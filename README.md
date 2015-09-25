# CourseProjectForGettingAndCleaningData

This document describes the script and codebook developed for the course project
for the Coursera - Getting and Cleaning Data course.

The main script is named 'run_analysis.R'. It can be run as long as the
Samsung data files described in the course project is present in your working directory.

## Step 1 : Merge the training and test sets to create one data set

### Step 1.1 : Function to build dataset from input files

In the run_analysis.R, a function named 'buildDataset' was added to take in the
three input files with information about subject, activity and feature observations
and return a data.frame.

```{r}
buildDataset <- function(subjectFile, activityFile, featureFile) {
  ...
}
```

The buildDataset function has the following blocks:

### Step 1.1.1 : Build subjectFrame
This code fragment reads the contents of the text file containing the subject identifiers (1-30)
for the current dataset and creates a dataFrame named 'subjectFrame' with one column named 'Subject'.

```{r}
    subjectFrame <- read.table(subjectFile, header=FALSE)
    names(subjectFrame) <- c("Subject")
    subjectFrame <- mutate(subjectFrame, Subject = as.factor(Subject))
```

### Step 1.1.2 : Build activityFrame
This code fragment reads the contents of the text file containing the activity identifiers (1-6)
for the current dataset and creates a dataFrame named 'activityFrame' with one column named 'Activity'.
Each row in activityFrame contains the activity performed by the subject in the corresponding row in the 
subjectFrame. 

The activityFile contains the numbers (1-6). The actual activity labels are in 'activity_labels.txt'.
The numeric codes are converted into the corresponding label and stored back into the 'Activity' column.

```{r}
    activities <- read.table("activity_labels.txt", header=FALSE)
    activityNames <- activities[,2]
    
    activityFrame <- read.table(activityFile, header=FALSE)
    names(activityFrame) <- c("Activity")
    #convert numeric code of activity into string label
    activityFrame <- mutate(activityFrame, Activity = as.factor(activityNames[Activity]))
```

### Step 1.1.3 : Build featureFrame
This code fragment reads the contents of the text file containing the observations 
for the current dataset and creates a dataFrame named 'featureFrame' with one column for
each of the 561 features. Each row in featureFrame contains the features observed or calculated
for the subject in the corresponding row in the subjectFrame.

The feature labels are in 'features.txt'. These labels are used to set the names of the
columns in the featureFrame.

```{r}
    features <- read.table("features.txt", header=FALSE)
    featureNames <- make.names(features[,2])
    
    featureFrame <- read.table(featureFile, header=FALSE)
    names(featureFrame) <- featureNames
```

Since the data in the three textfiles is already in the correct order( ie the activity and
the features for a subject in the subjectFile was in the same row in the activityFile and
featureFile), we can just use the data.frame command to combine the three frames into one.

```{r}
df <- data.frame(subjectFrame, activityFrame, featureFrame)
```
The number of columns in the 'df' dataFrame will be 563 (subject, activity and the 561 features) 

Step 1.2 : Call 'buildDataSet' function from 'myrunx' function

myrunx is the main function. It makes two calls to buildDataset
function with the appropriate filenames for the 'test' and 'train' sets.

Both datasets have the same number of columns, but different number of rows.
So the rbind (row-bind) command was used to join the two datasets into one.

```{r}
 df1 <- rbind(dfTrain, dfTest)
```

## Step 2 : Extract only the measurements on the mean and standard deviation for each measurement. 

The select function from dplyr package is used to retain only the columns
whose names contain either 'mean' or 'std'.

```{r}
df1 <- select(df1, Subject, Activity, matches("mean|std"))
```

## Step 3 : Use descriptive activity names to name the activities in the data set
This was already done in Step 1.1.2 above in the 'buildDataset' function

## Step 4: Appropriately labels the data set with descriptive variable names

The original variable names were read in from the 'features.txt' file in step 1.1.3.
The names were updated to convert '.' (dot) characters to '_' (underscore) characters.
Consecutive occurrences like '..' and '...' were converted to a single underscore character. The '.' characters at
the end of variable names were removed altogether. According to the week 4 lecture of the course on "Editing Text Variables (10-46)", underscores improve readablity. Also, the case of the variable names was changed to lower case.

Some of the variables are listed below in the table:

|Original name in data files    | New name in data.frame|
|-------------------------------|----------------------|
|fBodyGyro.meanFreq...X  | fbodygyro_meanfreq_x |            
|fBodyAccMag.mean..      | fbodyaccmag_mean     |                 
|fBodyAccMag.std..       | fbodyaccmag_std      |            
|fBodyAccMag.meanFreq..  | fbodyaccmag_meanfreq |            
|angle.X.gravityMean.    | angle_x_gravitymean  |

## Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The following two lines of code create a new dataFrame df2 that groups all the observations in df1
by 'subject' and 'activity' and calculates the mean of each of the features

```{r}
    df2 <- group_by(df1, subject, activity)
    
    df2 <- summarize_each(df2, funs(mean))
```

And finally, the following line writes the tidy dataset as a text file.

```{r}
write.table(df2, file="tidy_data_set.txt", row.names=FALSE)
```

## Tidy Data Set

The data set that is created by the script has one row for each combination of subject and activity,
giving 180 (ie 30 * 6) rows. There aren't any missing values. Values are not used as variable names.

Each of the feature averages is in its own column. Data which spread across different files in the original 
directory have been converted to this data making it amenable for further analysis.

For this reason, this dataset can be considered as a *tidy data set*









