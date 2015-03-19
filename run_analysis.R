# Assumptions: run_analysis.R is called from the working directory containing 
# the unzipped files form the UCI HAR dataset. The working directory contains
# features.txt, activity_labels.txt and two sub-directories: test and train 
# where the data resides. Uses the dplyr package.
#
# Please see README.md for a description of how the script works
#
# Define which columns to extract. Only keep columns with mean() or std() functions
# in the name. See README.md for further details

library(dplyr)
library(data.table)

getCols<-function(){
  neededCol<-read.table("features.txt",header=FALSE, col.names = c("index","name"),
                      colClasses=c("integer","character"))
  hasMean<-grepl("mean()",neededCol$name)
  hasStd<-grepl("std()",neededCol$name)
  keep<-(hasMean|hasStd)
  return(neededCol[keep,])
}


# This function reads the file activity_labels.txt to get the description of activities
getActivityNames<-function(){
  actNames<-read.table("activity_labels.txt",header=FALSE,col.names=c("index","activity"),
                       colClasses=c("integer","character"))
  return(actNames)
}


# The function readData reads the data from the files passed in creates a data frame. 
# SubjectFile = who performed the activity. YFile = activity that was being performed 
# XFile = data values for all columns. keepCol = df created by getCols() 

readData<-function(SubjectFile,XFile,YFile,keepCol){
  df<-read.table(XFile,header=FALSE)
  df<-df[,keepCol$index]
  # Now attach the activity column to the left side
  activity<-read.table(YFile, header=FALSE)
  df<-cbind(activity,df)
  # Now attach the subject column to the left side
  subject<-read.table(SubjectFile, header=FALSE, colClasses=c("factor"))
  df<-cbind(subject,df)
  # Now make the column names human readable
  colnames(df)<-c("subject","activity",keepCol$name)
  return(df)
}


# Build the merged data frame by calling functions See README.md for full description

buildData<-function(){
  if ((!file.exists("./features.txt"))|(!file.exists("./test/X_test.txt"))){
    stop("Error: Data files and subdirectories are not in the cwd!")
  }
  dataCols<-getCols()
  #read the two data frames and concatenate them
  testdf<-readData("./test/subject_test.txt","./test/X_test.txt","./test/y_test.txt",
                   dataCols)
  traindf<-readData("./train/subject_train.txt","./train/X_train.txt","./train/y_train.txt",
                    dataCols)
  mergeddf<-rbind(testdf,traindf)
  # Use the integer activities to make a column with descriptive text for the activity
  actNames<-getActivityNames()
  activityName<-sapply(mergeddf[,2],function(x){actNames[x,2]})
  activityName<-as.data.frame(activityName)
  mergeddf<-cbind(mergeddf,activityName)
  # Remove the numeric code activity column now we're done with it
  mergeddf<-mergeddf[,-2]
  # Lastly, clean up the ColumnNames
  setnames(mergeddf, colnames(mergeddf), gsub("-","_",colnames(mergeddf)))
  setnames(mergeddf, colnames(mergeddf), gsub("BodyBody","Body",colnames(mergeddf)))
  setnames(mergeddf, colnames(mergeddf), gsub("\\(\\)", "", colnames(mergeddf)))
  return(mergeddf)
}

# summarizeData provides the mean for each variable grouped by each activity 
# for each subject
summarizeData<-function(df){
  # Group the data by subject and activityName
  sdf<-group_by(df, subject, activityName)
  # Calculate the mean of every measurement
  summary<-summarise_each(sdf,funs(mean), tBodyAcc_mean_X:fBodyGyroJerkMag_meanFreq)
  return(summary)
}

# Main script execution
mydata<-buildData()
summaryData<-summarizeData(mydata)
write.table(summaryData, file="data_summary.txt", row.name=FALSE, col.names=TRUE)
