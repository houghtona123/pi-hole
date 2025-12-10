#!/bin/bash
# ====================================================
# Pi-hole + Unbound Maintenance Script
# ====================================================

# Variables
TIMESTAMP=$(date +"%Y-%m-%d_%H%M")
HOME_DIR="/home/pi"
BACKUP_DIR="$HOME_DIR/pihole_backups"
UNBOUND_BACKUP_DIR="$HOME_DIR/unbound_backups"
LOG_FILE="$HOME_DIR/pihole_maintenance_$TIMESTAMP.log"
EMAIL="youremail@example.com"  # <-- change this

# Ensure backup directories exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$UNBOUND_BACKUP_DIR"

echo "=== Pi-hole Maintenance Started: $TIMESTAMP ===" > "$LOG_FILE"

# 1) Update OS
echo "[INFO] Updating system packages..." >> "$LOG_FILE"
apt update >> "$LOG_FILE" 2>&1
apt full-upgrade -y >> "$LOG_FILE" 2>&1

# 2) Update Pi-hole
echo "[INFO] Updating Pi-hole..." >> "$LOG_FILE"
pihole -up >> "$LOG_FILE" 2>&1

# 3) Restart Unbound
echo "[INFO] Restarting Unbound..." >> "$LOG_FILE"
systemctl restart unbound >> "$LOG_FILE" 2>&1

# 4) Backup Unbound
echo "[INFO] Backing up Unbound configs..." >> "$LOG_FILE"
cp -a /etc/unbound/unbound.conf.d "$UNBOUND_BACKUP_DIR/unbound_$TIMESTAMP" >> "$LOG_FILE" 2>&1

# 5) Pi-hole Teleporter backup
echo "[INFO] Creating Pi-hole Teleporter backup..." >> "$LOG_FILE"
pihole -a -t >> "$LOG_FILE" 2>&1
mv "$HOME_DIR"/pi-hole-teleporter_*.tar.gz "$BACKUP_DIR/pihole-backup-$TIMESTAMP.tar.gz" 2>/dev/null

# 6) Rotate old backups (keep last 6)
echo "[INFO] Cleaning old Pi-hole backups..." >> "$LOG_FILE"
if compgen -G "$BACKUP_DIR/*.tar.gz" > /dev/null; then
    ls -tp "$BACKUP_DIR"/*.tar.gz | tail -n +7 | xargs -r rm --
fi

echo "[INFO] Cleaning old Unbound backups..." >> "$LOG_FILE"
if compgen -G "$UNBOUND_BACKUP_DIR/*" > /dev/null; then
    ls -tp "$UNBOUND_BACKUP_DIR"/* | tail -n +7 | xargs -r rm -r --
fi

# 7) Email results
echo "[INFO] Sending email report..." >> "$LOG_FILE"
mail -s "Pi-hole Maintenance Report $TIMESTAMP" "$EMAIL" < "$LOG_FILE"

echo "=== Maintenance Completed: $(date +"%Y-%m-%d_%H%M") ===" >> "$LOG_FILE"
