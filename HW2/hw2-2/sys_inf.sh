echo "$1"
echo "This system report is generated on $(date)"
echo "================================================================="
sysctl -n kern.hostname kern.ostype kern.osrelease hw.machine hw.model hw.ncpu hw.physmem hw.usermem | tr -s "\n" "|" |
awk -F"|" '
    function human(x) {
        if (x<1024) {return x}
        else{
            x/=1024.0;
            s= "kMGT"
        }
        while (x>=1024 && length(s)>1){
            x/=1024.0;
            s=substr(s,2)
        }
        return int(x*100)/100" "substr(s,1,1)"B"

    }
    {
        print "Hostname: "$1;
        print "OS Rame: "$2;
        print "OS Release Version: "$3;
        print "OS Architecture: "$4;
        print "Processor Model: "$5;
        print "Number of Processor Cores: "$6;
        print "Total Physical Memory: "human($7);
        free_mem=int((1-($8/$7))*100);
        print "Free Memory (%): "free_mem;
    }'
users=$(who | sort -nk1 | rev | uniq -f 5 | rev | wc -l | tr -d " ") 
echo "Total logged in users: "$users
echo; echo; echo "The output file is saved to $2"
