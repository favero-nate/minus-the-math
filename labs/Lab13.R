# Nathan Favero (https://minusthemath.com)
# Chapter 13 Lab (version: Aug 4, 2024)

library(tidyverse)
library(haven)
library(psych)
library(gmodels)

data <- read_dta("http://www.stata-press.com/data/r14/nlsw88.dta")
# These data come from a 1988 survey of women in the labor force (National Longitudinal Survey of Mature and Young Women)

table(data$race)

# add factor labels since they aren't preserved from Stata file
data$race <- factor(data$race, levels=c(1,2,3), labels=c("white", "black", "other"))
table(data$race)

# create binary race variable (drop "other")
data <- data |> 
  mutate(white=ifelse(race=="white", 1, ifelse(race=="black",0,NA)))
table(data$white, data$race, useNA="ifany")

# 3 methods of seeing whether the mean wage is different for whites and blacks

  # two-sample t-test
  t.test(wage ~ white, data = data)
  # if we want to get a p-value equivalent to our other methods, 
  # we can change settings to make the assumption that the variances 
  # in the two sub-populations (for Black and white respondents) are equivalent:
  t.test(wage ~ white, data = data, var.equal = TRUE)
  
  # ANOVA
  summary(aov(wage ~ white, data))
  
  # equivalent regression
  summary(lm(wage ~ white, data))


table(data$occupation)

#create new occupation variable without categories with almost no observations
data <- data |> 
  mutate(occupation11=ifelse(occupation != 9 & occupation != 12, occupation, NA))
table(data$occupation11)

# 2 methods of seeing whether the mean wage is different by occupation

  # ANOVA
  summary(aov(wage ~ factor(occupation11), data = data))
  describeBy(data$wage, group=data$occupation11)
  
  # equivalent regression
  summary(lm(wage ~ factor(occupation11), data))


# 2 methods of seeing whether race is associated with occupation (chi-square or regression)

# chi2 test (order of variables doesn't matter)
  CrossTable(data$occupation11, data$white, prop.c=FALSE, prop.t=FALSE, prop.chisq=FALSE, chisq=TRUE)
	# or:
  CrossTable(data$occupation11, data$white, prop.r=FALSE, prop.t=FALSE, prop.chisq=FALSE, chisq=TRUE)
	# or:
  CrossTable(data$white, data$occupation11, prop.r=FALSE, prop.t=FALSE, prop.chisq=FALSE, chisq=TRUE)
  
	# similar (not quite equivalent) approach using regression
  summary(lm(white ~ factor(occupation11), data))

	
	# if I want to include the "other" race category:
	# chi2 test:
  CrossTable(data$occupation11, data$race, prop.c=FALSE, prop.t=FALSE, prop.chisq=FALSE, chisq=TRUE)

	# similar (not quite equivalent) approach using regression
  data <- data |> 
    mutate(race_1=ifelse(race=="white", 1, 0))
  data <- data |> 
    mutate(race_2=ifelse(race=="black", 1, 0))
  data <- data |> 
    mutate(race_3=ifelse(race=="other", 1, 0))
  summary(lm(race_1 ~ factor(occupation11), data))
  summary(lm(race_2 ~ factor(occupation11), data))
  summary(lm(race_3 ~ factor(occupation11), data))
  
	
# if I want to use multiple independent variables, I have to use regression
  summary(lm(wage ~ tenure + white + factor(occupation11), data))
