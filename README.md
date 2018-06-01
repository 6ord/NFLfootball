# nflFootball
NFL American football match up analysis and recommendation. *See Projects tab*

2017_schedule.csv
- Copy & Paste of schedule grid from ESPN
- http://www.espn.com/nfl/schedulegrid/_/year/2017

2017_TNFMNF.csv
- Manual text file written to identify dates of non-Sunday games (Thursday Night Football & Monday Night Football), including week and teams.

nflTeamBoxscoreStats.r
- Pre-Python Scrape:
  - Uses 2017_schedule.csv and 2017_TNFMNF.csv to construct a dataframe with Game Date, Road Team and Home Team. This dataframe is then written to 2017_schedule_single.csv.

- Post-Python Scrape:
  - Analysis Script In Progress

2017_schedule_single.csv
- Contains Week, Date, Road Team and Home Team of all 2017 NFL Games
- Used in nflTeamBoxscoreScrape.py to build CBSSports.com URLs for each NFL game's results. Example: https://www.cbssports.com/nfl/gametracker/boxscore/NFL_20171112_DAL@ATL/ 

nflTeamBoxscoreScrape.py
- Contains a single function nflBoxscoreScrape(), which scrapes box score Team Stats from CBSSports.com. Data is captured in a List of Lists (List of games, where each element is a List of stat categories such as Team Rushed Yards, Team Passed Yards, number of 1st Downs, Time of Possession etc.). This data structure is then written to a flat nflBoxscoreScrape.csv, where each row is a team's stat observations per game.
- Games in scope dependent on 2017_schedule_single.csv
- Uses the following Python Modules: re, requests, bs4, csv, datetime
