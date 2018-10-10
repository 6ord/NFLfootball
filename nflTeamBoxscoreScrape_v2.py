import re, requests, bs4, csv, datetime

##  New Schedule Scraping instead of ESPN grid.
#url='https://www.cbssports.com/nfl/news/2018-nfl-schedule-release-heres-the-time-and-date-for-all-256-games/'
#pageSoup = bs4.BeautifulSoup(requests.get(url).text,'html.parser')
#pageSoup.select('div > h3')

def RegSeason2017BoxscoreScrape():
    print(datetime.datetime.now())
    #Ex, https://www.cbssports.com/nfl/gametracker/boxscore/NFL_20171210_IND@BUF
    url_base = 'https://www.cbssports.com/nfl/gametracker/boxscore/NFL_'
    url_game = []
    schedule = tuple(csv.reader(open('./2017_schedule_single.csv')))
    soupOutput = []
    tagDump = open('nflBoxscoreScrape(Tags).csv','w',newline='')
    tagCSVWriter = csv.writer(tagDump,delimiter=',',lineterminator='\n')

    realOutput = []
    realDump = open('nflBoxscoreScrape.csv','w',newline='')
    realCSVWriter = csv.writer(realDump,delimiter=',',lineterminator='\n')
    
    for i in range(1,257):
        url_game.append(schedule[i][1][0:4]+
                        schedule[i][1][5:7]+
                        schedule[i][1][8:10]+
                        '_'+
                        schedule[i][2]+
                        schedule[i][3])
        
    tagPick_lines = '.team-stats tr'
    #tagPick_stat_feld/valu = '.team-stats td'
    print('\n'+str(len(url_game))+'\n')
    print(url_game[-1])
    #for i in range(256):
    for i in range(len(url_game)):
    #for i in range(2):
        url=str(url_base+url_game[i])
        boxSoup = bs4.BeautifulSoup(requests.get(url).text,'html.parser')
        
        # TESTING: Make sure each game has 36 stats(from bs4 Object length) 
        print('Gm '+str(i)+'  '+url+'   '+str(len(boxSoup.select(tagPick_lines))))
        print(datetime.datetime.now())
        soupOutput.append([url[55:len(url)],boxSoup.select(tagPick_lines)[0].getText()])

        for j in range(1,len(boxSoup.select(tagPick_lines))):
            soupOutput[i].append(boxSoup.select(tagPick_lines)[j].getText())

        tagCSVWriter.writerow(soupOutput[i])

    tagDump.close()

    print('NFL Boxscore from CBS Scrape ended.')
    #print('Example row: '+str(soupOutput[0]))   #TO SEE \n 's
    #print('Example row: '+soupOutput[0][35])
    print(datetime.datetime.now())


    nxt_rcrd = 0
    realOutput.append(['Gm','Date','Team'])
    for h in range(1,len(soupOutput[0])):
        realOutput[nxt_rcrd].append(soupOutput[0][h].splitlines()[0])
    nxt_rcrd += 1    
    
    for i in range(len(soupOutput)):
        url=str(url_base+url_game[i])
        realOutput.append([url[55:len(url)],
                           url[55:63],
                           url[url.rfind('_')+1:url.find('@')]  #away team
                           ])
        for j in range(1,len(soupOutput[i])):
            realOutput[nxt_rcrd].append(soupOutput[i][j].splitlines()[1])
        nxt_rcrd += 1    
        realOutput.append([url[55:len(url)],
                           url[55:63],
                           url[url.find('@')+1:len(url)]   #home team
                           ])
        for k in range(1,len(soupOutput[i])): #Do something different if j=34,35
                                              #RZ and GoalToGo success rate had
                                              #FIVE lines (\n) to include %.
            if not 33<k<36:
                realOutput[nxt_rcrd].append(soupOutput[i][k].splitlines()[2])
            else:
                realOutput[nxt_rcrd].append(soupOutput[i][k].splitlines()[4])
        nxt_rcrd += 1
        
    for i in (range(len(realOutput))):
        realCSVWriter.writerow(realOutput[i])
    realDump.close()
    


def boxscoreScrapeWk(wkNum):
    print(datetime.datetime.now())
    #Ex, https://www.cbssports.com/nfl/gametracker/boxscore/NFL_20171210_IND@BUF
    url_base = 'https://www.cbssports.com/nfl/gametracker/boxscore/NFL_'
    url_game = []

    #TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST
    #To point to 2018 schedule when 3 or 4 wks are available to scrape
    #schedule = tuple(csv.reader(open('2017_schedule_single.csv')))
    schedule = tuple(csv.reader(open('2018_schedule_single.csv')))

    #below doesn't take column headings, which is why we loop from 0 3 blocks down
    thisWk = [(date,road,home) for (wk,date,road,home) in schedule if wk==str(wkNum)]

    soupOutput = []
    tagDump = open('nflBoxscoreScrape2018(Tags).csv','a',newline='') #change to append
    tagCSVWriter = csv.writer(tagDump,delimiter=',',lineterminator='\n') #change to append

    realOutput = []
    realDump = open('nflBoxscoreScrape2018.csv','a',newline='')
    realCSVWriter = csv.writer(realDump,delimiter=',',lineterminator='\n')

    # complete game url list to be fed to Requests
    for i in range(len(thisWk)):
    #for i in range(1,257):   #change 'thisWk' to 'schedule' for cumulative
        url_game.append(thisWk[i][0][0:4]+
                        thisWk[i][0][5:7]+
                        thisWk[i][0][8:10]+
                        '_'+
                        thisWk[i][1]+
                        thisWk[i][2])
        
    tagPick_lines = '.team-stats tr'
    #tagPick_stat_feld/valu = '.team-stats td'
    print('\n'+str(len(url_game))+'\n')
    print(url_game[-1])

    # Go through game url list and scrape each url
    #for i in range(256):
    for i in range(len(url_game)):
    #for i in range(2):
        url=str(url_base+url_game[i])
        boxSoup = bs4.BeautifulSoup(requests.get(url).text,'html.parser')
        
        # TESTING: Make sure each game has 36 stats(from bs4 Object length) 
        print('Gm '+str(i)+'  '+url+'   '+str(len(boxSoup.select(tagPick_lines))))
        print(datetime.datetime.now())
        soupOutput.append([url[55:len(url)],boxSoup.select(tagPick_lines)[0].getText()])

        for j in range(1,len(boxSoup.select(tagPick_lines))):
            soupOutput[i].append(boxSoup.select(tagPick_lines)[j].getText())

        tagCSVWriter.writerow(soupOutput[i])

    tagDump.close()

    print('NFL Boxscore from CBS Scrape ended.')
    #print('Example row: '+str(soupOutput[0]))   #TO SEE \n 's
    #print('Example row: '+soupOutput[0][35])
    print(datetime.datetime.now())

    # organize soupOutput
    nxt_rcrd = 0
    realOutput.append(['Gm','Date','Team'])
    for h in range(1,len(soupOutput[0])):
        realOutput[nxt_rcrd].append(soupOutput[0][h].splitlines()[0])
    nxt_rcrd += 1    
    
    for i in range(len(soupOutput)):
        url=str(url_base+url_game[i])
        realOutput.append([url[55:len(url)],
                           url[55:63],
                           url[url.rfind('_')+1:url.find('@')]  #away team
                           ])
        for j in range(1,len(soupOutput[i])):
            realOutput[nxt_rcrd].append(soupOutput[i][j].splitlines()[1])
        nxt_rcrd += 1    
        realOutput.append([url[55:len(url)],
                           url[55:63],
                           url[url.find('@')+1:len(url)]   #home team
                           ])
        for k in range(1,len(soupOutput[i])): #Do something different if j=34,35
                                              #RZ and GoalToGo success rate had
                                              #FIVE lines (\n) to include %.
            if not 33<k<36:
                realOutput[nxt_rcrd].append(soupOutput[i][k].splitlines()[2])
            else:
                realOutput[nxt_rcrd].append(soupOutput[i][k].splitlines()[4])
        nxt_rcrd += 1

    # Organized soupOutput written to csv    
    for i in (range(len(realOutput))):
        realCSVWriter.writerow(realOutput[i])
    realDump.close()
    
