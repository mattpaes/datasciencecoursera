Hello friend! 

Here are some useful information to run and understand my work:


1) There are three (3) files in this repo:
        a) The "Read_me.txt" file;
        b) The "Codebook.txt" file, which contains information on the variables and
           explains the operations performed to obtain the tidy datasets;
        c) The "run_analysis.R" script, containing the R code.


2) Set your working directory to the "UCI HAR Dataset" folder you obtained when you
   unzipped the downloaded file from the course page.


3) In the "run_analysis.R" file you will see that it contains two parts: I first made a
   function (replace_multiple, described in the codebook) and then there is the tidying
   script.


4) If you want to run it, system.time indicates that it takes 82 seconds.


5) After running my script you will see the following warning messages : 

      There were 50 or more warnings (use warnings() to see the first 50)  

This happens because of my mapply(mean,activity,SIMPLIFY=FALSE) loop in line 69. Indeed, activity is a data.table whose second variable contains "character" elements. Of course the mean cannot be calculated and as a result it returns warnings and NAs. You will find more information in the R script and in the codebook.