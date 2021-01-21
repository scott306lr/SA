ps -p $1 -o user,pid,ppid,stat,%cpu,%mem,command | tail -n +2 |
awk '{
    print "USER: "$1;
    print "PID: "$2;
    print "PPID: "$3;
    print "STAT: "$4;
    print "%CPU: "$5;
    print "%MEM: "$6;
    print "COMMAND: "$7;
}'
