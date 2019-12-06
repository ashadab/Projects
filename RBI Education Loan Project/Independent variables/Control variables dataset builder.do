/****************************************************************************************

THIS DO FILE CONTAINS STATA COMMANDS TO PREPARE ALL THE INDEPENDENT VARAIBLES DATASET : 
HIGHER EDUCATION INSTITUTES, EDUCATION LOAN, CENSUS (POPULATION), NIGHT LIGHTS, BANK BRANCHES 


IMPORTANT NOTE: 
FOR GENERATING EACH DATASET, USER NEEDS TO SET COMMON PATH AS PER HIS LOCAL MACHINE WHERE PROJECT FOLDER HAVE BEEN SAVED.


*PLEASE REFER TO BELOW TABLE TO LOCATE CODE FOR REQUIRED DATASET

SNo NAME									CODE LINE (APPROXIMATELY)	

1. 	HIGHER EDUCATION INSTITUTES DATASET		30
2. 	EDUCATION LOAN DATASET 					345
3. 	CENSUS POPULATION DATASET 				1500
4. 	NIGHT LIGHTS DATASET 					2755
5. 	BANK BRANCHES DATASET					4060
	-BRANCH OPEN DATASET					4083
	-BRANCH CLOSE DATASET					4700
	-BRANCH OPERATING DATASET				4875
***************************************************************************************/




*********************************************************************************************************************************
*********************************** HIGHER EDUCATION INSTITUTES DATASET ********************************************************************
*********************************************************************************************************************************

		
*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"
		
log using "$common_path\Independent variables\log file independent variables.log", append
		
		
*loading raw institutional dataset 
use "$common_path\Independent variables\Institution Dataset\Raw Data\inst_dist.dta" , clear

*creating a state variable with names since it was missing in original dataset

generate State = ""

replace State = "HIMACHAL PRADESH" if state_code11 == 2
replace State = "PUNJAB" if state_code11 == 3
replace State = "CHANDIGARH" if state_code11 == 4
replace State = "UTTARAKHAND" if state_code11 == 5
replace State = "HARYANA" if state_code11 == 6
replace State = "DELHI" if state_code11 == 7
replace State = "RAJASTHAN" if state_code11 == 8
replace State = "UTTAR PRADESH" if state_code11 == 9
replace State = "BIHAR" if state_code11 == 10
replace State = "DELHI" if state_code11 == 11
*br if state_code11==7 |  state_code11== 11
replace State = "ASSAM" if state_code11 == 18
replace State = "WEST BENGAL" if state_code11 == 19
replace State = "JHARKHAND" if state_code11 == 20
replace State = "ODISHA" if state_code11 == 21
replace State = "CHHATTISGARH" if state_code11 == 22
replace State = "MADHYA PRADESH" if state_code11 == 23
replace State = "GUJARAT" if state_code11 == 24
replace State = "MAHARASHTRA" if state_code11 == 27
replace State = "ANDHRA PRADESH" if state_code11 == 28
replace State = "KARNATAKA" if state_code11 == 29
replace State = "KERALA" if state_code11 == 32
replace State = "TAMIL NADU" if state_code11 == 33
replace State = "TELANGANA" if state_code11 == 36


*creating a district variable where we are doing trimming and changing in upper case
gen District = upper(trim(district_name))


*droping all the UNNECESSARY states.. all missing state names are for those districts for whom we don't care
drop if State==""



************* Assigning  district code using the mapping file created by us *************

run "$common_path\Supporting Files\district_codes_mapping_file 09112017.do"

*labelling variables

label var district_code "NSS 61 normalized codes from our district mapping file"

count if district_code == . 

rename state_code11 state_code_primitive_insti_data
rename district_name district_name_primit_insti_data
rename district district_primitive_insti_data
rename _merge merge_primitive_insti_data


*renaming original state and district varaibles

rename State State_insti_data
rename District District_insti_data



********* Doing reclink merge with NSS 71 round districts which carry NSS 61 normalized codes *************


*generating state_district key

gen State_district_key_insti_data = State_insti_data + "_"+ District_insti_data
label var State_district_key_insti_data "key contains original Institute Data state-district combination" 


*renaming insti data state-district key suitable for reclink so that we can get district codes for these strings
rename State_district_key_insti_data State_district_key_68_71 

*generating a unique identifier for each obsercvation since reclink demands it
gen insti_data_unique_id = _n


*merging the NSS 71 round data consisting NSS 61 codes

global NSS_71_normalized_data "$common_path\NSS Data\NSS 71\Step 2\nss_71_district_code_remaped_dataset_07112017_1642.dta" 

reclink State_district_key_68_71 using "$NSS_71_normalized_data", idmaster(insti_data_unique_id) idusing(State_district_code) gen(match_score_insti_data_NSS71) uprefix("NSS_71_") 



*labeling variable

label var match_score_insti_data_NSS71 "reclink matching score of institute Data & NSS 71 dataset"
label var insti_data_unique_id "created for sake of using reclink"

*relabelling wrong tagging
label var State_district_FINAL_code_71 "IMP variable: codes normalized to 61st round obtained from NSS 71st round"


*restoring name of original institutional state and district combination
rename State_district_key_68_71 State_district_key_insti_data




*************** DOING SOME DATA GROOMING ***************

*reclink: dropping UNWANTED variables brought with (using) dataset while doing reclink
drop State_district_code old_State_code_71 old_State_71 old_District_71 old_District_code_71 State_code_71 District_code_71 State_district_code_string_71 State_71 District_71 UState_district_key_68_71 match_score State_district_primitive_code_68 State_code_68 District_code_68 old_District_68 State_68 tag_string District_68 State_district_code_string State_district_FINAL_code_68 true_state_district_code_68 _merge_nss71_with_modify_68 true_primitive_nss_68_71 true_state_district_code_71

count if match_score_insti_data_NSS71!=1



*************** Comparing if codes from district mapping file and reclink district codes are matching ***************

gen true_NSS71_norm_insti_data = 0
replace true_NSS71_norm_insti_data= 1 if State_district_FINAL_code_71 == district_code


*# districts which couldn't be mapped using district code mapping file 
count if district_code==.

*# missing district codes which cannot be EXACTLY mapped using reclink
count if district_code==. & match_score_insti_data_NSS71!=1


*labelling important variables
label var true_NSS71_norm_insti_data "checking NSS71 normalzed codes with district code mapping file"


*************** re-assigning districts with missing district codes and recklink score NOT equal to one ***************

gen district_code_FINAL_insti_data = district_code
replace district_code_FINAL_insti_data = State_district_FINAL_code_71 if district_code==.

label var district_code_FINAL_insti_data "IMP: final district codes for institutional data"
	
*correct for Sonapur/Sonepur/Subranpur Orissa
replace district_code_FINAL_insti_data = 2123 if State_insti_data =="ODISHA" & District_insti_data =="SUBARNAPUR"

*correct for Hathras UP
replace district_code_FINAL_insti_data = 913 if State_insti_data =="UTTAR PRADESH" & District_insti_data =="HATRAS"



count if district_code_FINAL_insti_data==.

*renaming IMP variables
rename  _merge _merge_NSS71_insti_data


*checking codes that came as endowment with insti dataset ..are they same as what we created 

gen true_endowment_NSS71 = 1 if district_primitive_insti_data == district_code_FINAL_insti_data
replace true_endowment_NSS71 = 0 if district_primitive_insti_data != district_code_FINAL_insti_data
count if true_endowment_NSS71 == 0
 
label var true_endowment_NSS71 "checking if our district codes match with original instituional datset"
 

***** running program for re-mapping as per district groups 

*please make input for the old variable which has information about district codes

global old_dist_code_var "district_code_FINAL_insti_data"

program_replace_dist_code $old_dist_code_var



* Correcting for South District of Sikkim & Central Delhi

drop if district_name_primit_insti_data=="South District"  //this varable has district_code as 1100 which corresponds to Sikkim ..thus we are dropping it
*we have already correctly mapped district_name_primit_insti_data=="Central" to that as that of Delhi and things are fine.. we already defined state name as Delhi in the first place thus we are good with it



** looking for duplicates
duplicates tag dist_code_after_group , gen(dist_dup)
list district_name_primit_insti_data dist_code_after_group if dist_dup!=0
drop dist_dup


*** creating # colleges and universities after district grouping

forvalues year = 1961/2011 { 

    bysort dist_code_after_group: egen col_dist_grp_`year' = total(col_`year')
}
*

forvalues year = 1961/2011 { 

    bysort dist_code_after_group: egen uni_dist_grp_`year' = total(uni_`year')
}
*


*droping original/old..... year wise college and university variables
forvalues year = 1961/2011 { 

    drop col_`year'
	drop uni_`year'
}
*

*drop variables which are not necessary.. variables from original institution dataset, reclink data etc
drop state_code_primitive_insti_data district_primitive_insti_data type_id merge_primitive_insti_data District_insti_data district_code State_district_key_insti_data NSS_71_State_district_key_68_71 insti_data_unique_id match_score_insti_data_NSS71 State_district_FINAL_code_71 _merge_NSS71_insti_data true_NSS71_norm_insti_data true_endowment_NSS71



****Number of educational institutions***
forvalues i = 1985(1)2011{

gen inst_`i' = uni_dist_grp_`i' + col_dist_grp_`i'

label var inst_`i' "#higher edu. insti. present in year `i' in the district group" 

}
*


/*We also find the average number of institutes  district wise by arguing that we don’t know when a person entered the higher 
education cohort hence we will just find the average number of institutes present in each district in each year whenever a 
person was about to enter the education cohort.
*/

****Averages for each 9-year period (when each individual in the treatment and control groups was 17-25)********

forvalues i = 1985(1)2003{

			local k1 = `i' + 1
			local k2 = `i' + 2
			local k3 = `i' + 3
			local k4 = `i' + 4
			local k5 = `i' + 5
			local k6 = `i' + 6
			local k7 = `i' + 7
			local k8 = `i' + 8
			
			gen avg_inst_`i' = (inst_`k1'+inst_`k2'+inst_`k3'+inst_`k4'+inst_`k5'+inst_`k6'+inst_`k7'+inst_`k8'+inst_`i')/9
			
			label var avg_inst_`i' "average number of higher edu insti. present in `i' for a district group" 
}
*

***since institutions data is available only till 2011
gen avg_inst_2004= (inst_2004+ inst_2005+inst_2006+inst_2007+inst_2008+inst_2009+inst_2010+inst_2011)/8
gen avg_inst_2005= (inst_2005+inst_2006+inst_2007+inst_2008+inst_2009+inst_2010+inst_2011)/7

label var avg_inst_2004 "average number of higher edu insti. present in 2004 for a district group" 
label var avg_inst_2005 "average number of higher edu insti. present in 2005 for a district group" 



*IMP: dropping duplicate districts arising due to group formation

duplicates report dist_code_after_group

duplicates drop dist_code_after_group, force
duplicates report dist_code_after_group

*keep these important variables

*br State_insti_data district_name_primit_insti_data inst_1985 inst_1986 inst_1987 inst_1988 inst_1989 inst_1990 inst_1991 inst_1992 inst_1993 inst_1994 inst_1995 inst_1996 inst_1997 inst_1998 inst_1999 inst_2000 inst_2001 inst_2002 inst_2003 inst_2004 inst_2005 inst_2006 inst_2007 inst_2008 inst_2009 inst_2010 inst_2011 avg_inst_1985 avg_inst_1986 avg_inst_1987 avg_inst_1988 avg_inst_1989 avg_inst_1990 avg_inst_1991 avg_inst_1992 avg_inst_1993 avg_inst_1994 avg_inst_1995 avg_inst_1996 avg_inst_1997 avg_inst_1998 avg_inst_1999 avg_inst_2000 avg_inst_2001 avg_inst_2002 avg_inst_2003 avg_inst_2004 avg_inst_2005


save "$common_path\Independent variables\Institution Dataset\Processed Data\Higher educational institute dataset 27032018.dta", replace
clear



/*

*Code to compare 2 created datasets

set more off
global file_prior_consolidation "C:\Users\abc\Dropbox\Education Loan Project\Independent variables\Institution Dataset\Higher educational institute dataset 27032018.dta"
global file_post_consolidation  "C:\Users\abc\Dropbox\Education Loan Project\Independent variables\Institution Dataset\Processed Data\Higher educational institute dataset 27032018.dta"

use "$file_post_consolidation", clear
cf _all using "$file_prior_consolidation", verbose all 
clear

*/



											************************************
											******* END OF LAST DATASET ********
											************************************









*********************************************************************************************************************************
*********************************** EDUCATION LOAN DATASET ********************************************************************
*********************************************************************************************************************************

/*

*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"

*/



forvalues i = 2001/2011 {

		set more off
		
		/*Note in this loop we make use of looping index varaible (i) for defining global variables : "year_loan" and "loan_data_year"
		A local varaible "year" is also defined using (i). This is done just for coding purpose, one can also use (i) in place of all these 3 variables */ 
		
		global loan_data_year `i'


		if $loan_data_year==2011 import excel using "$common_path\Independent variables\Education Loan Dataset\Raw Data\edu_loan_11.xlsx", firstrow

		if $loan_data_year!=2011 import excel using "$common_path\Independent variables\Education Loan Dataset\Raw Data\edu_loan.xlsx", sheet("$loan_data_year") firstrow




		**error spotted for 2011
		**rename EducationLoanasonMarch31a State  //made correction to variable name

		capture rename EducationLoanasonMarch31as State  //for year 2001-2010
		capture rename EducationLoanasonMarch31a State  //for year 2011... made correction to variable name... this is done specifically for year 2011 

		if $loan_data_year !=2003 rename B District

		if $loan_data_year !=2003 rename E account
		if $loan_data_year ==2003 rename NoofAccount account 

		if $loan_data_year !=2003 rename In000 amount 
		if $loan_data_year ==2003 rename AmountOutstanding amount 

		if $loan_data_year !=2003 rename C Sector 
		if $loan_data_year ==2003 rename Population Sector 

		if $loan_data_year !=2003 rename D Bank_Type 
		if $loan_data_year ==2003 rename Bank_group Bank_Type 


		drop in 1 if $loan_data_year !=2003

		destring amount account, replace


		gen sec_bank_type = Sector+ " " + Bank_Type
		tab sec_bank_type


		//dropping missing values
		gen xy=_n if $loan_data_year !=2003
		drop if _n==_N & $loan_data_year !=2003
		capture drop xy 

		 

		*this will vary form year to year
		distinct sec_bank_type 


		//defining marker for each sec_bank_type

		sort sec_bank_type, stable
		by sec_bank_type: gen counter = _n if _n==1

		gen marker = 0 
		replace marker = 1 if sec_bank_type=="METROPOLITAN FOREIGN BANKS"
		replace marker = 2 if sec_bank_type=="METROPOLITAN NATIONALISED BANKS"
		replace marker = 3 if sec_bank_type=="METROPOLITAN PRIVATE SECTOR BANKS"
		replace marker = 4 if sec_bank_type=="METROPOLITAN REGIONAL RURAL BANKS"
		replace marker = 5 if sec_bank_type=="METROPOLITAN STATE BANK OF INDIA AND ITS ASSOCIATES"

		replace marker = 6 if sec_bank_type=="RURAL NATIONALISED BANKS"
		replace marker = 7 if sec_bank_type=="RURAL PRIVATE SECTOR BANKS"
		replace marker = 8 if sec_bank_type=="RURAL REGIONAL RURAL BANKS"
		replace marker = 9 if sec_bank_type=="RURAL STATE BANK OF INDIA AND ITS ASSOCIATES"

		replace marker = 10 if sec_bank_type=="SEMI-URBAN NATIONALISED BANKS"
		replace marker = 11 if sec_bank_type=="SEMI-URBAN PRIVATE SECTOR BANKS"
		replace marker = 12 if sec_bank_type=="SEMI-URBAN REGIONAL RURAL BANKS"
		replace marker = 13 if sec_bank_type=="SEMI-URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"

		*adding 19th marker since in 2001 and 2002 year files we have Semi-urban Foreign bank type for Darjeeling @West bengal, but its not a problem with other years
		replace marker = 19 if sec_bank_type=="SEMI-URBAN FOREIGN BANKS"

		replace marker = 14 if sec_bank_type=="URBAN FOREIGN BANKS"
		replace marker = 15 if sec_bank_type=="URBAN NATIONALISED BANKS"
		replace marker = 16 if sec_bank_type=="URBAN PRIVATE SECTOR BANKS"
		replace marker = 17 if sec_bank_type=="URBAN REGIONAL RURAL BANKS"
		replace marker = 18 if sec_bank_type=="URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"



		//information about codes assigned for each sector and bank type
		list Sector Bank_Type sec_bank_type marker if counter==1 , sepby(Sector)

		//checking if all sec_bank_types are mapped...

		*ideally answer should be ZERO
		list State District Sector Bank_Type marker if marker == 0 


		//reshaping long form to wide form of data
		sort State District, stable

		drop Sector Bank_Type sec_bank_type counter

		reshape wide account amount, i(State District) j(marker)


		//finding sum of accounts and amounts across all districts

		egen total_loan_account_district = rowtotal(account*)  // sum of #accounts across all districts
		egen total_loan_amount_district = rowtotal(amount*)

		label var total_loan_account_district "Total # loans in a district"
		label var total_loan_amount_district "Total value of loans in district"




		* labelling 19 account variables [ 18+ 1 (it was added latter) ]				
		* by writing capture I can hold the error to stop my code

		capture label var account1 "METROPOLITAN FOREIGN BANKS"
		capture label var account2 "METROPOLITAN NATIONALISED BANKS"
		capture label var account3 "METROPOLITAN PRIVATE SECTOR BANKS"
		capture label var account4 "METROPOLITAN REGIONAL RURAL BANKS"
		capture label var account5 "METROPOLITAN STATE BANK OF INDIA AND ITS ASSOCIATES"

		capture label var account6 "RURAL NATIONALISED BANKS"
		capture label var account7 "RURAL PRIVATE SECTOR BANKS"
		capture label var account8 "RURAL REGIONAL RURAL BANKS"
		capture label var account9 "RURAL STATE BANK OF INDIA AND ITS ASSOCIATES"

		capture label var account10 "SEMI-URBAN NATIONALISED BANKS"
		capture label var account11 "SEMI-URBAN PRIVATE SECTOR BANKS"
		capture label var account12 "SEMI-URBAN REGIONAL RURAL BANKS"
		capture label var account13 "SEMI-URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"


		capture label var account14 "URBAN FOREIGN BANKS"
		capture label var account15 "URBAN NATIONALISED BANKS"
		capture label var account16 "URBAN PRIVATE SECTOR BANKS"
		capture label var account17 "URBAN REGIONAL RURAL BANKS"
		capture label var account18 "URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"

		*adding 19th marker since in 2001 and 2002 year files we have Semi-urban Foreign bank type for Darjeeling @West bengal, but its not a problem with other years
		capture label var account19 "SEMI-URBAN FOREIGN BANKS"





		* labelling 19 amount variables 

		capture label var amount1 "METROPOLITAN FOREIGN BANKS"
		capture label var amount2 "METROPOLITAN NATIONALISED BANKS"
		capture label var amount3 "METROPOLITAN PRIVATE SECTOR BANKS"
		capture label var amount4 "METROPOLITAN REGIONAL RURAL BANKS"
		capture label var amount5 "METROPOLITAN STATE BANK OF INDIA AND ITS ASSOCIATES"

		capture label var amount6 "RURAL NATIONALISED BANKS"
		capture label var amount7 "RURAL PRIVATE SECTOR BANKS"
		capture label var amount8 "RURAL REGIONAL RURAL BANKS"
		capture label var amount9 "RURAL STATE BANK OF INDIA AND ITS ASSOCIATES"

		capture label var amount10 "SEMI-URBAN NATIONALISED BANKS"
		capture label var amount11 "SEMI-URBAN PRIVATE SECTOR BANKS"
		capture label var amount12 "SEMI-URBAN REGIONAL RURAL BANKS"
		capture label var amount13 "SEMI-URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"


		capture label var amount14 "URBAN FOREIGN BANKS"
		capture label var amount15 "URBAN NATIONALISED BANKS"
		capture label var amount16 "URBAN PRIVATE SECTOR BANKS"
		capture label var amount17 "URBAN REGIONAL RURAL BANKS"
		capture label var amount18 "URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"

		*adding 19th marker since in 2001 and 2002 year files we have Semi-urban Foreign bank type for Darjeeling @West bengal, but its not a problem with other years
		capture label var amount19 "SEMI-URBAN FOREIGN BANKS"



		****creating loan_year.dta files where we are mapping district codes and renaming key variables****


		global year_loan `i'
		
		
		display "for year $year_loan"
		display "number of rows BEFORE dropping unwanted states"
		display _N
		
		*running state_drop.do code to drop unwanted states
		run "$common_path\Supporting Files\statedrop modified 15122017.do"
		
		display "number of rows AFTER dropping unwanted states"
		display _N
		
			
		*running district mapping file created after normalization as per NSS-61 round
		run "$common_path\Supporting Files\district_codes_mapping_file 09112017.do"
		
		*summing values for all 19 account and 19 amount variables across all district codes 
		
		forvalues h=1/19{
		
			capture bysort district_code: egen account_new_`h'_`i'= total(account`h')
			capture bysort district_code: egen amount_new_`h'_`i'= total(amount`h')
		
		
		}
		*
		
		*Summing values of total_account and total_amount variables across all district codes
		*else we CANNNOT merge on district codes
		
		bysort district_code: egen total_new_account_`i'= total(total_loan_account_district)
		bysort district_code: egen total_new_amount_`i'= total(total_loan_amount_district)
		
		
		
		*renaming variables as per Senjuti's code requirement
				
		capture rename State State_`i'
		capture rename District District_`i'
		
		capture rename account1 account1_`i'
		capture rename amount1 amount1_`i'
		capture rename account2 account2_`i'
		capture rename amount2 amount2_`i'
		capture rename account3 account3_`i'
		capture rename amount3 amount3_`i'
		capture rename account4 account4_`i'
		capture rename amount4 amount4_`i'
		capture rename account5 account5_`i'
		capture rename amount5 amount5_`i'
		capture rename account6 account6_`i'
		capture rename amount6 amount6_`i'
		capture rename account7 account7_`i'
		capture rename amount7 amount7_`i'
		capture rename account8 account8_`i'
		capture rename amount8 amount8_`i'
		capture rename account9 account9_`i'
		capture rename amount9 amount9_`i'
		capture rename account10 account10_`i'
		capture rename amount10 amount10_`i'
		capture rename account11 account11_`i'
		capture rename amount11 amount11_`i'
		capture rename account12 account12_`i'
		capture rename amount12 amount12_`i'
		capture rename account13 account13_`i'
		capture rename amount13 amount13_`i'
		capture rename account14 account14_`i'
		capture rename amount14 amount14_`i'
		capture rename account15 account15_`i'
		capture rename amount15 amount15_`i'
		capture rename account16 account16_`i'
		capture rename amount16 amount16_`i'
		capture rename account17 account17_`i'
		capture rename amount17 amount17_`i'
		capture rename account18 account18_`i'
		capture rename amount18 amount18_`i'
		capture rename account19 account19_`i'
		capture rename amount19 amount19_`i'
		
		capture rename gh1 gh1_`i'
		capture rename gh2 gh2_`i'

		capture rename total_loan_account_district total_account_`i'
		capture rename total_loan_amount_district total_amount_`i'
		
		
		
		*dropping old account and amount variables since they are of NO USE
		*one can always COMMENT it out if its NOT required
		
		capture drop gh1_`i' gh2_`i' 
		
		drop total_account_`i' total_amount_`i'
		
		forvalues g=1/19{
				capture drop account`g'_`i'
				capture drop amount`g'_`i'
				
		}		
		*
		
		
		
		*need to drop districts which are duplicates else we CANNNOT merge on district codes
		
		duplicates tag district_code , generate(tag_dup_district_code_`i')
		tab tag_dup_district_code_`i', mi
		
		duplicates drop district_code, force
		
		
		
		*counting missing values for district_code across Loan 2001-2011 datasets
		
		quietly count if district_code==.
		display "#missing values for district mapping for year $year_loan"
		display r(N)		
		
		
		
		
		********* IMPORTANT: please make input for the old variable which has information about district codes  *********

		global old_dist_code_var "district_code"

			
		*running the program which has codes for all the district groups that we have formed
		program_replace_dist_code $old_dist_code_var


		*Loking for missing district codes
		count if district_code==.
		count if dist_code_after_group==.
	
		*defined for coding purpose
		local year `i'
		
		*creating 19 account and 19 amount varaibles as per BANK-SECTOR type
		
		forvalues h=1/19{
		
			capture bysort dist_code_after_group: egen account_dist_grp_`h'_`year'= total(account_new_`h'_`year')
			capture bysort dist_code_after_group: egen amount_dist_grp_`h'_`year'= total(amount_new_`h'_`year')
				
		}
		
		
		//finding sum of accounts and amounts across newly formed district groups

		egen total_loan_account_dist_grp_`year' = rowtotal(account_dist_grp*)  // sum of all variables starting with <<account_dist_grp..>>>> of a particular district
		egen total_loan_amount_dist_grp_`year' = rowtotal(amount_dist_grp*)    // sum of all variables starting with <<amount_dist_grp..>>>> of a particular district

		
		***need to drop old variables
		
		drop tag_dup_district_code_`year'
		drop total_new_account_`year'
		drop total_new_amount_`year'
		
		forvalues h=1/19{
		
			capture drop account_new_`h'_`year'                
			capture drop amount_new_`h'_`year'                
				
		}
		*		
		
		* labelling 19 account variables as to which type of bank type they stand for [ 18+ 1 (it was added latter) ]				
		
		* by writing capture I can hold the error to stop my code..since all bank types are not present in all year loan datasets
		
		*adding 19th marker since in 2001 and 2002 year files we have Semi-urban Foreign bank type for Darjeeling @West bengal, but its not a problem with other years
		
		capture label var account_dist_grp_1_`year' "METROPOLITAN FOREIGN BANKS"
		capture label var account_dist_grp_2_`year' "METROPOLITAN NATIONALISED BANKS"
		capture label var account_dist_grp_3_`year' "METROPOLITAN PRIVATE SECTOR BANKS"
		capture label var account_dist_grp_4_`year' "METROPOLITAN REGIONAL RURAL BANKS"
		capture label var account_dist_grp_5_`year' "METROPOLITAN STATE BANK OF INDIA AND ITS ASSOCIATES"
		capture label var account_dist_grp_6_`year' "RURAL NATIONALISED BANKS"
		capture label var account_dist_grp_7_`year' "RURAL PRIVATE SECTOR BANKS"
		capture label var account_dist_grp_8_`year' "RURAL REGIONAL RURAL BANKS"
		capture label var account_dist_grp_9_`year' "RURAL STATE BANK OF INDIA AND ITS ASSOCIATES"
		capture label var account_dist_grp_10_`year' "SEMI-URBAN NATIONALISED BANKS"
		capture label var account_dist_grp_11_`year' "SEMI-URBAN PRIVATE SECTOR BANKS"
		capture label var account_dist_grp_12_`year' "SEMI-URBAN REGIONAL RURAL BANKS"
		capture label var account_dist_grp_13_`year' "SEMI-URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"
		capture label var account_dist_grp_14_`year' "URBAN FOREIGN BANKS"
		capture label var account_dist_grp_15_`year' "URBAN NATIONALISED BANKS"
		capture label var account_dist_grp_16_`year' "URBAN PRIVATE SECTOR BANKS"
		capture label var account_dist_grp_17_`year' "URBAN REGIONAL RURAL BANKS"
		capture label var account_dist_grp_18_`year' "URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"
		capture label var account_dist_grp_19_`year' "SEMI-URBAN FOREIGN BANKS"

		
		* labelling 19 amount variables 

		capture label var amount_dist_grp_1_`year' "METROPOLITAN FOREIGN BANKS"
		capture label var amount_dist_grp_2_`year' "METROPOLITAN NATIONALISED BANKS"
		capture label var amount_dist_grp_3_`year' "METROPOLITAN PRIVATE SECTOR BANKS"
		capture label var amount_dist_grp_4_`year' "METROPOLITAN REGIONAL RURAL BANKS"
		capture label var amount_dist_grp_5_`year' "METROPOLITAN STATE BANK OF INDIA AND ITS ASSOCIATES"
		capture label var amount_dist_grp_6_`year' "RURAL NATIONALISED BANKS"
		capture label var amount_dist_grp_7_`year' "RURAL PRIVATE SECTOR BANKS"
		capture label var amount_dist_grp_8_`year' "RURAL REGIONAL RURAL BANKS"
		capture label var amount_dist_grp_9_`year' "RURAL STATE BANK OF INDIA AND ITS ASSOCIATES"
		capture label var amount_dist_grp_10_`year' "SEMI-URBAN NATIONALISED BANKS"
		capture label var amount_dist_grp_11_`year' "SEMI-URBAN PRIVATE SECTOR BANKS"
		capture label var amount_dist_grp_12_`year' "SEMI-URBAN REGIONAL RURAL BANKS"
		capture label var amount_dist_grp_13_`year' "SEMI-URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"
		capture label var amount_dist_grp_14_`year' "URBAN FOREIGN BANKS"
		capture label var amount_dist_grp_15_`year' "URBAN NATIONALISED BANKS"
		capture label var amount_dist_grp_16_`year' "URBAN PRIVATE SECTOR BANKS"
		capture label var amount_dist_grp_17_`year' "URBAN REGIONAL RURAL BANKS"
		capture label var amount_dist_grp_18_`year' "URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"
		capture label var amount_dist_grp_19_`year' "SEMI-URBAN FOREIGN BANKS"
		
		
		*dropping duplicate district codes which arose due to formation of groups
		duplicates drop dist_code_after_group, force
	 
	 
		*saving the new year dataset
		save "$common_path\Independent variables\Education Loan Dataset\Processed Data\Loan Year Dataset\loan$year_loan.dta", replace
		
		clear
				
		
}		
//
	
	
	
/*Code to compare 2 created datasets... in new dataset we have 2 extra varaibles.. else all other data values are same

global file_prior_consolidation "C:\Users\abc\Dropbox\Education Loan Project\Independent variables\Education Loan Dataset\Raw data processing\Loan Year Dataset\Before consolidation\loan2011.dta"
global file_post_consolidation  "C:\Users\abc\Dropbox\Education Loan Project\Independent variables\Education Loan Dataset\Raw data processing\Loan Year Dataset\loan2011.dta"

use "$file_post_consolidation", clear
cf _all using "$file_prior_consolidation", verbose all 
clear

*/




****** Step 2: Creating eduloan 2004, 2009 and 2011 dataset ******


foreach NSS_year in "2004" "2009" "2011" {


set more off

global t_NSS `NSS_year'

display ""
display $t_NSS
display ""

global t_3 = $t_NSS -3
global t_4 = $t_NSS -4
global t_5 = $t_NSS -5

display $t_3
display $t_4
display $t_5


*defining path names of all t-3, t-4 and t-5 datasets

global loan_t_NSS "$common_path\Independent variables\Education Loan Dataset\Processed Data\Loan Year Dataset\loan$t_NSS.dta"
global loan_t_3 "$common_path\Independent variables\Education Loan Dataset\Processed Data\Loan Year Dataset\loan$t_3.dta"
global loan_t_4 "$common_path\Independent variables\Education Loan Dataset\Processed Data\Loan Year Dataset\loan$t_4.dta"
global loan_t_5 "$common_path\Independent variables\Education Loan Dataset\Processed Data\Loan Year Dataset\loan$t_5.dta"


************************ loading NSS data ************************

*loading NSS year as Master dataset
use "$loan_t_NSS", clear



************************ merging t-3 data ************************


*merging t-3 data
merge 1:1 dist_code_after_group using "$loan_t_3"

display "data set for NSS year $t_NSS"
display ""
display "merging with $t_3"

*replacing MISSING LOAN data for previous year

tab total_loan_account_dist_grp_$t_3 _merge 	if _merge!=3, mi
tab total_loan_amount_dist_grp_$t_3  _merge   if _merge!=3, mi

list State_$t_NSS District_$t_NSS   total_loan_account_dist_grp_$t_3   total_loan_amount_dist_grp_$t_3   _merge if _merge!=3 


/*assigning ZERO values to all the MISSING t-3 year loan amount and account values
BUT only for case when data is present in Master dataset.  Else while taking difference missing values are generated
*/

replace total_loan_account_dist_grp_$t_3 = 0 if _merge==1
replace total_loan_amount_dist_grp_$t_3 = 0  if _merge==1

list State_$t_NSS District_$t_NSS   total_loan_account_dist_grp_$t_3   total_loan_amount_dist_grp_$t_3   _merge if _merge!=3 



*generating time-lagged variables

gen diff_account_ALL_t_3_$t_NSS = total_loan_account_dist_grp_$t_NSS - total_loan_account_dist_grp_$t_3
gen diff_amount_ALL_t_3_$t_NSS = total_loan_amount_dist_grp_$t_NSS - total_loan_amount_dist_grp_$t_3

*br total_loan_account_dist_grp_2009 total_loan_amount_dist_grp_2009 total_loan_account_dist_grp_2006 total_loan_amount_dist_grp_2006 diff_account_ALL_t_3 diff_amount_ALL_t_3 if _merge!=3


*generate time lagged account and amount variables from LOAN YEAR DATASETS (account and amount variables)

forvalues k=1/19 {

			/*assigning ZERO values to all the MISSING t-3 year loan amount and account values
			 BUT only for case when data is present in Master dataset.  Else while taking difference missing values are generated
			*/
			capture replace account_dist_grp_`k'_$t_3 =0 if _merge==1     
			capture replace amount_dist_grp_`k'_$t_3 =0 if _merge==1     
			
			*generate time lagged account and amount variables from LOAN YEAR DATASETS (account and amount variables)
			
			capture gen diff_account_type_`k'_t_3_$t_NSS = account_dist_grp_`k'_$t_NSS - account_dist_grp_`k'_$t_3
			capture gen diff_amount_type_`k'_t_3_$t_NSS = amount_dist_grp_`k'_$t_NSS - amount_dist_grp_`k'_$t_3  

}
//


rename _merge _merge_with_$t_3





************************merging t-4 data ************************

*merging t-4 and t-5 data only for 2009 and 2011 since 2000 and 1999 loan data not available

if $t_NSS != 2004 {


		*merging t-4 data with combined data of NSS year and t-3 year
		merge 1:1 dist_code_after_group using "$loan_t_4"


		display "data set for NSS year $t_NSS"
		display ""
		display "merging with $t_4"


		*replacing MISSING LOAN data for t-4 year

		tab total_loan_account_dist_grp_$t_4 _merge 	if _merge!=3, mi
		tab total_loan_amount_dist_grp_$t_4  _merge   if _merge!=3, mi

		list State_$t_NSS District_$t_NSS   total_loan_account_dist_grp_$t_4   total_loan_amount_dist_grp_$t_4   _merge if _merge!=3 


		/*assigning ZERO values to all the MISSING t-4 year loan amount and account values
		BUT only for case when data is present in Master dataset.  Else while taking difference missing values are generated
		*/

		replace total_loan_account_dist_grp_$t_4 = 0 if _merge==1
		replace total_loan_amount_dist_grp_$t_4 = 0  if _merge==1

		list State_$t_NSS District_$t_NSS   total_loan_account_dist_grp_$t_4   total_loan_amount_dist_grp_$t_4   _merge if _merge!=3



		*generating time-lagged variables

		gen diff_account_ALL_t_4_$t_NSS = total_loan_account_dist_grp_$t_NSS - total_loan_account_dist_grp_$t_4
		gen diff_amount_ALL_t_4_$t_NSS = total_loan_amount_dist_grp_$t_NSS - total_loan_amount_dist_grp_$t_4

		*br total_loan_account_dist_grp_2009 total_loan_amount_dist_grp_2009 total_loan_account_dist_grp_2006 total_loan_amount_dist_grp_2006 diff_account_ALL_t_3 diff_amount_ALL_t_3 if _merge!=3


		*generate time lagged account and amount variables from LOAN YEAR DATASETS (account and amount variables)

		forvalues k=1/19 {

					/*assigning ZERO values to all the MISSING t-4 year loan amount and account values
					 BUT only for case when data is present in Master dataset.  Else while taking difference missing values are generated
					*/
					capture replace account_dist_grp_`k'_$t_4 =0 if _merge==1     
					capture replace amount_dist_grp_`k'_$t_4 =0 if _merge==1     
					
					*generate time lagged account and amount variables from LOAN YEAR DATASETS (account and amount variables)
					
					capture gen diff_account_type_`k'_t_4_$t_NSS = account_dist_grp_`k'_$t_NSS - account_dist_grp_`k'_$t_4
					capture gen diff_amount_type_`k'_t_4_$t_NSS = amount_dist_grp_`k'_$t_NSS - amount_dist_grp_`k'_$t_4  

		}
		//


		rename _merge _merge_with_$t_4





		************************merging t-5 data ************************

		*merging t-5 data with combined data of NSS year, t-3 year and t-4 year
		merge 1:1 dist_code_after_group using "$loan_t_5"


		display "data set for NSS year $t_NSS"
		display ""
		display "merging with $t_5"



		*replacing MISSING LOAN data for t-5 year

		tab total_loan_account_dist_grp_$t_5 _merge 	if _merge!=3, mi
		tab total_loan_amount_dist_grp_$t_5  _merge   if _merge!=3, mi

		list State_$t_NSS District_$t_NSS   total_loan_account_dist_grp_$t_5   total_loan_amount_dist_grp_$t_5   _merge if _merge!=3 


		/*assigning ZERO values to all the MISSING t-5 year loan amount and account values
		BUT only for case when data is present in Master dataset.  Else while taking difference missing values are generated
		*/

		replace total_loan_account_dist_grp_$t_5 = 0 if _merge==1
		replace total_loan_amount_dist_grp_$t_5 = 0  if _merge==1

		list State_$t_NSS District_$t_NSS   total_loan_account_dist_grp_$t_5   total_loan_amount_dist_grp_$t_5   _merge if _merge!=3



		*generating time-lagged variables

		gen diff_account_ALL_t_5_$t_NSS = total_loan_account_dist_grp_$t_NSS - total_loan_account_dist_grp_$t_5
		gen diff_amount_ALL_t_5_$t_NSS = total_loan_amount_dist_grp_$t_NSS - total_loan_amount_dist_grp_$t_5

		*br total_loan_account_dist_grp_2009 total_loan_amount_dist_grp_2009 total_loan_account_dist_grp_2006 total_loan_amount_dist_grp_2006 diff_account_ALL_t_3 diff_amount_ALL_t_3 if _merge!=3


		*generate time lagged account and amount variables from LOAN YEAR DATASETS (account and amount variables)

		forvalues k=1/19 {

					/*assigning ZERO values to all the MISSING t-5 year loan amount and account values
					 BUT only for case when data is present in Master dataset.  Else while taking difference missing values are generated
					*/
					capture replace account_dist_grp_`k'_$t_5 =0 if _merge==1     
					capture replace amount_dist_grp_`k'_$t_5 =0 if _merge==1     
					
					*generate time lagged account and amount variables from LOAN YEAR DATASETS (account and amount variables)
					
					capture gen diff_account_type_`k'_t_5_$t_NSS = account_dist_grp_`k'_$t_NSS - account_dist_grp_`k'_$t_5
					capture gen diff_amount_type_`k'_t_5_$t_NSS = amount_dist_grp_`k'_$t_NSS - amount_dist_grp_`k'_$t_5  

		}
		//


		rename _merge _merge_with_$t_5

}
*


*labelling t-3, t-4 , t-5 lag variables for finding difference loans between NSS year and previous years..sector and bank wise


foreach diff_year in "t_3" "t_4" "t_5" {

						
			*labelling all account variables giving us difference between loans across NSS year and t-3, t-4 and t-5 years

			capture label var diff_account_type_1_`diff_year'_$t_NSS "METROPOLITAN FOREIGN BANKS"
			capture label var diff_account_type_2_`diff_year'_$t_NSS "METROPOLITAN NATIONALISED BANKS"
			capture label var diff_account_type_3_`diff_year'_$t_NSS "METROPOLITAN PRIVATE SECTOR BANKS"
			capture label var diff_account_type_4_`diff_year'_$t_NSS "METROPOLITAN REGIONAL RURAL BANKS"
			capture label var diff_account_type_5_`diff_year'_$t_NSS "METROPOLITAN STATE BANK OF INDIA AND ITS ASSOCIATES"
			capture label var diff_account_type_6_`diff_year'_$t_NSS "RURAL NATIONALISED BANKS"
			capture label var diff_account_type_7_`diff_year'_$t_NSS "RURAL PRIVATE SECTOR BANKS"
			capture label var diff_account_type_8_`diff_year'_$t_NSS "RURAL REGIONAL RURAL BANKS"
			capture label var diff_account_type_9_`diff_year'_$t_NSS "RURAL STATE BANK OF INDIA AND ITS ASSOCIATES"
			capture label var diff_account_type_10_`diff_year'_$t_NSS "SEMI-URBAN NATIONALISED BANKS"
			capture label var diff_account_type_11_`diff_year'_$t_NSS "SEMI-URBAN PRIVATE SECTOR BANKS"
			capture label var diff_account_type_12_`diff_year'_$t_NSS "SEMI-URBAN REGIONAL RURAL BANKS"
			capture label var diff_account_type_13_`diff_year'_$t_NSS "SEMI-URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"
			capture label var diff_account_type_14_`diff_year'_$t_NSS "URBAN FOREIGN BANKS"
			capture label var diff_account_type_15_`diff_year'_$t_NSS "URBAN NATIONALISED BANKS"
			capture label var diff_account_type_16_`diff_year'_$t_NSS "URBAN PRIVATE SECTOR BANKS"
			capture label var diff_account_type_17_`diff_year'_$t_NSS "URBAN REGIONAL RURAL BANKS"
			capture label var diff_account_type_18_`diff_year'_$t_NSS "URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"
			capture label var diff_account_type_19_`diff_year'_$t_NSS "SEMI-URBAN FOREIGN BANKS"


			*labelling all amount variables giving us difference between loans across NSS year and t-3, t-4 and t-5 years 
			
			capture label var diff_amount_type_1_`diff_year'_$t_NSS "METROPOLITAN FOREIGN BANKS"
			capture label var diff_amount_type_2_`diff_year'_$t_NSS "METROPOLITAN NATIONALISED BANKS"
			capture label var diff_amount_type_3_`diff_year'_$t_NSS "METROPOLITAN PRIVATE SECTOR BANKS"
			capture label var diff_amount_type_4_`diff_year'_$t_NSS "METROPOLITAN REGIONAL RURAL BANKS"
			capture label var diff_amount_type_5_`diff_year'_$t_NSS "METROPOLITAN STATE BANK OF INDIA AND ITS ASSOCIATES"
			capture label var diff_amount_type_6_`diff_year'_$t_NSS "RURAL NATIONALISED BANKS"
			capture label var diff_amount_type_7_`diff_year'_$t_NSS "RURAL PRIVATE SECTOR BANKS"
			capture label var diff_amount_type_8_`diff_year'_$t_NSS "RURAL REGIONAL RURAL BANKS"
			capture label var diff_amount_type_9_`diff_year'_$t_NSS "RURAL STATE BANK OF INDIA AND ITS ASSOCIATES"
			capture label var diff_amount_type_10_`diff_year'_$t_NSS "SEMI-URBAN NATIONALISED BANKS"
			capture label var diff_amount_type_11_`diff_year'_$t_NSS "SEMI-URBAN PRIVATE SECTOR BANKS"
			capture label var diff_amount_type_12_`diff_year'_$t_NSS "SEMI-URBAN REGIONAL RURAL BANKS"
			capture label var diff_amount_type_13_`diff_year'_$t_NSS "SEMI-URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"
			capture label var diff_amount_type_14_`diff_year'_$t_NSS "URBAN FOREIGN BANKS"
			capture label var diff_amount_type_15_`diff_year'_$t_NSS "URBAN NATIONALISED BANKS"
			capture label var diff_amount_type_16_`diff_year'_$t_NSS "URBAN PRIVATE SECTOR BANKS"
			capture label var diff_amount_type_17_`diff_year'_$t_NSS "URBAN REGIONAL RURAL BANKS"
			capture label var diff_amount_type_18_`diff_year'_$t_NSS "URBAN STATE BANK OF INDIA AND ITS ASSOCIATES"
			capture label var diff_amount_type_19_`diff_year'_$t_NSS "SEMI-URBAN FOREIGN BANKS"


}
*

*saving the eduloan_NSS_year databse
save "$common_path\Independent variables\Education Loan Dataset\Processed Data\Eduloan 2004_2009_2011_Dataset\eduloan_$t_NSS.dta", replace

 
clear

}
*



*******appending datsets of eduloan 2004, 09 and 11 so that it can be merged with NSS specification 2 data

		
set more off

global edu_loans_data_04 "$common_path\Independent variables\Education Loan Dataset\Processed Data\Eduloan 2004_2009_2011_Dataset\eduloan_2004.dta"
global edu_loans_data_09 "$common_path\Independent variables\Education Loan Dataset\Processed Data\Eduloan 2004_2009_2011_Dataset\eduloan_2009.dta"
global edu_loans_data_11 "$common_path\Independent variables\Education Loan Dataset\Processed Data\Eduloan 2004_2009_2011_Dataset\eduloan_2011.dta"


append using "$edu_loans_data_04" "$edu_loans_data_09" "$edu_loans_data_11", generate(loan_year)


gen year_marker = 2004 if loan_year == 1
replace year_marker = 2009 if loan_year == 2
replace year_marker = 2011 if loan_year == 3


***** creating variables capturing info about # accounts

*single variable having info of total number of loans in each NSS year in a district

gen 	account_Total_NOT_BL = total_loan_account_dist_grp_2004 if year_marker == 2004
replace account_Total_NOT_BL = total_loan_account_dist_grp_2009 if year_marker == 2009
replace account_Total_NOT_BL = total_loan_account_dist_grp_2011 if year_marker == 2011

*refer to code line 77 for more info on total_loan_account_dist_grp_`year'
label var account_Total_NOT_BL "gives you total # accounts in NSS year across newly formed district groups"


*baseline consits of loan acoounts with difference of 4 years. But since we education loan data till 2011
*hence for year 2004..we take only t_3

*variables consiting edu_loans data as per our definition of #loans accounts created in a year in a district 

gen 	account_baseline = diff_account_ALL_t_3_2004 if year_marker == 2004
replace account_baseline = diff_account_ALL_t_4_2009 if year_marker == 2009
replace account_baseline = diff_account_ALL_t_4_2011 if year_marker == 2011

label var account_baseline "IMP: gives #accounts created as diff. btwn accounts in NSS_year and (NSS_year-4)"


gen 	account_baseline_lag3 = diff_account_ALL_t_3_2004 if year_marker == 2004
replace account_baseline_lag3 = diff_account_ALL_t_3_2009 if year_marker == 2009
replace account_baseline_lag3 = diff_account_ALL_t_3_2011 if year_marker == 2011

label var account_baseline_lag3 "gives #accounts created as diff. btwn accounts in NSS_year and (NSS_year-3)"


gen 	account_baseline_lag5 = diff_account_ALL_t_3_2004 if year_marker == 2004
replace account_baseline_lag5 = diff_account_ALL_t_5_2009 if year_marker == 2009
replace account_baseline_lag5 = diff_account_ALL_t_5_2011 if year_marker == 2011

label var account_baseline_lag5 "gives #accounts created as diff. btwn accounts in NSS_year and (NSS_year-5)"



***creating variables by bank type

*baseline consists of loan acoounts with difference of 4 years. But since education loan data is available till 2001
*hence for year 2004..we take only t_3

forvalues k=1/19 {

	set more off
	
	*variables consiting edu_loans data as per our definition of #loans accounts created in a year in a district 
	
	capture noisily gen 	account_type_`k'_baseline = 0
	capture noisily replace	account_type_`k'_baseline = diff_account_type_`k'_t_3_2004 if year_marker == 2004 
	capture noisily replace account_type_`k'_baseline = diff_account_type_`k'_t_4_2009 if year_marker == 2009 
	capture noisily replace account_type_`k'_baseline = diff_account_type_`k'_t_4_2011 if year_marker == 2011
	
	capture noisily label var account_type_`k'_baseline "#loans accounts by bank type(refer edu_loan.dta for more info)"
}
*



*********** creating #edu loans accounts in public banks as per our standard definition of NSS - t_4 year


***** creating 2004 variable 

global pub_bank_marker 2 4 5 6 8 9 10 12 13 15 17 18

gen public_bank_account_2004 = 0 

foreach k of global pub_bank_marker {

	capture noisily gen interim_loan_acct = 0
	
	capture noisily replace interim_loan_acct = diff_account_type_`k'_t_3_2004
	
	capture noisily replace public_bank_account_2004 = interim_loan_acct + public_bank_account_2004
	
	capture noisily drop interim_loan_acct
	
}
*
label var public_bank_account_2004 "info about # accounts created in 2004 and t-4 year"

*checking all variables formed
*br diff_account_type_2_t_3_2004 diff_account_type_5_t_3_2004 diff_account_type_6_t_3_2004 diff_account_type_8_t_3_2004 diff_account_type_9_t_3_2004 diff_account_type_10_t_3_2004 diff_account_type_12_t_3_2004 diff_account_type_13_t_3_2004 diff_account_type_15_t_3_2004 diff_account_type_17_t_3_2004 diff_account_type_18_t_3_2004 public_bank_account_2004


***** creating for 2009


gen public_bank_account_2009 = 0 

foreach k of global pub_bank_marker {

	capture noisily gen interim_loan_acct = 0
	
	capture noisily replace interim_loan_acct = diff_account_type_`k'_t_4_2009
	
	capture noisily replace public_bank_account_2009 = interim_loan_acct + public_bank_account_2009
	
	capture noisily drop interim_loan_acct
	
}
*

label var public_bank_account_2009 "info about # accounts created in 2009 and t-4 year"

*checking all variables formed
*br diff_account_type_2_t_4_2009 diff_account_type_4_t_4_2009 diff_account_type_5_t_4_2009 diff_account_type_6_t_4_2009 diff_account_type_8_t_4_2009 diff_account_type_9_t_4_2009 diff_account_type_10_t_4_2009 diff_account_type_12_t_4_2009 diff_account_type_13_t_4_2009 diff_account_type_15_t_4_2009 diff_account_type_17_t_4_2009 diff_account_type_18_t_4_2009 public_bank_account_2009 if year_marker == 2009


*****  creating for 2011

gen public_bank_account_2011 = 0 

foreach k of global pub_bank_marker {

	capture noisily gen interim_loan_acct = 0
	
	capture noisily replace interim_loan_acct = diff_account_type_`k'_t_4_2011
	
	capture noisily replace public_bank_account_2011 = interim_loan_acct + public_bank_account_2011
	
	capture noisily drop interim_loan_acct
	
}
*
label var public_bank_account_2011 "info about # accounts created in 2011 and t-4 year"

*br diff_account_type_2_t_4_2011 diff_account_type_4_t_4_2011 diff_account_type_5_t_4_2011 diff_account_type_6_t_4_2011 diff_account_type_8_t_4_2011 diff_account_type_9_t_4_2011 diff_account_type_10_t_4_2011 diff_account_type_12_t_4_2011 diff_account_type_13_t_4_2011 diff_account_type_15_t_4_2011 diff_account_type_17_t_4_2011 diff_account_type_18_t_4_2011 public_bank_account_2011 if year_marker == 2011


*creating common public bank education loan account variable

gen pub_account 	= public_bank_account_2004 if year_marker==2004 
replace pub_account = public_bank_account_2009 if year_marker==2009 
replace pub_account = public_bank_account_2011 if year_marker==2011 

label var pub_account "IMP: variable having info # public bank loan accounts created in NSS and t-4 year"

tab year_marker if pub_account < 0


*to see why so many negative accounts do this
sort year_marker dist_code_after_group

*br year_marker State_2004 District_2004 dist_code_after_group account_Total_NOT_BL total_loan_account_dist_grp_2001 account_baseline account_baseline_lag3 account_baseline_lag5


count if account_baseline <pub_account
*br year_marker dist_code_after_group account_baseline  pub_account  if account_baseline <pub_account



*labelling total loan account and amount variables

forvalues year_k = 2001/2011 {

capture noisily label var total_loan_account_dist_grp_`year_k' "# edu loan accounts across newly formed district groups"
capture noisily label var total_loan_amount_dist_grp_`year_k'  "amount of edu loan accounts across newly formed district groups"

}
*





*********** creating #edu loans accounts in RURAL-URBAN wise demarcation ***********




*********************************
**************RURAL**************
*********************************


***** creating 2004 variable 

global rural_bank_marker 6 7 8 9 

gen rural_bank_account_2004 = 0 

foreach k of global rural_bank_marker {

	capture noisily gen interim_loan_acct = 0
	
	capture noisily replace interim_loan_acct = diff_account_type_`k'_t_3_2004
	
	capture noisily replace rural_bank_account_2004 = interim_loan_acct + rural_bank_account_2004
	
	capture noisily drop interim_loan_acct
	
}
*
label var rural_bank_account_2004 "info about # rural bank loan accounts created between 2004 and t-3 year"


*checking all variables formed
*br diff_account_type_2_t_3_2004 diff_account_type_3_t_3_2004 diff_account_type_5_t_3_2004 diff_account_type_6_t_3_2004 diff_account_type_7_t_3_2004 diff_account_type_8_t_3_2004 diff_account_type_9_t_3_2004 diff_account_type_10_t_3_2004 diff_account_type_11_t_3_2004 diff_account_type_12_t_3_2004 diff_account_type_13_t_3_2004 diff_account_type_15_t_3_2004 diff_account_type_16_t_3_2004 diff_account_type_17_t_3_2004 diff_account_type_18_t_3_2004 rural_bank_account_2004



***** creating for 2009


gen rural_bank_account_2009 = 0 

foreach k of global rural_bank_marker {

	capture noisily gen interim_loan_acct = 0
	
	capture noisily replace interim_loan_acct = diff_account_type_`k'_t_4_2009
	
	capture noisily replace rural_bank_account_2009 = interim_loan_acct + rural_bank_account_2009
	
	capture noisily drop interim_loan_acct
	
}
*

label var rural_bank_account_2009 "info about # rural bank accounts created between 2009 and t-4 year"



*****  creating for 2011

gen rural_bank_account_2011 = 0 

foreach k of global rural_bank_marker {

	capture noisily gen interim_loan_acct = 0
	
	capture noisily replace interim_loan_acct = diff_account_type_`k'_t_4_2011
	
	capture noisily replace rural_bank_account_2011 = interim_loan_acct + rural_bank_account_2011
	
	capture noisily drop interim_loan_acct
	
}
*
label var rural_bank_account_2011 "info about # rural bank accounts created between 2011 and t-4 year"



*creating rural bank education loan account variable

gen rural_bank_account 	= rural_bank_account_2004 if year_marker==2004 
replace rural_bank_account = rural_bank_account_2009 if year_marker==2009 
replace rural_bank_account = rural_bank_account_2011 if year_marker==2011 

label var rural_bank_account "IMP: variable having info # rural bank loan accounts created between NSS and t-4 year"





*********************************
**************URBAN**************
*********************************


************* finding urban bank loan account ************* 


***** creating 2004 variable 

*global rural_bank_marker 2 3 5 10 11 12 13 15 16 17 18

global urban_bank_marker 1 2 3 4 5 10 11 12 13 14 15 16 17 18 19

gen urban_bank_account_2004 = 0 

foreach k of global urban_bank_marker {

	capture noisily gen interim_loan_acct = 0
	
	capture noisily replace interim_loan_acct = diff_account_type_`k'_t_3_2004
	
	capture noisily replace urban_bank_account_2004 = interim_loan_acct + urban_bank_account_2004
	
	capture noisily drop interim_loan_acct
	
}
*
label var urban_bank_account_2004 "info about # urban bank loan accounts created between 2004 and t-3 year"


*checking all variables formed
*br diff_account_type_2_t_3_2004 diff_account_type_3_t_3_2004 diff_account_type_5_t_3_2004 diff_account_type_6_t_3_2004 diff_account_type_7_t_3_2004 diff_account_type_8_t_3_2004 diff_account_type_9_t_3_2004 diff_account_type_10_t_3_2004 diff_account_type_11_t_3_2004 diff_account_type_12_t_3_2004 diff_account_type_13_t_3_2004 diff_account_type_15_t_3_2004 diff_account_type_16_t_3_2004 diff_account_type_17_t_3_2004 diff_account_type_18_t_3_2004 urban_bank_account_2004



***** creating for 2009


gen urban_bank_account_2009 = 0 

foreach k of global urban_bank_marker {

	capture noisily gen interim_loan_acct = 0
	
	capture noisily replace interim_loan_acct = diff_account_type_`k'_t_4_2009
	
	capture noisily replace urban_bank_account_2009 = interim_loan_acct + urban_bank_account_2009
	
	capture noisily drop interim_loan_acct
	
}
*

label var urban_bank_account_2009 "info about # urban bank accounts created between 2009 and t-4 year"



*****  creating for 2011

gen urban_bank_account_2011 = 0 

foreach k of global urban_bank_marker {

	capture noisily gen interim_loan_acct = 0
	
	capture noisily replace interim_loan_acct = diff_account_type_`k'_t_4_2011
	
	capture noisily replace urban_bank_account_2011 = interim_loan_acct + urban_bank_account_2011
	
	capture noisily drop interim_loan_acct
	
}
*
label var urban_bank_account_2011 "info about # urban bank accounts created between 2011 and t-4 year"



*creating urban bank education loan account variable

gen urban_bank_account 	= urban_bank_account_2004 if year_marker==2004 
replace urban_bank_account = urban_bank_account_2009 if year_marker==2009 
replace urban_bank_account = urban_bank_account_2011 if year_marker==2011 

label var urban_bank_account "IMP: variable having info # urban bank loan accounts created between NSS and t-4 year"

****

*checking if values match for 2004 

gen total_rural_urban = rural_bank_account + urban_bank_account

gen check_pp = 1 if total_rural_urban == diff_account_ALL_t_3_2004

*there are some missing values but those are formatting issues.. checked in Excel
drop total_rural_urban check_pp


*saving the database
save "$common_path\Independent variables\Education Loan Dataset\Processed Data\edu_loan_04_09_11_specification_2.dta", replace

clear







											************************************
											******* END OF LAST DATASET ********
											************************************
											
											


											
											
											
											

											
											
*											







											
											
*******************************************************************************************************************************
*********************************** CENSUS POPULATION DATASET ********************************************************************
*******************************************************************************************************************************

/*

*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
				
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project"
				
global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"

*/

		



**********
***2001***
**********


*Creating dataset for 21 states

foreach state in "Tamil Nadu" "Kerala" "Maharastra"	"Karnataka"	"Andhra Pradesh" "Gujarat" "Madhya Pradesh"	"Chhattisgarh" "Orissa"	"Jharkhand"	"West Bengal" "Assam" "Bihar" "Uttar Pradesh" "Rajasthan" "Delhi" "Haryana"	"Uttarakhand" "Chandigarh" "Punjab" "Himachal Pradesh"{

		
		global state_name `state'

		global state_census_2001_excel "$common_path\Independent variables\Population (Census) Dataset\2001\Raw Data\Excel files\\$state_name.xls" 
		
		import excel using "$state_census_2001_excel"

		*renaming variables
		rename A Table_Name
		rename B State_Code
		rename C District_Code
		rename D Tehsil_Code
		rename E Area_Name
		rename F Age
		rename G Total_Persons
		rename H Total_Males
		rename I Total_Females
		rename J Rural_Persons
		rename K Rural_Males
		rename L Rural_Females
		rename M Urban_Persons
		rename N Urban_Males
		rename O Urban_Females

		*dropping unnecessary rows blank rows
		drop in 1/7

		
		save "$common_path\Independent variables\Population (Census) Dataset\2001\Processed Data\State wise Datasets\\$state_name.dta", replace

		clear
	
		
}
*



*appending all the state files 


foreach state in "Tamil Nadu" "Kerala" "Maharastra"	"Karnataka"	"Andhra Pradesh" "Gujarat" "Madhya Pradesh"	"Chhattisgarh" "Orissa"	"Jharkhand"	"West Bengal" "Assam" "Bihar" "Uttar Pradesh" "Rajasthan" "Delhi" "Haryana"	"Uttarakhand" "Chandigarh" "Punjab" "Himachal Pradesh"{

		global state_name `state'
		global state_file "$common_path\Independent variables\Population (Census) Dataset\2001\Processed Data\State wise Datasets\\$state_name.dta"
		
		append using "$state_file"
		
		
}
**


*there are few unnecessary columns so dropping those in case there are no values present over there

foreach empty_col in "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "AA" "AB" "AC" "AD" "AE" "AF" "AG" "AH" "AI" "AJ" "AK" "AL" "AM"{
		
		global col_name `empty_col'
		egen sum_`empty_col' = total(`empty_col')
		display "total that of $col_name" 
		display e(cmd)
		drop sum_`empty_col'
}
*

*dropping all unncessary columns since they have no values
drop P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK AL AM



*for analyzing data we need to destring the variables

*destringing the numeric variables

destring State_Code District_Code Total_Persons Total_Males Total_Females Rural_Persons Rural_Males Rural_Females Urban_Persons Urban_Males Urban_Females, replace
destring Tehsil_Code, replace


*Age variable has some nono-numeric values, creating a new numeric variable for age 
 
gen Age_numeric = Age

replace Age_numeric = "500" if Age=="100+"
replace Age_numeric = "501" if Age=="Age not stated"
replace Age_numeric = "502" if Age=="All ages"

destring Age_numeric, replace


*finding out State_codes for each State

count if Age_numeric==502 & District_Code==0
list Area_Name State_Code if Age_numeric==502 & District_Code==0



save "$common_path\Independent variables\Population (Census) Dataset\2001\Processed Data\All states_2001_census_C_series 16112017.dta", replace

***********************************************
***********************************************




********* IMPORTANT: make your input for census year here *********
   
global census_year 2001


*************** extracting state names ***************

gen state_1_$census_year = substr( Area_Name, 9 , .) if District_Code== 0

gen state_1_len_$census_year = length(state_1_$census_year)

gen state_2_$census_year= substr( state_1_$census_year, 1, state_1_len_$census_year - 3)


*drop intermeidate variables 
drop state_1_$census_year state_1_len_$census_year 

 
*assigning state_names as per state codes

gen State_census_$census_year= ""

replace State_census_$census_year = "TAMIL NADU" if State_Code == 33
replace State_census_$census_year = "KERALA" if State_Code == 32
replace State_census_$census_year = "MAHARASHTRA" if State_Code == 27
replace State_census_$census_year = "KARNATAKA" if State_Code == 29
replace State_census_$census_year = "ANDHRA PRADESH" if State_Code == 28
replace State_census_$census_year = "GUJARAT" if State_Code == 24
replace State_census_$census_year = "MADHYA PRADESH" if State_Code == 23
replace State_census_$census_year = "CHHATTISGARH" if State_Code == 22
replace State_census_$census_year = "ODISHA" if State_Code == 21
replace State_census_$census_year = "JHARKHAND" if State_Code == 20
replace State_census_$census_year = "WEST BENGAL" if State_Code == 19
replace State_census_$census_year = "ASSAM" if State_Code == 18
replace State_census_$census_year = "BIHAR" if State_Code == 10
replace State_census_$census_year = "UTTAR PRADESH" if State_Code == 09
replace State_census_$census_year = "RAJASTHAN" if State_Code == 08
replace State_census_$census_year = "NCT OF DELHI" if State_Code == 07
replace State_census_$census_year = "HARYANA" if State_Code == 06
replace State_census_$census_year = "UTTARAKHAND" if State_Code == 05
replace State_census_$census_year = "CHANDIGARH" if State_Code == 04
replace State_census_$census_year = "PUNJAB" if State_Code == 03
replace State_census_$census_year = "HIMACHAL PRADESH" if State_Code == 02


*checking it all relevent states data is present (the datset we have used didn't had any UN-IMPORTANT states)
tab State_census_$census_year if Age=="All ages"

*checking if the changes we made are correct
list State_Code Area_Name state_2_$census_year State_census_$census_year if Age =="All ages" & District_Code == 0



***************extracting district name ***************

gen District_1_$census_year = substr( Area_Name, 12, .) if District_Code!= 0

gen District_1_len_$census_year= length(District_1_$census_year )

gen District_2_$census_year= substr( District_1_$census_year, 1, District_1_len_$census_year - 3) 

gen District_2_trim_$census_year = trim(District_2_$census_year)

gen District_3_$census_year = District_2_trim_$census_year
replace District_3 = substr( District_2_trim_$census_year , 1, length(District_2_trim_$census_year) -1 ) if substr( District_2_trim_$census_year, -1, 1) == "*"  

*doing trimming of district name
gen District_census_$census_year = upper(trim(District_3_$census_year))


*dropping unnecessay intermediate variables
drop District_1_$census_year District_1_len_$census_year District_2_$census_year District_2_trim_$census_year District_3_$census_year


*labelling important state and district variables

label var state_2_$census_year "state name obtained from census data after extracting it from Area name"
label var State_census_$census_year "state name that we assigned manually for census year as per state codes"

label var District_census_$census_year "district name obtained after extracting it from Area name"





************* Assigning  district code using the mapping file created by us *************


rename District_census_$census_year District
rename State_census_$census_year State

run "$common_path\Supporting Files\district_codes_mapping_file 09112017.do"


*labelling variables

label var district_code "NSS 61 normalized codes from our district mapping file"
*rename district_code district_$census_year



* shows us list of all districts
*br if District_Code!= 0 & Age=="All ages"  

* #total districts for census year
count if District_Code!= 0 & Age=="All ages"  

* # districts NOT assigned a code
count if district_code==. & District_Code!= 0 & Age=="All ages" 
list State District if district_code==. & District_Code!= 0 & Age=="All ages"


rename District District_census_$census_year
rename State State_census_$census_year


*finding #original districts present in dataset 
count if District_Code!=0  & Age=="All ages"  // 514 number of original districts present in the dataset



********* Doing reclink merge with NSS 71 round districts which carry NSS 61 normalized codes *************


***** dropping state level data while district data is being preserved (since this data also got mapped by reclink since initially district codes were missing for it ***** 
drop if District_Code==0



*generating state_district key

gen State_district_key_$census_year = State_census_$census_year + "_"+ District_census_$census_year


*renaming census state-district key suitable for reclink so that we can get district codes for these strings
rename State_district_key_$census_year State_district_key_68_71 


*generating a unique identifier for each obsercvation since reclink demands it
gen census_unique_id_$census_year = _n



*merging the NSS 71 round data

global NSS_71_normalized_data "$common_path\NSS Data\NSS 71\Step 2\nss_71_district_code_remaped_dataset_07112017_1642.dta" 

reclink State_district_key_68_71 using "$NSS_71_normalized_data", idmaster(census_unique_id_$census_year) idusing(State_district_code) gen(score_NSS_71_census) uprefix("NSS_71_") 


*labeling variable
label var State_district_key_68_71 "key contains original census state-district combination" 
label var score_NSS_71_census "reclink matching score of census & NSS 71 district codes"
label var census_unique_id_$census_year "created for sake of using reclink"

*relabelling wrong tagging
label var State_district_FINAL_code_71 "IMP variable: codes normalized to 61st round obtained from NSS 71st round"


*renaming census state-district key suitable for reclink so that we can get district codes for these strings
rename State_district_key_68_71 State_district_key_census_$census_year



***************Comparing if codes from district mapping file and reclink district codes are matching ***************

gen true_NSS71_norm_census_$census_year = 0
replace true_NSS71_norm_census_$census_year = 1 if State_district_FINAL_code_71 == district_code


*# districts which couldn't be mapped using district code mapping file 
count if District_Code!= 0 & Age=="All ages" & district_code==.

*# missing district codes which cannot be EXACTLY mapped using reclink
count if District_Code!= 0 & Age=="All ages" & district_code==. & score_NSS_71_census!=1

* # districts where disctrict code and reclink codes are different even when match score ==1 
count if District_Code!= 0 & Age=="All ages" & district_code!=. & score_NSS_71_census==1 & true_NSS71_norm_census_$census_year == 0


***************re-assigning districts with missing district codes and recklink score NOT equal to one ***************

*#districts present in the database
count if District_Code!=0 & Age=="All ages"

*#districts which CANNOT be mapped by mapping file and are present in the database
count if district_code==. & District_Code!=0 & Age=="All ages"


gen district_code_FINAL_census_$census_year = district_code

***
***
*** IMP: correction made to this code
replace district_code_FINAL_census_$census_year = State_district_FINAL_code_71 if district_code==. & District_Code!=0


*correct for Rangarredy Andhra Pradesh, because it couldn't be mapped by district code mapping file due to seplling differeces
replace district_code_FINAL_census_$census_year = 2806 if State_census_$census_year=="ANDHRA PRADESH" & District_census_$census_year=="RANGAREDDI"
	
*correct for Sonapur/Sonepur/Subranpur Orissa
replace district_code_FINAL_census_$census_year = 2123 if State_census_$census_year=="ODISHA" & District_census_$census_year=="SONAPUR"


* # districts NOT assigned a code after corrections
count if district_code_FINAL_census_$census_year ==. & District_Code!= 0 & Age=="All ages" 
list State_census_$census_year District_census_$census_year if district_code_FINAL_census_$census_year ==. & District_Code!= 0 & Age=="All ages"




*************** DOING SOME DATA GROOMING ***************

*reclink: dropping UNWANTED variables brought with (using) dataset while doing reclink
drop State_district_code old_State_code_71 old_State_71 old_District_71 old_District_code_71 State_code_71 District_code_71 State_district_code_string_71 State_71 District_71 UState_district_key_68_71 match_score State_district_primitive_code_68 State_code_68 District_code_68 old_District_68 State_68 tag_string District_68 State_district_code_string State_district_FINAL_code_68 true_state_district_code_68 _merge_nss71_with_modify_68 true_primitive_nss_68_71 true_state_district_code_71


*renaming IMP variables
rename  _merge _merge_NSS71_normal_census_$census_year


*labelling important variables
label var true_NSS71_norm_census_$census_year "checking NSS71 normalzed codes with district code mapping file"
label var district_code_FINAL_census_$census_year "IMP: final district codes for census data"



************** Creating All ages & age 17-25 years (18 variables) **************


************** FOR ALL AGES **************

*creating intermediate variable for ALL ages variable for total, rural-urban, male-female split
 
foreach age_var in "Total_Persons"	"Total_Males"	"Total_Females"	"Rural_Persons"	"Rural_Males"	"Rural_Females"	"Urban_Persons"	"Urban_Males"	"Urban_Females" {

		bysort district_code_FINAL_census_$census_year: egen age_allyr_temp_`age_var' = total(`age_var') if Age== "All ages"
		
}

*creating FINAL variable for ALL ages variable for total, rural-urban, male-female split

foreach age_var in "Total_Persons"	"Total_Males"	"Total_Females"	"Rural_Persons"	"Rural_Males"	"Rural_Females"	"Urban_Persons"	"Urban_Males"	"Urban_Females" {

		bysort district_code_FINAL_census_$census_year: egen age_all_years_`age_var' = max(age_allyr_temp_`age_var')
		drop age_allyr_temp_`age_var'
}
*



************** FOR AGE 17-25 years **************

*creating intemediate variables for age between 17-25 years (closed intervals)

foreach age_var in "Total_Persons"	"Total_Males"	"Total_Females"	"Rural_Persons"	"Rural_Males"	"Rural_Females"	"Urban_Persons"	"Urban_Males"	"Urban_Females" {

		bysort district_code_FINAL_census_$census_year: egen age_17_25_interim_`age_var' = total(`age_var') if (Age_numeric >= 17) &  (Age_numeric <= 25)
		
}
*

*generating FINAL variables for age between 17-25 years (closed intervals)

foreach age_var in "Total_Persons"	"Total_Males"	"Total_Females"	"Rural_Persons"	"Rural_Males"	"Rural_Females"	"Urban_Persons"	"Urban_Males"	"Urban_Females" {

		bysort district_code_FINAL_census_$census_year: egen age_17_25_`age_var' = max(age_17_25_interim_`age_var') 
		drop age_17_25_interim_`age_var'
}
*


************** keeping data which is relevent at DISTRICT LEVEL ************** 

distinct district_code_FINAL_census_$census_year if District_Code!= 0 & Age=="All ages"
duplicates report district_code_FINAL_census_$census_year if District_Code!= 0 & Age=="All ages"


*keeping only single row for each district
keep if District_Code!= 0 & Age=="All ages"

duplicates drop district_code_FINAL_census_$census_year, force  


*this variable is coming empty anyways hence better to drop it
drop state_2_$census_year



/////////// ********** Creating census 2001 dataset post district grouping *************** /////////// 


********* IMPORTANT: Please make input for the old variable which has information about district codes  *********


global old_dist_code_var "district_code_FINAL_census_2001"


*running the program which has codes for all the district groups that we have formed
program_replace_dist_code $old_dist_code_var

list State_census_2001 District_census_2001  district_code_FINAL_census_2001 dist_code_after_group if  district_code_FINAL_census_2001 != dist_code_after_group, abbreviate(33) sepby(dist_code_after_group)

count if dist_code_after_group ==.


************** Post district groupping : Creating NEW All ages & age 17-25 years (18 variables) **************


*creating new age_all_years variables 
global age_all_years "age_all_years_Total_Persons age_all_years_Total_Males age_all_years_Total_Females age_all_years_Rural_Persons age_all_years_Rural_Males age_all_years_Rural_Females age_all_years_Urban_Persons age_all_years_Urban_Males age_all_years_Urban_Females" 

foreach x of global age_all_years { 
	
	local y = "`x'" + "_new"
	bysort dist_code_after_group : egen `y' = total(`x')
	
}
*

*creating new 17-25 years variables 
global age_17_25 "age_17_25_Total_Persons age_17_25_Total_Males age_17_25_Total_Females age_17_25_Rural_Persons age_17_25_Rural_Males age_17_25_Rural_Females age_17_25_Urban_Persons age_17_25_Urban_Males age_17_25_Urban_Females" 

foreach x of global age_17_25 { 
	
	local y = "`x'" + "_new"
	bysort dist_code_after_group : egen `y' = total(`x')
	
}
*

*dropping unnecessary variables
drop Table_Name State_Code District_Code Tehsil_Code Area_Name Age Total_Persons Total_Males Total_Females Rural_Persons Rural_Males Rural_Females Urban_Persons Urban_Males Urban_Females Age_numeric
drop district_code district_code NSS_71_State_district_key_68_71 census_unique_id_2001 score_NSS_71_census State_district_FINAL_code_71 _merge_NSS71_normal_census_2001 true_NSS71_norm_census_2001


*dropping old All_age and age_17_25 varaibles

drop age_all_years_Total_Persons age_all_years_Total_Males age_all_years_Total_Females age_all_years_Rural_Persons age_all_years_Rural_Males age_all_years_Rural_Females age_all_years_Urban_Persons age_all_years_Urban_Males age_all_years_Urban_Females

drop age_17_25_Total_Persons age_17_25_Total_Males age_17_25_Total_Females age_17_25_Rural_Persons age_17_25_Rural_Males age_17_25_Rural_Females age_17_25_Urban_Persons age_17_25_Urban_Males age_17_25_Urban_Females



*dropping duplicate values
duplicates drop dist_code_after_group, force // Keep only one value for each district


*saving the database
save "$common_path\Independent variables\Population (Census) Dataset\2001\Processed Data\Penultimate 2001 census data 28022018.dta", replace
clear










//*********************************
** Preparing data for 2011 census 
***********************************//



*Creating dataset for all states

foreach state in "Tamil Nadu" "Kerala" "Maharastra"	"Karnataka"	"Andhra Pradesh" "Gujarat" "Madhya Pradesh"	"Chhattisgarh" "Orissa"	"Jharkhand"	"West Bengal" "Assam" "Bihar" "Uttar Pradesh" "Rajasthan" "Delhi" "Haryana"	"Uttarakhand" "Chandigarh" "Punjab" "Himachal Pradesh"{

		
		global state_name `state'
		
		global state_census_11_excel "$common_path\Independent variables\Population (Census) Dataset\2011\Raw Data\Excel files\\$state_name.xls" 
		import excel using "$state_census_11_excel"

		*renaming variables
		rename A Table_Name
		rename B State_Code
		rename C District_Code
		rename D Area_Name
		rename E Age
		rename F Total_Persons
		rename G Total_Males
		rename H Total_Females
		rename I Rural_Persons
		rename J Rural_Males
		rename K Rural_Females
		rename L Urban_Persons
		rename M Urban_Males
		rename N Urban_Females

		*dropping unnecessary rows blank rows
		drop in 1/7

		save "$common_path\Independent variables\Population (Census) Dataset\2011\Processed Data\State wise Datasets\\$state_name.dta", replace

		clear

}

****


*********************************************************************************************


*appending all the state files 


foreach state in "Tamil Nadu" "Kerala" "Maharastra"	"Karnataka"	"Andhra Pradesh" "Gujarat" "Madhya Pradesh"	"Chhattisgarh" "Orissa"	"Jharkhand"	"West Bengal" "Assam" "Bihar" "Uttar Pradesh" "Rajasthan" "Delhi" "Haryana"	"Uttarakhand" "Chandigarh" "Punjab" "Himachal Pradesh"{

		global state_name `state'
		global state_file "$common_path\Independent variables\Population (Census) Dataset\2011\Processed Data\State wise Datasets\\$state_name.dta"
		
		append using "$state_file"
		
		
}
//

save "$common_path\Independent variables\Population (Census) Dataset\2011\Processed Data\All states_2011_census_C_series 10112017 1645.dta", replace





********* IMPORTANT: make your input for census year here *********
   
global census_year 2011


*for analyzing data we need to destring the variables 
*destringing the numeric variables

destring State_Code District_Code Total_Persons Total_Males Total_Females Rural_Persons Rural_Males Rural_Females Urban_Persons Urban_Males Urban_Females, replace


gen Age_numeric = Age

replace Age_numeric = "500" if Age=="100+"
replace Age_numeric = "501" if Age=="Age not stated"
replace Age_numeric = "502" if Age=="All ages"

destring Age_numeric, replace



*************** extracting state names ***************

gen state_1_$census_year = substr( Area_Name, 8 , .) if District_Code== 0

gen state_1_len_$census_year = length(state_1_$census_year)

gen state_2_$census_year= substr( state_1_$census_year, 1, state_1_len_$census_year - 5)


*drop intermeidate variables 
drop state_1_$census_year state_1_len_$census_year 

 
*assigning state_names as per state codes

gen State_census_$census_year= ""

replace State_census_$census_year = "TAMIL NADU" if State_Code == 33
replace State_census_$census_year = "KERALA" if State_Code == 32
replace State_census_$census_year = "MAHARASHTRA" if State_Code == 27
replace State_census_$census_year = "KARNATAKA" if State_Code == 29
replace State_census_$census_year = "ANDHRA PRADESH" if State_Code == 28
replace State_census_$census_year = "GUJARAT" if State_Code == 24
replace State_census_$census_year = "MADHYA PRADESH" if State_Code == 23
replace State_census_$census_year = "CHHATTISGARH" if State_Code == 22
replace State_census_$census_year = "ODISHA" if State_Code == 21
replace State_census_$census_year = "JHARKHAND" if State_Code == 20
replace State_census_$census_year = "WEST BENGAL" if State_Code == 19
replace State_census_$census_year = "ASSAM" if State_Code == 18
replace State_census_$census_year = "BIHAR" if State_Code == 10
replace State_census_$census_year = "UTTAR PRADESH" if State_Code == 09
replace State_census_$census_year = "RAJASTHAN" if State_Code == 08
replace State_census_$census_year = "NCT OF DELHI" if State_Code == 07
replace State_census_$census_year = "HARYANA" if State_Code == 06
replace State_census_$census_year = "UTTARAKHAND" if State_Code == 05
replace State_census_$census_year = "CHANDIGARH" if State_Code == 04
replace State_census_$census_year = "PUNJAB" if State_Code == 03
replace State_census_$census_year = "HIMACHAL PRADESH" if State_Code == 02


*checking it all relevent states data is present (the datset we have used didn't had any UN-IMPORTANT states)
tab State_census_$census_year if Age=="All ages"

*checking if the changes we made are correct
list State_Code Area_Name state_2_$census_year State_census_$census_year if Age =="All ages" & District_Code == 0



***************extracting district name ***************

gen District_1_$census_year = substr( Area_Name, 11, .) if District_Code!= 0

gen District_1_len_$census_year= length(District_1_$census_year )

gen District_2_$census_year= substr( District_1_$census_year, 1, District_1_len_$census_year - 5) 


*doing trimming of district name
gen District_census_$census_year = upper(trim(District_2_$census_year))


*dropping unnecessay intermediate variables
drop District_1_$census_year District_1_len_$census_year District_2_$census_year 


*labelling important state and district variables

label var state_2_$census_year "state name obtained from census data after extracting it from Area name"
label var State_census_$census_year "state name that we assigned manually for census year as per state codes"

label var District_census_$census_year "district name obtained after extracting it from Area name"





************* Assigning  district code using the mapping file created by us *************


rename District_census_$census_year District
rename State_census_$census_year State

run "$common_path\Supporting Files\district_codes_mapping_file 09112017.do"

*labelling variables

label var district_code "NSS 61 normalized codes from our district mapping file"


* #total districts for census year
count if District_Code!= 0 & Age=="All ages"  

* # districts NOT assigned a code
count if district_code==. & District_Code!= 0 & Age=="All ages" 
list State District if district_code==. & District_Code!= 0 & Age=="All ages"


rename District District_census_$census_year
rename State State_census_$census_year


duplicates example Area_Name if District_Code==0



********* Doing reclink merge with NSS 71 round districts which carry NSS 61 normalized codes *************


*fixing error

***** dropping state level data while district data is being preserved (since this data also got mapped by reclink since initially district codes were missing for it ***** 
drop if District_Code==0



*generating state_district key
gen State_district_key_$census_year = State_census_$census_year + "_"+ District_census_$census_year

*renaming census state-district key suitable for reclink so that we can get district codes for these strings
rename State_district_key_$census_year State_district_key_68_71 

*generating a unique identifier for each obsercvation since reclink demands it
gen census_unique_id_$census_year = _n


*merging the NSS 71 round data

global NSS_71_normalized_data "$common_path\NSS Data\NSS 71\Step 2\nss_71_district_code_remaped_dataset_07112017_1642.dta" 

reclink State_district_key_68_71 using "$NSS_71_normalized_data", idmaster(census_unique_id_$census_year) idusing(State_district_code) gen(score_NSS_71_census) uprefix("NSS_71_") 


*labeling variable
label var State_district_key_68_71 "key contains original census state-district combination" 
label var score_NSS_71_census "reclink matching score of census & NSS 71 district codes"
label var census_unique_id_$census_year "created for sake of using reclink"

*relabelling wrong tagging
label var State_district_FINAL_code_71 "IMP variable: codes normalized to 61st round obtained from NSS 71st round"


*renaming census state-district key suitable for reclink so that we can get district codes for these strings
rename State_district_key_68_71 State_district_key_census_$census_year



***************Comparing if codes from district mapping file and reclink district codes are matching ***************

gen true_NSS71_norm_census_$census_year = 0
replace true_NSS71_norm_census_$census_year = 1 if State_district_FINAL_code_71 == district_code


*# districts which couldn't be mapped using district code mapping file 
count if District_Code!= 0 & Age=="All ages" & district_code==.

*# missing district codes which cannot be EXACTLY mapped using reclink
count if District_Code!= 0 & Age=="All ages" & district_code==. & score_NSS_71_census!=1

* # districts where district code and reclink codes are different even when match score ==1 
count if District_Code!= 0 & Age=="All ages" & district_code!=. & score_NSS_71_census==1 & true_NSS71_norm_census_$census_year == 0




***************re-assigning districts with missing district codes and recklink score NOT equal to one ***************

*#districts present in the database
count if District_Code!=0 & Age=="All ages"

*#districts which CANNOT be mapped by mapping file and are present in the database
count if district_code==. & District_Code!=0 & Age=="All ages"


gen district_code_FINAL_census_$census_year = district_code

***
***
*** IMP: correction made to this code
replace district_code_FINAL_census_$census_year = State_district_FINAL_code_71 if district_code==. & District_Code!=0


*correct for Sonapur/Sonepur/Subranpur Orissa
replace district_code_FINAL_census_$census_year = 2123 if State_census_$census_year=="ODISHA" & District_census_$census_year=="SUBARNAPUR"

*correct for mahamaya nagar Uttar Pradesh
replace district_code_FINAL_census_$census_year = 913 if State_census_$census_year=="UTTAR PRADESH" & District_census_$census_year=="MAHAMAYA NAGAR"


* # districts NOT assigned a code after corrections
count if district_code_FINAL_census_$census_year ==. & District_Code!= 0 & Age=="All ages" 
list State_census_$census_year District_census_$census_year if district_code_FINAL_census_$census_year ==. & District_Code!= 0 & Age=="All ages"



*************** DOING SOME DATA GROOMING ***************

*reclink: dropping UNWANTED variables brought with (using) dataset while doing reclink
drop State_district_code old_State_code_71 old_State_71 old_District_71 old_District_code_71 State_code_71 District_code_71 State_district_code_string_71 State_71 District_71 UState_district_key_68_71 match_score State_district_primitive_code_68 State_code_68 District_code_68 old_District_68 State_68 tag_string District_68 State_district_code_string State_district_FINAL_code_68 true_state_district_code_68 _merge_nss71_with_modify_68 true_primitive_nss_68_71 true_state_district_code_71


*renaming IMP variables
rename  _merge _merge_NSS71_normal_census_$census_year


*labelling important variables
label var true_NSS71_norm_census_$census_year "checking NSS71 normalzed codes with district code mapping file"
label var district_code_FINAL_census_$census_year "IMP: final district codes for census data"




************** Creating All ages & age 17-25 years (18 variables) **************



************** FOR ALL AGES **************

*creating intermediate variable for ALL ages variable for total, rural-urban, male-female split
 
foreach age_var in "Total_Persons"	"Total_Males"	"Total_Females"	"Rural_Persons"	"Rural_Males"	"Rural_Females"	"Urban_Persons"	"Urban_Males"	"Urban_Females" {

		bysort district_code_FINAL_census_$census_year: egen age_allyr_temp_`age_var' = total(`age_var') if Age== "All ages"
		
}

*creating FINAL variable for ALL ages variable for total, rural-urban, male-female split

foreach age_var in "Total_Persons"	"Total_Males"	"Total_Females"	"Rural_Persons"	"Rural_Males"	"Rural_Females"	"Urban_Persons"	"Urban_Males"	"Urban_Females" {

		bysort district_code_FINAL_census_$census_year: egen age_all_years_`age_var' = max(age_allyr_temp_`age_var')
		drop age_allyr_temp_`age_var'
}
*

************** FOR AGE 17-25 years **************

*creating intemediate variables for age between 17-25 years (closed intervals)

foreach age_var in "Total_Persons"	"Total_Males"	"Total_Females"	"Rural_Persons"	"Rural_Males"	"Rural_Females"	"Urban_Persons"	"Urban_Males"	"Urban_Females" {

		bysort district_code_FINAL_census_$census_year: egen age_17_25_interim_`age_var' = total(`age_var') if (Age_numeric >= 17) &  (Age_numeric <= 25)
		
}
*

*generating FINAL variables for age between 17-25 years (closed intervals)

foreach age_var in "Total_Persons"	"Total_Males"	"Total_Females"	"Rural_Persons"	"Rural_Males"	"Rural_Females"	"Urban_Persons"	"Urban_Males"	"Urban_Females" {

		bysort district_code_FINAL_census_$census_year: egen age_17_25_`age_var' = max(age_17_25_interim_`age_var') 
		drop age_17_25_interim_`age_var'
}
*


************** keeping data which is relevent at DISTRICT LEVEL ************** 

count if District_Code!= 0 & Age=="All ages"
distinct district_code_FINAL_census_$census_year if District_Code!= 0 & Age=="All ages"
duplicates report district_code_FINAL_census_$census_year if District_Code!= 0 & Age=="All ages"

duplicates tag district_code_FINAL_census_2011 if District_Code!= 0 & Age=="All ages", generate(dup_districts)
tab dup_districts
*br if dup_districts==1
list State_census_2011 District_census_2011 district_code_FINAL_census_2011 if dup_districts==1



keep if District_Code!= 0 & Age=="All ages"

duplicates drop district_code_FINAL_census_$census_year, force  

*this variable is coming empty anyways hence better to drop it
drop state_2_2011

drop dup_districts





/////////// ********** Creating census 2011 dataset post district grouping *************** /////////// 


********* IMPORTANT: Please make input for the old variable which has information about district codes  *********


global old_dist_code_var "district_code_FINAL_census_2011"


*running the program which has codes for all the district groups that we have formed
program_replace_dist_code $old_dist_code_var

list State_census_2011 District_census_2011  district_code_FINAL_census_2011 dist_code_after_group if  district_code_FINAL_census_2011 != dist_code_after_group, abbreviate(33) sepby(dist_code_after_group)

count if dist_code_after_group ==.





************** Post district groupping : Creating NEW All ages & age 17-25 years (18 variables) **************



*creating new age_all_years variables 
global age_all_years "age_all_years_Total_Persons age_all_years_Total_Males age_all_years_Total_Females age_all_years_Rural_Persons age_all_years_Rural_Males age_all_years_Rural_Females age_all_years_Urban_Persons age_all_years_Urban_Males age_all_years_Urban_Females" 

foreach x of global age_all_years { 
	
	local y = "`x'" + "_new"
	bysort dist_code_after_group : egen `y' = total(`x')
	
}
*

*creating new 17-25 years variables 
global age_17_25 "age_17_25_Total_Persons age_17_25_Total_Males age_17_25_Total_Females age_17_25_Rural_Persons age_17_25_Rural_Males age_17_25_Rural_Females age_17_25_Urban_Persons age_17_25_Urban_Males age_17_25_Urban_Females" 

foreach x of global age_17_25 { 
	
	local y = "`x'" + "_new"
	bysort dist_code_after_group : egen `y' = total(`x')
	
}
*


*dropping unnecessary variables
drop Table_Name State_Code District_Code Area_Name Age Total_Persons Total_Males Total_Females Rural_Persons Rural_Males Rural_Females Urban_Persons Urban_Males Urban_Females Age_numeric

drop district_code district_code NSS_71_State_district_key_68_71 census_unique_id_2011 score_NSS_71_census State_district_FINAL_code_71 _merge_NSS71_normal_census_2011 true_NSS71_norm_census_2011


*dropping old All_age and age_17_25 varaibles

drop age_all_years_Total_Persons age_all_years_Total_Males age_all_years_Total_Females age_all_years_Rural_Persons age_all_years_Rural_Males age_all_years_Rural_Females age_all_years_Urban_Persons age_all_years_Urban_Males age_all_years_Urban_Females
drop age_17_25_Total_Persons age_17_25_Total_Males age_17_25_Total_Females age_17_25_Rural_Persons age_17_25_Rural_Males age_17_25_Rural_Females age_17_25_Urban_Persons age_17_25_Urban_Males age_17_25_Urban_Females



*dropping duplicate values
duplicates drop dist_code_after_group, force // Keep only one value for each district


*saving the census dataset
save "$common_path\Independent variables\Population (Census) Dataset\2011\Processed Data\Latest round 2011 census data 28022018.dta", replace
clear






//*********************************
** Doing Population Interpolation 
***********************************//

** creating template

set more off
 
use "$common_path\Independent variables\Population (Census) Dataset\2011\Processed Data\Latest round 2011 census data 28022018.dta"
keep dist_code_after_group
gen year_marker=.

save "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Yearly template\year_marker_template 28022018.dta", replace
clear


*creating 2002-2010 year_marker files

forvalues x = 2002/2010 {

		
		use "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Yearly template\year_marker_template 28022018.dta", clear
		replace year_marker = `x'
		
		save "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Yearly template\\`x'_year_marker.dta", replace
		clear
}
*


************************************************





///////////////********  Population Interpolation.... combining 2001 to all mid years to 2011 ********///////////////


set more off


*defining global paths of 2001 and 2011 census data
global census_2001_path "$common_path\Independent variables\Population (Census) Dataset\2001\Processed Data\Penultimate 2001 census data 28022018.dta"

global census_2011_path "$common_path\Independent variables\Population (Census) Dataset\2011\Processed Data\Latest round 2011 census data 28022018.dta"


*use census 2001 dataset
use "$census_2001_path", clear
gen year_marker = 2001


*append datasets

forvalues x = 2002/2010 {
		
		local year_marker "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Yearly template\\`x'_year_marker.dta"
		append using "`year_marker'"
		
}
*

*appending final file i.e. census 2011
append using "$census_2011_path"
replace year_marker = 2011 if year_marker==.


*data grooming and cleaning
order State_census_2001 District_census_2001 State_census_2011 District_census_2011, first
drop State_district_key_census_2001 State_district_key_census_2011 

drop district_code_FINAL_census_2011 district_code_FINAL_census_2001

sort dist_code_after_group year_marker 


*renaming varaibles
rename age_all_years_Total_Persons_new 	age_all_years_Total_Persons
rename age_all_years_Total_Males_new 	age_all_years_Total_Males
rename age_all_years_Total_Females_new 	age_all_years_Total_Females
rename age_all_years_Rural_Persons_new 	age_all_years_Rural_Persons
rename age_all_years_Rural_Males_new 	age_all_years_Rural_Males
rename age_all_years_Rural_Females_new 	age_all_years_Rural_Females
rename age_all_years_Urban_Persons_new 	age_all_years_Urban_Persons
rename age_all_years_Urban_Males_new 	age_all_years_Urban_Males
rename age_all_years_Urban_Females_new 	age_all_years_Urban_Females
rename age_17_25_Total_Persons_new 		age_17_25_Total_Persons
rename age_17_25_Total_Males_new 		age_17_25_Total_Males
rename age_17_25_Total_Females_new 		age_17_25_Total_Females
rename age_17_25_Rural_Persons_new 		age_17_25_Rural_Persons
rename age_17_25_Rural_Males_new 		age_17_25_Rural_Males
rename age_17_25_Rural_Females_new 		age_17_25_Rural_Females
rename age_17_25_Urban_Persons_new 		age_17_25_Urban_Persons
rename age_17_25_Urban_Males_new 		age_17_25_Urban_Males
rename age_17_25_Urban_Females_new 		age_17_25_Urban_Females



*changing format of numeric variables

format age_all_years_Total_Persons %12.0g
format age_all_years_Total_Males %12.0g
format age_all_years_Total_Females %12.0g
format age_all_years_Rural_Persons %12.0g
format age_all_years_Rural_Males %12.0g
format age_all_years_Rural_Females %12.0g
format age_all_years_Urban_Persons %12.0g
format age_all_years_Urban_Males %12.0g
format age_all_years_Urban_Females %12.0g
format age_17_25_Total_Persons %12.0g
format age_17_25_Total_Males %12.0g
format age_17_25_Total_Females %12.0g
format age_17_25_Rural_Persons %12.0g
format age_17_25_Rural_Males %12.0g
format age_17_25_Rural_Females %12.0g
format age_17_25_Urban_Persons %12.0g
format age_17_25_Urban_Males %12.0g
format age_17_25_Urban_Females %12.0g





*creating mid year variables i.e for 2002-2010 using linear interpolation


local all_age_years "age_all_years_Total_Persons age_all_years_Total_Males age_all_years_Total_Females age_all_years_Rural_Persons age_all_years_Rural_Males age_all_years_Rural_Females age_all_years_Urban_Persons age_all_years_Urban_Males age_all_years_Urban_Females age_17_25_Total_Persons age_17_25_Total_Males age_17_25_Total_Females age_17_25_Rural_Persons age_17_25_Rural_Males age_17_25_Rural_Females age_17_25_Urban_Persons age_17_25_Urban_Males age_17_25_Urban_Females"

foreach x of local all_age_years {
	
		local p = "`x'" + "_lp"
		
		display "`p'"
		
		bysort dist_code_after_group : ipolate `x' year_marker, gen("`p'")
		
		label var `p' "obtained using linear interpolation" 
		
}
*


*finding exponential growth rate interpolation

local cvt "age_all_years_Total_Persons age_all_years_Total_Males age_all_years_Total_Females age_all_years_Rural_Persons age_all_years_Rural_Males age_all_years_Rural_Females age_all_years_Urban_Persons age_all_years_Urban_Males age_all_years_Urban_Females age_17_25_Total_Persons age_17_25_Total_Males age_17_25_Total_Females age_17_25_Rural_Persons age_17_25_Rural_Males age_17_25_Rural_Females age_17_25_Urban_Persons age_17_25_Urban_Males age_17_25_Urban_Females"

foreach x of local cvt {
	
		local q = "`x'" + "_gr"
		
		display "`q'"
		
		bysort dist_code_after_group : gen `q'  = ( ln(`x'[11]/`x'[1]) / 10 )
		
		local pl = "`x'" + "_ex"
		
		bysort dist_code_after_group : gen `pl' =  `x'
		bysort dist_code_after_group : replace `pl' = `x'[1] * exp( `q' * (_n-1) )   
		
		label var `pl' "obtained using EXPONENTIAL growth interpolation" 
		
}
*



** IMP: replace all missing values to zero

*replacing all linear interpolation missing values with ZERO

local dvd "age_all_years_Total_Persons_lp age_all_years_Total_Males_lp age_all_years_Total_Females_lp age_all_years_Rural_Persons_lp age_all_years_Rural_Males_lp age_all_years_Rural_Females_lp age_all_years_Urban_Persons_lp age_all_years_Urban_Males_lp age_all_years_Urban_Females_lp age_17_25_Total_Persons_lp age_17_25_Total_Males_lp age_17_25_Total_Females_lp age_17_25_Rural_Persons_lp age_17_25_Rural_Males_lp age_17_25_Rural_Females_lp age_17_25_Urban_Persons_lp age_17_25_Urban_Males_lp age_17_25_Urban_Females_lp"

foreach y of local dvd {
	
	replace `y' = 0 if `y'  == . 

}
*

*replacing all exponential growth interpolation missing values with ZERO

local sfd "age_all_years_Total_Persons_ex age_all_years_Total_Males_ex age_all_years_Total_Females_ex age_all_years_Rural_Persons_ex age_all_years_Rural_Males_ex age_all_years_Rural_Females_ex age_all_years_Urban_Persons_ex age_all_years_Urban_Males_ex age_all_years_Urban_Females_ex age_17_25_Total_Persons_ex age_17_25_Total_Males_ex age_17_25_Total_Females_ex age_17_25_Rural_Persons_ex age_17_25_Rural_Males_ex age_17_25_Rural_Females_ex age_17_25_Urban_Persons_ex age_17_25_Urban_Males_ex age_17_25_Urban_Females_ex"

foreach y of local sfd {
	
	replace `y' = 0 if `y'  == . 

}
*


*dropping exponential growth variables

drop age_all_years_Total_Persons_gr age_all_years_Total_Males_gr age_all_years_Total_Females_gr age_all_years_Rural_Persons_gr age_all_years_Rural_Males_gr age_all_years_Rural_Females_gr age_all_years_Urban_Persons_gr age_all_years_Urban_Males_gr age_all_years_Urban_Females_gr age_17_25_Total_Persons_gr age_17_25_Total_Males_gr age_17_25_Total_Females_gr age_17_25_Rural_Persons_gr age_17_25_Rural_Males_gr age_17_25_Rural_Females_gr age_17_25_Urban_Persons_gr age_17_25_Urban_Males_gr age_17_25_Urban_Females_gr


*looking for missing values across all interpolated columns

local big_list "age_all_years_Total_Persons_lp age_all_years_Total_Males_lp age_all_years_Total_Females_lp age_all_years_Rural_Persons_lp age_all_years_Rural_Males_lp age_all_years_Rural_Females_lp age_all_years_Urban_Persons_lp age_all_years_Urban_Males_lp age_all_years_Urban_Females_lp age_17_25_Total_Persons_lp age_17_25_Total_Males_lp age_17_25_Total_Females_lp age_17_25_Rural_Persons_lp age_17_25_Rural_Males_lp age_17_25_Rural_Females_lp age_17_25_Urban_Persons_lp age_17_25_Urban_Males_lp age_17_25_Urban_Females_lp age_all_years_Total_Persons_ex age_all_years_Total_Males_ex age_all_years_Total_Females_ex age_all_years_Rural_Persons_ex age_all_years_Rural_Males_ex age_all_years_Rural_Females_ex age_all_years_Urban_Persons_ex age_all_years_Urban_Males_ex age_all_years_Urban_Females_ex age_17_25_Total_Persons_ex age_17_25_Total_Males_ex age_17_25_Total_Females_ex age_17_25_Rural_Persons_ex age_17_25_Rural_Males_ex age_17_25_Rural_Females_ex age_17_25_Urban_Persons_ex age_17_25_Urban_Males_ex age_17_25_Urban_Females_ex"

foreach y of local big_list {

format `y' %12.0g
count if `y' == . 

} 
*

*creating state and district name for interpolated data

bysort dist_code_after_group : gen State_pop_interp = State_census_2011[11]
bysort dist_code_after_group : gen District_pop_interp = District_census_2011[11]

order State_pop_interp District_pop_interp, first

label var State_pop_interp "State name from population interpolation"
label var District_pop_interp "District name from population interpolation"




*enter population dataset you want to create

*creating year wise population dataset

forvalues i= 2001/2011 {


global year_pop `i'

preserve

drop State_census_2001 District_census_2001 State_census_2011 District_census_2011

drop age_all_years_Total_Persons age_all_years_Total_Males age_all_years_Total_Females age_all_years_Rural_Persons age_all_years_Rural_Males age_all_years_Rural_Females age_all_years_Urban_Persons age_all_years_Urban_Males age_all_years_Urban_Females age_17_25_Total_Persons age_17_25_Total_Males age_17_25_Total_Females age_17_25_Rural_Persons age_17_25_Rural_Males age_17_25_Rural_Females age_17_25_Urban_Persons age_17_25_Urban_Males age_17_25_Urban_Females

keep if year_marker == $year_pop

save "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Interpolated Yearly Population\Interpolated $year_pop population.dta", replace

restore

}

*clearing the datasets from memory
clear 



************ merging population data *************

*appending the above created datasets so that they can be easily merged with Specification 2 dataset

set more off

global pop_2004_data "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Interpolated Yearly Population\Interpolated 2004 population.dta"

global pop_2009_data "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Interpolated Yearly Population\Interpolated 2009 population.dta"

global pop_2011_data "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Interpolated Yearly Population\Interpolated 2011 population.dta"

append using "$pop_2004_data" "$pop_2009_data" "$pop_2011_data"

save "$common_path\Independent variables\Population (Census) Dataset\Population Projection\Combined 2004_09_11 Interpolated Yearly Population.dta", replace



clear











											************************************
											******* END OF LAST DATASET ********
											************************************
											
											


											
											
											
											

											
											
*											

















											
											
*******************************************************************************************************************************
************************************* NIGHT LIGHTS DATASET ********************************************************************
*******************************************************************************************************************************


/*

*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"

*/


**********************************************************************
***** Fixing errors found in raw night light files for year 2011 *****
**********************************************************************

/* Manual Step:  

Note that for running this code user must first create a folder titled as "2011_corrected" at 
location:  \Night Lights Dataset\Raw Data\2011_corrected      
User must also copy all the raw files as present in folder titled as "2011" into the "2011_corrected" folder.   

2011 folder : consists of raw files (which has some errors)

*/


global path_nl_2011 "$common_path\Independent variables\Night Lights Dataset\Raw Data\2011"


*declaring the file names of the districts for which changes need to be made
global dist_name "mainpuri lakhisarai uttar_dinajpu uttar_bastar_ junagadh east_godavari chikkaballap_"

display "$dist_name"


*using for loop to open file and make changes to district names and then saving it again

foreach file_var of global dist_name {
 
		set more off
		
		global modify_dist `file_var'
				
		use "$path_nl_2011\\$modify_dist.tif.vat.dta", clear
		
		display "making changes to $modify_dist.tif.vat.dta"
		
		tab district,mi
		
		*replacing district names of 2011 WITH SIMILAR NAMES as of 2004
		
		replace district = "Mainpuri" 		if "$modify_dist" == "mainpuri"
		replace district = "Lakhisarai" 	if "$modify_dist" == "lakhisarai"
		replace district = "Uttar_dinajpu" 	if "$modify_dist" == "uttar_dinajpu"
		replace district = "Uttar_bastar_" 	if "$modify_dist" == "uttar_bastar_"
		replace district = "Junagadh" 		if "$modify_dist" == "junagadh"
		replace district = "East_godavari" 	if "$modify_dist" == "east_godavari"
		replace district = "Chikkaballap_"  if "$modify_dist" == "chikkaballap_"
		
		*saving the file
		
		save "$common_path\Independent variables\Night Lights Dataset\Raw Data\2011_corrected\\$modify_dist.tif.vat.dta", replace
		clear

}
*


********************************************
*creating dataset for 2004, 2009 and 2011
********************************************



foreach i in "2004" "2009" "2011" {
			
			
			/*Please refer to following key for different district codes that we have assigned:

			*Multi-parent child .. assigned X same code as Y
			*A(Daughter district) is assigned same code as B(Parent district)
			**Correction to Komal's code
			*/

						
			set more off
			display "`i'"
			global nl_data_year `i'

			if ( $nl_data_year == 2004 | $nl_data_year == 2009 )  global nl_file_path "$common_path\\Independent variables\Night Lights Dataset\Raw Data\\$nl_data_year"

			if $nl_data_year == 2011  global nl_file_path "$common_path\Independent variables\Night Lights Dataset\Raw Data\2011_corrected"

			*accessing names of all the files present in the night light year folder
			cd "$nl_file_path"
			quietly fs
			
			
			
			*appending all the files for the night light year

			foreach district in `r(files)' {

				append using `district'

			}
			*
			
			
			*assigning state codes

			*creating state_name for night lights data... its a string variable
			gen State_Night_Lights_data=""

			*creating variable denoting state_code for each state.. its a numeric variable
			gen state=.


			*Himachal Pradesh 
			replace state=02 if (district=="Kangra"|district=="Mandi"|district=="Shimla"|district=="Solan"|district=="Sirmaur"|district=="Una"|district=="Chamba"| ///
			district=="Hamirpur_hp"|district=="Kullu"|district=="Bilaspur_hp"|district=="Kinnaur"|district=="Lahul_spiti")

			replace State_Night_Lights_data = "HIMACHAL PRADESH" if state== 02


			*Punjab

			replace state=03 if (district=="Ludhiana"|district=="Amritsar"|district=="Gurdaspur"|district=="Jalandhar"|district=="Firozpur"|district=="Patiala"|district=="Sangrur"| ///
			district=="Hoshiarpur"|district=="Bathinda"|district=="Tarn_taran"|district=="Moga"|district=="Muktsar"|district=="Kapurthala"|district=="Mansa"| district=="Rupnagar"| ///
			district=="Faridkot"|district=="Shahid_bhagat"|district=="Fatehgarh_sah"|district=="Barnala"|district=="Sahibzada_aji")

			replace State_Night_Lights_data = "PUNJAB" if state== 03

			*Uttaranchal/Uttarakhand

			replace state=05 if (district=="Hardwar"|district=="Dehradun"|district=="Udham_singh_n"|district=="Nainital"|district=="Garhwal"|district=="Almora"| ///
			district=="Tehri_garhwal"|district=="Pithoragarh"|district=="Chamoli"|district=="Uttarkashi"|district=="Bageshwar"|district=="Champawat"|district=="Rudraprayag")

			replace State_Night_Lights_data = "UTTARANCHAL" if state== 05


			*Haryana

			replace state=06 if (district=="Faridabad"|district=="Hisar"|district=="Bhiwani"|district=="Gurgaon"|district=="Karnal"|district=="Sonipat"|district=="Jind"| ///
			district=="Sirsa"|district=="Yamunanagar"|district=="Panipat"|district=="Ambala"|district=="Mewat"|district=="Kaithal"|district=="Rohtak"|district=="Palwal"| ///
			district=="Kurukshetra"|district=="Jhajjar"|district=="Fatehabad"|district=="Mahendragarh"|district=="Rewari"|district=="Panchkula")

			replace State_Night_Lights_data = "HARYANA" if state== 06


			*Delhi

			replace state=07 if (district=="North_west_de"|district=="South_delhi"|district=="West_delhi"|district=="South_west"|district=="North_east_de"|district=="East_delhi"| ///
			district=="North_delhi"|district=="Central_delhi"|district=="New_delhi")

			replace State_Night_Lights_data = "DELHI" if state== 07


			*Rajasthan

			replace state=08 if (district=="Jaipur"|district=="Jodhpur"|district=="Alwar"|district=="Nagaur"|district=="Udaipur"|district=="Sikar"|district=="Barmer"| ///
			district=="Ajmer"|district=="Bharatpur"|district=="Bhilwara"|district=="Bikaner"|district=="Jhunjhunun"|district=="Churu"|district=="Pali"|district=="Ganganagar"| ///
			district=="Kota"|district=="Jalor"|district=="Banswara"|district=="Hanumangarh"|district=="Dausa"|district=="Chittaurgarh"|district=="Karauli"|district=="Tonk"| ///
			district=="Jhalawar"|district=="Dungarpur"|district=="Sawai_madhopu"|district=="Baran"|district=="Dhaulpur"|district=="Rajsamand"|district=="Bundi"|district=="Sirohi"| ///
			district=="Pratapgarh_r"|district=="Jaisalmer") 

			replace State_Night_Lights_data = "RAJASTHAN" if state== 08


			*Uttar Pradesh

			replace state=09 if  (district=="Allahabad"|district=="Moradabad"|district=="Ghaziabad"|district=="Azamgarh"|district=="Lucknow"|district=="Kanpur_nagar"| ///
			district=="Kanpur_dehat"|district=="Jaunpur"|district=="Sitapur"|district=="Bareilly"|district=="Gorakhpur"|district=="Agra"|district=="Muzaffarnagar"| ///
			district=="Hardoi"|district=="Kheri"|district=="Sultanpur"|district=="Bijnor"|district=="Budaun"|district=="Varanasi"|district=="Aligarh"|district=="Ghazipur"| ///
			district=="Kushinagar"|district=="Bulandshahr"|district=="Bahraich"|district=="Saharanpur"|district=="Meerut"|district=="Gonda")

			replace state=09 if (district=="Rae_bareli"|district=="Bara_banki"|district=="Ballia"|district=="Pratapgarh_up"|district=="Unnao"|district=="Deoria"| ///
			district=="Shahjahanpur"|district=="Maharajganj"|district=="Fatehpur"|district=="Siddharth_nag"|district=="Mathura"|district=="Firozabad"| ///
			district=="Mirzapur"|district=="Faizabad"|district=="Basti"|district=="Ambedkarnagar"|district=="Rampur"|district=="Mau"|district=="Balrampur"|district=="Pilibhit"| ///
			district=="Jhansi"|district=="Chandauli"|district=="Farrukhabad"|district=="Mainpuri"|district=="Etawah"|district=="Sant_ravi_das"|district=="Mahamaya_naga"| ///
			district=="Kansiram_naga"|district=="Auraiya"|district=="Baghpat"|district=="Lalitpur"|district=="Shrawasti"|district=="Hamirpur_up"|district=="Chitrakoot"|district=="Mahoba")

			replace state=09 if (district=="Banda"|district=="Etah"|district=="Gautam_buddha"|district=="Jalaun"|district=="Jyotiba_phule"|district=="Kannauj"|district=="Kaushambi"| ///
			district=="Sant_kabir_na"|district=="Sonbhadra")

			replace State_Night_Lights_data = "UTTAR PRADESH" if state== 09


			*Bihar

			replace state=10 if (district=="Patna"|district=="Purba_champar"|district=="Muzaffarpur"|district=="Madhubani"|district=="Gaya"|district=="Samastipur"| ///
			district=="Saran_chhapra"|district=="Darbhanga"|district=="Pashchim_cham"|district=="Vaishali"|district=="Sitamarhi"|district=="Siwan"|district=="Purnia"| ///
			district=="Katihar"|district=="Bhagalpur"|district=="Begusarai"|district=="Rohtas"|district=="Nalanda"|district=="Araria"|district=="Bhojpur"|district=="Gopalganj"| ///
			district=="Aurangabad_b"|district=="Supaul"|district=="Nawada"|district=="Banka"|district=="Madhepura"|district=="Saharsa"|district=="Jamui"|district=="Buxar"| ///
			district=="Kishanganj"|district=="Khagaria"|district=="Kaimur_bhabua"|district=="Munger"|district=="Jehanabad"|district=="Lakhisarai"|district=="Arwal"| ///
			district=="Sheohar"|district=="Sheikhpura")

			replace State_Night_Lights_data = "BIHAR" if state== 10


			*Assam

			replace state=18 if (district=="Nagaon"|district=="Dhubri"|district=="Sonitpur"|district=="Cachar"|district=="Barpeta"|district=="Kamrup"|district=="Tinsukia"| ///
			district=="Dibrugarh"|district=="Kamrup_metrop"|district=="Karimganj"|district=="Sivasagar"|district=="Jorhat"|district=="Golaghat"|district=="Lakhimpur"| ///
			district=="Goalpara"|district=="Marigaon"|district=="Karbi_anglong"|district=="Baksa"|district=="Darrang"|district=="Kokrajhar"|district=="Udalguri"|district=="Nalbari"| ///
			district=="Bongaigaon"|district=="Dhemaji"|district=="Hailakandi"|district=="Chirang"|district=="Dima_hasao")

			replace State_Night_Lights_data = "ASSAM" if state== 18


			*West Bengal

			replace state=19 if (district=="North_24_parg"|district=="South_24_parg"|district=="Barddhaman"|district=="Murshidabad"|district=="Pashchim_medi"| ///
			district=="Hugli"|district=="Nadia"|district=="Purba_medinip"|district=="Haora"|district=="Kolkata"|district=="Maldah"|district=="Jalpaiguri"|district=="Bankura"| ///
			district=="Birbhum"|district=="Uttar_dinajpu"|district=="Puruliya"|district=="Koch_bihar"|district=="Darjiling"|district=="Dakshin_dinaj")

			replace State_Night_Lights_data = "WEST BENGAL" if state== 19



			*Jharkhand

			replace state=20 if (district=="Ranchi"|district=="Dhanbad"|district=="Giridih"|district=="Purbi_singhbh"|district=="Bokaro"|district=="Palamu"|district=="Hazaribagh"| ///
			district=="Pashchimi_sin"|district=="Deoghar"|district=="Garhwa"|district=="Dumka"|district=="Godda"|district=="Sahibganj"|district=="Saraikela_kha"|district=="Chatra"| ///
			district=="Gumla"|district=="Ramgarh"|district=="Pakur"|district=="Jamtara"|district=="Latehar"|district=="Kodarma"|district=="Simdega"|district=="Khunti"| ///
			district=="Lohardaga")

			replace State_Night_Lights_data = "JHARKHAND" if state== 20



			*Orissa

			replace state=21 if (district=="Ganjam"|district=="Cuttack"|district=="Mayurbhanj"|district=="Baleshwar"|district=="Khordha"|district=="Sundargarh"|district=="Jajapur"| ///
			district=="Kendujhar"|district=="Puri"|district=="Balangir"|district=="Kalahandi"|district=="Bhadrak"|district=="Bargarh"|district=="Kendrapara"|district=="Koraput"| ///
			district=="Anugul"|district=="Nabarangapur"|district=="Dhenkanal"|district=="Jagatsinghapu"|district=="Sambalpur"|district=="Rayagada"|district=="Nayagarh"| ///
			district=="Kandhamal"|district=="Malkangiri"|district=="Nuapada"|district=="Subarnapur"|district=="Jharsuguda"|district=="Gajapati"|district=="Bauda"|district=="Debagarh")

			replace State_Night_Lights_data = "ORISSA" if state== 21


			*Chhattisgarh

			replace state=22 if (district=="Raipur"|district=="Durg"|district=="Bilaspur_c"|district=="Surguja"|district=="Janjgir_champ"|district=="Rajnandgaon"| ///
			district=="Raigarh_c"|district=="Bastar"|district=="Korba"|district=="Mahasamund"|district=="Jashpur"|district=="Kabeerdham"|district=="Dhamtari"| ///
			district=="Uttar_bastar_"|district=="Koriya"|district=="Dakshin_basta"|district=="Bijapur_c"|district=="Narayanpur") //Kanker and dantewara not in night lights

			replace State_Night_Lights_data = "CHATTISGARH" if state== 22


			*Madhya Pradesh

			replace state=23 if (district=="Indore"|district=="Jabalpur"|district=="Sagar"|district=="Bhopal"|district=="Rewa"|district=="Satna"|district=="Dhar"| ///
			district=="Chhindwara"|district=="Gwalior"|district=="Ujjain"|district=="Morena"|district=="West_nimar"|district=="Chhatarpur"|district=="Shivpuri"|district=="Bhind"| ///
			district=="Balaghat"|district=="Betul"|district=="Dewas"|district=="Rajgarh"|district=="Shajapur"|district=="Vidisha"|district=="Ratlam"|district=="Tikamgarh"| ///
			district=="Barwani"|district=="Seoni"|district=="Mandsaur"|district=="Raisen"|district=="Sehore"|district=="East_nimar"|district=="Katni"|district=="Damoh"| ///
			district=="Guna"|district=="Hoshangabad"|district=="Singrauli"|district=="Sidhi"|district=="Narsimhapur"|district=="Shahdol"|district=="Mandla"|district=="Jhabua"| ///
			district=="Panna"|district=="Ashoknagar"|district=="Neemuch"|district=="Datia"|district=="Burhanpur"|district=="Anuppur"|district=="Alirajpur"|district=="Dindori"| ///
			district=="Sheopur"|district=="Umaria"|district=="Harda")

			replace State_Night_Lights_data = "MADHYA PRADESH" if state== 23



			*Gujarat

			replace state=24 if (district=="Ahmadabad"|district=="Surat"|district=="Vadodara"|district=="Rajkot"|district=="Banas_kantha"|district=="Bhavnagar"|district=="Junagadh"| ///
			district=="Sabar_kantha"|district=="Panch_mahals"|district=="Kheda"|district=="Jamnagar"|district=="Dohad"|district=="Anand"|district=="Kachchh"|district=="Mahesana"| ///
			district=="Surendranagar"|district=="Valsad"|district=="Bharuch"|district=="Amreli"|district=="Gandhinagar"|district=="Patan"|district=="Navsari"|district=="Tapi"| ///
			district=="Narmada"|district=="Porbandar"|district=="The_dangs")

			replace State_Night_Lights_data = "GUJARAT" if state== 24



			*Maharshtra

			replace state=27 if (district=="Thane"|district=="Pune"|district=="Mumbai_suburb"|district=="Nashik"|district=="Nagpur"|district=="Ahmadnagar"|district=="Solapur"| ///
			district=="Jalgaon"|district=="Kolhapur"|district=="Aurangabad_m"|district=="Nanded"|district=="Mumbai"|district=="Satara"|district=="Amravati"|district=="Sangli"| ///
			district=="Yavatmal"|district=="Raigarh_m"|district=="Buldana"|district=="Bid"|district=="Latur"|district=="Chandrapur"|district=="Dhule"|district=="Jalna"| ///
			district=="Parbhani"|district=="Akola"|district=="Osmanabad"|district=="Nandurbar"|district=="Ratnagiri"|district=="Gondiya"|district=="Wardha"|district=="Bhandara"| ///
			district=="Washim"|district=="Hingoli"|district=="Garhchiroli"|district=="Sindhudurg")

			replace State_Night_Lights_data = "MAHARASHTRA" if state== 27



			*Andhra Pradesh

			replace state=28 if (district=="Rangareddy"|district=="East_godavari"|district=="Guntur"|district=="Krishna"|district=="Visakhapatnam"|district=="Chittoor"| ///
			district=="Anantapur"|district=="Kurnool"|district=="Mahbubnagar"|district=="Hyderabad"|district=="West_godavari"| ///
			district=="Karimnagar"|district=="Warangal"|district=="Nalgonda"|district=="Prakasam"|district=="Medak"|district=="Sri_potti_sri"|district=="Ysr"|district=="Khammam"| ///
			district=="Adilabad"|district=="Srikakulam"|district=="Nizamabad"|district=="Vizianagaram")

			replace State_Night_Lights_data = "ANDHRA PRADESH" if state== 28



			*Karnataka

			replace state=29 if (district=="Bangalore"|district=="Belgaum"|district=="Mysore"|district=="Tumkur"|district=="Gulbarga"|district=="Bellary"|district=="Bijapur_k"| ///
			district=="Dakshina_kann"|district=="Davanagere"|district=="Raichur"|district=="Bagalkot"|district=="Dharwad"|district=="Mandya"|district=="Hassan"|district=="Shimoga"| ///
			district=="Bidar"|district=="Chitradurga"|district=="Haveri"|district=="Kolar"|district=="Uttara_kannad"|district=="Koppal"|district=="Chikkaballap_"|district=="Udupi"| ///
			district=="Yadgir"|district=="Chikmagalur"|district=="Ramanagara"|district=="Gadag"|district=="Chamrajnagar"|district=="Bangalore_rur"|district=="Kodagu")

			replace State_Night_Lights_data = "KARNATAKA" if state== 29



			*Kerala

			replace state=32 if (district=="Malappuram"|district=="Thiruvanantha"|district=="Ernakulam"|district=="Thrissur"|district=="Kozhikode"|district=="Palakkad"| ///
			district=="Kollam"|district=="Kannur"|district=="Alappuzha"|district=="Kottayam"|district=="Kasaragod"|district=="Pathanamthitt"|district=="Idukki"|district=="Wayanad")

			replace State_Night_Lights_data = "KERALA" if state== 32



			*Tamil Nadu

			replace state=33 if (district=="Chennai"|district=="Kancheepuram"|district=="Vellore"|district=="Thiruvallur"|district=="Salem"|district=="Viluppuram"|district=="Coimbatore"| ///
			district=="Tirunelveli"|district=="Madurai"|district=="Tiruchirappal"|district=="Cuddalore"|district=="Tiruppur"|district=="Tiruvannamala"|district=="Erode"| ///
			district=="Dindigul"|district=="Virudunagar"|district=="Krishnagiri"|district=="Kanniyakumari"|district=="Thoothukkudi"|district=="Namakkal"|district=="Pudukkottai"| ///
			district=="Nagappattinam"|district=="Dharmapuri"|district=="Ramanathapura"|district=="Sivaganga"|district=="Thiruvarur"|district=="Theni"|district=="Karur"| ///
			district=="Ariyalur"|district=="Perambalur"|district=="Thanjavur"|district=="The_nilgiris")

			replace State_Night_Lights_data = "TAMIL NADU" if state== 33



			*Chandigarh (NOT present in Komal's file)

			replace state=04 if district=="Chandigarh"

			sort state district


			************************************************************************************************************************************************************************
			************************************************************************************************************************************************************************



			****** Unique codes for districts *******

			*creating district code for each district 

			gen dist=.

			
			****Himachal Pradesh****

			replace dist=1 if district=="Chamba"
			replace dist=2 if district=="Kangra"
			replace dist=3 if district=="Lahul_spiti"
			replace dist=4 if district=="Kullu"
			replace dist=5 if district=="Mandi"
			replace dist=6 if district=="Hamirpur_hp"
			replace dist=7 if district=="Una"
			replace dist=8 if district=="Bilaspur_hp"
			replace dist=9 if district=="Solan"
			replace dist=10 if district=="Sirmaur"
			replace dist=11 if district=="Shimla"
			replace dist=12 if district=="Kinnaur"

			****Punjab****

			replace dist=1 if district=="Gurdaspur"
			replace dist=2 if district=="Amritsar"
			replace dist=3 if district=="Kapurthala"
			replace dist=4 if district=="Jalandhar"
			replace dist=5 if district=="Hoshiarpur"
			replace dist=6 if district=="Shahid_bhagat"
			replace dist=7 if district=="Rupnagar"
			replace dist=8 if district=="Fatehgarh_sah"
			replace dist=9 if district=="Ludhiana"
			replace dist=10 if district=="Moga"
			replace dist=11 if district=="Firozpur"
			replace dist=12 if district=="Muktsar"
			replace dist=13 if district=="Faridkot"
			replace dist=14 if district=="Bathinda"
			replace dist=15 if district=="Mansa"
			replace dist=16 if district=="Sangrur"
			replace dist=17 if district=="Patiala"

			*Multi-parent child .. assigned Mohali (Sahibzada Ajit Singh) same code as Rupnagar 
			replace dist=7 if district=="Sahibzada_aji"

			* Barnala (Daughter district) is assigned same code as Sangrur (Parent district)
			replace dist=16 if district=="Barnala"

			* taran-taran (Daughter district) is assigned same code as Amritsar (Parent district)
			replace dist=2 if district=="Tarn_taran"




			****Uttarakhand****

			replace dist=1 if district=="Uttarkashi"
			replace dist=2 if district=="Chamoli"
			replace dist=3 if district=="Rudraprayag"
			replace dist=4 if district=="Tehri_garhwal"
			replace dist=5 if district=="Dehradun"
			replace dist=6 if district=="Garhwal"
			replace dist=7 if district=="Pithoragarh"

			* bageshwar and champwat code has to be exhanged as per NSS-61 level
			replace dist=10 if district=="Bageshwar"

			replace dist=9 if district=="Almora"

			* bageshwar and champwat code has to be exhanged as per NSS-61 level
			replace dist=8 if district=="Champawat"

			replace dist=11 if district=="Nainital"
			replace dist=12 if district=="Udham_singh_n"
			replace dist=13 if district=="Hardwar"



			****Haryana****

			replace dist=1 if district=="Panchkula"
			replace dist=2 if district=="Ambala"
			replace dist=3 if district=="Yamunanagar"
			replace dist=4 if district=="Kurukshetra"
			replace dist=5 if district=="Kaithal"
			replace dist=6 if district=="Karnal"
			replace dist=7 if district=="Panipat"
			replace dist=8 if district=="Sonipat"
			replace dist=9 if district=="Jind"
			replace dist=10 if district=="Fatehabad"
			replace dist=11 if district=="Sirsa"
			replace dist=12 if district=="Hisar"
			replace dist=13 if district=="Bhiwani"
			replace dist=14 if district=="Rohtak"
			replace dist=15 if district=="Jhajjar"
			replace dist=16 if district=="Mahendragarh"
			replace dist=17 if district=="Rewari"
			replace dist=18 if district=="Gurgaon"
			replace dist=19 if district=="Faridabad"

			* Mewat (Daughter district) is assigned same code as Gurgaon (Parent district)
			replace dist=18 if district=="Mewat"




			****Delhi****

			replace dist=1 if district=="North_west_de"
			replace dist=2 if district=="North_delhi"
			replace dist=3 if district=="North_east_de"
			replace dist=4 if district=="East_delhi"
			replace dist=5 if district=="New_delhi"
			replace dist=6 if district=="Central_delhi"
			replace dist=7 if district=="West_delhi"
			replace dist=8 if district=="South_west"
			replace dist=9 if district=="South_delhi"




			****Rajasthan****

			replace dist=1 if district=="Ganganagar"
			replace dist=2 if district=="Hanumangarh"
			replace dist=3 if district=="Bikaner"
			replace dist=4 if district=="Churu"
			replace dist=5 if district=="Jhunjhunun"
			replace dist=6 if district=="Alwar"
			replace dist=7 if district=="Bharatpur"
			replace dist=8 if district=="Dhaulpur"
			replace dist=9 if district=="Karauli"
			replace dist=10 if district=="Sawai_madhopu"
			replace dist=11 if district=="Dausa"
			replace dist=12 if district=="Jaipur"
			replace dist=13 if district=="Sikar"
			replace dist=14 if district=="Nagaur"
			replace dist=15 if district=="Jodhpur"
			replace dist=16 if district=="Jaisalmer"
			replace dist=17 if district=="Barmer"
			replace dist=18 if district=="Jalor"
			replace dist=19 if district=="Sirohi"
			replace dist=20 if district=="Pali"
			replace dist=21 if district=="Ajmer"
			replace dist=22 if district=="Tonk"
			replace dist=23 if district=="Bundi"
			replace dist=24 if district=="Bhilwara"
			replace dist=25 if district=="Rajsamand"
			replace dist=26 if district=="Udaipur"
			replace dist=27 if district=="Dungarpur"
			replace dist=28 if district=="Banswara"
			replace dist=29 if district=="Chittaurgarh"
			replace dist=30 if district=="Kota"
			replace dist=31 if district=="Baran"
			replace dist=32 if district=="Jhalawar"




			****Uttar Pradesh****

			replace dist=1 if district=="Saharanpur"
			replace dist=2 if district=="Muzaffarnagar"
			replace dist=3 if district=="Bijnor"
			replace dist=4 if district=="Moradabad"
			replace dist=5 if district=="Rampur"
			replace dist=6 if district=="Jyotiba_phule"
			replace dist=7 if district=="Meerut"
			replace dist=8 if district=="Baghpat"
			replace dist=9 if district=="Ghaziabad"
			replace dist=10 if district=="Gautam_buddha"
			replace dist=11 if district=="Bulandshahr"
			replace dist=12 if district=="Aligarh"
			replace dist=13 if district=="Mahamaya_naga"
			replace dist=14 if district=="Mathura"
			replace dist=15 if district=="Agra"
			replace dist=16 if district=="Firozabad"
			replace dist=17 if district=="Etah"
			replace dist=18 if district=="Mainpuri"
			replace dist=19 if district=="Budaun"
			replace dist=20 if district=="Bareilly"
			replace dist=21 if district=="Pilibhit"
			replace dist=22 if district=="Shahjahanpur"
			replace dist=23 if district=="Kheri"
			replace dist=24 if district=="Sitapur"
			replace dist=25 if district=="Hardoi"
			replace dist=26 if district=="Unnao"
			replace dist=27 if district=="Lucknow"
			replace dist=28 if district=="Rae_bareli"
			replace dist=29 if district=="Farrukhabad"
			replace dist=30 if district=="Kannauj"
			replace dist=31 if district=="Etawah"
			replace dist=32 if district=="Auraiya"
			replace dist=33 if district=="Kanpur_dehat"
			replace dist=34 if district=="Kanpur_nagar"
			replace dist=35 if district=="Jalaun"
			replace dist=36 if district=="Jhansi"
			replace dist=37 if district=="Lalitpur"
			replace dist=38 if district=="Hamirpur_up"
			replace dist=39 if district=="Mahoba"
			replace dist=40 if district=="Banda"
			replace dist=41 if district=="Chitrakoot"
			replace dist=42 if district=="Fatehpur"
			replace dist=43 if district=="Pratapgarh_up"
			replace dist=44 if district=="Kaushambi"
			replace dist=45 if district=="Allahabad"
			replace dist=46 if district=="Bara_banki"
			replace dist=47 if district=="Faizabad"
			replace dist=48 if district=="Ambedkarnagar"
			replace dist=49 if district=="Sultanpur"
			replace dist=50 if district=="Bahraich"
			replace dist=51 if district=="Shrawasti"
			replace dist=52 if district=="Balrampur"
			replace dist=53 if district=="Gonda"
			replace dist=54 if district=="Siddharth_nag"
			replace dist=55 if district=="Basti"
			replace dist=56 if district=="Sant_kabir_na"
			replace dist=57 if district=="Maharajganj"
			replace dist=58 if district=="Gorakhpur"
			replace dist=59 if district=="Kushinagar"
			replace dist=60 if district=="Deoria"
			replace dist=61 if district=="Azamgarh"
			replace dist=62 if district=="Mau"
			replace dist=63 if district=="Ballia"
			replace dist=64 if district=="Jaunpur"
			replace dist=65 if district=="Ghazipur"
			replace dist=66 if district=="Chandauli"
			replace dist=67 if district=="Varanasi"
			replace dist=68 if district=="Sant_ravi_das"
			replace dist=69 if district=="Mirzapur"
			replace dist=70 if district=="Sonbhadra"

			* Kashiram nagar/ kansiram nagar (Daughter district) is assigned same code as Etah (Parent district)
			replace dist=17 if district=="Kansiram_naga"




			****Bihar****

			replace dist=1 if district=="Pashchim_cham"
			replace dist=2 if district=="Purba_champar"
			replace dist=3 if district=="Sheohar"
			replace dist=4 if district=="Sitamarhi"
			replace dist=5 if district=="Madhubani"
			replace dist=6 if district=="Supaul"
			replace dist=7 if district=="Araria"
			replace dist=8 if district=="Kishanganj"
			replace dist=9 if district=="Purnia"
			replace dist=10 if district=="Katihar"
			replace dist=11 if district=="Madhepura"
			replace dist=12 if district=="Saharsa"
			replace dist=13 if district=="Darbhanga"
			replace dist=14 if district=="Muzaffarpur"
			replace dist=15 if district=="Gopalganj"
			replace dist=16 if district=="Siwan"
			replace dist=17 if district=="Saran_chhapra"
			replace dist=18 if district=="Vaishali"
			replace dist=19 if district=="Samastipur"
			replace dist=20 if district=="Begusarai"
			replace dist=21 if district=="Khagaria"
			replace dist=22 if district=="Bhagalpur"
			replace dist=23 if district=="Banka"
			replace dist=24 if district=="Munger"
			replace dist=25 if district=="Lakhisarai"
			replace dist=26 if district=="Sheikhpura"
			replace dist=27 if district=="Nalanda"
			replace dist=28 if district=="Patna"
			replace dist=29 if district=="Bhojpur"
			replace dist=30 if district=="Buxar"
			replace dist=31 if district=="Kaimur_bhabua"
			replace dist=32 if district=="Rohtas"
			replace dist=33 if district=="Jehanabad"
			replace dist=34 if district=="Aurangabad_b"
			replace dist=35 if district=="Gaya"
			replace dist=36 if district=="Nawada"
			replace dist=37 if district=="Jamui"

			* Arwal (Daughter district) is assigned same code as Jehanabad (Parent district)
			replace dist=33 if district=="Arwal"




			****Assam****

			replace dist=1 if district=="Kokrajhar"
			replace dist=2 if district=="Dhubri"
			replace dist=3 if district=="Goalpara"
			replace dist=4 if district=="Bongaigaon"
			replace dist=5 if district=="Barpeta"
			replace dist=6 if district=="Kamrup"
			replace dist=7 if district=="Nalbari"
			replace dist=8 if district=="Darrang"
			replace dist=9 if district=="Marigaon"
			replace dist=10 if district=="Nagaon"
			replace dist=11 if district=="Sonitpur"
			replace dist=12 if district=="Lakhimpur"
			replace dist=13 if district=="Dhemaji"
			replace dist=14 if district=="Tinsukia"
			replace dist=15 if district=="Dibrugarh"
			replace dist=16 if district=="Sivasagar"
			replace dist=17 if district=="Jorhat"
			replace dist=18 if district=="Golaghat"
			replace dist=19 if district=="Karbi_anglong"

			*Correction to Komal's code : spelling mistake
			replace dist=20 if district=="Dima_hasao"


			replace dist=21 if district=="Cachar"
			replace dist=22 if district=="Karimganj"
			replace dist=23 if district=="Hailakandi"

			*Multi-parent child .. assigned Chirang same code as Bongaigaon
			replace dist=4 if district=="Chirang"

			*Multi-parent child .. assigned Baksa same code as Barpeta
			replace dist=5 if district=="Baksa"

			* Kamrup Metropolitan / Guwahati (Daughter district) is assigned same code as undivided Kamrup district (Parent district)
			replace dist=6 if district=="Kamrup_metrop"

			* Udalgiri (Daughter district) is assigned same code as Darrang (BTC) (Parent district)
			replace dist=8 if district=="Udalguri"







			****West Bengal****

			replace dist=1 if district=="Darjiling"
			replace dist=2 if district=="Jalpaiguri"
			replace dist=3 if district=="Koch_bihar"
			replace dist=4 if district=="Uttar_dinajpu"
			replace dist=5 if district=="Dakshin_dinaj"
			replace dist=6 if district=="Maldah"
			replace dist=7 if district=="Murshidabad"
			replace dist=8 if district=="Birbhum"
			replace dist=9 if district=="Barddhaman"
			replace dist=10 if district=="Nadia"
			replace dist=11 if district=="North_24_parg"
			replace dist=12 if district=="Hugli"
			replace dist=13 if district=="Bankura"
			replace dist=14 if district=="Puruliya"
			replace dist=15 if district=="Pashchim_medi"
			replace dist=16 if district=="Haora"
			replace dist=17 if district=="Kolkata"
			replace dist=18 if district=="South_24_parg"

			* Purba medinipur (Daughter district) is assigned same code as old medinipur / paschim medinipur (Parent district)
			replace dist=15 if district=="Purba_medinip"





			****Jharkhand****

			replace dist=1 if district=="Garhwa"
			replace dist=2 if district=="Palamu"
			replace dist=3 if district=="Chatra"
			replace dist=4 if district=="Hazaribagh"
			replace dist=5 if district=="Kodarma"
			replace dist=6 if district=="Giridih"
			replace dist=7 if district=="Deoghar"
			replace dist=8 if district=="Godda"
			replace dist=9 if district=="Sahibganj"
			replace dist=10 if district=="Pakur"
			replace dist=11 if district=="Dumka"
			replace dist=12 if district=="Dhanbad"
			replace dist=13 if district=="Bokaro"
			replace dist=14 if district=="Ranchi"
			replace dist=15 if district=="Lohardaga"
			replace dist=16 if district=="Gumla"
			replace dist=17 if district=="Pashchimi_sin"
			replace dist=18 if district=="Purbi_singhbh"

			* Latehar (Daughter district) is assigned same code as Palamau (Parent district)
			replace dist=2 if district=="Latehar"

			* Simdega (Daughter district) is assigned same code as Gumla (Parent district)
			replace dist=16 if district=="Simdega"

			* Jamtara (Daughter district) is assigned same code as Dumka (Parent district)
			replace dist=11 if district=="Jamtara"

			* Saraikela kharsawan(Daughter district) is assigned same code as west/paschimi singhbhum (Parent district)
			replace dist=17 if district=="Saraikela_kha"






			***Orissa***

			replace dist=1 if district=="Bargarh"
			replace dist=2 if district=="Jharsuguda"
			replace dist=3 if district=="Sambalpur"
			replace dist=4 if district=="Debagarh"
			replace dist=5 if district=="Sundargarh"
			replace dist=6 if district=="Kendujhar"
			replace dist=7 if district=="Mayurbhanj"
			replace dist=8 if district=="Baleshwar"
			replace dist=9 if district=="Bhadrak"
			replace dist=10 if district=="Kendrapara"
			replace dist=11 if district=="Jagatsinghapu"
			replace dist=12 if district=="Cuttack"
			replace dist=13 if district=="Jajapur"
			replace dist=14 if district=="Dhenkanal"
			replace dist=15 if district=="Anugul"
			replace dist=16 if district=="Nayagarh"
			replace dist=17 if district=="Khordha"
			replace dist=18 if district=="Puri"
			replace dist=19 if district=="Ganjam"
			replace dist=20 if district=="Gajapati"
			replace dist=21 if district=="Kandhamal"
			replace dist=22 if district=="Bauda"
			replace dist=23 if district=="Subarnapur"
			replace dist=24 if district=="Balangir"
			replace dist=25 if district=="Nuapada"
			replace dist=26 if district=="Kalahandi"
			replace dist=27 if district=="Rayagada"
			replace dist=28 if district=="Nabarangapur"
			replace dist=29 if district=="Koraput"
			replace dist=30 if district=="Malkangiri"




			***Chhattisgarh****

			replace dist=1 if district=="Koriya"
			replace dist=2 if district=="Surguja"
			replace dist=3 if district=="Jashpur"
			replace dist=4 if district=="Raigarh_c"
			replace dist=5 if district=="Korba"
			replace dist=6 if district=="Janjgir_champ"
			replace dist=7 if district=="Bilaspur_c"
			replace dist=8 if district=="Kabeerdham"		  // also known as kawardha	
			replace dist=9 if district=="Rajnandgaon"
			replace dist=10 if district=="Durg"
			replace dist=11 if district=="Raipur"
			replace dist=12 if district=="Mahasamund"
			replace dist=13 if district=="Dhamtari"
			replace dist=14 if district=="Uttar_bastar_"	  // also known as kanker	
			replace dist=15 if district=="Bastar"
			replace dist=16 if district=="Dakshin_basta"      // also known as Dantewada


			* Narayanpur (Daughter district) is assigned same code as Bastar (Parent district)
			replace dist=15 if district=="Narayanpur"

			* Bijapur (Daughter district) is assigned same code as Dakshin Bastar/Dantewada (Parent district)
			replace dist=16 if district=="Bijapur_c"




			****Madhya Pradesh****

			replace dist=1 if district=="Sheopur"
			replace dist=2 if district=="Morena"
			replace dist=3 if district=="Bhind"
			replace dist=4 if district=="Gwalior"
			replace dist=5 if district=="Datia"
			replace dist=6 if district=="Shivpuri"
			replace dist=7 if district=="Guna"
			replace dist=8 if district=="Tikamgarh"
			replace dist=9 if district=="Chhatarpur"
			replace dist=10 if district=="Panna"
			replace dist=11 if district=="Sagar"
			replace dist=12 if district=="Damoh"
			replace dist=13 if district=="Satna"
			replace dist=14 if district=="Rewa"
			replace dist=15 if district=="Umaria"
			replace dist=16 if district=="Shahdol"
			replace dist=17 if district=="Sidhi"
			replace dist=18 if district=="Neemuch"
			replace dist=19 if district=="Mandsaur"
			replace dist=20 if district=="Ratlam"
			replace dist=21 if district=="Ujjain"
			replace dist=22 if district=="Shajapur"
			replace dist=23 if district=="Dewas"
			replace dist=24 if district=="Jhabua"
			replace dist=25 if district=="Dhar"
			replace dist=26 if district=="Indore"
			replace dist=27 if district=="West_nimar"
			replace dist=28 if district=="Barwani"
			replace dist=29 if district=="East_nimar"
			replace dist=30 if district=="Rajgarh"
			replace dist=31 if district=="Vidisha"
			replace dist=32 if district=="Bhopal"
			replace dist=33 if district=="Sehore"
			replace dist=34 if district=="Raisen"
			replace dist=35 if district=="Betul"
			replace dist=36 if district=="Harda"
			replace dist=37 if district=="Hoshangabad"
			replace dist=38 if district=="Katni"
			replace dist=39 if district=="Jabalpur"
			replace dist=40 if district=="Narsimhapur"
			replace dist=41 if district=="Dindori"
			replace dist=42 if district=="Mandla"
			replace dist=43 if district=="Chhindwara"
			replace dist=44 if district=="Seoni"
			replace dist=45 if district=="Balaghat"

			* Ashoknagar (Daughter district) is assigned same code as Guna (Parent district)
			replace dist=7 if district=="Ashoknagar"

			* Anuppur (Daughter district) is assigned same code as Shahdol (Parent district)
			replace dist=16 if district=="Anuppur"

			* Burhanpur (Daughter district) is assigned same code as Khandwa/East Nimar(Parent district)
			replace dist=29 if district=="Burhanpur"

			* Singrauli (Daughter district) is assigned same code as Sidhi (Parent district)
			replace dist=17 if district=="Singrauli"

			* Alirajpur (Daughter district) is assigned same code as jhabua (Parent district)
			replace dist=24 if district=="Alirajpur"




			****Gujarat****

			replace dist=1 if district=="Kachchh"
			replace dist=2 if district=="Banas_kantha"
			replace dist=3 if district=="Patan"
			replace dist=4 if district=="Mahesana"
			replace dist=5 if district=="Sabar_kantha"
			replace dist=6 if district=="Gandhinagar"
			replace dist=7 if district=="Ahmadabad"
			replace dist=8 if district=="Surendranagar"
			replace dist=9 if district=="Rajkot"
			replace dist=10 if district=="Jamnagar"
			replace dist=11 if district=="Porbandar"
			replace dist=12 if district=="Junagadh"
			replace dist=13 if district=="Amreli"
			replace dist=14 if district=="Bhavnagar"
			replace dist=15 if district=="Anand"
			replace dist=16 if district=="Kheda"
			replace dist=17 if district=="Panch_mahals"
			replace dist=18 if district=="Dohad"
			replace dist=19 if district=="Vadodara"
			replace dist=20 if district=="Narmada"
			replace dist=21 if district=="Bharuch"
			replace dist=22 if district=="Surat"
			replace dist=23 if district=="The_dangs"
			replace dist=24 if district=="Navsari"
			replace dist=25 if district=="Valsad"




			****Maharashtra****

			replace dist=1 if district=="Nandurbar"
			replace dist=2 if district=="Dhule"
			replace dist=3 if district=="Jalgaon"
			replace dist=4 if district=="Buldana"
			replace dist=5 if district=="Akola"
			replace dist=6 if district=="Washim"
			replace dist=7 if district=="Amravati"
			replace dist=8 if district=="Wardha"
			replace dist=9 if district=="Nagpur"
			replace dist=10 if district=="Bhandara"
			replace dist=11 if district=="Gondiya"
			replace dist=12 if district=="Garhchiroli"
			replace dist=13 if district=="Chandrapur"
			replace dist=14 if district=="Yavatmal"
			replace dist=15 if district=="Nanded"
			replace dist=16 if district=="Hingoli"
			replace dist=17 if district=="Parbhani"
			replace dist=18 if district=="Jalna"
			replace dist=19 if district=="Aurangabad_m"
			replace dist=20 if district=="Nashik"
			replace dist=21 if district=="Thane"
			replace dist=22 if district=="Mumbai_suburb"
			replace dist=23 if district=="Mumbai"
			replace dist=24 if district=="Raigarh_m"
			replace dist=25 if district=="Pune"
			replace dist=26 if district=="Ahmadnagar"
			replace dist=27 if district=="Bid"
			replace dist=28 if district=="Latur"
			replace dist=29 if district=="Osmanabad"
			replace dist=30 if district=="Solapur"
			replace dist=31 if district=="Satara"
			replace dist=32 if district=="Ratnagiri"
			replace dist=33 if district=="Sindhudurg"
			replace dist=34 if district=="Kolhapur"
			replace dist=35 if district=="Sangli"




			****Andhra Pradesh****

			replace dist=1 if district=="Adilabad"
			replace dist=2 if district=="Nizamabad"
			replace dist=3 if district=="Karimnagar"
			replace dist=4 if district=="Medak"
			replace dist=5 if district=="Hyderabad"
			replace dist=6 if district=="Rangareddy"
			replace dist=7 if district=="Mahbubnagar"
			replace dist=8 if district=="Nalgonda"
			replace dist=9 if district=="Warangal"
			replace dist=10 if district=="Khammam"
			replace dist=11 if district=="Srikakulam"
			replace dist=12 if district=="Vizianagaram"
			replace dist=13 if district=="Visakhapatnam"
			replace dist=14 if district=="East_godavari"
			replace dist=15 if district=="West_godavari"
			replace dist=16 if district=="Krishna"
			replace dist=17 if district=="Guntur"
			replace dist=18 if district=="Prakasam"


			**Correction to Komal's code : nellore full name is SRI POTTI SRIRAMULU NELLORE

			*replace dist=19 if district=="Nellore"
			replace dist=19 if district=="Sri_potti_sri"


			replace dist=20 if district=="Ysr"
			replace dist=21 if district=="Kurnool"
			replace dist=22 if district=="Anantapur"
			replace dist=23 if district=="Chittoor"




			****Karnataka****

			replace dist=1 if district=="Belgaum"
			replace dist=2 if district=="Bagalkot"
			replace dist=3 if district=="Bijapur_k"
			replace dist=4 if district=="Gulbarga"
			replace dist=5 if district=="Bidar"
			replace dist=6 if district=="Raichur"
			replace dist=7 if district=="Koppal"
			replace dist=8 if district=="Gadag"
			replace dist=9 if district=="Dharwad"
			replace dist=10 if district=="Uttara_kannad"
			replace dist=11 if district=="Haveri"
			replace dist=12 if district=="Bellary"
			replace dist=13 if district=="Chitradurga"
			replace dist=14 if district=="Davanagere"
			replace dist=15 if district=="Shimoga"
			replace dist=16 if district=="Udupi"
			replace dist=17 if district=="Chikmagalur"
			replace dist=18 if district=="Tumkur"
			replace dist=19 if district=="Kolar"
			replace dist=20 if district=="Bangalore"
			replace dist=21 if district=="Bangalore_rur"
			replace dist=22 if district=="Mandya"
			replace dist=23 if district=="Hassan"
			replace dist=24 if district=="Dakshina_kann"
			replace dist=25 if district=="Kodagu"
			replace dist=26 if district=="Mysore"
			replace dist=27 if district=="Chamrajnagar"

			* Ramanagara (Daughter district) is assigned same code as Banglore Rural district (Parent district)
			replace dist=21 if district=="Ramanagara"

			* Chikkaballapura (Daughter district) is assigned same code as Kolar  (Parent district)
			*replace dist=19 if district=="Chikkaballap_"

			*Correction to Komal's code : spelling mistake  & Chikkaballapura (Daughter district) is assigned same code as Kolar  (Parent district)
			replace dist=19 if district=="Chikkaballap_"

			*assigning state code of Karnataka for chikkabalipurram
			replace state=29 if district=="Chikkaballap_"

			replace State_Night_Lights_data="KARNATAKA" if district=="Chikkaballap_"


			****Kerala****

			replace dist=1 if district=="Kasaragod"
			replace dist=2 if district=="Kannur"
			replace dist=3 if district=="Wayanad"
			replace dist=4 if district=="Kozhikode"
			replace dist=5 if district=="Malappuram"
			replace dist=6 if district=="Palakkad"
			replace dist=7 if district=="Thrissur"
			replace dist=8 if district=="Ernakulam"
			replace dist=9 if district=="Idukki"
			replace dist=10 if district=="Kottayam"
			replace dist=11 if district=="Alappuzha"
			replace dist=12 if district=="Pathanamthitt"
			replace dist=13 if district=="Kollam"
			replace dist=14 if district=="Thiruvanantha"



			****Tamil Nadu****

			replace dist=1 if district=="Thiruvallur"
			replace dist=2 if district=="Chennai"
			replace dist=3 if district=="Kancheepuram"
			replace dist=4 if district=="Vellore"
			replace dist=5 if district=="Dharmapuri"
			replace dist=6 if district=="Tiruvannamala"
			replace dist=7 if district=="Viluppuram"
			replace dist=8 if district=="Salem"
			replace dist=9 if district=="Namakkal"
			replace dist=10 if district=="Erode"
			replace dist=11 if district=="The_nilgiris"
			replace dist=12 if district=="Coimbatore"
			replace dist=13 if district=="Dindigul"
			replace dist=14 if district=="Karur"
			replace dist=15 if district=="Tiruchirappal"
			replace dist=16 if district=="Perambalur"
			replace dist=17 if district=="Ariyalur"
			replace dist=18 if district=="Cuddalore"
			replace dist=19 if district=="Nagappattinam"
			replace dist=20 if district=="Thiruvarur"
			replace dist=21 if district=="Thanjavur"
			replace dist=22 if district=="Pudukkottai"
			replace dist=23 if district=="Sivaganga"
			replace dist=24 if district=="Madurai"
			replace dist=25 if district=="Theni"
			replace dist=26 if district=="Virudunagar"
			replace dist=27 if district=="Ramanathapura"
			replace dist=28 if district=="Thoothukkudi"
			replace dist=29 if district=="Tirunelveli"
			replace dist=30 if district=="Kanniyakumari"

			*adding this district since it was missing from Komal's file

			* Krishnagiri (Daughter district) is assigned same code as Dharmapuri (Parent district)
			replace dist=5 if district=="Krishnagiri"




			*Chandigarh (NOT present in Komal's file)

			replace dist=01 if district=="Chandigarh"
			replace State_Night_Lights_data="CHANDIGARH" if district=="Chandigarh"


			********************************************************************************************************


			/*correcting district codes for which a STATE code is getting assigned but are NOT getting a district code, 
			these are mostly new districts being formed out of old
			Ideally they should also be assigned code as of their parent district */

			*formed from Ranchi-Jharkhand
			replace dist=14 if district=="Khunti"

			*formed from Faridabad-haryana
			replace dist= 19 if district=="Palwal"

			*Multi-parent child .. assigned Pratapgarh same code as Chittaurgarh
			replace dist=29  if district=="Pratapgarh_r"

			*formed from hazaribagh-jharkhand
			replace dist=04  if district=="Ramgarh"

			*formed from surat-gujarat
			replace dist=22  if district=="Tapi"

			*Multi-parent child .. assigned Tiruppur same code as Coimbatore
			replace dist=12  if district=="Tiruppur"

			*formed  from Gulbarga-karnataka
			replace dist=04  if district=="Yadgir"


			************************************************************************************************************



			*converting district name into upper case

			sort state dist

			gen District_Night_Lights_data = upper(district)


			******* Generate unique code for each district *********

			tostring state, replace
			replace state="0"+state if length(state)==1
			tostring dist,replace
			replace dist="0"+dist if length(dist)==1
			egen uniqdist=concat(state dist)



			********************************
			*checking for few more discrepencies


			*districts for which district code is not getting assigned
			tab district if dist=="0." & state!="0." & state!="01" & state!="30"   //leaving out J&K and Goa

			*districts for which state code is not getting assigned
			tab district if dist!="0." & state=="0." & state!="01" & state!="30"   //leaving out J&K and Goa



			*dropping UNWANTED districts

			count if state=="0." & dist=="0."
			drop if state=="0." & dist=="0."

			**********************************




			********* IMPORTANT: please make input for the old variable which has information about district codes  *********


			destring uniqdist, replace
			global old_dist_code_var "uniqdist"


			*running the program which has codes for all the district groups that we have formed
			program_replace_dist_code $old_dist_code_var




			******* Generate per unit square kilometer night light for each district *********

			gen area=(count*0.86) // Convert pixels into square kilometers
			gen night_light=(value*area) // Multiply value for each square kilometer by the frequency


			bysort dist_code_after_group: egen total_dist_area_$nl_data_year = total(area) // Sum the area covered for each district. This should give the area of each district in aquare kilometers
			bysort dist_code_after_group: egen total_nl_$nl_data_year = total(night_light) // Sum the total intensity of night light recorded for each district
			bysort dist_code_after_group: gen avg_nl_$nl_data_year = (total_nl_$nl_data_year) / (total_dist_area_$nl_data_year ) // Normalize this total by the area of the respective district.


			count if dist_code_after_group ==. 
			count if uniqdist ==. 


			*dropping unncesary variables
			drop district state dist

			*ordering the dataset
			order State_Night_Lights_data District_Night_Lights_data uniqdist dist_code_after_group, first


			*dropping duplicate values
			duplicates drop dist_code_after_group, force // Keep only one value for each district


			*renaming variables

			rename uniqdist uniqdist_night_light
			rename value value_night_light
			rename count count_night_light
			rename area area_night_light
			rename total_dist_area_$nl_data_year total_dist_area_night_light_$nl_data_year


			*saving the database
			save "$common_path\Independent variables\Night Lights Dataset\Processed Data\Year wise data\night_lights_$nl_data_year.dta", replace

			clear

}
*




*****************************************************************
******* appending 2004,2009 ans 2011 night-light datasets ******* 
*****************************************************************



use "$common_path\Independent variables\Night Lights Dataset\Processed Data\Year wise data\night_lights_2004.dta", clear

global nl_dataset_2009 "$common_path\Independent variables\Night Lights Dataset\Processed Data\Year wise data\night_lights_2009.dta"
global nl_dataset_2011 "$common_path\Independent variables\Night Lights Dataset\Processed Data\Year wise data\night_lights_2011.dta"

append using "$nl_dataset_2009" "$nl_dataset_2011" , gen (year_nl)


*generating a common variable which has information for average night-light intensity for all districts and across 2004,09 and 11

gen avg_nl_data = .

replace avg_nl_data = avg_nl_2004 if year_nl == 0
replace avg_nl_data = avg_nl_2009 if year_nl == 1
replace avg_nl_data = avg_nl_2011 if year_nl == 2


replace year_nl = 2004 if year_nl==0
replace year_nl = 2009 if year_nl==1
replace year_nl = 2011 if year_nl==2


label var avg_nl_2004 "key variable: info for average night-light intensity for 2004"
label var avg_nl_2009 "key variable: info for average night-light intensity for 2009"
label var avg_nl_2011 "key variable: info for average night-light intensity for 2011"

label var avg_nl_data "key variable: info for avg night light for all years & districts"


*saving the database
save "$common_path\Independent variables\Night Lights Dataset\Processed Data\Year wise data\night_lights_data_2004_09_11.dta", replace


clear

**********************************************












											************************************
											******* END OF LAST DATASET ********
											************************************
											
											
							





							
							
							
							
							
							
							




											
											
*******************************************************************************************************************************
************************************* BANK BRANCHES DATASET *******************************************************************
*******************************************************************************************************************************


/*

*user needs to input the common_path as per path where the project folder is saved on her machine
*running a do file consisting of some programs 
		
set more off
global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

global path_program_file "$common_path\Supporting Files\Global variable and Programs file 15022018.do"
run "$path_program_file"

*/



***************************************
********* BRANCH OPEN DATASET *********
***************************************



**** Step 1 ***

*creating pin code dataset

*global pin_code_path "C:\Users\PPRU-7\Dropbox\Arka Tridip Sir Project\Data work\Original Datasets\Arka sent\Oct 4"

global pin_code_excel "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Raw Data\All_India_pincode_data_18082017.csv"

import delimited using "$pin_code_excel"

display _N
count if pincode==.

tostring pincode, generate(pincode_1)

gen pincode_2=trim(pincode_1)

gen test =1 if pincode_2==pincode_1
replace test=0 if pincode_2!=pincode_1 
count if test==0

drop pincode_1 test pincode

destring pincode_2, generate(pincode)  
drop pincode_2 


drop officename officetype deliverystatus

duplicates tag, generate(dup)

display _N

preserve
duplicates drop pincode, force
display "unique number of pincodes are"  
display _N
restore

display _N

duplicates drop pincode, force 
duplicates tag, generate(dup_1)
list pincode if dup_1!=0

drop dup dup_1
describe pincode


label var pincode "Pin code from Pin code dataset" 
label var divisionname "Divison name from Pin code dataset" 
label var regionname "Region name from Pin code dataset" 
label var circlename "circle name from Pin code dataset" 
label var taluk "Taluk name from Pin code dataset" 
label var districtname " District name from Pin code dataset"  
label var statename " State name from Pin code dataset" 

save "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 1\pin_code_data 05102017 1630.dta", replace
clear


******************************
******************************




**** Step 2 ***

*missing_district_pin_code_reconcilation_17102017 1715.do &&& creating_exception_district_dataset_17102017 1310.do used  combined

*merging branch open excel file with pin code dataset


global branch_open_excel "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Raw Data\MOF_Data2.xlsx"
global pin_code_data "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 1\pin_code_data 05102017 1630.dta"


set more off
import excel using "$branch_open_excel", firstrow

order Address, last
gen address_1 =trim(Address)
gen address_2 =subinstr(address_1, ", , , ," ,"", 2)

gen pin_code_1=substr(address_2, -6 , 6)
gen pin_code_2=trim(pin_code_1) 

destring pin_code_2, generate(pincode) force 
describe pincode


//merging data from pin code dataset
merge m:1 pincode using "$pin_code_data"

save "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 2\branch_open_pin_code_merged_data 09102017.dta", replace



*****************************************
** dealing with exceptional districts (who got multiple parents) 
*****************************************

global district_except_path "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 2\Multi Parent District Text File"






*****************************************************
****** now analysis for Amethi (Uttar Pradesh)
*****************************************************

*finding total #branches mapped
count if District== "AMETHI" & _merge==3

tab District districtname if District== "AMETHI" & _merge==3  

*finding total #branches from Master data which are NOT mapped
count if District== "AMETHI" & _merge==1


listtab District Center Address pincode districtname BankGroup Bank Part1Code Part2Code taluk _merge if District== "AMETHI" & _merge==1 using "$district_except_path\Amethi missing brach information 10102017 1500.txt", rstyle(tabdelim) replace





*****************************************************
***** now analysis for Tiruppur (Tamil Nadu)
*****************************************************

*finding total #branches mapped
count if District== "TIRUPPUR" & _merge==3

tab District districtname if District== "TIRUPPUR" & _merge==3  

*finding total #branches from Master data which are NOT mapped
count if District== "TIRUPPUR" & _merge==1


listtab District Center Address pincode districtname BankGroup Bank Part1Code Part2Code taluk _merge if District== "TIRUPPUR" & _merge==1 using "$district_except_path\Tiruppur missing brach information 11102017 1155.txt", rstyle(tabdelim) replace

*br District Center Address pincode districtname taluk _merge if District== "TIRUPPUR"






*****************************************************
***** now analysis for Morbi (Gujarat)
*****************************************************


*finding total #branches mapped
count if District== "MORBI" & _merge==3

tab District districtname if District== "MORBI" & _merge==3  

*finding total #branches from Master data which are NOT mapped
count if District== "MORBI" & _merge==1

listtab District Center Address pincode districtname BankGroup Bank Part1Code Part2Code taluk _merge if District== "MORBI" & _merge==1 using "$district_except_path\Morbi missing brach information 11102017 1506.txt", rstyle(tabdelim) replace


*****************************************************
***** now analysis for MAHISAGAR (Gujarat)
*****************************************************

*load branch_open_pin_code_merged_data 09102017 
*use "C:\Users\PPRU-7\Dropbox\Arka Tridip Sir Project\Data work\Shadab files\Data sets created\Branch Open Dataset\branch_open_pin_code_merged_data 09102017.dta", clear


*finding total #branches mapped
count if District== "MAHISAGAR" & _merge==3

tab District districtname if District== "MAHISAGAR" & _merge==3  

*finding total #branches from Master data which are NOT mapped
count if District== "MAHISAGAR" & _merge==1


listtab District Center Address pincode districtname BankGroup Bank Part1Code Part2Code taluk _merge if District== "MAHISAGAR" & _merge==1 using "$district_except_path\Mahisagar missing brach information 11102017 1612.txt", rstyle(tabdelim) replace



*****************************************************
***** now analysis for BOTAD (Gujarat)
*****************************************************

*load branch_open_pin_code_merged_data 09102017 
*use "C:\Users\abc\Dropbox\Arka Tridip Sir Project\Data work\Shadab files\Data sets created\Branch Open Dataset\branch_open_pin_code_merged_data 09102017.dta", clear

global except_district "BOTAD"

*finding total #branches mapped
count if District== "$except_district" & _merge==3

tab District districtname if District== "$except_district" & _merge==3  

*finding total #branches from Master data which are NOT mapped
count if District== "$except_district" & _merge==1


listtab District Center Address pincode districtname BankGroup Bank Part1Code Part2Code taluk _merge if District== "$except_district" & _merge==1 using "$district_except_path\ $except_district missing brach information 12102017.txt", rstyle(tabdelim) replace


*****************************************************
***** now analysis for BHIM NAGAR (Uttar Pradesh)
*****************************************************

*load branch_open_pin_code_merged_data 09102017 
*use "C:\Users\abc\Dropbox\Arka Tridip Sir Project\Data work\Shadab files\Data sets created\Branch Open Dataset\branch_open_pin_code_merged_data 09102017.dta", clear

global except_district "BHIM NAGAR"

*finding total #branches mapped
count if District== "$except_district" & _merge==3

tab District districtname if District== "$except_district" & _merge==3  

*finding total #branches from Master data which are NOT mapped
count if District== "$except_district" & _merge==1

*br District Center Address pincode districtname taluk _merge if District== "$except_district"

listtab District Center Address pincode districtname BankGroup Bank Part1Code Part2Code taluk _merge if District== "$except_district" & _merge==1 using "$district_except_path\ $except_district missing brach information 12102017.txt", rstyle(tabdelim) replace




*****************************************************
***** now analysis for PRATAPGARH (RAJASTHAN)
*****************************************************

*load branch_open_pin_code_merged_data 09102017 
*use "C:\Users\\$dropbox_mach_name\Dropbox\Arka Tridip Sir Project\Data work\Shadab files\Data sets created\Branch Open Dataset\branch_open_pin_code_merged_data 09102017.dta", clear



global except_district "PRATAPGARH"

*finding total #branches mapped
count if District== "$except_district" & _merge==3 & State=="RAJASTHAN"

tab District districtname if District== "$except_district" & _merge==3 & State=="RAJASTHAN"    

*finding total #branches from Master data which are NOT mapped
count if District== "$except_district" & _merge==1 & State=="RAJASTHAN"  

*br District Center Address pincode districtname taluk _merge if District== "$except_district"

listtab State District Center Address pincode districtname BankGroup Bank Part1Code Part2Code taluk _merge if District== "$except_district" & _merge==1 & State=="RAJASTHAN"  using "$district_except_path\ $except_district missing brach information 16102017.txt", rstyle(tabdelim) replace

clear


**************************************************
** creating STATA datasets out of Excel files
**************************************************

global districtexcel "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 2\Multi Parent District Excel File"  
global districtstata "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 2\Multi Parent District STATA File"  


foreach i in "Amethi" "Bhim_Nagar" "Botad" "Mahisagar" "Morbi" "Pratapgarh" "Tiruppur" {


		import excel using "$districtexcel\\`i'.xlsx", firstrow

		save "$districtstata\\`i'.dta", replace



		clear

}
*


*merging so far created branch open and pin code dataset with exceptional (multi-parent) districts

use "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 2\branch_open_pin_code_merged_data 09102017.dta", clear

set more off
drop if _merge==2
rename _merge _merge_after_pincode_dataset
destring Part1Code, replace
destring Part2Code, replace



foreach i in "Amethi" "Bhim_Nagar" "Botad" "Mahisagar" "Morbi" "Pratapgarh" "Tiruppur" {

	merge 1:1 District Center Address Part1Code Part2Code using "$districtstata\\`i'.dta", keepusing(districtname) update  
	
	rename _merge _merge_with_`i'
		
}
*

rename _merge_with_Bhim_Nagar _merge_with_BHIM_NAGAR
rename _merge_with_Pratapgarh _merge_with_PRATAPGARH_RAJASTHAN



save "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 2\branch_open_exception_district_included 17102017 1505.dta", replace
clear






***************************************************************************************************************************
***************************************************************************************************************************






************ Step 3 **************

**Final_Opening_Branch_file_Exceptional_district_manual_corrections 20112017.do code used


*loading dataset created in Step 2
use "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 2\branch_open_exception_district_included 17102017 1505.dta", clear



***************making manual corrections to the (wrong) mapping happeneing due to WRONG pin-code entered by BANK EMPLOYEES ***************


*Amethi:

replace districtname="Sultanpur" if District=="AMETHI" & districtname=="Pratapgarh" & Center=="SANGRAMPUR" & State=="UTTAR PRADESH"  

*http://pincodes.info/in/Uttar-Pradesh/Sultanpur/Amethi/Sangrampur-Amethi/
*https://pincode.net.in/UTTAR_PRADESH/PRATAPGARH/S/SANGRAMPUR

*****************************************
*Tiruppur:

replace districtname="Erode" if District== "TIRUPPUR" & districtname=="Ernakulam" & Center=="VELLAKOIL" & State=="TAMIL NADU"    
*https://pincode.net.in/TAMIL_NADU/ERODE/V/VELLAKOIL


replace districtname="Coimbatore" if District== "TIRUPPUR" & districtname=="Thanjavur" & Center=="TIRUPPUR" & State=="TAMIL NADU"   
*2 branches address is that of given in Tiruppur



replace districtname="Erode" if District== "TIRUPPUR" & districtname=="Dindigul" & Center=="KANNIVADI" & State=="TAMIL NADU"   
*hhttp://www.onefivenine.com/india/bank/ifsccode/CNRB0001605

replace districtname="Coimbatore" if District== "TIRUPPUR" & districtname=="Dindigul" & Center=="MADATHUKULAM" & State=="TAMIL NADU"   
*http://www.mapsofindia.com/pincode/india/tamil-nadu/coimbatore/madathukulam.html



*****************************************
*Morbi:

*No problem
*****************************************

*Mahisagar:

replace districtname="Panch Mahals" if District== "MAHISAGAR" & districtname=="Dahod" & Center=="BATAKWADA" & State=="GUJARAT"

*https://www.mapsofindia.com/villages/gujarat/panch-mahals/santrampur/batakwada.html
*http://1min.in/indiapost/pincode/389172
*389172 PinCode of Santrampur, Dahod, Gujarat


replace districtname="Panch Mahals" if District== "MAHISAGAR" & districtname=="Dahod" & Center=="GOTHIB" & State=="GUJARAT"  
*http://www.onefivenine.com/india/villages/Panch-Mahals/Santrampur/Gothib
*389190 PinCode of Fatepura, Dahod, Gujarat

replace districtname="Panch Mahals" if District== "MAHISAGAR" & districtname=="Dahod" & Center=="KHEDAYA ALIAS PRATAPGADH" & State=="GUJARAT"  
*http://www.onefivenine.com/india/villages/Panch-Mahals/Santrampur/Khedaya-Alias-Pratapgadh


replace districtname="Panch Mahals" if District== "MAHISAGAR" & districtname=="Dahod" & Center=="SIMALIYA (SANTRAMPUR)" & State=="GUJARAT"
*http://www.onefivenine.com/india/villages/Panch-Mahals/Santrampur/Simaliya

*****************************************

*Botad

*No problem

*****************************************

*BHIM NAGAR

replace districtname="Moradabad" if District== "BHIM NAGAR" & districtname=="Jyotiba Phule Nagar" & Center=="ASMOLI" & State=="UTTAR PRADESH" 
*https://www.mapsofindia.com/villages/uttar-pradesh/moradabad/sambhal/asmoli.html

replace districtname="Moradabad" if District== "BHIM NAGAR" & districtname=="Jyotiba Phule Nagar" & Center=="BABU KHERA" & State=="UTTAR PRADESH" 
*https://villageinfo.in/uttar-pradesh/moradabad/sambhal/babu-khera.html

replace districtname="Moradabad" if District== "BHIM NAGAR" & districtname=="Jyotiba Phule Nagar" & Center=="BHAWALPUR WASLI" & State=="UTTAR PRADESH" 
*https://villageinfo.in/uttar-pradesh/moradabad/sambhal/bhawalpur-wasli.html

replace districtname="Moradabad" if District== "BHIM NAGAR" & districtname=="Jyotiba Phule Nagar" & Center=="DEHPA" & State=="UTTAR PRADESH" 
*https://www.mapsofindia.com/villages/uttar-pradesh/moradabad/sambhal/dehpa.html

replace districtname="Moradabad" if District== "BHIM NAGAR" & districtname=="Jyotiba Phule Nagar" & Center=="MADALA FATEHPUR" & State=="UTTAR PRADESH"  
*https://www.mapsofindia.com/villages/uttar-pradesh/moradabad/sambhal/madala-fatehpur.html

replace districtname="Moradabad" if District== "BHIM NAGAR" & districtname=="Jyotiba Phule Nagar" & Center=="MANAUTA" & State=="UTTAR PRADESH" 
*https://villageinfo.in/uttar-pradesh/moradabad/sambhal/manauta.html

*****************************************

*Pratapgarh, Rajasthan
*No problem, except need to correct spelling for chittorgarh and make Banswara in capitals

set more off
tab districtname if State=="RAJASTHAN" & District== "PRATAPGARH"
//need to correct spelling for chittorgarh and make Banswara in capitals

*****************************************


*finding information for exceptional districts

set more off

tab districtname if District== "AMETHI" & _merge_after_pincode_dataset==3  // _merge=3 gives us branches which were mapped through pincode file
tab districtname if District== "AMETHI" & _merge_after_pincode_dataset==1  // _merge=1 gives us branches which we mapped manually
*need to correct spelling for Raiebarelli

tab districtname if District== "TIRUPPUR" & _merge_after_pincode_dataset==3 
tab districtname if District== "TIRUPPUR" & _merge_after_pincode_dataset==1

tab districtname if District== "MORBI" & _merge_after_pincode_dataset==3 
tab districtname if District== "MORBI" & _merge_after_pincode_dataset==1
 
tab districtname if District== "MAHISAGAR" & _merge_after_pincode_dataset==3 
tab districtname if District== "MAHISAGAR" & _merge_after_pincode_dataset==1

tab districtname if District== "BOTAD" & _merge_after_pincode_dataset==3
tab districtname if District== "BOTAD" & _merge_after_pincode_dataset==1

tab districtname if District== "BHIM NAGAR" & _merge_after_pincode_dataset==3 
tab districtname if District== "BHIM NAGAR" & _merge_after_pincode_dataset==1 

tab districtname if State=="RAJASTHAN" & District== "PRATAPGARH" & _merge_after_pincode_dataset==3 
tab districtname if State=="RAJASTHAN" & District== "PRATAPGARH" & _merge_after_pincode_dataset==1 
*need to correct spelling for chittorgarh and make Banswara in capitals





***************************************************************************************************************************


*generating NSS District variable for mapping all the districts 

*here District variable is the district belonging to RBI file
gen NSS_district= District 



/* replacing the mapped values (which consists of branches which got mapped by the pin-code dataset merging
as well as those for which we made manual changes after internet search
*/

*bringing info for exceptional districts for 7 districts

*here districtname is the district name as obtained from pin-code merge as well as after internet search and manually mapping it

replace NSS_district= upper(districtname) if District=="AMETHI" & State=="UTTAR PRADESH"
replace NSS_district= upper(districtname) if District== "TIRUPPUR" & State=="TAMIL NADU"
replace NSS_district= upper(districtname) if District== "MORBI" & State=="GUJARAT"
replace NSS_district= upper(districtname) if District== "MAHISAGAR" & State=="GUJARAT"
replace NSS_district= upper(districtname) if District== "BOTAD" & State=="GUJARAT"
replace NSS_district= upper(districtname) if District== "BHIM NAGAR" & State=="UTTAR PRADESH"
replace NSS_district= upper(districtname) if District== "PRATAPGARH" & State=="RAJASTHAN"

*IMPORTANT: correcting for spelling mistake for Amethi (raibareli) and Morbi(Surendranagr)
replace NSS_district= "RAI BARELI" if District=="AMETHI" & districtname=="Raebareli"
replace NSS_district= "RAI BARELI" if District=="AMETHI" & districtname=="Raibareli"
 
replace NSS_district= "SURENDRANAGAR" if District=="MORBI" & districtname=="Surendra Nagar"

tab NSS_district if District=="AMETHI"
tab NSS_district if District=="MORBI"

*correcting for Chitttaurgarh

tab NSS_district if District== "PRATAPGARH" & State=="RAJASTHAN"

replace NSS_district= "CHITTAURGARH" if NSS_district=="CHITTORGARH" & District== "PRATAPGARH" & State=="RAJASTHAN" 
tab NSS_district if District== "PRATAPGARH" & State=="RAJASTHAN"


*we are getting correct things 

*br State District pincode districtname NSS_district Address if District=="PRATAPGARH" & State=="RAJASTHAN"
*br State District pincode districtname NSS_district Address if District=="AMETHI"


***************************************************************************************************************************



*renaming variables since we need to run district code mapping file

rename District District_RBI_branch_open
rename NSS_district District


*checking in case Tiruppur / Pratapgarh are present... answer it is not present
tab District if State=="RAJASTHAN"
tab District if State=="TAMIL NADU"


*running the NSS norm 61 district code mapping file created by us

run "$common_path\Supporting Files\district_codes_mapping_file 09112017.do"


*running statedrop.do file for states
run "$common_path\Supporting Files\statedrop modified 15122017.do"


count if district_code==.
tab District_RBI_branch_open if district_code==.

*duplicates examples State District_RBI_branch_open District if district_code==.



*renaming variables of the entire datset

rename SNo SNo_RBI_branch_open
rename Region Region_RBI_branch_open
rename State State_RBI_branch_open

rename Center Center_RBI_branch_open
rename BankGroup BankGroup_RBI_branch_open
rename Bank Bank_RBI_branch_open
rename Branch Branch_RBI_branch_open
rename Part1Code Part1Code_RBI_branch_open
rename Part2Code Part2Code_RBI_branch_open
rename PopulationGroup PopulationGroup_RBI_branch_open
rename DateofOpen DateofOpen_RBI_branch_open
rename ADCategory ADCategory_RBI_branch_open
rename LicenseNo LicenseNo_RBI_branch_open
rename LicenseDate LicenseDate_RBI_branch_open
rename BranchOffice BranchOffice_RBI_branch_open
rename Address Address_RBI_branch_open
rename address_1 address_1_RBI_branch_open
rename address_2 address_2_RBI_branch_open
rename pin_code_1 pin_code_1_RBI_branch_open
rename pin_code_2 pin_code_2_RBI_branch_open

rename divisionname divisionname_pin_code_excel_file
rename regionname regionname_pin_code_excel_file
rename circlename circlename_pin_code_excel_file
rename taluk taluk_pin_code_excel_file
rename districtname districtname_pin_code_excel_file
rename statename statename_pin_code_excel_file



*labelling important variables

label var District "main district var which has parent districts name, used for mapping district codes"

label var Address_RBI_branch_open "original address, used for extracting pin-code of branches"
label var address_1_RBI_branch_open "ignore this intermediate address"
label var address_2_RBI_branch_open "ignore this intermediate address"
label var pin_code_1_RBI_branch_open "ignore this intermediate pincode"
label var pin_code_2_RBI_branch_open "ignore this intermediate pincode"

label var pincode "original pincode, based on which branch open and pincode datset was merged"

label var districtname_pin_code_excel_file "district name from pic code dataset"
label var statename_pin_code_excel_file "state name from pic code dataset"




save "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 3\branch_open_clean_dataset 20112017.dta", replace
clear

******************************************************








*****************************************************************************
*****************************************************************************






***************************************
********* BRANCH CLOSE DATASET ********
***************************************


*Creating closed branches dataset


*importing Excel file of closed branches 

set more off

global branch_close_data "$common_path\Independent variables\Branch Operating Dataset\Branch Close\Raw Data\20160308_closed_branches_final-1.xlsx"
import excel using "$branch_close_data", firstrow 


rename statenm State
rename DSTNM District  


*running state_drop.do code to drop unwanted states

display "number of rows BEFORE dropping unwanted states"
display _N


run "$common_path\Supporting Files\statedrop modified 15122017.do"


display "number of rows AFTER dropping unwanted states"
display _N


*running district mapping file created after normalization as per NSS-61 round
run "$common_path\Supporting Files\district_codes_mapping_file 09112017.do"

count if district_code==.
list District if district_code==.



*manipulating branches closed dataset

gen branch_close_date_str_length= length(dtclose)
tab branch_close_date_str_length

gen branch_close_year = substr(dtclose,1,4)

gen branch_close_year_str_length= length(branch_close_year)
tab branch_close_year_str_length

destring branch_close_year, generate(close_year)
order dtclose branch_close_year close_year, last

*summarize close year
su close_year




*creating a tag (binary variable) to indentify if an individual branch got closed till a particular year  

forvalues i = 1975(1)2016{
gen closed_by_`i' = 0
replace closed_by_`i' = 1 if close_year < `i'
}
*


*summing across NSS-61 normlaized district codes
*finding sum of all branches that got closed by a partiuclar year for each district_code

forvalues i = 1975(1)2016{
bys district_code: egen closed_branches_`i' = total(closed_by_`i')
}
*


*to check if closing year is in reasonable range
su close_year
count if close_year==. 


*need to rename important variables

rename State State_closed_dataset
rename District District_closed_dataset

*need to relabel all important variables

forvalues i = 1975(1)2016{

label var closed_branches_`i' "#branches closed in the district_code by year `i'"

}
*



*** generating population type

tab ppg

gen pop_type = "RURAL" if ppg=="1) RURAL"
replace pop_type = "URBAN" if ppg=="2) SEMI-URBAN" || ppg=="3) URBAN" || ppg=="4) METROPOLITAN"

tab pop_type, mi 

label var pop_type "identifies whether closed branch is located in rural/urban area"



set more off 

forvalues i=1975(1)2016{

bysort district_code pop_type: egen pop_branch_closed_`i' = total(closed_by_`i')
label var pop_branch_closed_`i' "#branches closed in area defined by ..pop_type.. uptil `i'"   

}
*

forvalues i=1975(1)2016{

bysort district_code: gen rural_branch_interim_closed_`i' = pop_branch_closed_`i' if pop_type == "RURAL"
bysort district_code: gen urban_branch_interim_closed_`i' = pop_branch_closed_`i' if pop_type == "URBAN"

bysort district_code: egen rural_branch_closed_`i' = max(rural_branch_interim_closed_`i') 
bysort district_code: egen urban_branch_closed_`i' = max(urban_branch_interim_closed_`i') 

label var rural_branch_closed_`i' "#branches closed in rural areas uptil `i'"   
label var urban_branch_closed_`i' "#branches closed in urban areas uptil `i'"   

}
*


*dropping irrelevent variables 

forvalues i=1975/2016{

drop closed_by_`i' 
drop rural_branch_interim_closed_`i'
drop urban_branch_interim_closed_`i'

}
*


*droping duplicate district codes since we are interested in only #branches closed by each year and not when individual branches got closed
*otherwise we wouldn't be able to merge dataset with open brnach dataset

duplicates report district_code

duplicates drop district_code, force




*saving the branch close dataset
save "$common_path\Independent variables\Branch Operating Dataset\Branch Close\Processed Data\branch_close_dataset_21062018.dta", replace
clear






**************************************************
**************************************************





*******************************************
********* BRANCH OPERATING DATASET ********
*******************************************


*creating # branches operating (or present) in a district.. main idea is to subtract (#branch open - # branch closed) in a district


******************** loading Branch-open database ********************

use "$common_path\Independent variables\Branch Operating Dataset\Branch Open\Step 3\branch_open_clean_dataset 20112017.dta", clear
set more off


*creating Open_Year variable

gen Open_Year= substr(DateofOpen,-4,.)
destring Open_Year, replace

//sense check
su Open_Year
count if Open_Year==.



*then running Senjuti's code

*generating a marker whether a branch got opened before that year

forvalues i = 1975(1)2016{
gen open_by_`i' = 0
replace open_by_`i' = 1 if Open_Year < `i'
}
*

*generating sum of all branches opened before that year for each district code

forvalues i = 1975(1)2016{
bys district_code: egen open_branches_`i' = total(open_by_`i')
}
*


**************************************************************************************
*******finding rural and urban branches that got opened uptil a particular year*******
**************************************************************************************

***June 21, 2018

gen pop_branch_open_type = "URBAN" if PopulationGroup_RBI_branch_open=="Metropolitan" ||  PopulationGroup_RBI_branch_open=="Semi-urban" || PopulationGroup_RBI_branch_open=="Urban"
replace pop_branch_open_type = "RURAL" if PopulationGroup_RBI_branch_open=="Rural"
label var pop_branch_open_type "identifies whether opened branch is located in RURAL/URBAN area"

tab pop_branch_open_type


*finding # branches opened in population type uptil a particular year

forvalues i = 1975(1)2016{

bysort district_code pop_branch_open_type : egen open_pop_branches_`i' = total(open_by_`i')
label var open_pop_branches_`i' "#branches opened in area defined by ..pop_branch_open_type.. uptil `i'"   

}
*


*finding # branches opened in RURAL and URBAN areas uptil a particular year

forvalues i = 1975(1)2016{

set more off


 
gen rural_branch_interim_open_`i' =.  
replace rural_branch_interim_open_`i' = open_pop_branches_`i' if pop_branch_open_type=="RURAL"
label var rural_branch_interim_open_`i' "#branches opened in rural areas uptil `i'"   


gen urban_branch_interim_open_`i' =.  
replace urban_branch_interim_open_`i' = open_pop_branches_`i' if pop_branch_open_type=="URBAN"
label var urban_branch_interim_open_`i' "#branches opened in urban areas uptil `i'"

}
*


forvalues i = 1975(1)2016 {

bysort district_code : egen rural_branch_open_`i' = max(rural_branch_interim_open_`i')
label var rural_branch_open_`i' "#branches opened in rural areas uptil `i'"   
drop rural_branch_interim_open_`i' 
 
bysort district_code : egen urban_branch_open_`i' = max(urban_branch_interim_open_`i') 
label var urban_branch_open_`i' "#branches opened in urban areas uptil `i'"   
drop urban_branch_interim_open_`i'

}
*



**************************************************
******** DROPING duplicate district codes  ********
**************************************************


*since we are interested in only #branches opened by each year and not in individual branches
* we also need to do the same since we are merging dataset based on district codes

display _N 
duplicates drop district_code, force
display _N


*labelling important varaibles

label var Open_Year "opening year of branch"


forvalues i = 1975(1)2016{

label var open_by_`i' "marking if branch opened by `i'"

label var open_branches_`i' "#branches opened in district by `i'"

}
*

*dropping individual bank marker

forvalues i = 1975/2016{
	
	drop open_by_`i'

}
*



******************************************************
**********  merging branch_close data  ***************
******************************************************


global closed_branch_dataset "$common_path\Independent variables\Branch Operating Dataset\Branch Close\Processed Data\branch_close_dataset_21062018.dta"
merge 1:1 district_code using "$closed_branch_dataset"


*assigning zero value for all those districts (present in master: branch opening data) where no branches ever got closed
*actually there are missing values present for closed branches for all such districts
*hence we are replacing them with zero

forvalues i = 1975(1)2016{

set more off
replace closed_branches_`i' = 0 if _merge==1
replace rural_branch_closed_`i'=0 if _merge==1
replace urban_branch_closed_`i'=0 if _merge==1

/*replacing missing values with zero in urban/rural area where branch never got closed otherwise we don't get any branch operating even
when we have non negative branches operating over there*/

replace rural_branch_closed_`i'=0 if rural_branch_closed_`i'==.
replace urban_branch_closed_`i'=0 if urban_branch_closed_`i'==.

*replacing missing values with zero in urban/rural area where branch never got OPENED otherwise we get missing operating branches (instead of ZERO)

replace rural_branch_open_`i'=0 if rural_branch_open_`i'==. 
replace urban_branch_open_`i'=0 if urban_branch_open_`i'==.


}
*


*finding #branches present in a district at a particular year (#opened branches -#closed branches at a given year)

forvalues i = 1975(1)2016{

set more off

gen branches_`i' = open_branches_`i'- closed_branches_`i'
gen branches_rural_`i' = rural_branch_open_`i' - rural_branch_closed_`i'
gen branches_urban_`i' = urban_branch_open_`i' - urban_branch_closed_`i'

}
*


*label branches variable present in the dataset

forvalues i=1975/2016 {
	
label var branches_`i' "#bank branches operating in `i'"
label var branches_rural_`i' "#rural bank branches operating in `i'"
label var branches_urban_`i' "#urban bank branches operating in `i'"
}
*


*checking whether the branches present in overall , rural and urban areas have any missing values

forvalues i=1975/2016 {

count if branches_`i'== . 

}
*

forvalues i=1975/2016 {

display "missing values rural branches for `i'"
count if branches_rural_`i'== . 

}
*

forvalues i=1975/2016 {

display "missing values urban branches for `i'"
count if branches_urban_`i'== . 

}
*


rename _merge _merge_branch_open_with_closed


****************************************************************************************************


******** DISTRICT GROUPING : now assiging district code for various groups that we have formed ********

*please make input for the old variable which has information about district codes
global old_dist_code_var "district_code"

program_replace_dist_code $old_dist_code_var


*creating open, closed and bank branches offices after district grouping


*finding number of branches opened in the district group

forvalues year = 1975/2016 { 

	bysort dist_code_after_group: egen open_branch_dist_grp_`year' = total(open_branches_`year')
	label var open_branch_dist_grp_`year' "#branches opened as per district group in `year'"
	
	bysort dist_code_after_group: egen open_rural_branch_dist_grp_`year' = total(rural_branch_open_`year')
	label var open_rural_branch_dist_grp_`year' "#branches opened in rural area as per district group in `year'"
	
	bysort dist_code_after_group: egen open_urban_branch_dist_grp_`year' = total(urban_branch_open_`year')
	label var open_urban_branch_dist_grp_`year' "#branches opened in urban area as per district group in `year'"
}
*



*finding number of branches closed in the district group

forvalues year = 1975/2016 { 

    bysort dist_code_after_group: egen closed_branch_dist_grp_`year' = total(closed_branches_`year')
	label var closed_branch_dist_grp_`year' "#branches closed as per district group in `year'"
	
	bysort dist_code_after_group: egen closed_rur_branch_dist_grp_`year' = total(rural_branch_closed_`year')
	label var closed_rur_branch_dist_grp_`year' "#branches closed  in rural areas as per district group in `year'"
	
	bysort dist_code_after_group: egen closed_urb_branch_dist_grp_`year' = total(urban_branch_closed_`year')
	label var closed_urb_branch_dist_grp_`year' "#branches closed  in rural areas as per district group in `year'"
	
}
*



*finding number of branches operating in the district group

forvalues year = 1975/2016 { 

	bysort dist_code_after_group: egen branches_dist_grp_`year' = total(branches_`year')
	label var branches_dist_grp_`year' "#branches operating as per district group in `year'"
	
	bysort dist_code_after_group: egen branches_rural_dist_grp_`year' = total(branches_rural_`year')
	label var branches_rural_dist_grp_`year' "#branches operating in rural area as per district group in `year'"
	
	bysort dist_code_after_group: egen branches_urban_dist_grp_`year' = total(branches_urban_`year')
	label var branches_urban_dist_grp_`year' "#branches operating in urban area as per district group in `year'"
	
}
*



*finding missing and negative values for operating bank branches 

forvalues i=1975/2016 {

set more off

display "missing values of TOTAL branches for `i'"
count if branches_`i'== . | branches_`i' < 0

display ""
display "missing values rural branches for `i'"
count if branches_rural_`i' == . | branches_rural_`i' < 0

display ""
display "missing values urban branches for `i'"
count if branches_urban_`i' == . | branches_urban_`i' < 0

display ""
display ""
display ""


}
*

*this can be checked using
*br district_code dist_code_after_group open_branches_2006  open_pop_branches_2006  rural_branch_open_2006  urban_branch_open_2006  closed_branches_2006  pop_branch_closed_2006  rural_branch_closed_2006  urban_branch_closed_2006  branches_2006  branches_rural_2006  branches_urban_2006  open_branch_dist_grp_2006  open_rural_branch_dist_grp_2006  open_urban_branch_dist_grp_2006  closed_branch_dist_grp_2006  closed_rur_branch_dist_grp_2006  closed_urb_branch_dist_grp_2006  branches_dist_grp_2006  branches_rural_dist_grp_2006  branches_urban_dist_grp_2006 if branches_rural_dist_grp_2006 < 0



	
*IMP: dropping duplicate districts arising due to group formation

duplicates report $old_dist_code_var
duplicates report dist_code_after_group

duplicates drop dist_code_after_group, force
duplicates report dist_code_after_group


****************************************************************************************************************
**** Averages for each 9-year period (when each individual in the treatment and control groups was 17-25)*******
****************************************************************************************************************


forvalues i = 1975(1)2008{

	local k1 = `i' + 1
	local k2 = `i' + 2
	local k3 = `i' + 3
	local k4 = `i' + 4
	local k5 = `i' + 5
	local k6 = `i' + 6
	local k7 = `i' + 7
	local k8 = `i' + 8
	
	gen branches_avg_`i' = (branches_dist_grp_`k1'+branches_dist_grp_`k2'+branches_dist_grp_`k3'+branches_dist_grp_`k4'+branches_dist_grp_`k5'+branches_dist_grp_`k6'+branches_dist_grp_`k7'+branches_dist_grp_`k8'+ branches_dist_grp_`i')/9
	
	label var branches_avg_`i' "#average branches operating between (`i',`i'+9yr) for year `i'"  
	
	
}
*


*saving new dataset
save "$common_path\Independent variables\Branch Operating Dataset\district_wise_branch_dataset.dta", replace
clear


log close


