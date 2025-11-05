#!/bin/bash

# Step 1: Aggregate votes per candidate per race and save to RAWdata.json
curl https://data.kingcounty.gov/resource/uuda-pmuy.json > data.json
awk -F'"' '
{
    race=""; candidate=""; count=0

    for(i=1;i<=NF;i++){
        if($i=="race") race=$(i+2)
        if($i=="countertype") candidate=$(i+2)
        if($i=="sumofcount"){
            val=$(i+2)
            gsub(/[^0-9]/,"",val)
            count=val+0
        }
    }

    key = race "," candidate
    votes[key] += count
    races[race] = 1
    race_candidate_keys[key] = 1
}
END {
    # Print as JSON-like array of objects
    print "["
    first_race = 1
    for(r in races){
        race_entries = ""
        for(k in race_candidate_keys){
            split(k, arr, ",")
            race_name = arr[1]
            candidate_name = arr[2]
            if(race_name==r){
                vote_count = votes[k]
                race_entries = race_entries sprintf("  {\"race\":\"%s\",\"candidate\":\"%s\",\"votes\":%d},\n", r, candidate_name, vote_count)
            }
        }
        # Remove trailing comma and newline
        if(length(race_entries) > 0){
            sub(/,\n$/,"",race_entries)
            if(!first_race) print ","
            first_race=0
            print race_entries
        }
    }
    print "]"
}' data.json > RAWdata.json

echo "RAWdata.json has been written."

# Step 2: Filter out unwanted candidates and print cleaned data to console
grep -v -E '"candidate":"(Times Over Voted|Times Counted|Write-in|Registered Voters|Times Under Voted)"' RAWdata.json > clean.json
bash web.sh
