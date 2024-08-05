// Nathan Favero (https://minusthemath.com)
// Chapter 6 Lab (version: Aug 4, 2024)


******************************
** A Very Simple Simulation **
******************************

// This very simple simulation of data can be used to demonstrate the central limit theorem
// Be sure to examine the distributions of the underlying variables (u1-u6), even though it
// is not in the code to create historams for them

clear all
set obs 1000

// uncomment the following line if you want to get the same results every time
*set seed 1234

gen u1 = runiform()
gen u2 = runiform()
gen u3 = sqrt(runiform())
gen u4 = sqrt(runiform())
gen u5 = runiform()^2
gen u6 = runiform()^2

gen sum = u1 + u2 + u3 + u4 + u5 + u6
hist sum



************************************
** Confidence Interval Simulation **
************************************

// This simulation is considerably more complex. It demonstrates the need for the t-distribution with
// small samples, as opposed to relying on the normal distribution (to construct confidence intervals).


// For this simulation, you need to set a working directory where you can save the simulated data
// as it is created:
cd "C:\Users\favero\OneDrive - american.edu\minus the math\labs"

clear all

global pop_m = 10
global pop_sd = 5

// simulate sample draws
// run the following lines all at once:
	local num_sim = 10000 // number of simulations to conduct
	postfile sim mhat sd n using sim_results.dta, replace
	set seed 12345
	foreach i of numlist 5 10 100 { // set sample sizes to try
		forvalues j=1/`num_sim' {
			quietly set obs `i'
			quietly gen satisfaction = rnormal($pop_m , $pop_sd )
			quietly sum satisfaction in 1/`i'
			post sim (r(mean)) (r(sd)) (`i')
			drop satisfaction
		}
	}
	postclose sim

use sim_results.dta, clear // each observation is one simulated sample

// Case 1: 95% confidence intervals created from the normal distribution (threshold 1.96) when S.D. is known (unrealistic case)
// generate confidence interval lower/upper bounds for each simulated sample
gen ci1_lb = mhat - 1.96*$pop_sd /sqrt(n)
gen ci1_ub = mhat + 1.96*$pop_sd /sqrt(n)
// create dummy variable indicating whther confidence interval from that sample contains true population mean
gen ci1_tr = 0
replace ci1_tr = 1 if ci1_lb < $pop_m & ci1_ub > $pop_m 

// Case 2: 95% confidence intervals created from the normal distribution (threshold 1.96) when S.D. is estimated (the realistic case)
gen ci2_lb = mhat - 1.96*sd /sqrt(n)
gen ci2_ub = mhat + 1.96*sd /sqrt(n)
gen ci2_tr = 0
replace ci2_tr = 1 if ci2_lb < $pop_m & ci2_ub > $pop_m

// Case 3: 95% confidence intervals created from t distribution (threshold obtained using "invt" function) when S.D. is estimated (the realistic case)
gen ci3_lb = mhat - invt(n-1,.975)*sd /sqrt(n)
gen ci3_ub = mhat + invt(n-1,.975)*sd /sqrt(n)
gen ci3_tr = 0
replace ci3_tr = 1 if ci3_lb < $pop_m & ci3_ub > $pop_m

// Results: looking for 95% coverage (i.e., ci?_tr equal to 1 close to 95% of the time)
bys n: tab ci1_tr // Case 1: results by sample size (unrealistic case)
bys n: tab ci2_tr // Case 2: results by sample size (known to be biased)
bys n: tab ci3_tr // Case 3: results by sample size (should be unbiased)


