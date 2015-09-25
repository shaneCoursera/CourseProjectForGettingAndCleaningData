# CourseProjectForGettingAndCleaningData

This document describes the script and codebook developed for the course project
for the Coursera - Getting and Cleaning Data course.

The main script is named 'run_analysis.R'. It can be run as long as the
Samsung data described in the course project is present in your working directory.

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
    subjectFrame <- read.table(subjFile, header=FALSE)
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

### Step 1.1.4 : Build data.frame

```{r}
df <- data.frame(subjectFrame, activityFrame, featureFrame)
```
The number of columns in the 'df' dataFrame will be 561. 

Step 1.2 : Call 'buildDataSet' function from 'myrunx' function

myrunx is the main function. It makes two calls to buildDataset
function with the appropriate filenames for the 'test' and 'train' sets.

Both datasets have the same number of columns, but different number of rows.
So the rbind (row-bind) command was used to join the two datasets into one.

```{r}
 df1 <- rbind(dfTrain, dfTest)
```

## Step 2 : Extract only the measurements on the mean and standard deviation for each measurement. 

The variable names from 'features.txt' were updated to convert '.' (dot) characters to '_' (underscore) characters.
Consecutive occurrences like '..' and '...' were converted to a single underscore character. The '.' characters at
the end of variable names were removed altogether. According to the week 4 lecture of the course on "Editing Text Variables (10-46)", underscores improve readablity. And the case of the variable names was changed to lower case.


|[67] "fBodyGyro.meanFreq...X"  | fBodyGyro_meanFreq_X |            
|[70] "fBodyAccMag.mean.."      | fBodyAccMag_mean     |                 
|[71] "fBodyAccMag.std.."       | fBodyAccMag_std      |            
|[72] "fBodyAccMag.meanFreq.."  | fBodyAccMag_meanFreq |            
|[86] "angle.X.gravityMean."    | angle_X_gravityMean  |


