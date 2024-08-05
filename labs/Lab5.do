// Nathan Favero (https://minusthemath.com)
// Chapter 5 Lab (version: Aug 4, 2024)

// This lab is focused on the important topic of data processing. It is a bit different from the others,
// in that this lab isn't really tied to this chapter's contents, since data management is not really
// a statistical topic. It is nonetheless crucial if you want to work with data yourself.

* Edit the following line to point to the folder you'll be using (your "working directory").
cd ""

// This will create a file that keeps a log of your work.
capture log close
log using data_management, replace text

// These commands help to make sure that Stata is running in a consistent way and from a clean slate so
// that everyone gets the same results when running this do file. I've omitted this sort of thing from
// most do-files for simplicity, but it can be helpful to include at the top of your do-files,
// especially if you are doing anything complicated and want to ensure others can replicate it.
version 16.1
clear all
macro drop _all
set linesize 80

use "https://minusthemath.com/data/nyc_schools.dta"
// Source: New York City Department of Education records, assembled by Nathan Favero


* Rename a variable
rename schoolname school



* Let's practice if statements. We can use if statements to find summary statistics for subsets of the data.
sum overallscore if schooltype == "Elementary"
sum overallscore if schooltype == "Middle"
sum overallscore if schooltype == "K-8"

* The overall score ranges from 0 to 100 (plus bonus points, which cause some observations to be greater than 100).
* Say we want to rescale the variable so that it ranges from 0 to 1. We simply divide by 100.
* This operation is useful for converting percentages to ratios.
replace overallscore = overallscore / 100
sum overallscore


* Generate a dummy (0-1) variable indicating whether or not the school is an elementary school
gen elementary = 0
replace elementary = 1 if schooltype == "Elementary" | schooltype == "K-8"
replace elementary = . if schooltype == ""

* Now, we do the same thing for middle schools
gen middle = 0
replace middle = 1 if schooltype == "Middle" | schooltype == "K-8"
replace middle = . if schooltype == ""

* To double-check our work, we use the sum and tab commands
tab schooltype
sum elementary middle
tab schooltype elementary
tab schooltype middle


* We similarly create dummy variables for the letter grades.
gen gradeA = 0
replace gradeA = 1 if overallgrade == "A"
replace gradeA = . if overallgrade == ""

gen gradeB = 0
replace gradeB = 1 if overallgrade == "B"
replace gradeB = . if overallgrade == ""

gen gradeC = 0
replace gradeC = 1 if overallgrade == "C"
replace gradeC = . if overallgrade == ""

gen gradeD = 0
replace gradeD = 1 if overallgrade == "D"
replace gradeD = . if overallgrade == ""

gen gradeF = 0
replace gradeF = 1 if overallgrade == "F"
replace gradeF = . if overallgrade == ""

* Finally, we create a variable to indicate if the letter grade is missing.
gen grade_missing = 0
replace grade_missing = 1 if overallgrade == ""


* If we try to look at the summary statistics for the variable blackhispanic, Stata gives us nothing because
* it is treating the variable as text (as a string variable) since it includes the percentage sign (%).
sum blackhispanic

* We need to convert this variable to just numbers. We can use the destring command to do this.
destring blackhispanic, replace ignore(%)
sum blackhispanic

* We do the same thing for the variable ell.
destring ell, replace ignore(%)


* If we want to move a set of variables to be the first columns in the dataset, we run the following.
order schooltype overallgrade

* If we want a variable to come afer another one, we use the after option.
order district, after (dbn)

* Now, we want to sort the data by the type of school.
sort schooltype

* If we want to sort by the grade within each school type, we list both variables (with the primary sorting variable listed first).
sort schooltype overallgrade


* Let's say that we only want to use the elementary schools in our dataset. We can delete the others by
* running the following line of code.
keep if elementary == 1

* Alternatively, we could have run the following (which does exactly the same thing as the line above in this case).
drop if elementary == 0


* Now, let's create an index of the progress grade and the performance grade. We first convert the grades to numeric variables.
* We assign a score of 5 to schools with an A, 4 for a B, etc.
gen progress = .
replace progress = 4 if progressgrade == "A"
replace progress = 3 if progressgrade == "B"
replace progress = 2 if progressgrade == "C"
replace progress = 1 if progressgrade == "D"
replace progress = 0 if progressgrade == "F"

gen performance = .
replace performance = 4 if performancegrade == "A"
replace performance = 3 if performancegrade == "B"
replace performance = 2 if performancegrade == "C"
replace performance = 1 if performancegrade == "D"
replace performance = 0 if performancegrade == "F"

* Now we want to combine the two measures into a single index by adding them, creating a scale ranging from 0 to 8.
gen index = progress + performance


* The variable dbn contains the district, borough, and school number. The first 2 digits are the district number.
* The third digit is the borough. And the fourth through sixth digits are the school number.
help substr
gen distnum = substr(dbn,1,2)	
gen borough = substr(dbn,3,1)
gen schoolnum = substr(dbn,4,3)

* If we want, we can destring the distnum and/or the schoolnum
destring distnum, replace
destring schoolnum, replace


* Don't overwrite the original file! Save a new copy in case we realize later that we made a mistake and
* want to go back to the original data. Giving the modified file a new name helps to clarify. Even though
* we loaded the file directly into Stata from a URL, in normal research, I would want to save a copy of
* the unedited file on my hard drive, along with a record of the date of download and URL. Websites
* often change, so it's important that others know when/where I downloaded the original data for purposes
* of transparency and replication.
save "nyc_schools_cleaned.dta"

log close
exit

