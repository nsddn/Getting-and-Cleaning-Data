##Check to see if the directory exists, if not, then create it.

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

##set the working directory to the data after unzipping the contents to a directory


setwd("~/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

##Clear the global data environment

rm(list=ls())
##read all the files from the data directors

files<-list.files("./", recursive=TRUE)
files

## creating objects to read the dataset

dataActivityTest<-read.table(file.path("./", "test", "Y_test.txt"), header = FALSE)

dataActivityTrain<-read.table(file.path("./", "train", "Y_train.txt"), header = FALSE)

dataSubjectTest<-read.table(file.path("./", "test", "subject_test.txt"), header = FALSE)

dataSubjectTrain<-read.table(file.path("./", "train", "subject_train.txt"), header = FALSE)

dataFeaturesTest<-read.table(file.path("./", "test", "X_test.txt"), header = FALSE)

dataFeaturesTrain<-read.table(file.path("./", "train", "X_train.txt"), header = FALSE)

##See the properties of each of the dataset created above
str(dataActivityTest)

str(dataActivityTrain)

str(dataSubjectTrain)

str(dataSubjectTest)

str(dataFeaturesTest)

str(dataFeaturesTrain)

##Merging the train and test data set to create one data set

dataSubject<-rbind(dataSubjectTrain,dataSubjectTest)

dataActivity<-rbind(dataActivityTrain,dataActivityTest)

dataFeatures<-rbind(dataFeaturesTrain,dataFeaturesTest)

##setting names to variables

names(dataSubject)<-c("Subject")

names(dataActivity)<-c("Activity")

dataFeaturesNames<-read.table(file.path("./", "features.txt"), head=FALSE)

names(dataFeatures)<-dataFeaturesNames$V2

##Merge columns to get the data frame Data for all the data

dataCombine<-cbind(dataSubject, dataActivity)

Data<-cbind(dataFeatures, dataCombine)

##Extract data for only the measurements on the mean and standard deviation for each measurement
subDataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

##subset the data frame Data by selected names by Features

selectedNames<-c(as.character(subDataFeaturesNames), "Subject", "Activity")
Data<-subset(Data, select=selectedNames)

##the sturcture of the data frame Data is

str(Data)

##Read descriptive activity names from "activity_labels.txt"

activitylabels<-read.table(file.path("./", "activity_labels.txt"), header=FALSE)

head(Data$Activity, 30)

names(Data)<-gsub("^t","time", names(Data))
names(Data)<-gsub("^f","frequency", names(Data))
names(Data)<-gsub("Acc","Accelerometer", names(Data))
names(Data)<-gsub("Gyro","Gyroscope", names(Data))
names(Data)<-gsub("Mag","Magitude", names(Data))
names(Data)<-gsub("Mag","Magnitude", names(Data))
names(Data)<-gsub("BodyBody","Body", names(Data))
names(Data)

library(plyr)
Data2<-aggregate(.~ Subject + Activity, Data, mean)
Data2<-Data2[order(Data2$Subject, Data2$Activity), ]

write.table(Data2, file="tidydata.txt", row.name=FALSE)

library(knitr)
knit2html("codebook.Rmd")


