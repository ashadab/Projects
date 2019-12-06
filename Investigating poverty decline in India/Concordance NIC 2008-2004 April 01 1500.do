//ssc install egenmore
set more off
import excel "E:\Shadab\UBC Project\NSS Data\Extracted_nss_68_10\Shadab Files\Organized Files\Concordance\March 22 2030 Modified_Concordance_nic_2008 and 2004.xlsx", sheet("Table 1") firstrow allstring

//droping values

gen NIC_2008_new= "NIC-" + "2008"  
gen NIC_2004_new= "NIC-" + "2004"

count if NIC2008== NIC_2008_new & NIC2004== NIC_2004_new  
list if NIC2008== NIC_2008_new & NIC2004== NIC_2004_new  

drop if NIC2008== NIC_2008_new & NIC2004== NIC_2004_new      //dropping values where unnecessay NIC 2008 and NIC 2004 are written in columns 
drop NIC_2008_new NIC_2004_new								 //dropping the above created variables	


list if NIC2008=="NA"  
drop if NIC2008=="NA"   									 //dropping values which were missing in NIC 2008 column as present in original excel file

distinct NIC2008    										 //total 419 unique NIC2008 codes	
drop if _n==_N                                              //dropping last variable since its kind of vacant row


//Removing (p) suffix from NIC 2004 code and breaking each code of NIC 2004 as per unique NIC 2008 code

egen NIC2004_remove_small_p= sieve(NIC2004), omit((p))       		//removing(p) from NIC 2004 code
egen NIC2004_A= sieve(NIC2004_remove_small_p) , omit((P))
split NIC2004_A, parse(+)								//splitting all NIC 2004 codes based on '+'


//creating 2-digit NIC 2004 codes from raw data

forvalues j= 1/18 {
	
	gen NIC2004_A`j'_str_length=length(NIC2004_A`j')								   //finding length of nic 2008 code in attempt to introduce leading zeros
	
	gen NIC2004_A`j'_str_modified= "0" + NIC2004_A`j' if NIC2004_A`j'_str_length!=4	   //adding leading zeros 
	replace NIC2004_A`j'_str_modified= NIC2004_A`j'   if NIC2004_A`j'_str_length==4
	
	gen NIC2004_A`j'_2_digit_interm= substr(NIC2004_A`j'_str_modified,1,2)             //generating string type 2-digit NIC 2004 codes
	gen NIC2004_A`j'_2_digit = trim(NIC2004_A`j'_2_digit_interm) 
	gen NIC2004_A`j'_numeric_2_digit = real(NIC2004_A`j'_2_digit)  		  			   //converting string type into NIC 2004 2-digit integers
	
	drop NIC2004_A`j'_str_length
	//drop NIC2004_A`j'_str_modified
	drop NIC2004_A`j'_2_digit_interm
	drop NIC2004_A`j'_2_digit 

	}

//drop NIC2004_A1 NIC2004_A2 NIC2004_A3 NIC2004_A4 NIC2004_A5 NIC2004_A6 NIC2004_A7 NIC2004_A8 NIC2004_A9 NIC2004_A10 NIC2004_A11 NIC2004_A12 NIC2004_A13 NIC2004_A14 NIC2004_A15 NIC2004_A16 NIC2004_A17 NIC2004_A18
	
//Fixed the bug of large NIC 2004 codes group by fixing spaces in Excel

list NIC2008 NIC2004 if NIC2004_A8_numeric_2_digit==. & NIC2004_A9_numeric_2_digit!=.	



//classifying each NIC 2004 code into one of 8 INDUSTRIES
	
forvalues k=1/18 {

   gen NIC2004_A`k'_industry= 1 if  ( 1 <= NIC2004_A`k'_numeric_2_digit & NIC2004_A`k'_numeric_2_digit <= 5 )		//agriculture
   replace NIC2004_A`k'_industry =2 if ( 10 <= NIC2004_A`k'_numeric_2_digit & NIC2004_A`k'_numeric_2_digit <= 14 )	//mining
   replace NIC2004_A`k'_industry =3 if ( 15 <= NIC2004_A`k'_numeric_2_digit & NIC2004_A`k'_numeric_2_digit <= 41 ) 	//manufacturing
   replace NIC2004_A`k'_industry =4 if ( 45 <= NIC2004_A`k'_numeric_2_digit & NIC2004_A`k'_numeric_2_digit <= 45 )	//construction
   replace NIC2004_A`k'_industry =5 if ( 50 <= NIC2004_A`k'_numeric_2_digit & NIC2004_A`k'_numeric_2_digit <= 55 )	//trade
   replace NIC2004_A`k'_industry =6 if ( 60 <= NIC2004_A`k'_numeric_2_digit & NIC2004_A`k'_numeric_2_digit <= 64 )	//transport
   replace NIC2004_A`k'_industry =7 if ( 65 <= NIC2004_A`k'_numeric_2_digit & NIC2004_A`k'_numeric_2_digit <= 74 )	//finance
   replace NIC2004_A`k'_industry =8 if ( NIC2004_A`k'_numeric_2_digit >= 75 & NIC2004_A`k'_numeric_2_digit !=. )	//public
   //replace NIC2004_A`k'_industry =0 if ( NIC2004_A`k'_numeric_2_digit = .)
   
 }  
   

//finding maximum and minimum of all NIC 2004 codes in a row... and if they match then we have a unique NIC 2008 and NIC 2004 pair   
egen NIC2004_A_flag_max= rowmax(NIC2004_A1_industry NIC2004_A2_industry NIC2004_A3_industry NIC2004_A4_industry NIC2004_A5_industry NIC2004_A6_industry NIC2004_A7_industry NIC2004_A8_industry NIC2004_A9_industry NIC2004_A10_industry NIC2004_A11_industry NIC2004_A12_industry)

egen NIC2004_A_flag_min= rowmin(NIC2004_A1_industry NIC2004_A2_industry NIC2004_A3_industry NIC2004_A4_industry NIC2004_A5_industry NIC2004_A6_industry NIC2004_A7_industry NIC2004_A8_industry NIC2004_A9_industry NIC2004_A10_industry NIC2004_A11_industry NIC2004_A12_industry)

gen NIC2004_A_tag = "match" if (NIC2004_A_flag_max==NIC2004_A_flag_min)

count if NIC2004_A_tag!="match"  //IMPORTANT: 13 cases where this is a mismatch 

list NIC2008 NIC2004 NIC2004_A_tag if NIC2004_A_tag!="match"


//assigning final values to NIC 2008 codes a corresponding industry
gen NIC2008_industry = NIC2004_A_flag_max if NIC2004_A_tag=="match"         


distinct NIC2008           //unique 419 NIC codes

distinct NIC2008_industry  //unique 8 industries



//process of creating 2-digit NIC2008 code (which is 4-digit string in first place)
gen nic2008_str_length=length(NIC2008)										//finding length of nic 2008 code in attempt to introduce leading zeros

tab nic2008_str_length
quietly: list NIC2008 NIC2004 nic2008_str_length if nic2008_str_length==3

gen nic2008_str_modified= "0"+ NIC2008 if nic2008_str_length!=4 			//adding leading zeros 
replace nic2008_str_modified = NIC2008 if nic2008_str_length==4  

gen replica_nic2008=NIC2008

gen nic2008_str_2_digit_code = substr(nic2008_str_modified,1,2)				//taking out first 2 digits from sub-string

gen nic2008_code =real(nic2008_str_2_digit_code)							//getting final nic 2008 2 digit numeric code



/*
gen comb1= "code " + string( nic2008_code) + " industry " + string( NIC2008_industry)

distinct nic2008_code if NIC2008_industry!=.  

distinct comb1 if NIC2008_industry!=.

count if NIC2008_industry==.
list NIC2008 nic2008_code NIC2008_industry if NIC2008_industry==.
list NIC2008 NIC2004 nic2008_code NIC2008_industry if NIC2008_industry==.
list NIC2008 NIC2004 nic2008_code if NIC2008_industry==.

*/



// 13 NIC-2008 codes (NOT unique) are exceptional 
count if NIC2008_industry==. 						
list  nic2008_code NIC2008_industry if NIC2008_industry==.

//list of nic 2008 codes for exceptions
list nic2008_code NIC2008_industry if nic2008_code==9 |  nic2008_code==11 |  nic2008_code== 19 |  nic2008_code==33 |  nic2008_code==58 |  nic2008_code==59 |  nic2008_code==81 |  nic2008_code==92 |  nic2008_code==95


//list of NIC2008 and correepsonding industry codes
sort nic2008_code, stable
list nic2008_code NIC2008_industry

/*

//handling exceptions after discussion with Arka
replace NIC2008_industry=2 if nic2008_code==9

replace NIC2008_industry=3 if nic2008_code==11

replace NIC2008_industry=3 if nic2008_code==19

replace NIC2008_industry=3 if nic2008_code==33

replace NIC2008_industry=3 if nic2008_code==58

replace NIC2008_industry=8 if nic2008_code==59

replace NIC2008_industry=7 if nic2008_code==81

replace NIC2008_industry=5 if nic2008_code==92

replace NIC2008_industry=5 if nic2008_code==95


*/



//verificatioon that all exceptions have been handled
count if NIC2008_industry==. 						
list  nic2008_code NIC2008_industry if NIC2008_industry==.


drop if NIC2008_industry==. 


//removing duplicates

distinct nic2008_code							//there are distinct 86 NIC-2008 codes
 
sort nic2008_code, stable
by nic2008_code: gen first_industry=1 if _n==1	//marking 1st observation

drop if first_industry!=1						//dropping rows/observations which are repetitive

distinct nic2008_code							
display _N										//total 86 observations are left equivalent unique NIC 2008 codes


