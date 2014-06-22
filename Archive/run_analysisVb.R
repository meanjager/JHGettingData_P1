## Get Peer Reveiw data
## Setup project if necessary
setupProject <- function(project) {
     switch(Sys.info()["sysname"],
          Darwin = {workingDir <- "/Users/matthew/Documents/002 - Cloud/Dropbox/Code/JHData/GettingData/"},
          Windows = {workingDir <- 'c:\\users\\matthew\\my documents\\002 - Cloud\\Dropbox\\Code\\JHData\\GettingData\\'},
          Linux = {workingDir <- '/users/matthew/Documents/002 - Cloud/Dropbox/Code/JHData/GettingData"'})
          setwd(workingDir)
     
     if(!file.exists(paste(getwd(), project, sep = ""))) {
          dir.create(project)
          workingDir <- paste(workingDir, project, sep = "")
          setwd(workingDir)
     }
}

## Download source data if required. Read the file into a destination object. 
## Return the destination object and filename containing the source data.
## Unzip data if a zip file.
xGetData <- function(fileUrl, dl=FALSE, destFName, type, struct="df", ...) {
     destFNameDate <- paste(destFName, "-", Sys.Date(), ".", type, sep="")
     if(dl == TRUE) {       
          download.file(fileUrl, destFNameDate, method="curl")
     }
          switch(type,
               csv = { switch(struct,
               df = { destObj <- read.csv(paste(destFName, "*", sep=""))
                    }, dt = { destObj <- fread(paste(destFName, "*", sep="")) })
               },
               xml = { library(XML)
                    destObj <- xmlTreeParse(destFName, useInternal = TRUE, ...)
               },
               xlsx = { library(xlsx)
                    destObj <- read.xlsx(destFName, ...)
               }, 
               if(type=="zip") {
                    ## Not sure which file to bind at this stage
                    ## so just return true.
                    destObj <- TRUE
                    destDataDir <- paste(destFName, Sys.Date(), sep="-")
                    QUnZip <- readline("Press 'y' to unzip.")
                    if(QUnZip == 'y') {
                         ## Unzip to a directory without extension
                         ## Check if already unzipped today
                         print(destDataDir)
                         if(file.exists(destDataDir)) {
                              print("Data already extracted today")
                         } else {  
                              unzip(destFNameDate, exdir=destDataDir, overwrite = FALSE)
                              print("Source data was unzipped")
                              }
                    }
               })
     ## Return a vector containing the data object and the destination file
     ## name for use by subsequent functions.
     return(c(destObj, destDataDir))
}

## Check whether the source data has already been downloaded at any time
xFileExist <- function(destFName) {
     dataFiles <- list.files() 
     for(i in length(dataFiles)) {
          if(grepl(paste(destFName, "*", sep=""), dataFiles[i], 
                   ignore.case=TRUE) == TRUE) {
               return(TRUE)
          } else { return(FALSE) }
     }
}

## Function to replace activity IDs with friendly names. Returns a simple
## table of activity names that aligns with the rest of the data.
## Implements TASK 3
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

## Body of execution
setupProject("Proj1")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
destFile <- "UCIHARDataSet"
fileCons <- as.character()
## Check if download exists. If not, download it and save with date.
if(xFileExist(destFile) == FALSE) {
     gdReturn <- xGetData(fileUrl, dl=TRUE, destFile, "zip")
     destDataDir <- gdReturn[2]
} else { 
     xDL <- readline("A download already exists. Type, 'y' to re-download.")
     if(xDL == 'y') {
          gdReturn <- xGetData(fileUrl, dl=TRUE, destFile, "zip")
     } else { gdReturn <- xGetData(fileUrL, dl=FALSE, destFile, "zip")
              destDataDir <- gdReturn[2] 
     }
}

## Create 'shared' connections. These are the IDs and are shared across
## both the test and train data sets. Read in as tables.
featCon <- conMgr(destDataDir, "/UCI HAR Dataset/features.txt", "featCon", conList=NULL, action="open" )
actDescCon <- conMgr(destDataDir, "/UCI HAR Dataset/activity_labels.txt", "actDescCon", conList=NULL, action="open" )
featTab <- read.table(featCon)
actDescTab <- read.table(actDescCon)
tidyOut <- conMgr(destDataDir, "tidyOut", action="create")


## TEST TEST TEST 
## Create all 'test' connections we need. 
xTstCon <- conMgr(destDataDir, "/UCI HAR Dataset/test/X_test.txt", "xTstCon", conList=NULL, action="open" )
tstActCon <- conMgr(destDataDir, "/UCI HAR Dataset/test/Y_test.txt", "tstActCon", conList=NULL, action="open" )
tstSubjCon <- conMgr(destDataDir, "/UCI HAR Dataset/test/subject_test.txt", "tstSubjCon", conList=NULL, action="open" )

## Read the test data in
xTstTab <- read.table(xTstCon)
tstActTab <- read.table(tstActCon)
tstSubjTab <- read.table(tstSubjCon)

## run fixActs() to replace activity numbers with friendly names
tstActTab <- fixActs(tstActTab, actDescTab)

## Add the activity and subject columns to the data. Subject in first column
xTstTab <- cbind(tstActTab, xTstTab)
xTstTab <- cbind(tstSubjTab, xTstTab)

## Add subject_test and activity rows to the featTab and then
## use featTab to create the column headings
featTab[,2] <- as.character(featTab[,2])
featTab <- rbind(c(1,"activity"), featTab)
featTab <- rbind(c(1,"subject"), featTab)
colnames(xTstTab) <- featTab[,2]

## TRAIN TRAIN TRAIN
## Create all 'train' connections we need. 
xTrnCon <- conMgr(destDataDir, "/UCI HAR Dataset/train/X_train.txt", "xTrnCon", conList=NULL, action="open" )
trnActCon <- conMgr(destDataDir, "/UCI HAR Dataset/train/Y_train.txt", "trnActCon", conList=NULL, action="open" )
trnSubjCon <- conMgr(destDataDir, "/UCI HAR Dataset/train/subject_train.txt", "trnSubjCon", conList=NULL, action="open" )

## Read the train data in
xTrnTab <- read.table(xTrnCon)
trnActTab <- read.table(trnActCon)
trnSubjTab <- read.table(trnSubjCon)

## run fixActs() to replace activity numbers with friendly names (TASK 3)
trnActTab <- fixActs(trnActTab, actDescTab)

## Create activity descriptions
xTrnTab <- cbind(trnActTab, xTrnTab)
xTrnTab <- cbind(trnSubjTab, xTrnTab)

## Use featTab to create the column headings (TASK 4)
## featTab has already been configured correctly in the TEST phase. 
colnames(xTrnTab) <- featTab[,2]

## Create one data frame containing all the observations (Task 1)
comboTab <- rbind(xTstTab, xTrnTab)

## Get a list of the columns with mean or std in the name
colList <- sort(c(1,2, grep("*[mM]ean*", featTab[,2]), grep("*std*", featTab[,2])))

## Subset combo for the columns we're interested in and melt to a tall 
## data set.
comboMS <- comboTab[, colList]
comboMSNarrow <- melt(comboMS, id=c("subject", "activity"))

## reshape and summarize the data. Take the average of each combination of 
## subject and activity for the data we have selected.
tidyMeans <- dcast(comboMSNarrow, subject + activity ~ variable, mean)
write.table(tidyMeans, tidyOut, sep=",",row.names=FALSE)