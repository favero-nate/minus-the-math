// Nathan Favero (https://minusthemath.com)
// Chapter 3 Lab - Part B (version: Aug 4, 2024)

insheet using "https://onlinestatbook.com/2/case_studies/data/sat.txt", delimiter(" ")

twoway scatter univ_gpa high_gpa
corr univ_gpa high_gpa

reg univ_gpa high_gpa

twoway (scatter univ_gpa high_gpa) (lfit univ_gpa high_gpa)

gen sat = math_sat + verb_sat
twoway scatter univ_gpa sat
reg univ_gpa high_gpa sat
corr univ_gpa sat
corr high_gpa sat