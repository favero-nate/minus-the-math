# Nathan Favero (https://minusthemath.com)
# Chapter 12 Lab (version: Aug 4, 2024)

library(tidyverse)
library(ggplot2)

#to read in data, you'll need to download BIG5.zip from the page https://openpsychometrics.org/_rawdata/
#after downloading, you'll need to unzip the file, and then you should have a file called data.csv
#set the working directory appropriately:
setwd("")
data <- read.delim("data.csv")

#create an index for overall extraversion
data <- mutate(data, extraversion = E1 - E2 + E3 - E4 + E5 - E6 + E7 - E8 + E9 - E10)
hist(data$extraversion)

#recode the gender variable: 0=NA, 1=male, 2=female, 3=other
data <- mutate(data, gender=recode_factor(data$gender, `1` = "Male", `2` = "Female", `3` = "Non-binary"))
data <- mutate(data, male=case_when(gender=="Male" ~ 1, gender=="Female" ~ 0))

#examine descriptive stats for extraversion by gender
library(psych)
describeBy(data$extraversion, group=data$gender)

#compare histograms for male vs. female
ggplot(subset(data, gender %in% c("Male","Female")), aes(x=extraversion)) + geom_histogram() + facet_grid(gender ~ .)

#run a regression comparing extraversion for male vs. female
summary(lm(extraversion ~ male, data))

#or, another approach to run an equivalent regression using the original gender variable
#(though the reference category changes from female to male)
summary(lm(extraversion ~ gender, data = subset(data, gender %in% c("Male","Female"))))

#a t-test, equivalent to the regression we just ran
t.test(extraversion ~ gender, data = subset(data, gender %in% c("Male","Female")))

#now, let's also consider non-binary
hist(data$extraversion[data$gender=="Non-binary"])

#here's a regression that accounts for all three gender categories
summary(lm(extraversion ~ gender, data = data))

#we can run an anova, with equivalent results to the regression we just ran
summary(aov(extraversion ~ gender, data = data))

#after anova, we can do pair-wise t-tests with bonferroni adjustments
pairwise.t.test(data$extraversion, data$gender, p.adj = "bonf")

#let's try to predict gender (male vs. female) based on the value of extraversion:
predict_gender <- lm(male ~ extraversion, data = subset(data, gender %in% c("Male","Female")))
summary(predict_gender)

#really, when the dependent variable is binary, we should use the "robust" option to calculate standard errors:
library(lmtest)
library(sandwich)
coeftest(predict_gender, vcov = vcovHC(predict_gender, type = "HC1"))
