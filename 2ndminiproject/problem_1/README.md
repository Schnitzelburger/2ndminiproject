## Problem 1

We first import the `data.table` library since we're going to need the `melt()` and `dcast()` functions.
It's important to read the `README.txt` in the UCI HAR Dataset, as it contains information we need to get things up and running.

We know that `features.txt` contains variable names and `activity_labels.txt` has activity names, so we'll save them using `read.table()` to detail our tables later.

`test` and `train` both have the datasets we need to get our values from, so we create tables for those with `read.table()`. Next, we retrieve activity IDs and subject IDs from both datasets in the same manner.

Now we use `rbind()` to merge both `activityID` and `subjectID` in both datasets, so we can merge that to the combined `test` and `training` dataset later. 

After using `gsub()` to replace some terms to make things clearer (e.g., `mean()` to `mean`, `std()` to `standard_deviation`, `Acc` to `Acceleration`, and `Mag` to `Magnitude`), we use `colnames()` to set variable names in our new combined dataset, referring to the `varNames` table we made earlier.

Now that we have variable names as indicators for what values mean what, we use `grepl()` to take columns that match the strings "mean" or "standard_deviation" since we're only looking for mean and standard deviation for each measurement.

Next, we take the activity names we saved earlier and match them to their corresponding IDs in `activityIDs`, so that we can add them to our final list to be more detailed later.

Everything's set up now, so we can use `cbind()` to merge columns and give us a dataset that now has subject IDs and activity names, together with all the means and standard deviations. We then use `colnames()` once more to rename our new columns.

Almost done. We then use `melt()` to put every variable into a column such that each row under those columns becomes a respective column to each variable, based on `Subject_ID` and `Activity_Name`.

Finally, we use `dcast()` to separate the variables once more, while using the function `mean()` to aggregate.

The program will then attempt to `View()` the resulting tidy dataset.
