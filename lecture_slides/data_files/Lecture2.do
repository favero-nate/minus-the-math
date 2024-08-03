// Nathan Favero (https://minusthemath.com)
// Lecture 2 (version: Aug 3, 2024)

insheet using "https://github.com/favero-nate/minus-the-math/raw/main/lecture_slides/data_files/district_snapshot_2018.dat"
// Source: Texas Education Agency district snapshots - 2018 version
// The file "district_snapshot_2018.txt" is a codebook (originally downloaded with a .lyt file extension)

gen charter = [commtype=="Charters"]
gen passrate = dda00a001218r if dda00a001218r >= 0
gen tsal = dpsttosa if dpsttosa >= 0
gen tturn = dpsturnr if dpsturnr >= 0

label define chartercode 0 "Traditional Schools" 1 "Charter Schools"
label values charter chartercode

order charter passrate tsal tturn

*******

// slide 9:
sum tturn if charter==0
sum tturn if charter==1
twoway (kdensity tturn if charter==1) (kdensity tturn if charter==0, lpattern(dash)), legend( col(1) label (1 "Charter Schools (mean=31, s.d.=14)") label (2 "Traditional Schools (mean=20, s.d.=10)")) xtitle("Teacher Turnover Rate (%)") ytitle("kdensity")
	
// slide 11:
la var tturn "Teacher Turnover Rate (%)"
kdensity tturn

// slide 12:
egen tturn_z = std(tturn)
la var tturn_z "Z-scores for Teacher Turnover Rate"
kdensity tturn_z

// slide 16:
hist tsal

// slide 17:
gen logtsal = log(tsal)
hist logtsal

// slides 18/19:
sum tsal, detail
sum logtsal, detail