Zabbix template for monitoring rdiff-backup repositories. This version is implemented in Bash only, no need to install myriad of Perl or Python scripts. Original taken from https://github.com/theranger/zabbix-rdiff-backup


# Installation
1. Copy `zabbix_agentd.d/userparameter_rdiff_backup.conf` to the Zabbix agent's configuration directory (usually located in `/etc/zabbix/`).
2. Copy `scripts/rdiff-backup.sh` to the directory where scripts are located.
3. Import template configuration `templates/rdiff-backup.xml` to Zabbix web frontend.

# Notes
For successfully run add in sudo string like this:
`zabbix  ALL=(ALL)       NOPASSWD: /etc/zabbix/scripts/rdiff-backup.sh`
# Restart the agent
`systemctl restart zabbix-zagent`
