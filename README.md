# October 15, 2018 Update

Project now scrapes team boxscores a week at a time, in appending fashion. The following is the end-to-end process:

  1. boxscoreScrapeWk(wkNum) function in nflTeamBoxscoreScrape_v2.py collects boxscore data see September 3, 2018 update for more detail.
  2. nflTeamBoxscoreOutput.r sources:
      nflTeamBoxscoreFunctions.r to build user defined functions
      nflTeamBoxscoreStats.r to import, clean and build teams' 'allowed' stats
      nflTeamBoxscoreAnalysis.r to extract recent weeks and build pair-wise variables for current week matchups
  3. nflTeamBoxscoreOutput.r uses Shiny package to output recommendations based on average ranking of pair-wise variable groups.

*NOTE: SOME PRIMETIME GAMES ARE TBD on 2018_schedule_single.csv file. Will need updating later on in the season.*

Future Enhancement:
  - merge in and analyze players' snap count for player picking as well as team picking
  - public online access to Shiny app


# September 3, 2018 Update

2018_schedule_single.csv
- This year, I coped & pasted schedule from CBS (link below) and organized information in Excel, rather than using the grid from ESPN and R.
- https://www.cbssports.com/nfl/news/2018-nfl-schedule-release-heres-the-time-and-date-for-all-256-games/
- *NOTE: SOME PRIMETIME GAMES ARE TBD. Will need updating later on in the season.*

nflTeamBoxscoreScrape_v2.py
- Updated to contain two scraping functions:
  1. RegSeason2017BoxscoreScrape()
     - single function that scrapes boxscores for entire regular season. See original documentation on the nflBoxscoreScrape() function for more details.
     - Uses the following Python Modules: re, requests, bs4, csv, datetime

  2. boxscoreScrapeWk(wkNum)
     - scrapes boxscores for a given week (wkNum) of the season, appends output to .csv file in working path
     - Uses the following Python Modules: re, requests, bs4, csv, datetime
     - *Warning: Headings are also appended. Will need to remove when importing for analysis*

Work In Progress: nflTeamBoxscoreStats.r
- next iteration to convert scraped character data types to numeric as appropriate, other organizing into data frame, and incorporate analysis for recommendation.


# nflFootball
NFL American football web scraped stats, and match up analysis and recommendation. *See Projects tab*

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
