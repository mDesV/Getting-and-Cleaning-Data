#Course Project of Getting and Cleaning Data Course (Coursera)

>This codebook describes the variables, the data and the transformations performed for obtain the results
>The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. 
>The goal is to prepare a tidy data that can be used for later analysis.

##Data

The data linked to from the course website represent data collected from the accelerometers 
from the Samsung Galaxy S smartphone. A full description is available at the site where the 
data was obtained: [UCI Machine Learning Repository]. The data for the project can be downloaded from the link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. 

The data set: The experiment have been carried out with a group of 30 volunteers (`./UCI HAR Dataset/test/subject_test.txt and ./UCI HAR Dataset/train/subject_train.txt  `)
within an age bracket of 19-48 years. Each person performed six activities (`activity_labels.txt`) wearing a smarthphone (Samsung Galaxy S II) on the waist.
Using the embedded accelerometer and gyroscope, a 3-axial linear acceleration and 3-axial angular velocity
at a constant rate of 50 Hz were captured. The obtained dataset has been randomly partitioned into two sets, where 70%
of the volunteers was selected for generating the training data (`./UCI HAR Dataset/train`), and 30%
the test data (`./UCI HAR Dataset/test`).

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters 
and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window).
The sensor acceleration signal, which has gravitational and body motion components, was separated using a 
Butterworth low-pass filter into body acceleration and gravity. From each window, a vector of 
features was obtained by calculating variables from the time and frequency domain. The last is
expressed in a 561-feature vector (`features.txt`).

 
##Project
 
 The course project says:
 
> You should create one R script called run_analysis.R that does the following: 
>  1. Merges the training and the test sets to create one data set.
>  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
>  3. Uses descriptive activity names to name the activities in the data set
>  4. Appropriately labels the data set with descriptive variable names. 
>  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##R script `run_analysis.R` 

 The folder downloaded has to be in the Working Directory 
 The procedure follows a different order from the one specified in the list above in order to simplify some steps, but they are called and numbered following the instructions in order to facilitate the corrections.
 
 1. Get the data: In this first step the program unzip the downloaded file using the `unzip()` function.
 ```
 >unzip(zipfile="getdata-projectfiles-UCI HAR Dataset.zip")
 ```
 
 2. Read the data: Here the program reads the text files using the `read.table()`function and assign the result to a variable with the same name as the text file.
 
 ```
 >dataActivity_labels<-read.table(file="./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
 >dataFeatures<-read.table(file="./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)
 
 >dataSubject_test<-read.table(file="./UCI HAR Dataset/test/subject_test.txt",stringsAsFactors = FALSE)
 >dataX_test<-read.table(file="./UCI HAR Dataset/test/X_test.txt",stringsAsFactors = FALSE)
 >dataY_test<-read.table(file="./UCI HAR Dataset/test/y_test.txt",stringsAsFactors = FALSE)
  
 >dataSubject_train<-read.table(file="./UCI HAR Dataset/train/subject_train.txt",stringsAsFactors = FALSE)
 >dataX_train<-read.table(file="./UCI HAR Dataset/train/X_train.txt",stringsAsFactors = FALSE)
 >dataY_train<-read.table(file="./UCI HAR Dataset/train/y_train.txt",stringsAsFactors = FALSE)
 ```
 
 
 After the data.frames `dataSubject_test, dataY_test, dataSubject_train and dataY_train` are converted to vectors using `[]`.
 
 
 ```
 >dataSubject_test<-dataSubject_test[,1]
 >dataY_test<-dataY_test[,1]
 >dataSubject_train<-dataSubject_train[,1]
 >dataY_train<-dataY_train[,1]
 ```

 3. Merges the training and the test sets to create one data set: First two data.frame are created `dataTest and dataTrain` using the `data.frame`function and joining joining subject, activity and measurements for each one.
  
 ```
 >dataTest<-data.frame(Subject=dataSubject_test,Activity=dataY_test,dataX_test)
 >dataTrain<-data.frame(Subject=dataSubject_train,Activity=dataY_train,dataX_train)
 ```
  
 After this two data.frame are joined by rows using `rbind`function.
  
  ```  
  >data<-rbind(dataTest,dataTrain)
  ```
  
  
 4. Uses descriptive activity names to name the activities in the data set: Activity data is converted to factors to assign self-descriptive labels, using `as.factor()` and `levels()` functions.
 
 ``` 
 >data[,2]<-as.factor(data[,2])
 >dataActivity_labels<-dataActivity_labels[,2]
 >levels(data[,2])<-dataActivity_labels
 ```
  
 5. Appropriately labels the data set with descriptive variable names: the assignment of values and propitiate label to the columns is done here for make the filter easy, the labe are in `features.txt`.
 This file includes characters that can`t be used as names in R (`"-" and "()"`).
 using the function `gsub()`.
  
  ```
  >dataFeatures<-dataFeatures[,2]
  >dataFeatures<-gsub("-","_",dataFeatures)
  >dataFeatures<-gsub("\\(\\)","",dataFeatures)
  ```
  
  In addition `gsub()`function is used for make changes at the features renaming it with descriptive names. 
 
  * t= time
  * f= frequency
  * Acc= Accelerometer
  * Gyro= Gyroscope
  * Mag= Magnitude
  * BodyBody= Body  
  
 ```
 >dataFeatures<-gsub("^t","time",dataFeatures)
 >dataFeatures<-gsub("^f","frequency",dataFeatures)
 >dataFeatures<-gsub("BodyBody","Body", dataFeatures)
 >dataFeatures<-gsub("Gyro","Gyroscope",dataFeatures)
 >dataFeatures<-gsub("Acc","Acceleration",dataFeatures)
 >dataFeatures<-gsub("Mag","Magnitude",dataFeatures)
 ```

 And the names are assigned to each column of the dataset using `names()` function.
 
 ```
 >names(data)[3:dim(data)[2]]<-dataFeatures
 ```
 
 6. Extracts only the measurements on the mean and standard deviation for each measurement: The column names of data is used to search the measurements relative
  to mean() and std(). The function `grep()` is used to generate the filter, a vector with the positions found.
  A dataframe are created taking the "Subject" and "Activity" rows (1,2) and the positions founds.

 ```
 >position<-grep("mean_|std_|mean$|std$",names(data))
 >DATA<-data[c(1,2,position)] 
 ```

 7. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject:Finally, a subset of the dataset `DATA` is created. This subset is created using the packadge `dplyr` and contains only the average of each 
  variable for each activity and each subject. The subset is saved to a text file using `write.table()` function (with the argument row.name=FALSE).

 ```
 >library(dplyr)
 >results<-DATA %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
 
 >write.table(results,file="results.txt",row.name=FALSE)
 ```

##Variables

Variables in the script:
 
  - `dataActivity_labels`: vector for activity labeling
  - `dataFeatures`: vector with the 561-features vector labels
  - `dataSubject_test`: vector with subject identification for test group
  - `dataX_test`: dataframe with measurements for test group
  - `dataY_train`: vector with activity identification for test group
  - `dataSubject_train`: vector with subject identification for train group
  - `dataX_train`: dataframe with measurements for train group
  - `dataY_train`: vector with activity identification for train group
  - `dataTest`: dataframe with the complete test data (subject, activity and measurements)
  - `dataTrain`: dataframe with the complete train data (subject, activity and measurements)
  - `data`: dataframe joining test and train data
  - `dataActivity_labels`: character vector with self-descriptive names for features
  - `position`: vector with the columns which contains "mean" or "std"
  - `DATA`:dataframe with the measurements on the mean and standard deviation for each measurement
  - `results`: dataframe with the data averaging each measurement by each subject and each activity

 
 
 The raw data considers the following variables (unitless, because they are normalized):
 
 >The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals
 tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a 
 constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass 
 Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration 
 signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) 
 using another low pass Butterworth filter with a corner frequency of 0.3 Hz. Subsequently, the body 
 linear acceleration and angular velocity were derived in time to obtain Jerk signals 
 (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional 
 signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, 
 tBodyGyroMag, tBodyGyroJerkMag). Finally a Fast Fourier Transform (FFT) was applied to 
 some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, 
 fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).These signals were 
 used to estimate variables of the feature vector for each pattern:  '-XYZ' is used to denote 3-axial 
 signals in the X, Y and Z directions.
 >  - tBodyAcc-XYZ
 >  - tGravityAcc-XYZ
 >  - tBodyAccJerk-XYZ
 >  - tBodyGyro-XYZ
 >  - tBodyGyroJerk-XYZ
 >  - tBodyAccMag
 >  - tGravityAccMag
 >  - tBodyAccJerkMag
 >  - tBodyGyroMag
 >  - tBodyGyroJerkMag
 >  - fBodyAcc-XYZ
 >  - fBodyAccJerk-XYZ
 >  - fBodyGyro-XYZ
 >  - fBodyAccMag
 >  - fBodyAccJerkMag
 >  - fBodyGyroMag
 >  - fBodyGyroJerkMag
 >
 >From these signals a set if variables were estimated:
 >  - mean(): Mean value
 >  - std(): Standard deviation
 >  - mad(): Median absolute deviation 
 >  - max(): Largest value in array
 >  - min(): Smallest value in array
 >  - sma(): Signal magnitude area
 >  - energy(): Energy measure. Sum of the squares divided by the number of values. 
 >  - iqr(): Interquartile range 
 >  - entropy(): Signal entropy
 >  - arCoeff(): Autorregresion coefficients with Burg order equal to 4
 >  - correlation(): correlation coefficient between two signals
 >  - maxInds(): index of the frequency component with largest magnitude
 >  - meanFreq(): Weighted average of the frequency components to obtain a mean frequency
 >  - skewness(): skewness of the frequency domain signal 
 >  - kurtosis(): kurtosis of the frequency domain signal 
 >  - bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
 >  - angle(): Angle between to vectors.
  
##Results
  In the subset ('results.txt') created only mean() and std() values are present, and the features names were changed to be more descriptive:
  - timeBodyAccelerometer-XYZ
  - timeGravityAccelerometer-XYZ
  - timeBodyAccelerometerJerk-XYZ
  - timeBodyGyroscope-XYZ
  - timeBodyGyroscopeJerk-XYZ
  - timeBodyAccelerometerMagnitude
  - timeGravityAccelerometerMagnitude
  - timeBodyAccelerometerJerkMagnitude
  - timeBodyGyroscopeMagnitude
  - timeBodyGyroscopeJerkMagnitude
  - frequencyBodyAccelerometer-XYZ
  - frequencyBodyAccelerometerJerk-XYZ
  - frequencyBodyGyroscope-XYZ
  - frequencyBodyAccelerometerMagnitude
  - frequencyBodyAccelerometerJerkMagnitude
  - frequencyBodyGyroscopeMagnitude
  - frequencyBodyGyroscopeJerkMagnitude
  

 
[UCI Machine Learning Repository]:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#