# Getting and Cleaning Data Course Project

This directory contains the files needed by the Coursera 
"Getting and Cleaning Data" course project.

- run_analysis.R is the R script 
- CodeBook.md is the code book describing the variables.

## Project instructions are below :

The data linked to from the course website represent data collected from the 
accelerometers from the Samsung Galaxy S smartphone. A full description 
is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

 You should create one R script called run_analysis.R that does the following. 

    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement. 
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive variable names. 

    From the data set in step 4, creates a second, independent tidy data set with
    the average of each variable for each activity and each subject.

## run_analysis.R explanations

The R script should be located where the "UCI HAR Dataset.zip" file is extracted.
The working directory is set line 8 with a call to setwd().

### STEP 1
#### Merges the training and the test sets to create one data set.

To merge the training and test sets, the test and train data are loaded each in one data.frame,
using read.table(), then the two corresponding data.frame are merged using rbind().

The temporay data.frames are removed to free the memory as the become unneeded.

### STEP 2
####  Extracts only the measurements on the mean and standard deviation for each measurement

# Searching for '-mean(' or '-std(' in the features names

features = read.table("features.txt",colClasses=c("numeric","character"))
# get the indices
indices = grep("/*-std\\(|-mean\\(",features[,'V2'],perl=TRUE) 

extracted = X[,indices]
rm(X);


### STEP 3
####  Uses descriptive activity names to name the activities in the data set
activities = read.table("activity_labels.txt",colClasses=c("numeric","character"))
activityNames = factor(activities[,'V2'],levels=activities[,'V2'])
namedY = factor(y$V1)
levels(namedY)=levels(activityNames)

# adding activities and subjects to the main data set

X = cbind(S,namedY,extracted)

rm(S,namedY,extracted)

### STEP 4
####  Appropriately labels the data set with descriptive variable names. 
labels = grep("/*-std\\(|-mean\\(",features[,'V2'],perl=TRUE,value=TRUE)
names(X)<-c('Subject','Activity',labels)


### STEP 5
####  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# with the help from the site at:
# https://github.com/dgrapov/TeachingDemos/blob/master/Demos/dplyr/hands_on_with_dplyr.md
library(dplyr)

XAvrg <- group_by(X,Subject,Activity) %>%
    select(one_of(labels)) %>%
    summarise_each(funs(mean(.,na.rm=TRUE)))

# writing the text file to upload in the current working dir
write.table(XAvrg,"XAvrg.txt",row.names=FALSE)



The script file is heavily commented and hopefully understandable.
