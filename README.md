# getdataProject
For Coursera getdata-012 class project

## Assumptions: 
Run_analysis.R is called from the working directory containing 
the unzipped files form the UCI HAR dataset. The working directory contains
features.txt, activity_labels.txt and two sub-directories: test and train 
where the data resides

## Logical Flow of the Script
1. Define which columns to extract by parsing features.txt
2. Read defined columns from train/x_train.txt into a dataframe
3. Add the activity column to that dataframe using activity names
4. Add the subject ID to the dataframe
5. Repeat steps 2-4 on the test/ data
6. Concatenate the two dataframes
7. Output a tidy data set with averages

## Reading features.txt
Two nice overviews of string functions in R can be found at [GastonSanchez](http://gastonsanchez.com/Handling_and_Processing_Strings_in_R.pdf) and [Wikibooks](http://en.wikibooks.org/wiki/R_Programming/Text_Processing).  The function getCols define which columns to extract. Only keep columns with names containg with mean() or std(). This will include  with names with intervening characters such as meanFreq() but not aggolmeration columns lik angle(Z,gravityMean)

## Reading activity_labels.txt
The function getActivityNames reads this file to create a dataframe describing the activities corresponding to the numbered activity.


