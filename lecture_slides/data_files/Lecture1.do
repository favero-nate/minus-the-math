// Nathan Favero (https://minusthemath.com)
// Lecture 1 (version: Aug 3, 2024)

insheet using "https://github.com/favero-nate/minus-the-math/raw/main/lecture_slides/data_files/binge.csv"
// original file downloaded as Excel doc from https://onlinestatbook.com/2/case_studies/binge.html
// dataset description/coding also explained at link above

la var sex "Sex"
la def sex_val 1 "Male" 2 "Female"
la val sex sex_val

graph hbar (count), over(sex) // slide 8

la var mo_binge_n "Number of times binge drinking last month"

graph box mo_binge_n, over(sex) // slide 12
	
hist mo_binge_n // slide 14
kdensity mo_binge_n // slide 15
graph box mo_binge_n, horizontal // slide 16

findit vioplot // install package if need be
vioplot mo_binge_n, horizontal // slide 17

findit stripplot // install package if need be
stripplot mo_binge_n, jitter(10) // slide 18


// Not on slides, but here is an example of a histogram for a discrete variable:
la var u_fam "Familiarity with alcohol unit-based guidelines"
hist u_fam, discrete freq