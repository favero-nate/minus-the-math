# Nathan Favero (https://minusthemath.com)
# Chapter 1 Lab - Part A (version: Aug 28, 2024)

satdata <- read.table("https://minusthemath.com/data/binge.csv", sep=",", header=TRUE)
# original file downloaded as Excel doc from https://onlinestatbook.com/2/case_studies/binge.html
# dataset description/coding also explained at link above

# converting sex to a factor variable with nice labels
satdata$sex <- factor(satdata$sex,
                      levels = c(1,2),
                      labels = c("Male", "Female"))

# histogram with qualitative variable (notice the labels we created are nicely applied here)
barplot(prop.table(table(satdata$sex)))

# let's look at a quantitative variable: mo_binge_n measures "Number of times
# binge drinking last month"

# we'll create three different graphs

# first, a histogram:
hist(satdata$mo_binge_n)
# we can modify the titles to look better
hist(satdata$mo_binge_n,
     main = "",
     xlab = "Number of times binge drinking last month")

# now, a kernel density plot:
plot(density(satdata$mo_binge_n))
# we can split the "plot" and "density" functions into two different statements
# and also fix the titles
d <- density(satdata$mo_binge_n)
plot(d,
     main = "",
     xlab = "Number of times binge drinking last month")

# finally, a boxplot:
boxplot(satdata$mo_binge_n,
        horizontal = TRUE)

# now, we'll create two graphs that require installing user-written packages
# first, we'll install the package vioplot (note: you only need to do this once):
install.packages("vioplot")

# once a package has been installed on our computer, we can use "library" to
# load the package into R:
library(vioplot)

# with the vioplot package loaded, we can now use the "vioplot" function:
vioplot(satdata$mo_binge_n,
        horizontal=TRUE)

# our axis only labels one point; we can get a much better plot with ggplot2:
install.packages("tidyverse")
library(ggplot2)
ggplot(satdata,
       aes(x = mo_binge_n, y = "")) +
       geom_violin()

# now, let's make a stripplot using the lattice package
install.packages("lattice")
library(lattice)
stripplot(~mo_binge_n,
          data = satdata,
          jitter = TRUE)

# finally, let's make a histogram for a discrete variable:
hist(satdata$u_fam,
     main = "",
     xlab = "Familiarity with alcohol unit-based guidelines",
     breaks = ((min(satdata$u_fam) - 1):max(satdata$u_fam)) + 0.5)
     
	# if we don't specify the breaks (where the bins start), we get a pretty ugly
  # graph because of the default binning:
  hist(satdata$u_fam)
  