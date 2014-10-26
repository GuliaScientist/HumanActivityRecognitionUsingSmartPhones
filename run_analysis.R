# ToDO :
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#setwd("C:/Users/rgulia/Documents/Coursera/Assignments/Getting and Cleaning Data")
# Step1. Merges the training and the test sets to create one data set.        

        #Read Training 
                
                #Training Data
                trainData <- read.table("./data/train/X_train.txt")
               
                # Training Label
                trainLabel <- read.table("./data/train/y_train.txt",col.names="label")
               
                # Training Subject
                trainSubject <- read.table("./data/train/subject_train.txt",col.names="subject")
        
        #Read Test 
                # Test Data
                testData <- read.table("./data/test/X_test.txt")
                
                #Test Label
                testLabel <- read.table("./data/test/y_test.txt",col.names="label")
                                        
                #Test Subject
                testSubject <- read.table("./data/test/subject_test.txt",col.names="subject")
                
        #Join Test and Training         
        data <- rbind(cbind(testSubject, testLabel, testData), 
                      cbind(trainSubject, trainLabel, trainData)) 
        


# Step2. Extracts only the measurements on the mean and standard deviation for each measurement. 
        #Read Features Data         
                featuresData <- read.table("./data/features.txt")
       
        # only retain features of mean and standard deviation 
                featuresMeanStd <- featuresData[grep("mean\\(\\)|std\\(\\)", featuresData$V2), ] 
                
        # select only the means and standard deviations from data 
        # increment by 2 because data has subjects and labels in the beginning 
                dataMeanStd <- data[, c(1, 2, featuresMeanStd$V1+2)] 
                

# Step3. Uses descriptive activity names to name the activities in 
# the data set
        #Read the labels        
        activity <- read.table("./data/activity_labels.txt")
        
        # replace labels in data with label names 
        dataMeanStd$label <- labels[dataMeanStd$label, 2] 

# Step4. Appropriately labels the data set with descriptive activity 
# names. 
        # Make a list of the current column names and feature names 
        goodColNames <- c("subject", "label", featuresMeanStd$V2) 
                
        # tidy that list 
        #removing non-alphabetic character and convert to lowercase 
        goodColNames <- tolower(gsub("[^[:alpha:]]", "", goodColNames)) 
        
        colnames(dataMeanStd) <- goodColNames
                
# Step5. Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 
                
        # find the mean for each combination of subject and label 
        aggrData <- aggregate(dataMeanStd[, 3:ncol(dataMeanStd)], 
                                  by=list(subject = dataMeanStd$subject,  
                                  label = dataMeanStd$label), 
                                  mean) 
                
# Write the data to the file.
        write.table(format(aggrData, scientific=T), "./tidyDataWithMeans.txt", 
                    row.names=F, col.names=F, quote=2) 
                
