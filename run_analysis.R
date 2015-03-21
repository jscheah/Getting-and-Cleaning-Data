library(plyr)

# Functions
DownloadToDataDir <- function(url, dest) {
  download.file(url, dest)
}

UnzipAndExtractDataFile <- function(inputfilePath, filename) {
  unz(inputfilePath, filename)
}

LoadInputData <- function(inputfilePath, dataSetName) {
  if (!(dataSetName %in% c("train", "test"))){ stop("invalid dataset name. Only train or test dataSetName accepted.") }
  
  data <- read.table(UnzipAndExtractDataFile(inputfilePath, paste0("UCI HAR Dataset/",dataSetName,"/X_",dataSetName,".txt")), col.names=features)
  labels <- read.table(UnzipAndExtractDataFile(inputfilePath, paste0("UCI HAR Dataset/",dataSetName,"/y_",dataSetName,".txt")))
  subjects <- read.table(UnzipAndExtractDataFile(inputfilePath, paste0("UCI HAR Dataset/",dataSetName,"/subject_",dataSetName,".txt")))
  
  data$Activity <- labels[,1]
  data$Subject <- subjects[,1]
  
  # Rearranging columns for better reading
  # Append Activity and Subject to the front of the data set
  data[, append(c("Activity", "Subject"), head(colnames(data), 561))]
}

# Constants

DATADIR <- "./Data"
OUTPUTDIR <- paste(DATADIR, "output", sep="/")
OUTPUTFILE <- paste(OUTPUTDIR, "tidy_data_set.csv", sep="/")
OUTPUTTXTFILE <- paste(OUTPUTDIR, "tidy_data_set.txt", sep="/")
INPUTURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
INPUTZIPFILE <- paste(DATADIR, "uci_har_dataset.zip", sep="/")

# The actual script begins here.

# Step 1: Downloading the data file.
# Check if the zip file has been downloaded, if not download the input file.
if (!file.exists(INPUTZIPFILE)) {
  if(!file.exists(DATADIR)) { dir.create(DATADIR) }
  DownloadToDataDir(INPUTURL, INPUTZIPFILE)
}

# Step 2: Read activity labels and feature info
activityLabels <- read.table(UnzipAndExtractDataFile(INPUTZIPFILE, "UCI HAR Dataset/activity_labels.txt"))[,2]
features <- as.character(read.table(UnzipAndExtractDataFile(INPUTZIPFILE, "UCI HAR Dataset/features.txt"))[,2])

# Step 3: Load test and training Data
testData <- LoadInputData(INPUTZIPFILE,"test")
trainningData <- LoadInputData(INPUTZIPFILE,"train")

# Step 4: Merge the data as required
allData <- merge(testData, trainningData, all=TRUE, sort=FALSE)

# Step 5: Extract mean and stdDev Cols
meanAndStdDevCols <- grep("Activity|Subject|\\.mean\\.|\\.std\\.", colnames(allData))
meanAndStdDevData <- allData[,meanAndStdDevCols]

# Step 6: Calculate averages
meanAndStdDevAverages <- ddply(meanAndStdDevData, .(Activity,Subject), colMeans)

# Step 7: Rename activity labels accordingly
meanAndStdDevAverages$Activity <- as.factor(meanAndStdDevAverages$Activity)
levels(meanAndStdDevAverages$Activity) <- activityLabels

# Step 8: Writing final data to .txt without row names.
if(!file.exists(OUTPUTDIR)) { dir.create(OUTPUTDIR) }
write.table(meanAndStdDevAverages,OUTPUTTXTFILE,row.name=FALSE)