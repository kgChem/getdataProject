# Assumptions: run_analysis.R is called from the working directory containing 
# the unzipped files form the UCI HAR dataset. The working directory contains
# features.txt, activity_labels.txt and two sub-directories: test and train 
# where the data resides
#
# Please see README.md for a description of how the script works
#
# Define which columns to extract. Only keep columns with mean() or std() functions
# in the name. See README.md for further details
getCols<-function(){
  neededCol<-read.table("features.txt",header=FALSE, col.names = c("index","name"),
                      colClasses=c("integer","character"))
  hasMean<-grepl("mean()",neededCol$name)
  hasStd<-grepl("std()",neededCol$name)
  keep<-(hasMean|hasStd)
  return(neededCol[keep,])
}
#
# This function reads the file activity_labels.txt to get the description of activities
getActivityNames<-function(){
  actNames<-read.table("activity_labels.txt",header=FALSE,col.names=c("index","activity"),
                       colClasses=c("integer","character"))
  return(actNames)
}


## Collect labels for columns and activities
dataCols<-getCols()
actNames<-getActivityNames()