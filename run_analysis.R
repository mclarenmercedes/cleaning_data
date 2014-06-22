dst <- "data.zip";
dstRoot <- "UCI HAR Dataset";
if (!file.exists(dst)) {
  download.file(
    url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
    destfile = dst,
    method = "curl");
  unzip(zipfile = dst);
}
root <- paste(getwd(), dstRoot, sep ="/");
trainRoot <- paste(root, "train", sep = "/");
testRoot <- paste(root, "test", sep = "/");
outputRoot <- paste(root, "merged", sep = "/");

unlink(outputRoot, recursive=TRUE);
outputRootDirInner <- paste(outputRoot, "Inertial Signals", sep = "/");
dir.create(outputRootDirInner, recursive=T);
fs <- list.files(trainRoot, recursive = T);
for (trainFile in fs) {
  left <- paste(trainRoot, trainFile, sep = "/");
  leftContent <- read.table(left);
  
  right <- gsub("train", "test", left);
  rightContent <- read.table(right);
  
  mergedData <- rbind(leftContent, rightContent);
  
  outputFile <- gsub("train", "merged", left);
  write.table(mergedData, file = outputFile, col.names = F, row.names = F);
}

# Read the merged data
ids <- read.table(paste(outputRoot, "subject_merged.txt", sep = "/"));
ys <- read.table(paste(outputRoot, "y_merged.txt", sep = "/"));
xs <- read.table(paste(outputRoot, "X_merged.txt", sep = "/"));
colNames <- read.table(paste(root, "features.txt", sep = "/"))[,2];

namesToConsider <- list();
limit <- length(colNames);
columnsToRetain <- list();
for (i in 1:limit) {
  curName <- as.character(colNames[i]);
  if (regexpr("mean()", curName, fixed = T) != -1 || regexpr("std()", curName, fixed = T) != -1) {
    columnsToRetain <- append(columnsToRetain, i);
    namesToConsider <- append(namesToConsider, curName);
  }
}
filteredDataset <- xs[, unlist(columnsToRetain)];

allMergedData <- cbind(ids, filteredDataset, ys);
withoutNas <- allMergedData[complete.cases(allMergedData), ];
names(withoutNas) <- c("subjects", namesToConsider, "ys");
write.table(withoutNas, paste(outputRoot, "all_merged_data.txt", sep = "/"));

#Part 2
groupedStats <- aggregate(withoutNas, by = list(withoutNas$subjects), FUN = mean)
write.table(groupedStats, paste(outputRoot, "grouped_data.txt", sep = "/"));
