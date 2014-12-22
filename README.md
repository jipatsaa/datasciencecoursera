datasciencecoursera
===================
=====================================================================
Based on data from: 
Human Activity Recognition Using Smartphones Dataset
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory www.smartlab.ws

=====================================================================


=====================================================================
 LAST REVISION: 2014-12-19
 AUTHOR: JIPATSAA

 GOAL: Obtain for each subject-activity pair the mean values of the Mean and Standard deviation features from original dataset

 PRE-REQUISITES:  1) The library data.table must be installed.
           2) Internet conection is required since the data will be downloaded form the web
           The data contains the movement captures (in the X Y and Z dimentions) of 30 Subjects and 
            the corresponding activity associated to those movements
           The data will be downloaded from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
       and unzip-ed and save in a NEW directory called ./data
 POST: The result has been saved into the file called "MeanAndStdValuesForEachSubject-Activity.txt”)

=====================================================================

To execute run: run_analysis.R
             Two additional files containing R functions are included:
- “downloadFromURLAndUnzip.R" 
- “readTable.R" 
             
Output: MeanAndStdValuesForEachSubject-Activity.txt
NOTE: It will create a folder called ./data in which it will download the datasets

The README is divided as follows:

1. Information about the original dataSet
2. Information about the process to get the mean values from the mean and standard deviation features from the original dataset

=====================================================================
1. Information about the data (obtained from the documentation of the original dataset)
=====================================================================

The dataset includes the following files:

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

=====================================================================
2. Information about the process to get the mean values from the mean and standard deviation features from the original dataset.
=====================================================================

Steps pursued to obtain for each subject-activity pair the mean values of the Mean and Standard deviation features from original dataset:

=====================================================================
 1 Step: DOWNLOAD THE DATA

Downlod the data from the https://d396qusza40orc.cloudfront.net website 
he file getdata_projectfiles_UCI HAR Dataset.zip will be download and unziped
("https://d396qusza40orc.cloudfront.net/getdata_projectfiles_FUCI HAR Dataset.zip”)

- NOTE: The information in this webpage was originally obtained from: http://archive.ics.uci.edu/ml/machine-learning-databases/00240/
so if the previous webpage is down data will be downloaded from:
"http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI HAR Dataset.zip"


=====================================================================
 2 Step: OBTAIN GENERAL INFORMATION ABOUT THE ACTIVITY AND FEATURE CODES

 OBTAIN ACTIVITY CODES AND DESCRIPTORS 
(6 activities in total)
(activity_labels.txt) file containing the activity codes and descriptors i.e. 1 WALKING 
 OBTAIN MOVEMENT FEATURES CODES AND DESCRIPTORS 
(561 features in total)
(features.txt) file containing the descriptors of the movement features i.e. 1 tBodyAcc-mean()-X
 OBTAIN TEST+TRAIN 
(X_test.txt eta X_train.txt)
TEST:  dim=number of observations: 2947, number of processed movement features: 561
TRAIN: dim=number of observations: 7351, number of processed movement features: 561


=====================================================================
 3 Step: MERGE TRAIN+TEST

corpProcessedFeatures<-rbind(trainProcessedFeatures,testProcessedFeatures) #Merge Test+Train obtaining the whole corpus (dataSet)


=====================================================================
 4 Step: ADD THE NAMES OF THE FEATURES

=====================================================================
 5 Step: FILTER MEANS AND STD DEVIATIONS

From all the features we want to process ONLY the ones reffering to (M/m)ean and (S/s)tandard deviation features

=====================================================================
 6 Step: OBTAIN INF. ABOUT THE SUBJECTS

(30 different subjects)
(subject_train.txt) file contains inf. about 21 subjects: 1  3  5  6  7  8 11 14 15 16 17 19 21 22 23 25 26 27 28 29 30
(subject_test.txt) file contains inf. about 9 subjects: 2  4  9 10 12 13 18 20 24


=====================================================================
 7 Step: OBTAIN CLASS INFORMATION (the class to guess)

 (Y_test.txt) file contains inf. about the class to guess in the clustering task


=====================================================================
 8 Step: MERGE SUBJ+FEATURES+ACTIVITY INF.

Merge the information about the subjects with their corresponding processed movement features and the activity associated to the subject in that moment

remove all auxiliary variables
rm(features,trainSubjects,testSubjects,trainProcessedFeatures,testProcessedFeatures,trainActivityCode,testActivityCode,corpProcessedFeatures,corpActivityDescriptor,corpSubjs,meanInd,stdInd,meanStdInd)

=====================================================================
 9 Step: PROCESS THE DATA TO OBTAIN THE MEAN OF EACH FEAT. BY SUBJECT-ACTIVITY PAIR: 
  - 1. Organize by Subject and Activity. 
  - 2. Calculate the mean of each feature for each subject-activity pair
  - 3. name the calculated features
  - 4. order the results by subject and activity

=====================================================================
 10 Step: WRITE THE DATA IN A TXT FILE
