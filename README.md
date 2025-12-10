# 📌 Pi-hole + Unbound Automated Maintenance Script

This script performs weekly automated maintenance for a Raspberry Pi running Pi-hole + Unbound.
It handles updates, backups, cleanup, and email reports — fully unattended.


# ✨ Features:

🔄 Updates OS packages
🟩 Updates Pi-hole (gravity + core)
🔁 Restarts Unbound
📦 Creates Pi-hole Teleporter backups
📁 Backs up Unbound configs
🧹 Rotates backups (keeps last 6)
📧 Emails full maintenance report
👌 Safe to run via cron


# 📂 File Locations
# Item	           Path
Script	          /home/pi/pihole_maintenance_full.sh
Pi-hole backups	  /home/pi/pihole_backups/
Unbound backups	  /home/pi/unbound_backups/
Logs	            /home/pi/pihole_maintenance_*.log


# 🛠️ Installation
1. Create the script
```
sudo nano /home/pi/pihole_maintenance_full.sh
```
