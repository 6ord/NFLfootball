import re, requests, bs4, csv, datetime

def nflBoxscoreScrape():
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
    
