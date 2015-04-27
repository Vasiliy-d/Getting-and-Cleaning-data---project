library(plyr)

# Step 0
# load the data
###############################################################################

# Download the zip file into temp file
temp <- tempfile()
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,temp,mode="wb")


# Load train data set from temp file
x_train <- read.table(unz(temp,"UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(unz(temp,"UCI HAR Dataset/train/y_train.txt"))
subject_train <- read.table(unz(temp,"UCI HAR Dataset/train/subject_train.txt"))

# Load test data set from temp file
x_test <- read.table(unz(temp,"UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(unz(temp,"UCI HAR Dataset/test/y_test.txt"))
subject_test <- read.table(unz(temp,"UCI HAR Dataset/test/subject_test.txt"))

# Load features and activities from temp file
features <- read.table(unz(temp,"UCI HAR Dataset/features.txt"))
activities <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"))

# Remove the temp file
unlink(temp)


# Step 1
# create combined data set
###############################################################################

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Step 2
# Extract the measurements 
###############################################################################

mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_and_std_features]
names(x_data) <- features[mean_and_std_features, 2]

# Step 3
# Name the activities in the data set 
###############################################################################

y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"


# Step 4
# Label the data set
###############################################################################

names(subject_data) <- "subject"
all_data <- cbind(x_data, y_data, subject_data)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)
