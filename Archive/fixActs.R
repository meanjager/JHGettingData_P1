fixActs <- function(actTab, actDesc) {
     numActs <- dim(actTab)[1]
     numDescs <- dim(actDesc)[1]
     for(i in 1:dim(actTab)[1]) {
          actTab[i,1] <- as.character(actDesc[actTab[i,1],2])
     }
     return(actTab)
}