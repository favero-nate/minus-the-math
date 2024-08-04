// Nathan Favero (https://minusthemath.com)
// Lecture 5 (version: Aug 3, 2024)

insheet using "https://github.com/favero-nate/minus-the-math/raw/main/lecture_slides/data_files/data_20170517.csv"
// data file originally downloaded here: https://doi.org/10.1371/journal.pone.0183224
// data shared under CC BY (http://creativecommons.org/licenses/by/4.0/)
// full citation: Hwang S-H, Lee JY, Yi S-M, Kim H (2017) Associations of particulate matter and its components with emergency room visits for cardiovascular and respiratory diseases. PLoS ONE 12(8): e0183224. https://doi.org/10.1371/journal.pone.0183224

keep if year==2011

la define days 1 "Sun" 2 "Mon" 3 "Tues" 4 "Wed" 5 "Thur" 6 "Fri" 7 "Sat"
la values dow days

la define sea 4 "Dec-Feb" 1 "Mar-May" 2 "Jun-Aug" 3 "Sep-Nov"
la values season sea

la var circ "Cardiovascular admissions"
la var resp "Respiratory admissions"

// appendix slide 3
hist circ

sum circ

// appendix slide 5
hist circ, width(1)

// appendix slide 6
tab circ

// appendix slide 8
hist circ, normal

hist circ, normal width(1)

// appendix slide 10
graph box circ , over( dow )

// appendix slide 11
hist circ if dow==5, width(1)

tab circ if dow==5

// appendix slide 12
hist circ if dow==5, normal

// appendix slide 13
hist circ if dow <=3, by(dow, col(1) legend(off) note("")) normal normopts(lwidth(thick)) xtitle("")

bys dow : sum circ

// appendix slide 14
hist resp

