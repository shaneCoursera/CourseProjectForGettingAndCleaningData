
myrunx <- function() {
    
    #read the files pertaining to 'training'    
    dfTrain <- buildDataset("train/subject_train.txt", "train/y_train.txt", "train/X_train.txt")
    
    #read the files pertaining to 'test'
    dfTest <- buildDataset("test/subject_test.txt", "test/y_test.txt", "test/X_test.txt")
    
    #merge the training and test sets to create one dataset
    df1 <- rbind(dfTrain, dfTest)
    
    message("dim df1 11 = ", dim(df1))
    
    #extract only the measurements on the mean and standard deviation for each measurement
    df1 <- select(df1, Subject, Activity, matches("mean|std"))
    
    message("dim df1 22 = ", dim(df1))

    # convert '.', '..' and '...' in variable names to underscores
    finalnames <- names(df1)
    finalnames <- gsub("(\\.)+", "_", finalnames)
    finalnames <- gsub("_$", "", finalnames)
    finalnames <- tolower(finalnames)
    names(df1) <- finalnames

    #group by 'subject' and then 'activity'
    df2 <- group_by(df1, subject, activity)
    
    message("dim df2 11 = ", dim(df2))
    
    #create second independent tidy dataset with the average of 
    #each variable for each activity and each subject
    df2 <- summarize_each(df2, funs(mean))
    
    message("dim df2 22 = ", dim(df2))
    
    # write tidy dataset to output file
    write.table(df2, file="tidy_data_set.txt", row.names=FALSE)
    
    df2
}

buildDataset <- function(subjectFile, activityFile, featureFile) {
    library(dplyr)
    
    ##build subjectFrame            
    subjectFrame <- read.table(subjectFile, header=FALSE)
    names(subjectFrame) <- c("Subject")
    subjectFrame <- mutate(subjectFrame, Subject = as.factor(Subject))
    
    ##build activityFrame        
    activities <- read.table("activity_labels.txt", header=FALSE)
    activityNames <- activities[,2]
    
    activityFrame <- read.table(activityFile, header=FALSE)
    names(activityFrame) <- c("Activity")
    #convert numeric code of activity into string label
    activityFrame <- mutate(activityFrame, Activity = as.factor(activityNames[Activity]))
            
    ##build featureFrame                     
    features <- read.table("features.txt", header=FALSE)
    featureNames <- make.names(features[,2])
    
    featureFrame <- read.table(featureFile, header=FALSE)
    names(featureFrame) <- featureNames
    
    df <- data.frame(subjectFrame, activityFrame, featureFrame)
}

