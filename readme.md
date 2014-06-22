#First project for Getting Data
##run_analysis.R - creating a tidy data set from wearable computing data.
###Introduction
The purpose of run_analysis.R is to process the test and train data sets provided by the [UCI HAR study](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The processing provides a single output file that can be considered tidy on the basis that:

1. each variable forms a column (in this case, all features that represent a mean or standard deviation are included in their own column).
2. each observation (in this case, each combination of subject and activity) forms a single row
3. each type of observational unit forms a table (run_analysis.R provides a table of the average of each variable for each combination of subject and activity). 

This is the definition of tidy data from Hadley Wickham's paper, ["Tidy Data"](http://<vita.had.co.nz/papers/tidy-data.pdf).

###Data processing
The script goes through a number of steps to process the data:

1. Sets up a project folder to store data get a consistent working directory
2. Checks to see if the data has already been downloaded. If it has, it offers to re-download with a new date and time stamp. In both cases, it will offer to unzip the data. If the data has not been downloaded, it downloads it and saves the file with a data and time stamp. The data is unzipped into a foler with the same date stamp as the source file.
3. Sets up a number of shared file connections that will be used for working with both the test and train data
4. Reads in the 'test' data consisting of 
	*'X_test.txt' which is the bulk of the data (all measurements)
	*'Y_test.txt' which contains the activity mapping
	*'subject_test.txt' which maps the subjects (of which there are 30) to the measurements
5. Fix the activities mappings so that 'friendly names' are used in place of raw numbers.  
6. The script creates a table of feature (measurement) names to which it adds two additional rows to represent the subject and activity (activities now have friendly names).
7. The subject and activity mappings are added to the table xTstTab which contains the data from 'X_test.txt'.
8. The column headings are added.
9. The same process 3-8 is performed for the 'train' data.
10. A combination table (comboTab) is created by concatenating the two resulting tables.
11. A list of column headings is generated containing only those columns that have 'mean', 'Mean' or 'std' in their name.
12. This is used to subset the combination table so that only 'mean' and 'std' columns are retained.
13. This table is 'melted' to create a table with subject and activity as the ID columns. 
14. And finally, this is dcast to provide the average of each measurement for each combination of subject and activity.

Since there are 30 subjects and 6 activites, there are 180 total commbinations. An average is taken of every mean or standard deviation measurement. The output is provided as a wide table that satisfies the definition of tidy data that was provided above.
 
###Using the script
The script can be run by sourcing it to the console. It does not require arguments. All data is stored as variables and items like the download location should be edited there (e.g. fileUrl and destFile in the body of execution). Once the data has been processed, the script will produce a file in the working directory called 'tidyOut-[DATE & TIME].txt'. This file can be loaded back into R using the following command:

yourVar <- read.table(file="tidyOut-[date & time].txt",header=TRUE)

You can then manipulate the data as you see fit.
