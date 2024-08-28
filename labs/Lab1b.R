# Nathan Favero (https://minusthemath.com)
# Chapter 1 Lab - Part B (version: Aug 28, 2024)

# This lab contains examples using the 2018 GSS, a survey of US adults

# An easy way to get the GSS data is to download the GSSR package (https://github.com/kjhealy/gssr)
install.packages('gssr', repos =
                   c('https://kjhealy.r-universe.dev', 'https://cloud.r-project.org'))

# You can skip this line if tidyverse is already installed on your computer
install.packages("tidyverse")

# Load necessary libraries (note: dplyr is part of tidyverse)
library(dplyr)
library(gssr)

# This loads in the 2018 data; you can learn about the variables here: https://gssdataexplorer.norc.org/variables/vfilter
gss18 <- gss_get_yr(2018)

# We're interested in the variable "satjob", but it is coded such that higher
# values indicated dissatisfaction, which is potentially confusing.
# Since the variable ranges from 1 (very satisfed) to 4 (very dissatisfied),
# we can flip the coding around by subtracting the current value from 5.
# So for example, 1 will become 4 since 5-1=4.

# We accomplish this by creating a new variable "job_satis" in the gss18 data
# frame, using the function "mutate". The actual code is a bit complex.
# Our statement begins by telling R where we want to store the result of our
# mutation, which yields a dataset with the new variable included.
# We want to simply overwrite the existing dataset, so we begin with "gss18 <-"
# to indicate that we will store our results in the object "gss18", which
# implies overwriting the current dataset since it has the name "gss18".

# We also use piping (|>), but we could have instead written the statement as:
#   gss18 <- mutate(gss18, job_satis = 5 - satjob)
# "gss18 |>" tells R to feed the dataset gss18 into the function that follows
gss18 <- gss18 |>
  mutate(job_satis = 5 - satjob)

# Check the new variable
head(gss18$job_satis)

# Create a very simple scatter plot (which is not very useful because many
# observations have the exact same values, which get stacked on top of each
# other, appearing as a single observation)
plot(gss18$educ, gss18$job_satis)

# Create a scatter plot with jittered points, plus nice titles
plot(jitter(gss18$educ, factor = 0.2),
     jitter(gss18$job_satis, factor = 0.2),
     xlab = "Education Level",
     ylab = "Job Satisfaction",
     main = "Jittered Scatter Plot of Education vs. Job Satisfaction")

# We can also change them to solid circles through changing "pch" and add
# transparency (alpha = 30%); note that red=0, green=0, blue=0 yields black
plot(jitter(gss18$educ, factor = 0.2),
     jitter(gss18$job_satis, factor = 0.2),
     xlab = "Education Level",
     ylab = "Job Satisfaction",
     main = "Jittered Scatter Plot of Education vs. Job Satisfaction",
     pch = 16, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.3))


# Add a regression line
abline(lm(gss18$job_satis ~ gss18$educ), col = "black")

# We can easily control many more features of our plots using ggplot2
library(ggplot2)

# Create a black and white scatter plot with vertically jittered and transparent
# points, plus a regression line
ggplot(gss18, aes(x = educ, y = job_satis)) +
  geom_jitter(width = 0, height = 0.05, color = "black", alpha = 0.1) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(x = "Education Level", y = "Job Satisfaction",
       title = "Vertically Jittered Scatter Plot of Education vs. Job Satisfaction with Regression Line") +
  theme_bw()


