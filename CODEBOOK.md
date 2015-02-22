#Course Project of Getting and Cleaning Data Course (Coursera)

>This codebook describes the variables, the data and the transformations performed for obtain the results
>The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. 
>The goal is to prepare a tidy data that can be used for later analysis.

##Data

The data linked to from the course website represent data collected from the accelerometers 
from the Samsung Galaxy S smartphone. A full description is available at the site where the 
data was obtained:[UCI Machine Learning Repository]. The data for the project can be downloaded from the link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. 

The data set represents a series of experiments carried out with a group of 30 volunteers
within an age bracket of 19-48 years. Each person performed six activities (labelled in the
`activity_labels.txt` file) wearing a smarthphone (Samsung Galaxy S II) on the waist.
Using the embedded accelerometer and gyroscope, a 3-axial linear acceleration and 3-axial angular velocity
at a constant rate of 50 Hz were captured. The dataset has been randomly partitioned into two sets, where 70%
of the volunteers was selected for generating the training data (inside the `./UCI HAR Dataset/train` folder), and 30%
the test data (inside the `./UCI HAR Dataset/test` folder).

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters 
and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window).
The sensor acceleration signal, which has gravitational and body motion components, was separated using a 
Butterworth low-pass filter into body acceleration and gravity. From each window, a vector of 
features was obtained by calculating variables from the time and frequency domain. The last is
expressed in a 561-feature vector (the name of each feature measured is in `features.txt`).

The test and train datasets (in `./UCI HAR Dataset/test` and `./UCI HAR Dataset/train` folders) comprises three types 
of text files that are used in the analysis:
 - A file referring the volunteer identification of each measurement: `subject_test.txt` and `subject_train.txt`.
 - A file with the activity performed during each measurement (codified as numbers): `Y_test.txt` and `Y_train.txt`. 
 - A bigger file with the 561-feature vector: `X_test.txt` and `X_train.txt`.
 
##The R script
 
 The course project says:
 
> You should create one R script called run_analysis.R that does the following: 
>  1. Merges the training and the test sets to create one data set.
>  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
>  3. Uses descriptive activity names to name the activities in the data set
>  4. Appropriately labels the data set with descriptive variable names. 
>  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
 The R script named `run_analysis.R` prepares a tidy dataset from the raw dataset. 
 The raw dataset must be in a unzip folder named `UCI HAR Dataset` in the working directory, and package "dplyr" must be installed. The procedure
 follows a different order from the one specified in the list above in order to simplify some steps like filtering.
 
 1. The first section of the code reads the text files containing the data using the `read.table()` function.
 This data is assigned to a variable with the same name as the text file. To avoid messing up the data with factors, the
 argument 'stringsAsFactors=FALSE' is used.
 
 >>activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
features<-read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test<-read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train<-read.table("./UCI HAR Dataset/train/Y_train.txt")
 
 2. The data.frames containing activity labels, subjects and features labels (corresponding to features.txt, activity_labels.txt, Y_test.txt and Y_train.txt),
 are converted to vectors by subsetting (using `[]`).
 
 >>features<-features[,2]
subject_test<-subject_test[,1]
Y_test<-Y_test[,1]
subject_train<-subject_train[,1]
Y_train<-Y_train[,1]
activity_labels<-activity_labels[,2]
 
 3. Activity data is converted to factors to assign self-descriptive labels, using `as.factor()` and `levels()` functions.
 
 >>Y_test<-as.factor(Y_test)
Y_train<-as.factor(Y_train)
levels(Y_test)<-activity_labels
levels(Y_train)<-activity_labels
 
 4. Two data frames are created joining subject, activity and measurements for each group (test and train), using `data.frame()` function. Using this data.frames, a unique dataset for both groups is created using `cbind()` function.
 
 >>test<-data.frame(subject=subject_test,activity=Y_test, X_test)
train<-data.frame(subject=subject_train, activity=Y_train, X_train)
dataset<-rbind(test, train)

 5. Before filtering data to maintain only the measurements relative to mean() and std() values, 
 an appropriate label is assigned to the columns of the dataset (to make filtering easy). The labels are included in 'features.txt' file, however, this
 includes characters that can`t be used as names in R (the characters "-" and "()"). This characters are replaced by a more addecuated ones
 using the function `gsub()`. A vector with the features names is created to perform corrections.
 
 >>dataset_column_names<-c("Subject", "Activity", features)
 dataset_column_names<-gsub("\\(\\)", "" , dataset_column_names)
dataset_column_names<-gsub("-", "_" , dataset_column_names)

 6. Using the same `gsub()` function, self-descriptive names for features are generated, replacing the following characters:
  * t prefix is replaced by time
  * f prefix is replaced by frequency
  * Acc is replaced by Accelerometer
  * Gyro is replaced by Gyroscope
  * Mag is replaced by Magnitude
  * BodyBody is replaced by Body
 
 
 
 >>dataset_column_names<-gsub("^t", "time", dataset_column_names)
dataset_column_names<-gsub("^f", "frequency", dataset_column_names)
dataset_column_names<-gsub("Acc", "Accelerometer" , dataset_column_names)
dataset_column_names<-gsub("Gyro", "Gyroscope" , dataset_column_names)
dataset_column_names<-gsub("Mag", "Magnitude" , dataset_column_names)
dataset_column_names<-gsub("BodyBody", "Body" , dataset_column_names)

 7. Names are assigned to each column of the dataset using `names()` function.
 
 >>names(dataset)<-dataset_column_names
 
 8. Using the column names, de dataset is filtered to maintain only the measurements relative
 to mean() and std(). The function `grepl()` is used to generate the filters. A 'filter1' is used to
 select only the columns with "Subject", "Activity", "mean" of "std" in the column name. A 'filter2' is 
 again used to eliminate from the generated subset the columns relative to "meanFreq".
 
 >>filter1<-grepl("Subject|Activity|mean|std", names(dataset))
dataset<-dataset[,filter1]
filter2<-grepl("meanFreq", names(dataset))
dataset<-dataset[,!filter2]

 9. Finally, a subset of the tidy dataset generated in 8 is created. This subset comprises only the average of each 
variable for each activity and each subject. The packadge "dplyr" is used to achieve this. The subset is saved to a 
text file `using write.table()` function (with the argument row.name=FALSE).

 >>library(dplyr)
subset<-dataset %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
write.table(subset, file="subset.txt", row.name=FALSE)

##The variables
 
 The variables used in the script are described below:
 
  - `activity_labels`: vector for activity labeling
  - `features`: vector with the 561-features vector labels
  - `subject_test`: vector with subject identification for test group
  - `X_test`: dataframe with measurements for test group
  - `Y_train`: vector with activity identification for test group
  - `subject_train`: vector with subject identification for train group
  - `X_train`: dataframe with measurements for train group
  - `Y_train`: vector with activity identification for train group
  - `test`: dataframe with the complete test data (subject, activity and measurements)
  - `train`: dataframe with the complete train data (subject, activity and measurements)
  - `dataset`: dataframe joining test and train data
  - `dataset_column_names`: character vector with self-descriptive names for features
  - `filter1`: logical vector to select columns referring "subject", "activity", "mean" of "std"
  - `filter2`: logical vector to eliminate columns relative to "meanFreq"
  - `subset`: dataframe with the final data, averaging each measurement by each subject and each activity
 
 
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
  
In the subset ('subset.txt') created only mean() and std() values are present, and the features names were changed to be more descriptive:
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
[here]:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 