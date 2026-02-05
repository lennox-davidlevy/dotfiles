# add an env to the directory you are currently in
function addenv() {
  local dirpath="$(pwd)"
  local varname

  if grep -Fq "'$dirpath'" ~/.env_directories 2>/dev/null; then
    echo "The directory '$dirpath' is already associated with a variable in .env_directories."
    grep "'$dirpath'" ~/.env_directories
    return 1
  fi

  read "varname?Enter variable name: "

  if grep -Eq "^export $varname=" ~/.env_directories 2>/dev/null; then
    echo "The variable name '$varname' is already used in .env_directories."
    grep "^export $varname=" ~/.env_directories
    read -q "overwrite?Do you want to overwrite it? (y/n): "
    echo
    if [[ ! $overwrite =~ ^[Yy]$ ]]; then
      echo "Operation cancelled."
      return 1
    else
      sed -i.bak "/^export $varname=/d" ~/.env_directories
      echo "Previous entry for '$varname' removed."
    fi
  fi

  echo "export $varname='$dirpath'" >>~/.env_directories
  source ~/.env_directories
  echo "Added and sourced: export $varname='$dirpath'"
}

# function to create a new pyenv virtual environment
function vmake {
  if [ -z "$1" ]; then
    echo "Usage: create_pyenv_virtualenv <env_name> [python_version]"
    return 1
  fi

  local env_name=$1
  local python_version=${2:-$(pyenv global)}

  if pyenv versions --bare | grep -q "^${env_name}$"; then
    echo "Virtual environment '${env_name}' already exists."
    return 1
  fi

  pyenv virtualenv ${python_version} ${env_name}

  if [ $? -eq 0 ]; then
    echo "Virtual environment '${env_name}' created successfully."
  else
    echo "Failed to create virtual environment '${env_name}'."
    return 1
  fi
}

# Function to delete a pyenv virtual environment
function vdel {
  if [ -z "$1" ]; then
    echo "Usage: venv_del <env_name>"
    return 1
  fi

  local env_name=$1

  if ! pyenv versions --bare | grep -q "^${env_name}$"; then
    echo "Environment '${env_name}' does not exist."
    return 1
  fi

  pyenv uninstall -f ${env_name}

  if [ $? -eq 0 ]; then
    echo "Environment '${env_name}' deleted successfully."
  else
    echo "Failed to delete environment '${env_name}'."
    return 1
  fi
}

# Function to list all pyenv virtual environments
function vlist {
  pyenv virtualenvs
}

function vstart {
  if [ -z "$1" ]; then
    echo "Usage: vstart <env_name>"
    return 1
  fi
  local env_name=$1

  # Activate the environment
  init_pyenv_virtualenv
  pyenv activate "$env_name"

  # Check if activation was successful
  if [ $? -eq 0 ]; then
    echo "Activated environment '$env_name'. Restarting shell..."
    exec $SHELL
  else
    echo "Failed to activate environment '$env_name'."
    return 1
  fi
}

# Function to deactivate current virtual environment
function vstop {
  pyenv deactivate
}

# Function to initialize pyenv virtualenv when needed
function init_pyenv_virtualenv {
  if [ -z "$PYENV_VIRTUALENV_INIT" ]; then
    eval "$(pyenv virtualenv-init -)"
    export PYENV_VIRTUALENV_INIT=1
  fi
}

# SSH nonsense
ssh() {
  if [[ -n "$TMUX" ]]; then
    # tmux select-pane -P 'bg=#054ADA,fg=white'
    # tmux select-pane -P 'bg=black,fg=green'
    tmux select-pane -P 'bg=black,fg=colour46'
    command ssh "$@"
    tmux select-pane -P 'bg=default,fg=default'
  else
    command ssh "$@"
  fi
}

# Copy public url to clipboard after starting ngrok
ngrokpb() {
  (
    sleep 2
    curl -s http://127.0.0.1:4040/api/tunnels |
      jq -r '.tunnels[0].public_url' |
      tr -d '\n' |
      pbcopy
    echo "Copied: $(pbpaste)"
  ) &

  ngrok http "${1:-8000}"
}

# Open remote repo from cli
remote-open() {
  local remote=${1:-origin}

  local url=$(git remote get-url "$remote" 2>/dev/null)

  if [[ -z "$url" ]]; then
    echo "Error: Remote '$remote' not found"
    echo "Available remotes:"
    git remote -v
    return 1
  fi

  if [[ "$url" =~ ^git@(.+):(.+)\.git$ ]]; then
    url="https://${match[1]}/${match[2]}"
  elif [[ "$url" =~ ^git@(.+):(.+)$ ]]; then
    url="https://${match[1]}/${match[2]}"
  fi

  url=${url%.git}

  echo "Opening: $url"
  open "$url" # macOS
  # Use 'xdg-open "$url"' for Linux
}

remote-copy() {
  local remote=${1:-origin}
  local use_ssh=${2:-false}
  local url
  local original_url

  url=$(git remote get-url "$remote" 2>/dev/null) || {
    echo "Error: Remote '$remote' not found" >&2
    echo "Available remotes:" >&2
    git remote -v
    return 1
  }

  original_url="$url"

  if [[ $use_ssh == "true" ]]; then
    if [[ $url =~ ^https://([^/]+)/(.+)\.git$ ]]; then
      url="git@${match[1]}:${match[2]}.git"
    elif [[ $url =~ ^https://([^/]+)/(.+)$ ]]; then
      url="git@${match[1]}:${match[2]}"
    fi
  else
    if [[ $url =~ ^git@([^:]+):(.+)\.git$ ]]; then
      url="https://${match[1]}/${match[2]}.git"
    fi
  fi

  echo "Copying: $url"
  printf '%s' "$url" | pbcopy
}

# Open remote repo from cli
fast-docs() {
  PORT="${1:-${FASTAPI_PORT:-8000}}"
  URL="http://127.0.0.1:${PORT}/docs"
  open "$URL"
}

# File preview with fzf and bat
fp() {
  local file
  if [[ $# -eq 0 ]]; then
    file=$(find . -type f | fzf --preview 'bat --color=always {}')
  else
    file=$(find . -name "*$1*" -type f | fzf --preview 'bat --color=always {}')
  fi
  
  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}

# Start colima with settings for orchestrate
function colima-orchestrate() {
  echo "Starting Colima with optimized settings for orchestrate..."
  colima start --cpu-type host --arch host --vm-type=vz --mount-type virtiofs -c 8 -m 16 "$@"
}

# Create a new project with standard directory structure
function newproject {
  if [ -z "$1" ]; then
    echo "Usage: newproject <project_name>"
    return 1
  fi

  local project_name=$1
  local project_path="./${project_name}"

  if [ -d "$project_path" ]; then
    echo "Error: Project '${project_name}' already exists at ${project_path}"
    return 1
  fi

  echo "Creating project '${project_name}'..."
  mkdir -p "${project_path}"/{notes,videos,docs,presentations,projects}

  if [ $? -eq 0 ]; then
    echo "Project '${project_name}' created successfully!"
    echo "  ${project_path}/notes/"
    echo "  ${project_path}/videos/"
    echo "  ${project_path}/docs/"
    echo "  ${project_path}/presentations/"
    echo "  ${project_path}/projects/"
    echo ""
    echo "To navigate: cd ${project_name}"
  else
    echo "Failed to create project '${project_name}'."
    return 1
  fi
}

# Sign in and set secret environment values
function sign-in() {
  if command -v op &> /dev/null; then
    export BOBSHELL_API_KEY=$(op read "op://Private/Project Bob API key/credential" 2>/dev/null)
    echo "Signed in and BOBSHELL_API_KEY set."
    export TEST_API_KEY="hello"
    echo "Signed in and TEST_API_KEY set."
  else
    echo "op command not found."
  fi
}

# IBM ATL Customer Workspace Management

# Initialize a new ATL customer workspace with complete folder structure
function atl-init() {
  if [ -z "$1" ]; then
    echo "Usage: atl-init <customer_name>"
    echo "Example: atl-init goldman_sachs"
    return 1
  fi

  local customer_name=$1
  local workspace_path="./${customer_name}"

  if [ -d "$workspace_path" ]; then
    echo "Error: Customer workspace '${customer_name}' already exists at ${workspace_path}"
    return 1
  fi

  echo "Creating ATL workspace for '${customer_name}'..."

  # Create main directory structure
  mkdir -p "${workspace_path}/ibm"/{products,playbooks,enablement,assets}
  mkdir -p "${workspace_path}/customer"/{org,initiatives,tech_stack,processes,contracts}
  mkdir -p "${workspace_path}/active/template-project"/{notes,videos,docs,presentations,projects}
  mkdir -p "${workspace_path}/meetings"/{2025_Q1,2025_Q2,2025_Q3,2025_Q4}
  mkdir -p "${workspace_path}/opportunities"
  mkdir -p "${workspace_path}/archive"

  # Create .gitkeep files for empty directories
  touch "${workspace_path}/ibm/products/.gitkeep"
  touch "${workspace_path}/ibm/playbooks/.gitkeep"
  touch "${workspace_path}/ibm/enablement/.gitkeep"
  touch "${workspace_path}/ibm/assets/.gitkeep"
  touch "${workspace_path}/meetings/2025_Q1/.gitkeep"
  touch "${workspace_path}/meetings/2025_Q2/.gitkeep"
  touch "${workspace_path}/meetings/2025_Q3/.gitkeep"
  touch "${workspace_path}/meetings/2025_Q4/.gitkeep"
  touch "${workspace_path}/archive/.gitkeep"

  # Create customer/org/contacts.md with template
  cat > "${workspace_path}/customer/org/contacts.md" << 'EOF'
# Contacts

## Key Contacts

### Technical Contacts
- **Name**: 
  - Role: 
  - Email: 
  - Phone: 

### Business Contacts
- **Name**: 
  - Role: 
  - Email: 
  - Phone: 

## Notes
- Add important contact information and communication preferences
EOF

  # Create customer/org/stakeholders.md with template
  cat > "${workspace_path}/customer/org/stakeholders.md" << 'EOF'
# Stakeholders

## Executive Stakeholders
- **Name**: 
  - Title: 
  - Influence Level: 
  - Key Interests: 

## Technical Stakeholders
- **Name**: 
  - Title: 
  - Influence Level: 
  - Key Interests: 

## Business Stakeholders
- **Name**: 
  - Title: 
  - Influence Level: 
  - Key Interests: 
EOF

  # Create customer/initiatives/strategic_priorities.md with template
  cat > "${workspace_path}/customer/initiatives/strategic_priorities.md" << 'EOF'
# Strategic Priorities

## Current Initiatives

### Initiative 1
- **Description**: 
- **Timeline**: 
- **Budget**: 
- **Key Stakeholders**: 
- **IBM Relevance**: 

### Initiative 2
- **Description**: 
- **Timeline**: 
- **Budget**: 
- **Key Stakeholders**: 
- **IBM Relevance**: 

## Future Priorities
- 
EOF

  # Create customer/tech_stack/current_state.md with template
  cat > "${workspace_path}/customer/tech_stack/current_state.md" << 'EOF'
# Current Technology Stack

## Infrastructure
- **Cloud Provider**: 
- **On-Premise**: 
- **Hybrid**: 

## Key Technologies
- **Databases**: 
- **Application Servers**: 
- **Development Tools**: 
- **Security Tools**: 

## IBM Products in Use
- 

## Pain Points
- 
EOF

  # Create opportunities/pipeline.md with template
  cat > "${workspace_path}/opportunities/pipeline.md" << 'EOF'
# Opportunities Pipeline

## Active Opportunities

### Opportunity 1
- **Name**: 
- **Value**: 
- **Stage**: 
- **Expected Close**: 
- **Products**: 
- **Next Steps**: 

## Future Opportunities
- 
EOF

  # Create opportunities/rfps.md with template
  cat > "${workspace_path}/opportunities/rfps.md" << 'EOF'
# RFPs and Proposals

## Active RFPs

### RFP 1
- **Title**: 
- **Due Date**: 
- **Estimated Value**: 
- **Status**: 
- **Requirements**: 
- **Our Approach**: 

## Submitted Proposals
- 
EOF

  # Create root README.md
  cat > "${workspace_path}/README.md" << EOF
# ${customer_name} - ATL Customer Workspace

## Directory Structure

\`\`\`
${customer_name}/
├── ibm/                  # IBM-specific materials
│   ├── products/         # Product research, positioning, battlecards
│   ├── playbooks/        # Standard pitches, objection handling
│   ├── enablement/       # Training, certifications
│   └── assets/           # Logos, templates
├── customer/             # Customer-specific information
│   ├── org/              # Contacts, stakeholders, org charts
│   ├── initiatives/      # Strategic programs, priorities
│   ├── tech_stack/       # Architecture, systems, technologies
│   ├── processes/        # Buying process, procurement
│   └── contracts/        # Current agreements, SOWs
├── active/               # Active projects (use atl-new to create)
│   └── template-project/ # Template folder structure
├── meetings/             # Meeting notes organized by quarter
│   ├── 2025_Q1/
│   ├── 2025_Q2/
│   ├── 2025_Q3/
│   └── 2025_Q4/
├── opportunities/        # Pipeline, RFPs, proposals
└── archive/              # Completed work
\`\`\`

## Quick Start

### Create a new project
From this directory, run:
\`\`\`bash
atl-new <project_name>
\`\`\`

This creates a new project in the \`active/\` folder with standard structure.

## Usage

- Store IBM product materials in \`ibm/\`
- Document customer information in \`customer/\`
- Create active projects with \`atl-new\`
- Organize meetings by quarter in \`meetings/\`
- Track opportunities and RFPs in \`opportunities/\`
- Archive completed work in \`archive/\`
EOF

  if [ $? -eq 0 ]; then
    echo "✓ ATL workspace '${customer_name}' created successfully!"
    echo ""
    echo "Structure created:"
    echo "  ${workspace_path}/ibm/            # IBM materials"
    echo "  ${workspace_path}/customer/       # Customer info"
    echo "  ${workspace_path}/active/         # Active projects"
    echo "  ${workspace_path}/meetings/       # Meeting notes"
    echo "  ${workspace_path}/opportunities/  # Pipeline & RFPs"
    echo "  ${workspace_path}/archive/        # Completed work"
    echo ""
    echo "Next steps:"
    echo "  cd ${customer_name}"
    echo "  atl-new <project_name>  # Create a new project"
  else
    echo "Failed to create ATL workspace '${customer_name}'."
    return 1
  fi
}

# Create a new project within an ATL workspace
function atl-new() {
  # Validate we're in an ATL workspace
  if [ ! -d "./active" ] || [ ! -d "./ibm" ] || [ ! -d "./customer" ]; then
    echo "Error: Not in an ATL workspace directory."
    echo "This command must be run from the root of an ATL customer workspace."
    echo "Expected folders: ./active, ./ibm, ./customer"
    echo ""
    echo "To create a new workspace, use: atl-init <customer_name>"
    return 1
  fi

  if [ -z "$1" ]; then
    echo "Usage: atl-new <project_name>"
    echo "Example: atl-new watsonx_pilot"
    return 1
  fi

  local project_name=$1
  local project_path="./active/${project_name}"

  if [ -d "$project_path" ]; then
    echo "Error: Project '${project_name}' already exists at ${project_path}"
    return 1
  fi

  echo "Creating ATL project '${project_name}'..."

  # Create project directory structure
  mkdir -p "${project_path}"/{notes,videos,docs,presentations,projects}

  # Create project README
  cat > "${project_path}/README.md" << EOF
# ${project_name}

## Project Overview
Brief description of this project.

## Directory Structure
- \`notes/\` - Meeting notes, research, brainstorming
- \`videos/\` - Recorded demos, presentations, training
- \`docs/\` - Documentation, specifications, requirements
- \`presentations/\` - Slide decks, pitch materials
- \`projects/\` - Code, configurations, technical deliverables

## Status
- [ ] Initiated
- [ ] Planning
- [ ] In Progress
- [ ] Review
- [ ] Completed

## Key Information
- **Start Date**: 
- **Target Completion**: 
- **Stakeholders**: 
- **Objectives**: 
EOF

  if [ $? -eq 0 ]; then
    echo "✓ Project '${project_name}' created successfully!"
    echo ""
    echo "Project structure:"
    echo "  ${project_path}/notes/"
    echo "  ${project_path}/videos/"
    echo "  ${project_path}/docs/"
    echo "  ${project_path}/presentations/"
    echo "  ${project_path}/projects/"
    echo ""
    echo "To navigate: cd active/${project_name}"
  else
    echo "Failed to create project '${project_name}'."
    return 1
  fi
}

# Aliases for ATL functions
alias atli='atl-init'
alias atln='atl-new'
