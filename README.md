Zabbix template for monitoring rdiff-backup repositories. This version is implemented in Bash only, no need to install myriad of Perl or Python scripts. Unfortunately, there are some restrictions in this blue heaven. Read the notes below.


# Installation
1. Copy `zabbix_agentd.d/rdiff-backup.conf` to the Zabbix agent's configuration directory (usually located in `/etc`).
2. Import template configuration `templates/rdiff-backup.xml` to Zabbix web frontend.

# Notes
Because this plugin access `rdiff-backup` metadata directory directly, it fails doing that by default since `rdiff-backup` creates metadata files with least access bits (0700 / 0400) restricted to reading by owner only. In order for this plugin to succeed, either configure agent's commands in `rdiff-backup.conf` to be run as root (eg. via `sudo`) or:

1. Make all `rdiff-backup-data` metadata directories in all client backup locations group readable. This is one-time `chmod` only, it must be done for every backup location once, permissions will not be touched later on.
2. Add user `zabbix` to the groups of each backup client SSH account so that `zabbix` user is allowed to read contents of the directories mentioned in the first step.
3. Since `rdiff-backup` creates new statistics files on each run (and with owner-only access) something like this must be run periodically (e.g. via `crontab`; adapt the first argument of `find` to your actual backup location):
```
        0  *    * * *   root    find /home -maxdepth 4 -name session_statistics.*.data -exec chmod g+r {} \;
```
