//intial set of inputs
set obs 300
generate hospital_beds = 82   //define beds in hospital
generate gamma_parameter= 75  //define daily census in hospital 

//
gen census_1= _n    
gen prob_census_1= exp(-gamma_parameter)* ( (gamma_parameter)^census_1 / exp(lnfactorial(census_1)) )  // finding proabilites for particular each census value

//finding probability for pseudo-poisson distribution
egen prob_sum = sum(prob_census_1) if census_1 >= hospital_beds
gen prob_census_2= prob_census_1 if census_1 < hospital_beds   //finding new probability for census >= #beds in hospital
replace prob_census_2= prob_sum if census_1 >= hospital_beds  

//graph of pseudo-poisson distribution
//twoway connected prob_census_2 census_1 if census_1 <= hospital_beds & census_1 > 40,  xtitle("Census Number") ytitle("Probability") title("Pseudo Poisson vs others")

//experimenting with secondary axis
//twoway (connected prob_census_2 census_1 if census_1 < hospital_beds, c(1) yaxis(1) xtitle("Census Number") ytitle("Probability") title("Pseudo Poisson vs others") ) || (connected prob_census_2 census_1 if census_1 >= hospital_beds, c(1) yaxis(2) )
	   
//expriment 2
	   
twoway (connected prob_census_2 census_1 if census_1 < hospital_beds, c(l) yaxis(1) ) || (connected prob_census_2 census_1 if census_1 == hospital_beds, c(l) yaxis(2) )	   
	   

//probability for theoretical distribution [ g(c)]

gen gamma_parameter_elective= 52.5  //this value in an input for e.g. P(n)=0.1 , P(p)=0.9, gamma(p)=0.9*75=67.5    and   gen gamma_parameter_elective= 0.0 //value of P(n)=0.3

generate F_value= poisson(gamma_parameter, hospital_beds-1)   //denotes F(s-1,gamma)   
gen prob_instant= poissonp(gamma_parameter,hospital_beds)    // denotes p(s,gamma)
gen bed_elective_term= hospital_beds/(hospital_beds - gamma_parameter_elective)   // denotes [  s/s-gamma(p) ]

gen phi_new= 1/(F_value + bed_elective_term * prob_instant) //finding value of phi( s,gamma, gamma(p))
gen prob_census_3= prob_census_1 * phi_new   //finding proabability for census<beds
gen prob_census_max= bed_elective_term * prob_instant * phi_new //finding proabability for census>=beds

//defining perfect theoretical probability for census
gen prob_census_theory= prob_census_3 if census_1 < hospital_beds 
replace prob_census_theory= prob_census_max if census_1 >= hospital_beds  

//graph of theoretical probability distribution
//twoway connected prob_census_theory census_1 if census_1 <= hospital_beds & census_1 > 40,  xtitle("Census Number") ytitle("Probability") title("Pseudo Poisson vs Theorotical")

//finding value of gamma_parameter_hat_elective for which pseudo-poisson is equal to theoretical distribution
generate F_value_new= poisson(gamma_parameter, hospital_beds)   //denotes F(s,gamma)
generate gamma_parameter_hat_elective = hospital_beds * ( (1- F_value_new)/ (1-F_value) )

//finding mean census for pseudo-poission and theoretical distribution
egen cen_mean_pseudo = sum(census_1* prob_census_2) if census_1 <= hospital_beds   // mean of pseudo-poission 
egen cen_mean_theory = sum(census_1* prob_census_theory) if census_1 <= hospital_beds // mean of theoretical distribution

//for running simulation (different value of GAMMA_ELECTIVE need to DROP all these variables
//drop gamma_parameter_elective F_value prob_instant bed_elective_term phi_new prob_census_3 prob_census_max prob_census_theory F_value_new gamma_parameter_hat_elective cen_mean_pseudo cen_mean_theory

//storing values 

//generate prob_gamma_e_75 = prob_census_theory  // when gamma_parameter_elective= 75
//generate prob_gamma_e_67 = prob_census_theory  // when gamma_parameter_elective= 67.5
generate prob_gamma_e_52 = prob_census_theory  // when gamma_parameter_elective= 52.5


//plotting theoretical and other distributions together

//twoway (connected prob_gamma_e_75 census_1 if census_1 <= hospital_beds & census_1 > 55,  xtitle("Census Number") ytitle("Probability") title("Pseudo Poisson vs Theoretical")) || (connected prob_gamma_e_67 census_1 if census_1 <= hospital_beds & census_1 > 55 ) || (connected prob_gamma_e_52 census_1 if census_1 <= hospital_beds & census_1 > 55 ) || (connected prob_census_2 census_1 if census_1 <= hospital_beds & census_1 > 55 ) , ///  
//legend(label(1 gamma_75)) legend(label(2 gamma_67)) legend(label(3 gamma_52)) legend(label(4 pseudo)) 




//Doing simulation			

//before running simulation dropping previous variables
drop gamma_parameter_elective F_value prob_instant bed_elective_term phi_new prob_census_3 prob_census_max prob_census_theory F_value_new gamma_parameter_hat_elective cen_mean_pseudo cen_mean_theory

//define parameters
generate gamma_e_75 = 75.0  // when gamma_parameter_elective= 75
generate gamma_e_67 = 67.5  // when gamma_parameter_elective= 67.5
generate gamma_e_52 = 52.5  // when gamma_parameter_elective= 52.5
generate gamma_e_41 = 41.0  // when gamma_parameter_elective= 41.0
generate gamma_e_22 = 22.5  // when gamma_parameter_elective= 22.5
generate gamma_e_0  = 0.0   // when gamma_parameter_elective= 0.0

foreach elec_para of varlist gamma_e_75-gamma_e_0 {
		gen gamma_parameter_elective= `elec_para'
		generate F_value= poisson(gamma_parameter, hospital_beds-1)   //denotes F(s-1,gamma)   
		gen prob_instant= poissonp(gamma_parameter,hospital_beds)    // denotes p(s,gamma)
		gen bed_elective_term= hospital_beds/(hospital_beds - gamma_parameter_elective)   // denotes [  s/s-gamma(p) ]

		gen phi_new= 1/(F_value + bed_elective_term * prob_instant) //finding value of phi( s,gamma, gamma(p))
		gen prob_census_3= prob_census_1 * phi_new   //finding proabability for census<beds
		gen prob_census_max= bed_elective_term * prob_instant * phi_new //finding proabability for census>=beds

		//defining perfect theoretical probability for census
		gen prob_census_theory= prob_census_3 if census_1 < hospital_beds 
		replace prob_census_theory= prob_census_max if census_1 >= hospital_beds
		gen prob_new_`elec_para' = prob_census_theory
		
		drop gamma_parameter_elective F_value prob_instant bed_elective_term phi_new prob_census_3 prob_census_max prob_census_theory //if `elec_para'!= gamma_e_52
		}

//plotting graphs together		
twoway (connected prob_new_gamma_e_75 census_1 if census_1 <= hospital_beds & census_1 > 55,  xtitle("Census Number") ytitle("Probability") title("Pseudo Poisson vs Theoretical")) || (connected prob_new_gamma_e_67 census_1 if census_1 <= hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_52 census_1 if census_1 <= hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_41 census_1 if census_1 <= hospital_beds & census_1 > 55 )|| (connected prob_new_gamma_e_22 census_1 if census_1 <= hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_0 census_1 if census_1 <= hospital_beds & census_1 > 55 ) || (connected prob_census_2 census_1 if census_1 <= hospital_beds & census_1 > 55 ) , ///  
legend(label(1 gamma_75)) legend(label(2 gamma_67)) legend(label(3 gamma_52)) legend(label(4 gamma_41)) legend(label(5 gamma_22)) legend(label(6 gamma_0)) legend(label(7 pseudo)) 		

//on introducing secondary axis
twoway (connected prob_new_gamma_e_75 census_1 if census_1 < hospital_beds & census_1 > 55,  c(1) yaxis(1) xtitle("Census Number") ytitle("Probability") title("Pseudo Poisson vs Theoretical")) || (connected prob_new_gamma_e_75 census_1 if census_1 == hospital_beds, c(1) yaxis(2) ) || (connected prob_new_gamma_e_67 census_1 if census_1 <= hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_52 census_1 if census_1 <= hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_41 census_1 if census_1 <= hospital_beds & census_1 > 55 )|| (connected prob_new_gamma_e_22 census_1 if census_1 <= hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_0 census_1 if census_1 <= hospital_beds & census_1 > 55 ) || (connected prob_census_2 census_1 if census_1 <= hospital_beds & census_1 > 55 ) , ///  
legend(label(1 gamma_75)) legend(label(2 gamma_67)) legend(label(3 gamma_52)) legend(label(4 gamma_41)) legend(label(5 gamma_22)) legend(label(6 gamma_0)) legend(label(7 pseudo)) 		

/////

gen prob_max_e_75= prob_new_gamma_e_75 if census_1 == hospital_beds
gen prob_max_e_67= prob_new_gamma_e_67 if census_1 == hospital_beds
gen prob_max_e_52= prob_new_gamma_e_52 if census_1 == hospital_beds
gen prob_max_e_41= prob_new_gamma_e_41 if census_1 == hospital_beds
gen prob_max_e_22= prob_new_gamma_e_22 if census_1 == hospital_beds
gen prob_max_e_0 = prob_new_gamma_e_0  if census_1 == hospital_beds
gen prob_max_pseudo= prob_census_2     if census_1 == hospital_beds

//for census< #beds i.e. graphs with clear and distinct peaks for various values of gamma_elective
twoway (connected prob_new_gamma_e_75 census_1 if census_1 < hospital_beds & census_1 > 55,  xtitle("Census Number") ytitle("Probability") title("Pseudo Poisson vs Theoretical")) || (connected prob_new_gamma_e_67 census_1 if census_1 < hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_52 census_1 if census_1 < hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_41 census_1 if census_1 < hospital_beds & census_1 > 55 )|| (connected prob_new_gamma_e_22 census_1 if census_1 < hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_0 census_1 if census_1 < hospital_beds & census_1 > 55 ) || (connected prob_census_2 census_1 if census_1 < hospital_beds & census_1 > 55 ) , ///  
legend(label(1 gamma_75)) legend(label(2 gamma_67)) legend(label(3 gamma_52)) legend(label(4 gamma_41)) legend(label(5 gamma_22)) legend(label(6 gamma_0)) legend(label(7 pseudo)) 		


//for census< #beds and census+#beds 
twoway (connected prob_new_gamma_e_75 census_1 if census_1 < hospital_beds & census_1 > 55,  xtitle("Census Number") ytitle("Probability") title("Pseudo Poisson vs Theoretical")) || (connected prob_new_gamma_e_67 census_1 if census_1 < hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_52 census_1 if census_1 < hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_41 census_1 if census_1 < hospital_beds & census_1 > 55 )|| (connected prob_new_gamma_e_22 census_1 if census_1 < hospital_beds & census_1 > 55 ) || (connected prob_new_gamma_e_0 census_1 if census_1 < hospital_beds & census_1 > 55 ) || (connected prob_census_2 census_1 if census_1 < hospital_beds & census_1 > 55 )|| (connected prob_max_e_75 census_1 if census_1 == hospital_beds, c(l) yaxis(2)) || (connected prob_max_e_67 census_1 if census_1 == hospital_beds, c(l) yaxis(2)) || (connected prob_max_e_52 census_1 if census_1 == hospital_beds, c(l) yaxis(2)) (connected prob_max_e_41 census_1 if census_1 == hospital_beds, c(l) yaxis(2)) || (connected prob_max_e_22 census_1 if census_1 == hospital_beds, c(l) yaxis(2)) || (connected prob_max_e_0 census_1 if census_1 == hospital_beds, c(l) yaxis(2) ) || (connected prob_max_pseudo census_1 if census_1 == hospital_beds, c(l) yaxis(2) ) , ///  
legend(label(1 gamma_75)) legend(label(2 gamma_67)) legend(label(3 gamma_52)) legend(label(4 gamma_41)) legend(label(5 gamma_22)) legend(label(6 gamma_0)) legend(label(7 pseudo)) 		

