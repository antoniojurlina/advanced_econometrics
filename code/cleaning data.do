 /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
> @ Authors: Antonio J, Yelshadady G, Shelby F., Lakshya B.    @
> @ Date: 3/3/2021                                             @
> @ Filename: lab_03.do                                        @
> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

/*-----------------------------------------
@ Loading data and initializing log file  @
-----------------------------------------*/
// Clear previously stored data and set global options
cls
clear all
cd "/Users/labteam/Google Drive/Spring 2021/ECO 531/data"

use "wageV1.dta" // load data

// Store results in a log file (diary)
cd "/Users/labteam/Google Drive/Spring 2021/ECO 531/logs"
log using "lab_03_log.txt", replace text

// generate new variable (if it isn't already there)
capture confirm variable lwage, exact
if _rc {
	generate lwage = log(wage)
}

/*-----------------------------------
@ Basic descriptive statistics		@
-----------------------------------*/
browse

summarize wage educ exper sex married region

correlate wage educ exper sex married region

inspect wage
inspect educ
inspect exper
inspect sex
inspect married
inspect region

/*-----------------------------------
@ Plots 		                    @
-----------------------------------*/
histogram wage, name(wage)
histogram educ, name(educ)
histogram exper, name(exper)
histogram sex, name(sex)
histogram married, name(married)
histogram region, name(region)

graph twoway (scatter wage educ) (lfit wage educ), name(wage_v_educ)
graph twoway (scatter wage exper) (lfit wage exper), name(wage_v_exper)

/*-----------------------------------
@ Exploring misssing data           @
-----------------------------------*/
misstable patterns
misstable summarize
misstable tree
misstable nested

/*-----------------------------------
@ Filling misssing data             @
-----------------------------------*/
generate educ_mean = educ
generate educ_mode = educ
generate educ_ols = educ

summarize(educ), detail
replace educ_mean = r(mean) if educ == .
replace educ_mode = r(p50) if educ == .

regress educ exper wage male married race region numdep
predict educhat
summarize educhat
replace educ_ols = r(mean) if educ == .
drop educhat

/*-----------------------------------
@ Regressions                       @
-----------------------------------*/
regress lwage educ c.exper##c.exper
regress lwage educ_mean c.exper##c.exper
regress lwage educ_mode c.exper##c.exper
regress lwage educ_ols c.exper##c.exper

/*-----------------------------------
@ Close log file					@
-----------------------------------*/
log close




