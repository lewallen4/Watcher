#!/bin/bash

# Read the JSON file and create HTML output
{
cat << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Election Results Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --bg-primary: #0f0f23;
            --bg-secondary: #1a1a2e;
            --bg-card: rgba(30, 30, 46, 0.8);
            --accent: #00d4ff;
            --accent-glow: rgba(0, 212, 255, 0.4);
            --text-primary: #ffffff;
            --text-secondary: #b0b0cc;
            --text-muted: #8888aa;
            --border: rgba(255, 255, 255, 0.1);
            --success: #00ff88;
            --warning: #ffaa00;
            --danger: #ff4444;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            min-height: 100vh;
            padding: 20px;
            line-height: 1.4;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px;
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--accent), #a855f7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .header p {
            color: var(--text-secondary);
            font-size: 1rem;
        }

        .stats-bar {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin: 25px 0;
            flex-wrap: wrap;
        }

        .stat {
            background: var(--bg-card);
            padding: 15px 25px;
            border-radius: 12px;
            border: 1px solid var(--border);
            text-align: center;
            backdrop-filter: blur(10px);
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--accent);
            display: block;
        }

        .stat-label {
            font-size: 0.85rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .grid-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 40px;
            justify-content: center;
        }

        .race-card {
            background: var(--bg-card);
            border-radius: 16px;
            padding: 20px;
            border: 1px solid var(--border);
            backdrop-filter: blur(15px);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            flex: 0 0 calc(33.333% - 20px);
            min-width: 300px;
        }

        .race-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, var(--accent), transparent);
        }

        .race-card:hover {
            transform: translateY(-2px);
            border-color: var(--accent-glow);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .race-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            gap: 15px;
        }

        .race-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            flex: 1;
            line-height: 1.3;
        }

        .race-meta {
            text-align: right;
            flex-shrink: 0;
        }

        .total-votes {
            font-size: 0.9rem;
            color: var(--text-secondary);
            background: rgba(255,255,255,0.05);
            padding: 4px 8px;
            border-radius: 6px;
        }

        .candidate-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .candidate-row {
            display: flex;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            gap: 12px;
        }

        .candidate-row:last-child {
            border-bottom: none;
        }

        .candidate-info {
            flex: 1;
            min-width: 0;
        }

        .candidate-name {
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--text-primary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .winner .candidate-name::after {
            content: " 🏆";
            font-size: 0.8rem;
        }

        .candidate-details {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.8rem;
            color: var(--text-secondary);
            margin-top: 2px;
        }

        .vote-bar-container {
            flex: 0 0 120px;
            height: 6px;
            background: rgba(255,255,255,0.1);
            border-radius: 3px;
            overflow: hidden;
            position: relative;
        }

        .vote-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--accent), #a855f7);
            border-radius: 3px;
            transition: width 0.5s ease;
        }

        .vote-count {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.85rem;
            flex: 0 0 50px;
            text-align: right;
        }

        .percentage {
            flex: 0 0 45px;
            text-align: right;
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .winner {
            background: linear-gradient(90deg, rgba(0, 212, 255, 0.1), transparent);
            border-left: 3px solid var(--accent);
            margin: 0 -20px;
            padding: 8px 20px;
        }

        .winner .candidate-name {
            color: var(--accent);
            font-weight: 600;
        }

        .winner .vote-count {
            color: var(--accent);
        }

        .compact-view .candidate-row {
            padding: 6px 0;
        }

        .compact-view .candidate-name {
            font-size: 0.85rem;
        }

        .compact-view .vote-bar-container {
            flex: 0 0 80px;
        }

        .controls {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 25px 0;
            flex-wrap: wrap;
        }

        .btn {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            color: var(--text-secondary);
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn:hover {
            border-color: var(--accent);
            color: var(--accent);
        }

        .btn.active {
            background: var(--accent);
            color: var(--bg-primary);
            border-color: var(--accent);
        }

        @media (max-width: 1024px) {
            .race-card {
                flex: 0 0 calc(50% - 20px);
            }
        }

        @media (max-width: 768px) {
            .grid-container {
                flex-direction: column;
            }
            
            .race-card {
                flex: 0 0 100%;
                min-width: auto;
                padding: 15px;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .stats-bar {
                gap: 15px;
            }
            
            .stat {
                padding: 12px 20px;
            }
            
            .vote-bar-container {
                flex: 0 0 60px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }
            
            .race-header {
                flex-direction: column;
                gap: 8px;
            }
            
            .race-meta {
                text-align: left;
                align-self: flex-start;
            }
        }

        .footer {
            text-align: center;
            padding: 30px 0;
            color: var(--text-muted);
            font-size: 0.85rem;
            border-top: 1px solid var(--border);
            margin-top: 40px;
        }

        /* Animation for vote bars */
        @keyframes slideIn {
            from { transform: scaleX(0); }
            to { transform: scaleX(1); }
        }

        .vote-fill {
            transform-origin: left;
            animation: slideIn 0.8s ease-out;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-vote-yea"></i> King County - Live Election Dashboard</h1>
            <p>Real-time voting results and analytics</p>
        </div>

        <div class="stats-bar" id="stats-container">
            <!-- Stats will be populated by JavaScript -->
        </div>

        <div class="controls">
            <button class="btn active" onclick="toggleView('normal')">
                <i class="fas fa-th"></i> Normal View
            </button>
            <button class="btn" onclick="sortByVotes()">
                <i class="fas fa-sort-amount-down"></i> Sort by Votes
            </button>
            <button class="btn" onclick="sortAlphabetically()">
                <i class="fas fa-sort-alpha-down"></i> Sort A-Z
            </button>
        </div>

        <div class="grid-container" id="races-container">
            <!-- Race cards will be populated here -->
EOF

# Process the JSON data and generate HTML race cards
awk '
function escape_html(str) {
    gsub(/&/, "\\&amp;", str)
    gsub(/</, "\\&lt;", str)
    gsub(/>/, "\\&gt;", str)
    gsub(/"/, "\\&quot;", str)
    gsub(/\//, "\\&#x2F;", str)
    return str
}

BEGIN {
    FS = "\""
    race_index = 0
    in_array = 0
    current_race = ""
    current_candidate = ""
    current_votes = 0
}

/\[/ { in_array = 1; next }
/\]/ { in_array = 0; next }

in_array && /race/ {
    for(i=1; i<=NF; i++) {
        if ($i == "race") {
            current_race = $(i+2)
            break
        }
    }
}

in_array && /candidate/ {
    for(i=1; i<=NF; i++) {
        if ($i == "candidate") {
            current_candidate = $(i+2)
            break
        }
    }
}

in_array && /votes/ {
    for(i=1; i<=NF; i++) {
        if ($i == "votes") {
            split($(i+1), arr, /[:,]/)
            current_votes = arr[2] + 0
            break
        }
    }
    
    if (current_race != "" && current_candidate != "") {
        races[current_race][current_candidate] = current_votes
        all_races[current_race] = 1
    }
    
    current_race = ""
    current_candidate = ""
    current_votes = 0
}

END {
    # Sort races alphabetically
    n = 0
    for (race in all_races) {
        race_order[n++] = race
    }
    
    for (i = 0; i < n-1; i++) {
        for (j = 0; j < n-i-1; j++) {
            if (race_order[j] > race_order[j+1]) {
                temp = race_order[j]
                race_order[j] = race_order[j+1]
                race_order[j+1] = temp
            }
        }
    }
    
    # Generate HTML race cards
    for (r = 0; r < n; r++) {
        race = race_order[r]
        
        total_votes = 0
        max_votes = 0
        candidate_count = 0
        
        for (candidate in races[race]) {
            votes = races[race][candidate]
            total_votes += votes
            if (votes > max_votes) max_votes = votes
            candidate_order[candidate_count++] = candidate
        }
        
        # Sort candidates by votes
        for (i = 0; i < candidate_count-1; i++) {
            for (j = 0; j < candidate_count-i-1; j++) {
                if (races[race][candidate_order[j]] < races[race][candidate_order[j+1]]) {
                    temp = candidate_order[j]
                    candidate_order[j] = candidate_order[j+1]
                    candidate_order[j+1] = temp
                }
            }
        }
        
        # Print race card
        printf "            <div class=\"race-card\">\n"
        printf "                <div class=\"race-header\">\n"
        printf "                    <div class=\"race-title\">%s</div>\n", escape_html(race)
        printf "                    <div class=\"race-meta\">\n"
        printf "                        <div class=\"total-votes\">%d votes</div>\n", total_votes
        printf "                    </div>\n"
        printf "                </div>\n"
        printf "                <div class=\"candidate-list\">\n"
        
        # Print candidates
        for (i = 0; i < candidate_count; i++) {
            candidate = candidate_order[i]
            votes = races[race][candidate]
            
            percentage = (total_votes > 0) ? (votes / total_votes * 100) : 0
            percentage_str = sprintf("%.1f%%", percentage)
            bar_width = (max_votes > 0) ? (votes / max_votes * 100) : 0
            is_winner = (i == 0 && votes > 0) ? 1 : 0
            
            printf "                    <div class=\"candidate-row%s\">\n", (is_winner ? " winner" : "")
            printf "                        <div class=\"candidate-info\">\n"
            printf "                            <div class=\"candidate-name\">%s</div>\n", escape_html(candidate)
            printf "                        </div>\n"
            printf "                        <div class=\"percentage\">%s</div>\n", percentage_str
            printf "                        <div class=\"vote-bar-container\">\n"
            printf "                            <div class=\"vote-fill\" style=\"width: %.1f%%\"></div>\n", bar_width
            printf "                        </div>\n"
            printf "                        <div class=\"vote-count\">%d</div>\n", votes
            printf "                    </div>\n"
        }
        
        printf "                </div>\n"
        printf "            </div>\n"
        
        delete candidate_order
    }
}
' clean.json

cat << 'EOF'
        </div>

        <div class="footer">
            <p>Generated on <span id="generation-date"></span> | Election Results System</p>
        </div>
    </div>

    <script>
        // Set generation date
        document.getElementById('generation-date').textContent = new Date().toLocaleDateString();

        let currentView = 'normal';
        let currentSort = 'default';

        function toggleView(view) {
            currentView = view;
            const container = document.getElementById('races-container');
            const cards = container.getElementsByClassName('race-card');
            const buttons = document.querySelectorAll('.btn');
            
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            for (let card of cards) {
                if (view === 'compact') {
                    card.classList.add('compact-view');
                } else {
                    card.classList.remove('compact-view');
                }
            }
        }

        function sortByVotes() {
            currentSort = 'votes';
            sortRaces();
        }

        function sortAlphabetically() {
            currentSort = 'alpha';
            sortRaces();
        }

        function sortRaces() {
            const container = document.getElementById('races-container');
            const cards = Array.from(container.getElementsByClassName('race-card'));
            
            cards.sort((a, b) => {
                if (currentSort === 'votes') {
                    const aVotes = parseInt(a.querySelector('.total-votes').textContent);
                    const bVotes = parseInt(b.querySelector('.total-votes').textContent);
                    return bVotes - aVotes;
                } else {
                    const aTitle = a.querySelector('.race-title').textContent;
                    const bTitle = b.querySelector('.race-title').textContent;
                    return aTitle.localeCompare(bTitle);
                }
            });
            
            cards.forEach(card => container.appendChild(card));
        }

        // Initialize with some stats
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(() => {
                const statsContainer = document.getElementById('stats-container');
                statsContainer.innerHTML = `
                    <div class="stat">
                        <span class="stat-number" id="total-races">0</span>
                        <span class="stat-label">Total Races</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number" id="total-candidates">0</span>
                        <span class="stat-label">Candidates</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number" id="total-votes">0</span>
                        <span class="stat-label">Total Votes</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number" id="avg-turnout">0</span>
                        <span class="stat-label">Avg. Turnout</span>
                    </div>
                `;
                
                // Animate stats
                animateCounter('total-races', document.querySelectorAll('.race-card').length);
                animateCounter('total-candidates', document.querySelectorAll('.candidate-row').length);
                
                let totalVotes = 0;
                document.querySelectorAll('.total-votes').forEach(el => {
                    totalVotes += parseInt(el.textContent);
                });
                animateCounter('total-votes', totalVotes);
                animateCounter('avg-turnout', Math.round(totalVotes / document.querySelectorAll('.race-card').length));
            }, 100);
        });

        function animateCounter(elementId, target) {
            const element = document.getElementById(elementId);
            let current = 0;
            const increment = target / 50;
            const timer = setInterval(() => {
                current += increment;
                if (current >= target) {
                    element.textContent = target.toLocaleString();
                    clearInterval(timer);
                } else {
                    element.textContent = Math.floor(current).toLocaleString();
                }
            }, 30);
        }
    </script>
</body>
</html>
EOF
} > election_dashboard.html

echo "Ultra-modern dashboard generated: election_dashboard.html"