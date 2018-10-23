# 
# nfl2018 <- read.csv("D:/workbin/BigData/NFLScrape/nflBoxscoreScrape2018.csv"
#                     ,stringsAsFactors = FALSE
# )
# 
# schedule2018 <- read.csv("D:/workbin/BigData/NFLScrape/2018_schedule_single.csv"
#                          ,stringsAsFactors = FALSE
# )

nfl2018 <- read.csv("nflBoxscoreScrape2018.csv",stringsAsFactors = FALSE)
schedule2018 <- read.csv("2018_schedule_single.csv",stringsAsFactors = FALSE)


schedule2018$Date <- as.Date(schedule2018$Date,'%Y-%m-%d')

nfl2018.orig <- nfl2018

nfl2018 <- nfl2018[which(nfl2018$Gm!='Gm'),]

attach(nfl2018)

nfl2018$Date <- as.Date(Date,'%Y%m%d')
nfl2018$Time.of.Pos <- strptime(Time.of.Pos,'%M:%S')$hour*60+strptime(Time.of.Pos,'%M:%S')$min
nfl2018$X1st.Downs <- as.numeric(X1st.Downs)
nfl2018$Rushing <- as.numeric(Rushing)
nfl2018$Passing <- as.numeric(Passing)
nfl2018$Penalty <- as.numeric(Penalty)
#Test below completion-attempt
nfl2018$rdDwnCon <- as.numeric(regmatches(X3rd.Down.Conv,regexpr('\\d+',X3rd.Down.Conv)))
nfl2018$rdDwnAtt <- abs(as.numeric(regmatches(X3rd.Down.Conv,regexpr('\\-\\d+',X3rd.Down.Conv))))
nfl2018$thDwnCon <- as.numeric(regmatches(X4th.Down.Conv,regexpr('\\d+',X4th.Down.Conv)))
nfl2018$thDwnAtt <- abs(as.numeric(regmatches(X4th.Down.Conv,regexpr('\\-\\d+',X4th.Down.Conv))))

nfl2018$Total.Net.Yards <- as.numeric(Total.Net.Yards)
nfl2018$Total.Plays <- as.numeric(Total.Plays)
nfl2018$Avg.Gain<-NULL

nfl2018$Net.Yards.Rushing <- as.numeric(Net.Yards.Rushing)
nfl2018$Rush.Attempts <- as.numeric(Rush.Attempts)
nfl2018$Avg.Rush.Yards<-NULL

nfl2018$Net.Yards.Passing <- as.numeric(Net.Yards.Passing)
nfl2018$PassCom <- as.numeric(regmatches(Comp....Att.,regexpr('\\d+',Comp....Att.)))
nfl2018$PassAtt <- abs(as.numeric(regmatches(Comp....Att.,regexpr('\\-\\d+',Comp....Att.))))
nfl2018$Comp....Att. <- NULL
nfl2018$Yards.Per.Pass <- NULL

nfl2018$Sacked <- as.numeric(regmatches(Sacked...Yards.Lost,regexpr('\\d+',Sacked...Yards.Lost)))
nfl2018$SackYdsLost <- abs(as.numeric(regmatches(Sacked...Yards.Lost,regexpr('\\-\\d+',Sacked...Yards.Lost))))
nfl2018$Sacked...Yards.Lost <- NULL

nfl2018$Penalties <- as.numeric(regmatches(Penalties...Yards,regexpr('\\d+',Penalties...Yards)))
nfl2018$PenaltyYdsLost <- abs(as.numeric(regmatches(Penalties...Yards,regexpr('\\-\\d+',Penalties...Yards))))
nfl2018$Penalties...Yards <- NULL

nfl2018$Touchdowns <- as.numeric(Touchdowns)
nfl2018$Rushing.TDs <- as.numeric(Rushing.TDs)
nfl2018$Passing.TDs <- as.numeric(Passing.TDs)
nfl2018$Other <- as.numeric(Other)

nfl2018$Turnovers <- as.numeric(Turnovers)

nfl2018$Fumbles <- as.numeric(regmatches(Fumbles...Lost,regexpr('\\d+',Fumbles...Lost)))
nfl2018$FumblesLost <- abs(as.numeric(regmatches(Fumbles...Lost,regexpr('\\-\\d+',Fumbles...Lost))))
nfl2018$Fumbles...Lost <- NULL

nfl2018$Int..Thrown <- as.numeric(Int..Thrown)
nfl2018$Punts...Avg <- NULL
nfl2018$Return.Yards <- NULL
nfl2018$PuntReturns <- as.numeric(regmatches(Punts...Returns,regexpr('\\d+',Punts...Returns)))
nfl2018$PuntReturnYds <- abs(as.numeric(regmatches(Punts...Returns,regexpr('\\-\\d+',Punts...Returns))))
nfl2018$KickReturns <- as.numeric(regmatches(Kickoffs...Returns,regexpr('\\d+',Kickoffs...Returns)))
nfl2018$KickReturnYds <- abs(as.numeric(regmatches(Kickoffs...Returns,regexpr('\\-\\d+',Kickoffs...Returns))))
nfl2018$Ints <- as.numeric(regmatches(Int....Returns,regexpr('\\d+',Int....Returns)))
nfl2018$IntReturnYds <- abs(as.numeric(regmatches(Int....Returns,regexpr('\\-\\d+',Int....Returns))))

nfl2018$Kicking <- NULL
nfl2018$Kicking.XPMade <- as.numeric(regmatches(Extra.Points,regexpr('\\d+',Extra.Points)))
nfl2018$Kicking.XPAtt <- as.numeric(regmatches(Extra.Points,regexpr('\\d+$',Extra.Points)))
nfl2018$Kicking.FGMade <- as.numeric(regmatches(Field.Goals,regexpr('\\d+',Field.Goals)))
nfl2018$Kicking.FGAtt <- as.numeric(regmatches(Field.Goals,regexpr('\\d+$',Field.Goals)))

nfl2018$RZScr <- as.numeric(regmatches(Red.Zone.Eff.,regexpr('\\d+',Red.Zone.Eff.)))
nfl2018$RZAtt <- as.numeric(regmatches(Red.Zone.Eff.,regexpr('\\d+$',Red.Zone.Eff.)))

nfl2018$GTGConv <- as.numeric(regmatches(Goal.to.Go.Eff.,regexpr('\\d+',Goal.to.Go.Eff.)))
nfl2018$GTGAtt <- as.numeric(regmatches(Goal.to.Go.Eff.,regexpr('\\d+$',Goal.to.Go.Eff.)))

nfl2018$Safeties <- NULL

colnames(nfl2018)[4] <- 'TOP'
colnames(nfl2018)[5] <- 'FirstDowns'
colnames(nfl2018)[6] <- 'FrstDwnRsh'
colnames(nfl2018)[7] <- 'FrstDwnPas'
colnames(nfl2018)[8] <- 'FrstDwnPen'

colnames(nfl2018)[11] <- 'TotalNetYds'
colnames(nfl2018)[12] <- 'TotalPlays'

colnames(nfl2018)[13] <- 'RushNetYds'
colnames(nfl2018)[14] <- 'RushAtt'
# NEED AVG RUSH
colnames(nfl2018)[15] <- 'PassNetYds'
# NEED AVG PASS
colnames(nfl2018)[16] <- 'TDs'
colnames(nfl2018)[17] <- 'TDsRush'
colnames(nfl2018)[18] <- 'TDsPass'
colnames(nfl2018)[19] <- 'TDsOthr'
colnames(nfl2018)[21] <- 'IntLost'

nfl2018$X3rd.Down.Conv <- NULL
nfl2018$X4th.Down.Conv <- NULL
nfl2018[20:26] <- NULL
# home: TRUE/FALSE, if team has @ in front
for (i in (1:nrow(nfl2018))) nfl2018$home[i] <- grepl(paste('@',nfl2018$Team[i],sep=''),nfl2018$Gm[i])

nfl2018 <- merge(nfl2018,unique(schedule2018[c('Week','Date')]),by = 'Date',all=FALSE)

detach(nfl2018)
sum(is.na(nfl2018))

#dput(colnames(nfl2018))
#https://stackoverflow.com/questions/5620885/how-does-one-reorder-columns-in-a-data-frame

nfl2018 <- nfl2018[c("Week", "Gm", "Date", "home", "Team", "TOP",
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

nfl2018 <- merge(nfl2018,matchups(schedule2018),by=c('Week','Team'))
nfl2018$Oppn <- as.character(nfl2018$Oppn)

nfl2018 <- merge(nfl2018,
                 data.frame(cbind(nfl2018[c('Week','Team')],nfl2018[c(6:29)],nfl2018[c(31:35,37:47)])),
                 by.x=c('Week','Oppn'),by.y=c('Week','Team'))

nfl2018$Oppn <- NULL

#Rename fields to "allowed"
colnames(nfl2018) <- c('Week', 'Team', 'Gm', 'Date', 'home', 'TOP', 'TotalPlays', 
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
