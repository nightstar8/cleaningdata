
# Read files
path <- file.path("UCI HAR Dataset")

acttest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
acttrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
subjtrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
subjtest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
featest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
featrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

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

# extracts mean and standard deviation
cutfeanames<-feanames$V2[grep("mean\\(\\)|std\\(\\)", feanames$V2)]
names<-c(as.character(cutfeanames), "subject", "activity" )
merge <-subset(merge,select=names)

# adding descriptive activity names
actlabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
merge$activity<-factor(merge$activity,labels=actlabels[,2])

# adding descriptive variable names
names(merge)<-gsub("^t", "time", names(merge))
names(merge)<-gsub("^f", "frequency", names(merge))
names(merge)<-gsub("Acc", "Accelerometer", names(merge))
names(merge)<-gsub("Gyro", "Gyroscope", names(merge))
names(merge)<-gsub("Mag", "Magnitude", names(merge))
names(merge)<-gsub("BodyBody", "Body", names(merge))

# create tidy data set
library(dplyr);
data <-aggregate(. ~subject + activity, merge, mean)
data <-data[order(data$subject,data$activity),]
write.table(data, file = "data.txt",row.name=FALSE)

# create code book
library(knitr)
knit("codebook.Rmd", output = NULL);