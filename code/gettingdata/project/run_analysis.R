

library(data.table)

##I created this function because I was not satisfied by the behaviour of replace() with sapply().
## I wanted  a function that replaced numerical values by a corresponding character without worrying about dimensions
## of the arguments I passed in the function
replace_multiple <- function(x)                         
{
        if (x==1) x <- "Walking"
        else if(x==2) x <- "Walking_upstairs"
        else if(x==3) x <- "Walking_downstrairs"
        else if(x==4) x <- "Sitting"
        else if(x==5) x <- "Standing"
        else if(x==6) x <- "Laying"
        else break
}

#--------------------------------- Step 1 - Fetching the data and organizing it a bit 


variables <- read.table("features.txt") ##will be used later to rename the variable of the tidy data table
variables<-variables$V2
variables<-as.character(variables)

--------------## a) for train 

x_train <- as.data.table(read.table("train/X_train.txt",colClasses = "numeric",nrows = 7352, comment.char=""))
y_train <- read.table("train/y_train.txt")
subjects_train <- as.data.table(read.table("train/subject_train.txt"))

## here at the same time I take the collumn (a vector) I am interested in and I use sapply() together with my function 
## to change the values of the vector
y_train <- sapply(y_train[,1],replace_multiple) 

--------------## b) for test

x_test <- as.data.table(read.table("test/X_test.txt",colClasses = "numeric",nrows = 2947, comment.char=""))
y_test <- read.table("test/y_test.txt")
subjects_test <- as.data.table(read.table("test/subject_test.txt"))     

## same as for y_train
y_test <- sapply(y_test[,1],replace_multiple)


#--------------------------------- Step 2 - Merges the training and the test sets to create one data set.


## The order of binding is important as I want the patient and the activity performed to be the first collumns
mergedDT_test  <- cbind(subjects_test,y_test) 
mergedDT_test  <- cbind(mergedDT_test,x_test)

mergedDT_train  <- cbind(subjects_train,y_train)
mergedDT_train  <- cbind(mergedDT_train,x_train)

## use.names=FALSE guarantees that rbind() won't try to match collumns by their names but will bind them according to their position
mergedDT <- rbind(mergedDT_test,mergedDT_train,use.names=FALSE)

## Here I am renaming the collumns of the data table. Remember that y_train/test has already been changed to be more understandable
setnames(mergedDT,c("Patient_number","Activity",variables))


#--------------------------------- Step 3 - Extracts only the measurements on the mean and standard deviation for each measurement. 

 
## Here I am initializing a new DT with the first two collumns of mergedDT: Patient_number and Activity
## with=FALSE allows me to use c(1,2) instead of the collumn names
mean.stdevDT<-mergedDT[,c(1,2),with=FALSE]

## This loop filters the collumns of mergedDT related to means and standard deviations by using periodicity
## See the Codebook for mor details
for (i in 0:13)  
{
        for (j in 3:8) mean.stdevDT<-cbind(mean.stdevDT,mergedDT[,40*i+j,with=FALSE])      
}


#--------------------------------- Step 4 -Creates a second, independent tidy data set with the average of each variable for each activity and each subject.       


## As I explained in the codebook, the first loop filters out patients individually while the second one filters out the activities.
## I then build my new data table row by row using the mapply() function. PLease find more details on the codebook
averageDT <- data.table()
for (k in 1:length(unique(mergedDT$Patient_number)))  
{
        patient<-mergedDT[mergedDT$Patient_number==k,]
        
        for (l in unique(mergedDT$Activity_performed))
        {
                activity <- patient[patient$Activity_performed==l,]
                averageDT <- rbind(averageDT,mapply(mean,activity,SIMPLIFY=FALSE),use.names=FALSE)
        }
}

write.table(averageDT, row.name=FALSE)
