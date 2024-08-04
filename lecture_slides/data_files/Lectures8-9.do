// Nathan Favero (https://minusthemath.com)
// Lectures 8 & 9 (version: Aug 3, 2024)

// This do-file contains examples using the 2016 ANES dataset
// To run this script, you will need to first download the dataset here: https://doi.org/10.3886/ICPSR36824.v2
// (If the link above is not working for you, you can also try this site: https://electionstudies.org/data-center/)

// You will need to set the working directory to the folder in which you saved the ANES dataset
// (copy-paste the directory of that folder between the quotation marks):
cd ""


use "36824-0001-Data.dta" // update if the file you download has a different name (e.g., a new version)

*************************************
** Lecture 8
*************************************

// Note: most of this goes beyond what is directly in the slides

// Race variable
tab V161310X

// Feeling thermometer: how respondents feel about whites
sum V162314
hist V162314
tab V162314


*** One-way ANOVA

// We consider whether different racial groups have different attitudes about whites.
// Notice that we only want to include observations where the values for race/attitudes
// are non-missing (we use the "if..." statement).
oneway V162314 V161310X if V162314 >=0 & V161310X>=0, tabulate

// If we want to conduct multiple-comparison tests using the Bonferroni adjustment,
// we can add the option "Bonferroni:
oneway V162314 V161310X if V162314 >=0 & V161310X>=0, tabulate bonferroni

// We could also compute the basic one-way ANOVA test using the "anova" command,
// which also allows for more advanced types of ANOVA:
anova V162314 V161310X if V162314 >=0 & V161310X>=0


*** Two-sample t-tests and one-way ANOVA yeild equivalent results with 2 categories

// Let's compare only black and Hispanic respondents:
oneway V162314 V161310X if V162314 >=0 & (V161310X==2 | V161310X==5), tabulate
ttest V162314 if V162314 >=0 & (V161310X==2 | V161310X==5), by(V161310X)

// With the t-test, we have the option to allow for unequal variances
ttest V162314 if V162314 >=0 & (V161310X==2 | V161310X==5), by(V161310X) unequal


*** Factorial ANOVA

// We now simultaneously consider race and gender (V161342 is the gender variable)
anova V162314 V161310X##V161342 if V162314 >=0 & V161310X>=0 & (V161342==1 | V161342==2)


*** Regression

// This gives us the same results as ANOVA
reg V162314 i.V161310X if V162314 >=0 & V161310X>=0, base




*************************************
** Lecture 9
*************************************

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
