 /*@@@@@@@@@@@@@@@@@@@@@@@@@@@
> @ Authors: Antonio J       @
> @ Date: 3/17/2021           @
> @ Filename: midterm.do     @
> @@@@@@@@@@@@@@@@@@@@@@@@@@*/

/*-----------------------------------------
@ Loading data and initializing log file  @
-----------------------------------------*/
// Clear previously stored data and set global options
cls
clear all

webuse union

// Store results in a log file (diary)
cd "/Users/labteam/Google Drive/Spring 2021/ECO 531/logs"
log using "midterm.txt", replace text

// keeping the relevant data and generating a new variable
drop if year != 77
drop year

generate smsa = 0
replace smsa = 1 if not_smsa == 0

/*-----------------------------------
@ Analysis                          @
-----------------------------------*/
probit union age grade south smsa
predict union_p

scalar logl2 = e(ll)
margins, dydx(*)
margins, dydx(*) atmeans

scatter union union_p grade

qui probit union south smsa
scalar logl1 = e(ll)

di "log likelihood 1 = " logl1
di "log likelihood 2 = " logl2
di "chi_squared = " 2*(logl2-logl1)
di "Prob > chi_squared = " chi2tail(2, 2*(logl2-logl1))

/*-----------------------------------
@ Close log file					@
-----------------------------------*/
log close

