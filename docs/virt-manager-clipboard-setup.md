# Virt-Manager Clipboard Setup Guide

## Enable Copy-Paste Between Fedora Host and VMs

This guide explains how to set up clipboard sharing between your Fedora host and virtual machines using virt-manager with SPICE.

## Prerequisites

- Fedora host system
- virt-manager installed
- Virtual machine running

## Step-by-Step Setup

### 1. Install SPICE Guest Tools in VM

**For Linux VMs:**
```bash
sudo dnf install spice-vdagent spice-webdavd
```

**For Windows VMs:**
- Download spice-guest-tools from [spice-space.org](https://www.spice-space.org/download.html)
- Run the installer in the Windows VM

### 2. Enable SPICE Services (Linux VMs only)

Start and enable the SPICE agent services:
```bash
sudo systemctl enable --now spice-vdagentd
sudo systemctl enable --now spice-vdagent
```

### 3. Configure VM Display Settings

1. Open virt-manager
2. Right-click your VM → **Open**
3. Go to **View** menu → **Details**
4. Click **Display Spice** in the left panel
5. Set **Type** to **Spice server**
6. Set **Listen type** to **Address**
7. Click **Apply**

### 4. Add Clipboard Channel

1. In VM details view, click **Add Hardware**
2. Select **Channel**
3. Set **Device Type** to **Spice agent (spicevmc)**
4. Click **Finish**

### 5. Restart and Test

1. **Reboot the VM** to apply all changes
2. Test clipboard functionality:
   - Copy text from host system (Ctrl+C)
   - Paste in VM (Ctrl+V)
   - Copy text from VM (Ctrl+C)  
   - Paste on host system (Ctrl+V)

## Troubleshooting

### If clipboard sharing doesn't work:

**Check SPICE agent status:**
```bash
systemctl status spice-vdagentd
systemctl status spice-vdagent
```

**Restart SPICE services:**
```bash
sudo systemctl restart spice-vdagent
sudo systemctl restart spice-vdagentd
```

**Verify VM settings:**
- Ensure VM uses SPICE display (not VNC)
- Confirm SPICE channel is present in VM hardware list
- Try logging out/in of desktop session in VM

**Alternative keyboard shortcuts:**
- In virt-manager VM window: View → Copy guest clipboard (Ctrl+Shift+C)
- View → Paste to guest clipboard (Ctrl+Shift+V)

## Notes

- Works with both Linux and Windows VMs
- SPICE provides better performance than VNC
- Clipboard sharing works bidirectionally once properly configured
- Some desktop environments may require a session restart after setup
