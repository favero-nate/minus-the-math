// Nathan Favero (https://minusthemath.com)
// Chapter 8 Lab (version: Aug 4, 2024)

insheet using https://ippsr.msu.edu/sites/default/files/cspp/cspp_core_academic_2-6.csv
/*
Variable definitions (https://ippsr.msu.edu/sites/default/files/CorrelatesCodebook.pdf)
region - "If state is located in South (1), West (2), Midwest (3), Northeast (4)"
mood - "An over-time, state-level measure of Stimson’s (1999) policy mood" (higher values roughly indicate a more politically left-leaning public)
*/

// Delete observations from years other than 2000 to get a simpler dataset
keep if year == 2000

// Because missing values were coded as "NA" in original file, most quant variables are not stored in the
// proper format and need to be reprocessed (converted from "string" variables to numeric)
// The following code attempts to "destring" all variables (it will succeed for the truly numeric ones
// and skip over the rest)
destring , replace ignore("NA")

* We want to know, does policy mood differ meaningfully by region?

* First, we can examine a mean estimate with confidence interval for each region
bys region: ci means mood
ssc install ciplot // note: don't need to run if already installed
ciplot mood, by(region)

* Now, let's run a series of t-tests (note: we've not adjusted for multiple comparisons, 
* which is potentially problematic)
ttest mood if region==1 | region==2, by(region)
ttest mood if region==1 | region==3, by(region)
ttest mood if region==1 | region==4, by(region)

* Let's run an ANOVA
oneway mood region

* We can rerun the ANOVA and tell Stata to follow up with multiple comparison-adjusted pairwise test
oneway mood region, tab bon

* Let's compare regression results to those of the ANOVA and the t-tests
regress mood i.region
