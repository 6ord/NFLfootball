wk_date <- data.frame('Week'= c(1:17),'Date'=as.Date('20170910','%Y%m%d'))
for(i in 1:17){
  wk_date[i,2] <- wk_date[i,2]+((i-1)*7)}

grid <- read.csv("C:/Users/trunk/Dropbox/Pro/Fantasy/2017_schedule.csv")

schedule <- data.frame(1,grid[,1],grid[,2])
names(schedule) <- c('Week','Team','Vs')

for(i in 2:17){
  schedule <- rbind(schedule,data.frame('Week'=i,'Team'=grid[,1],'Vs'=grid[,i+1]))
                    }
schedule <- merge(wk_date,schedule[which(substring(schedule$Vs,1,1)=='@'),],by='Week')
names(schedule) <- c('Week','Date','Road','Home')

monthu <- read.csv("C:/Users/trunk/Dropbox/Pro/Fantasy/2017_TNFMNF.csv",header=FALSE)
names(monthu) <- c('Week','Date','Road','Home')

schedule <- merge(monthu,schedule,by=c('Week','Road','Home'),all.y=TRUE)
schedule <- data.frame(schedule[1],'Date'=ifelse(is.na(schedule$Date.x),as.character(schedule$Date.y),as.character(schedule$Date.x)),schedule[2:3])
rm(dates)

rm(grid,wk_date,i,monthu)
#rm(schedule)

schedule <- data.frame(lapply(schedule,function(x){gsub('WSH','WAS',x)}))
schedule <- data.frame(lapply(schedule,function(x){gsub('JAX','JAC',x)}))

write.table(schedule, file = "C:/Users/trunk/Dropbox/Pro/Fantasy/2017_schedule_single.csv",
            append = FALSE, quote = FALSE, sep = ",",eol = "\n",
            row.names = FALSE, col.names = TRUE)


# PYTHON SCRAPE...Import back in below...


nfl2017 <- read.csv("C:/Users/trunk/Downloads/BigData/python/nflBoxscoreScrape.csv"
                              ,stringsAsFactors = FALSE
                    )

