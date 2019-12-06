/****************************************************************************************

THIS DO FILE CONTAINS STATA COMMANDS TO RUN SPECIFICIATION 1 and 2 AS GIVEN IN THE PAPER: 

IMPACT OF EDUCATION LOANS ON HIGHER EDUCATION: THE INDIAN EXPERIENCE 


IMPORTANT NOTE: 
AT START OF SPECIFICATION 1 and 2, USER NEEDS TO SET COMMON PATH AS PER HIS LOCAL MACHINE WHERE PROJECT FOLDER HAVE BEEN SAVED.



SPECIFICATON 1		25

SPECIFICATON 2		1220
		
***************************************************************************************/




*********************************************************************************************************************************
*********************************** SPECIFICATON 1 *****************************************************************************
*********************************************************************************************************************************

		
*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"


log using "$common_path\Regression Specifications\Specification 1\log file specification 1.log", append


**Use NSS 71st round data

use "$common_path\NSS Data\NSS 71\Step 3\nss_71_2014_relg_social_grp_educ_dataset_15122017.dta", clear 


*correcting for wrongly assigned code to Telangana Khammam. Hence assigning it same code as Andhra Pradesh Khammam
replace State_district_FINAL_code_71 = 2810 if State_district_FINAL_code_71 == 3610 


*running the program which has codes for all the district groups that we have formed

*please input the old district code variable
global old_dist_code_var "State_district_FINAL_code_71"

program_replace_dist_code $old_dist_code_var

count if State_district_FINAL_code_71==.
count if dist_code_after_group == .


*assigning weights to NSS dataset

gen weight=multiplier/100 if nss== nsc
replace weight=multiplier/200 if weight==.




******** Shadab defined years of education *********


*not literate -01
gen edu_yrs = 0      if general_education==1


*literate without any schooling -02, literate without formal schooling: through NFEC -03, literate through TLC/ AEC -04, others -05
replace edu_yrs = 1  if general_education>=2 & general_education<=5

*literate with formal schooling: below primary -06,
replace edu_yrs = 2  if general_education==6

*primary -07
replace edu_yrs = 5  if general_education==7

*upper primary/middle -08
replace edu_yrs = 7  if general_education==8

*general_education==9.. not available

*secondary -10
replace edu_yrs = 10 if general_education==10

*higher secondary -11
replace edu_yrs = 12 if general_education==11

*diploma /certificate course(upto secondary) - 12 .. assigned education years as that of secondary guy
replace edu_yrs = 10 if general_education==12  

*diploma or certificate (higher secondary) -13... assigned education years as that of higher-secondary guy
replace edu_yrs = 12 if general_education==13  

*diploma or certificate (graduation and above)-14 .. assigned education years as that of graduate
replace edu_yrs = 16 if general_education==14  

*graduate -15
replace edu_yrs = 16 if general_education==15

*postgraduate and above -16
replace edu_yrs = 18 if general_education==16



*******************************************************



**defining education levels i.e. primary, secondary, higher secondary, graduate and post-graduate

gen prim=1 if edu_yrs==5
recode prim .=0          // recode replaces missing values in a variable to any specified value.. in our case it is ZERO
tab prim, mi

gen sec=1 if edu_yrs==10
recode sec .=0
tab sec, mi

gen hsec=1 if edu_yrs==12
recode hsec .=0
tab hsec, mi

gen grad=1 if edu_yrs==16
recode grad .=0
tab grad, mi

gen pgrad=1 if edu_yrs==18
recode pgrad .=0
tab pgrad, mi


 
********* treatment and control groups *********


*defining treatment and control cohort

gen newtrt=1 if age>=26 & age<=34       //treatment cohort in 2014 (who would be of age 17-25 in 2005; 13-21 in 2001)
replace newtrt=0 if age>=38 & age<=46   //control cohort in 2014 (who would be of age 29-37 in 2005; 25-33 in 2001)


********* pseudo treatment and control groups (used in falsification exercise) *********

*note: renaming newtrt1 to newtrt_psuedo

gen newtrt_psuedo =1 if age>=38 & age<=46
replace newtrt_psuedo =0 if age>=50 & age<=58


*generating religion specific variables

gen byte religion_short = religion if religion<=3

replace religion_short= 4 if religion>3

replace religion_short= . if religion==.


label define rel 1 "Hindu" 2 "Muslim" 3 "Christian" 4 "others"
label values religion_short rel


********************************************************************************************************************************************************
********************************************************************************************************************************************************



*********************************************************
*************** merge with loan_2005 data ***************
*********************************************************

*master : NSS data   ( multiple values of district codes since individual level dataset)
*using  : loans data ( single value of district code) 


global loan_2005_data "$common_path\Independent variables\Education Loan Dataset\Processed Data\Loan Year Dataset\loan2005.dta" 

merge m:1 dist_code_after_group using "$loan_2005_data"

rename _merge merge_NSS71_with_loan2005



gen state_district_key_71 = State_71+" "+ District_71

tab state_district_key_71 if merge_NSS71_with_loan2005==1
tab state_district_key_71 if merge_NSS71_with_loan2005==2


/*Results:
loan data not present for  ASSAM DIMA HASAO, HIMACHAL PRADESH LAHUL & SPITI, TAMIL NADU ARIYALUR 
*/



********************************************************************************************************************************************************
********************************************************************************************************************************************************



*********************************************************
*merging census 2005 population data
*********************************************************


global pop_census_2005 "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Interpolated Yearly Population\Interpolated 2005 population.dta"
merge m:1 dist_code_after_group using "$pop_census_2005"

rename _merge merge_nss71_loan_with_pop



*droping all 17-25 variables
drop age_17_25_Total_Persons_lp age_17_25_Total_Males_lp age_17_25_Total_Females_lp age_17_25_Rural_Persons_lp age_17_25_Rural_Males_lp age_17_25_Rural_Females_lp age_17_25_Urban_Persons_lp age_17_25_Urban_Males_lp age_17_25_Urban_Females_lp age_17_25_Total_Persons_ex age_17_25_Total_Males_ex age_17_25_Total_Females_ex age_17_25_Rural_Persons_ex age_17_25_Rural_Males_ex age_17_25_Rural_Females_ex age_17_25_Urban_Persons_ex age_17_25_Urban_Males_ex age_17_25_Urban_Females_ex

*dropping all_age variables except TOTAL_persons
drop age_all_years_Total_Males_lp age_all_years_Total_Females_lp age_all_years_Rural_Persons_lp age_all_years_Rural_Males_lp age_all_years_Rural_Females_lp age_all_years_Urban_Persons_lp age_all_years_Urban_Males_lp age_all_years_Urban_Females_lp age_all_years_Total_Males_ex age_all_years_Total_Females_ex age_all_years_Rural_Persons_ex age_all_years_Rural_Males_ex age_all_years_Rural_Females_ex age_all_years_Urban_Persons_ex age_all_years_Urban_Males_ex age_all_years_Urban_Females_ex




********************************************************************************************************************************************************
********************************************************************************************************************************************************



*********************************************************
*merging institutions data
*********************************************************


global insti_data_path "$common_path\Independent variables\Institution Dataset\Processed Data\Higher educational institute dataset 27032018.dta"

*for sake of merging we need to rename the variable
*rename district_code dist_code_after_group  

merge m:1 dist_code_after_group using "$insti_data_path"

rename _merge merge_nss71_loan_pop_insti


*****control for the number of institutions in individuals' district of residence when they were 17 (age of entry according to our definition***
gen insti_freshman=.

forvalues i=1(1)21{
	
	local k = 2006-`i'
	local l = 25+`i'
	replace insti_freshman = inst_`k' if age==`l'

}
*

***control for average number of institutions in district of residence while an individual was in the higher education age group (17-25 years)***

gen insti_freshman_avg=.

forvalues i=1(1)21{
	
	local k = 2006-`i'
	local l = 25+`i'
	replace insti_freshman_avg = avg_inst_`k' if age==`l'

}
*


********************************************************************************************************************************************************
********************************************************************************************************************************************************




*********************************************************
*merging #branches dataset
*********************************************************


global branch_exisiting_data "$common_path\Independent variables\Branch Operating Dataset\district_wise_branch_dataset.dta"
merge m:1 dist_code_after_group using "$branch_exisiting_data"

rename _merge merge_nss_loan_pop_insti_branch


*****control for the number of bank branches in individuals' district of residence when they were 17 (age of entry according to our definition***

gen branches_freshman=.

forvalues i=1(1)21{
	
	local k = 2006-`i'
	local l = 25+`i'
	replace branches_freshman = branches_dist_grp_`k' if age==`l'

}
*


**control for average number of bank branches in district of residence while an individual was in the higher education age group (17-25 years)***

gen branches_freshman_avg =.

forvalues i=1(1)21{
	local k = 2006-`i'
	local l = 25+`i'
	replace branches_freshman_avg = branches_avg_`k' if age==`l'
}
*





********************************************************************************************************************************************************
********************************************************************************************************************************************************



*********** creating some regression specific variables ***********

**creating measure of program intensity for each district .. i.e. # loans per 100 people  in district * dummy (=1) if individual has been treated

gen loan_per_capita = (total_loan_account_dist_grp_2005 /age_all_years_Total_Persons_lp)  //finding #loan account created in 2005 per capita
gen loan_per_hundred = loan_per_capita * 100			 	   							  //finding #loan account created in 2005 per 100 people
gen program_intensity = loan_per_hundred * newtrt				   						  //newtrt=1 for treatment group i.e. if person's age in 2014 is 26-34 



*creating new social group variable where we have combined both Scheduled caste and tribe together

tab social_group, mi
rename social_group old_social_group

gen social_group = 1 if old_social_group==1 | old_social_group==2     // "ST+SC"
replace social_group = 2 if old_social_group==3   					  // "OBC"
replace social_group = 3 if old_social_group==9 					  // "Others"

fvset base 3 social_group

label define social_group_prime 1 "Scheduled Tribes & Scheduled Castes" 2 "Other Backward Castes" 3 "Others"
label values social_group social_group_prime 


*renaming district code variables.. i.e. making them regression friendly

rename district_code district_code_unwanted
rename dist_code_after_group district_code



* IMP: user must give path of his machine to save this dataset

*saving the final database 
save "D:\General\Fall 2017-18\Arka Tridip work\Specification 1\July 24 2018\specification 1_full_database.dta", replace

clear

log close









***************************************************************************************************************************
****************************************** Running regressions as per Specification 1 *************************************
***************************************************************************************************************************




*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"


*loading so far created specification 1 database
use "D:\General\Fall 2017-18\Arka Tridip work\Specification 1\July 24 2018\specification 1_full_database.dta", clear


log using "$common_path\Regression Specifications\Specification 1\log file specification 1.log", append


*creating variables for running regression and for ease in display of regression output

gen 		female_dummy = 0 if sex!=.
replace 	female_dummy = 1 if sex==2
label var 	female_dummy "Female"

gen 		urban_dummy = 0 if sector!=.
replace 	urban_dummy = 1 if sector==2 
label var 	urban_dummy "Urban"

gen 		ST_SC_dummy = 0 if social_group!=.
replace 	ST_SC_dummy = 1 if social_group == 1
label var 	ST_SC_dummy "Scheduled Castes \& Scheduled Tribes"

gen 		OBC_dummy = 0 if social_group!=.
replace 	OBC_dummy = 1 if social_group == 2
label var 	OBC_dummy "Other Backward Castes"

global demo_control "female_dummy ST_SC_dummy OBC_dummy urban_dummy"
global caste_control "ST_SC_dummy OBC_dummy"




*labelling variables as per regression output requirement

label var newtrt "newtrt equal to one if individual belongs to treatment group"

label var branches_freshman "# branches in individuals' district at age of 17"

label var branches_freshman_avg "average # branches when indiv is 17_25"

label var insti_freshman "# institutions in individuals' district at age of 17"

label var insti_freshman_avg "average # institutions when indiv is 17_25"



set matsize 5000
set more off
destring common_id, replace
format common_id %12.0g 


global title_table_1 "Table 1: Descriptive Statistics: Years of Schooling"
global title_table_2 "Table 2: Effect of Education Loan on Years of Schooling"
global title_table_3 "Table 3: Heterogeneous Effects in Years of Schooling: Gender"
global title_table_4 "Table 4: Heterogeneous Effects in Years of Schooling: Caste Groups"
global title_table_5 "Table 5: Heterogeneous Effects in Years of Schooling: Sector (Rural/Urban)"
global title_table_6 "Table 6: Effect of Education Loan on Years of Schooling: Falsification Test"
global title_table_7 "Table 7: Years of Schooling: Robustness Checks: Controlling for Higher Education Institutions and Bank Branches"
global title_table_8 "Table 8: Years of Schooling: Robustness Checks: Including Age and Household Fixed Effects"
global title_table_9 "Table 9: Effect of Education Loans on the Probability of Attainment of Different Education Levels"



* Note : This code needs to be run only once to create relevent directory

*creating directory for Latex tables

forvalues i = 1/9 {
	global table_number = `i'
	mkdir "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number" 

}

*


*********************************************************************************************************************************************************
*********************************************************************************************************************************************************




********************************************************
*Table 1: Descriptive Statistics: Years of Schooling
********************************************************


*ssc install estout

global table_number = 1



global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number.tex"


label var loan_per_hundred "Education Loan Accounts (per Hundred Population in 2005)"
 
gen edu_yrs2634 = edu_yrs if age >= 26 & age <= 34 
label var edu_yrs2634 "Years of Schooling: 26-34 year olds (Measured in 2014)"

gen edu_yrs3846 = edu_yrs if age >= 38 & age <= 46
label var edu_yrs3846 "Years of Schooling: 38-46 year olds (Measured in 2014)"

global varlist "loan_per_hundred edu_yrs2634 edu_yrs3846"

************************************************************

file open fh using "$Table_1", write replace

file write fh "\documentclass[11pt]{article}" _newline "\usepackage[margin=0.5in]{geometry}" _newline "\usepackage[flushleft]{threeparttable}" _newline
file write fh "\begin{document}" _newline

file write fh "\begin{table}[h!]" _newline "\centering" _newline "\begin{threeparttable}" _newline 
file write fh "\caption{Summary Statistics}" _newline "\begin{tabular}{p{7cm}ccc}" _newline "\hline" _newline
file write fh "Variable & Mean & Sd & \\ [0.6ex] " _newline "\hline" _newline

foreach var in $varlist {
local l : variable label `var'
quietly summarize `var' [aw= weight]
local mn = round(r(mean), 0.001)
local std = round(r(sd), 0.001)
file write fh " `l' & `mn' & `std' \\" _newline 
}

file write fh "\end{tabular}" _newline "\end{threeparttable}" _newline "\end{table}" _newline _newline
file write fh "\end{document}"
file close fh




*********************************************************************************************************************************************************
*********************************************************************************************************************************************************












********************************************************
*Table 2: Effect of Education Loan on Years of Schooling *table 2.. line 99 @firstmodel_new.do (Google Drive)
********************************************************


global table_number = 2

*global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number.csv"

global Table_2 "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_2.tex"

preserve

keep if newtrt==1 | newtrt==0

set more off

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion urban_dummy $caste_control i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_2", tex replace label keep(edu_yrs program_intensity female_dummy urban_dummy $caste_control) ctitle(Years of Schooling) title($title_table_2) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES ) nocons addnote("")


restore




***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 2

global Table_2 "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number"

preserve

keep if newtrt==1 | newtrt==0

set more off

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion urban_dummy $caste_control i.district_code [pw=weight], vce(cluster district_code)

outreg2 using "$Table_2", dta replace label drop(i.district_code) ctitle(Years of Schooling) title($title_table_2) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES ) nocons addnote("")


restore


*********************************************************************************************************************************************************
*********************************************************************************************************************************************************
















*****************************************************************************************
*Table 3: Heterogeneous Effects in Years of Schooling: Gender *table 3.. line 103, 104
*****************************************************************************************

global table_number = 3
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number.tex"


preserve

keep if newtrt==1 | newtrt==0


set more off
quietly regress edu_yrs program_intensity i.newtrt i.religion $caste_control urban_dummy i.district_code [pw=weight] if sex==1, vce(cluster district_code)
outreg2 using "$Table_3", tex replace label keep(edu_yrs program_intensity) ctitle(Male) title($title_table_3) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons addnote("")

quietly regress edu_yrs program_intensity i.newtrt i.religion $caste_control urban_dummy i.district_code [pw=weight] if sex==2, vce(cluster district_code)
outreg2 using "$Table_3", tex append label keep(edu_yrs program_intensity) ctitle(Female) title($title_table_3) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons addnote("")

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight] , vce(cluster district_code)
outreg2 using "$Table_3", tex append label keep(edu_yrs program_intensity female_dummy) ctitle(Overall) title($title_table_3) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons addnote("")

restore




***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 3
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number"


preserve

keep if newtrt==1 | newtrt==0


set more off
quietly regress edu_yrs program_intensity i.newtrt i.religion $caste_control urban_dummy i.district_code [pw=weight] if sex==1, vce(cluster district_code)
outreg2 using "$Table_3", dta replace label drop(i.district_code) ctitle(Male) title($title_table_3) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons addnote("")

quietly regress edu_yrs program_intensity i.newtrt i.religion $caste_control urban_dummy i.district_code [pw=weight] if sex==2, vce(cluster district_code)
outreg2 using "$Table_3", dta append label drop(i.district_code) ctitle(Female) title($title_table_3) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons addnote("")

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight] , vce(cluster district_code)
outreg2 using "$Table_3", dta append label drop(i.district_code) ctitle(Overall) title($title_table_3) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons addnote("")

restore


*********************************************************************************************************************************************************
*********************************************************************************************************************************************************












*****************************************************************************************
*Table 4: Heterogeneous Effects in Years of Schooling: Caste Groups ** *table 4 code line 105, 106,107 
*****************************************************************************************

global table_number = 4
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number.tex"


preserve

keep if newtrt==1 | newtrt==0

set more off

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion urban_dummy i.district_code [pw=weight] if social_group==1, vce(cluster district_code)
outreg2 using "$Table_4", tex replace label keep(edu_yrs program_intensity) ctitle(SC/ST) title($title_table_4) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion urban_dummy i.district_code [pw=weight] if social_group==2, vce(cluster district_code)
outreg2 using "$Table_4", tex append label keep(edu_yrs program_intensity) ctitle(OBC) title($title_table_4) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion urban_dummy i.district_code [pw=weight] if social_group==3, vce(cluster district_code)
outreg2 using "$Table_4", tex append label keep(edu_yrs program_intensity) ctitle(Others) title($title_table_4) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_4", tex append label keep(edu_yrs program_intensity $caste_control) ctitle(Overall) title($title_table_4) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

restore




***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 4
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number"


preserve

keep if newtrt==1 | newtrt==0

set more off

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion urban_dummy i.district_code [pw=weight] if social_group==1, vce(cluster district_code)
outreg2 using "$Table_4", dta replace label drop(i.district_code) ctitle(SC/ST) title($title_table_4) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion urban_dummy i.district_code [pw=weight] if social_group==2, vce(cluster district_code)
outreg2 using "$Table_4", dta append label drop(i.district_code) ctitle(OBC) title($title_table_4) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion urban_dummy i.district_code [pw=weight] if social_group==3, vce(cluster district_code)
outreg2 using "$Table_4", dta append label drop(i.district_code) ctitle(Others) title($title_table_4) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_4", dta append label drop(i.district_code) ctitle(Overall) title($title_table_4) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

restore


*********************************************************************************************************************************************************
*********************************************************************************************************************************************************














*****************************************************************************************
*Table 5: Heterogeneous Effects in Years of Schooling: Sector (Rural/Urban) ** *table 5 108 and 109 in new version
*****************************************************************************************

global table_number = 5
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number.tex"


preserve

keep if newtrt==1 | newtrt==0

set more off

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control i.district_code [pw=weight] if sector==1, vce(cluster district_code)
outreg2 using "$Table_5", tex replace label keep(edu_yrs program_intensity) ctitle(Rural) title($title_table_5) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control i.district_code [pw=weight] if sector==2, vce(cluster district_code)
outreg2 using "$Table_5", tex append label keep(edu_yrs program_intensity) ctitle(Urban) title($title_table_5) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_5", tex append label keep(edu_yrs program_intensity urban_dummy) ctitle(Overall) title($title_table_5) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

restore



***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************

global table_number = 5
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number"


preserve

keep if newtrt==1 | newtrt==0

set more off

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control i.district_code [pw=weight] if sector==1, vce(cluster district_code)
outreg2 using "$Table_5", dta replace label drop(i.district_code) ctitle(Rural) title($title_table_5) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control i.district_code [pw=weight] if sector==2, vce(cluster district_code)
outreg2 using "$Table_5", dta append label drop(i.district_code) ctitle(Urban) title($title_table_5) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_5", dta append label drop(i.district_code) ctitle(Overall) title($title_table_5) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

restore


*********************************************************************************************************************************************************
*********************************************************************************************************************************************************
















*****************************************************************************************
*Table 6: Effect of Education Loan on Years of Schooling: Falsification Test *table 6 ..Note lines 97 and 116 in the new do file
*****************************************************************************************

global table_number = 6
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number.tex"

gen program_intensity_test = loan_per_hundred * newtrt_psuedo

set more off

quietly regress edu_yrs program_intensity_test i.newtrt_psuedo female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_6", tex replace label keep(edu_yrs program_intensity_test female_dummy urban_dummy $caste_control) ctitle(Years of Schooling) title($title_table_6) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons



***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 6
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number"


set more off

quietly regress edu_yrs program_intensity_test i.newtrt_psuedo female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_6", dta replace label drop(i.district_code) ctitle(Years of Schooling) title($title_table_6) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons



*********************************************************************************************************************************************************
*********************************************************************************************************************************************************

















*****************************************************************************************
*Table 7: Years of Schooling: Robustness Checks: Controlling for Higher Education Institutions and Bank Branches * ..Code line 30, 31 , 37 at controls.do
*****************************************************************************************


global table_number = 7
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number.tex"


********************************************
****** creating Latex file for Table 7 *****
********************************************


preserve
keep if newtrt==1 | newtrt==0

set more off 


//1st column
*regressing edu_years with institutions and bank branches as per our base specification

quietly regress edu_yrs i.newtrt program_intensity female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_7", tex replace label keep(edu_yrs program_intensity) ctitle(Years of Education) title($title_table_7) addtext(Baseline Institutions \& Bank Branches, - , Institutions \& Bank Branches at Age of Entry, -, Average Number of Institutions \& Bank Branches, - , Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons


//2nd column
*****Interacting baseline characteristics with cohort****

gen inst_baseline_robust = inst_1999 * newtrt
label var inst_baseline_robust "Number of institutes in 1999"

gen branches_baseline_robust = branches_dist_grp_1999 * newtrt
label var branches_baseline_robust "Number of branches in 1999"



quietly regress edu_yrs i.newtrt program_intensity inst_baseline_robust branches_baseline_robust female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_7", tex append label keep(edu_yrs program_intensity) ctitle(Years of Education) title($title_table_7) addtext(Baseline Institutions \& Bank Branches, YES, Institutions \& Bank Branches at Age of Entry, - , Average Number of Institutions \& Bank Branches, - , Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons


//3rd column
*regressing edu_years with institutions and bank branches when individual was 17 years old (just to enter treatment cohort)

quietly regress edu_yrs i.newtrt program_intensity insti_freshman branches_freshman female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_7", tex append label keep(edu_yrs program_intensity) ctitle(Years of Education) title($title_table_7) addtext(Baseline Institutions \& Bank Branches, - , Institutions \& Bank Branches at Age of Entry, YES, Average Number of Institutions \& Bank Branches, - , Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

//4th column
*regressing edu_years with AVERAGE institutions and AVERAGE bank branches when individual was 17 years old (just to enter treatment cohort)

quietly regress edu_yrs i.newtrt program_intensity insti_freshman_avg branches_freshman_avg female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_7", tex append label keep(edu_yrs program_intensity) ctitle(Years of Education) title($title_table_7) addtext(Baseline Institutions \& Bank Branches, - , Institutions \& Bank Branches at Age of Entry, - , Average Number of Institutions \& Bank Branches, YES, Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons


restore





***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 7
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number"


preserve

keep if newtrt==1 | newtrt==0

set more off 


//1st column
*regressing edu_years with institutions and bank branches as per our base specification

quietly regress edu_yrs i.newtrt program_intensity female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_7", dta replace label drop(i.district_code) ctitle(Years of Education) title($title_table_7) addtext(Baseline Institutions \& Bank Branches, - , Institutions \& Bank Branches at Age of Entry, -, Average Number of Institutions \& Bank Branches, - , Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons


//2nd column
*****Interacting baseline characteristics with cohort****

gen inst_baseline_robust = inst_1999 * newtrt
label var inst_baseline_robust "Number of institutes in 1999"

gen branches_baseline_robust = branches_dist_grp_1999 * newtrt
label var branches_baseline_robust "Number of branches in 1999"


quietly regress edu_yrs i.newtrt program_intensity inst_baseline_robust branches_baseline_robust female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_7", dta append label drop(i.district_code) ctitle(Years of Education) title($title_table_7) addtext(Baseline Institutions \& Bank Branches, YES, Institutions \& Bank Branches at Age of Entry, - , Average Number of Institutions \& Bank Branches, - , Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons


//3rd column
*regressing edu_years with institutions and bank branches when individual was 17 years old (just to enter treatment cohort)

quietly regress edu_yrs i.newtrt program_intensity insti_freshman branches_freshman female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_7", dta append label drop(i.district_code) ctitle(Years of Education) title($title_table_7) addtext(Baseline Institutions \& Bank Branches, - , Institutions \& Bank Branches at Age of Entry, YES, Average Number of Institutions \& Bank Branches, - , Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

//4th column
*regressing edu_years with AVERAGE institutions and AVERAGE bank branches when individual was 17 years old (just to enter treatment cohort)

quietly regress edu_yrs i.newtrt program_intensity insti_freshman_avg branches_freshman_avg female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_7", dta append label drop(i.district_code) ctitle(Years of Education) title($title_table_7) addtext(Baseline Institutions \& Bank Branches, - , Institutions \& Bank Branches at Age of Entry, - , Average Number of Institutions \& Bank Branches, YES, Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons


restore


*********************************************************************************************************************************************************
*********************************************************************************************************************************************************















*****************************************************************************************
*Table 8: Years of Schooling: Robustness Checks: Including Age and Household Fixed Effects... 100 and 102 in new verssion
*****************************************************************************************


global table_number = 8
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number.tex"


preserve

keep if newtrt==1 | newtrt==0


set more off

//demographic, district and cohort fixed effect
quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code) 
outreg2 using "$Table_8", tex replace label keep(edu_yrs program_intensity) ctitle(Years of Education) title($title_table_8) addtext(Demographic Controls, YES , District Fixed Effects, YES , Cohort Fixed Effect, YES , Age Fixed Effect, -, Household Fixed Effect, -  ) nocons

//cohort fixed effect, household fixed effect
quietly reghdfe edu_yrs program_intensity female_dummy [pw=weight],  absorb(i.newtrt i.common_id) 
outreg2 using "$Table_8", tex append label keep(edu_yrs program_intensity) ctitle(Years of Education) title($title_table_8) addtext(Demographic Controls, - , District Fixed Effects, - , Cohort Fixed Effect, YES , Age Fixed Effect, - , Household Fixed Effect, YES  ) nocons


// demographic, district, age fixed effect
quietly reghdfe edu_yrs program_intensity female_dummy i.religion $caste_control urban_dummy [pw=weight],  absorb(i.district_code i.age)
outreg2 using "$Table_8", tex append label keep(edu_yrs program_intensity) ctitle(Years of Education) title($title_table_8) addtext(Demographic Controls, YES , District Fixed Effects, YES , Cohort Fixed Effect, - , Age Fixed Effect, YES, Household Fixed Effect, -  ) nocons

//age fixed effect, household fixed effect
quietly reghdfe edu_yrs program_intensity female_dummy [pw=weight],  absorb(i.age i.common_id)  			   
outreg2 using "$Table_8", tex append label keep(edu_yrs program_intensity) ctitle(Years of Education) title($title_table_8) addtext(Demographic Controls, - , District Fixed Effects, - , Cohort Fixed Effect, -, Age Fixed Effect, YES, Household Fixed Effect, YES  ) nocons

restore




***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 8
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number"


preserve

keep if newtrt==1 | newtrt==0


set more off

//demographic, district and cohort fixed effect
quietly regress edu_yrs program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code) 
outreg2 using "$Table_8", dta replace label drop(i.district_code) ctitle(Years of Education) title($title_table_8) addtext(Demographic Controls, YES , District Fixed Effects, YES , Cohort Fixed Effect, YES , Age Fixed Effect, -, Household Fixed Effect, -  ) nocons

//cohort fixed effect, household fixed effect
quietly reghdfe edu_yrs program_intensity female_dummy [pw=weight],  absorb(i.newtrt i.common_id) 
outreg2 using "$Table_8", dta append label drop(i.common_id) ctitle(Years of Education) title($title_table_8) addtext(Demographic Controls, - , District Fixed Effects, - , Cohort Fixed Effect, YES , Age Fixed Effect, - , Household Fixed Effect, YES  ) nocons


// demographic, district, age fixed effect
quietly reghdfe edu_yrs program_intensity female_dummy i.religion $caste_control urban_dummy [pw=weight],  absorb(i.district_code i.age)
outreg2 using "$Table_8", dta append label drop(i.district_code i.age) ctitle(Years of Education) title($title_table_8) addtext(Demographic Controls, YES , District Fixed Effects, YES , Cohort Fixed Effect, - , Age Fixed Effect, YES, Household Fixed Effect, -  ) nocons

//age fixed effect, household fixed effect
quietly reghdfe edu_yrs program_intensity female_dummy [pw=weight],  absorb(i.age i.common_id)  			   
outreg2 using "$Table_8", dta append label drop(i.age i.common_id) ctitle(Years of Education) title($title_table_8) addtext(Demographic Controls, - , District Fixed Effects, - , Cohort Fixed Effect, -, Age Fixed Effect, YES, Household Fixed Effect, YES  ) nocons

restore


*********************************************************************************************************************************************************
*********************************************************************************************************************************************************




















*****************************************************************************************
*Table 9: Effect of Education Loans on the Probability of Attainment of Different Education Levels... *table 9.. 110-114 in new version
*****************************************************************************************

global table_number = 9
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number.tex"


preserve

keep if newtrt==1 | newtrt==0

set more off

quietly regress prim  program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_9", tex replace label keep(prim program_intensity) ctitle(Primary) title($title_table_9) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress sec   program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_9", tex append label keep(sec program_intensity) ctitle(Secondary) title($title_table_9) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress hsec  program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_9", tex append label keep(hsec program_intensity) ctitle(Higher Secondary) title($title_table_9) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress grad  program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_9", tex append label keep(grad program_intensity) ctitle(Graduate) title($title_table_9) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress pgrad program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_9", tex append label keep(pgrad program_intensity) ctitle(Post Graduate) title($title_table_9) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons


restore




***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 9
global Table_$table_number "$common_path\Regression Specifications\Specification 1\Output and Results\Table $table_number\Table_$table_number"


preserve


keep if newtrt==1 | newtrt==0

set more off

quietly regress prim  program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_9", dta replace label drop(i.district_code) ctitle(Primary) title($title_table_9) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress sec   program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_9", dta append label drop(i.district_code) ctitle(Secondary) title($title_table_9) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress hsec  program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_9", dta append label drop(i.district_code) ctitle(Higher Secondary) title($title_table_9) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress grad  program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_9", dta append label drop(i.district_code) ctitle(Graduate) title($title_table_9) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons

quietly regress pgrad program_intensity i.newtrt female_dummy i.religion $caste_control urban_dummy i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_9", dta append label drop(i.district_code) ctitle(Post Graduate) title($title_table_9) addtext(Demographic Controls, YES , Cohort Fixed Effect, YES , District Fixed Effects, YES) nocons


restore



*********************************************************************************************
** Creating an Excel file for Specification 1 using STATA (.dta) files created in above step
*********************************************************************************************

clear

global Specification_1 "$common_path\Regression Specifications\Specification 1\Output and Results\Specification 1.xlsx" 

forvalues i = 2/9 {

		use "$common_path\Regression Specifications\Specification 1\Output and Results\Table `i'\Table_`i'_dta.dta", clear
		
		if `i' == 2 export excel using "$Specification_1", sheet("Table_`i'") replace
		
		if `i' != 2 export excel using "$Specification_1", sheet("Table_`i'") sheetmodify
				
		clear

}
*


log close

clear all



											************************************
											******* END OF SPECIFICATION ********
											************************************












											
											


*********************************************************************************************************************************
*********************************** SPECIFICATON 2 *****************************************************************************
*********************************************************************************************************************************

		
*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"

log using "$common_path\Regression Specifications\Specification 2\log file specification 2.log", append



*append nss 61 round, 6th round ans 68 th round datset


global NSS_61_data "$common_path\NSS Data\NSS 61\Processed Data\nss_61_2004_relg_social_grp_educ_dataset_15122017.dta"

global NSS_66_data "$common_path\NSS Data\NSS 66\Step 3\nss_66_2004_relg_social_grp_educ_dataset_15122017.dta"

global NSS_68_data "$common_path\NSS Data\NSS 68\Step 3\nss_68_2011_relg_social_grp_educ_dataset_15122017.dta"


append using "$NSS_61_data" "$NSS_66_data" "$NSS_68_data", generate(year_marker) 

replace year_marker = 2004 if year_marker == 1
replace year_marker = 2009 if year_marker == 2
replace year_marker = 2011 if year_marker == 3


*running district code grouping code program

*creating a common_district code varaible taking codes from relevent each NSS round normalized to NSS 61 codes

gen common__dist_code = State_district_code if year_marker ==2004
replace common__dist_code = State_district_FINAL_code_66 if year_marker ==2009
replace common__dist_code = State_district_FINAL_code_68 if year_marker ==2011

*running our program

********* IMPORTANT: please make input for the old variable which has information about district codes  *********

global old_dist_code_var "common__dist_code"

*running the program which has codes for all the district groups that we have formed
quietly program_replace_dist_code $old_dist_code_var






*****************************************************************
************* merging population data *************
*****************************************************************

************* merging population 2004, 2009 and 2011 data *************


global pop_2004_09_11_data "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Combined 2004_09_11 Interpolated Yearly Population.dta" 

merge m:1 year_marker dist_code_after_group using "$pop_2004_09_11_data"  

tab year_marker if _merge==1

duplicates examples year_marker common__dist_code if _merge==1 , abbreviate(20)
duplicates examples year_marker dist_code_after_group if _merge==1 , abbreviate(20)

*renaming merging varaible
rename _merge _merge_speci_2_pop_04_09_11





*****************************************************************
******* merging night lights data  *******
*****************************************************************


global night_light_04_09_11 "$common_path\Independent variables\Night Lights Dataset\Processed Data\Year wise data\night_lights_data_2004_09_11.dta"

*doing it since in night-lights data we have marked year using different varaible name 
rename year_marker year_nl

merge m:1 year_nl dist_code_after_group using "$night_light_04_09_11"   

*renaming back to original variable since merge with nigh-lights is done now
rename year_nl year_marker

*checking for outliers
tab year_marker if _merge==1
tab common__dist_code if _merge==1
tab dist_code_after_group if _merge==1

duplicates examples year_marker common__dist_code if _merge==1 , abbreviate(20)
duplicates examples year_marker dist_code_after_group if _merge==1 , abbreviate(20)

*renaming merging varaible
rename _merge _merge_speci_2_night_light






*****************************************************************
******* merging branches operating dataset *******
*****************************************************************


global branches_data_04_09_11 "$common_path\Independent variables\Branch Operating Dataset\district_wise_branch_dataset.dta"

*bringing only relevent variables since other variables are not useful
merge m:1 dist_code_after_group using "$branches_data_04_09_11", keepusing(branches_dist_grp_* branches_rural_dist_grp_* branches_urban_dist_grp_* branches_avg_*)   

*checking for outliers
tab year_marker if _merge==1
tab common__dist_code if _merge==1
tab dist_code_after_group if _merge==1



*creating a new variable which has information of number of branches present in each NSS year
gen new_branch_dist_grp = 		branches_dist_grp_2004 if year_marker == 2004
replace new_branch_dist_grp =  	branches_dist_grp_2009 if year_marker == 2009
replace new_branch_dist_grp =  	branches_dist_grp_2011 if year_marker == 2011

label var new_branch_dist_grp "IMP: gives year-wise # branches present in each district code"



*creating a new varaible which has information of RURAL branches present in each NSS year

gen new_branch_rural_dist_grp =		branches_rural_dist_grp_2004 if year_marker == 2004
replace new_branch_rural_dist_grp =	branches_rural_dist_grp_2009 if year_marker == 2009
replace new_branch_rural_dist_grp =	branches_rural_dist_grp_2011 if year_marker == 2011

label var new_branch_rural_dist_grp "IMP: gives year-wise # rural branches present in each district code"


*creating a new varaible which has information of URBAN branches present in each NSS year

gen new_branch_urban_dist_grp =		branches_urban_dist_grp_2004 if year_marker == 2004
replace new_branch_urban_dist_grp =	branches_urban_dist_grp_2009 if year_marker == 2009
replace new_branch_urban_dist_grp =	branches_urban_dist_grp_2011 if year_marker == 2011

label var new_branch_urban_dist_grp "IMP: gives year-wise # urban branches present in each district code"



*renaming merging varaible
rename _merge _merge_speci_2_branch_operate





*********************************************************************************
*****merging institution data
*********************************************************************************


global higher_insti_data "$common_path\Independent variables\Institution Dataset\Processed Data\Higher educational institute dataset 27032018.dta"

merge m:1 dist_code_after_group using "$higher_insti_data" 

tab year_marker if _merge==1

*checking for outliers
tab year_marker if _merge==1
tab common__dist_code if _merge==1
tab dist_code_after_group if _merge==1

duplicates examples State_pop_interp District_pop_interp common__dist_code dist_code_after_group if _merge==1 , abbreviate(20)

*renaming merging variable
rename _merge _merge_speci_2_higher_insti


*creating a higher institute variable that gives # institutes across 2004, 09 and 11

gen 	higher_edu_inst = .
replace higher_edu_inst = inst_2004 if year_marker == 2004
replace higher_edu_inst = inst_2009 if year_marker == 2009
replace higher_edu_inst = inst_2011 if year_marker == 2011

label var higher_edu_inst "# higher institute in district across 2004, 09 and 11"






*****************************************************************
******* merging EDUCATION LOAN dataset *******
*****************************************************************

global edu_loans_data "$common_path\Independent variables\Education Loan Dataset\Processed Data\edu_loan_04_09_11_specification_2.dta"

set more off

**merging edu_loan 2004, 09 and 11 data
merge m:1 year_marker dist_code_after_group using "$edu_loans_data"

*checking for outliers
tab year_marker if _merge==1
tab common__dist_code if _merge==1
tab dist_code_after_group if _merge==1

duplicates examples State_pop_interp District_pop_interp common__dist_code dist_code_after_group if _merge==1 , abbreviate(20)


*renaming merging variable
rename _merge _merge_speci_2_loan_data



**********************************************************************

*saving the entire specification 2 database (only for bank branches dataset we have not merged entire dataset, otherwise all other datasets consists of all variables)
save "D:\General\Fall 2017-18\Arka Tridip work\Specification 2\July 25 2018\specification_2_full_database.dta", replace

**********************************************************************






**********************************************************************
******* KEEPING only relevent variables for specification 2 *******
*********************************************************************


/*	Note: please include other variables that you want to include for running the regressions.
	
	This is a list of variables which would be useful to us while running regression */


	
global identifier_var 		"year_marker dist_code_after_group" 

global NSS_var 				"common_id-common__dist_code"

global populate_var 		"State_pop_interp District_pop_interp age_all_years_Total_Persons_lp age_all_years_Total_Persons_ex age_all_years_Rural_Persons_lp age_all_years_Rural_Persons_ex age_all_years_Urban_Persons_lp age_all_years_Urban_Persons_ex"

global night_light_var 		"avg_nl_2004 avg_nl_2009 avg_nl_2011 avg_nl_data" 

global bank_branch_var 		"new_branch_dist_grp new_branch_rural_dist_grp new_branch_urban_dist_grp"

global higher_edu_insti_var "higher_edu_inst"

global edu_loan_var 		"account_Total_NOT_BL account_baseline account_baseline_lag3 account_baseline_lag5 account_type_1_baseline account_type_2_baseline account_type_3_baseline account_type_4_baseline account_type_5_baseline account_type_6_baseline account_type_7_baseline account_type_8_baseline account_type_9_baseline account_type_10_baseline account_type_11_baseline account_type_12_baseline account_type_13_baseline account_type_14_baseline account_type_15_baseline account_type_16_baseline account_type_17_baseline account_type_18_baseline account_type_19_baseline pub_account urban_bank_account rural_bank_account"


*br $identifier_var $NSS_var $populate_var $night_light_var $bank_branch_var $higher_edu_insti_var $edu_loan_var

*dropping all unnecessary variables
keep $identifier_var $NSS_var $populate_var $night_light_var $bank_branch_var $higher_edu_insti_var $edu_loan_var





*******************************************************************************************






*******************************************************************************************
*********** creating variables as per requirement of Specification 2 ***********
*******************************************************************************************


*generating weights

*creating weights for the dataset .. weights are created in similar fashion across 3 NSS rounds
gen weight=multiplier/100 if nss== nsc
replace weight=multiplier/200 if weight==.

label var weight "created by us: weights which need to be applied to sample data"


*identifying individuals who belong to higher education cohort (17-25)
gen temp=1 if age>=17 & age<=25
label var temp "marker for individual (17-25) in higher education group"

****** creating dependent variable << enrolment >> in our regression model ******

*identifying whether individual in higher education (17-25) cohort is currently enrolled in formal higher education institute
*it also consists of individual who have officiallly enrolled in diploma certificate for vocational training

gen enrol=1 	if status_curr_attendance>=27 & temp==1 & year_marker==2004
replace enrol=1 if status_curr_attendance>=28 & temp==1 & year_marker!=2004

label var enrol "identifies if indiv. 17-25 enrolled in formal higher education instiute"

*important to replace enorol == 1 with  missing values if status_curr_attendance == ., since  they are currently getting value ==1 
*i.e. if you are from higher education cohort and status_curr_attendance is missing then your enrollment should be also be missing
replace enrol=. if status_curr_attendance==.  & temp==1

*br year_marker round age status_curr_attendance enrol if temp==1 & status_curr_attendance==.


*identifying whether individual in higher education (17-25) cohort is currently recieving formal vocational training 
gen voc=1 if vocational_training==1 & temp==1
label var voc "identifies if indiv. 17-25 is currently recieving formal vocational training"  


tab vocational_training
tab vocational_training if status_curr_attendance==. , mi
tab vocational_training if status_curr_attendance!=. , mi


*identifying individuals in higher education (17-25) cohort who are either studying in formal higher education institute or recieving formal vocational training
gen enrolment=1 if voc==1 | enrol==1
label var enrolment "identifies if indiv. 17-25 is recieveing formal higher education/vocational training" 



*assigning enollment status as zero to indivuals belongign to higher education cohort but who have neither enrolled in formal college or in some vocational traning program
replace enrolment=0 if enrolment==. & temp==1


*finding number of age 17-25 household member
*members in higher education age group

bysort year_marker common_id  :egen tot_age=count(temp)
label var tot_age "count of number of age 17-25 household member"


*finding number of age 17-25 household member enrolled in formal college / vocational centre
bysort year_marker common_id  :egen enrol_count= total(enrolment) 
label var enrol_count "count of number of age 17-25 household member enrolled in formal college/vocational centre"


*br year_marker round common_id age temp status_curr_attendance enrol enrol voc enrolment tot_age enrol_count 


***********


* across NSS 61, 66 and 68 there are same codes for general_education level

*not literate -01
gen edu_yrs= 0 if general_education==1

label var edu_yrs "gives us years to schooling based on general_education variable"

*literate without formal schooling: EGS/ NFEC/ AEC -02, TLC -03, others -04 
replace edu_yrs= 1 if general_education >= 2 & general_education <= 4

*literate: below primary -05
replace edu_yrs= 2 if general_education == 5

*primary -06
replace edu_yrs= 5 if general_education == 6

*middle -07
replace edu_yrs= 8 if general_education == 7

*secondary -08
replace edu_yrs= 10 if general_education == 8

*higher secondary -10
replace edu_yrs= 12 if general_education == 10

*diploma/certificate course -11
replace edu_yrs= 14 if general_education == 11

*graduate -12
replace edu_yrs= 16 if general_education == 12

*postgraduate and above -13
replace edu_yrs= 18 if general_education == 13




*avg adult education

*marking individual with age greater than 25
gen age_25_higher_marker =1 if age> 25

*assigning edu_years as per their education level
gen edu_yrs_adult = edu_yrs if age_25_higher_marker ==1

*finding sum of education years at household level
bysort year_marker common_id: egen t_edu= total(edu_yrs_adult)

*finding count of # household memebers who are of age > 25
bysort year_marker common_id: egen hhold_adult_count = count(age_25_higher_marker) if age_25_higher_marker==1

*finding average education year for adult members
bysort year_marker common_id: gen avg_edu_interim = t_edu / hhold_adult_count if hhold_adult_count!=0

bysort year_marker common_id: egen avg_edu = max(avg_edu_interim)
label var avg_edu "gives a household's average adult person's years of education" 





*finding dependent members in a household

gen depend_marker =1 if age<=14 | age>=65 
bysort year_marker common_id: egen dep = count(depend_marker) 
label var dep "count of number of dependent members in a household"





*broader religion

gen byte religion_short=religion if religion<=2
replace religion_short=3 if religion>2
replace religion_short=. if religion==.

label define rel 1 "Hindu" 2 "Muslim" 3 "others"
label values religion_short rel

label var religion_short "religion info for Hindu-1, Muslim-2, others-3"



* creating total loan accounts (rural+urban)... (# edu loans per capita)*100 .... primary independent variable of interest

gen acc_prime = account_baseline / age_all_years_Total_Persons_lp
gen account_prime = acc_prime *100

label var account_prime "IMP: primary independent variable, creating total loan accounts (rural+urban)"

tab year_marker if acc_prime ==. 
duplicates examples State_pop_interp District_pop_interp common__dist_code dist_code_after_group if account_prime==.  , abbreviate(20)



*creating rural loan accounts 
gen account_rural_prime = ( rural_bank_account / age_all_years_Rural_Persons_lp ) *100

label var account_rural_prime "IMP: primary independent variable: number of rural loan accounts"

tab year_marker if account_rural_prime ==. 
duplicates examples State_pop_interp District_pop_interp common__dist_code dist_code_after_group if account_rural_prime==.  , abbreviate(20)



*creating urban loan accounts 
gen account_urban_prime = ( urban_bank_account / age_all_years_Urban_Persons_lp ) *100

label var account_urban_prime "IMP: primary independent variable: number of urban loan accounts"

tab year_marker if account_urban_prime ==. 
duplicates examples State_pop_interp District_pop_interp common__dist_code dist_code_after_group if account_urban_prime==.  , abbreviate(20)



*creating new social group variable where we have combined both Scheduled caste and tribe together

tab social_group, mi

rename social_group old_social_group


gen social_group = 1 if old_social_group==1 | old_social_group==2     // "ST+SC"
replace social_group = 2 if old_social_group==3   					  // "OBC"
replace social_group = 3 if old_social_group==9 					  // "Others"

fvset base 3 social_group




*creating quartile variable used in Table 15 for finding land quartiles

*for rural area only: generating varaible for finding of quartile where family lies as per land possesssed by them
global NSS_year 2004 2009 2011 

foreach k of global NSS_year {

xtile quart_`k'_inter =land_possessed if year==`k' & sector==1 & person_srl_no == 1 [pw=weight] , nq(4)
bysort year common_id : egen quart_`k' = max(quart_`k'_inter)

} 
*



*drop intermediate varaibles
drop quart_2004_inter quart_2009_inter quart_2011_inter

gen quart = 	quart_2004 if year==2004
replace quart = quart_2009 if year==2009
replace quart = quart_2011 if year==2011

label var quart "in rural sector: gives quartile of family as per land possessed" 

tab quart if sector==1 , mi
tab land_possessed if quart==. & sector==1, mi



*saving the entire specification 2 database (only for bank branches dataset we have not merged entire dataset, otherwise all other datasets consists of all variables)
save "D:\General\Fall 2017-18\Arka Tridip work\Specification 2\July 25 2018\specification_2_mini_version_regression_ready_22062018.dta", replace












*******************************************************************************************
*************** Running regressions as per Specification 2 ********************************
*******************************************************************************************

/*
 
*uploading the truncated database for running the regression
use "D:\General\Fall 2017-18\Arka Tridip work\Specification 2\July 25 2018\specification_2_mini_version_regression_ready_22062018.dta", clear 




*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"


log using "$common_path\Regression Specifications\Specification 2\log file specification 2.log", append

*/


set more off
set matsize 800


*renaming key varaibles as variables defined by Senjuti

rename year_marker 						year
rename dist_code_after_group			district_code
rename account_prime 					account
rename avg_nl_data 						nl
rename age_all_years_Total_Persons_lp 	pop
rename new_branch_dist_grp 				branches
rename account_baseline_lag3 			account3
rename account_baseline_lag5			account5
rename higher_edu_inst					insti

rename insti							institute


*labelling variables as per display in paper
label var enrolment 	"Enrolment"
label var account 		"Education Loan Accounts (per hundred population)" 
label var account3 		"Education Loan Accounts (per hundred population)" 
label var account5 		"Education Loan Accounts (per hundred population)" 
label var pub_account   "Education Loan Accounts (per hundred population)" 

label var account_rural "Education Loan Accounts (per hundred population)" 
label var account_urban "Education Loan Accounts (per hundred population)" 



fvset base 1 sex
label var sex "Female"

label define social_group_prime 1 "Scheduled Tribes & Scheduled Castes" 2 "Other Backward Castes" 3 "Others"
label values social_group social_group_prime 


fvset base 1 sector
label var sector "Urban"



*renaming rural and urban accounts

rename account_urban_prime account_urban
rename account_rural_prime account_rural 

rename new_branch_rural_dist_grp branches_rural
rename new_branch_urban_dist_grp branches_urban

rename age_all_years_Rural_Persons_lp pop_rural
rename age_all_years_Urban_Persons_lp pop_urban


*creating variables for running regression and for ease in display of regression output

gen 		female_dummy = 0 if sex!=.
replace 	female_dummy = 1 if sex==2
label var 	female_dummy "Female"

gen 		urban_dummy = 0 if sector!=.
replace 	urban_dummy = 1 if sector==2 
label var 	urban_dummy "Urban"

gen 		ST_SC_dummy = 0 if social_group!=.
replace 	ST_SC_dummy = 1 if social_group == 1
label var 	ST_SC_dummy "Scheduled Castes \& Scheduled Tribes"

gen 		OBC_dummy = 0 if social_group!=.
replace 	OBC_dummy = 1 if social_group == 2
label var 	OBC_dummy "Other Backward Castes"

global demo_control "female_dummy ST_SC_dummy OBC_dummy urban_dummy"
global caste_control "ST_SC_dummy OBC_dummy"




*labelling variables so that its helpful for displaying regression output
label var nl "average night light intensity"

label var pop "Population"

label var pop_rural "Rural Population"   

label var pop_urban "Urban Population"

label var branches "Total bank branches"

label var branches_rural "Total rural bank branches"

label var branches_urban "Total urban bank branches"



*defining titles for tables

global title_table_10 "Table 10: Descriptive Statistics: Enrolment"
global title_table_11 "Table 11: Effect of Education Loan on Higher Education Enrolment"
global title_table_12 "Table 12: Heterogeneous Effects in Enrolment: Gender"
global title_table_13 "Table 13: Heterogeneous Effects in Enrolment: Caste Groups"
global title_table_14 "Table 14: Heterogeneous Effects in Enrolment: Sector(Rural/Urban)"
global title_table_15 "Table 15: Heterogeneous Effects in Enrolment in the Rural Sample: Land Quartiles"
global title_table_16 "Table 16: Robustness Checks for Effect of Education Loan on Enrolment: Additional Controls"
global title_table_17 "Table 17: Robustness Checks : Alternative Definitions of the Measure of Loan Availability"
global title_table_18 "Table 18: Robustness Checks : Excluding 2009 and Loan Accounts for Public Sector Banks"




* Note : This code needs to be run only once to create relevent directory

*creating directory for Latex tables

forvalues i = 10/18 {
	global table_number = `i'
	mkdir "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number" 

}

*




***********************************************************************************************************************
***********************************************************************************************************************




********************************************************
*Table 10: Descriptive Statistics: Enrolment
********************************************************

*ssc install estout

global table_number = 10


global Table_10_csv "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number.csv"
global Table_10_tex "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number.tex"


preserve

label var enrolment "Enrolment in Higher Education"
label var account_baseline "Number of Education Loan Accounts (in Last Four Years)"
label var account "Number of Education Loan Accounts (per Hundred Population)"
label var nl "Night Light Intensity per sq. km"
label var branches "Number of Bank Branches"
label var institute "Number of Higher Education Institutions"


estpost sum enrolment account_baseline account nl branches institute [aw= weight] if year==2004 & temp==1
est sto m1

estpost sum enrolment account_baseline account nl branches institute [aw= weight] if year==2009 & temp==1
est sto m2

estpost sum enrolment account_baseline account nl branches institute [aw= weight] if year==2011 & temp==1
est sto m3

*producing csv file
esttab m1 m2 m3 using "$Table_10_csv", label replace b(a2) csv title($title_table_10) cell ("mean sd") mtitles(2004 2009 2011) 

*producing latex file
esttab m1 m2 m3 using "$Table_10_tex", label replace b(a2) tex title($title_table_10) cell ("mean sd") mtitles(2004 2009 2011) 

restore




********************************************************
*Table 11 .. Effect of Education Loan on Higher Education Enrolment
********************************************************


*ssc install outreg2

global table_number = 11
global Table_11 "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number.tex"



preserve 

keep if temp==1


quietly regress enrolment account hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_11", tex replace label keep(enrolment account female_dummy $caste_control urban_dummy) ctitle(Enrolment) title($title_table_11) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls , NO ) nocons addnote("")

quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_11", tex append  label keep(enrolment account female_dummy $caste_control urban_dummy) ctitle(Enrolment) title($title_table_11)  addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES ) nocons addnote("")    



restore





***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************




global table_number = 11
global Table_11 "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number"


preserve 

keep if temp==1

quietly regress enrolment account hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_11", dta replace label drop(i.year i.district_code) ctitle(Enrolment) title($title_table_11) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls , NO ) nocons addnote("")

quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_11", dta append label drop(i.year i.district_code) ctitle(Enrolment) title($title_table_11)  addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES ) nocons addnote("")    


restore





***********************************************************************************************************************
***********************************************************************************************************************



********************************************************
*Table 12..Heterogeneous Effects in Enrolment: Gender
********************************************************

global table_number = 12
global Table_12 "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number.tex"


preserve

keep if temp==1

quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep i.religion $caste_control urban_dummy i.year i.district_code [pw=weight] if sex==1, vce(cluster district_code)
outreg2 using "$Table_12", tex replace label keep(enrolment account female_dummy) ctitle(Male) title($title_table_12) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep i.religion $caste_control urban_dummy i.year i.district_code [pw=weight] if sex==2, vce(cluster district_code) 
outreg2 using "$Table_12", tex append label keep(enrolment account female_dummy) ctitle(Female) title($title_table_12) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_12", tex append label keep(enrolment account female_dummy) ctitle(Overall) title($title_table_12) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

restore 




***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 12
global Table_12 "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number"


preserve

keep if temp==1

quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep i.religion $caste_control urban_dummy i.year i.district_code [pw=weight] if sex==1, vce(cluster district_code)
outreg2 using "$Table_12", dta replace label drop(i.year i.district_code) ctitle(Male) title($title_table_12) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep i.religion $caste_control urban_dummy i.year i.district_code [pw=weight] if sex==2, vce(cluster district_code) 
outreg2 using "$Table_12", dta append label drop(i.year i.district_code) ctitle(Female) title($title_table_12) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_12", dta append label drop(i.year i.district_code) ctitle(Overall) title($title_table_12) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

restore 










***********************************************************************************************************************
***********************************************************************************************************************



********************************************************
*Table 13: Heterogeneous Effects in Enrolment: Caste Groups
********************************************************

global table_number = 13
global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number.tex"

preserve

keep if temp==1

quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion urban_dummy i.year i.district_code [pw=weight] if social_group==1, vce(cluster district_code)
outreg2 using "$Table_13", tex replace label keep(enrolment account $caste_control) ctitle(SC/ST) title($title_table_13) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion urban_dummy i.year i.district_code [pw=weight] if social_group==2, vce(cluster district_code)
outreg2 using "$Table_13", tex append label keep(enrolment account $caste_control) ctitle(OBC) title($title_table_13) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion urban_dummy i.year i.district_code [pw=weight] if social_group==3, vce(cluster district_code)
outreg2 using "$Table_13", tex append label keep(enrolment account $caste_control) ctitle(Others) title($title_table_13) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

******baseline with all controls 
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_13", tex append label keep(enrolment account $caste_control) ctitle(Overall) title($title_table_13) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


restore





***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 13
global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number"

preserve

keep if temp==1

quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion urban_dummy i.year i.district_code [pw=weight] if social_group==1, vce(cluster district_code)
outreg2 using "$Table_13", dta replace label drop(i.year i.district_code) ctitle(SC/ST) title($title_table_13) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion urban_dummy i.year i.district_code [pw=weight] if social_group==2, vce(cluster district_code)
outreg2 using "$Table_13", dta append label drop(i.year i.district_code) ctitle(OBC) title($title_table_13) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion urban_dummy i.year i.district_code [pw=weight] if social_group==3, vce(cluster district_code)
outreg2 using "$Table_13", dta append label drop(i.year i.district_code) ctitle(Others) title($title_table_13) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

******baseline with all controls 
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_13", dta append label drop(i.year i.district_code) ctitle(Overall) title($title_table_13) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


restore









***********************************************************************************************************************
***********************************************************************************************************************


********************************************************
*Table 14: Heterogeneous Effects in Enrolment: Sector (Rural/Urban)
********************************************************


global table_number = 14

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number.tex"


preserve

keep if temp==1

*rural use master_rural.dta
quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if sector==1 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_14", tex replace label keep(enrolment account_rural urban_dummy) ctitle(Rural) title($title_table_14) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


*urban use master_urban.dta
quietly regress enrolment account_urban nl pop_urban branches_urban hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if sector==2 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_14", tex append label keep(enrolment account_urban urban_dummy) ctitle(Urban) title($title_table_14) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


******baseline with all controls 
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_14", tex append label keep(enrolment account urban_dummy) ctitle(Overall) title($title_table_14) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

restore





***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************



global table_number = 14

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number"


preserve

keep if temp==1

*rural use master_rural.dta
quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if sector==1 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_14", dta replace label drop(i.year i.district_code) ctitle(Rural) title($title_table_14) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


*urban use master_urban.dta
quietly regress enrolment account_urban nl pop_urban branches_urban hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if sector==2 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_14", dta append label drop(i.year i.district_code) ctitle(Urban) title($title_table_14) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


******baseline with all controls 
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_14", dta append label drop(i.year i.district_code) ctitle(Overall) title($title_table_14) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

restore








***********************************************************************************************************************
***********************************************************************************************************************


********************************************************
*Table 15: Heterogeneous Effects in Enrolment in the Rural Sample: Land Quartiles
********************************************************


***heterogeneity across land quartiles (for master_rural.dta)


global table_number = 15

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number.tex"

label var account_rural "Education Loan Accounts (per hundred population)"

preserve

keep if temp==1

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart==1 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", tex replace label keep(enrolment account_rural) ctitle(Q1) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart==2 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", tex append label keep(enrolment account_rural) ctitle(Q2) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart==3 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", tex append label keep(enrolment account_rural) ctitle(Q3) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    
  
quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart==4 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", tex append label keep(enrolment account_rural) ctitle(Q4) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


restore



***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************



global table_number = 15

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number"


preserve

keep if temp==1

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart==1 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", dta replace label  drop(i.year i.district_code) ctitle(Q1) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart==2 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", dta append label  drop(i.year i.district_code) ctitle(Q2) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart==3 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", dta append label drop(i.year i.district_code) ctitle(Q3) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    
  
quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart==4 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", dta append label  drop(i.year i.district_code) ctitle(Q4) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


restore





***********************************************************************************************************************
***********************************************************************************************************************





************************************************************************************
*Table 15 : Senjuti's approach : Alternate specification 
************************************************************************************

*Alternate definition of land quartiles

*Table 15: Heterogeneous Effects in Enrolment in the Rural Sample: Land Quartiles

*creating quartile variable used in Table 15 for finding land quartiles

*for rural area only: generating varaible for finding of quartile where family lies as per land possesssed by them
global NSS_year 2004 2009 2011 

foreach k of global NSS_year {

xtile quart_`k'_prime = land_possessed if year==`k' & sector==1 [pw=weight] , nq(4)  // & person_srl_no == 1 this condition is being dropped

} 
*


gen quart_prime =  quart_2004_prime if year==2004
replace quart_prime = quart_2009_prime if year==2009
replace quart_prime = quart_2011_prime if year==2011

label var quart_prime "gives quartile of family as per land possessed using Senjuti's definition" 

tab quart_prime if sector==1 , mi
tab land_possessed if quart_prime==. & sector==1, mi


gen quart_check = 0
replace quart_check = 1 if quart == quart_prime

count if sector ==1 & quart_check == 0  & year == 2004
count if sector ==1 & quart_check == 0  & year == 2009
count if sector ==1 & quart_check == 0  & year == 2011


count if sector ==1 & quart_check == 0  & year == 2004 & person_srl_no==1
count if sector ==1 & quart_check == 0  & year == 2009 & person_srl_no==1
count if sector ==1 & quart_check == 0  & year == 2011 & person_srl_no==1



*Table 15: Heterogeneous Effects in Enrolment in the Rural Sample: Land Quartiles
***heterogeneity across land quartiles (for master_rural.dta)

global title_table_15 "Table 15: Heterogeneous Effects in Enrolment in the Rural Sample: Land Quartiles"

global table_number = 15

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table 15_Senjuti's approach\Table 15_Senjuti's approach.tex"

label var account_rural "Education Loan Accounts (per hundred population)"

preserve

keep if temp==1

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart_prime==1 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", tex replace label keep(enrolment account_rural) ctitle(Q1) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart_prime==2 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", tex append label keep(enrolment account_rural) ctitle(Q2) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart_prime==3 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", tex append label keep(enrolment account_rural) ctitle(Q3) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    
  
quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart_prime==4 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", tex append label keep(enrolment account_rural) ctitle(Q4) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


restore



***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 15

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table 15_Senjuti's approach\Table 15_Senjuti's approach"

*label var account_rural "Education Loan Accounts (per hundred population)"

preserve

keep if temp==1

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart_prime==1 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", dta replace label  drop(i.year i.district_code) ctitle(Q1) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart_prime==2 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", dta append label  drop(i.year i.district_code) ctitle(Q2) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart_prime==3 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", dta append label  drop(i.year i.district_code) ctitle(Q3) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    
  
quietly regress enrolment account_rural nl pop_rural branches_rural hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control i.year i.district_code if quart_prime==4 [pw=weight], vce(cluster district_code)
outreg2 using "$Table_15", dta append label  drop(i.year i.district_code) ctitle(Q4) title($title_table_15) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


restore




***********************************************************************************************************************
***********************************************************************************************************************






********************************************************
*Table 16: Robustness Checks for Effect of Education Loan on Enrolment: Additional Controls
********************************************************

global table_number = 16

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number.tex"

*ssc install reghdfe

preserve

keep if temp==1


******baseline with all controls 
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_16", tex replace label keep(enrolment account) ctitle(Baseline) title($title_table_16) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


***institutions ( "institute" - variable is the number of institutions )
quietly regress enrolment account nl pop branches institute hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_16", tex append label keep(enrolment account) ctitle(Institutes) title($title_table_16) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


****state X time fixed effects
quietly reghdfe enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy [pw=weight], absorb(i.district_code i.year i.state#i.year)
outreg2 using "$Table_16", tex append label keep(enrolment account) ctitle(State X Time) title($title_table_16) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

restore




***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 16

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number"

*ssc install reghdfe

preserve

keep if temp==1


******baseline with all controls 
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_16", dta replace label  drop(i.year i.district_code) ctitle(Baseline) title($title_table_16) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


***institutions ( "institute" - variable is the number of institutions )
quietly regress enrolment account nl pop branches institute hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_16", dta append label  drop(i.year i.district_code) ctitle(Institutes) title($title_table_16) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


****state X time fixed effects
quietly reghdfe enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy [pw=weight], absorb(i.district_code i.year i.state#i.year)
outreg2 using "$Table_16", dta append label  drop(i.district_code i.year i.state#i.year) ctitle(State X Time) title($title_table_16) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

restore






***********************************************************************************************************************
***********************************************************************************************************************





************************************************************************************************
*Table 17: Robustness Checks : Alternative Definitions of the Measure of Loan Availability
************************************************************************************************


*creating account_lag3 loan accounts 


****Note: the variables which have we are using here have been renamed before running regressions. So kindly
*check for their parent variables just at start of the regression


gen account3_prime = ( account3 / pop ) *100
*label var account3_prime "IMP: primary independent variable: #accounts between (t-3,t)"

label var account3_prime "Education Loan Accounts (per hundred population)" 
tab year if account3_prime ==. 



*creating account_lag5 loan accounts 

gen account5_prime = ( account5 / pop ) *100
*label var account5_prime "IMP: primary independent variable: #accounts between (t-5,t)"

label var account5_prime "Education Loan Accounts (per hundred population)" 
tab year if account5_prime ==. 



global table_number = 17

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number.tex"


preserve

keep if temp==1

******baseline with all controls 
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_17", tex replace label keep(enrolment account) ctitle(Baseline) title($title_table_17) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


***3 year difference
quietly regress enrolment account3_prime nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_17", tex append label keep(enrolment account3_prime) ctitle(3-year differences) title($title_table_17) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

***5 year difference
quietly regress enrolment account5_prime nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_17", tex append label keep(enrolment account5_prime) ctitle(5-year differences) title($title_table_17) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

restore



***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************


global table_number = 17

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number"


preserve

keep if temp==1

******baseline with all controls 
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_17", dta replace label  drop(i.year i.district_code) ctitle(Baseline) title($title_table_17) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


***3 year difference
quietly regress enrolment account3_prime nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_17", dta append label  drop(i.year i.district_code) ctitle(3-year differences) title($title_table_17) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

***5 year difference
quietly regress enrolment account5_prime nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_17", dta append label  drop(i.year i.district_code) ctitle(5-year differences) title($title_table_17) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

restore






***********************************************************************************************************************
***********************************************************************************************************************




********************************************************************************************
*Table 18: Robustness Checks : Excluding 2009 and Loan Accounts for Public Sector Banks
********************************************************************************************


*creating account_lag5 loan accounts 

****Note: the variables which have we are using here have been renamed before running regressions. So kindly
*check for their parent variables just at start of the regression

gen pub_account_prime = (pub_account/pop) *100

label var pub_account_prime "Education Loan Accounts (per hundred population)"  
tab year if pub_account_prime ==. 



global table_number = 18

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number.tex"


preserve

keep if temp==1


******baseline with all controls 
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_18", tex replace label keep(enrolment account) ctitle(Basline) title($title_table_18) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


***robustness check: excluding 2009
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight] if year==2004 | year==2011, vce(cluster district_code)
outreg2 using "$Table_18", tex append label keep(enrolment account) ctitle(2004 \& 2011) title($title_table_18) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


**only Public bank accounts
quietly regress enrolment pub_account_prime nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_18", tex append label keep(enrolment pub_account_prime) ctitle(Public Sector Banks) title($title_table_18) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

restore



***********************************************************************************************************************
*** Getting regression output in STATA (.dta) format which would eventually be useful to convert output in Excel format 
***********************************************************************************************************************



global table_number = 18

global Table_$table_number "$common_path\Regression Specifications\Specification 2\Output and Results\Table $table_number\Table_$table_number"


preserve

keep if temp==1


******baseline with all controls 
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_18", dta replace label  drop(i.year i.district_code) ctitle(Basline) title($title_table_18) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


***robustness check: excluding 2009
quietly regress enrolment account nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight] if year==2004 | year==2011, vce(cluster district_code)
outreg2 using "$Table_18", dta append label  drop(i.year i.district_code) ctitle(2004 \& 2011) title($title_table_18) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    


**only Public bank accounts
quietly regress enrolment pub_account_prime nl pop branches hh_size land_possessed avg_edu tot_age dep female_dummy i.religion $caste_control urban_dummy i.year i.district_code [pw=weight], vce(cluster district_code)
outreg2 using "$Table_18", dta append label drop(i.year i.district_code) ctitle(Public Sector Banks) title($title_table_18) addtext(Demographic Controls, YES, District Fixed Effects, YES, Time Fixed Effects, YES, District Level Time Controls, YES) nocons    

restore




*********************************************************************************************
** Creating an Excel file for Specification 2 using STATA (.dta) files created in above steps
*********************************************************************************************

clear

global Specification_2 "$common_path\Regression Specifications\Specification 2\Output and Results\Specification 2.xlsx" 

forvalues i = 11/18 {

		use "$common_path\Regression Specifications\Specification 2\Output and Results\Table `i'\Table_`i'_dta.dta", clear
		
		if `i' == 11 export excel using "$Specification_2", sheet("Table_`i'") replace
		
		if `i' != 11 export excel using "$Specification_2", sheet("Table_`i'") sheetmodify
				
		clear

}
*


*appending excel file for Table 15's alternative definition regression
 
use "$common_path\Regression Specifications\Specification 2\Output and Results\Table 15_Senjuti's approach\Table 15_Senjuti's approach_dta.dta", clear
export excel using "$Specification_2", sheet("Table 15_Senjuti approach") sheetmodify
clear



log close








