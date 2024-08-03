// Nathan Favero (https://minusthemath.com)
// Lecture 3 (version: Aug 3, 2024)

insheet using "https://github.com/favero-nate/minus-the-math/raw/main/lecture_slides/data_files/district_snapshot_2018.dat"
// Source: Texas Education Agency district snapshots - 2018 version
// The file "district_snapshot_2018.txt" is a codebook (originally downloaded with a .lyt file extension)

gen charter = [commtype=="Charters"]
gen passrate = dda00a001218r if dda00a001218r >= 0
gen tsal = dpsttosa if dpsttosa >= 0
gen tturn = dpsturnr if dpsturnr >= 0

gen oneschooldist = (dzcampus==1)

label define chartercode 0 "Traditional Schools" 1 "Charter Schools"
label values charter chartercode
la var oneschooldist "Single-School District"

order charter passrate tsal tturn oneschooldist

*******

// slide 5
sum passrate if charter==0
sum passrate if charter==1

// slide 8
tabstat passrate, s(median) by(charter)

// slide 10
graph box passrate, over(charter)	

// slides 12/13
tab oneschooldist charter, col


*******


// slide 16
use https://www.stata-press.com/data/r16/auto, clear
twoway scatter price weight, title("Price & Weight of Common Automobiles")


*******

clear all
set seed 1234567

set obs 20

gen x1 = rnormal()
gen y1 = -.2 * x1 + sqrt(.3) * rnormal()

// slide 22
twoway scatter (y1 x1) ///
	, aspectratio(1) xsize(4) ysize(4) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono) legend(off) ytitle("y1")

// slide 23
twoway (scatter y1 x1) (lfit y1 x1, lwidth(medthick) lcolor(black) ) ///
	, aspectratio(1) xsize(4) ysize(4) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono) legend(off) ytitle("y1")


****** scatter plots demonstrating correlation/covariance with simulated data ******
// note: the remainder of this file is simulated data for scatterplots.
// this section of code is not very clean, and I use global scalars rather
// than local, which I believe violates best practice. but perhaps someone
// will still learn something from this imperfect code.

*** positive relationship

clear all
set seed 1234567

set obs 10

gen x1 = rnormal()
gen y1 = sqrt(.5) * x1 + sqrt(.5) * rnormal()

sum x1
global x1_bar = r(mean)
sum y1
global y1_bar = r(mean)

corr x1 y1
global corr_x1y1: display %3.2f r(rho)

// slide 19
twoway scatter (y1 x1) ///
	, text(3 -2 "Corr(x,y)=${corr_x1y1}", place(c) size(large) color(blue)) ///
	aspectratio(1) xsize(4) ysize(4) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)

// appendix slide 1
twoway scatter (y1 x1) ///
	, text(3 -2 "Corr(x,y)=${corr_x1y1}", place(c) size(large) color(blue)) ///
	text(2.3 2.2 "+", place(c) size(vhuge) color(red)) ///
	text(-2.3 -2.2 "+", place(c) size(vhuge) color(red)) ///
	text(-2.3 2.2 "-", place(c) size(vhuge) color(red)) ///
	text(2.3 -2.2 "-", place(c) size(vhuge) color(red)) ///
	aspectratio(1) xsize(4) ysize(4) xline($x1_bar ) yline($y1_bar ) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)


*** negative relationship

gen x2 = rnormal()
gen y2 = -sqrt(.5) * x2 + sqrt(.5) * rnormal()

sum x2
global x2_bar = r(mean)
sum y2
global y2_bar = r(mean)

//corr x2 y2, covariance
//global cov_x2y2 = round(r(cov_12),.01)
corr x2 y2
global corr_x2y2: display %3.2f r(rho)

twoway scatter (y2 x2) ///
	, text(3 -2 "Corr(x,y)=${corr_x2y2}", place(c) size(large) color(blue)) ///
	aspectratio(1) xsize(4) ysize(4) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)

// appendix slide 3
twoway scatter (y2 x2) ///
	, text(3 -2 "Corr(x,y)=${corr_x2y2}", place(c) size(large) color(blue)) ///
	text(2.3 2.2 "+", place(c) size(vhuge) color(red)) ///
	text(-2.3 -2.2 "+", place(c) size(vhuge) color(red)) ///
	text(-2.3 2.2 "-", place(c) size(vhuge) color(red)) ///
	text(2.3 -2.2 "-", place(c) size(vhuge) color(red)) ///
	aspectratio(1) xsize(4) ysize(4) xline($x2_bar ) yline($y2_bar ) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)


*** no relationship

gen x3 = rnormal()
gen y3 = -sqrt(0) * x3 + sqrt(1) * rnormal()

sum x3
global x3_bar = r(mean)
sum y3
global y3_bar = r(mean)

corr x3 y3
global corr_x3y3: display %3.2f r(rho)

// slide 20
twoway scatter (y3 x3) ///
	, text(3 -2 "Corr(x,y)=${corr_x3y3}", place(c) size(large) color(blue)) ///
	aspectratio(1) xsize(4) ysize(4) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)

// appendix slide 4
twoway scatter (y3 x3) ///
	, text(3 -2 "Corr(x,y)=${corr_x3y3}", place(c) size(large) color(blue)) ///
	text(2.3 2.2 "+", place(c) size(vhuge) color(red)) ///
	text(-2.3 -2.2 "+", place(c) size(vhuge) color(red)) ///
	text(-2.3 2.2 "-", place(c) size(vhuge) color(red)) ///
	text(2.3 -2.2 "-", place(c) size(vhuge) color(red)) ///
	aspectratio(1) xsize(4) ysize(4) xline($x3_bar ) yline($y3_bar ) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)


*** slight positive relationship

gen x4 = rnormal()
gen y4 = sqrt(.2) * x4 + sqrt(.8) * rnormal()

sum x4
global x4_bar = r(mean)
sum y4
global y4_bar = r(mean)

//corr x4 y4, covariance
//global cov_x4y4 = round(r(cov_12),.01)
corr x4 y4
global corr_x4y4: display %3.2f r(rho)

// appendix slide 5
twoway scatter (y4 x4) ///
	, text(3 -2 "Corr(x,y)=${corr_x4y4}", place(c) size(large) color(blue)) ///
	aspectratio(1) xsize(4) ysize(4) xline($x4_bar ) yline($y4_bar ) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)


*** slope doesn't matter

gen x5 = 1 + 2*rnormal()
gen y5 = -sqrt(.8) * x5 + sqrt(.2) * rnormal()

sum x5
global x5_bar = r(mean)
sum y5
global y5_bar = r(mean)

//corr x5 y5, covariance
//global cov_x5y5 = round(r(cov_12),.01)
corr x5 y5
global corr_x5y5: display %3.2f r(rho)

// appendix slide 6
twoway scatter (y5 x5) ///
	, text(3 -2 "Corr(x,y)=${corr_x5y5}", place(c) size(large) color(blue)) ///
	aspectratio(1) xsize(4) ysize(4) xline($x5_bar ) yline($y5_bar ) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)


gen x6 = x5
gen y6 = .3*y5

sum x6
global x6_bar = r(mean)
sum y6
global y6_bar = r(mean)

//corr x6 y6, covariance
//global cov_x6y6 = round(r(cov_12),.01)
corr x6 y6
global corr_x6y6: display %3.2f r(rho)

// appendix slide 7
twoway scatter (y6 x6) ///
	, text(3 -2 "Corr(x,y)=${corr_x6y6}", place(c) size(large) color(blue)) ///
	aspectratio(1) xsize(4) ysize(4) xline($x6_bar ) yline($y6_bar ) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)

// appendix slide 8
twoway scatter (y6 x6) ///
	, text(3 -2 "Corr(x,y)=${corr_x6y6}", place(c) size(large) color(blue)) ///
	aspectratio(1) xsize(4) ysize(4) xline($x6_bar ) yline($y6_bar ) ylabel(-1(1)1) xlabel(-4(1)4) scheme(s1mono)

gen x7 = .5*x5
gen y7 = y5

sum x7
global x7_bar = r(mean)
sum y7
global y7_bar = r(mean)

//corr x7 y7, covariance
//global cov_x7y7 = round(r(cov_12),.01)
corr x7 y7
global corr_x7y7: display %3.2f r(rho)

twoway scatter (y7 x7) ///
	, text(3 -2 "Corr(x,y)=${corr_x7y7}", place(c) size(large) color(blue)) ///
	aspectratio(1) xsize(4) ysize(4) xline($x7_bar ) yline($y7_bar ) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)

**********************
*** Covariance
**********************
clear all
set obs 3

gen x = 5 in 1
replace x = 2 in 2
replace x = 2 in 3

gen y = 5 in 1
replace y = 4 in 2
replace y = 0 in 3

// appendix slide 18
twoway (scatter y x ) ///
	   , aspectratio(1) xsize(4) ysize(4) ylabel(-1(1)7) xlabel(-1(1)7) scheme(s1mono)

// appendix slide 19
twoway (scatter y x ) ///
	   , text(5.3 5.2 "+", place(c) size(vhuge) color(red)) ///
	   text(.7 .8 "+", place(c) size(vhuge) color(red)) ///
	   text(.7 5.2 "-", place(c) size(vhuge) color(red)) ///
	   text(5.3 .8 "-", place(c) size(vhuge) color(red)) ///
	   aspectratio(1) xsize(4) ysize(4) xline(3) yline(3) ylabel(-1(1)7) xlabel(-1(1)7) scheme(s1mono)

// appendix slide 20
twoway (scatter y x ) ///
       (scatteri 3 5 5 5, recast(line) legend(off) lpattern(dash) ) ///
       (scatteri 5 3 5 5, recast(line) legend(off) lpattern(dash) ) ///
	   , text(4 5.1 "+2", place(e)) ///
	   text(5.1 4 "+2", place(n)) ///
	   text(6 5 "(+2)*(+2) = 4", place(c) color(red)) ///
	   aspectratio(1) xsize(4) ysize(4) xline(3) yline(3) ylabel(-1(1)7) xlabel(-1(1)7) scheme(s1mono)

// appendix slide 21
twoway (scatter y x ) ///
       (scatteri 3 2 4 2, recast(line) legend(off) lpattern(dash) ) ///
       (scatteri 4 3 4 2, recast(line) legend(off) lpattern(dash) ) ///
	   , text(3.5 1.9 "+1", place(w)) ///
	   text(4.1 2.5 "-1", place(n)) ///
	   text(5 1 "(-1)*(+1) = -1", place(c) color(red)) ///
	   aspectratio(1) xsize(4) ysize(4) xline(3) yline(3) ylabel(-1(1)7) xlabel(-1(1)7) scheme(s1mono)

// appendix slide 22
twoway (scatter y x ) ///
       (scatteri 3 2 0 2, recast(line) legend(off) lpattern(dash) ) ///
       (scatteri 0 3 0 2, recast(line) legend(off) lpattern(dash) ) ///
	   , text(1.5 1.9 "-3", place(w)) ///
	   text(-.1 2.5 "-1", place(s)) ///
	   text(0 .5 "(-1)*(-3) = 3", place(c) color(red)) ///
	   aspectratio(1) xsize(4) ysize(4) xline(3) yline(3) ylabel(-1(1)7) xlabel(-1(1)7) scheme(s1mono)

corr x y, cov
corr x y



*** positive relationship

clear all
set seed 1234567

set obs 10

gen x1 = rnormal()
gen y1 = sqrt(.15) * x1 + sqrt(.85) * rnormal()

sum x1
global x1_bar = r(mean)
sum y1
global y1_bar = r(mean)

corr x1 y1, covariance
global cov_x1y1 = round(r(cov_12),.01)
corr x1 y1

// appendix slide 23
twoway scatter (y1 x1) ///
	, text(3 -2 "Cov(x,y)=${cov_x1y1}", place(c) size(large) color(blue)) ///
	text(2.3 2.2 "+", place(c) size(vhuge) color(red)) ///
	text(-2.3 -2.2 "+", place(c) size(vhuge) color(red)) ///
	text(-2.3 2.2 "-", place(c) size(vhuge) color(red)) ///
	text(2.3 -2.2 "-", place(c) size(vhuge) color(red)) ///
	aspectratio(1) xsize(4) ysize(4) xline($x1_bar ) yline($y1_bar ) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)


*** negative relationship

gen x2 = rnormal()
gen y2 = -sqrt(.15) * x2 + sqrt(.85) * rnormal()

sum x2
global x2_bar = r(mean)
sum y2
global y2_bar = r(mean)

corr x2 y2, covariance
global cov_x2y2 = round(r(cov_12),.01)
corr x2 y2

// appendix slide 24
twoway scatter (y2 x2) ///
	, text(3 -2 "Cov(x,y)=${cov_x2y2}", place(c) size(large) color(blue)) ///
	text(2.3 2.2 "+", place(c) size(vhuge) color(red)) ///
	text(-2.3 -2.2 "+", place(c) size(vhuge) color(red)) ///
	text(-2.3 2.2 "-", place(c) size(vhuge) color(red)) ///
	text(2.3 -2.2 "-", place(c) size(vhuge) color(red)) ///
	aspectratio(1) xsize(4) ysize(4) xline($x2_bar ) yline($y2_bar ) ylabel(-4(1)4) xlabel(-4(1)4) scheme(s1mono)
