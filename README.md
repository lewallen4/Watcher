## King County Election Results Tracker

A Bash script that fetches, processes, and displays King County election results by automatically generating a web page hosted on GitHub Pages.
<br>

#### Overview

    Fetches live election data from King County's open data portal

    Processes and aggregates votes by candidate and race

    Filters out non-candidate entries (like "Write-in", "Registered Voters", etc.)

    Generates a clean web page with the results

    Automatically deploys to GitHub Pages for public viewing

#### Features

    Real-time Data: Pulls directly from the official King County data source

    Data Cleaning: Removes administrative entries to focus on actual candidates

    Automatic Deployment: Self-publishing to web via GitHub Pages

    Structured Output: Generates properly formatted JSON data

#### Data Source

##### Data is sourced from the King County Elections API

#### Viewing Results

    
##### After running the script, the results will be automatically published to GitHub Pages where you can track King County Elections in real-time.
###### https://lewallen4.github.io/Watcher
---
<img src="https://raw.githubusercontent.com/lewallen4/Watcher/main/docs/Screenshot.png?raw=true" 
     alt="Watcher Screenshot" 
     width="500" 
     style="border: 10px solid #ddd; padding: 20px; border-radius: 8px;" />
