df -ahTt nfs,zfs $1 | tail -n +2 |
awk '
{
    print "Filesystem: "$1;
    print "Type: "$2;
    print "Size: "$3;
    print "Used: "$4;
    print "Avail: "$5;
    print "Capacity: "$6;
    print "Mounted_on: "$7;
}'
