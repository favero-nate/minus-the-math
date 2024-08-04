// Nathan Favero (https://minusthemath.com)
// Lecture 6 (version: Aug 3, 2024)

// for this script, it will be useful to set a working directory (copy-paste the
// directory of whatever folder you wish to work out of between the quotation marks):
cd "C:\Users\favero\OneDrive - american.edu\Conduct 1\07. sampling distributions\tmp"

***************************
*** Appendix 1
***************************

// create data

set obs 20
gen satisfaction = 1 in 1/2
//replace satisfaction = 2 in 2
replace satisfaction = 3 in 3
replace satisfaction = 4 in 4/5
replace satisfaction = 5 in 6/8
replace satisfaction = 6 in 9/10
replace satisfaction = 7 in 11/13
replace satisfaction = 8 in 14/16
replace satisfaction = 9 in 17/18
replace satisfaction = 10 in 19/20

save population.dta, replace

// simulate sample draws

local num_sim = 10000 // number of simulations to conduct

postfile sim mhat n using sim_results.dta, replace
set seed 12345
foreach i of numlist 3 5 10 { // set sample sizes to try
	forvalues j=1/`num_sim' {
		quietly gen rand = uniform()
		quietly sort rand
		quietly sum satisfaction in 1/`i'
		post sim (r(mean)) (`i')
		drop rand
	}
}
	
postclose sim

use sim_results.dta, clear

label var mhat "Estimates of Mean(Satisfaction)"
la define sampsize 3 "Sample size = 3" 5 "Sample size = 5" 10 "Sample size = 10"
la values n sampsize

// appendix slide 9
hist mhat if n==3, xlabel(0(2)10)

// appendix slide 12
hist mhat, by(n, col(1)) xlabel(0(2)10)

bys n: sum mhat

// examine original dataset

use population.dta, clear
label var satisfaction "Satisfaction"

// appendix slide 7
hist satisfaction, width(1) start(.5) // note: I now realize a better way to do this is with the "discrete" option

sum satisfaction

***************************
*** Appendix 2
***************************

// simulate sample draws

local num_sim = 1000 // number of simulations to conduct

postfile sim diff_y1 diff_y2 n using diff_means_results.dta, replace
set seed 12345
foreach i of numlist 10 50 200 { // set sample sizes to try
	clear
	set obs `i'
	local halfn = `i'/2
	quietly gen x = 0 in 1/`halfn'
	quietly replace x = 1 if x == .
	forvalues j=1/`num_sim' {
		display "n=`i'; simulation #`j'"
		quietly drawnorm e1 e2
		quietly gen y1 = .5*x + e1
		quietly gen y2 = e2
		list x y1 y2 in 1/10
		bys x: sum y1
		reg y1 x
		local diff_y1 = _b[x]
		bys x: sum y2
		reg y2 x
		local diff_y2 = _b[x]
		post sim (`diff_y1') (`diff_y2') (`i')
		drop e? y?
	}
}
	
postclose sim

use diff_means_results.dta, clear

label var diff_y1 "Estimates of Treatment Effect (Y1)"
label var diff_y2 "Estimates of Treatment Effect (Y2)"
la define sampsize 10 "Sample size = 10" 50 "Sample size = 50" 200 "Sample size = 200"
la values n sampsize

// appendix slide 16
hist diff_y1 if n==10, xlabel(-3(3)3) name(y1_n10, replace)
hist diff_y2 if n==10, xlabel(-3(3)3) name(y2_n10, replace)
graph combine y1_n10 y2_n10, rows(2)

// appendix slide 17
hist diff_y1, by(n, col(1))

// appendix slide 18
hist diff_y2, by(n, col(1))

bys n: sum diff_y1
bys n: sum diff_y2

***************************
*** Appendix 4
***************************

// This final set of simulations is not actually in the slides, but I
// sometimes use it as a teaching example alongside appendix 4.

clear all

set obs 10000 // this is where we set how many simulations we want to do
egen sample = fill(1 2 3)

expand 40 // sample size: 40
sort sample
egen obs_num = fill(1 2 3)
replace obs_num = obs_num - (sample-1)*40

// we'll draw from a normal distribution (mean: 65, sd:5)
// we're also assuming an infinite population
gen height = rnormal(65,5)


*** mean estimator ***


// now we calculate a sample mean for each sample
egen sample_mean = mean(height), by(sample)

egen tag = tag(sample)
sum sample_mean if tag==1, detail
*hist sample_mean if tag==1


*** 1st variance estimator ***


// now we'll calculate the variance for each sample,
// using the variance formula we learned in week 2

// first, we calculate the squared deviation for each observation
gen deviation = (height - sample_mean)^2

// then we sum the deviations
egen sum_dev = total(deviation), by(sample)

// finally, we divide by the sample size (40) to get the variance
gen var_of_sample = sum_dev/40

sum var_of_sample if tag==1, detail
*hist var_of_sample if tag==1


*** 2nd variance estimator ***


// now we'll use the sample variance formula we learned today,
// dividing by the sample size minus one (40-1=39)
gen sample_var = sum_dev/39

sum sample_var if tag==1, detail
*hist sample_var if tag==1

****
** now, repeat with n=10
****

clear all

set obs 10000 // this is where we set how many simulations we want to do
egen sample = fill(1 2 3)

expand 10 // sample size: 10
sort sample
egen obs_num = fill(1 2 3)
replace obs_num = obs_num - (sample-1)*10

// we'll draw from a normal distribution (mean: 65, sd:5)
// we're also assuming an infinite population
gen height = rnormal(65,5)


*** mean estimator ***


// now we calculate a sample mean for each sample
egen sample_mean = mean(height), by(sample)

egen tag = tag(sample)
sum sample_mean if tag==1, detail
*hist sample_mean if tag==1


*** 1st variance estimator ***


// now we'll calculate the variance for each sample,
// using the variance formula we learned in week 2

// first, we calculate the squared deviation for each observation
gen deviation = (height - sample_mean)^2

// then we sum the deviations
egen sum_dev = total(deviation), by(sample)

// finally, we divide by the sample size (10) to get the variance
gen var_of_sample = sum_dev/10

sum var_of_sample if tag==1, detail
*hist var_of_sample if tag==1


*** 2nd variance estimator ***


// now we'll use the sample variance formula we learned today,
// dividing by the sample size minus one (10-1=9)
gen sample_var = sum_dev/9

sum sample_var if tag==1, detail
*hist sample_var if tag==1

