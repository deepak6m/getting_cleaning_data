list.files()
list.dirs()
"./UCI HAR Dataset"
# Download the dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip",method="curl")
# unzip the dataset
unzip(Dataset.zip)

# List the directories
list.dirs()
# List the files in directory
list.files("./UCI HAR Dataset",recursive = TRUE)

# Read trainings tables:
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read testing tables:
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Read feature vector:
features <- read.table('./UCI HAR Dataset/features.txt')

# Read activity labels:
activityLabels = read.table('./UCI HAR Dataset/activity_labels.txt')

dim(x_train)
dim(x_test)
dim(y_train)
dim(y_test)
dim(features)
dim(activityLabels)
nrow(unique(y_train))==nrow(activityLabels)

# Merge the datasets into one
mrg_train <- cbind(subject_train, y_train, x_train)
mrg_test <- cbind(subject_test, y_test, x_test)
combinedSet <- rbind(mrg_train, mrg_test)

dim(combinedSet)

# Name the columns
names(combinedSet) <- c("subject_id","activity_id",as.character(features$V2))

# Select measures with mean() and std()
mean_and_std <- combinedSet[,grep("mean\\(\\)|std\\(\\)",names(combinedSet))]

# naming activities with their descriptive names
names(activityLabels) <- c("activity_id","activity_type")
combinedSet <- merge(combinedSet, activityLabels, by='activity_id', all.x=TRUE)

# Label the dataset with descriptive variables
names(combinedSet)
#prefix 't' to denote time
#Acc accelerometer 
#Gyro gyroscope
#Mag Magnitude
#'f' frequency domain signals
names(combinedSet) <- gsub("^t","time",names(combinedSet))
names(combinedSet) <- gsub("^f","frequency",names(combinedSet))
names(combinedSet) <- gsub("Acc", "Accelerometer",names(combinedSet))
names(combinedSet) <- gsub("Gyro", "Gyroscope",names(combinedSet))
names(combinedSet) <- gsub("Mag", "Magnitude",names(combinedSet))

# Tidy data with mean, using activity_id,subject_id
tidyData <- aggregate(. ~ activity_id + subject_id, combinedSet, mean)
dim(tidyData)
write.table(tidyData,file = "tidyData.txt",row.names = FALSE)
