/****************************************************************************************

THIS DO FILE CONTAINS STATA COMMANDS TO PREPARE REQUIRED DATA FOR 
NSS 61, 66, 68 & 71 ROUND


IMPORTANT NOTE: 
FOR GENERATING EACH DATASET, USER NEEDS TO SET COMMON PATH AS PER HIS LOCAL MACHINE WHERE PROJECT FOLDER HAVE BEEN SAVED.


*PLEASE REFER TO BELOW TABLE TO LOCATE CODE FOR REQUIRED DATASET

NAME			CODE LINE (APPROXIMATELY)	

NSS 61			25
NNS 66			120
NSS 68 			444
NSS 71			700

***************************************************************************************/




**********************************
******** NSS 61 ********
**********************************


*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"

log using "$common_path\NSS Data\log file nss data.log", append

*loading NSS 61 data which has info on religion and social group.. where each household is identified using "common_id"
global NSS61_relig_social_grp_data "$common_path\NSS Data\NSS 61\Raw Data\level01.dta"


*loading NSS 61 data which has info on education status which has data at "person_srl_no" level
use "$common_path\NSS Data\NSS 61\Raw Data\level03.dta", clear


merge m:1 common_id using "$NSS61_relig_social_grp_data" 


**grooming data for NSS 61 th round

*converting the string formats
tostring state , generate(state_string)

tostring district , generate(district_string)

gen district_string_len= length(district_string)
tab district_string_len, mi
 
gen district_string_2_digit_code= district_string 
replace district_string_2_digit_code= string(0)+ district_string if district_string_len==1  

gen State_district_code_string = state_string + district_string_2_digit_code

gen State_district_code_string_len = length(State_district_code_string)
tab State_district_code_string_len, mi 

destring State_district_code_string, generate(State_district_code_numeric)
rename State_district_code_numeric State_district_code

*dropping unnecessary varaibles 
drop district_string_len district_string_2_digit_code State_district_code_string State_district_code_string_len

label var State_district_code "IMP: district code created by us using info present in NSS different levels"

label var _merge "merge resulting from merging NSS 61 religion, social group and education data"
rename _merge merge_NSS61_relg_soc_with_educ 


*finding if State_district_code has any missing values 
count if State_district_code == .



*DROPPING unwanted states

local index "1 11 12 13 14 15 16 17 25 26 30 31 34 35" 

foreach x of local index {
	
	drop if state== `x'
}
*

save "$common_path\NSS Data\NSS 61\Processed Data\nss_61_2004_relg_social_grp_educ_dataset_15122017.dta", replace
clear











************************************************************************************************************************************
************************************************************************************************************************************





**********************************
************* NSS 66 *************
**********************************


/*
*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"
*/



***** Step 1 *****



import excel using "$common_path\NSS Data\NSS 66\Raw Data\District code_66.xls", firstrow
set more off 


gen StateCode_len= length(StateCode)
tab StateCode_len, mi

gen DistrictCode_len=length(DistrictCode)
tab DistrictCode_len, mi 

*gen StateCode_new = string(0)+ StateCode if StateCode_len < 2
*replace StateCode_new = StateCode if StateCode_len = 2

gen State_district_code= StateCode + DistrictCode
gen State_district_code_len=length(State_district_code)
tab State_district_code_len, mi 


*converting string into numbers

destring StateCode, replace
destring DistrictCode, replace
destring State_district_code, replace

*dropping unnecessary length variables
drop StateCode_len DistrictCode_len State_district_code_len


*assigning keys

gen State_66="Andaman & Nicobar Islands" if StateCode==35
replace State_66="Andhra Pradesh" if StateCode==28
replace State_66="Arunachal Pradesh" if StateCode==12
replace State_66="Assam" if StateCode==18
replace State_66="Bihar" if StateCode==10
replace State_66="Chandigarh" if StateCode==04
replace State_66="Chhattisgarh" if StateCode==22
replace State_66="Dadra and Nagar Haveli" if StateCode==26
replace State_66="Daman & Diu" if StateCode==25
replace State_66="Delhi" if StateCode==07
replace State_66="GOA" if StateCode==30
replace State_66="Gujarat" if StateCode==24
replace State_66="Haryana" if StateCode==06
replace State_66="Himachal Pradesh" if StateCode==02
replace State_66="Jammu & Kashmir" if StateCode==01
replace State_66="Jharkhand" if StateCode==20
replace State_66="Karnataka" if StateCode==29
replace State_66="Kerala" if StateCode==32
replace State_66="Lakshadweep" if StateCode==31
replace State_66="Madhya Pradesh" if StateCode==23
replace State_66="Maharashtra" if StateCode==27
replace State_66="Manipur" if StateCode==14
replace State_66="Meghalaya" if StateCode==17
replace State_66="Mizoram" if StateCode==15
replace State_66="Nagaland" if StateCode==13
replace State_66="Orissa" if StateCode==21
replace State_66="Pondicherry" if StateCode==34
replace State_66="Punjab" if StateCode==03
replace State_66="Rajasthan" if StateCode==08
replace State_66="Sikkim" if StateCode==11
replace State_66="Tamilnadu" if StateCode==33
replace State_66="Tripura" if StateCode==16
replace State_66="Uttar Pradesh" if StateCode==09
replace State_66="Uttaranchal" if StateCode==05
replace State_66="West Bengal" if StateCode==19

*no missing values obtained
tab State_66, mi

*renaming as per NSS Round number

*StateName StateCode DistrictName DistrictCode State_district_code

rename StateName StateName_old_66
rename StateCode State_code_66
rename DistrictCode District_code_66

rename DistrictName District_66


*triming the values and convering to upper cases

replace State_66 = trim(upper(State_66))
replace District_66= trim(upper(District_66))


*generating state_district key for NSS 66 round

gen State_district_key_66 = State_66 + "_" + District_66


tab State_district_code, mi
drop if State_district_code==.


save "$common_path\NSS Data\NSS 66\Step 1\nss_66_round_district_codes_30102017.dta", replace
clear












***************************
****** Step 2 *******
***************************

global NSS_66_data "$common_path\NSS Data\NSS 66\Step 1\nss_66_round_district_codes_30102017.dta" 
use "$NSS_66_data", clear

distinct State_district_code
sort State_district_code
  
gen st_dis_code_1 = State_district_code

/*making manual changes, however remember  we are using same list as in NSS 68th round but commented the cases
which are not required */

replace st_dis_code_1 = 307 if State_district_code== 318
*replace st_dis_code_1 = 316 if State_district_code== 319
*replace st_dis_code_1 = 302 if State_district_code== 320
replace st_dis_code_1 = 510 if State_district_code== 508
replace st_dis_code_1 = 508 if State_district_code== 510
replace st_dis_code_1 = 511 if State_district_code== 514
replace st_dis_code_1 = 505 if State_district_code== 515
replace st_dis_code_1 = 618 if State_district_code== 620
*replace st_dis_code_1 = 917 if State_district_code== 971
replace st_dis_code_1 = 1033 if State_district_code== 1038
replace st_dis_code_1 = 1804 if State_district_code== 1824
replace st_dis_code_1 = 1805 if State_district_code== 1825
replace st_dis_code_1 = 1806 if State_district_code== 1826
replace st_dis_code_1 = 1808 if State_district_code== 1827

replace st_dis_code_1 = 1915 if State_district_code== 1919
replace st_dis_code_1 = 2002 if State_district_code== 2019
replace st_dis_code_1 = 2016 if State_district_code== 2020
replace st_dis_code_1 = 2011 if State_district_code== 2021
replace st_dis_code_1 = 2017 if State_district_code== 2022
*replace st_dis_code_1 = 2215 if State_district_code== 2217
*replace st_dis_code_1 = 2216 if State_district_code== 2218
replace st_dis_code_1 = 2307 if State_district_code== 2346
replace st_dis_code_1 = 2316 if State_district_code== 2347
replace st_dis_code_1 = 2329 if State_district_code== 2348
*replace st_dis_code_1 = 2324 if State_district_code== 2349
*replace st_dis_code_1 = 2317 if State_district_code== 2350
*replace st_dis_code_1 = 2921 if State_district_code== 2928
*replace st_dis_code_1 = 2919 if State_district_code== 2929
replace st_dis_code_1 = 3305 if State_district_code== 3331

rename st_dis_code_1 State_district_FINAL_code_66

gen true_state_district_code_66 = 1     if State_district_code== State_district_FINAL_code_66
replace true_state_district_code_66 =0  if State_district_code!= State_district_FINAL_code_66

list State_district_code State_district_key_66 State_district_FINAL_code_66  if true_state_district_code_66 ==0


save "$common_path\NSS Data\NSS 66\Step 2\nss_66_district_code_remaped_dataset_03112017_2250.dta" , replace
clear






***************************
****** Step 3 *******
***************************


*loading NSS 66 data which has info on religion and social group
global NSS66_relig_social_grp_data "$common_path\NSS Data\NSS 66\Raw Data\level02.dta"

*loading NSS 66 data which has info on education status
use "$common_path\NSS Data\NSS 66\Raw Data\level04.dta", clear

merge m:1 common_id using "$NSS66_relig_social_grp_data" 



**grooming data for NSS 66 th round

*converting the string formats
tostring state , generate(state_string)

tostring district , generate(district_string)

gen district_string_len= length(district_string)
tab district_string_len, mi
 
gen district_string_2_digit_code= district_string 
replace district_string_2_digit_code= string(0)+ district_string if district_string_len==1  

gen State_district_code_string = state_string + district_string_2_digit_code

gen State_district_code_string_len = length(State_district_code_string)
tab State_district_code_string_len, mi 

destring State_district_code_string, generate(State_district_code_numeric)
rename State_district_code_numeric State_district_code

*dropping unnecessary varaibles 
drop district_string_len district_string_2_digit_code State_district_code_string State_district_code_string_len

label var State_district_code "district code created by us using info present in NSS different levels"

label var _merge "merge resulting from merging NSS 66 religion, social group and education data"
rename _merge merge_NSS66_relg_soc_with_educ 




******** mapping with normalized NSS 61 round codes ********

*CANNOT RUN district mapping file created by us since we don't have variable which has information on State and District
  

*merging with NSS 66 remapped data (this dataset consists of NSS 66 district codes which are normalized to NSS 61 level)


global NSS_66_remaped_data "$common_path\NSS Data\NSS 66\Step 2\nss_66_district_code_remaped_dataset_03112017_2250.dta"
merge m:1 State_district_code using "$NSS_66_remaped_data"

rename _merge merge_soc_relg_educ_with_remap66
label var merge_soc_relg_educ_with_remap66 "merge of nss religion, social group, education with remapped NSS 66 data" 

label var State_district_FINAL_code_66 "IMP: NSS 61 normalized codes" 

gen true_old_remaped_code= 1 if State_district_FINAL_code_66 == State_district_code
replace true_old_remaped_code= 0 if State_district_FINAL_code_66 != State_district_code

tab State_district_key_66 if true_old_remaped_code== 0


duplicates examples state District_66 State_district_code State_district_FINAL_code_66 if true_old_remaped_code ==0

count if State_district_FINAL_code_66==.
tab merge_NSS66_relg_soc_with_educ
tab merge_soc_relg_educ_with_remap66



*we should keep only those observations which are present in NSS 66 different levels
list state district District_66 State_district_code State_district_FINAL_code_66 if merge_soc_relg_educ_with_remap66 == 2
drop if merge_soc_relg_educ_with_remap66 == 2


*dropping uncesessary varaibles
drop StateName_old_66 State_code_66 District_code_66 true_state_district_code_66 State_district_key_66

*labelling variables from NSS 66 remapped dataset
label var State_66 "state name variable from NSS 66 remapped dataset"
label var District_66 "district name variable from NSS 66 remapped dataset"

label var true_old_remaped_code "when equal to 0, gives info for district getting normalized codes frm NSS61 round"


*dropping unwanted states

distinct State_66 
rename State_66 State


*running state drop do file
run "$common_path\Supporting Files\statedrop modified 15122017.do"

rename State State_66

distinct State_66 
tab State_66 , mi

*sort common_id person_srl_no, stable

save "$common_path\NSS Data\NSS 66\Step 3\nss_66_2004_relg_social_grp_educ_dataset_15122017.dta", replace  

clear






















**********************************
************* NSS 68 *************
**********************************

/*
*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"
*/



***** Step 1 *****


set more off 


global NSS_68_file "$common_path\NSS Data\NSS 68\Raw Data\District-codes_68.xls" 
import excel using "$NSS_68_file"

rename A State_code_68
rename B District_code_68
rename C District_68
rename D State_68

*dropping 3 blank rows which got imported from the Excel file
drop in 1/3

*removing star mark from District names

gen tag_string=0
replace tag_string =1 if substr(District_68,-1,.)=="*"

gen District_68_new = District_68
replace District_68_new =substr(District_68, 1, length(District_68)-1 ) if tag_string ==1

*renaming the district variable for convienece
rename District_68 old_District_68

rename District_68_new District_68


*triming the values and convering to upper cases

replace State_68 = trim(upper(State_68))
replace District_68= trim(upper(District_68)) 


*gernating state-district dode
gen State_district_code_string = State_code_68 + District_code_68

destring State_district_code_string, generate(State_district_code)





*generating state_district key for NSS 68 round

gen State_district_key_68 = State_68 + "_" + District_68

save "$common_path\NSS Data\NSS 68\Step 1\nss_68_round_district_codes_31102017 1440.dta", replace
clear





********** Step 2 **********


*using NSS 68th round data 

global NSS_68_data "$common_path\NSS Data\NSS 68\Step 1\nss_68_round_district_codes_31102017 1440.dta" 
use "$NSS_68_data", clear

distinct State_district_code


/*making manual changes, however remember  we are using same list for both NSS 66 and 68th round 
However, in NSS 66 th round we commented the cases which are not required */

sort State_district_code

gen st_dis_code_1 = State_district_code

replace st_dis_code_1 = 307 if State_district_code== 318
replace st_dis_code_1 = 316 if State_district_code== 319
replace st_dis_code_1 = 302 if State_district_code== 320
replace st_dis_code_1 = 510 if State_district_code== 508
replace st_dis_code_1 = 508 if State_district_code== 510
replace st_dis_code_1 = 511 if State_district_code== 514
replace st_dis_code_1 = 505 if State_district_code== 515
replace st_dis_code_1 = 618 if State_district_code== 620
replace st_dis_code_1 = 917 if State_district_code== 971
replace st_dis_code_1 = 1033 if State_district_code== 1038
replace st_dis_code_1 = 1804 if State_district_code== 1824
replace st_dis_code_1 = 1805 if State_district_code== 1825
replace st_dis_code_1 = 1806 if State_district_code== 1826
replace st_dis_code_1 = 1808 if State_district_code== 1827

replace st_dis_code_1 = 1915 if State_district_code== 1919
replace st_dis_code_1 = 2002 if State_district_code== 2019
replace st_dis_code_1 = 2016 if State_district_code== 2020
replace st_dis_code_1 = 2011 if State_district_code== 2021
replace st_dis_code_1 = 2017 if State_district_code== 2022
replace st_dis_code_1 = 2215 if State_district_code== 2217
replace st_dis_code_1 = 2216 if State_district_code== 2218
replace st_dis_code_1 = 2307 if State_district_code== 2346
replace st_dis_code_1 = 2316 if State_district_code== 2347
replace st_dis_code_1 = 2329 if State_district_code== 2348
replace st_dis_code_1 = 2324 if State_district_code== 2349
replace st_dis_code_1 = 2317 if State_district_code== 2350
replace st_dis_code_1 = 2921 if State_district_code== 2928
replace st_dis_code_1 = 2919 if State_district_code== 2929
replace st_dis_code_1 = 3305 if State_district_code== 3331

rename st_dis_code_1 State_district_FINAL_code_68

*testing for the changes we have made 

gen true_state_district_code_68 = 1     if State_district_code== State_district_FINAL_code_68
replace true_state_district_code_68 =0  if State_district_code!= State_district_FINAL_code_68

list State_district_code State_district_key_68 State_district_FINAL_code_68  if true_state_district_code_68 ==0

save "$common_path\NSS Data\NSS 68\Step 2\nss_68_district_code_remaped_dataset_06112017_1320.dta", replace
clear








******* Step 3 *******


set more off



*loading NSS 68 data which has info on religion and social group
global NSS68_relig_social_grp_data "$common_path\NSS Data\NSS 68\Raw Data\level02.dta"

*loading NSS 68 data which has info on education status
use "$common_path\NSS Data\NSS 68\Raw Data\level03.dta", clear


merge m:1 common_id using "$NSS68_relig_social_grp_data" 



**grooming data for NSS 68 th round

*converting the string formats
tostring state , generate(state_string)

tostring district , generate(district_string)

gen district_string_len= length(district_string)
tab district_string_len, mi
 
gen district_string_2_digit_code= district_string 
replace district_string_2_digit_code= string(0)+ district_string if district_string_len==1  

gen State_district_code_string = state_string + district_string_2_digit_code

gen State_district_code_string_len = length(State_district_code_string)
tab State_district_code_string_len, mi 

destring State_district_code_string, generate(State_district_code_numeric)
rename State_district_code_numeric State_district_code

*dropping unnecessary varaibles 
drop district_string_len district_string_2_digit_code State_district_code_string State_district_code_string_len

label var State_district_code "district code created by us using info present in NSS different levels"

label var _merge "merge resulting from merging NSS 68 religion, social group and education data"
rename _merge merge_NSS68_relg_soc_with_educ 


******** mapping with normalized NSS 61 round codes ********

*CANNOT RUN district mapping file created by us since we don't have variable which has information on State and District
*merging with NSS 68 remapped data (this dataset consists of NSS 68 district codes which are normalized to NSS 61 level)

 
global NSS_68_remaped_data "$common_path\NSS Data\NSS 68\Step 2\nss_68_district_code_remaped_dataset_06112017_1320.dta"
merge m:1 State_district_code using "$NSS_68_remaped_data"

rename _merge merge_soc_relg_educ_with_remap68
label var merge_soc_relg_educ_with_remap68 "merge of nss religion, social group, education with remapped NSS 68 data" 

label var State_district_FINAL_code_68 "IMP: NSS 61 normalized codes" 

gen true_old_remaped_code= 1 if State_district_FINAL_code_68 == State_district_code
replace true_old_remaped_code= 0 if State_district_FINAL_code_68 != State_district_code

tab State_district_key_68 if true_old_remaped_code== 0

*br state District_68 State_district_code State_district_FINAL_code_68 if true_old_remaped_code ==0

duplicates examples state District_68 State_district_code State_district_FINAL_code_68 if true_old_remaped_code ==0

count if State_district_FINAL_code_68==.
tab merge_NSS68_relg_soc_with_educ
tab merge_soc_relg_educ_with_remap68



*we should keep only those observations which are present in NSS 68 different levels
list state district District_68 State_district_code State_district_FINAL_code_68 if merge_soc_relg_educ_with_remap68 == 2
drop if merge_soc_relg_educ_with_remap68 == 2



*dropping uncesessary varaibles obtained from suing dataset (NSS 68th remapped data)
drop State_code_68 District_code_68 old_District_68 tag_string State_district_code_string State_district_key_68 true_state_district_code_68

label var true_old_remaped_code "when equal to 0, gives info for district getting normalized codes from NSS61 round"


*running file consisting of a program <<<state_drop>>> which in turns labels state and district varaible and DROPS unwanted states


state_drop 68 State_68 District_68



save "$common_path\NSS Data\NSS 68\Step 3\nss_68_2011_relg_social_grp_educ_dataset_15122017.dta", replace
clear 

















**********************************
************* NSS 71 *************
**********************************

/*
*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"
*/


***** Step 1 *******



global NSS_71_file "$common_path\NSS Data\NSS 71\Raw Data\dist_code_71st.xls" 


import excel using "$NSS_71_file"

*dropping 3 blank rows which got imported from the Excel file
drop in 1/3

*renaming variables
rename A State_code_71
rename B State_71

rename C District_71
rename D District_code_71


*removing paranthesis from District code
gen State_code_71_Inter_1 = trim(State_code_71)
gen State_code_71_Inter_2 = substr(State_code_71_Inter_1,2,2)   
*checking string length
gen State_code_71_Inter_2_len = length(State_code_71_Inter_2)
tab State_code_71_Inter_2_len, mi



*removing paranthesis from District code
gen District_code_71_Inter_1 = trim(District_code_71)
gen District_code_71_Inter_2 = substr(District_code_71_Inter_1,2,2)  
*checking string length
gen District_code_71_Inter_2_len = length(District_code_71_Inter_2)
tab District_code_71_Inter_2_len, mi

*renaming old and new state and district variables

rename State_code_71 old_State_code_71 
rename District_code_71 old_District_code_71

rename State_code_71_Inter_2 State_code_71
rename District_code_71_Inter_2 District_code_71 

*dropping trimmed and length variables
drop State_code_71_Inter_1 District_code_71_Inter_1 State_code_71_Inter_2_len District_code_71_Inter_2_len

*gernating state-district code
gen State_district_code_string_71 = State_code_71 + District_code_71

*generating key common across all rounds
destring State_district_code_string_71, generate(State_district_code)


*triming the values and converting to upper cases

rename State_71 old_State_71
rename District_71 old_District_71

gen State_71 = trim(upper(old_State_71))
gen District_71= trim(upper(old_District_71)) 


*generating state_district key for NSS 71 round
gen State_district_key_71 = State_71 + "_" + District_71

save "$common_path\NSS Data\NSS 71\Step 1\nss_71_round_district_codes_31102017 1652.dta", replace
clear

*************************************************************************************************









************** Step 2 **************


*modifying NSS 68 remapped dataset so that it could be useful for generating remapped dataset for NSS 71
*this is primarily done for purpose of doing reclink exercise

global NSS_68_remaped_data "$common_path\NSS Data\NSS 68\Step 2\nss_68_district_code_remaped_dataset_06112017_1320.dta"  
use "$NSS_68_remaped_data", clear

rename State_district_key_68 State_district_key_68_71
rename State_district_code State_district_code_68
rename State_district_code_68 State_district_primitive_code_68

save "$common_path\NSS Data\NSS 71\Step 2\nss_68_district_code_remaped_for_NSS_71_dataset_06112017_1615.dta", replace
clear

*****************************************************************




*loading NSS 71 original dataset

global NSS_71_original "$common_path\NSS Data\NSS 71\Step 1\nss_71_round_district_codes_31102017 1652.dta"
use "$NSS_71_original", clear

*just doing for the sake of merging the remaped-NSS 68 data with NSS 71st round
rename State_district_key_71 State_district_key_68_71
rename State_district_code State_district_primitive_code_71



*merging (using recklink) NSS 68th remaped district with NSS 71st original data
global NSS_68_remaped_data_for_NSS_71 "$common_path\NSS Data\NSS 71\Step 2\nss_68_district_code_remaped_for_NSS_71_dataset_06112017_1615.dta"  

reclink State_district_key_68_71 using "$NSS_68_remaped_data_for_NSS_71", idmaster(State_district_primitive_code_71) idusing(State_district_primitive_code_68) gen(match_score)   


*cross checking variables

gen true_primitive_nss_68_71 = 1     if State_district_primitive_code_71 == State_district_primitive_code_68
replace true_primitive_nss_68_71 = 0 if State_district_primitive_code_71 != State_district_primitive_code_68
count if true_primitive_nss_68_71 == 0
count if true_primitive_nss_68_71 == 0 & match_score !=1



*****************************************
*making manual changes to exceptional districts in NSS 71 round
*****************************************

gen State_district_FINAL_code_71= State_district_FINAL_code_68

replace State_district_FINAL_code_71 = 306 if State_district_primitive_code_71== 305
replace State_district_FINAL_code_71 = 619 if State_district_primitive_code_71== 621
replace State_district_FINAL_code_71 = 1820 if State_district_primitive_code_71== 1816
replace State_district_FINAL_code_71 = 1806 if State_district_primitive_code_71== 1823
replace State_district_FINAL_code_71 = 2004 if State_district_primitive_code_71== 2016
replace State_district_FINAL_code_71 = 2014 if State_district_primitive_code_71== 2020
replace State_district_FINAL_code_71 = 2904 if State_district_primitive_code_71== 2926
replace State_district_FINAL_code_71 = 2808 if State_district_primitive_code_71== 3608
replace State_district_FINAL_code_71 = 2809 if State_district_primitive_code_71== 3609
replace State_district_FINAL_code_71 = 2801 if State_district_primitive_code_71== 3601
replace State_district_FINAL_code_71 = 3312 if State_district_primitive_code_71== 3332
replace State_district_FINAL_code_71 = 2810 if State_district_primitive_code_71== 3610
replace State_district_FINAL_code_71 = 2804 if State_district_primitive_code_71== 3604
replace State_district_FINAL_code_71 = 2422 if State_district_primitive_code_71== 2426
replace State_district_FINAL_code_71 = 2806 if State_district_primitive_code_71== 3606
replace State_district_FINAL_code_71 = 0829 if State_district_primitive_code_71== 833
replace State_district_FINAL_code_71 = 2802 if State_district_primitive_code_71== 3602
replace State_district_FINAL_code_71 = 2805 if State_district_primitive_code_71== 3605

*************************************************************************************************


*testing for the changes we have made 
*actually if NSS 68 and 71st were same, we would have considered NSS 68 codes which are normalized to NSS 61st round 

gen true_state_district_code_71 = 1     if State_district_FINAL_code_68 == State_district_FINAL_code_71
replace true_state_district_code_71 =0  if State_district_FINAL_code_68 != State_district_FINAL_code_71


*checking for duplicates in data

distinct State_district_primitive_code_71

duplicates report State_district_primitive_code_71

duplicates examples State_district_primitive_code_71

list State_district_primitive_code_71 State_district_key_68_71 if State_district_primitive_code_71== 621 | State_district_primitive_code_71== 2214

list State_district_primitive_code_71 State_district_key_68_71 State_district_FINAL_code_71  if true_state_district_code_71 ==0

*br State_district_key_68_71 State_district_primitive_code_71  match_score _merge State_district_FINAL_code_68  UState_district_key_68_71 State_district_primitive_code_68 State_district_FINAL_code_71 if true_state_district_code_71 ==0

list State_district_key_68_71 State_district_primitive_code_71 State_district_FINAL_code_68 State_district_FINAL_code_71 if State_district_primitive_code_71==621 | State_district_primitive_code_71==2214

*droping one of palwal
*br if State_district_primitive_code_71==621 & State_district_FINAL_code_68==606
drop if State_district_primitive_code_71==621 & State_district_FINAL_code_68==606

*droping wrong Uttar Bastar Kanker
*br if State_district_primitive_code_71==2214 & State_district_FINAL_code_68==2215 
drop if State_district_primitive_code_71==2214 & State_district_FINAL_code_68==2215

duplicates report State_district_primitive_code_71


*renaming variables for future datasets
rename State_district_primitive_code_71 State_district_code
rename _merge _merge_nss71_with_modify_68

*labelling variables

label var State_district_primitive_code_68 "primitve/original code from NSS 68 round excel file"
label var State_district_code "primitve/original code from NSS 71st round excel file"  

label var true_primitive_nss_68_71 "binary variable, zero denoting mismatches where primitve values of NSS 68 and 71 DOESN'T match after using reglink"  
label var true_state_district_code_71 "binay variable, zero denotes mismatches where NSS 68 FINAL and NSS 71 FINAL differ"

label var State_district_key_68_71 "Original State-District combination from NSS 71st round"
label var UState_district_key_68_71 "Original State-District combination from NSS 68st round..'U' stands for using while we were doing merge" 

label var State_district_FINAL_code_68 "these are normalized to 61st round ..NSS 68th round codes"
label var State_district_FINAL_code_71 "these are normalized to 61st round ..NSS 71st round codes"


*making correction for 2 districts for whom mapping was not done properly 

replace State_district_FINAL_code_71 = 2123 if State_district_code== 2123  // replacing for Orissa Subranpur
replace State_district_FINAL_code_71 = 913  if State_district_code== 913   // replacing for UP Mahamaya nagar/ hathras 



*sort _all, stable   //this step was included just for purpose of checking this newly generated dataset with old dataset

save "$common_path\NSS Data\NSS 71\Step 2\nss_71_district_code_remaped_dataset_07112017_1642.dta", replace

clear

**************************************************************************











************** Step 3 ******************


set more off 

*loading NSS 71 data which has info on religion and social group
global NSS71_relig_social_grp_data "$common_path\NSS Data\NSS 71\Raw Data\level02.dta"

*loading NSS 71 data which has info on education status
use "$common_path\NSS Data\NSS 71\Raw Data\level03.dta" , clear

merge m:1 common_id using "$NSS71_relig_social_grp_data" 


**grooming data for NSS 71 th round

*converting the string formats
tostring state , generate(state_string)

tostring district , generate(district_string)

gen district_string_len= length(district_string)
tab district_string_len, mi
 
gen district_string_2_digit_code= district_string 
replace district_string_2_digit_code= string(0)+ district_string if district_string_len==1  

gen State_district_code_string = state_string + district_string_2_digit_code

gen State_district_code_string_len = length(State_district_code_string)
tab State_district_code_string_len, mi 

destring State_district_code_string, generate(State_district_code_numeric)
rename State_district_code_numeric State_district_code

*dropping unnecessary varaibles 
drop district_string_len district_string_2_digit_code State_district_code_string State_district_code_string_len

label var State_district_code "district code created by us using info present in NSS different levels"

label var _merge "merge resulting from merging NSS 71 religion, social group and education data"

rename _merge merge_NSS71_relg_soc_with_educ 



******** mapping with normalized NSS 61 round codes ********

*CANNOT RUN district mapping file created by us since we don't have variable which has information on State and District
*merging with NSS 71 remapped data
 
global NSS_71_remaped_data "$common_path\NSS Data\NSS 71\Step 2\nss_71_district_code_remaped_dataset_07112017_1642.dta"

merge m:1 State_district_code using "$NSS_71_remaped_data"

duplicates examples District_71 State_district_code if state==28  // checking for Andhra Pradesh
duplicates examples District_71 State_district_code if state==36  // checking for Telangana

*code 2810 is not getting mapped since 2810 corresponds to Andhara Khammam (125 observation). But NSS 71 also has 3610 corresponding to Telangana Khammam (347 observation)
*hence we need to assign all observations to Telangana Khamman (total: 472). Since it would make Khammam observations same as other district observations in Telangana

replace State_district_FINAL_code_71 = 3610 if State_district_code ==2810  


count if State_district_FINAL_code_71==.

rename _merge merge_soc_relg_educ_with_remap71
label var merge_soc_relg_educ_with_remap71 "merge of nss religion, social group, education with remapped NSS 71 data" 

label var State_district_FINAL_code_71 "IMP: NSS 61 normalized codes" 

gen true_old_remaped_code= 1 if State_district_FINAL_code_71 == State_district_code
replace true_old_remaped_code= 0 if State_district_FINAL_code_71 != State_district_code


*duplicates examples state District_71 State_district_code State_district_FINAL_code_71 if true_old_remaped_code ==0

count if State_district_FINAL_code_71==.
tab merge_NSS71_relg_soc_with_educ
tab merge_soc_relg_educ_with_remap71


*we should keep only those observations which are present in NSS 71 different levels
list state district District_71 State_district_code State_district_FINAL_code_71 if merge_soc_relg_educ_with_remap71 == 2

drop if merge_soc_relg_educ_with_remap71 == 2


* dropping UNWANTED variables brought with (using) dataset
drop old_State_code_71 old_State_71 old_District_71 old_District_code_71 State_code_71 District_code_71 State_district_code_string_71 State_district_key_68_71 UState_district_key_68_71 match_score State_district_primitive_code_68 State_code_68 District_code_68 old_District_68 State_68 tag_string District_68 State_district_code_string State_district_FINAL_code_68 true_state_district_code_68 _merge_nss71_with_modify_68 true_primitive_nss_68_71 true_state_district_code_71


label var true_old_remaped_code "when equal to 0, gives info for district getting normalized codes from NSS61 round"


*dropping irrelvent states using the program we created (this program is written under Global variable and Programs file 15022018.do)
state_drop 71 State_71 District_71




save "$common_path\NSS Data\NSS 71\Step 3\nss_71_2014_relg_social_grp_educ_dataset_15122017.dta", replace
clear 


*closing the log file created at the beginning
log close





											************************************
											******* END OF LAST DATASET ********
											************************************
