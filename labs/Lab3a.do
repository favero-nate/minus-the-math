// Nathan Favero (https://minusthemath.com)
// Chapter 3 Lab - Part A (version: Aug 4, 2024)

insheet using "https://minusthemath.com/data/tx_schools.dat"
// Source: Texas Education Agency district snapshots - 2018 version
// Codebook (originally downloaded with a .lyt file extension) available here: https://github.com/favero-nate/minus-the-math/raw/main/lecture_slides/data_files/district_snapshot_2018.txt

// We can repeat our data processing from the Ch 2 lab
gen charter = (commtype=="Charters")
label define chartercode 0 "Traditional District" 1 "Charter District"
label values charter chartercode
gen passrate = dda00a001218r if dda00a001218r >= 0
gen tsal = dpsttosa if dpsttosa >= 0
gen tturn = dpsturnr if dpsturnr >= 0

// Let's create an additional variable that will indicate if a district has only 1 school:
gen oneschooldist = (dzcampus==1)
la var oneschooldist "Single-School District"
label define singleschool 0 "Multi-School" 1 "Single-School"
label values oneschooldist singleschool

// Let's only keep the variables we'll use in this lab:
keep charter passrate tsal tturn oneschooldist

*******

// Does the pass rate differ between charter school districts vs. traditional districts?
// Here are a few ways we can examine the relationship b/w a quant and a qual variable:

sum passrate if charter==0
sum passrate if charter==1

tabstat passrate, s(median) by(charter)

graph box passrate, over(charter)	

// Now, let's see whether charter districts are more likely to have only 1 school
// Some ways to look at the relationship b/w two qual variables:
tab oneschooldist charter, col

graph bar, over(oneschooldist) by(charter)
	// see more tips here: https://medium.com/the-stata-gallery/advanced-bar-graphs-in-stata-part-2-visualizing-relationships-between-discrete-variables-7afb8cb5aaf2

graph hbar, over(oneschooldist) over(charter) stack asyvars percentage
	// see more tips here: https://medium.com/the-stata-gallery/advanced-bar-graphs-in-stata-part-3-stacked-bar-graphs-2bb2a58c6c95

// Finally, let's look at two quant variables (passrate and teacher salaries):
corr passrate tsal

twoway scatter passrate tsal

******

// To run a regression, we use "reg" and always list the dependent variable first:
reg passrate tsal

	// We can visualize a regression line (using "lfit") on top of a scatterplot:
	twoway (scatter passrate tsal) (lfit passrate tsal)

// We can have multiple independent variables:
reg passrate tsal tturn

