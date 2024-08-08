// Nathan Favero (https://minusthemath.com)
// Chapter 13 Lab (version: Aug 4, 2024)

use http://www.stata-press.com/data/r14/nlsw88.dta
// These data come from a 1988 survey of women in the labor force (National Longitudinal Survey of Mature and Young Women)

tab race

// create binary race variable (drop "other")
gen white=0 if race==2
replace white=1 if race==1
tab race white, missing

*** 3 methods of seeing whether the mean wage is different for white vs black women

	// two-sample t-test
	ttest wage, by(white)

	// two-sample t-test
	oneway wage white, tab

	// equivalent regression
	reg wage white

	
tab occupation

//create new occupation variable without categories with almost no observations
gen occupation11 = occupation if occupation != 9 & occupation != 12
tab occupation11
label values occupation11 occlbl
tab occupation11

*** 2 methods of seeing whether the mean wage is different by occupation

	// ANOVA
	oneway wage occupation11, tab

	// equivalent regression
	reg wage i.occupation11, base


*** 2 methods of seeing whether race is associated with occupation (chi-square or regression)

	// chi2 test (order of variables doesn't matter)
	tab occupation11 white, chi2 row
	// or:
	tab occupation11 white, chi2 col
	// or:
	tab white occupation11, chi2 col

	// similar (not quite equivalent) approach using regression
	reg white i.occupation11, base
	
	
	// if I want to include the "other" race category:
	// chi2 test:
	tab occupation11 race, chi2 row

	// similar (not quite equivalent) approach using regression
	tab race, gen(race_)
	reg race_1 i.occupation11, base
	reg race_2 i.occupation11, base
	reg race_3 i.occupation11, base
	
	
*** if I want to use multiple independent variables, I have to use regression
	reg wage tenure white i.occupation11, base
	