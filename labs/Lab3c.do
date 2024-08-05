// Nathan Favero (https://minusthemath.com)
// Chapter 3 Lab - Part C (version: Aug 4, 2024)

// Note: This lab does not introduce many new commands, instead providing a different setting to
// review commands already covered in prior labs. Thus, code annotations are minimal.

insheet using https://ippsr.msu.edu/sites/default/files/cspp/cspp_core_academic_2-6.csv

// Delete observations from years other than 2000 to get a simpler dataset
keep if year == 2000

// Because missing values were coded as "NA" in original file, most quant variables are not stored in the
// proper format and need to be reprocessed (converted from "string" variables to numeric)
// The following code attempts to "destring" all variables (it will succeed for the truly numeric ones
// and skip over the rest)
destring , replace ignore("NA")

order povrate region earned_income_taxcredit mood poptotal
/*
Variable definitions (https://ippsr.msu.edu/sites/default/files/CorrelatesCodebook.pdf)
povrate - "Estimated percent of individuals living in poverty"
region - "If state is located in South (1), West (2), Midwest (3), Northeast (4)"
earned_income_taxcredit - "Does the state have an earned income tax credit? (0 = no, 1 = yes)"
mood - "An over-time, state-level measure of Stimson’s (1999) policy mood" (higher values roughly indicate a more politically left-leaning public)
poptotal - "Total population per state"
*/

hist povrate
	hist povrate, freq

hist earned_income_taxcredit
	graph bar (count), over(earned_income_taxcredit)
graph bar (count), over(region)

graph box povrate
graph box mood
graph box poptotal

findit stripplot

stripplot povrate
	stripplot povrate, jitter(5)
stripplot mood
stripplot poptotal

tab povrate
tab region
tab mood

sum povrate region earned_income_taxcredit mood poptotal


sum povrate mood poptotal, detail

// in the following, we use "bys" to execute the "sum" command multiple times for different subgroups
// for example, subgroups can be defined by different values of "earned_income_taxcredit"
bys earned_income_taxcredit : sum mood
bys region : sum mood
	// an exclamation point (!) means "not", so we're saying to ignore Delaware (execute command if "st" not equal "DE")
	bys region : sum mood if st != "DE"

graph box mood , over ( region )
stripplot mood , over ( region )

tab region earned_income_taxcredit, row

corr mood poptotal
corr mood poptotal povrate

twoway scatter mood povrate

reg mood povrate
reg mood poptotal povrate
