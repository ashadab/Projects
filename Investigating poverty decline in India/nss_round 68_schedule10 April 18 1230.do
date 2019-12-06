log using "E:\Shadab\UBC Project\NSS Data\Extracted_nss_68_10\Shadab Files\Organized Files\Experimental Result\result 3 april 01 2030.smcl"


use "E:\Shadab\UBC Project\NSS Data\Extracted_nss_68_10\Shadab Files\Organized Files\Original Datasets\level06_schedule 10_round 68.dta"

note: using old concordance file where exceptions are NOT dropped and I am not dropping any observations in this file EXCEPT in attempt to find education premium 

/*
gen current_date=c(current_date)
gen current_time=c(current_time)
gen xpath= "E:\Shadab\UBC Project\NSS Data\Extracted_nss_68_10\Shadab Files\Results\Log Files" + current_date + c(current_time)
log using xpath
*/

set more off
set scrollbufsize 2000000

//2-digit NIC 2008 code for DAILY status
summarize nic2008_code
distinct nic2008_code                     //87 unique 2-digit NIC-2008 codes                                       

//5-digit NIC 2008 code for WEEKLY status
su current_wkly_act_nic2008
distinct current_wkly_act_nic2008         //1158 unique 2-digit NIC-2008 codes 

gen str_current_wkly_act_nic2008= string(current_wkly_act_nic2008)
gen len_current_wkly_act_nic2008=length(str_current_wkly_act_nic2008)

gen modi_current_wkly_act_nic2008="0"+ str_current_wkly_act_nic2008  if len_current_wkly_act_nic2008!=5
replace modi_current_wkly_act_nic2008= str_current_wkly_act_nic2008  if len_current_wkly_act_nic2008==5

gen four_digit_nic2008=substr(modi_current_wkly_act_nic2008,1,4)
gen two_digit_nic2008=substr(modi_current_wkly_act_nic2008,1,2)
gen numeric_two_digit_nic2008=real(two_digit_nic2008)

//log close

//seeing proportion of 4-digit codes for mis-match in concordance
tab four_digit_nic2008 if  numeric_two_digit_nic2008==9
tab four_digit_nic2008 if  numeric_two_digit_nic2008==11
tab four_digit_nic2008 if  numeric_two_digit_nic2008==19
tab four_digit_nic2008 if  numeric_two_digit_nic2008==33
tab four_digit_nic2008 if  numeric_two_digit_nic2008==58
tab four_digit_nic2008 if  numeric_two_digit_nic2008==59
tab four_digit_nic2008 if  numeric_two_digit_nic2008==70
tab four_digit_nic2008 if  numeric_two_digit_nic2008==81
tab four_digit_nic2008 if  numeric_two_digit_nic2008==92
tab four_digit_nic2008 if  numeric_two_digit_nic2008==95

/*
sort nic2008_code, stable
by nic2008_code: gen nic2008_first=1 if _n==1
list nic2008_code if nic2008_first==1 
count if nic2008_first==1
*/ 

count if nic2008_code==.    //317,466 NIC-2008 code MISSING  values 
count if nic2008_code!=. 	//177,550 NIC-2008 code NON-ZERO values	
distinct nic2008_code       //87 unique 2-digit NIC-2008 codes   

display _N   				//total rows or observations: 495,016

distinct lot_fsu_number   	//12,729 villages or urban-blocks have been considered
tab hh_id   		  		//max value is 8 ...i.e. in a sample village max 8 houses are taken
tab person_srl_no	  		//max 39 people are considered in houseshold 
tab  activity_srl_no  		//people max do 5 activites
 
tab total_no_days_each_act  //min =5 and max=70, hence we easily see that actual observation is multiplied by 10 

distinct common_id    		//101,724 distinct values
gen trim_common_id=trim(common_id)
distinct trim_common_id
	
gen len_common_id=length(common_id)
tab len_common_id 			//its a 9-digit code

gen real_common_id=real(common_id)
distinct real_common_id  	//53,221 distinct values
su real_common_id 
count if real_common_id==.  //zero missing values

format real_common_id %12.0g 
//br common_id  real_common_id ... DON'T see this.. they have different values


/* VERY IMPORTANT to see data-set in proper format run this
sort common_id lot_fsu_number hh_id person_srl_no activity_srl_no , stable     //second_stage_stratum_num is not required since its just a categorization for each household
Note: Data is organized at household-level > FSU(village/block) > (second-stagestratum) > household-id > person_srl_no
*/

//sort common_id lot_fsu_number hamlet_group_sub_block_no second_stage_stratum_num hh_id person_srl_no activity_srl_no , stable






//***********************************MERGING the Concordance Dataset********************************************//

merge m:1 nic2008_code using "E:\Shadab\UBC Project\NSS Data\Extracted_nss_68_10\Shadab Files\Organized Files\Original Datasets\concordance_nic2008_nic 2004 March 24 2240.dta"

//#rows from concordance data :    88 i.e. 88 unique NIC 2008 codes
//#rows from NSS 68, schedule 10 : 495,016


/*   Results

 Result                           # of obs.
    -----------------------------------------
    not matched                       317,467
        from master                   317,466  (_merge==1)
        from using                          1  (_merge==2)      // because NIC-2008 2-digit code: 98 (9810), NIC 2004: 9600, _merge==2 "using only(2)"   is NOT present in NSS Dataset

    matched                           177,550  (_merge==3)
*/


tab _merge
list nic2008_code NIC2008 if _merge== 2               // NIC-2008 2-digit code: 98 (9810) is NOT present in NSS Dataset

display _N

note: IMPORTANT: since we are not dropping any row, 1 additional row in data has been introduced

/*

drop if _merge==1 | _merge==2     //keeping only MATCHED results OR dropped all un-matched results
//3,17,467 are deleted out of original 4,95,017 

*/


//*********************************    Tabe 1 for IGIDR paper or table 6 of EPW      ***************************************//


/* As defined in concordance do file

NIC 2004 code	Industry		Industry_code
		
[1, 5]	        agriculture		1
[10,14]	 		mining			2
[15 ,41 ]		manufacturing	3
{45}			construction	4
[50 ,55 ]		trade			5
[60 ,64 ]		transport		6
[65 , 74]		finance			7
[75 , above)	public			8

*/



//using row 1168 and 1559 from consumption pattern
gen indi=1     if NIC2008_industry==1    											//using agriculture
replace indi=2 if NIC2008_industry==3												//using manufacturing
replace indi=3 if NIC2008_industry==4 | NIC2008_industry==5 | NIC2008_industry==6	//using constr, trade or transport
replace indi=4 if NIC2008_industry==8												//using public
replace indi=5 if NIC2008_industry==2 | NIC2008_industry==7							//using mining, finance


label var first_industry "id to identify 1st industry"    //it has only 1 as all values
label var NIC2008_industry "8 industry categories"
label var indi "5 industry categories"						//useful for tahble 1 of IGIDR
label var total_no_days_each_act "#days in a week for an activity"



//creating multiplier
gen double mul4=.
replace mul4=multiplier/100 if nss==nsc
replace mul4=multiplier/200 if nss!=nsc



//making Table 1 for ALL SEXES

matrix B=J(5,1,0)
matlist B

forvalues i=1(1)5 { 
	
	//by indi: egen junk=sum(mul4*total_no_days_each_act)      	//total_days is total days of each activity pursued by an individual
	
	egen junk=sum(mul4*total_no_days_each_act) , by(indi)       // (??)we are getting a running sum here, hope it is okay 
	gen junk1=junk/10000000										// (?? since total days is multiplied by 10, we divide by 1 crore)
	sum junk1 if indi==`i' 
	drop junk junk1	
	matrix B[`i',1]=r(mean)	
}
mat list B

rename age age_1


//************************* MERGING level_03_schedule 10_round 68 dataset...sinec 'sex' and 'education' variable is missing*****************//


merge m:1 lot_fsu_number hamlet_group_sub_block_no sector second_stage_stratum_num hh_id person_srl_no using "E:\Shadab\UBC Project\NSS Data\Extracted_nss_68_10\Shadab Files\Organized Files\Original Datasets\level03__schedule 10_round 68.dta" , keepusing(sex age general_education technical_education) gen(level3_merge)  
//egen hhid=group(lot_fsu_number hamlet_group_sub_block_no second_stage_stratum_num hh_id)

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                       293,743
        from master                         0  (level3_merge==1)
        from using                    293,743  (level3_merge==2)

    matched                           177,550  (level3_merge==3)
    -----------------------------------------
	
*/


count if level3_merge==1 | level3_merge==2     

/*

drop if level3_merge==1 | level3_merge==2   
//2,93,743 are deleted

*/

display _N  //left observations are 1,77,550


count if age==age_1   //same as #observations...i.e. our data has been merged properly
drop age
rename age_1 age


//making Table 1 for MALES (sex==1)

preserve  			//preserve:  preserves the data, guaranteeing that data will be restored after program termination
keep if sex==1      //keep works the same as drop, except that you specify the variables or observations to be kept rather than the variables or observations to be deleted.

matrix define B=J(5,1,0)
forvalues i=1(1)5 {
	
	egen junk=sum(mul4*total_no_days_each_act) , by(indi)       // (??)we are getting a running sum here, hope it is okay 
	gen junk1=junk/10000000										// (?? since total days is multiplied by 10, we divide by 1 crore)
	sum junk1 if indi==`i' 
	drop junk junk1	
	matrix B[`i',1]=r(mean)	
	
}
display "Table 1 for Males"
mat list B
restore


//making Table 1 for FEMALES (sex==2)
preserve  			//preserve:  preserves the data, guaranteeing that data will be restored after program termination
keep if sex==2      //keep works the same as drop, except that you specify the variables or observations to be kept rather than the variables or observations to be deleted.

matrix define B=J(5,1,0)
forvalues i=1(1)5 {
	
	egen junk=sum(mul4*total_no_days_each_act) , by(indi)       // (??)we are getting a running sum here, hope it is okay 
	gen junk1=junk/10000000										// (?? since total days is multiplied by 10, we divide by 1 crore)
	sum junk1 if indi==`i' 
	drop junk junk1	
	matrix B[`i',1]=r(mean)	
	
}
display "Table 1 for Females"
mat list B
restore

display _N

note: REMEMBER to normalize the values obtained from above matrixes since those are number used in IGIDR paper
 
note: we got same values for Table 1 even when we DROPPED the observations but this time we HAVEN'T dropped any observations


//****************************   TABLE 2(a) IGIDR    *******************************************************


egen hhid=group(lot_fsu_number hamlet_group_sub_block_no second_stage_stratum_num hh_id)		      //creating id for a  HOUSEHOLD
egen pid=group(lot_fsu_number hamlet_group_sub_block_no second_stage_stratum_num hh_id person_srl_no) //creating id for an INDIVIDUAL..don't forget to include hhid 


//**** CROSS-CHECKING WAGE DATA (Shadab's data)


/*

//validating figures on pg 23 (pdf-31) (india-level) of PDF Table 6
display _N

preserve    //line 824

set more off
quietly: tab curr_day_status
distinct curr_day_status //11 distinct values

//31: worked as regular salaried/ wage employee  ; 71: had regular salaried/wage employment but did not work due to: sickness;  72: other reasons

count if current_wkly_act_status==31 | current_wkly_act_status==71 | current_wkly_act_status==72
count if curr_day_status==31 | curr_day_status==71 | curr_day_status==72
//41,810...same across WEEKLY and DAILY activites


keep if curr_day_status==31|curr_day_status==71|curr_day_status==72

quietly: duplicates list pid   			
duplicates tag pid, gen(dup)
tab dup

bysort pid:egen earning_combined=total(wage_salary_earn_total)   //from line 834... finding total weekly earning across ALL INDUSTRIES per person ID

duplicates drop pid,force


//capture drop daily_wage
gen daily_wage= (earning_combined/7)       						//finding daily wages(across ALL INDUSTRIES), by dividing weekly wage...

//pg 23 (india-level for rural) of PDF Table 6  

summ daily_wage if sector==1 & sex==1 & age>=15 & age<=59 [aw=mul4]	//for MEN
summ daily_wage if sector==1 & sex==2 & age>=15 & age<=59 [aw=mul4]	//for WOMEN
summ daily_wage if sector==1 & age>=15 & age<=59 [aw=mul4]			//for all sexes

//pg 23 (india-level for urban) of PDF Table 6  

summ daily_wage if sector==2 & sex==1 & age>=15 & age<=59 [aw=mul4]	//for MEN
summ daily_wage if sector==2 & sex==2 & age>=15 & age<=59 [aw=mul4]	//for WOMEN
summ daily_wage if sector==2 & age>=15 & age<=59 [aw=mul4]			//for all sexes

//pg 23 (india-level rural+urban) of PDF Table 6  

summ daily_wage if sex==1 & age>=15 & age<=59 [aw=mul4]	//for MEN
summ daily_wage if sex==2 & age>=15 & age<=59 [aw=mul4]	//for WOMEN
summ daily_wage if age>=15 & age<=59 [aw=mul4]			//for all sexes

restore
display _N

*/



//validating figures on pg 90 of pdf- TABLE S36

/*

preserve

set more off
quietly: tab curr_day_status
distinct curr_day_status //11 distinct values

//31: worked as regular salaried/ wage employee  ; 71: had regular salaried/wage employment but did not work due to: sickness;  72: other reasons

count if current_wkly_act_status==31 | current_wkly_act_status==71 | current_wkly_act_status==72
count if curr_day_status==31 | curr_day_status==71 | curr_day_status==72
//41,810...same across WEEKLY and DAILY activites


keep if curr_day_status==31|curr_day_status==71|curr_day_status==72

quietly: duplicates list pid   			
duplicates tag pid, gen(dup)
tab dup

bysort pid:egen earning_combined=total(wage_salary_earn_total)   //from line 834... finding total weekly earning across ALL INDUSTRIES per person ID

duplicates drop pid,force


//capture drop daily_wage
gen daily_wage= (earning_combined/7)       						//finding daily wages(across ALL INDUSTRIES), by dividing weekly wage...


//page 98 (state-wise rural) of PDF Table S37 ...numbers are matching..... btw <aw> applies weights to the daily wage.....summ is summarize function

/*
bysort state: summ daily_wage if sector==1 & age>=15 & age<=59 & state<=10 [aw=mul4]			//for all sexes
bysort state: summ daily_wage if sector==1 & sex==1 & age>=15 & age<=59 & state>=10 & state<=20 [aw=mul4]	//for MEN
bysort state: summ daily_wage if sector==1 & sex==2 & age>=15 & age<=59 & state>=20 & state<=35 [aw=mul4]	//for WOMEN
*/

/*
//page 99 (staste-wise urban)

bysort state: summ daily_wage if sector==2 & age>=15 & age<=59 & state<=10[aw=mul4]	
bysort state: summ daily_wage if sector==2 & sex==1 & age>=15 & age<=59 & state>=10 & state<=20 [aw=mul4]	
bysort state: summ daily_wage if sector==2 & sex==2 & age>=15 & age<=59 & state>=20 & state<=35 [aw=mul4]	
*/



//page 100 (state-wise rural+urban).... Table S37

bysort state: summ daily_wage if age>=15 & age<=59 & state<=10 [aw=mul4]	
bysort state: summ daily_wage if sex==1 & age>=15 & age<=59 & age<=59 & state>=10 & state<=20 [aw=mul4]	
bysort state: summ daily_wage if sex==2 & age>=15 & age<=59 & state>=20 & state<=35 [aw=mul4]	


restore
display _N

*/


//*****************MERGING NSS 68 TENDULKAR deflator figures**********************\\


rename state state_61    //since in deflator file of TENDULKAR he has state_61 has been used 
                         //and it also means that NSS 61 and 68 has same code for states

merge m:1 sector state_61 using "E:\Shadab\UBC Project\NSS Data\Extracted_nss_68_10\Shadab Files\Organized Files\Original Datasets\deflators_r68_tendulkar_March 30 1535.dta", keepusing(state_name poverty_line poverty_line2 state_key1) gen(deflator68_merge)  

rename state_61 state

	 
// attempting to find quie state_id in Tendulkar and 68th round NSS data-set


sort state, stable
by state: gen first_tag=1 if _n==1						 

//list state first_tag if first_tag==1
count if first_tag==1 
display _N

//br state first_tag state_key1 if first_tag==1   // uncomment it if you want to see the matches 
//Note: state codes in 68 round matches with that in Tendulkar file





//*************creating Table 2(a)to 2(d) properly*********************** line 874

su wage_salary_earn_total

count if wage_salary_earn_total<0  //thank god, at least NO NEGATIVE WAGES
count if wage_salary_earn_total==0 //12 cases
count if wage_salary_earn_total==. //4,19,706 cases for MISSING VALUES 

count if wage_salary_earn_total==0 | wage_salary_earn_total==.    //4,19,718... cases where values are missing or are zero


tab NIC2008_industry if wage_salary_earn_total==0 | wage_salary_earn_total==.  //50% employs in agriculture, 22% in trade i.e. they report ZERO earnings
tab curr_day_status  if wage_salary_earn_total==0 | wage_salary_earn_total==.  //30% attended educational institute,  


quietly: list state curr_day_status nic2008_code NIC2008_industry if wage_salary_earn_total==0 | wage_salary_earn_total==.  



//********************defining REAL wages & COHORT ............from line 1215 consump. pattern1

gen real_weekly_wage= (wage_salary_earn_total)/poverty_line2    
gen real_daily_wage=(real_weekly_wage/total_no_days_each_act)*10 

//br NIC2008 NIC2004 nic2008_code NIC2008_industry pub real_weekly_wage curr_day_status if NIC2008_industry==8
tab NIC2008_industry if real_weekly_wage==. | real_weekly_wage==0
tab curr_day_status if real_weekly_wage==. | real_weekly_wage==0

count if real_daily_wage==0     //12 cases
count if real_daily_wage==.     //419706
count if real_daily_wage!=.     //75,311 cases

cap drop cohort

gen cohort=1 if age>=18 & age<26
replace cohort=2 if age>=26 & age<34
replace cohort=3 if age>=34 & age<42
replace cohort=4 if age>=42 & age<50
replace cohort=5 if age>=50 & age<58
replace cohort=6 if age>=58 & age<66

gen cohort3 = cohort == 3

gen pwt=mul4*total_no_days_each_act          //creating a person weight...i.e. on avertage how many days do people work in a particular activity



//*******************  already pulled EDUCATION variable from level 03, block 4  ***********************************\\



//defining MIDDLE SCHOOL EDUCATION people
gen secdrey=1 if general_education==7|general_education==8   
replace secdrey=0 if secdrey==.

//******
//defining GRADUATES people
gen graduate_force=1 if general_education==10|general_education==11|general_education==12|general_education==13
replace graduate_force=0 if graduate_force==. 



//look at line 1385 consumption pattern 1
gen agri=1 if NIC2008_industry==1
replace agri=0 if agri==.
 
gen mining=1 if NIC2008_industry==2
replace mining=0 if mining==.

gen manu=1 if NIC2008_industry==3
replace manu=0 if manu==.

gen constr=1 if NIC2008_industry==4
replace constr=0 if constr==.

gen trade=1 if NIC2008_industry==5
replace trade=0 if trade==.

gen transport=1 if NIC2008_industry==6
replace transport=0 if transport==.

gen finance=1 if NIC2008_industry==7
replace finance=0 if finance==.

gen pub=1 if NIC2008_industry==8
replace pub=0 if pub==.


//************Table 2(a) finding values of p(i)***********************

/* PROPORTION produces estimates of proportions, along with standard errors, for the categories identified by the values in each variable of varlist.
previously it was showing error... Error: no observations..... r(2000)
in our case agri manu..etc are all binary variables
br agri mining manu constr trade transport finance pub if cohort3==1 & sex==1 & general_education==1 & real_weekly_wage!=.

*/



/*
proportion agri mining manu constr trade transport finance pub if cohort3==1 & sex==1 & general_education==1 & real_weekly_wage!=. [pw=pwt]   

proportion agri mining manu constr trade transport finance pub if cohort3==1 & sex==2 & general_education==1 & real_weekly_wage!=. [pw=pwt]

proportion agri mining manu constr trade transport finance pub if cohort3==1 & sex==1 & secdrey==1 & real_weekly_wage!=. [pw=pwt]

proportion agri mining manu constr trade transport finance pub if cohort3==1 & sex==2 & secdrey==1 & real_weekly_wage!=. [pw=pwt]

*/


//finding proportion for ILLITERATE fellows
mean   agri mining manu constr trade transport finance pub if cohort3==1 & sex==1 & ///
general_education==1 & real_weekly_wage!=. [pw=pwt]
estimates store prop_m

mean   agri mining manu constr trade transport finance pub if cohort3==1 & sex==2 & ///
general_education==1 & real_weekly_wage!=. [pw=pwt]
estimates store prop_f

//finding proportion for MIDDLE SCHOOL fellows
mean   agri mining manu constr trade transport finance pub if cohort3==1 & sex==1 & ///
secdrey==1 & real_weekly_wage!=. [pw=pwt]
estimates store propsec_m

mean   agri mining manu constr trade transport finance pub if cohort3==1 & sex==2 & ///
secdrey==1 & real_weekly_wage!=. [pw=pwt]
estimates store propsec_f

//finding proportion for GRADUATE fellows
mean   agri mining manu constr trade transport finance pub if cohort3==1 & sex==1 & ///
graduate_force==1 & real_weekly_wage!=. [pw=pwt]
estimates store propgrad_m

mean   agri mining manu constr trade transport finance pub if cohort3==1 & sex==2 & ///
graduate_force==1 & real_weekly_wage!=. [pw=pwt]
estimates store propgrad_f





//*********Table 2(a) finding values of w(i): REAL WAGES*****************

/*
bysort NIC2008_industry:summ real_weekly_wage if  cohort3==1 & sex==1 & general_education==1 & real_weekly_wage!=. & real_weekly_wage!=0 [aw=mul4]   //real weekly wage for age 34-42, male, not literate
bysort NIC2008_industry:summ real_weekly_wage if  cohort3==1 & sex==2 & general_education==1 [aw=mul4]   //real weekly wage for age 34-42, female, not literate

bysort NIC2008_industry:summ real_weekly_wage if  cohort3==1 & sex==1 & secdrey==1 [aw=mul4]  //real weekly wage for age 34-42, male, with seconday education
bysort NIC2008_industry:summ real_weekly_wage if  cohort3==1 & sex==2 & secdrey==1 [aw=mul4]  //real weekly wage for age 34-42, female, with seconday education 
*/



//below code produces same results as with bysort command used above



//finding real weekly wages for ILLITERATE fellows

mean real_weekly_wage if  cohort3==1 & sex==1 & general_education==1 & real_weekly_wage!=. [aw=mul4], over(NIC2008_industry)
estimates store wage_m

mean real_weekly_wage if  cohort3==1 & sex==2 & general_education==1 & real_weekly_wage!=. [aw=mul4], over(NIC2008_industry) 
estimates store wage_f

//finding real weekly wages for MIDDLE SCHOOL fellows

mean real_weekly_wage if  cohort3==1 & sex==1 & secdrey==1 & real_weekly_wage!=. [aw=mul4], over(NIC2008_industry) 
estimates store wagesec_m

mean real_weekly_wage if  cohort3==1 & sex==2 & secdrey==1 & real_weekly_wage!=. [aw=mul4], over(NIC2008_industry) 
estimates store wagesec_f

//finding real weekly wages for GRADUATE fellows

mean real_weekly_wage if  cohort3==1 & sex==1 & graduate_force==1 & real_weekly_wage!=. [aw=mul4], over(NIC2008_industry) 
estimates store wagegrad_m

mean real_weekly_wage if  cohort3==1 & sex==2 & graduate_force==1 & real_weekly_wage!=. [aw=mul4], over(NIC2008_industry) 
estimates store wagegrad_f








/*  IMP: NOOOO  difference even after when I dropped  real_weekly_wage!=.

mean real_weekly_wage if  cohort3==1 & sex==1 & general_education==1 [aw=mul4], over(NIC2008_industry)
estimates store wage_m
mean real_weekly_wage if  cohort3==1 & sex==2 & general_education==1 [aw=mul4], over(NIC2008_industry) 
estimates store wage_f
mean real_weekly_wage if  cohort3==1 & sex==1 & secdrey==1 [aw=mul4], over(NIC2008_industry) 
estimates store wagesec_m
mean real_weekly_wage if  cohort3==1 & sex==2 & secdrey==1 [aw=mul4], over(NIC2008_industry) 
estimates store wagesec_f
*/



note: NOOOO  difference even after when I removed condition to drop missing values of real_weekly_wage

esttab prop_m prop_f propsec_m propsec_f propgrad_m propgrad_f using "E:\Shadab\UBC Project\NSS Data\Extracted_nss_68_10\Shadab Files\Results\round_68_april 18 1315 proportion.csv", ///
not b(4) nostar title(proportions) mtitles(m1 f1 m2 f2 m3 f3) //replace   mtitles(m_no education f_no education m_middle school f_middle school)

esttab wage_m wage_f wagesec_m wagesec_f wagegrad_m wagegrad_f using "E:\Shadab\UBC Project\NSS Data\Extracted_nss_68_10\Shadab Files\Results\round_68_april 18 1315 wage.csv", ///
not b(4) nostar title(wages) mtitles(m1 f1 m2 f2 m3 f3) 










//******* Generating EDUCATION PREMIUM values ************//

/*
gen newedu=1 if general_education==1    //1: not literate
replace newedu=2 if general_education==2 | general_education==3|general_education==4|general_education==5|general_education==6   // EGS......till primary 
replace newedu=3 if general_education==7 //7: middle
replace newedu=4 if general_education==8| general_education==10| general_education==11 | general_education==12 | general_education==13  //8: secondary, 10 : higher secondary;
//11: diploma/certificate course; 12: graduate; 13: postgraduate and above
*/


gen newedu=1 if general_education==1   //1: not literate
replace newedu=2 if general_education==2 | general_education==3 | general_education==4  | general_education==5  | general_education==6   // EGS......till primary 
replace newedu=3 if general_education==7 | general_education==8  //7: middle; 8: secondary
replace newedu=4 if general_education==10| general_education==11 | general_education==12 | general_education==13  // 10 : higher secondary;
																												  // 11: diploma/certificate course; 12: graduate; 13: postgraduate and above

summ real_weekly_wage if cohort==3 & newedu==1 & real_weekly_wage!=.  [aw=mul4]
summ real_weekly_wage if cohort==3 & newedu==2 & real_weekly_wage!=.  [aw=mul4]
summ real_weekly_wage if cohort==3 & newedu==3 & real_weekly_wage!=.  [aw=mul4]
summ real_weekly_wage if cohort==3 & newedu==4 & real_weekly_wage!=.  [aw=mul4]


drop if real_weekly_wage==0
gen lsvwagetot=log(real_weekly_wage)   // log(x) and ln(x) are similar


recode state 12 30 2 1 14 17 15 13 11 16 35 4 26 25 7 31 34 = 0

svyset [pweight=mul4], strata(stratum) psu(lot_fsu_number)  //svyset declares the data to be complex survey data, designates variables that contain information about the survey design.
															//You must svyset your data before using any svy command;

//In our case: fsu are villages or urban-blocks.... 															
															
//psu is _n or the name of a variable (numeric or string) that contains identifiers for the primary sampling units (clusters).
//strata(varname) specifies the name of a variable (numeric or string) that contains stratum identifiers.



//using iis and not xtset


iis state      //iis is similar xtset: xtset declares the data in memory to be a panel.  You must xtset your data before you can use the other xt commands.  


xi: xtreg lsvwagetot i.cohort i.newedu i.newedu*i.cohort if sex==1 & state~=0, fe

//xi expands terms containing categorical variables into indicator (also called dummy) variable sets by creating new variables and, in the second syntax
//(xi: any_stata_command), executes the specified command with the expanded terms


predict phat1 if cohort==3 & newedu==1  
predict phat2 if cohort==3 & newedu==2
predict phat3 if cohort==3 & newedu==3
predict phat4 if cohort==3 & newedu==4

summ phat1
summ phat2
summ phat3
summ phat4

gen phat1_exp=exp(phat1)
gen phat2_exp=exp(phat2)
gen phat3_exp=exp(phat3) 
gen phat4_exp=exp(phat4)

summ phat1_exp
summ phat2_exp
summ phat3_exp
summ phat4_exp

log close
