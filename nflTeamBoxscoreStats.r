# 
# gameStats <- read.csv("D:/workbin/BigData/NFLScrape/nflBoxscoreScrape2018.csv",stringsAsFactors = FALSE)
# 
# leagueSched <- read.csv("D:/workbin/BigData/NFLScrape/2018_schedule_single.csv",stringsAsFactors = FALSE)

vars <- list(currWk=3,
             numWks=2
)

gameStats <- read.csv("nflBoxscoreScrape2019.csv",stringsAsFactors = FALSE)
leagueSched <- read.csv("2019_schedule_single.csv",stringsAsFactors = FALSE)

# snapcounts2018 <- data.frame(read.csv("nflSnapCount2018.csv",stringsAsFactors = FALSE))
# snapcounts2018[4:(length(snapcounts2018)-2)] <- as.numeric(snapcounts2018[4:length(snapcounts2018)])
# snapcounts2018 <- data.frame(read.csv("D:/workbin/BigData/NFLScrape/nflSnapCount2018.csv",stringsAsFactors = FALSE))
# 
# rm(snapcounts2018)
#Â

leagueSched$Date <- as.Date(leagueSched$Date,'%Y-%m-%d')

gameStats.orig <- gameStats

gameStats <- gameStats[which(gameStats$Gm!='Gm'),]

attach(gameStats)

gameStats$Date <- as.Date(Date,'%Y%m%d')
gameStats$Time.of.Pos <- strptime(Time.of.Pos,'%M:%S')$hour*60+strptime(Time.of.Pos,'%M:%S')$min
gameStats$X1st.Downs <- as.numeric(X1st.Downs)
gameStats$Rushing <- as.numeric(Rushing)
gameStats$Passing <- as.numeric(Passing)
gameStats$Penalty <- as.numeric(Penalty)
#Test below completion-attempt
gameStats$rdDwnCon <- as.numeric(regmatches(X3rd.Down.Conv,regexpr('\\d+',X3rd.Down.Conv)))
gameStats$rdDwnAtt <- abs(as.numeric(regmatches(X3rd.Down.Conv,regexpr('\\-\\d+',X3rd.Down.Conv))))
gameStats$thDwnCon <- as.numeric(regmatches(X4th.Down.Conv,regexpr('\\d+',X4th.Down.Conv)))
gameStats$thDwnAtt <- abs(as.numeric(regmatches(X4th.Down.Conv,regexpr('\\-\\d+',X4th.Down.Conv))))

gameStats$Total.Net.Yards <- as.numeric(Total.Net.Yards)
gameStats$Total.Plays <- as.numeric(Total.Plays)
gameStats$Avg.Gain<-NULL

gameStats$Net.Yards.Rushing <- as.numeric(Net.Yards.Rushing)
gameStats$Rush.Attempts <- as.numeric(Rush.Attempts)
gameStats$Avg.Rush.Yards<-NULL

gameStats$Net.Yards.Passing <- as.numeric(Net.Yards.Passing)
gameStats$PassCom <- as.numeric(regmatches(Comp....Att.,regexpr('\\d+',Comp....Att.)))
gameStats$PassAtt <- abs(as.numeric(regmatches(Comp....Att.,regexpr('\\-\\d+',Comp....Att.))))
gameStats$Comp....Att. <- NULL
gameStats$Yards.Per.Pass <- NULL

gameStats$Sacked <- as.numeric(regmatches(Sacked...Yards.Lost,regexpr('\\d+',Sacked...Yards.Lost)))
gameStats$SackYdsLost <- abs(as.numeric(regmatches(Sacked...Yards.Lost,regexpr('\\-\\d+',Sacked...Yards.Lost))))
gameStats$Sacked...Yards.Lost <- NULL

gameStats$Penalties <- as.numeric(regmatches(Penalties...Yards,regexpr('\\d+',Penalties...Yards)))
gameStats$PenaltyYdsLost <- abs(as.numeric(regmatches(Penalties...Yards,regexpr('\\-\\d+',Penalties...Yards))))
gameStats$Penalties...Yards <- NULL

gameStats$Touchdowns <- as.numeric(Touchdowns)
gameStats$Rushing.TDs <- as.numeric(Rushing.TDs)
gameStats$Passing.TDs <- as.numeric(Passing.TDs)
gameStats$Other <- as.numeric(Other)

gameStats$Turnovers <- as.numeric(Turnovers)

gameStats$Fumbles <- as.numeric(regmatches(Fumbles...Lost,regexpr('\\d+',Fumbles...Lost)))
gameStats$FumblesLost <- abs(as.numeric(regmatches(Fumbles...Lost,regexpr('\\-\\d+',Fumbles...Lost))))
gameStats$Fumbles...Lost <- NULL

gameStats$Int..Thrown <- as.numeric(Int..Thrown)
gameStats$Punts...Avg <- NULL
gameStats$Return.Yards <- NULL
gameStats$PuntReturns <- as.numeric(regmatches(Punts...Returns,regexpr('\\d+',Punts...Returns)))
gameStats$PuntReturnYds <- abs(as.numeric(regmatches(Punts...Returns,regexpr('\\-\\d+',Punts...Returns))))
gameStats$KickReturns <- as.numeric(regmatches(Kickoffs...Returns,regexpr('\\d+',Kickoffs...Returns)))
gameStats$KickReturnYds <- abs(as.numeric(regmatches(Kickoffs...Returns,regexpr('\\-\\d+',Kickoffs...Returns))))
gameStats$Ints <- as.numeric(regmatches(Int....Returns,regexpr('\\d+',Int....Returns)))
gameStats$IntReturnYds <- abs(as.numeric(regmatches(Int....Returns,regexpr('\\-\\d+',Int....Returns))))

gameStats$Kicking <- NULL
gameStats$Kicking.XPMade <- as.numeric(regmatches(Extra.Points,regexpr('\\d+',Extra.Points)))
gameStats$Kicking.XPAtt <- as.numeric(regmatches(Extra.Points,regexpr('\\d+$',Extra.Points)))
gameStats$Kicking.FGMade <- as.numeric(regmatches(Field.Goals,regexpr('\\d+',Field.Goals)))
gameStats$Kicking.FGAtt <- as.numeric(regmatches(Field.Goals,regexpr('\\d+$',Field.Goals)))

gameStats$RZScr <- as.numeric(regmatches(Red.Zone.Eff.,regexpr('\\d+',Red.Zone.Eff.)))
gameStats$RZAtt <- as.numeric(regmatches(Red.Zone.Eff.,regexpr('\\d+$',Red.Zone.Eff.)))

gameStats$GTGConv <- as.numeric(regmatches(Goal.to.Go.Eff.,regexpr('\\d+',Goal.to.Go.Eff.)))
gameStats$GTGAtt <- as.numeric(regmatches(Goal.to.Go.Eff.,regexpr('\\d+$',Goal.to.Go.Eff.)))

gameStats$Safeties <- NULL

colnames(gameStats)[4] <- 'TOP'
colnames(gameStats)[5] <- 'FirstDowns'
colnames(gameStats)[6] <- 'FrstDwnRsh'
colnames(gameStats)[7] <- 'FrstDwnPas'
colnames(gameStats)[8] <- 'FrstDwnPen'

colnames(gameStats)[11] <- 'TotalNetYds'
colnames(gameStats)[12] <- 'TotalPlays'

colnames(gameStats)[13] <- 'RushNetYds'
colnames(gameStats)[14] <- 'RushAtt'
# NEED AVG RUSH
colnames(gameStats)[15] <- 'PassNetYds'
# NEED AVG PASS
colnames(gameStats)[16] <- 'TDs'
colnames(gameStats)[17] <- 'TDsRush'
colnames(gameStats)[18] <- 'TDsPass'
colnames(gameStats)[19] <- 'TDsOthr'
colnames(gameStats)[21] <- 'IntLost'

gameStats$X3rd.Down.Conv <- NULL
gameStats$X4th.Down.Conv <- NULL
gameStats[20:26] <- NULL
# home: TRUE/FALSE, if team has @ in front
for (i in (1:nrow(gameStats))) gameStats$home[i] <- grepl(paste('@',gameStats$Team[i],sep=''),gameStats$Gm[i])

gameStats <- merge(gameStats,unique(leagueSched[c('Week','Date')]),by = 'Date',all=FALSE)

detach(gameStats)
sum(is.na(gameStats))

#dput(colnames(gameStats))
#https://stackoverflow.com/questions/5620885/how-does-one-reorder-columns-in-a-data-frame

gameStats <- gameStats[c("Week", "Gm", "Date", "home", "Team", "TOP",
                     "TotalPlays", "TotalNetYds",
                     "RushAtt", "RushNetYds",
                     "PassCom", "PassAtt", "PassNetYds",
                     "TDs", "TDsRush", "TDsPass", "TDsOthr",
                     "FirstDowns", "FrstDwnRsh", "FrstDwnPas","FrstDwnPen",
                     "rdDwnAtt", "rdDwnCon", "thDwnAtt", "thDwnCon",
                     "GTGConv", "GTGAtt", "RZScr", "RZAtt",
                     "Ints", "IntReturnYds",
                     "Sacked", "SackYdsLost", "Penalties", "PenaltyYdsLost", 
                     "IntLost", "Fumbles", "FumblesLost", "Turnovers",
                     "PuntReturns", "PuntReturnYds", "KickReturns", "KickReturnYds",
                     "Kicking.XPMade", "Kicking.XPAtt", "Kicking.FGMade", "Kicking.FGAtt")]

#Inverse-Allowed
# High level approach: 1. Create field "Opponent" for each team for a given week (each row).
#                      2. Merge with itself on Team=Opponent

gameStats <- merge(gameStats,matchups(leagueSched),by=c('Week','Team'))
gameStats$Oppn <- as.character(gameStats$Oppn)

gameStats <- merge(gameStats,
                 data.frame(cbind(gameStats[c('Week','Team')],gameStats[c(6:29)],gameStats[c(31:35,37:47)])),
                 by.x=c('Week','Oppn'),by.y=c('Week','Team'))

gameStats$Oppn <- NULL

#Rename fields to "allowed"
colnames(gameStats) <- c('Week', 'Team', 'Gm', 'Date', 'home', 'TOP', 'TotalPlays', 
                       'TotalYds', 'RushAtt', 'RushYds', 'PassCom', 'PassAtt', 
                       'PassYds', 'TDs', 'TDsRush', 'TDsPass', 'TDsOthr', 
                       'FirstDowns', 'FrstDwnRsh', 'FrstDwnPas', 'FrstDwnPen', 
                       'rdDwnAtt', 'rdDwnCon', 'thDwnAtt', 'thDwnCon', 'GTGConv', 
                       'GTGAtt', 'RZScr', 'RZAtt', 'Ints', 'IntReturnYds', 'Sacked', 
                       'SackYdsLost', 'Penalties', 'PenaltyYdsLost', 'IntLost', 
                       'Fumbles', 'FumblesLost', 'Turnovers', 'PuntReturns', 
                       'PuntReturnYds', 'KickReturns', 'KickReturnYds', 'Kicking.XPMade', 
                       'Kicking.XPAtt', 'Kicking.FGMade', 'Kicking.FGAtt', 'TOD', 
                       'PlaysDefended', 'NetYdsAllowed', 'RushPlaysDefended', 'RushYdsAllowed', 
                       'RecptnsAllowed', 'PassPlaysDefended', 'PassYdsAllowed', 'TDsAllowed', 'TDsRushAllowed', 
                       'TDsPassAllowed', 'TDsOthrAllowed', 'FirstDownsAllowed', 'FrstDwnRshAllowed', 'FrstDwnPasAllowed', 
                       'FrstDwnPenAllowed', 'rdDwnAttDefended', 'rdDwnConAllowed', 'thDwnAttDefended', 'thDwnConAllowed', 
                       'GTGConvAllowed', 'GTGAttDefended', 'RZScrAllowed', 'RZAttDefended', 'IntYdsLost', 
                       'Sacks', 'SackYdsGained', 'PenaltiesForced', 'PenaltyYdsGained', 
                       'FumblesForced', 'FumblesRecovered', 'TurnoversForced', 'Punts', 
                       'PuntReturnYdsAllowed', 'KickOffs', 'KickReturnYdsAllowed', 'Kicking.XPAllowed', 
                       'Kicking.XPDefended', 'Kicking.FGAllowed', 'Kicking.FGDefended')
