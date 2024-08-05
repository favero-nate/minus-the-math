// Nathan Favero (https://minusthemath.com)
// Chapter 10 Lab (version: Aug 4, 2024)

// This lab demonstrates how multiple regression can adjust for a "third variable," as described in Chapter 10
// (assuming that we can measure the third variable). This content also overlaps with the discussion of
// multiple regression in the Ch. 3 appendix.

use https://www.stata-press.com/data/r14/auto.dta

sum

* A preliminary example: Do weight and foreign company ownership affect gas mileage (Miles Per Gallon)?
reg mpg weight foreign

* When we had just two variables, it was easy to graph our data/regression line in a 2-dimensional figure
* With three variables, graphing becomes more difficult because we require 3-dimensions (one for each variable)
* It is doable, though, if one of our independent variables is binary, as in this case:
twoway (scatter mpg weight if foreign==0, msymbol(Oh) mcolor(red)) ///
  (scatter mpg weight if foreign==1, msymbol(+) mcolor(blue)) ///
  (lfit mpg weight, lcolor(black)), ///
  legend(label(1 foreign==0) label(2 foreign==1))

* Now, let's look at a case where we likely have a 3rd variable problem initially, which we can then correct
* Are foreign cars more expensive?
reg price foreign // no, not necessarily
reg price foreign weight // wait a minute, what happened?

* Here's a graph of the 3-variable relationship
twoway (scatter price weight if foreign==0, msymbol(Oh) mcolor(red)) ///
  (scatter price weight if foreign==1, msymbol(+) mcolor(blue)) ///
  (lfit price weight, lcolor(black)), ///
  legend(label(1 foreign==0) label(2 foreign==1))

* It turns out that foreign cars tend to be smaller than domestic cars, by about 1000 pounds on average:
reg weight foreign

* Bigger cars are more expensive (every additional pound is estimated to add about $3 to the cost)
* So if we compare foreign and domestic cars while holding weight constant, foreign cars are much more expensive
* In other words, we expect a foreign car to be more expensive than a domestic car of the same size
* But the typical foreign car is about the same price as the typical domestic car (since the typical foreign car’s
* smaller size cancels out the otherwise-higher price)

* So are foreign cars more expensive than domestic cars?
* It depends on how you define the question. But now we can answer comprehensively given the above regressions.

* Last one: Are cars with better (lower) gas-mileage more expensive?
reg price mpg // are companies really charging less for more efficient (higher-mpg)  cars?
reg price mpg weight

* Cars with better (lower) gas-mileage tend to be smaller, and smaller cars are cheaper
* If we control for weight, the effect of gas-mileage becomes statistically insignificant
* In other words, there’s no evidence that the price systematically differs for two cars of the same size
* (weight) with different gas-mileage
* But the typical car with high gas-mileage is cheaper than the typical car with low gas-mileage (because
* the typical high-gas-mileage car is smaller)
