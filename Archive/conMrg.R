## Create all of the file connections that will be required
## xTstCon <- file(paste(destDataDir, "/UCI HAR Dataset/test/X_test.txt", sep=""))
## tstActCon <- file(paste(destDataDir, "/UCI HAR Dataset/test/Y_test.txt", sep=""))
## tstSubjCon <- file(paste(destDataDir, "/UCI HAR Dataset/test/subject_test.txt", sep=""))
## featCon <- file(paste(destDataDir, "/UCI HAR Dataset/features.txt", sep=""))
## actDescCon <- file(paste(destDataDir, "/UCI HAR Dataset/activity_labels.txt", sep=""))

xTstCon <- conMgr(destDataDir, "/UCI HAR Dataset/test/X_test.txt", "xTstCon", conList=NULL, action="open" )
conMgr(destDataDir, "/UCI HAR Dataset/test/Y_test.txt", "tstActCon", conList=NULL, action="open" )
conMgr(destDataDir, "/UCI HAR Dataset/test/subject_test.txt", "tstSubjCon", conList=NULL, action="open" )
conMgr(destDataDir, "/UCI HAR Dataset/features.txt", "featCon", conList=NULL, action="open" )
conMgr(destDataDir, "/UCI HAR Dataset/activity_labels.txt", "actDescCon", conList=NULL, action="open" )


xTstTab <- read.table(xTstCon)
tstActTab <- read.table(tstActCon)
tstSubjTab <- read.table(tstSubjCon)
featTab <- read.table(featCon)
actDescTab <- read.table(actDescCon)


## Create activity descriptions


xTstTab <- cbind(tstActTab, xTstTab)
xTstTab <- cbind(tstSubjTab, xTstTab)

## Add the activity and subject_test
featTab[,2] <- as.character(featTab[,2])
featTab <- rbind(c(1,"activity"), featTab)
featTab <- rbind(c(1,"subject"), featTab)

colnames(xTstTab) <- featTab[,2]

## Function to replace activity IDs with friendly names. Returns a simple
## table of activity names that aligns with the rest of the data.
fixActs <- function(actTab, actDesc) {
     numActs <- dim(actTab)[1]
     numDescs <- dim(actDesc)[1]
     for(i in 1:dim(actTab)[1]) {
          actTab[i,1] <- as.character(actDesc[actTab[i,1],2])
     }
     return(actTab)
}

## Close all connections. Specify action as one of 'open', 'close'
## or 'closeall'. The open action appends the conName to the list, conList
## to facilitate easy close-out.
conMgr <- function(fPath, file, conName, conList, action="open") {
     switch(action,
            open = { fileCons <<- c(fileCons, conName) 
                     return(assign(conName, file(paste(fPath, file, sep=""))))},
            close = { close(conName) },
            closeall = { for(i in 1:length(conList)) { close(conList[i]) } },
            create = { return(file(paste(fPath, "/", file, "-", Sys.time(), sep="")))
            })
}