################################################################
# LAST REVISION: 2014-12-19
# AUTHOR: JIPATSAA
# GOAL: Obtain for each Subject-Activity pair the mean value of each feature containing *(M/m)ean* or *(S/s)td*
# PRE:  1) The library data.table must be installed.
#       2) Internet conection is required since the data will be downloaded form the web
#       The data contains the movement captures (in the X Y and Z dimentions) of 30 Subjects and 
#       the corresponding activity associated to those movements
#       The data will be downloaded from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#       and unzip-ed and save in a NEW directory called ./data
# POST: The result has been saved into the file called "MeanAndStdValuesForEachSubject-Activity")
#       To recover it load("MeanAndStdValuesForEachSubject-Activity")
################################################################
library(data.table)
source("downloadFromURLAndUnzip.R") #function to create ./data dir and download and unzip the data
source("readTable.R") #function to read a file in the ./data/UCI HAR Dataset and dump it into a table
actualPath<-getwd()

#############################
# 1 Step: Download the data
#############################
# Downlod the data from the https://d396qusza40orc.cloudfront.net website 
# the file getdata_projectfiles_UCI HAR Dataset.zip will be download and unziped
# The information in this webpage was originally obtained from: http://archive.ics.uci.edu/ml/machine-learning-databases/00240/
# so if the previous webpage is down data could also be downloaded from
# fileUrl <-"http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

dataDir <- paste(actualPath,"data",sep="/")
dirDataSet<-paste(dataDir,"UCI\ HAR\ Dataset",sep="/")#once it will be downloaded it will create this directory

fileNameZIP <- "HARdata.zip"
filePathZIP <- paste(dataDir,fileNameZIP,sep="/")
downloadFromURLAndUnzip(fileUrl,workdirPath=dataDir,fileName=fileNameZIP)

# if there is any problem downloading from https://d396qusza40orc.cloudfront.net webpage try the original
if(!file.exists(filePathZIP))
{
  fileUrl <-"http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
  downloadFromURLAndUnzip(fileUrl,workdirPath=dataDir,fileName=fileNameZIP)
}

###############################################
# 2. OBTAIN GENERAL INFORMATION ABOUT THE ACTIVITY AND FEATURE CODES
###############################################
# OBTAIN ACTIVITY CODES AND DESCRIPTORS 
# (6 activities in total)
# (activity_labels.txt) file containing the activity codes and descriptors i.e. 1 WALKING 

activity<-readTable(dirDataSet,"activity_labels.txt")
actList<-as.character(activity$V2) #getting the Strings corresponding to the codes


# OBTAIN MOVEMENT FEATURES CODES AND DESCRIPTORS 
# (561 features in total)
# (features.txt) file containing the descriptors of the movement features i.e. 1 tBodyAcc-mean()-X

features<-readTable(dirDataSet,"features.txt")
features<-features$V2 #we just want the 2nd column


#OBTAIN TEST+TRAIN 
# (X_test.txt eta X_train.txt)
# TEST:  dim=number of observations: 2947, number of processed movement features: 561
# TRAIN: dim=number of observations: 7351, number of processed movement features: 561
############################
trainProcessedFeatures<-readTable(dirDataSet,"train/X_train.txt")
testProcessedFeatures<-readTable(dirDataSet,"test/X_test.txt")

############################
# 3. MERGE TRAIN+TEST
############################
corpProcessedFeatures<-rbind(trainProcessedFeatures,testProcessedFeatures) #Merge Test+Train obtaining the whole corpus (dataSet)


############################
# 4. ADD THE NAMES OF THE FEATURES
############################
names(corpProcessedFeatures)<-as.character(features) #adding the names of the features to each column values

# From all the features we want to process ONLY the ones refering to (M/m)ean and (S/s)tandard deviation features

############################
# 5. FILTER MEANS AND STD DEVIATIONS
############################
# get the indexes of the columns containing the words (M/m)ean or (S/s)td
meanInd<-grep("mean",names(corpProcessedFeatures),ignore.case=TRUE)
stdInd<-grep("std",names(corpProcessedFeatures),ignore.case=TRUE)
meanStdInd<-c(meanInd,stdInd)
meanStdInd<-sort(meanStdInd)

# filter those indx to obtain only the (M/m)ean and (S/s)td columns 
corpMeanStdProcFeat<-subset(corpProcessedFeatures,select=meanStdInd) #equivalent corpProcessedFeatures[meanStdInd]


#################################
# 6. OBTAIN INF. ABOUT THE SUBJECTS
#################################
# (30 different subjects)
# (subject_train.txt) file contains inf. about 21 subjects: 1  3  5  6  7  8 11 14 15 16 17 19 21 22 23 25 26 27 28 29 30
# (subject_test.txt) file contains inf. about 9 subjects: 2  4  9 10 12 13 18 20 24
#################################
trainfitx<-paste(dirDataSet,"train/subject_train.txt",sep="/")
trainSubjects<-read.table(trainfitx)
testfitx<-paste(dirDataSet,"test/subject_test.txt",sep="/")
testSubjects<-read.table(testfitx)
corpSubjs<-rbind(trainSubjects,testSubjects) #bind subjects inf. from test+train

#################################
# 7. OBTAIN CLASS INFORMATION (the class to guess)
#################################
# (Y_test.txt) file contains inf. about the class to guess in the clustering task
#################################
trainfitx<-paste(dirDataSet,"train/Y_train.txt",sep="/")
trainActivityCode<-read.table(trainfitx)
testfitx<-paste(dirDataSet,"test/Y_test.txt",sep="/")
testActivityCode<-read.table(testfitx)
trainActivityDescriptor<-apply(trainActivityCode,1,function(x) as.character(actList[x]))
testActivityDescriptor<-apply(testActivityCode,1,function(x) as.character(actList[x]))
corpActivityDescriptor<-c(trainActivityDescriptor,testActivityDescriptor)

###############################
# 8. MERGE SUBJ+FEATURES+ACTIVITY INF.
###############################
# Merge the information about the subjects with their corresponding processed movement features and the activity associated to the subject in that moment
corpProcFeatActCode<-cbind(corpSubjs,corpMeanStdProcFeat,corpActivityDescriptor)
names(corpProcFeatActCode)<-c("subject",as.character(names(corpMeanStdProcFeat)),"activity")

#remove all auxiliary variables
rm(features,trainSubjects,testSubjects,trainProcessedFeatures,testProcessedFeatures,trainActivityCode,testActivityCode,corpProcessedFeatures,corpActivityDescriptor,corpSubjs,meanInd,stdInd,meanStdInd)

################################
# 9. PROCESS THE DATA TO OBTAIN THE MEAN OF EACH FEAT. BY SUBJECT-ACTIVITY PAIR: 
#    1. Organize by Subject and Activity. 
#    2. Calculate the mean of each feature for each subject-activity pair
################################
DT<-data.table(corpProcFeatActCode)#convert the frame into a table to split it by subject and activity and apply the mean to each column

res<-DT[, lapply(.SD,mean), by=list(subject,activity)]#.SD stands for subset data and it is used to apply the mean to every column of the table

res[order(subject,activity)]#order de result by subject and actibity

write.table(res, file ="MeanAndStdValuesForEachSubject-Activity",row.names=FALSE,sep=" ") #write the result as tidy data

