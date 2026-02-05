# ATL Customer Workspace Guide

## Overview

This guide explains how to use the ATL (Account Technical Leader) workspace functions to organize your customer engagement work at IBM. The workspace provides a structured approach to managing customer relationships, technical activities, and sales opportunities.

## Quick Start

### Creating a New Customer Workspace

```bash
# Navigate to where you keep customer folders
cd ~/Business/customers

# Create a new customer workspace
atl-init <customer_name>

# Example:
atl-init goldman_sachs
```

This creates a complete folder structure for managing all aspects of your customer engagement.

### Creating Projects Within a Workspace

```bash
# Navigate to the customer workspace root
cd ~/Business/customers/goldman_sachs

# Create a new active project
atl-new <project_name>

# Examples:
atl-new watsonx_pilot
atl-new infrastructure_assessment
atl-new ai_governance_workshop
```

## Directory Structure Explained

```
customer_name/
├── ibm/                  # IBM-specific materials and resources
├── customer/             # Customer intelligence and information
├── active/               # Current projects you're working on
├── meetings/             # Meeting notes organized by quarter
├── opportunities/        # Sales pipeline and RFPs
└── archive/              # Completed work
```

## What Goes in Each Directory

### 📘 `ibm/` - IBM Materials and Resources

Store IBM-provided materials, internal resources, and company assets related to this customer.

#### `ibm/products/`
**What to put here:**
- Product datasheets and specifications
- Technical architecture diagrams
- Product roadmaps and release notes
- Competitive battlecards
- Pricing guides and SKU information
- Product demo scripts
- Technical whitepapers

**Example files:**
- `watsonx_datasheet.pdf`
- `instana_architecture.pdf`
- `apptio_vs_competitors.md`
- `redhat_openshift_pricing_2025.xlsx`

#### `ibm/playbooks/`
**What to put here:**
- Standard pitch decks
- Objection handling guides
- Solution architectures for common use cases
- Reference architectures
- Implementation methodologies
- Best practices documentation

**Example files:**
- `ai_modernization_pitch.pptx`
- `cloud_migration_playbook.md`
- `security_objections.md`
- `financial_services_architecture.pdf`

#### `ibm/enablement/`
**What to put here:**
- Internal training materials
- Certification paths and study guides
- Technical enablement sessions
- Partner enablement content
- Sales enablement resources
- Product training recordings

**Example files:**
- `watsonx_technical_training.mp4`
- `apptio_sales_certification.pdf`
- `security_specialist_path.md`

#### `ibm/assets/`
**What to put here:**
- IBM logos and brand assets
- Presentation templates
- Email templates
- Proposal templates
- Standard contract templates
- Marketing collateral

**Example files:**
- `ibm_logo_suite.zip`
- `proposal_template.pptx`
- `sow_template.docx`
- `executive_brief_template.pdf`

---

### 🏢 `customer/` - Customer Intelligence

Store everything you learn about the customer's organization, technology, and business.

#### `customer/org/`
**What to put here:**
- Contact information for key people
- Organizational charts
- Stakeholder maps and influence diagrams
- Decision-maker profiles
- Team structures
- Communication preferences

**Template files created:**
- `contacts.md` - Name, role, email, phone for all contacts
- `stakeholders.md` - Executive, technical, and business stakeholders with influence levels

**Example additions:**
- `org_chart.pdf`
- `it_leadership_structure.md`
- `procurement_team.md`
- `executive_bios.md`

#### `customer/initiatives/`
**What to put here:**
- Strategic business initiatives
- Digital transformation programs
- Modernization roadmaps
- Business priorities and goals
- Key performance indicators (KPIs)
- Budget cycles and timelines

**Template files created:**
- `strategic_priorities.md` - Current and future initiatives

**Example additions:**
- `digital_transformation_roadmap.pdf`
- `2025_it_budget.md`
- `cloud_first_strategy.md`
- `ai_adoption_plan.md`

#### `customer/tech_stack/`
**What to put here:**
- Current technology inventory
- Architecture diagrams
- Network diagrams
- Application portfolio
- Infrastructure details
- Security tools and policies
- Integration points

**Template files created:**
- `current_state.md` - Infrastructure, key technologies, pain points

**Example additions:**
- `application_landscape.xlsx`
- `aws_infrastructure_diagram.pdf`
- `data_architecture.md`
- `security_stack.md`
- `integration_map.pdf`

#### `customer/processes/`
**What to put here:**
- Procurement process documentation
- Approval workflows
- Vendor management policies
- Budget approval process
- Security review requirements
- Legal review process
- Implementation methodologies they use

**Example files:**
- `procurement_workflow.md`
- `vendor_approval_checklist.md`
- `security_review_requirements.pdf`
- `change_management_process.md`

#### `customer/contracts/`
**What to put here:**
- Current IBM agreements
- Master Service Agreements (MSAs)
- Statements of Work (SOWs)
- Contract renewal dates
- Licensing agreements
- Support contracts
- Partner agreements

**Example files:**
- `msa_2024.pdf`
- `watsonx_license_agreement.pdf`
- `support_contract_details.md`
- `contract_renewal_dates.md`

---

### 🚀 `active/` - Current Projects

Create a separate folder for each active engagement, assessment, pilot, or project you're working on.

#### How to Create Projects
```bash
# From customer workspace root
atl-new <project_name>
```

#### Project Structure
Each project gets:
```
project_name/
├── notes/            # Meeting notes, research, brainstorming
├── videos/           # Recorded demos, presentations
├── docs/             # Requirements, specs, documentation
├── presentations/    # Pitch decks, executive briefings
├── projects/         # Code, configs, technical deliverables
└── README.md         # Project overview and status
```

#### `notes/`
**What to put here:**
- Daily work notes
- Research findings
- Brainstorming sessions
- Technical discovery notes
- Interview transcripts
- Requirements gathering notes

**Example files:**
- `discovery_call_2025-02-05.md`
- `technical_requirements.md`
- `pain_points_analysis.md`
- `competitor_research.md`

#### `videos/`
**What to put here:**
- Recorded product demos
- Training session recordings
- Customer presentations
- Architecture walkthroughs
- POC demonstrations
- Screen recordings

**Example files:**
- `watsonx_demo_for_cto.mp4`
- `architecture_walkthrough.mp4`
- `pilot_results_presentation.mp4`

#### `docs/`
**What to put here:**
- Technical specifications
- Requirements documents
- Architecture designs
- Implementation plans
- Test plans
- User guides
- API documentation

**Example files:**
- `technical_requirements_doc.pdf`
- `solution_architecture.pdf`
- `implementation_plan.md`
- `test_cases.xlsx`
- `user_guide.pdf`

#### `presentations/`
**What to put here:**
- Executive briefings
- Technical deep dives
- Pilot results presentations
- Business case presentations
- ROI analyses
- Proposal presentations

**Example files:**
- `executive_briefing.pptx`
- `technical_architecture_review.pdf`
- `pilot_results_q1_2025.pptx`
- `business_case_watsonx.pdf`

#### `projects/`
**What to put here:**
- Source code for POCs
- Configuration files
- Scripts and automation
- Terraform/Ansible playbooks
- Docker configurations
- Kubernetes manifests
- Technical deliverables

**Example files:**
- `poc-watsonx-integration/` (code repository)
- `deployment-scripts/`
- `terraform-configs/`
- `api-integration-examples/`

---

### 📅 `meetings/` - Meeting Notes by Quarter

Organize all meeting notes chronologically by quarter.

**Structure:**
```
meetings/
├── 2025_Q1/
├── 2025_Q2/
├── 2025_Q3/
└── 2025_Q4/
```

**What to put here:**
- Customer meeting notes
- Internal team meeting notes
- Executive briefing summaries
- Technical review sessions
- Status update meetings
- Steering committee meetings

**Naming convention:**
- `2025-02-05_executive_briefing.md`
- `2025-02-10_technical_discovery.md`
- `2025-02-15_weekly_sync.md`

**Meeting note template:**
```markdown
# Meeting Title - Date

**Attendees:**
- From Customer: Name (Title)
- From IBM: Name (Title)

**Agenda:**
1. Topic 1
2. Topic 2

**Discussion:**
- Key point discussed
- Decisions made
- Technical details

**Action Items:**
- [ ] Action 1 - Owner - Due Date
- [ ] Action 2 - Owner - Due Date

**Next Steps:**
- Schedule follow-up
- Prepare materials
```

---

### 💼 `opportunities/` - Sales Pipeline

Track sales opportunities, pipeline, and RFPs.

**Template files created:**
- `pipeline.md` - Active opportunities with stage, value, expected close
- `rfps.md` - Active RFPs and proposals

**What to put here:**
- Opportunity briefs
- Competitive analysis
- Win/loss analysis
- Proposal drafts
- RFP responses
- Pricing quotes
- SOW drafts

**Example files:**
- `q1_2025_opportunities.md`
- `watsonx_enterprise_rfp_response.pdf`
- `competitive_analysis_aws.md`
- `pricing_proposal_instana.xlsx`
- `win_strategy_infrastructure.md`

---

### 📦 `archive/` - Completed Work

Move completed projects and outdated materials here to keep your workspace clean.

**What to put here:**
- Completed projects from `active/`
- Outdated customer information
- Old meeting notes (previous years)
- Completed opportunities (won or lost)
- Historical contracts
- Deprecated technical information

**Organization suggestion:**
```
archive/
├── projects/
│   ├── 2024_watsonx_pilot/
│   └── 2023_cloud_migration/
├── opportunities/
│   ├── 2024_lost_deals/
│   └── 2024_won_deals/
└── old_meetings/
    ├── 2024_Q4/
    └── 2024_Q3/
```

---

## Workflow Examples

### Example 1: New Customer Engagement

```bash
# 1. Create customer workspace
cd ~/Business/customers
atl-init acme_corp

# 2. Navigate into workspace
cd acme_corp

# 3. Fill in initial customer information
nvim customer/org/contacts.md
nvim customer/tech_stack/current_state.md

# 4. Create your first project
atl-new initial_discovery

# 5. Start working
cd active/initial_discovery
nvim notes/discovery_call_notes.md
```

### Example 2: Starting a New Technical Project

```bash
# From customer workspace root
cd ~/Business/customers/goldman_sachs

# Create new project
atl-new watsonx_poc

# Navigate to project
cd active/watsonx_poc

# Create initial documentation
nvim docs/requirements.md
nvim docs/architecture.md

# Update project README with status
nvim README.md

# Create project code structure
mkdir -p projects/watsonx-integration
cd projects/watsonx-integration
git init
```

### Example 3: Preparing for Executive Meeting

```bash
# Navigate to customer workspace
cd ~/Business/customers/goldman_sachs

# Review customer intelligence
cat customer/org/stakeholders.md
cat customer/initiatives/strategic_priorities.md

# Get IBM materials
ls ibm/playbooks/
cp ibm/playbooks/ai_strategy_deck.pptx meetings/2025_Q1/

# Create meeting prep notes
nvim meetings/2025_Q1/2025-02-15_cto_briefing_prep.md

# After meeting, capture notes
nvim meetings/2025_Q1/2025-02-15_cto_briefing_notes.md
```

### Example 4: Responding to RFP

```bash
# Navigate to customer workspace
cd ~/Business/customers/acme_corp

# Create RFP project
atl-new cloud_modernization_rfp

# Navigate to project
cd active/cloud_modernization_rfp

# Organize RFP response
mkdir -p docs/rfp_sections
nvim docs/rfp_sections/technical_approach.md
nvim docs/rfp_sections/pricing.md
nvim docs/rfp_sections/timeline.md

# Track in opportunities
cd ../..
nvim opportunities/rfps.md

# Create final proposal presentation
nvim active/cloud_modernization_rfp/presentations/final_proposal.md
```

### Example 5: Archiving Completed Work

```bash
# Navigate to customer workspace
cd ~/Business/customers/goldman_sachs

# Create archive structure
mkdir -p archive/projects/2024

# Move completed project
mv active/watsonx_pilot archive/projects/2024/

# Archive old meetings
mkdir -p archive/old_meetings
mv meetings/2024_Q* archive/old_meetings/

# Document what was archived
echo "Archived watsonx pilot - completed Q4 2024" >> archive/README.md
```

---

## Best Practices

### 1. Keep Customer Intelligence Updated
- Update `contacts.md` immediately after meeting new people
- Refresh `tech_stack/current_state.md` after discovery sessions
- Document strategic priorities as you learn them

### 2. Use Consistent Naming
- **Dates**: Use ISO format `YYYY-MM-DD` (e.g., `2025-02-05_meeting.md`)
- **Projects**: Use lowercase with underscores (e.g., `watsonx_pilot`)
- **Files**: Descriptive names with underscores (e.g., `technical_requirements.md`)

### 3. Document as You Go
- Take meeting notes in real-time
- Update project READMEs with status changes
- Document decisions and rationale

### 4. Regular Cleanup
- Archive completed projects quarterly
- Remove outdated materials
- Update contact information as roles change

### 5. Leverage Templates
- Use the template files created by `atl-init`
- Create your own templates for common documents
- Keep frequently used IBM materials in `ibm/assets/`

### 6. Protect Sensitive Information
- Add `.gitignore` if using git
- Never commit customer confidential data to public repos
- Follow IBM and customer data handling policies
- Use encryption for sensitive documents

### 7. Collaborate Effectively
- Share workspace structure with team members
- Use consistent organization across customers
- Document your process in project READMEs

---

## Tips and Tricks

### Use Aliases
The functions have convenient aliases:
- `atli` = `atl-init` (Create new customer workspace)
- `atln` = `atl-new` (Create new project)

### Quick Navigation with Environment Variables
Add customer workspaces to your environment:
```bash
# From customer workspace root
addenv
# Enter variable name: GS (for Goldman Sachs)

# Now you can quickly navigate:
cd $GS
```

### Search Across Workspace
```bash
# Find all mentions of "watsonx"
grep -r "watsonx" .

# Find specific file types
find . -name "*.pdf"

# Search meeting notes only
grep -r "action items" meetings/
```

### Quick Project Status
```bash
# See all active projects
ls active/

# Check project status
cat active/*/README.md | grep "Status" -A 5
```

### Sync with Cloud Storage
Consider syncing customer workspaces with cloud storage:
```bash
# Example with cloud storage
ln -s ~/Business/customers ~/Library/CloudStorage/OneDrive-IBM/customers
```

---

## Troubleshooting

### "Not in an ATL workspace directory" error
**Problem**: Running `atl-new` outside a workspace

**Solution**: Navigate to the customer workspace root (where `active/`, `ibm/`, and `customer/` folders exist)
```bash
cd ~/Business/customers/customer_name
atl-new project_name
```

### Functions not found
**Problem**: `atl-init` or `atl-new` command not recognized

**Solution**: Source your zsh configuration
```bash
source ~/.zshrc
```

### Directory already exists
**Problem**: Trying to create a workspace or project that already exists

**Solution**: Use a different name or remove the existing directory first
```bash
# List existing customers
ls ~/Business/customers

# List existing projects
ls active/
```

---

## Getting Help

### Function Usage
```bash
# Show usage for atl-init
atl-init

# Show usage for atl-new
atl-new
```

### View Function Definition
```bash
# See the function code
type atl-init
type atl-new
```

### Edit Functions
The functions are defined in:
```bash
nvim ~/.zsh_scripts/functions.zsh
```

---

## Customization Ideas

### Add More Templates
Edit the `atl-init` function to create additional starter files that match your workflow.

### Create Additional Functions
Consider adding:
- `atl-archive <project_name>` - Move project to archive
- `atl-status` - Show summary of all active projects
- `atl-meeting` - Create meeting note with template
- `atl-clone <customer_name>` - Duplicate structure from existing customer

### Integration with Other Tools
- Use with Obsidian for markdown notes
- Integrate with IBM tools and databases
- Sync with CRM systems
- Export to reporting tools

---

## Summary

The ATL workspace structure helps you:
- ✅ Stay organized across multiple customer engagements
- ✅ Quickly find customer information when needed
- ✅ Maintain consistent documentation practices
- ✅ Track active projects and opportunities
- ✅ Preserve institutional knowledge
- ✅ Onboard team members faster
- ✅ Present professionally to customers and IBM leadership

Start with one customer, build the habit, and expand from there. Good luck! 🚀
