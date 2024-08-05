// Nathan Favero (https://minusthemath.com)
// Chapter 12 Lab (version: Aug 4, 2024)

*to read in data, you'll need to download BIG5.zip from the page https://openpsychometrics.org/_rawdata/
*after downloading, you'll need to unzip the file, and then you should have a file called data.csv
*set the working directory appropriately:
cd ""
insheet using data.csv

*create an index for overall extraversion
gen extraversion = e1 - e2 + e3 - e4 + e5 - e6 + e7 - e8 + e9 - e10
label var extraversion "Extraversion"
hist extraversion

*create a binary male variable from the gender variable (note: for the original gender variable, 0=missing, 1=male, 2=female, 3=other)
gen male = 0 if gender==2
replace male = 1 if gender==1
label var male "Gender"
label define male_val 0 "Female" 1 "Male"
label val male male_val

*examine descriptive stats for extraversion by gender
bys gender: sum extraversion

*compare histograms for male vs. female
hist extraversion, by(male)

*run a regression comparing extraversion for male vs. female
reg extraversion male

*a t-test, equivalent to the regression we just ran
ttest extraversion, by(male)

*now, let's also consider non-binary
hist extraversion if gender==3

*here's a regression that accounts for all three gender categories
reg extraversion ib1.gender if gender!=0

*we can run an anova, with equivalent results to the regression we just ran
oneway extraversion gender if gender!=0, tab

*after anova, we can do pair-wise t-tests with bonferroni adjustments
oneway extraversion gender if gender!=0, bon

*let's try to predict gender (male vs. female) based on the value of extraversion
reg male extraversion

*really, when the dependent variable is binary, we should use the "robust" option to calculate standard errors:
reg male extraversion, robust
