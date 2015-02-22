#Course Project-Getting and Cleaning Data-Coursera
#M. Des
#22 Feb 2015

#Get the data
  #Unzip the file
  unzip(zipfile="getdata-projectfiles-UCI HAR Dataset.zip")
  
  
#Read the data
  dataActivity_labels<-read.table(file="./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
  dataFeatures<-read.table(file="./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)
  
  dataSubject_test<-read.table(file="./UCI HAR Dataset/test/subject_test.txt",stringsAsFactors = FALSE)
  dataX_test<-read.table(file="./UCI HAR Dataset/test/X_test.txt",stringsAsFactors = FALSE)
  dataY_test<-read.table(file="./UCI HAR Dataset/test/y_test.txt",stringsAsFactors = FALSE)
  
  dataSubject_train<-read.table(file="./UCI HAR Dataset/train/subject_train.txt",stringsAsFactors = FALSE)
  dataX_train<-read.table(file="./UCI HAR Dataset/train/X_train.txt",stringsAsFactors = FALSE)
  dataY_train<-read.table(file="./UCI HAR Dataset/train/y_train.txt",stringsAsFactors = FALSE)
  
  dataSubject_test<-dataSubject_test[,1]
  dataY_test<-dataY_test[,1]
  dataSubject_train<-dataSubject_train[,1]
  dataY_train<-dataY_train[,1]
  

#1. Merges the training and the test sets to create one data set
  dataTest<-data.frame(Subject=dataSubject_test,Activity=dataY_test,dataX_test)
  dataTrain<-data.frame(Subject=dataSubject_train,Activity=dataY_train,dataX_train)
  
  data<-rbind(dataTest,dataTrain)

#3. Uses descriptive activity names to name the activities in the data set  
  data[,2]<-as.factor(data[,2])
  dataActivity_labels<-dataActivity_labels[,2]
  levels(data[,2])<-dataActivity_labels
  
#4. Appropriately labels the data set with descriptive variable names. 
  dataFeatures<-dataFeatures[,2]
  dataFeatures<-gsub("-","_",dataFeatures)
  dataFeatures<-gsub("\\(\\)","",dataFeatures)
  
  dataFeatures<-gsub("^t","time",dataFeatures)
  dataFeatures<-gsub("^f","frequency",dataFeatures)
  dataFeatures<-gsub("BodyBody","Body", dataFeatures)
  dataFeatures<-gsub("Gyro","Gyroscope",dataFeatures)
  dataFeatures<-gsub("Acc","Acceleration",dataFeatures)
  dataFeatures<-gsub("Mag","Magnitude",dataFeatures)
  
  names(data)[3:dim(data)[2]]<-dataFeatures

#2. Extracts only the measurements on the mean and standard deviation for each measurement
  position<-grep("mean_|std_|mean$|std$",names(data))
  DATA<-data[c(1,2,position)]
  
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  library(dplyr)
  results<-DATA %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
  
  write.table(results,file="results.txt",row.name=FALSE)
  