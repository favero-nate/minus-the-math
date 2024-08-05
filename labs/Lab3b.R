# Nathan Favero (https://minusthemath.com)
# Chapter 3 Lab - Part B (version: Aug 4, 2024)

satdata <- read.table("https://onlinestatbook.com/2/case_studies/data/sat.txt", sep=" ", header=TRUE)
plot(satdata$high_GPA, satdata$univ_GPA)
cor(satdata$univ_GPA, satdata$high_GPA)

summary(lm(univ_GPA ~ high_GPA, data=satdata))

plot(satdata$high_GPA, satdata$univ_GPA)
abline(lm(univ_GPA ~ high_GPA, data=satdata))

satdata$SAT <- satdata$math_SAT + satdata$verb_SAT
plot(satdata$SAT, satdata$univ_GPA)
summary(lm(univ_GPA ~ high_GPA + SAT, data=satdata))
cor(satdata$univ_GPA, satdata$SAT)
cor(satdata$high_GPA, satdata$SAT)
