###########################################################################
#
# This script was created for the course project for
# 'Coursera - Getting and Cleaning Data' course
#
# The main function is 'run_analysis'. To run the script 
# just type the following on the command-line:
#      run_analysis()
# 
# Running the above command will generate a text file named 'tidy_data_set.txt'
# if all the initial data files specified in the course in the current working 
# directory
# 
# The run_analysis function internally uses another function 'buildDataset'
# which is defined further below
#
###########################################################################
run_analysis <- function() {
    
    #read the files pertaining to 'training'    
    dfTrain <- buildDataset("train/subject_train.txt", "train/y_train.txt", "train/X_train.txt")
    
    #read the files pertaining to 'test'
    dfTest <- buildDataset("test/subject_test.txt", "test/y_test.txt", "test/X_test.txt")
    
    #merge the training and test sets to create one dataset
    df1 <- rbind(dfTrain, dfTest)
    
    #extract only the measurements on the mean and standard deviation for each measurement
    df1 <- select(df1, Subject, Activity, matches("mean|std"))
    
    # convert '.', '..' and '...' in variable names to underscores
    finalnames <- names(df1)
    finalnames <- gsub("(\\.)+", "_", finalnames)
    finalnames <- gsub("_$", "", finalnames)
    finalnames <- tolower(finalnames)
    names(df1) <- finalnames

    #group by 'subject' and then 'activity'
    df2 <- group_by(df1, subject, activity)
    
    #create second independent tidy dataset with the average of 
    #each variable for each activity and each subject
    df2 <- summarize_each(df2, funs(mean))
    
    # write tidy dataset to output file
    write.table(df2, file="tidy_data_set.txt", row.names=FALSE)
}

##################################################################
# 
# This function uses the three filenames passed in to build
# three dataFrames to hold info about 'Subject', 'Activity'
# and 'Features'. 
#
# It then merges the three dataFrames into one and returns it.
#
##################################################################
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

