dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./data")) dir.create("data")
download.file(dataUrl, destfile = "./data/Data.zip", method="curl")
unzip("./data/Data.zip", exdir = "./data")

dataTrainSubject <- read.table(file.path("./data", "UCI HAR Dataset", "train", "subject_train.txt"))
dataTrainActivity <- read.table(file.path("./data", "UCI HAR Dataset", "train", "y_train.txt"))
dataTrainX <- read.table(file.path("./data", "UCI HAR Dataset", "train", "X_train.txt"))

dataTestSubject <- read.table(file.path("./data", "UCI HAR Dataset", "test", "subject_test.txt"))
dataTestActivity <- read.table(file.path("./data", "UCI HAR Dataset", "test", "y_test.txt"))
dataTestX <- read.table(file.path("./data", "UCI HAR Dataset", "test", "X_test.txt"))

dataSubject <- rbind(dataTrainSubject, dataTestSubject)
dataActivity <- rbind(dataTrainActivity, dataTestActivity)
dataX <- rbind(dataTrainX, dataTestX)

library(data.table)

setnames(dataSubject, "V1", "Subject")
setnames(dataActivity, "V1", "Activityid")

features <- read.table(file.path("./data", "UCI HAR Dataset", "features.txt"))
setnames(dataX, as.character(features[,2]))

dataFull <- cbind(dataSubject, dataActivity, dataX)

activitylabels <- read.table(file.path("./data", "UCI HAR Dataset", "activity_labels.txt"))[,2]

dataFull$Activityid <- activitylabels[dataFull$Activityid]
setnames(dataFull, "Activityid", "Activity")

orig_names <- names(dataFull)
tmp_names <- names(dataFull)

tmp_names <- gsub("\\(", "", tmp_names)
tmp_names <- gsub("\\)", "", tmp_names)
tmp_names <- gsub("^t", "Time", tmp_names)
tmp_names <- gsub("^f", "Freq", tmp_names)
tmp_names <- gsub("-mean-", "Mean", tmp_names)
tmp_names <- gsub("-max-", "Max", tmp_names)
tmp_names <- gsub("-min-", "Min", tmp_names)
tmp_names <- gsub("-sma", "Sma", tmp_names)
tmp_names <- gsub("-energy-", "Energy", tmp_names)
tmp_names <- gsub("-mean", "Mean", tmp_names)
tmp_names <- gsub("-std", "Std", tmp_names)
tmp_names <- gsub("-mad", "Mad", tmp_names)
tmp_names <- gsub("-max", "Max", tmp_names)
tmp_names <- gsub("-min", "Min", tmp_names)
tmp_names <- gsub("-energy", "Energy", tmp_names)
tmp_names <- gsub("-iqr", "Iqr", tmp_names)
tmp_names <- gsub("-entropy", "Entropy", tmp_names)
tmp_names <- gsub("-maxInds", "MaxInds", tmp_names)
tmp_names <- gsub("-meanFreq", "MeanFreq", tmp_names)
tmp_names <- gsub("-skewness", "Skewness", tmp_names)
tmp_names <- gsub("-kurtosis", "Kurtosis", tmp_names)
tmp_names <- gsub("-X", "X", tmp_names)
tmp_names <- gsub("-Y", "Y", tmp_names)
tmp_names <- gsub("-Z", "Z", tmp_names)
tmp_names <- gsub("-arCoeff", "ArCoeff", tmp_names)
tmp_names <- gsub("-correlation", "Corr", tmp_names)
tmp_names <- gsub("-bandsEnergy-", "BandsEnergy", tmp_names)
tmp_names <- gsub(",gravity", "-Gravity", tmp_names)
tmp_names <- gsub(",", "-", tmp_names)
tmp_names <- gsub("^angle", "Angle", tmp_names)

names(dataFull) <- tmp_names

dataTidy <- aggregate(dataFull, by=list(Activity = dataFull$Activity, Subject=dataFull$Subject), FUN=mean)
colNameTable <- rbind(orig_names, tmp_names)

write.table(dataTidy, "./data/tidy_data.txt")
write.table(colNameTable, "./data/colnames.txt")
