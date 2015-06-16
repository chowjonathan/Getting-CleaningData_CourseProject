##Download file from url and unzip the zipped file 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="zipped.zip",method="curl")
unzip("zipped.zip")

## Start here if file has been downloaded and unzipped
upperwd <- getwd()

setwd("UCI HAR Dataset")
thiswd <- getwd()

## Load features and activities and set Column Names for Variables
features <- read.table("features.txt")
activities <-read.table("activity_labels.txt")
colnames<-c("Subject","Activity",as.character(features[,2]))

## Read test data
setwd("test")
x1<-read.table("X_test.txt")
y1<-read.table("Y_test.txt")
subject1<-read.table("subject_test.txt")
df1<-cbind(subject1,y1,x1)

## Read train data
setwd(thiswd)
setwd("train")
x2<-read.table("X_train.txt")
y2<-read.table("Y_train.txt")
subject2<-read.table("subject_train.txt")
df2<-cbind(subject2,y2,x2)

setwd(thiswd)

## Merge the training and test sets 
df<-rbind(df1,df2)

## Add Variable Names for All Columns
colnames(df)<-colnames

## Replace activity labels with the activity description
df$Activity<-sapply(df$Activity,function(elt) elt=activities[elt,2])

## Arrange data rows according to (1)Subject No. and (2)Activity Label
df<-df[order(df$Subject,df$Activity),]

## Compile Averages for each subject and activity and variable
library(data.table)
dt<-as.data.table(df)
dt_out<-dt[,lapply(.SD,mean),by=c("Subject","Activity")]

## Write the table into a file
setwd(upperwd)
write.table(dt_out,file="Averages.txt",row.name=FALSE)