 /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
> @ Authors: Antonio J            @
> @ Date: 4/19/2021               @
> @ Filename: problem_set_04.do   @
> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

/*-----------------------------------------
@ Loading data and initializing log file  @
-----------------------------------------*/
// Clear previously stored data and set global options
cls
clear all
cd "antoniojurlina/Projects/advanced_econometrics/data"

use "count.dta" // load data

// Store results in a log file (diary)
cd "antoniojurlina/Projects/advanced_econometrics/output"
log using "project_04_log.txt", replace text


/*-----------------------------------
@ Models                    		@
-----------------------------------*/
// Poisson
qui poisson visits nkids access status
estimates store poiss
predict visits_hat
qui margins, dydx(*) post
estimates store me_poiss

// Negative Binomial Type 1 model
qui nbreg visits nkids access status, dispersion(constant)
estimates store nb1
qui margins, dydx(*) post
estimates store me_nb1

// Negative Binomial Type 2 model
qui nbreg visits nkids access status, dispersion(mean)
estimates store nb2
qui margins, dydx(*) post
estimates store me_nb2

/*-----------------------------------
@ Tests                      		@
-----------------------------------*/
// Rule of thumb
qui summarize visits
display "Rule of Thumb Test: " round(r(sd)^2/r(mean), 0.001)

// Auxiliary regression
generate aux = ((visits-visits_hat)^2-visits)/visits_hat
qui regress aux visits_hat, noconstant
display "Auxiliary Regression Test: " _b[visits_hat]

/*-----------------------------------
@ Results                      		@
-----------------------------------*/
// Generate a table of estimates
esttab poiss nb1 nb2, ///
	mtitles("Poisson" "NB1" "NB2") b(3) se(3) ///
	star(* 0.1 ** 0.05 *** 0.01) nogaps

// Generate a table of margins
esttab me_poiss me_nb1 me_nb2, ///
	mtitles("Poisson" "NB1" "NB2") b(3) se(3) ///
	star(* 0.1 ** 0.05 *** 0.01) nogaps

// Close log file
log close
