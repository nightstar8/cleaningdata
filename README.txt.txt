## Instructions for project
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average 
   of each variable for each activity and each subject.

1. Read data from files (activity, subject and features files)
path <- file.path("UCI HAR Dataset")

acttest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
acttrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
subjtrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
subjtest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
featest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
featrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

2. Merge the training and the test sets to create one data set
# bind data by rows
subj <- rbind(subjtrain, subjtest)
act <- rbind(acttrain, acttest)
feat <- rbind(featrain, featest)

# name variables
names(subj)<-c("subject")
names(act)<- c("activity")
feanames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(feat)<- feanames$V2

# bind data by columns
combine <- cbind(subj, act)
merge <- cbind(feat, combine)

3. Extract only the measurements on the mean and standard deviation for each measurement
# subset names of selected features mean and standard deviation
cutfeanames<-feanames$V2[grep("mean\\(\\)|std\\(\\)", feanames$V2)]

# subset data frame by selected feature names
names<-c(as.character(cutfeanames), "subject", "activity" )
merge <-subset(merge,select=names)
 
4. Use descriptive activity names to name the activities in the data set
# Read descriptive activity names from "activity_labels.txt"
actlabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

# factorize `activity` using descriptive activity names**
merge$activity<-factor(merge$activity,labels=actlabels[,2])

5. Appropriately label the data set with descriptive variable name
# prefix t  is replaced by  time
# Acc is replaced by Accelerometer
# Gyro is replaced by Gyroscope
# prefix f is replaced by frequency
# Mag is replaced by Magnitude
# BodyBody is replaced by Body
names(merge)<-gsub("^t", "time", names(merge))
names(merge)<-gsub("^f", "frequency", names(merge))
names(merge)<-gsub("Acc", "Accelerometer", names(merge))
names(merge)<-gsub("Gyro", "Gyroscope", names(merge))
names(merge)<-gsub("Mag", "Magnitude", names(merge))
names(merge)<-gsub("BodyBody", "Body", names(merge))

6. Create a second,independent tidy data set and ouput it
library(dplyr);
data <-aggregate(. ~subject + activity, merge, mean)
data <-data[order(data$subject,data$activity),]
write.table(data, file = "data.txt",row.name=FALSE)
