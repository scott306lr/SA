last | tail -r | tail -n +2 | tail -r |
awk '{ cnt[$1]++; }
    END{ for (var in cnt) print cnt[var]" "var; }'| 
sort -rnk1 | head -n 5 |
awk 'BEGIN { 
        rank=0; 
        printf ("%-6s %-12s %-6s\n","Rank","Name","Times"); 
    }
    {   
        rank++;
        printf ("%-6s %-12s %-6s\n",rank,$2,$1);
    }'| column -t

