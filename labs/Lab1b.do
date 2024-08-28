// Nathan Favero (https://minusthemath.com)
// Chapter 1b Lab (version: Aug 28, 2024)

// This do-file contains examples using the 2018 GSS, a survey of US adults

// You will want to set the working directory to the folder in which you want the GSS dataset
//  to be saved (copy-paste the directory of that folder between the quotation marks):
cd ""



// Note: If the following line gives you an error, try manually downloading the 2018 file from this site: https://gss.norc.org/
unzipfile "https://gss.norc.org/documents/stata/2018_stata.zip"

use "GSS2018.dta" // update if the unzipped file has a different name (e.g., changed names in a new version)

// You can learn about the variables in this dataset here: https://gssdataexplorer.norc.org/variables/vfilter

// We're interested in the variable "satjob", but it is coded such that higher
// values indicated dissatisfaction, which is potentially confusing.
// Since the variable ranges from 1 (very satisfed) to 4 (very dissatisfied),
// we can flip the coding around by subtracting the current value from 5.
// So for example, 1 will become 4 since 5-1=4.
// We accomplish this by creating a new variable "job_satis":
gen job_satis = 5-satjob

// Check the new variable
codebook job_satis

// Create a very simple scatter plot (which is not very useful because many
// observations have the exact same values, which get stacked on top of each
// other, appearing as a single observation)
twoway scatter job_satis educ

// Create a scatter plot with jittered points, plus nice titles
// Note we use three slashes (///) to indicate that our command will continue
// on the following line. We must select both lines together before clicking
// "execute" from a do-file for a command spanning 2 lines.
twoway scatter job_satis educ, jitter(2) ///
	xtitle(Education Level) ytitle(Job Satisfaction) title(Jittered Scatter Plot of Education vs. Job Satisfaction)

// We can also add some transparency to the points (30% transparency in this example)
twoway scatter job_satis educ, jitter(2) mcolor(%30) ///
	xtitle(Education Level) ytitle(Job Satisfaction) title(Jittered Scatter Plot of Education vs. Job Satisfaction)

// Add a regression line
twoway (scatter job_satis educ, jitter(2) mcolor(%30)) ///
	(lfit job_satis educ) ///
	, xtitle(Education Level) ytitle(Job Satisfaction) title(Jittered Scatter Plot of Education vs. Job Satisfaction)

// We can eliminate the legend at the bottom of the graph, since it's uncessary in this case
twoway (scatter job_satis educ, jitter(2) mcolor(%30)) ///
	(lfit job_satis educ) ///
	, xtitle(Education Level) ytitle(Job Satisfaction) title(Jittered Scatter Plot of Education vs. Job Satisfaction) ///
	legend(off)
