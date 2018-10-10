

numPastWks <- 4

# priorGms <- "sum up a team's last X games. Next phase."

priorWks <- aggPriorWks(nfl2018,numPastWks)

priorWks <- cbind(priorWks[1],
                  GP=sapply(priorWks$Team,function(x)
                    {nrow(nfl2018[which(nfl2018$Team==x &
                                        nfl2018$Week %in% c((max(nfl2018$Week)-numPastWks+1):(max(nfl2018$Week)))),])
                    }),
                  priorWks[2:length(priorWks)]
                  )

attach(priorWks)

priorWks$TDsPassPerGame <- TDsPass/GP
priorWks$YdsPerPass <- PassYds/PassAtt
priorWks$FrstDwnByPass <- FrstDwnPas/FirstDowns

priorWks$TDsRushPerGame <- TDsRush/GP
priorWks$YdsPerRush <- RushYds/RushAtt
priorWks$FrstDwnByRush <- FrstDwnRsh/FirstDowns

# Rush/Pass Ratio plays, 1st downs in last X games
# priorWks$FrstDwnRshPasRatio <- FrstDwnRsh/FrstDwnPas
# priorWks$FrstDwnPasProp <- FrstDwnPas/FirstDowns
# priorWks$TDsRushPassRatio <- TDsRush/TDsPass
# priorWks$TDsPassRatio <- TDsPass/numPastWks

priorWks$TDsPassAllowedPerGame <- TDsPassAllowed/GP
priorWks$YdsAllowedPerPass <- PassYdsAllowed/PassPlaysDefended
priorWks$FrstDwnByPassAllowed <- FrstDwnPasAllowed/FirstDownsAllowed

priorWks$TDsRushAllowedPerGame <- TDsRushAllowed/GP
priorWks$YdsAllowedPerRush <- RushYdsAllowed/RushPlaysDefended
priorWks$FrstDwnByRushAllowed <- FrstDwnRshAllowed/FirstDownsAllowed

# Rush/Pass Ratio plays, 1st downs in last X games
# priorWks$FrstDwnAllowedRshPasRatio <- FrstDwnRshAllowed/FrstDwnPasAllowed
# priorWks$FrstDwnPasProp <- FrstDwnPas/FirstDowns
# priorWks$TDsAllowedRushPassRatio <- TDsRushAllowed/TDsPassAllowed
# priorWks$TDsPassRatio <- TDsPass/numPastWks

# fumbles per play ran in last X games
priorWks$FumbLostPerPlay <- FumblesLost/TotalPlays
priorWks$FumbForcedPerPlay <- FumblesForced/PlaysDefended

#Ints and Sacks
priorWks$IntLostPerPass <- IntLost/PassAtt
priorWks$IntPerPassPlayDefended <- Ints/PassPlaysDefended
priorWks$SackedPerPassAtt <- Sacked/PassAtt
priorWks$SacksPerPassPlayDefended <- Sacks/PassPlaysDefended

#Kick & Punt Returns
priorWks$YdsPerReturn <- (KickReturnYds+PuntReturnYds)/(KickReturns+PuntReturns)
priorWks$YdsPerReturnAllowed <- (KickReturnYdsAllowed+PuntReturnYdsAllowed)/(KickOffs+Punts)

#FGs & XPs allowed per game
priorWks$FGAttDefendedPerGame <- Kicking.FGDefended/GP
priorWks$XPAttDefendedPerGame <- Kicking.XPDefended/GP

# Matchup category factor for matches (usually product of team's and opponent's against)
detach(priorWks)
# rm(thisWk)

thisWk <- buildThisWk(5,schedule2018)
#build team and oppn metrics, cbind with thisWk after

tw <- data.frame(lapply(thisWk,function(x){gsub('@','',x)}))

colnames(thisWk)
colnames(tw)
#verify
sum(is.na(priorWks))
sum(is.na(thisWk))
sum(is.na(tw))

# Team P TDs per Gm
# Team Yds per Pass Att.
# Team P% 1st Dwn
# Team R TDs per Gm
# Team Yds per Rush
# Team R% 1st Dwn

thisWk$PassTD <- as.numeric(getMetric(priorWks,tw$Team,85))* 
                 as.numeric(getMetric(priorWks,tw$Oppn,91))
thisWk$YdsPerPass <- as.numeric(getMetric(priorWks,tw$Team,86))*
                     as.numeric(getMetric(priorWks,tw$Oppn,92))
thisWk$Pass1stDwn <- as.numeric(getMetric(priorWks,tw$Team,87))*
                     as.numeric(getMetric(priorWks,tw$Oppn,93))

thisWk$RushTD <- as.numeric(getMetric(priorWks,tw$Team,88))*
                 as.numeric(getMetric(priorWks,tw$Oppn,94))
thisWk$YdsPerRush <- as.numeric(getMetric(priorWks,tw$Team,89))*
                     as.numeric(getMetric(priorWks,tw$Oppn,95))
thisWk$Rush1stDwn <-as.numeric(getMetric(priorWks,tw$Team,90))*
                    as.numeric(getMetric(priorWks,tw$Oppn,96))

thisWk$RZPctDiff <- (as.numeric(getMetric(priorWks,tw$Team,25))/as.numeric(getMetric(priorWks,tw$Team,26)))-(1-
                    (as.numeric(getMetric(priorWks,tw$Oppn,67))/as.numeric(getMetric(priorWks,tw$Oppn,68)))
                    )
#RZscore/trips - (1-RZscoreallow/RZdef)

thisWk$Sacks <- as.numeric(getMetric(priorWks,tw$Team,102))+
                as.numeric(getMetric(priorWks,tw$Oppn,101))
thisWk$TODiff <- as.numeric(getMetric(priorWks,tw$Team,27))+as.numeric(getMetric(priorWks,tw$Team,75))-
                 as.numeric(getMetric(priorWks,tw$Oppn,33))+as.numeric(getMetric(priorWks,tw$Oppn,35))
thisWk$FFmbls <- as.numeric(getMetric(priorWks,tw$Team,98))+
                 as.numeric(getMetric(priorWks,tw$Oppn,97))
thisWk$Intpns <- as.numeric(getMetric(priorWks,tw$Team,100))+
                 as.numeric(getMetric(priorWks,tw$Oppn,99))

#returning
thisWk$KickPuntReturns <- as.numeric(getMetric(priorWks,tw$Team,103))*
                          as.numeric(getMetric(priorWks,tw$Oppn,104))
#kicking
thisWk$FGXPPct <- (as.numeric(getMetric(priorWks,tw$Team,41))+as.numeric(getMetric(priorWks,tw$Team,43)))/
                  (as.numeric(getMetric(priorWks,tw$Team,42))+as.numeric(getMetric(priorWks,tw$Team,44)))
#Weak Pass D, Strong Rush D & RZ D
thisWk$FGAttExpected <- as.numeric(getMetric(priorWks,tw$Oppn,105))
thisWk$XPAttExpected <- as.numeric(getMetric(priorWks,tw$Oppn,106))

thisWkRank <- thisWk
for(i in 4:length(thisWk)){thisWkRank[i] <- rank(-thisWk[i],ties.method='average')}

thisWkRankAvg <- as.data.frame(cbind(Week=thisWk$Week
                              ,Team=thisWk$Team
                              ,Oppn=thisWk$Oppn
                              #,QBWRTE=sapply(as.numeric(thisWkRank[4:6,10]),function(x){rowMeans(x)})
                              ,QBWRTE=round(rowMeans(thisWkRank[,c(4:6,10)]),2)
                              ,RB=round(rowMeans(thisWkRank[,c(7:10)]),2)
                              ,DEF=round(rowMeans(thisWkRank[,c(11:15)]),2)
                              ,DLLB=round(rowMeans(thisWkRank[,c(11:13)]),2)
                              ,DB=round(rowMeans(thisWkRank[,c(12,14)]),2)
                              ,KR=round(rowMeans(thisWkRank[,c(16:18)]),2)
                              ),stringsAsFactors = FALSE)
thisWkRankAvg[4:9] <- lapply(thisWkRankAvg[4:9],FUN=as.numeric)

