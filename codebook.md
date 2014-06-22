#JH Getting Data on Coursera
##Class Project - 21st June 2014
##Matthew Povey - matt.povey@gmail.com
###Variables
* actDescTab : Table containing plain text descriptions of activities
* comboMS : A subset of the concatenated test and train data containing only those columns which are means or standard deviations.
* comboMSNarrow : A melted version of comboMS with all subject and activity used as the ID fields.
* comboTab : The combination of test and Train data
* featTab : The features data. This has 'subject' and 'activity' added as additional columns at the left.
* tidyMeans : A dcast of comboMSNarrow that takes an average of each measure for each combination of a subject and activity. In practice, this means there are 180 combinations (30 subjects * 6 activites) and a mean for each of the 88 variables that are means or standard deviations.
* trnActTab : A DF containing Activity mapping for the train data (Y_train.txt)
* trnSubjTab : A DF containing the Subject mapping for the train data (subject_train.txt)
* tstActTab : A DF containing the Activity mapping for the test data (Y_test.txt)
* tstSubjTab : A DF containing the Subject mapping for the test data (subject_test.txt)
* xTrnTab : A DF containgin The training data (X_train.txt)
* xTstTab : A DF containing the test data (X_test.txt)

