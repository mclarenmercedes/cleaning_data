Steps:

1. Download the required zip file.
2. Unpack
3. Merge individual data sets into corresponding rows. Take the test and train datasets and do a filewise merge.
4. Store the results of each merged file into the corresponding file under the merged directory.
5. Pick the merged Ids, X values and Y values and create a new data frame.
6. Assign the column names for X values from features.txt.
7. Retain columns htat came from X whose column names have "mean()" or "std()" as their column names.
7. Remove rows containing NAs.
8. This is the cleaned up dataset without NAs. (stored in all_merged_data.txt)
9. Summary part was not clear. So, I have summarized by subject (grouped_data.txt) and by subject & activity Id (grouped_data_by_subject_and_activity.txt)

