library(data.table)
# Get variable and activity names
varNames <- read.table("specdata/UCI HAR Dataset/features.txt")
activityNames <- read.table("specdata/UCI HAR Dataset/activity_labels.txt")

# Read test and training datasets
test <- read.table("specdata/UCI HAR Dataset/test/X_test.txt")
training <- read.table("specdata/UCI HAR Dataset/train/X_train.txt")

# Get activity and subject IDs
testActivityIDs <- read.table("specdata/UCI HAR Dataset/test/Y_test.txt")
testSubjectIDs <- read.table("specdata/UCI HAR Dataset/test/subject_test.txt")
trainActivityIDs <- read.table("specdata/UCI HAR Dataset/train/Y_train.txt")
trainSubjectIDs <- read.table("specdata/UCI HAR Dataset/train/subject_train.txt")

# Merge activity and subject IDs
activityIDs <- rbind(testActivityIDs, trainActivityIDs)
subjectIDs <- rbind(testSubjectIDs, trainSubjectIDs)

# Merge training and test datasets
combinedTestTrain <- rbind(test, training)
# Add descriptive names to variables
count <- 1
for (name in 1:nrow(varNames)) {
  varNames[[2]][name] <- gsub("mean\\(\\)", "mean", varNames[[2]][name])
  varNames[[2]][name] <- gsub("std\\(\\)", "standard_deviation", varNames[[2]][name])
  varNames[[2]][name] <- gsub("Acc", "Acceleration", varNames[[2]][name])
  varNames[[2]][name] <- gsub("Mag", "Magnitude", varNames[[2]][name])
  count <- count + 1
}
colnames(combinedTestTrain) <- varNames[[2]]
# Extract only measurements of mean and std deviation for each measurement
meanStdCombined <- combinedTestTrain[ ,grepl("mean|standard_deviation", colnames(combinedTestTrain)) & !grepl("meanFreq", colnames(combinedTestTrain))]

# Add all activity names together with IDs
count <- 1
for (id in 1:nrow(activityIDs)) {
  activityIDs[id, 2] <- activityNames[activityIDs[id, 1], 2]
  count <- count + 1
}

# Merge all tables to have Subject ID and Activity columns
combinedTestTrain <- cbind(subjectIDs, activityIDs[,2], meanStdCombined)
colnames(combinedTestTrain)[1:2] <- c("Subject_ID", "Activity_Name")

# Melting rows of each variable to fit two columns based on Subject_ID and Activity_Name
meltedCombined <- melt(setDT(combinedTestTrain), id.vars = c("Subject_ID", "Activity_Name"), measure.vars = names(combinedTestTrain)[3:ncol(combinedTestTrain)])
# Casting the variable column into separated variables once more, but aggregated with mean()
castedCombined <- dcast(meltedCombined, Subject_ID + Activity_Name ~ variable, fun.aggregate = mean)

# Attempt to view tidy dataset
print("Done running. Attempting to view the castedCombined dataset now.")
tryCatch(View(castedCombined),
         error = function(e){
           print("Something went wrong. Try manually viewing castedCombined instead.")
        })
