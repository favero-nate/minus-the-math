// Nathan Favero (https://minusthemath.com)
// Chapter 4 Lab (version: Aug 4, 2024)

use "https://minusthemath.com/data/covid.dta"
// citation: Favero, N., & Pedersen, M. J. (2020). How to encourage “Togetherness by Keeping Apart” amid COVID-19? The ineffectiveness of prosocial and empathy appeals. Journal of Behavioral Public Administration, 3(2). https://doi.org/10.30636/jbpa.32.167

/*
survey was fielded among the general public on April 3, 2020 (within the first few weeks of Americans realizing there was a pandemic)

gender: whether respondent identifies as male, female, non-binary, or prefers not to answer

c_age: respondent age, measured in years

party: whether respondent’s preferred political party is Republican, Democratic, or other

edu: the highest level of schooling that the respondent has completed
o	1= Less than a high school diploma
o	2= High school degree or equivalent
o	3= Some college, no degree
o	4= Associate degree
o	5= Bachelor’s degree
o	6= Master’s degree
o	7= Professional degree
o	8= Doctorate

closebusiness: respondent agreement with the statement “The government should require all nonessential businesses in my area to close their on-site operations for at least the next 2 weeks”; measured on a 0-10 scale with 0 indicating strong disagreement and 10 indicating strong agreement

maxweeks: anticipated social distancing duration, measured in weeks; respondents could enter any whole number; the survey prompt said “If officials advised it, I could see myself generally staying at home and avoiding social contact for up to ___ weeks”
*/


// let's start by examining some of the basic (bivariate) associations between variables in our sample

tab gender party, row // the row option tells stata to calculate percentages by row (instead of by column)

// in the following, we use "bys" to execute the "sum" command multiple times for different subgroups
// subgroups are defined by different values of "party"
// an exclamation point (!) means "not", so we're telling it to ignore party==3 (execute command if party not equal 3)
bys party: sum maxweeks if party != 3, detail

replace maxweeks = 104 if maxweeks > 104 // windsorize 12 extreme values (outliers)
bys party: sum maxweeks if party != 3, detail

// we can treat ordinal variables (in this example, edu) as qual variables (using the tab command) or quant (using sum)
tab edu party, col
bys party: sum edu

corr c_age maxweeks
corr closebusiness maxweeks


*** confidence intervals ***

// if we assume our sample is a simple random sample from the population, we can estimate the population mean:
mean maxweeks
 
// to get a confidence interval for a correlation, install the package with the corrci command
findit corrci // scroll down and click/install "pr0041_4 from http://www.stata-journal.com/software/sj21-3"
corrci c_age maxweeks // point estimate is 0.029, and confidence interval is [-0.022, 0.079]
corrci closebusiness maxweeks

// regression output automatically includes confidence intervals for coefficients
reg maxweeks c_age
reg maxweeks closebusiness

