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

## Body of execution
setupProject("Proj1")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
destFile <- "UCIHARDataSet"
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

## Get X_test.txt and X_train.txt, add activities and subjects and label
## Create connections for the test files
##xTstCon <- file(paste(destDataDir, "/UCI HAR Dataset/test/X_test.txt", sep=""))
##xTstTab <- read.table(xTstCon)
##tstActCon <- file(paste(destDataDir, "/UCI HAR Dataset/test/Y_test.txt", sep=""))
##tstSubjCon <- file(paste(destDataDir, "/UCI HAR Dataset/test/subject_test.txt", sep=""))

## Create connections for the train files
##xTrnCon <- file(paste(destDataDir, "/UCI HAR Dataset/train/X_train.txt", sep=""))
##xTrnTab <- read.table(xTrnCon)
##trnActCon <- file(paste(destDataDir, "/UCI HAR Dataset/train/Y_test.txt", sep=""))
##trnSubjCon <- file(paste(destDataDir, "/UCI HAR Dataset/test/subject_train.txt", sep=""))

## Connections for the columns
##featCon <- file(paste(destDataDir, "/UCI HAR Dataset/features.txt", sep=""))



## xCombTab <- rbind(X_testTab, X_trainTab)
