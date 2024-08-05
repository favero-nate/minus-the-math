// Nathan Favero (https://minusthemath.com)
// Chapter 9 Lab (version: Aug 5, 2024)

// This do-file contains examples using the 2016 ANES dataset
// To run this script, you will need to first download the dataset here: https://doi.org/10.3886/ICPSR36824.v2
// (If the link above is not working for you, you can also try this site: https://electionstudies.org/data-center/)

// You will need to set the working directory to the folder in which you saved the ANES dataset
// (copy-paste the directory of that folder between the quotation marks):
cd ""


use "36824-0001-Data.dta" // update if the file you download has a different name (e.g., a new version)

// Race variable
tab V161310X
rename V161310X race
replace race = . if race < 0

tab race

// Vote variable
tab V161006
rename V161006 vote
replace vote = . if vote < 0 | vote > 5

tab vote

// Two-way table with percentage frequencies by row
tab race vote, row

// Chi-square test
tab race vote, row chi2

// Chi-square test just comparing Asian with Hispanic individuals
tab race vote if race==3 | race==5, row chi2


** Using regression to analyze vote (this is jumping ahead to Ch. 13 content, but it is useful to preview it here):

// create 3 dummy variables for the 3 vote options
tab vote, gen(vote_)
tab vote_1
tab vote_2
tab vote_3

// create 6 dummy variables for the 6 racial categories
tab race, gen(race_)
tab race_1
tab race_2
tab race_3
tab race_4
tab race_5
tab race_6

// run one regression for each category of the dependent variable
// (note: don't forget to drop one category for a categorical independent variable)
reg vote_1 race_2 race_3 race_4 race_5 race_6
reg vote_2 race_2 race_3 race_4 race_5 race_6
reg vote_3 race_2 race_3 race_4 race_5 race_6

