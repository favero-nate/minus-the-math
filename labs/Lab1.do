// Nathan Favero (https://minusthemath.com)
// Chapter 1 Lab (version: Aug 4, 2024)

insheet using "https://minusthemath.com/data/binge.csv"
// original file downloaded as Excel doc from https://onlinestatbook.com/2/case_studies/binge.html
// dataset description/coding also explained at link above

// creating nice labels for our variable
la var sex "Sex"
la def sex_val 1 "Male" 2 "Female"
la val sex sex_val

// histogram with qualitative variable (notice the labels we created are nicely applied here)
graph hbar (count), over(sex)

// let's look at a quantitative variable; we'll label the variable and then create three different graphs
la var mo_binge_n "Number of times binge drinking last month"
hist mo_binge_n
kdensity mo_binge_n
graph box mo_binge_n, horizontal

// now, we'll create two graphs that require installing user-written packages
// note: if you're using Stata through a remote network, you may not be able to install packages
// so you may have to skip this graph and the next one
findit vioplot // click through to install package if need be
vioplot mo_binge_n, horizontal

findit stripplot // install package if need be
stripplot mo_binge_n, jitter(10)
	// the "jitter" option tells it to spread out the datapoints a bit with random noise so we can see
	// multiple data points with the same value; larger values jitter the data more
	stripplot mo_binge_n
	stripplot mo_binge_n, jitter(0) // this is the default, so we get same result as prior line
	stripplot mo_binge_n, jitter(20)

// finally, let's make a histogram for a discrete variable:
la var u_fam "Familiarity with alcohol unit-based guidelines"
hist u_fam, discrete freq
	// if we don't use the discrete option, we get a pretty ugly graph because of the default binning:
	hist u_fam, freq
