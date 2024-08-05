# Nathan Favero (https://minusthemath.com)
# Chapter 8 Lab (version: Aug 4, 2024)

library(tidyverse)

data<-read_csv("https://ippsr.msu.edu/sites/default/files/cspp/cspp_core_academic_2-6.csv")

# Variable definitions (https://ippsr.msu.edu/sites/default/files/CorrelatesCodebook.pdf)
# region - "If state is located in South (1), West (2), Midwest (3), Northeast (4)"
# mood - "An over-time, state-level measure of Stimson’s (1999) policy mood" (higher values roughly indicate a more politically left-leaning public)

# Delete observations from years other than 2000 to get a simpler dataset
data <- data |> filter(year == 2000)

# We want to know, does policy mood differ meaningfully by region?

# First, we can examine a mean estimate with confidence interval for each region
library(psych)
describeBy(data$mood, group=data$region)

# Now, let's run a series of t-tests (note: we've not adjusted for multiple comparisons, which is potentially problematic)
# (Also, we are assuming variance is equal; not necessarily a good assumption, but this will align with other methods we'll compare to in a moment)
t.test(mood ~ region, data = data[data$region==1|data$region==2, ], var.equal = TRUE)
t.test(mood ~ region, data = data[data$region==1|data$region==3, ], var.equal = TRUE)
t.test(mood ~ region, data = data[data$region==1|data$region==4, ], var.equal = TRUE)

# Let's run an ANOVA
summary(aov(mood ~ factor(region), data = data))

# We can rerun the ANOVA and tell Stata to follow up with multiple comparison-adjusted pairwise test
pairwise.t.test(data$mood, data$region, p.adj = "bonf")

# Let's compare regression results to those of the ANOVA and the t-tests
summary(lm(mood ~ factor(region), data = data))
