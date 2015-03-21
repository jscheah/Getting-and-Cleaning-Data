#Code Book
This document describes the code inside run_analysis.R.
The code is divided into several sections below

Functions
Constants
The actual script which consists of 7 steps.

##Functions

###DownloadToDataDir
Downloads url file to the destination filepath.

###UnzipAndExtractDataFile
Unzip and extracts a file from the zipped UCI HAR file.

###LoadInputData
Loads data, labels and subjects from UCI HAR dataset to a data.frame. Throws an error if an invalid DataSetName is passed to the function (only "training" or "test" dataset names are accepted.)
The returned data.frame contains a column Activity with labels integer codes, a column Subject with subjects integer codes and all other columns from data.

##Constants
Some fixed values used in other parts of the script.

## The actual script which consists of 8 steps.
### Step 1: Downloading the data file.
Check if the zip file has been downloaded, if not download the input file.

### Step 2: Read activity labels and feature info
Reads the activity labels to activityLabels
Reads the column names of data (a.k.a. features) to features

### Step 3: Load test and training Data
Reads the test data.frame to testData
Reads the training data.frame to trainignData

### Step 4: Merge the data as required
Merges test data and training data to allData

### Step 5: Extract mean and stdDev Cols
Identifies the mean and stdDev columns (plus Activity and Subject) to meanAndStdDevCols
Extracts a new data.frame (called meanAndStdDevData) with only those columns from meanAndStdDevCols.

### Step 6: Calculate averages
Summarizes meanAndStdData calculating the average for each column for each activity/subject pair to meanAndStdAverages.

### Step 7: Rename activity labels accordingly
Transforms the column Activity into a factor.
Uses activityLabels to name levels of Activity factor.
At this point the final data frame meanAndStdAverages looks like this:

### Step 8: Writing final data to .txt without row names.
Creates the output dir if it doesn't exist and writes meanAndStdDevAverages data frame to the .txt file without row names.