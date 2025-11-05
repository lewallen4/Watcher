#!/bin/bash

# Download the data (assuming it's available at the same URL)
curl -s "https://election-results-01.kingcounty.gov/webresults.csv" > data.csv

# Process the CSV and generate the JSON output
awk -F',' '
NR == 1 {
    # Read header to find column positions
    for(i=1; i<=NF; i++) {
        if($i == "Ballot Title") ballot_title_col = i
        if($i == "Ballot Response") ballot_response_col = i
        if($i == "Votes") votes_col = i
        if($i == "District Name") district_subheading_col = i
    }
    next
}

{
    # Extract relevant fields
    ballot_title = $(ballot_title_col)
    candidate = $(ballot_response_col)
    votes = $(votes_col)
    district_subheading = $(district_subheading_col)
    
    # Clean up any quotes that might be in the fields
    gsub(/"/, "", ballot_title)
    gsub(/"/, "", candidate)
    gsub(/"/, "", votes)
    gsub(/"/, "", district_subheading)
    
    # Skip unwanted entries
    if(candidate ~ /^(Times Over Voted|Times Counted|Write-in|Registered Voters|Times Under Voted)$/) next
    
    # Combine district subheading and ballot title for race field
    race = district_subheading " - " ballot_title
    
    # Create key for aggregation
    key = race "|" candidate
    votes_total[key] += votes
    race_candidate_pairs[key] = 1
}

END {
    print "["
    first = 1
    for(key in votes_total) {
        split(key, arr, "|")
        race_name = arr[1]
        candidate_name = arr[2]
        
        if(!first) {
            print ","
        }
        first = 0
        
        printf "  {\"race\":\"%s\",\"candidate\":\"%s\",\"votes\":%d}", race_name, candidate_name, votes_total[key]
    }
    print "\n]"
}' data.csv > RAWdata.json

echo "RAWdata.json has been written."

# Step 2: Filter out any remaining unwanted candidates and print cleaned data to console
grep -v -E '"candidate":"(Times Over Voted|Times Counted|Write-in|Registered Voters|Times Under Voted)"' RAWdata.json > clean.json

# Continue with your existing workflow
bash web.sh
#powershell -Command "Start-Process -FilePath 'election_dashboard.html' -WindowStyle Normal"
