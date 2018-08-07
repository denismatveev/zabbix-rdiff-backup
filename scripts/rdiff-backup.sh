#!/bin/bash
BACKUPDIR="/backups"
umask=0022
print_help()
{
  echo -e "Usage: rdiff-backup.sh - without arguments script is discovering rdiff-backups"
  echo -e "Usage: rdiff-backup.sh -d dirname [OPTION]"
  echo -e "\t-d specifies path to dir with rdiff-backup"
  echo -e "OPTIONS are:"
  echo -e "\t-s prints size in bytes of rdiff-backup"
  echo -e "\t-t prints duration of the last backup"
  echo -e "\t-c prints growth size in bytes of the last backup"
  echo -e "\t-r prints start time of backup"
  echo -e "\t-g prints timestamp when the last backup was started"
}


if [ $# -eq 0 ];then
  find ${BACKUPDIR}  -maxdepth 3 -type d ! -readable -prune -o -name rdiff-backup-data -exec dirname {} \; | awk 'BEGIN{printf "{\"data\":["}; {i=split($1,path,"/"); printf c"{\"{#PATH}\":\""$1"\", \"{#HOST}\":\"" path[i-1] "\", \"{#DIR}\":\"" path[i] "\"}";c="," };  END{print "]}"}'
fi

while getopts "d:stcrgh" opt
do
  case ${opt} in
  d) DIR=${OPTARG}
  ;;
  s) grep SourceFileSize ${DIR}/rdiff-backup-data/session_statistics.$(basename $(ls ${DIR}/rdiff-backup-data/current_mirror.*.data) | cut -d "." -f2).data | cut -d " " -f2
  break
  ;;
  t) grep ElapsedTime ${DIR}/rdiff-backup-data/session_statistics.$(basename $(ls ${DIR}/rdiff-backup-data/current_mirror.*.data) | cut -d "." -f2).data | cut -d " " -f2 | xargs printf %.0f
 break
  ;;
  c) grep TotalDestinationSizeChange  ${DIR}/rdiff-backup-data/session_statistics.$(basename $(ls ${DIR}/rdiff-backup-data/current_mirror.*.data) | cut -d "." -f2).data | cut -d " " -f2
  break
  ;;
  r) grep StartTime ${DIR}/rdiff-backup-data/session_statistics.$(basename $(ls ${DIR}/rdiff-backup-data/current_mirror.*.data) | cut -d "." -f2).data | cut -d " " -f2 | xargs printf %.0f
  break;
  ;;
  g) grep StartTime ${DIR}/rdiff-backup-data/session_statistics.$(basename $(ls ${DIR}/rdiff-backup-data/current_mirror.*.data) | cut -d "." -f2).data | sed 's/^.*(//;s/)$//'
  break
  ;; 
  h) print_help
  exit 0
  ;;
  *) echo "Invalid option found!"; print_help
  exit 1;
  ;;
  esac
done






