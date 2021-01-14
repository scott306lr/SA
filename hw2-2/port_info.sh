sockstat -4 | tail -n +1 |
awk '{printf("%s %s_%s\n",$3,$5,$6) | "sort -rn" }' |
awk '{printf("%d %s ",$1,$2)}'
