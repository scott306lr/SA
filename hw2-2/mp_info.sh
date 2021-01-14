df -ahTt nfs,zfs | tail -n +2 |
awk '{printf("%s %s ",$1,$7)}'
