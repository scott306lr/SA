tail -n +10 | tail -r | tail -n +2 | tail -r | 
awk 'BEGIN {
        byWCPU=byRES="";
    }
    $11>0.5 {
        byWCPU = byWCPU "WW|" $1"|"$12"|"$2"|"$11"\n";
    }
    { 
        byRES = byRES "RR|" $1"|"$12"|"$2"|"$7"\n"; 
    }
    END {
        print byWCPU | "sort -k5 -t   \"|\" -r -n | head -n 5";
        print byRES  |  "head -n 5"; 
    }'| 
awk -F"|" 'BEGIN { sWCPU=sRES=name="" }
    (/^WW/) { sWCPU = sWCPU $2"|"$3"|"$4"|"$5"|\n"; }
    (/^RR/) { sRES  = sRES  $2"|"$3"|"$4"|"$5"|\n"; }
    (/^WW|^RR/){ cnt[$4]++; }
    END {
        printf("Top Five Processes of WCPU over 0.5\n\nPID|command|user|WCPU\n");
        print sWCPU;
        printf("Top Five Processes of RES\n\nPID|command|user|RES\n");
        print sRES;
        printf("Bad Users:\n\n");
        for (var in cnt){
            if (var=="root") 
                print "\033[0;32m"var"\033[0m";
            else if (cnt[var] == 1) 
                print "\033[0;33m"var"\033[0m";
            else 
                print "\033[0;31m"var"\033[0m";
        }
    }'|
awk -F"|" '{ printf("%-10s %-10s %-10s %-10s\n",$1,$2,$3,$4) }'

