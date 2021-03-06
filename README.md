# GetDataProject
For Coursera getdata-012 class project

## Assumptions: 
Run_analysis.R is called from the working directory containing 
the unzipped files form [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](the UCI HAR dataset). The working directory contains
features.txt, activity_labels.txt and two sub-directories: test and train 
where the data resides. Summary of the data by subject and by activity requires the package dplyr() to be installed and uses data.table

# Logical Flow of the Script
1. Define which columns to extract by parsing features.txt
2. Read defined columns from train/x_train.txt into a dataframe
3. Add the activity column to that dataframe
4. Add the subject ID to the dataframe
5. Repeat steps 2-4 on the test/ data
6. Concatenate the two dataframes
7. Output a tidy data set with human readable names
8. Write a summary dataframe

## Reading features.txt
Two nice overviews of string functions in R can be found at [GastonSanchez](http://gastonsanchez.com/Handling_and_Processing_Strings_in_R.pdf) and [Wikibooks](http://en.wikibooks.org/wiki/R_Programming/Text_Processing).  The function getCols define which columns to extract. Only keep columns with names containg with mean() or std(). This will include  with names with intervening characters such as meanFreq() but not aggolmeration columns like angle(Z,gravityMean)

## Reading activity_labels.txt
The function getActivityNames reads this file to create a dataframe describing the activities corresponding to the numbered activity.

## Reading The Data in sub directories
The function readData reads the data from the files passed in and creates a data frame. SubjectFile  is the file telling the subject who performed the activity. YFile is the label for the activity that was being performed in the original numeric format XFile is the actual data values for all columns. keepCol is the df created by getCols() that specifys which columns to keep. The files XFile, YFile, and SubjectFile all need to have the relative path specified (e.g. ./test/X_test.txt).  This function should be invoked twice, once for the test data and once for the training data. The function returns the resulting data frame with the human readable column labels.

## Merging the two data frames
The script buildData brings all the functions together. First it calls getCols() to make a data frame **dataCols** which contains the index and name of the columns to keep. Then buildData calls the readData function twice to build two data frames, **testdf** for the test data and **traindf** for the training data. These two data frames are concatenated together to make the **mergeddf** data frame. Finally, use the function getActivityNames to and use that data to add the activityName column to the mergeddf from the integers in activity column to make a more human readable format.

# Averaging and Tidying the Data by subject by activity
##The criteria for tidy data
1. Exactly one measured variable per column
2. Each observation is in a unique row
3. One table for every kind of variable
4. If multiple tables, should include column that allows them to be linked

So after the script runs, we have one measured variable per column. Taking the mean values gives one observation per row per subject per activity. The data is put into one table from multiple tables at the start.

##SummarizeData
The summarizeData function takes as an argument, the dataframe constructed by buildData(). The function then uses **group_by** from the **dplyr** package to group the data by subject and activity as requested. The function summarise each then applies the mean function to each column between tBodyAccmeanX and fBodyGyroJerkMagmeanFreq
