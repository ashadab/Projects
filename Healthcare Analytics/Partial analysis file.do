//******** Section A ********// Labeling variables for better understanding

quietly: describe

label var reg_no "tag/number for each unique patient in hospital database"
label var unique_id "tag/number for a patient visit to hospital"
label var ipd_admission_id "system code for each patient visit"
label variable release_cause "attains D/T/E based on release description"
label variable releasecode "attains D/T/E based on release description"
label variable releasedescription  "tells us status on discharge"
label variable tot_bed_no "might tell us #beds in the ward"
label variable is_casualty "tell us if ward=EMW"
label variable p_sex "male =1 and female =2"
label variable race_id "NO information about race"
label variable dob "date of birth of patient"
label var age "age (in yrs) of patient"
label var sname "state of India for the patient"
label var cast_id "if OBC then id=3"
label var cast_name "general, OBC, unkown"
label var p_citizenship "91 for india and 960,966 also exists"
label var icd "codes for disease desription"
label var expired "If a person dies in hospital"
//ssc inst distinct  //'distinct' package needs to be downloaded

note: CTVS full form is CardioThoracic & Vascular Surgery Department 
note: TS cast_name is general(very few), OBC or unknown
note: not everyone is cured from hospital, some people are just discharged... beacuse frequency distribution for cured and expired are different
notes



//******** Section B ********// Identifying patients who have made single or multiple visits to hospital and cross-checking results with distinct command


//assuming ward_admission_event_str captures ward level data correctly

split ward_admission_event_str, p(" ") gen(ward_add_detail) // ward_add_detail1 gives ward admission date and ward_add_detail2 gives ward admission time to a particular ward
gen ward_add_date = date( ward_add_detail1 , "DMY") //gives admission date to a ward.... since we need to convert string into proper date format
format ward_add_date %td
label var ward_add_date "gives admission date to a particular ward for a patient"

gen double ward_add_time = clock(ward_add_detail2, "hms") //
format ward_add_time %tc //checked from  wisconsin website (https://www.ssc.wisc.edu/sscc/pubs/stata_dates.htm)
label var ward_add_time "gives admission time to a particular ward for a patient"



//finding ward discharge date and time in proper format..useful in finding LOS

split ward_discharge_event_str, p(" ") gen(ward_disch_detail)
gen ward_disch_date = date( ward_disch_detail1 , "DMY") //gives admission date to a ward.... since we need to convert string into proper date format
format ward_disch_date %td
label var ward_disch_date "gives discharge date from a particular ward for a patient"

gen double ward_disch_time = clock(ward_disch_detail2, "hms") //
format ward_disch_time %tc
label var ward_disch_time "gives discharge time from a particular ward for a patient"



//for assigning event number at ward level for each patient visit and each visit of a patient will get started from 1 even if he coming for 2nd time to hospital
sort unique_id ward_add_date ward_add_time, stable
by unique_id: gen event_number= _n // CAUTION: we are assuming data is already sorted for each patient visit i.e. ward admission is in proper order and earlier admission date also comes latter

//for tagging patients with first_visit to hospital and 2nd visit for an old patient gets a missing value
sort reg_no ward_add_date ward_add_time, stable  // stable keeps same relative order for observations for whom we have same reg_no
by reg_no : gen first_visit=_n if _n==1  //classifies 1st visit of each patient or gives us unique number of patients in system
label var first_visit "classifies 1st visit of each patient" 


//for tagging patients who have made multiple(repeat) visits to hospital
gen repeat_visit = 1 if event_number==1 & first_visit==.  
quietly: list reg_no unique_id repeat_visit if repeat_visit==1

distinct reg_no   // 4292 unique patients
table first_visit // first_visit and distinct reg_no values match with each other

distinct unique_id // ans: 4351, gives me number of visits to hospital by all patients
table repeat_visit // 59 repeat patients/visits to the hospital
// total number of visits (4351) = unique patients (4292) + repeat patients/visits (59)




//******** Section C ********// Cross-checking if we have multiple data entry for a unique visit for each patient at ward level

duplicates report reg_no unique_id ward_name ward ward_admission_eventdt ward_discharge_eventdt
//we have duplicates, since a patient is taken to the same ward twice in a day but hopefully at different TIME

duplicates tag reg_no unique_id ward_name ward ward_admission_eventdt ward_discharge_eventdt , generate(mob)
//we have duplicates, hence we want to see at what positions we have duplicates using 'mob' variable

quietly: list reg_no unique_id ward_name ward ward_admission_eventdt ward_discharge_eventdt admission_time if mob==1
       //list reg_no unique_id ward_name ward ward_admission_eventdt ward_discharge_eventdt admission_time if mob==1  
//we get a list of patients who visit to the same ward at least TWICE 

duplicates report reg_no unique_id ward_name ward ward_admission_eventdt ward_discharge_eventdt admission_time
//we DONT'T have duplicates since we have added even admission time in the variable list  

duplicates tag reg_no unique_id ward_name ward ward_admission_eventdt ward_discharge_eventdt admission_time , generate(mob2)
//we are expecting mob2 has all zero values   

table mob  //32 duplicates, suggesting we have 32 cases when a patient visited same ward twice during his stay at hospital
table mob2 //no duplicates, suggesting we DON'T have multiple data entry for a unique visit for each patient at ward level




//******** Section D ********  // Using Threshold time (USER INPUT) to find out mischievous cases

// Finding out time difference between admissions to same ward by a patient on same day
sort unique_id mob, stable
by unique_id: gen timediff_new= ( ward_add_time[_N] - ward_add_time[_N -1] ) if mob==1 
format timediff_new %tc
//timediff_new gives me difference between time of admission to the SAME WARD by a patient on the SAME DAY

gen threshold_time = clock( "1/1/60 00:00", "MD19Yhm")   // use help clock to get better sense of arguments
format threshold_time %tc

replace threshold_time = clock( "1/1/60 00:45", "MD19Yhm")  // 'USER INPUT'... threshold time can be easily set out here, to identify as which observation are mischevious
quietly: list reg_no unique_id ward_name ward ward_admission_eventdt ward_discharge_eventdt admission_time ward_add_date ward_add_time timediff_new event_number if mob==1 & timediff_new < threshold_time

//if timediff_new < threshold_time, we need to decide what needs to be done with outliers either drop or modify them




//******** Section E ********//  Reporting Descriptive Statistics


//finding unique patients and patient visits
distinct reg_no   // 4292 unique patients
table first_visit // first_visit and distinct reg_no values match with each other

distinct unique_id // ans: 4351, gives me number of visits to hospital by all patients
table repeat_visit // 59 repeat patients/visits to the hospital


//finding number of males and females
table sex_name if first_visit==1 //significantly lesser number of female are admitted to the hospital


//finding information about age

split admission_date_f_ward_str, p(" ") gen(hosp_add_detail) // 
gen hosp_add_date = date(hosp_add_detail1 , "DMY") //gives admission date to a hospital... since we need to convert string into proper date format
format hosp_add_date %td
label var hosp_add_date "gives admission date to a hospital for a patient"

gen dob_format = date(p_dob, "YMD")
format dob_format %td 
gen age_months = hosp_add_date - dob_format
gen age_years =  (hosp_add_date - dob_format)/365

summarize age_years if first_visit==1    //for all 1st visit of patients irrespective of their ward, age is being captured 

//finding mean and sd for age of male and female patients
sort sex_name, stable
by sex_name: summarize age_years if first_visit==1    //finding age distribution by sex, on 1st visit of patient we are able to capture the information
list reg_no unique_id age_years if first_visit==1 & age_years==0 //finding cases where patient was born in the hospital

//quietly: histogram age_years if first_visit==1, fraction
quietly: tabulate age_years if first_visit==1 in 1/20



//******** Section E ********//  Finding Length of Stay across wards and Individual ward 


//finding length of stay across wards in hours and days

gen female_id="Female"
gen male_id="Male"

sort unique_id ward_add_date ward_add_time, stable    //it would be also better if data is restored to original by using..... sort unique_id event_number
by unique_id: gen LOS_hours_ward = 24*(ward_disch_date - ward_add_date) + ( (ward_disch_time - ward_add_time)/3600000 )
gen LOS_days_ward = LOS_hours_ward/24 

count if  LOS_days_ward<=0   // 19 cases where LOS <0
quietly: list reg_no ipd_admission_id ward ward_name LOS_days_ward ward_add_date ward_add_time ward_disch_date ward_disch_time if LOS_days_ward<=0   // except reg_no 100851372 everyone else has time of admission later than time of discharge  


//finding LOS mean and sd for ICU
egen total_LOS_ICU = total(LOS_days_ward) if ward=="CTVS_ICU" & LOS_days_ward >0
distinct reg_no if ward=="CTVS_ICU" & LOS_days_ward >0  						//number of patients who at least once visited ICU and has LOS >0
return list
gen mean_LOS_ICU = (total_LOS_ICU) / r(ndistinct)

gen sd_ICU_num_term = (LOS_days_ward-mean_LOS_ICU)^2  if ward=="CTVS_ICU" & LOS_days_ward >0
egen sd_ICU_num_total= total(sd_ICU_num_term)
distinct reg_no if ward=="CTVS_ICU" & LOS_days_ward >0  						//number of patients who at least once visited ICU and has LOS >0
return list
gen sd_ICU_LOS = sqrt(sd_ICU_num_total/ (r(ndistinct)-1) )						//finding standard deviation

su mean_LOS_ICU
su sd_ICU_LOS

su LOS_days_ward if ward=="CTVS_ICU" &  LOS_days_ward>0
count if ward=="CTVS_ICU" &  LOS_days_ward<=0									//14 cases where we have negative LOS



//finding mean and sd for general ward
egen total_LOS_general = total(LOS_days_ward) if ward=="general" & LOS_days_ward >0
distinct reg_no if ward=="general" & LOS_days_ward >0  							//number of patients who at least once visited General Ward and has LOS>0
return list
gen mean_LOS_general = (total_LOS_general) / r(ndistinct)

gen sd_general_num_term = (LOS_days_ward-mean_LOS_general)^2  if ward=="general" & LOS_days_ward >0
egen sd_general_num_total= total(sd_general_num_term)
distinct reg_no if ward=="general" & LOS_days_ward >0  							//number of patients who at least once visited General Ward and has LOS>0
return list
gen sd_general_LOS = sqrt( sd_general_num_total/ (r(ndistinct)-1) )

su mean_LOS_general
su sd_general_LOS

su LOS_days_ward if ward=="general" &  LOS_days_ward>0
count if ward=="general" &  LOS_days_ward<=0									//14 cases where we have negative LOS



//finding mean for OT
egen total_LOS_OT = total(LOS_days_ward) if ward=="CTVS_OT" & LOS_days_ward >0
distinct reg_no if ward=="CTVS_OT" & LOS_days_ward >0  							//number of patients who at least once visited OT Ward and has LOS>0
return list
gen mean_LOS_OT = (total_LOS_OT) / r(ndistinct)

summarize mean_LOS_OT
summarize LOS_days_ward if ward=="CTVS_OT" &  LOS_days_ward>0 
count if ward=="CTVS_OT" &  LOS_days_ward<=0

quietly: list reg_no ward_name ward_add_date ward_disch_date LOS_days_ward if ward=="CTVS_OT" &  LOS_days_ward>1
count if ward=="CTVS_OT" &  LOS_days_ward>1 	//31 cases where LOS > 1 in OT ward				 
	

	
	
	

//******** Section F ********//  Finding Patients's age and ALOS(in ICU and General ward) who visits 8 OT wards
// *** Dec 13 *** // 

gen ward_ICU="CTVS_ICU"
gen ward_general="general"




//generating CTVS_OT1 to ..8 variables
forvalues i=1/8 {
			gen CTVS_OT`i'= "CTVS OT"+ string(`i')

}

//generating value for across CTVS OT wards ........... CTVS_OT1-CTVS_OT8


//for all patients with ALL ages included

foreach i of varlist CTVS_OT1-CTVS_OT8{

			gen marker_`i'=1 if ward_name==`i'   								//generating marker for each "i"th CTVS OT ward
			
			sort reg_no marker_`i' ward_add_date ward_add_time, stable   		
			by reg_no: gen first_visit_`i'= _n if _n==1 & marker_`i'==1			//marking 1st visit in a "i"th CTVS OT ward
			
			sort unique_id ward_add_date ward_add_time, stable
			by unique_id: egen max_marker_`i'= max(marker_`i')					//marking all other wards visited a person who once visited a given "i"th CTVS OT ward 
			
			sort sex_name, stable
			display as text " "
			display as text "Overall Patient Charact. for " as result `i' 
			display as text " "
					
			by sex_name: su age_years if first_visit_`i'==1						//finding male and female patient age distribution across "i"th CTVS OT ward						  										
			
			quietly: distinct reg_no if ward_name==`i'
			display as text "Total Patients are " as result r(ndistinct)
			
			//finding gender ratio
			quietly: count if sex_name=="Female" & first_visit_`i'==1  			//another way would be ( distinct reg_no if ward_name=="CTVS_OT1" & sex_name=="Female" )   
			quietly: return list
			gen Female_`i'= r(N)
			quietly: count if sex_name=="Male" & first_visit_`i'==1  
			quietly: return list
			gen Male_`i'= r(N)
			gen gen_ratio_`i'= ( (Female_`i')/ (Male_`i') ) * 1000 				//finding gender ratio
			quietly: su gen_ratio_`i'											//finding gender ratio across "i"th CTVS OT ward
			display as text "Gender Ratio for " as result `i' " ward has value equal to " as result r(mean)
			//display as text "value is " as result r(mean)
			display as text " "
			

								foreach  j of varlist ward_ICU-ward_general{
												
												foreach k of varlist female_id-male_id {
																
																egen total_`k'_`j' = total(LOS_days_ward) if ward==`j' & sex_name==`k' & max_marker_`i'==1 & LOS_days_ward >0   //total_`k'_`j'_LOS_for_`i'
																quietly: distinct reg_no if ward_name==`i' & sex_name==`k' //another way is ( count if sex_name=="Female" & first_visit_`i'==1  
																quietly: return list
																gen mean_`k'_`j'= (total_`k'_`j') / r(ndistinct)  //mean_`k'_`j'_LOS_for_`i'
																quietly: su mean_`k'_`j'
																display as text "ALOS for " as result `k' " in ward " as result `j' " has value equal to " as result r(mean)																
																//display as text "has value equal to " as result r(mean)
																display as text " "
																drop total_`k'_`j' mean_`k'_`j'																
																}
												//drop total_`k'_`j', mean_`k'_`j' 
												
											}					
			//drop total_`k'_`j', mean_`k'_`j'
			
			  drop marker_`i' first_visit_`i' max_marker_`i' Female_`i' Male_`i' gen_ratio_`i' //total_`k'_`j', mean_`k'_`j'
											
											
}						
			
//over

//QC loop 1
//list reg_no ipd_admission_id ward_name if marker_CTVS_OT1==1 & first_visit_CTVS_OT1==.
			
			
			
//for all patients with age <=12 years
			
foreach i of varlist CTVS_OT1-CTVS_OT8{

			gen marker_`i'=1 if ward_name==`i'   								//generating marker for each "i"th CTVS OT ward
			
			sort reg_no marker_`i' ward_add_date ward_add_time, stable   		
			by reg_no: gen first_visit_`i'= _n if _n==1 & marker_`i'==1			//marking 1st visit in a "i"th CTVS OT ward
			
			sort unique_id ward_add_date ward_add_time, stable
			by unique_id: egen max_marker_`i'= max(marker_`i')					//marking all other wards visited a person who once visited a given "i"th CTVS OT ward 
			
			sort sex_name, stable
			display as text " "
			display as text "Overall Patient Charact. for " as result `i'
			display as text "when age <=12 years"
			display as text " "
					
			by sex_name: su age_years if first_visit_`i'==1 & age_years <= 12	//finding male and female patient age distribution across "i"th CTVS OT ward						  										
			
			quietly: distinct reg_no if ward_name==`i' & age_years <= 12 
			display as text "Total Patients are " as result r(ndistinct)
			
			//finding gender ratio
			quietly: count if sex_name=="Female" & first_visit_`i'==1 & age_years <= 12  
			quietly: return list
			gen Female_`i'= r(N)
			quietly: count if sex_name=="Male" & first_visit_`i'==1 & age_years <= 12  
			quietly: return list
			gen Male_`i'= r(N)
			gen gen_ratio_`i'= ( (Female_`i')/ (Male_`i') ) * 1000 				//finding gender ratio
			quietly: su gen_ratio_`i'											//finding gender ratio across "i"th CTVS OT ward
			display as text "Gender Ratio for " as result `i' " ward has value equal to " as result r(mean)
			//display as text "value is " as result r(mean)
			display as text " "
			

								foreach  j of varlist ward_ICU-ward_general{
												
												foreach k of varlist female_id-male_id {
																
																egen total_`k'_`j' = total(LOS_days_ward) if ward==`j' & sex_name==`k' & max_marker_`i'==1 & age_years <= 12 & LOS_days_ward >0  //total_`k'_`j'_LOS_for_`i'
																quietly: distinct reg_no if ward_name==`i' & sex_name==`k' & age_years <= 12
																quietly: return list
																gen mean_`k'_`j'= (total_`k'_`j') / r(ndistinct)  //mean_`k'_`j'_LOS_for_`i'
																quietly: su mean_`k'_`j'
																display as text "ALOS for " as result `k' " in ward " as result `j' " has value equal to " as result r(mean)																
																//display as text "has value equal to " as result r(mean)
																display as text " "
																drop total_`k'_`j' mean_`k'_`j'																
																}
												//drop total_`k'_`j', mean_`k'_`j' 
												
											}					
			//drop total_`k'_`j', mean_`k'_`j'
			
			drop marker_`i' first_visit_`i' max_marker_`i' Female_`i' Male_`i' gen_ratio_`i' //total_`k'_`j', mean_`k'_`j'
											
											
}						

//


//for all patients with age >12 years
			
foreach i of varlist CTVS_OT1-CTVS_OT8{

			gen marker_`i'=1 if ward_name==`i'   								//generating marker for each "i"th CTVS OT ward
			
			sort reg_no marker_`i' ward_add_date ward_add_time, stable   		
			by reg_no: gen first_visit_`i'= _n if _n==1 & marker_`i'==1			//marking 1st visit in a "i"th CTVS OT ward
			
			sort unique_id ward_add_date ward_add_time, stable
			by unique_id: egen max_marker_`i'= max(marker_`i')					//marking all other wards visited a person who once visited a given "i"th CTVS OT ward 
			
			sort sex_name, stable
			display as text " "
			display as text "Overall Patient Charact. for " as result `i'
			display as text "when age >12 years"
			display as text " "
					
			by sex_name: su age_years if first_visit_`i'==1 & age_years > 12	//finding male and female patient age distribution across "i"th CTVS OT ward						  										
			
			quietly: distinct reg_no if ward_name==`i' & age_years > 12 
			display as text "Total Patients are " as result r(ndistinct)
			
			//finding gender ratio
			quietly: count if sex_name=="Female" & first_visit_`i'==1 & age_years > 12
			quietly: return list
			gen Female_`i'= r(N)
			quietly: count if sex_name=="Male" & first_visit_`i'==1 & age_years > 12  
			quietly: return list
			gen Male_`i'= r(N)
			gen gen_ratio_`i'= ( (Female_`i')/ (Male_`i') ) * 1000 				//finding gender ratio
			quietly: su gen_ratio_`i'											//finding gender ratio across "i"th CTVS OT ward
			display as text "Gender Ratio for " as result `i' " ward has value equal to " as result r(mean)
			//display as text "value is " as result r(mean)
			display as text " "
			

								foreach  j of varlist ward_ICU-ward_general{
												
												foreach k of varlist female_id-male_id {
																
																egen total_`k'_`j' = total(LOS_days_ward) if ward==`j' & sex_name==`k' & max_marker_`i'==1 & age_years > 12 & LOS_days_ward >0  //total_`k'_`j'_LOS_for_`i'
																quietly: distinct reg_no if ward_name==`i' & sex_name==`k' & age_years > 12
																quietly: return list
																gen mean_`k'_`j'= (total_`k'_`j') / r(ndistinct)  //mean_`k'_`j'_LOS_for_`i'
																quietly: su mean_`k'_`j'
																display as text "ALOS for " as result `k' " in ward " as result `j' " has value equal to " as result r(mean)																
																//display as text "has value equal to " as result r(mean)
																display as text " "
																drop total_`k'_`j' mean_`k'_`j'																
																}
												//drop total_`k'_`j', mean_`k'_`j' 
												
											}					
			//drop total_`k'_`j', mean_`k'_`j'
			
			drop marker_`i' first_visit_`i' max_marker_`i' Female_`i' Male_`i' gen_ratio_`i' //total_`k'_`j', mean_`k'_`j'
											
											
}						

//




//******** Section E ********//  Finding health ourcomes across states


distinct sname // patients from 29 unique states.... Gujarat is missing from here
tabulate sname sex_name if first_visit==1
tabulate sname if first_visit==1

distinct icd_descr_1 // 204 unique diseases 
tab icd_descr_1 if first_visit==1

tab race_name if first_visit==1 //Hindu, muslim, sikhism and unkown.. but doesn't give any picture
tab cast_name if first_visit==1  //general, OBC and unknown.. but doesn't give any picture

tab p_citizenship if first_visit==1  //unique values for p_citizenship is 91, 960 and 966..... confirm what do 960 and 966 stand for ?
list reg_no unique_id sname p_citizenship if sname=="Unknown" & first_visit==1

table is_death if first_visit==1 //303 patients died
tabulate sname is_death if first_visit==1 //gives me number of peope surviving and died who entered the hospital state-wise
tabulate sex_name is_death if first_visit==1 // female death rate is 6.4% and that of male is 7.4%

table sname sex_name is_death if first_visit==1 //far off states bring people for selective surgery and thus have lesser number of admissions and mortality rates
//most vulnerable are Delhi population

table sname sex_name is_death if first_visit==1 & age_years <=12

table sname sex_name is_death if first_visit==1 & age_years >12

sort sname  
by sname: summarize Lenght of stay if firsit_visit==1 & sex_name=="Female"

table sname is_death if first_visit==1 & age_years <=12 & sex_name=="Male"


//finding male and feamle patients across threashold of 12 year of age
sort sex_name, stable
by sex_name: count if first_visit==1 //& sname!="Unknown"
by sex_name: count if age_years <=12 & first_visit==1 //& sname!="Unknown"
by sex_name: count if age_years >12 & first_visit==1 //& sname!="Unknown" 

 

//************//
//count if first_visit==1 & sname=="Unknown" //12 patients from 'Unknown' state
count if first_visit==1 & sname!="Unknown" & sex_name=="Female"
count if first_visit==1 & sname!="Unknown" & sex_name=="Male"

count if first_visit==1 & age_years <=12 & sname!="Unknown" & sex_name=="Female"
count if first_visit==1 & age_years <=12 & sname!="Unknown" & sex_name=="Male"

count if first_visit==1 & age_years >12 & sname!="Unknown" & sex_name=="Female"
count if first_visit==1 & age_years >12 & sname!="Unknown" & sex_name=="Male"
//************//



//deaths computation
table is_death if first_visit==1 //303 deaths and alive 3989
table expired if first_visit==1 //expired is a wrong indicator
quietly: list reg_no is_death expired if is_death=="Y" & expired==0 & first_visit==1

gen patient_expired=1 if is_death=="Y"
replace patient_expired=0 if is_death=="N"  
table patient_expired if first_visit==1


//finding death numbers
sort sex_name

by sex_name: count if first_visit==1 & patient_expired==1
by sex_name: count if age_years<=12 & first_visit==1 & patient_expired==1
by sex_name: count if age_years>12  & first_visit==1 & patient_expired==1


//creating overall death rates for age <=12
foreach k of varlist female_id-male_id{ 
										//sort sname, stable
										egen all_`k'_add_less_12= total(first_visit) if sex_name==`k' & first_visit==1 & age_years<=12
										egen all_`k'_death_less_12= total(patient_expired) if sex_name==`k' & first_visit==1 & age_years<=12 & patient_expired==1
										gen all_`k'_death_per_less_12=  ( ( all_`k'_death_less_12 / all_`k'_add_less_12) * 100  )

}
//



//creating overall death rates for age >12
foreach k of varlist female_id-male_id{ 
										//sort sname, stable
										egen all_`k'_add_great_12= total(first_visit) if sex_name==`k' & first_visit==1 & age_years>12
										egen all_`k'_death_great_12= total(patient_expired) if sex_name==`k' & first_visit==1 & age_years>12 & patient_expired==1
										gen all_`k'_death_per_great_12=  ( ( all_`k'_death_great_12 / all_`k'_add_great_12 ) * 100  )

}
//

su all_female_id_death_per_less_12
su all_male_id_death_per_less_12

su all_female_id_death_per_great_12
su all_male_id_death_per_great_12



//creating state-wise age <=12 years death ratios

foreach i of varlist female_id-male_id{
										sort sname, stable
										by sname: egen `i'_add_less_12= total(first_visit) if sex_name==`i' & first_visit==1 & age_years<=12
										by sname: egen `i'_death_less_12= total(patient_expired) if sex_name==`i' & first_visit==1 & age_years<=12 & patient_expired==1 
										by sname: gen `i'_death_percent_less_12=  ( (`i'_death_less_12 / `i'_add_less_12) * 100  )

										//count if sex_name==`i' & first_visit==1 & age_years<=12 & expired==1 & sname=="BIHAR"
										//list sname female_death_percent_less_12 if sname=="DELHI" & first_visit==1 & female_death_percent_less_12!= .
 
}
// 


//creating state-wise age >12 years death ratios

foreach j of varlist female_id-male_id{ 
										sort sname, stable
										by sname: egen `j'_add_great_12= total(first_visit) if sex_name==`j' & first_visit==1 & age_years>12
										by sname: egen `j'_death_great_12= total(patient_expired) if sex_name==`j' & first_visit==1 & age_years>12 & patient_expired==1 
										by sname: gen `j'_death_percent_great_12=  ( (`j'_death_great_12 / `j'_add_great_12) * 100  )

}

//

list reg_no sname female_id_death_percent_less_12 if female_id_death_percent_less_12!=. //matches with list that I produced with Excel

list reg_no sname female_id_death_percent_great_12 if female_id_death_percent_great_12!=. //matches with list that I produced with Excel
list reg_no sname male_id_death_percent_great_12 if male_id_death_percent_great_12!=. //matches with list that I produced with Excel

//table male_id_death_percent_great_12 sname 


//doing t-tests

count if age_years<=12 & first_visit==1 & patient_expired==1 & sex_name=="Female"
count if age_years<=12 & first_visit==1 & patient_expired==1 & sex_name=="Male"
count if age_years>12 & first_visit==1 & patient_expired==1 & sex_name=="Female"
count if age_years>12 & first_visit==1 & patient_expired==1 & sex_name=="Male"

//t-test for all the states
ttest patient_expired if age_years<=12 & first_visit==1 , by(sex_name) 
ttest patient_expired if age_years>12 & first_visit==1 , by(sex_name)


//t-test for 3 big states
ttest patient_expired if age_years<=12 & first_visit==1 & (sname=="BIHAR" | sname=="DELHI" | sname=="UTTAR PRADESH") , by(sex_name) 
ttest patient_expired if age_years>12 & first_visit==1 & (sname=="BIHAR" | sname=="DELHI" | sname=="UTTAR PRADESH") , by(sex_name) 

//t-test for remaining states except 'Unknown' and 3 big states

ttest patient_expired if age_years<=12 & first_visit==1 & sname!="BIHAR" & sname!="DELHI" & sname!="UTTAR PRADESH" & sname!="Unknown" , by(sex_name) 
ttest patient_expired if age_years>12  & first_visit==1 & sname!="BIHAR" & sname!="DELHI" & sname!="UTTAR PRADESH" & sname!="Unknown" , by(sex_name) 


//running t-test across states


//sort sname, stable
//by sname: ttest patient_expired if age_years<=12 & first_visit==1, by(sex_name)  ... wrong command

gen state_Bihar= "BIHAR"
gen state_Delhi= "DELHI"
gen state_UP="UTTAR PRADESH"
gen state_Haryana="HARYANA"
gen state_MP="MADHYA PRADESH"
gen state_Jharkh="JHARKHAND"
gen state_Punjab="PUNJAB"
gen state_Rajasthan="RAJASTHAN"
gen state_UTTARAKHAND="UTTRAKHAND"
gen state_Bengal="WEST BENGAL"


gen s1 =sname[1]
gen s2 =sname[3]

sort sname, stable
by sname: gen state_count=_n if _n==1
gen sum_state_count=sum(state_count) if state_count!=.
table state_count
distinct sname

gen state_13=sname if sum_state_count==13
gen state_fr=r(max)

table state_13
return list

forvalues i=1/3 {
			gen state_`i'=sname if sum_state_count==`i'
			//return list
			//gen state_dum_`i'=sname if sum_state_count==`i'
			
			egen state_f_`i'= colmax(state_`i')
			
}
//state_1-state_3







//doing ttest across states for age <12 across 2 sexes
//foreach i of varlist state_Bihar-state_Delhi {

foreach i of varlist state_Bihar-state_Bengal {
							sort sname, stable
							display as text " "
							display as text " "
							display as text "For age<=12 doing t-test for " as result `i'
							ttest patient_expired if age_years<=12 & first_visit==1 & sname==`i' , by(sex_name) welch
}


//doing ttest across states for age >12 across 2 sexes
foreach j of varlist state_Bihar-state_Bengal {
							sort sname, stable
							display as text " "
							display as text " "
							display as text "For age>12 doing t-test for " as result `j'
							ttest patient_expired if age_years>12 & first_visit==1 & sname==`j' , by(sex_name) welch
}

//
 


