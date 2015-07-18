#cleaning environnement
rm(list=objects())

# STEP 1
# Merges the training and the test sets to create one data set.

# set the working directory where the dataset reside (change it accordingly)
setwd("~/Documents/polasoft/R/datascience/project/UCI HAR Dataset")

# loading each set of data
X1 = read.table("train/X_train.txt",colClasses="numeric")
X2 = read.table("test/X_test.txt",colClasses="numeric")
# merging
X = rbind(X1,X2)
#removing unneeded variables
rm(X1,X2)

# idem for activities
y1 = read.table("train/y_train.txt",colClasses="numeric")
y2 = read.table("test/y_test.txt",colClasses="numeric")
y = rbind(y1,y2)
rm(y1,y2)

# idem for subjects
S1 = read.table("train/subject_train.txt",colClasses="numeric")
S2 = read.table("test/subject_test.txt",colClasses="numeric")
S = rbind(S1,S2)
names(S)<-'Subject'
rm(S1,S2)


# STEP 2
# Extracts only the measurements on the mean and standard deviation for each measurement

# Searching for '-mean(' or '-std(' in the features names

features = read.table("features.txt",colClasses=c("numeric","character"))
# get the indices
indices = grep("/*-std\\(|-mean\\(",features[,'V2'],perl=TRUE) 

extracted = X[,indices]
rm(X);


# STEP 3
# Uses descriptive activity names to name the activities in the data set
activities = read.table("activity_labels.txt",colClasses=c("numeric","character"))
activityNames = factor(activities[,'V2'],levels=activities[,'V2'])
namedY = factor(y$V1)
levels(namedY)=levels(activityNames)

# adding activities and subjects to the main data set

X = cbind(S,namedY,extracted)

rm(S,namedY,extracted)

# STEP 4
# Appropriately labels the data set with descriptive variable names. 
labels = grep("/*-std\\(|-mean\\(",features[,'V2'],perl=TRUE,value=TRUE)
names(X)<-c('Subject','Activity',labels)


# STEP 5
# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.

# with the help from the site at:
# https://github.com/dgrapov/TeachingDemos/blob/master/Demos/dplyr/hands_on_with_dplyr.md
library(dplyr)

XAvrg <- group_by(X,Subject,Activity) %>%
    select(one_of(labels)) %>%
    summarise_each(funs(mean(.,na.rm=TRUE)))

# writing the text file to upload in the current working dir
write.table(XAvrg,"XAvrg.txt",row.names=FALSE)

