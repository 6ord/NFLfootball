import re, requests, bs4, csv, datetime
import pandas as pd

pd.set_option('display.max_columns',500)
pd.set_option('display.max_rows',50)
pd.set_option('display.width',1000)

def weeklyScrape(yr,wkNum):
    print(datetime.datetime.now())
    #Scrape CBS NFL schedule for week "wkNum", and generate boxscore links
    #Scrape each boxscore link from above and write to csv
    #Ex, https://www.cbssports.com/nfl/gametracker/boxscore/NFL_20171210_IND@BUF

    pff_url = 'https://www.pro-football-reference.com/'
    #https://www.pro-football-reference.com/years/2019/week_1.htm
    week_url = 'years/'+str(yr)+'/week_'+str(wkNum)+'.htm'
    
    tag = '.right.gamelink a[href]'
    soup = bs4.BeautifulSoup(requests.get(pff_url+week_url).text,'html.parser')
    games = soup.select(tag)

    #games[0].get('href')

    #@@@@@@@@3









    

    seasonDF = pd.DataFrame(columns=['Week','Date','Road','Home','url'])
    # Ex, 1, YYYY-MM-DD, AWY, @HME, http://...AWY@HME/
    
    for i in range(1,18):
        weekURL = cbs_url+schedule_url+str(i)
        wkSoup = bs4.BeautifulSoup(requests.get(weekURL).text,'html.parser')
        gameURLs = wkSoup.select('.CellGame a[href]')
        numGm = len(gameURLs)
        
        #create DF of one week's games
        thisWkDF = pd.DataFrame(columns=['Week','Date','Road','Home','url'])
        
        for j in range(numGm):
            link = gameURLs[j].get('href')
            p = link.find('NFL_')+4
            thisWkDF.loc[j] = [i] + [str(link[p:p+4]+'-'+link[p+4:p+6]+'-'+link[p+6:p+8])]+[link[p+9:(link.find('@'))]] + [link[(link.find('@')):-1]]+[cbs_url+link] 

        seasonDF = seasonDF.append(thisWkDF)        
        #del(thisWkDF)
        #append above DF to schedDF

    gmURLs = seasonDF[seasonDF['Week']==wkNum]['url']
    numGm = len(gmURLs)
    #wkSchedSoup = bs4.BeautifulSoup(requests.get(cbs_url+schedule_url+str(wkNum)).text,'html.parser')
    #for 16 matches in i, generate dataframe, game boxscore URLs down one column
    #numGm = len(wkSchedSoup.select('.CellGame a[href]'))
    
    
    

    #for i in range(numGm):
    #    gmURLs.loc[i] = cbs_url+str(wkSchedSoup.select('.CellGame a[href]')[i].get('href')).replace('recap','boxscore')

    soupOutput = []
    tagDump = open('nflBoxscoreScrape2019(Tags).csv','a',newline='') #change to append
    tagCSVWriter = csv.writer(tagDump,delimiter=',',lineterminator='\n') #change to append

    realOutput = []
    realDump = open('nflBoxscoreScrape2019.csv','a',newline='')
    realCSVWriter = csv.writer(realDump,delimiter=',',lineterminator='\n')


    #######################################################
    ###  NEED SCHEDULE CSV BUT CAN DO FROM PANDA STRAIGHT TO CSV???

    

    
    #schdOutput = []
    #schdDump = open('2019_schedule_single.csv','a',newline='')
    #schdCSVWriter = csv.writer(realDump,delimiter=',',lineterminator='\n')

    seasonDF.drop('url',axis=1).to_csv('2019_schedule_single.csv', sep = ',', encoding = 'utf-8', index = False)



    #######################################################




    tagPick_lines = '.team-stats tr'
    #tagPick_stat_feld/valu = '.team-stats td'
    #print('\n'+str(len(url_game))+'\n')
    #print(url_game[-1])

    # Go through game url list and scrape each url
    for i in range(len(gmURLs)):
        url=str(gmURLs.loc[i])
        boxSoup = bs4.BeautifulSoup(requests.get(url).text,'html.parser')

        # TESTING: Make sure each game has 36 stats(from bs4 Object length) 
        print('Gm '+str(i)+'  '+url+'   '+str(len(boxSoup.select(tagPick_lines))))
        print(datetime.datetime.now())
        p = url.find('NFL_')+4
        soupOutput.append([url[p:-1],boxSoup.select(tagPick_lines)[0].getText()])

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
        #builds rest of column headings
    nxt_rcrd += 1    

    for i in range(len(soupOutput)):
        url=str(gmURLs.loc[i])
        p = url.find('NFL_')+4    
        realOutput.append([url[p:-1],
                           url[p:p+8],
                           url[url.rfind('_')+1:url.find('@')]  #away team
                           ])
        for j in range(1,len(soupOutput[i])):
            realOutput[nxt_rcrd].append(soupOutput[i][j].splitlines()[1])

        nxt_rcrd += 1    

        realOutput.append([url[p:-1],
                           url[p:p+8],
                           url[url.find('@')+1:len(url)-1]   #home team
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





# UNDER CONSTRUCTION #


def snapcountScrape():

    osc_url='https://www.fantasypros.com/nfl/reports/snap-counts/'
    dsc_url='https://www.fantasypros.com/nfl/reports/snap-counts/defense.php'

    osc_soup=bs4.BeautifulSoup(requests.get(osc_url).text,'html.parser')
    dsc_soup=bs4.BeautifulSoup(requests.get(dsc_url).text,'html.parser')

    offTagList=osc_soup.select('.mobile-table td')
    defTagList=dsc_soup.select('.mobile-table td')

    hdg=['player','position','team','total','average']
    hdgWks=[]
    for i in range(1,18):hdgWks.append('Wk'+str(i))
    heading=hdg[0:3]+hdgWks+hdg[3:5]
    del hdg, hdgWks

    allSnapCounts=[]
    allSnapCounts.append(heading)

    start=0
    end=22    
    for i in range(int(len(offTagList)/22)):

        temp=[]

        for j in range(start,end):
            temp.append(offTagList[j].getText())

        allSnapCounts.append(temp)
        del temp
        start+=22
        end+=22

    start=0
    end=22    
    for i in range(int(len(defTagList)/22)):

        temp=[]

        for j in range(start,end):
            temp.append(defTagList[j].getText())

        allSnapCounts.append(temp)
        del temp
        start+=22
        end+=22



    with open('nflSnapCount2018.csv','w',newline='',encoding='utf-8') as realDump:
        realCSVWriter = csv.writer(realDump,delimiter=',',lineterminator='\n')
        for i in (range(len(allSnapCounts))):
            realCSVWriter.writerow(allSnapCounts[i])
        realDump.close()
