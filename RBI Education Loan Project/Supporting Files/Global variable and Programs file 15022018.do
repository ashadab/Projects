********* Defining machine name for PPRU Desktop and my laptop *********

/*
set more off

if c(username) == "PPRU-7" {
global dropbox_mach_name "PPRU-7"
}

if c(username) == "abc" {
global dropbox_mach_name "abc"
}
//

*global common_path "C:\Users\abc\Dropbox\Education Loan Project" 

*/

*********************************************************
*********************************************************





********* Creating a program to drop unwanted States across all datasets *********

program state_drop

args round_number state_name district_name 

label var `state_name' "state name variable from NSS `round_number' remapped dataset"
label var `district_name' "district name variable from NSS `round_number' remapped dataset"


*droping unwanted states

display "#states present in dataset"
distinct `state_name'
 
rename `state_name' State


*run "C:\Users\PPRU-7\Dropbox\Arka Tridip Sir Project\Data work\Shadab files\Data sets created\Global variable files\Global variable file 27102017 1250.do"
run "$common_path\Supporting Files\statedrop modified 15122017.do"




display "#states after running state_drop.do file"
rename State `state_name'

distinct `state_name'
tab `state_name' , mi

end 

*********************************************************
*********************************************************







********* Creating a program to make changes to district codes across all datasets *********

program program_replace_dist_code

args old_var 

gen dist_code_after_group = `old_var'


replace dist_code_after_group = 5101 if `old_var' == 307 // PUNJAB SAHIBZADA AJIT SINGH NAGAR
replace dist_code_after_group = 5101 if `old_var' == 307 // PUNJAB Rupnagar
replace dist_code_after_group = 5101 if `old_var' == 317 // PUNJAB Patiala


replace dist_code_after_group = 5201 if `old_var' == 1804 // ASSAM Chirang 
replace dist_code_after_group = 5201 if `old_var' == 1801 // ASSAM Kokrajhar 
replace dist_code_after_group = 5201 if `old_var' == 1804 // ASSAM Bongaigaon
replace dist_code_after_group = 5201 if `old_var' == 1805 // ASSAM Barpeta


replace dist_code_after_group = 5201 if `old_var' == 1805 // ASSAM Baksa
replace dist_code_after_group = 5201 if `old_var' == 1807 // ASSAM Nalbari
*replace dist_code_after_group = 5201 if `old_var' == 1805 // ASSAM Barpeta
replace dist_code_after_group = 5201 if `old_var' == 1806 // ASSAM Kamrup
replace dist_code_after_group = 5201 if `old_var' == 1806 // ASSAM Guwahati (Sister district)


replace dist_code_after_group = 5301 if `old_var' == 3312 // TAMIL NADU Tiruppur
replace dist_code_after_group = 5301 if `old_var' == 3312 // TAMIL NADU Coimbatore
replace dist_code_after_group = 5301 if `old_var' == 3310 // TAMIL NADU Erode


replace dist_code_after_group = 5401 if `old_var' == 829 // RAJASTHAN Pratapgarh
replace dist_code_after_group = 5401 if `old_var' == 829 // RAJASTHAN Chittorgarh
replace dist_code_after_group = 5401 if `old_var' == 826 // RAJASTHAN Udaipur
replace dist_code_after_group = 5401 if `old_var' == 828 // RAJASTHAN Banswara


replace dist_code_after_group = 5501 if `old_var' == 705 // DELHI New Delhi
replace dist_code_after_group = 5501 if `old_var' == 702 // DELHI North Delhi
replace dist_code_after_group = 5501 if `old_var' == 709 // DELHI South Delhi
replace dist_code_after_group = 5501 if `old_var' == 708 // DELHI South West delhi
replace dist_code_after_group = 5501 if `old_var' == 704 // DELHI East Delhi
replace dist_code_after_group = 5501 if `old_var' == 706 // DELHI Central Delhi
replace dist_code_after_group = 5501 if `old_var' == 701 // DELHI North West Delhi
replace dist_code_after_group = 5501 if `old_var' == 707 // DELHI West Delhi
replace dist_code_after_group = 5501 if `old_var' == 703 // DELHI North East Delhi
replace dist_code_after_group = 5501 if `old_var' == 709 // DELHI South East Delhi
replace dist_code_after_group = 5501 if `old_var' == 7000 // DELHI Delhi


replace dist_code_after_group = 5601 if `old_var' == 2722 // MAHARASHTRA Mumbai_Suburban
replace dist_code_after_group = 5601 if `old_var' == 2723 // MAHARASHTRA Mumbai



*labelling old and new district code variables
label var `old_var' "pre-grouping district codes"
label var dist_code_after_group "district codes after group formed for multi-parent district"




*displaying all the changes where the new variables and old variables differ

set more off

display "displaying all the changes where the new variables and old variables differ"
display ""

list `old_var' dist_code_after_group if `old_var' != dist_code_after_group , abbreviate(33) sepby(dist_code_after_group)


*displaying report for duplicates 

display ""
display "Displaying report for duplicates "
display ""

duplicates report `old_var'
duplicates report dist_code_after_group










end



*********************************************************
*********************************************************
