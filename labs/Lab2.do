// Nathan Favero (https://minusthemath.com)
// Chapter 2 Lab (version: Aug 4, 2024)

insheet using "https://minusthemath.com/data/tx_schools.dat"
// Source: Texas Education Agency district snapshots - 2018 version
// Codebook (originally downloaded with a .lyt file extension) available here: https://github.com/favero-nate/minus-the-math/raw/main/lecture_slides/data_files/district_snapshot_2018.txt


// Let's create some new variables using the "gen" command

// This will go through each row and check whether the variable "commtype" has the value "Charters"
// If it does, it will create a 1; if not, it will code as 0
// So the new variable called "charter" will be either a 1 (for a charter) or 0 (not a charter)
// Note that we use one equal sign (=) to assign a value
// We use two equal signs (==) when we're telling it "check if these two things are equal"
gen charter = (commtype=="Charters")

// Let's label our new charter variable
label define chartercode 0 "Traditional District" 1 "Charter District"
label values charter chartercode

// Now, we have a very poorly named variable (dda00a001218r) from the original dataset that
// tells us the pass rate for standardized exams; let's examine the variable using the "sum"
// command, which gives us summary statistics
sum dda00a001218r

// The variable tells us the percentage of students who passed, but notice the minumum is -1
// That is because in this dataset, if the data is missing, the data is coded as -1 or -2
// We want to change that so that the missing values will be coded as a ".", which is 
// how stata represents missing data for quantitative variables
// An easy way to accomplish this is to create a new variable and tell it to take on the
// values of the original varaible *if* the original variable has non-negative values
// Where negative values exist, they will just end up coded as missing (.) with this code:
gen passrate = dda00a001218r if dda00a001218r >= 0

// Let's do the same thing for teacher salaries (district average) and teacher turnover rate:
gen tsal = dpsttosa if dpsttosa >= 0
gen tturn = dpsturnr if dpsturnr >= 0

// Now, we move our new variables to the beginning of the dataset
order charter passrate tsal tturn

// Let's also make this dataset a bit more compact by dropping the rest of the variables
// since we won't use them in this lab
// We can drop the rest by naming the ones we want to keep
keep charter passrate tsal tturn


*******

// Now that our data is processed a bit, let's evaluate the data a bit

// The "tab" command generate a frequency table (especially useful for quantitative variables):
tab charter

// We can also see the underlying numbers behind our value labels if we use the "fre" package
// If you haven't previously installed this package (or aren't sure), run this command:
ssc install fre

// Once fre is installed, the command is simple:
fre charter

// For quantitative variables, we'll want to use the "sum" command
// We saw how to use this with one variable above, but we can run the command with several
// variables at once by listing them out (it doesn't hurt to include qualitative variables):
sum charter passrate tsal tturn

// Since the four variables we chose are all next to each other in the dataset, we can
// also use a hyphen to indicate that we want all the variable between "charter" and "tturn"
sum charter-tturn

// We can use an if statement at the end of the sum command to get summary statistics
// for different subsets of the data (notice use of == because we're checking if the
// value of charter is 0):
sum tturn if charter==0
sum tturn if charter==1

// This is a rather complicated command to create a graph. We'll break it down in a moment
twoway (kdensity tturn if charter==1) (kdensity tturn if charter==0, lpattern(dash)), legend( col(1) label (1 "Charter Schools (mean=31, s.d.=14)") label (2 "Traditional Schools (mean=20, s.d.=10)")) xtitle("Teacher Turnover Rate (%)") ytitle("kdensity")

	// To simply create a kernel density plot of tturn for charter schools
	twoway kdensity tturn if charter==1
	
	// To stack to graphs on top of each other, we use parentheses to specify each graph:
	twoway (kdensity tturn if charter==1) (kdensity tturn if charter==0)
	
	// To make the graphs distinct, change the line pattern on the 2nd one (it may already
	// be dashed for you by default, depending on how things are configured in Stata):
	twoway (kdensity tturn if charter==1) (kdensity tturn if charter==0, lpattern(dash))
	
	// Now, we add a legend explaining graph 1 and graph 2, adding descriptive stats we
	// learned above when we ran the "sum" command:
	twoway (kdensity tturn if charter==1) (kdensity tturn if charter==0, lpattern(dash)), legend( label (1 "Charter Schools (mean=31, s.d.=14)") label (2 "Traditional Schools (mean=20, s.d.=10)"))
	
	// We specify the items in the legend should appear in 1 column:
	twoway (kdensity tturn if charter==1) (kdensity tturn if charter==0, lpattern(dash)), legend( col(1) label (1 "Charter Schools (mean=31, s.d.=14)") label (2 "Traditional Schools (mean=20, s.d.=10)"))
	
	// Finally, we customize the titles on the x and y axes:
	twoway (kdensity tturn if charter==1) (kdensity tturn if charter==0, lpattern(dash)), legend( col(1) label (1 "Charter Schools (mean=31, s.d.=14)") label (2 "Traditional Schools (mean=20, s.d.=10)")) xtitle("Teacher Turnover Rate (%)") ytitle("kdensity")

// Let's look at the turnover rate overall in the full sample (after labeling the variable)
la var tturn "Teacher Turnover Rate (%)"
kdensity tturn

// Since tturn is skewed right, the mean should be higher than the median
// Using the "detail" option with sum, we can compare the mean to the median (50% percentile):
sum tturn, detail // mean is 21.4; median is 19.3

// We can transform a variable through standardization using the "egen" command:
egen tturn_z = std(tturn)
la var tturn_z "Z-scores for Teacher Turnover Rate"
kdensity tturn_z

// Now, let's look at average teacher salaries
hist tsal

// We can create a log transformation of this variable:
gen logtsal = log(tsal)
hist logtsal

// Let's compare, using the "detail" option with sum, which gives us more info:
sum tsal, detail
sum logtsal, detail