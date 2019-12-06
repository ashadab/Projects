/* Objective: 
*using it to assign district codes to all the branch open data, educationloan data
*we have kept only unique values from district.do and branch_district.do files
*in the end we have appeneded the codes we have created while finding number of branches present in a district.

***********************************************************************************************************************

Key words for various changes made to the file: 

For Normalization of new districts back to their parent (NSS 61 codes)
* Norm61: assigning same code as

For correcting wrong codes of Senjuti:
* commenting out since Senjuti assigned a wrong code

For tagging that Senjuti already did CORRECT normlization of new districts to NSS61- level
* Senjuti_norm: she already assigned correct code as 

*/


generate district_code=3501 if District=="SOUTH ANDAMAN" & State== "ANDAMAN & NICOBAR ISLANDS"

replace district_code=3502 if District=="NICOBAR" & State== "ANDAMAN & NICOBAR ISLANDS"
replace district_code=3503 if District=="NORTH AND MIDDLE ANDAMAN" & State== "ANDAMAN & NICOBAR ISLANDS"
replace district_code=2811 if District=="SRIKAKULAM" & State=="ANDHRA PRADESH"
replace district_code=2812 if District=="VIZIANAGARAM" & State=="ANDHRA PRADESH"
replace district_code=2813 if District=="VISHAKHAPATNAM" & State=="ANDHRA PRADESH"
replace district_code=2814 if District=="EAST GODAVARI" & State=="ANDHRA PRADESH"
replace district_code=2815 if District=="WEST GODAVARI" & State=="ANDHRA PRADESH"
replace district_code=2816 if District=="KRISHNA" & State=="ANDHRA PRADESH"
replace district_code=2817 if District=="GUNTUR" & State=="ANDHRA PRADESH"
replace district_code=2818 if District=="PRAKASAM" & State=="ANDHRA PRADESH"
replace district_code=2819 if District=="NELLORE" & State=="ANDHRA PRADESH"
replace district_code=2801 if District=="ADILABAD" & State=="ANDHRA PRADESH"
replace district_code=2802 if District=="NIZAMABAD" & State=="ANDHRA PRADESH"
replace district_code=2803 if District=="KARIMNAGAR" & State=="ANDHRA PRADESH"
replace district_code=2804 if District=="MEDAK" & State=="ANDHRA PRADESH"
replace district_code=2805 if District=="HYDERABAD" & State=="ANDHRA PRADESH"
replace district_code=2806 if District=="RANGAREDDY" & State=="ANDHRA PRADESH"
replace district_code=2807 if District=="MAHBUBNAGAR" & State=="ANDHRA PRADESH"
replace district_code=2808 if District=="NALGONDA" & State=="ANDHRA PRADESH"
replace district_code=2809 if District=="WARANGAL" & State=="ANDHRA PRADESH"
replace district_code=2810 if District=="KHAMMAM" & State=="ANDHRA PRADESH"
replace district_code=2820 if District=="CUDDAPAH" & State=="ANDHRA PRADESH"
replace district_code=2821 if District=="KURNOOL" & State=="ANDHRA PRADESH"
replace district_code=2822 if District=="ANANTAPUR" & State=="ANDHRA PRADESH"
replace district_code=2823 if District=="CHITTOOR" & State=="ANDHRA PRADESH"
replace district_code=1201 if District=="TAWANG" & State=="ARUNACHAL PRADESH"
replace district_code=1202 if District=="WEST KAMENG" & State=="ARUNACHAL PRADESH"
replace district_code=1203 if District=="EAST KAMENG" & State=="ARUNACHAL PRADESH"
replace district_code=1204 if District=="PAPUMPARE" & State=="ARUNACHAL PRADESH"
replace district_code=1205 if District=="LOWER SUBANSIRI" & State=="ARUNACHAL PRADESH"
replace district_code=1206 if District=="UPPER SUBANSIRI" & State=="ARUNACHAL PRADESH"
replace district_code=1207 if District=="WEST SIANG" & State=="ARUNACHAL PRADESH"
replace district_code=1208 if District=="EAST SIANG" & State=="ARUNACHAL PRADESH"
replace district_code=1209 if District=="UPPER SIANG" & State=="ARUNACHAL PRADESH"
replace district_code=1210 if District=="LOWER DIBANG VALLEY" & State=="ARUNACHAL PRADESH"
replace district_code=1211 if District=="LOHIT" & State=="ARUNACHAL PRADESH"
replace district_code=1212 if District=="CHUNGLANG" & State=="ARUNACHAL PRADESH"
replace district_code=1213 if District=="TIRAP" & State=="ARUNACHAL PRADESH"
replace district_code=1214 if District=="ANJAW" & State=="ARUNACHAL PRADESH"
replace district_code=1216 if District=="LOWER DIBANG VALLEY" & State=="ARUNACHAL PRADESH"
replace district_code=1812 if District=="LAKSHADWEEPHIMPUR" & State=="ASSAM"
replace district_code=1812 if District=="LAKHIMPUR" & State=="ASSAM"
replace district_code=1814 if District=="TINSUKIA" & State=="ASSAM"
replace district_code=1815 if District=="DIBRUGARH" & State=="ASSAM"
replace district_code=1816 if District=="SIBSAGAR" & State=="ASSAM"
replace district_code=1817 if District=="JORHAT" & State=="ASSAM"
replace district_code=1818 if District=="GOLAGHAT" & State=="ASSAM"
replace district_code=1801 if District=="KOKRAJHAR" & State=="ASSAM"
replace district_code=1802 if District=="DHUBRI" & State=="ASSAM"
replace district_code=1803 if District=="GOALPARA" & State=="ASSAM"
replace district_code=1804 if District=="BONGAIGAON" & State=="ASSAM"
replace district_code=1805 if District=="BARPETA" & State=="ASSAM"
replace district_code=1806 if District=="KAMRUP" & State=="ASSAM"
replace district_code=1807 if District=="NALBARI" & State=="ASSAM"
replace district_code=1819 if District=="KARBI ANGLONG" & State=="ASSAM"
replace district_code=1820 if District=="NORTH CACHAR HILLS" & State=="ASSAM"
replace district_code=1821 if District=="CACHAR" & State=="ASSAM"
replace district_code=1822 if District=="KARIMGANJ" & State=="ASSAM"
replace district_code=1823 if District=="HAILAKANDI" & State=="ASSAM"
replace district_code=1808 if District=="DARRANG" & State=="ASSAM"
replace district_code=1809 if District=="MARIGAON" & State=="ASSAM"
replace district_code=1809 if District=="MORIGAON" & State=="ASSAM"
replace district_code=1810 if District=="NAGAON" & State=="ASSAM"
replace district_code=1811 if District=="SONITPUR" & State=="ASSAM"

* Norm61: assigning same code as BONGAIGAON
replace district_code=1804 if District=="CHIRANG" & State=="ASSAM"

* Norm61: assigning same code as BARPETA
replace district_code=1805 if District=="BAKSA" & State=="ASSAM"

* Norm61: assigning same code as Undivided Kamprup district
replace district_code=1806 if District=="GUWAHATI" & State=="ASSAM"


* Norm61: assigning same code as Darrang(BTC)
replace district_code=1808 if District=="UDALGURI" & State=="ASSAM"

* Norm61: assigning same code as Undivided Kamprup district
*Guwahati is also known as Kamrup_Metropolitan ( https://en.wikipedia.org/wiki/Kamrup_Metropolitan_(Guwahati)_district )
replace district_code=1806 if District=="KAMRUP METROPOLITAN" & State=="ASSAM"

replace district_code=1812 if District=="DHEMAJI" & State=="ASSAM"
replace district_code=1813 if District=="DHEMAJI" & State=="ASSAM"
replace district_code=1001 if District=="PASCHIMI CHAMPARAN" & State=="BIHAR"
replace district_code=1002 if District=="PURBI CHAMPARAN" & State=="BIHAR"
replace district_code=1003 if District=="SHEOHAR" & State=="BIHAR"
replace district_code=1004 if District=="SITAMARHI" & State=="BIHAR"
replace district_code=1005 if District=="MADHUBANI" & State=="BIHAR"
replace district_code=1006 if District=="SAPAUL" & State=="BIHAR"
replace district_code=1006 if District=="SUPAUL" & State=="BIHAR"
replace district_code=1007 if District=="ARARIA" & State=="BIHAR"
replace district_code=1008 if District=="KISHANGANJ" & State=="BIHAR"
replace district_code=1009 if District=="PURNIA" & State=="BIHAR"
replace district_code=1010 if District=="KATIHAR" & State=="BIHAR"
replace district_code=1011 if District=="MADHEPURA" & State=="BIHAR"
replace district_code=1012 if District=="SAHARSA" & State=="BIHAR"
replace district_code=1013 if District=="DARBHANGA" & State=="BIHAR"
replace district_code=1014 if District=="MUZAFFARPUR" & State=="BIHAR"
replace district_code=1015 if District=="GOPALGANJ" & State=="BIHAR"
replace district_code=1016 if District=="SIWAN" & State=="BIHAR"
replace district_code=1017 if District=="SARAN" & State=="BIHAR"
replace district_code=1018 if District=="VAISHALI" & State=="BIHAR"
replace district_code=1019 if District=="SAMASTIPUR" & State=="BIHAR"
replace district_code=1020 if District=="BENGUSARAI" & State=="BIHAR"
replace district_code=1020 if District=="BNGUSARAI" & State=="BIHAR"
replace district_code=1020 if District=="BEGUSARAI" & State=="BIHAR"
replace district_code=1021 if District=="KHAGARIA" & State=="BIHAR"
replace district_code=1022 if District=="BHAGALPUR" & State=="BIHAR"
replace district_code=1023 if District=="BANKA" & State=="BIHAR"
replace district_code=1024 if District=="MUNGER" & State=="BIHAR"
replace district_code=1025 if District=="LAKHISARAI" & State=="BIHAR"
replace district_code=1026 if District=="SHEIKHPURA" & State=="BIHAR"
replace district_code=1027 if District=="NALANDA" & State=="BIHAR"
replace district_code=1028 if District=="PATNA" & State=="BIHAR"
replace district_code=1029 if District=="BHOJPUR" & State=="BIHAR"
replace district_code=1030 if District=="BUXAR" & State=="BIHAR"
replace district_code=1031 if District=="KAIMUR BHABUA" & State=="BIHAR"
replace district_code=1031 if District=="KAIMUR" & State=="BIHAR"
replace district_code=1032 if District=="ROHTAS" & State=="BIHAR"
replace district_code=1033 if District=="JEHANABAD" & State=="BIHAR"
replace district_code=1034 if District=="AURANGABAD" & State=="BIHAR"
replace district_code=1035 if District=="GAYA" & State=="BIHAR"
replace district_code=1036 if District=="NAWADA" & State=="BIHAR"
replace district_code=1037 if District=="JAMUI" & State=="BIHAR"

* Norm61: assigning same code as Jehanabad
replace district_code=1033 if District=="ARWAL" & State=="BIHAR"

replace district_code=401 if District=="CHANDIGARH" & State=="CHANDIGARH"
replace district_code=2201 if District=="KORIYA" & State=="CHHATTISGARH"
replace district_code=2202 if District=="SURGUJA" & State=="CHHATTISGARH"
replace district_code=2203 if District=="JASHPUR" & State=="CHHATTISGARH"
replace district_code=2204 if District=="RAIGARH" & State=="CHHATTISGARH"
replace district_code=2205 if District=="KORBA" & State=="CHHATTISGARH"
replace district_code=2206 if District=="JANJGIR-CHAMPA" & State=="CHHATTISGARH"
replace district_code=2207 if District=="BILASPUR" & State=="CHHATTISGARH"
replace district_code=2208 if District=="KAWARDHA" & State=="CHHATTISGARH"
replace district_code=2209 if District=="RAJNANDGAON" & State=="CHHATTISGARH"
replace district_code=2210 if District=="DURG" & State=="CHHATTISGARH"
replace district_code=2211 if District=="RAIPUR" & State=="CHHATTISGARH"
replace district_code=2212 if District=="MAHASAMUND" & State=="CHHATTISGARH"
replace district_code=2213 if District=="DHAMTARI" & State=="CHHATTISGARH"
replace district_code=2214 if District=="KANKER" & State=="CHHATTISGARH"
replace district_code=2215 if District=="BASTAR" & State=="CHHATTISGARH"
replace district_code=2216 if District=="DANTEWADA" & State=="CHHATTISGARH"

* Norm61: assigning same code as Bastar
replace district_code=2215 if District=="NARAYANPUR" & State=="CHHATTISGARH"

* Norm61: assigning same code as Dantewada
replace district_code=2216 if District=="BIJAPUR" & State=="CHHATTISGARH"

replace district_code=2601 if District=="DADRA&NAGAR HAVELI" & State=="DADRA & NAGAR HAVELI"
replace district_code=2501 if District=="DIU" & State=="DAMAN & DIU"
replace district_code=2502 if District=="DAMAN" & State=="DAMAN & DIU"
replace district_code=3001 if District=="NORH GOA" & State=="GOA"
replace district_code=3001 if District=="NORTH GOA" & State=="GOA"
replace district_code=3002 if District=="SOUTH GOA" & State=="GOA"
replace district_code=2417 if District=="PANCH MAHALS" & State=="GUJARAT"
replace district_code=2418 if District=="DOHAD" & State=="GUJARAT"
replace district_code=2418 if District=="DAHOD" & State=="GUJARAT"
replace district_code=2419 if District=="VADODARA" & State=="GUJARAT"
replace district_code=2420 if District=="NARMADA" & State=="GUJARAT"
replace district_code=2421 if District=="BHARUCH" & State=="GUJARAT"
replace district_code=2422 if District=="SURAT" & State=="GUJARAT"
replace district_code=2423 if District=="DANGS" & State=="GUJARAT"
replace district_code=2424 if District=="NAVSARI" & State=="GUJARAT"
replace district_code=2425 if District=="VALSAD" & State=="GUJARAT"
replace district_code=2426 if District=="MAHESANA" & State=="GUJARAT"
replace district_code=2404 if District=="MAHESANA" & State=="GUJARAT"
replace district_code=2405 if District=="SABAR KANTHA" & State=="GUJARAT"
replace district_code=2406 if District=="GANDHINAGAR" & State=="GUJARAT"
replace district_code=2407 if District=="AHMEDABAD" & State=="GUJARAT"
replace district_code=2415 if District=="ANAND" & State=="GUJARAT"
replace district_code=2416 if District=="KHEDA" & State=="GUJARAT"
replace district_code=2402 if District=="BANS KANTHA" & State=="GUJARAT"
replace district_code=2402 if District=="BANAS KANTHA" & State=="GUJARAT"
replace district_code=2403 if District=="PATAN" & State=="GUJARAT"
replace district_code=2401 if District=="KACHCHH" & State=="GUJARAT"
replace district_code=2408 if District=="SURENDRANAGAR" & State=="GUJARAT"
replace district_code=2409 if District=="RAJKOT" & State=="GUJARAT"
replace district_code=2410 if District=="JAMNAGAR" & State=="GUJARAT"
replace district_code=2411 if District=="PORBANDAR" & State=="GUJARAT"
replace district_code=2412 if District=="JUNAGADH" & State=="GUJARAT"
replace district_code=2413 if District=="AMRELI" & State=="GUJARAT"
replace district_code=2414 if District=="BHAVNAGAR" & State=="GUJARAT"
replace district_code=601 if District=="PANCHKULA" & State=="HARYANA"
replace district_code=602 if District=="AMBALA" & State=="HARYANA"
replace district_code=603 if District=="YAMUNANAGAR" & State=="HARYANA"
replace district_code=604 if District=="KURUKSHETRA" & State=="HARYANA"
replace district_code=605 if District=="KAITHAL" & State=="HARYANA"
replace district_code=606 if District=="KARNAL" & State=="HARYANA"
replace district_code=607 if District=="PANIPAT" & State=="HARYANA"
replace district_code=608 if District=="SONIPAT" & State=="HARYANA"
replace district_code=614 if District=="ROHTAK" & State=="HARYANA"
replace district_code=615 if District=="JHAJJAR" & State=="HARYANA"
replace district_code=618 if District=="GURGAON" & State=="HARYANA"
replace district_code=619 if District=="FARIDABAD" & State=="HARYANA"
replace district_code=609 if District=="JIND" & State=="HARYANA"
replace district_code=610 if District=="FATEHABAD" & State=="HARYANA"
replace district_code=611 if District=="SIRSA" & State=="HARYANA"
replace district_code=612 if District=="HISAR" & State=="HARYANA"
replace district_code=613 if District=="BHIWANI" & State=="HARYANA"
replace district_code=616 if District=="MAHENDRAGARH" & State=="HARYANA"
replace district_code=617 if District=="REWARI" & State=="HARYANA"

* Norm61: assigning same code as Gurgaon
replace district_code=618 if District=="MEWAT" & State=="HARYANA"

replace district_code=202 if District=="KANGRA" & State=="HIMACHAL PRADESH"
replace district_code=204 if District=="KULLU" & State=="HIMACHAL PRADESH"
replace district_code=205 if District=="MANDI" & State=="HIMACHAL PRADESH"
replace district_code=206 if District=="HAMIRPUR" & State=="HIMACHAL PRADESH"
replace district_code=207 if District=="UNA" & State=="HIMACHAL PRADESH"
replace district_code=201 if District=="CHAMBA" & State=="HIMACHAL PRADESH"
replace district_code=203 if District=="LAHUL & SPITI" & State=="HIMACHAL PRADESH"
replace district_code=208 if District=="BILASPUR" & State=="HIMACHAL PRADESH"
replace district_code=209 if District=="SOLAN" & State=="HIMACHAL PRADESH"
replace district_code=210 if District=="SIRMAUR" & State=="HIMACHAL PRADESH"
replace district_code=211 if District=="SIHIMLA" & State=="HIMACHAL PRADESH"
replace district_code=211 if District=="SHIMLA" & State=="HIMACHAL PRADESH"
replace district_code=204 if District=="KULU" & State=="HIMACHAL PRADESH"
replace district_code=212 if District=="KINNAUR" & State=="HIMACHAL PRADESH"
replace district_code=113 if District=="JAMMU" & State=="JAMMU & KASHMIR"
replace district_code=114 if District=="KATHUA" & State=="JAMMU & KASHMIR"
replace district_code=109 if District=="DODA" & State=="JAMMU & KASHMIR"
replace district_code=110 if District=="UDHAMPUR" & State=="JAMMU & KASHMIR"
replace district_code=111 if District=="POONCH" & State=="JAMMU & KASHMIR"
replace district_code=112 if District=="RAJAURI" & State=="JAMMU & KASHMIR"
replace district_code=112 if District=="RAJOURI" & State=="JAMMU & KASHMIR"
replace district_code=101 if District=="KUPWARA" & State=="JAMMU & KASHMIR"
replace district_code=102 if District=="BARAMULA" & State=="JAMMU & KASHMIR"
replace district_code=102 if District=="BARAMULLA" & State=="JAMMU & KASHMIR"
replace district_code=103 if District=="SRINAGAR" & State=="JAMMU & KASHMIR"
replace district_code=104 if District=="BADGAM" & State=="JAMMU & KASHMIR"
replace district_code=105 if District=="PULWAMA" & State=="JAMMU & KASHMIR"
replace district_code=106 if District=="ANANTNAG" & State=="JAMMU & KASHMIR"
replace district_code=107 if District=="LEH LADAKH"  & State=="JAMMU & KASHMIR"
replace district_code=108 if District=="KARGIL" & State=="JAMMU & KASHMIR"
replace district_code=2001 if District=="GARHWA" & State=="JHARKHAND"
replace district_code=2002 if District=="PALAMAU" & State=="JHARKHAND"
replace district_code=2014 if District=="RANCHI"  & State=="JHARKHAND"
replace district_code=2015 if District=="LOHARDAGGA" & State=="JHARKHAND"
replace district_code=2016 if District=="GUMLA" & State=="JHARKHAND"
replace district_code=2017 if District=="PASCHIMI SINGHBHUM" & State=="JHARKHAND"
replace district_code=2018 if District=="PURBI SINGHBHUM" & State=="JHARKHAND"
replace district_code=2003 if District=="CHATRA" & State=="JHARKHAND"
replace district_code=2004 if District=="HAZARIBAG" & State=="JHARKHAND"
replace district_code=2005 if District=="KODARMA" & State=="JHARKHAND"
replace district_code=2005 if District=="KODERMA" & State=="JHARKHAND"
replace district_code=2006 if District=="GIRIDIH" & State=="JHARKHAND"
replace district_code=2007 if District=="DEOGHAR" & State=="JHARKHAND"
replace district_code=2008 if District=="GODDA" & State=="JHARKHAND"
replace district_code=2009 if District=="SAHIBGANJ" & State=="JHARKHAND"
replace district_code=2009 if District=="SAHEBGANJ" & State=="JHARKHAND"
replace district_code=2010 if District=="PAKAUR" & State=="JHARKHAND"
replace district_code=2010 if District=="PAKUR" & State=="JHARKHAND"
replace district_code=2011 if District=="DUMKA" & State=="JHARKHAND"
replace district_code=2012 if District=="DHANBAD" & State=="JHARKHAND"
replace district_code=2013 if District=="BOKARO" & State=="JHARKHAND"

* Norm61: assigning same code as PALAMAU
replace district_code=2002 if District=="LATEHAR" & State=="JHARKHAND"

* Norm61: assigning same code as GUMLA
replace district_code=2016 if District=="SIMDEGA" & State=="JHARKHAND"

* Norm61: assigning same code as West/Paschimi Singhbhum
replace district_code=2017 if District=="SARAIKHELA KHARESWAN" & State=="JHARKHAND"
replace district_code=2017 if District=="SERAIKELA KHARSAWAN" & State=="JHARKHAND"
replace district_code=2017 if District=="SERAIKELA-KHARSAWAN" & State=="JHARKHAND"

* Norm61: assigning same code as DUMKA
replace district_code=2011 if District=="JAMTARA" & State=="JHARKHAND"

replace district_code=2910 if District=="UTTARA KANNADA" & State=="KARNATAKA"
replace district_code=2910 if District=="UTTAR KANNAD" & State=="KARNATAKA"
replace district_code=2916 if District=="UDIPI" & State=="KARNATAKA"
replace district_code=2924 if District=="DAKSHIN KANNAD" & State=="KARNATAKA"
replace district_code=2915 if District=="SHIMOGA" & State=="KARNATAKA"
replace district_code=2917 if District=="CHIKMAGALUR" & State=="KARNATAKA"
replace district_code=2923 if District=="HASSAN" & State=="KARNATAKA"
replace district_code=2925 if District=="KODAGU" & State=="KARNATAKA"
replace district_code=2918 if District=="TUMKUR" & State=="KARNATAKA"
replace district_code=2919 if District=="KOLAR" & State=="KARNATAKA"
replace district_code=2920 if District=="BANGALORE URBAN" & State=="KARNATAKA"
replace district_code=2921 if District=="BANGALORE RURAL" & State=="KARNATAKA"
replace district_code=2922 if District=="MANDYA" & State=="KARNATAKA"
replace district_code=2926 if District=="MYSORE" & State=="KARNATAKA"

* Norm61: assigning same code as Banglore Rural district
replace district_code=2921 if District=="RAMNAGAR" & State=="KARNATAKA"
replace district_code=2921 if District=="RAMANAGARA" & State=="KARNATAKA"

* Norm61: assigning same code as Kolar
replace district_code=2919 if District=="CHIKKABALLAPURA" & State=="KARNATAKA"

replace district_code=2927 if District=="CHAMARAJANAGAR" & State=="KARNATAKA"
replace district_code=2901 if District=="BELGAUM" & State=="KARNATAKA"
replace district_code=2902 if District=="BAGALKOTE" & State=="KARNATAKA"
replace district_code=2903 if District=="BIJAPUR" & State=="KARNATAKA"
replace district_code=2904 if District=="GULBARGA" & State=="KARNATAKA"
replace district_code=2905 if District=="BIDAR" & State=="KARNATAKA"
replace district_code=2906 if District=="RAICHUR" & State=="KARNATAKA"
replace district_code=2907 if District=="KOPPAL" & State=="KARNATAKA"
replace district_code=2908 if District=="GADAG" & State=="KARNATAKA"
replace district_code=2909 if District=="DHARWAD" & State=="KARNATAKA"
replace district_code=2911 if District=="HAVERI" & State=="KARNATAKA"
replace district_code=2912 if District=="BELLARY" & State=="KARNATAKA"
replace district_code=2913 if District=="CHITRADURGA" & State=="KARNATAKA"
replace district_code=2914 if District=="DAVANAGERE" & State=="KARNATAKA"
replace district_code=2914 if District=="DAVANGERE" & State=="KARNATAKA"
replace district_code=3201 if District=="KASARGOD" & State=="KERALA"
replace district_code=3201 if District=="KASARAGOD" & State=="KERALA"
replace district_code=3202 if District=="KANNUR" & State=="KERALA"
replace district_code=3203 if District=="WAYANAD" & State=="KERALA"
replace district_code=3204 if District=="KOZHIKODE" & State=="KERALA"

replace district_code=3205 if District=="MALAPPURAM" & State=="KERALA"

*commenting out since Senjuti assigned a wrong code
*replace district_code=3205 if District=="PALAKKAD" & State=="KERALA"

replace district_code=3206 if District=="PALAKKAD" & State=="KERALA"

replace district_code=3207 if District=="THRISSUR" & State=="KERALA"
replace district_code=3208 if District=="ERNAKULAM" & State=="KERALA"
replace district_code=3209 if District=="IDUKKI" & State=="KERALA"
replace district_code=3210 if District=="KOTTAYAM" & State=="KERALA"
replace district_code=3211 if District=="ALAPPUZHA" & State=="KERALA"
replace district_code=3211 if District=="ALAPUZHA" & State=="KERALA"
replace district_code=3212 if District=="PATHANAMTHITTA" & State=="KERALA"
replace district_code=3213 if District=="KOLLAM" & State=="KERALA"
replace district_code=3214 if District=="THIRUVANANTHAPURAM" & State=="KERALA"
replace district_code=3101 if District=="LAKSHADWEEP" & State=="LAKSHADWEEP"
replace district_code=2308 if District=="TIKAMGARH" & State=="MADHYA PRADESH"
replace district_code=2309 if District=="CHHATARPUR" & State=="MADHYA PRADESH"
replace district_code=2310 if District=="PANNA" & State=="MADHYA PRADESH"
replace district_code=2313 if District=="SATNA" & State=="MADHYA PRADESH"
replace district_code=2314 if District=="REWA" & State=="MADHYA PRADESH"
replace district_code=2315 if District=="UMARIA" & State=="MADHYA PRADESH"
replace district_code=2316 if District=="SHAHDOL" & State=="MADHYA PRADESH"
replace district_code=2317 if District=="SIDHI" & State=="MADHYA PRADESH"
replace district_code=2311 if District=="SAGAR" & State=="MADHYA PRADESH"
replace district_code=2312 if District=="DAMOH" & State=="MADHYA PRADESH"
replace district_code=2331 if District=="VIDISHA" & State=="MADHYA PRADESH"
replace district_code=2332 if District=="BHOPAL" & State=="MADHYA PRADESH"
replace district_code=2333 if District=="SEHORE" & State=="MADHYA PRADESH"
replace district_code=2334 if District=="RAISEN" & State=="MADHYA PRADESH"
replace district_code=2318 if District=="NEEMUCH" & State=="MADHYA PRADESH"
replace district_code=2319 if District=="MANDSAUR" & State=="MADHYA PRADESH"
replace district_code=2320 if District=="RATLAM" & State=="MADHYA PRADESH"
replace district_code=2321 if District=="UJJAIN" & State=="MADHYA PRADESH"
replace district_code=2322 if District=="SHAJAPUR" & State=="MADHYA PRADESH"
replace district_code=2323 if District=="DEWAS" & State=="MADHYA PRADESH"
replace district_code=2324 if District=="JHABUA" & State=="MADHYA PRADESH"
replace district_code=2325 if District=="DHAR" & State=="MADHYA PRADESH"
replace district_code=2326 if District=="INDORE" & State=="MADHYA PRADESH"
replace district_code=2330 if District=="RAJGARH" & State=="MADHYA PRADESH"
replace district_code=2338 if District=="KATNI" & State=="MADHYA PRADESH"
replace district_code=2339 if District=="JABALPUR" & State=="MADHYA PRADESH"
replace district_code=2340 if District=="NARSIMHAPUR" & State=="MADHYA PRADESH"
replace district_code=2341 if District=="DINDORI" & State=="MADHYA PRADESH"
replace district_code=2342 if District=="MANDLA" & State=="MADHYA PRADESH"
replace district_code=2343 if District=="CHHINDWARA" & State=="MADHYA PRADESH"
replace district_code=2344 if District=="SENOI" & State=="MADHYA PRADESH"
replace district_code=2344 if District=="SEONI" & State=="MADHYA PRADESH"
replace district_code=2345 if District=="BALAGHAT" & State=="MADHYA PRADESH"
replace district_code=2327 if District=="WEST NIMAR" & State=="MADHYA PRADESH"
replace district_code=2328 if District=="BARWANI" & State=="MADHYA PRADESH"
replace district_code=2329 if District=="EAST NIMAR" & State=="MADHYA PRADESH"
replace district_code=2335 if District=="BETUL" & State=="MADHYA PRADESH"
replace district_code=2336 if District=="HARDA" & State=="MADHYA PRADESH"
replace district_code=2337 if District=="HOSHANGABAD" & State=="MADHYA PRADESH"
replace district_code=2301 if District=="SHEOPUR" & State=="MADHYA PRADESH"
replace district_code=2302 if District=="MORENA" & State=="MADHYA PRADESH"
replace district_code=2303 if District=="BHIND" & State=="MADHYA PRADESH"
replace district_code=2304 if District=="GWALIOR" & State=="MADHYA PRADESH"
replace district_code=2305 if District=="DATIA" & State=="MADHYA PRADESH"
replace district_code=2306 if District=="SHIVPURI" & State=="MADHYA PRADESH"
replace district_code=2307 if District=="GUNA" & State=="MADHYA PRADESH"

* Norm61: assigning same code as Shahdol
replace district_code=2316 if District=="ANUPPUR" & State=="MADHYA PRADESH"

* Norm61: assigning same code as Khandwa (East Nimar)
replace district_code=2329 if District=="BURHAMPUR" & State=="MADHYA PRADESH"

* Norm61: assigning same code as Khandwa (East Nimar)
replace district_code=2329 if District=="BURHANPUR" & State=="MADHYA PRADESH"

* Norm61: assigning same code as Jhabua
replace district_code=2324 if District=="ALIRAJPUR" & State=="MADHYA PRADESH"

* Norm61: assigning same code as Sidhi
replace district_code=2317 if District=="SINGRAULI" & State=="MADHYA PRADESH"

* Norm61: assigning same code as Guna
replace district_code=2307 if District=="ASHOKNAGAR" & State=="MADHYA PRADESH"


replace district_code=2721 if District=="THANE" & State=="MAHARASHTRA"
replace district_code=2722 if District=="MUMBAI SUBURBAN" & State=="MAHARASHTRA"
replace district_code=2723 if District=="MUMBAI" & State=="MAHARASHTRA"
replace district_code=2724 if District=="RAIGARH" & State=="MAHARASHTRA"
replace district_code=2732 if District=="RATNAGIRI" & State=="MAHARASHTRA"
replace district_code=2733 if District=="SINDHUDURG" & State=="MAHARASHTRA"
replace district_code=2725 if District=="PUNE" & State=="MAHARASHTRA"
replace district_code=2726 if District=="AHMEDNAGAR" & State=="MAHARASHTRA"
replace district_code=2730 if District=="SOLAPUR" & State=="MAHARASHTRA"
replace district_code=2731 if District=="SATARA" & State=="MAHARASHTRA"
replace district_code=2734 if District=="KOLHAPUR" & State=="MAHARASHTRA"
replace district_code=2735 if District=="SANGLI" & State=="MAHARASHTRA"
replace district_code=2701 if District=="NANDURBAR" & State=="MAHARASHTRA"
replace district_code=2702 if District=="DHULE" & State=="MAHARASHTRA"
replace district_code=2703 if District=="JALGAON" & State=="MAHARASHTRA"
replace district_code=2720 if District=="NASIK" & State=="MAHARASHTRA"
replace district_code=2715 if District=="NANDED" & State=="MAHARASHTRA"
replace district_code=2716 if District=="HINGOLI" & State=="MAHARASHTRA"
replace district_code=2717 if District=="PARBHANI" & State=="MAHARASHTRA"
replace district_code=2718 if District=="JALNA" & State=="MAHARASHTRA"
replace district_code=2719 if District=="AURANGABAD" & State=="MAHARASHTRA"
replace district_code=2727 if District=="BID" & State=="MAHARASHTRA"
replace district_code=2728 if District=="LATUR" & State=="MAHARASHTRA"
replace district_code=2729 if District=="OSMANABAD" & State=="MAHARASHTRA"
replace district_code=2704 if District=="BULDANA" & State=="MAHARASHTRA"
replace district_code=2704 if District=="BULDHANA" & State=="MAHARASHTRA"
replace district_code=2705 if District=="AKOLA" & State=="MAHARASHTRA"
replace district_code=2706 if District=="WASHIM" & State=="MAHARASHTRA"
replace district_code=2708 if District=="WARDHA" & State=="MAHARASHTRA"
replace district_code=2709 if District=="NAGPUR" & State=="MAHARASHTRA"
replace district_code=2714 if District=="YAVATMAL" & State=="MAHARASHTRA"
replace district_code=2707 if District=="AMRAVATI" & State=="MAHARASHTRA"
replace district_code=2710 if District=="BHANDARA" & State=="MAHARASHTRA"
replace district_code=2711 if District=="GONDIYA" & State=="MAHARASHTRA"
replace district_code=2711 if District=="GONDIA" & State=="MAHARASHTRA"
replace district_code=2712 if District=="GADCHIROLI" & State=="MAHARASHTRA"
replace district_code=2713 if District=="CHANDRAPUR" & State=="MAHARASHTRA"
replace district_code=2724 if District=="RAIGAD" & State=="MAHARASHTRA"
replace district_code=1404 if District=="BISHNUPUR" & State=="MANIPUR"
replace district_code=1404 if District=="BISHENPUR" & State=="MANIPUR"
replace district_code=1405 if District=="THOUBAL" & State=="MANIPUR"
replace district_code=1406 if District=="IMPHAL WEST" & State=="MANIPUR"
replace district_code=1407 if District=="IMPHAL EAST" & State=="MANIPUR"
replace district_code=1401 if District=="SENAPATI" & State=="MANIPUR"
replace district_code=1402 if District=="TAMENGLONG" & State=="MANIPUR"
replace district_code=1403 if District=="CHURACHANDPUR" & State=="MANIPUR"
replace district_code=1408 if District=="UKHRUL" & State=="MANIPUR"
replace district_code=1409 if District=="CHANDEL" & State=="MANIPUR"
replace district_code=1701 if District=="WEST GARO HILLS" & State=="MEGHALAYA"
replace district_code=1702 if District=="EAST GARO HILLS" & State=="MEGHALAYA"
replace district_code=1703 if District=="SOUTH GARO HILLS" & State=="MEGHALAYA"
replace district_code=1704 if District=="WEST KHASI HILLS" & State=="MEGHALAYA"
replace district_code=1705 if District=="RI BHOI" & State=="MEGHALAYA"
replace district_code=1706 if District=="EAST KHASI HILLS" & State=="MEGHALAYA"
replace district_code=1707 if District=="JAINTIA HILLS" & State=="MEGHALAYA"
replace district_code=1501 if District=="MAMIT" & State=="MIZORAM"
replace district_code=1502 if District=="KOLASIB" & State=="MIZORAM"
replace district_code=1503 if District=="AIZWAL" & State=="MIZORAM"
replace district_code=1503 if District=="AIZAWL" & State=="MIZORAM"
replace district_code=1504 if District=="CHAMPHAI" & State=="MIZORAM"
replace district_code=1505 if District=="SERCHIP" & State=="MIZORAM"
replace district_code=1505 if District=="SERCHHIP" & State=="MIZORAM"
replace district_code=1506 if District=="LUNGLEI" & State=="MIZORAM"
replace district_code=1507 if District=="LAWNGTLAI" & State=="MIZORAM"
replace district_code=1508 if District=="SAIHA" & State=="MIZORAM"
replace district_code=1301 if District=="MON" & State=="NAGALAND"
replace district_code=1302 if District=="TUENSANG" & State=="NAGALAND"
replace district_code=1303 if District=="MOKOKCHUNG" & State=="NAGALAND"
replace district_code=1304 if District=="ZUNHEBOTO" & State=="NAGALAND"
replace district_code=1305 if District=="WOKHA" & State=="NAGALAND"
replace district_code=1306 if District=="DIMAPUR" & State=="NAGALAND"
replace district_code=1307 if District=="KOHIMA" & State=="NAGALAND"
replace district_code=1308 if District=="KHEMA" & State=="NAGALAND"
replace district_code=1308 if District=="PHEK" & State=="NAGALAND"
replace district_code=1309 if District=="KIPHIRE" & State=="NAGALAND"
replace district_code=1310 if District=="LONGLENG" & State=="NAGALAND"
replace district_code=1311 if District=="PEREN" & State=="NAGALAND"
replace district_code=2108 if District=="BALESHWAR" & State=="ORISSA"
replace district_code=2109 if District=="BHADRAK" & State=="ORISSA"
replace district_code=2110 if District=="KENDRAPARA" & State=="ORISSA"
replace district_code=2111 if District=="JAGATSINGHAPUR" & State=="ORISSA"
replace district_code=2111 if District=="JAGATSINGHPUR" & State=="ORISSA"
replace district_code=2112 if District=="CUTTACK" & State=="ORISSA"
replace district_code=2113 if District=="JAJAPUR" & State=="ORISSA"
replace district_code=2113 if District=="JAJPUR" & State=="ORISSA"
replace district_code=2114 if District=="NAYAGARH" & State=="ORISSA"
replace district_code=2116 if District=="NAYAGARH" & State=="ORISSA"
replace district_code=2117 if District=="KHORDHA" & State=="ORISSA"
replace district_code=2117 if District=="KHURDA" & State=="ORISSA"
replace district_code=2118 if District=="PURI" & State=="ORISSA"
replace district_code=2119 if District=="GANJAM" & State=="ORISSA"
replace district_code=2120 if District=="GAJAPATI" & State=="ORISSA"
replace district_code=2120 if District=="KANDHAMAL" & State=="ORISSA"
replace district_code=2121 if District=="KANDHAMAL" & State=="ORISSA"
replace district_code=2122 if District=="BOUDH" & State=="ORISSA"
replace district_code=2123 if District=="SONEPUR" & State=="ORISSA"
replace district_code=2124 if District=="BOLANGIR" & State=="ORISSA"
replace district_code=2125 if District=="NAWAPARA" & State=="ORISSA"
replace district_code=2126 if District=="KALAHANDI" & State=="ORISSA"
replace district_code=2127 if District=="RAYAGADA" & State=="ORISSA"
replace district_code=2128 if District=="NABARANGAPUR" & State=="ORISSA"
replace district_code=2128 if District=="NAWRANGPUR" & State=="ORISSA"
replace district_code=2129 if District=="KORAPUT" & State=="ORISSA"
replace district_code=2130 if District=="MALKANGIRI" & State=="ORISSA"
replace district_code=2101 if District=="BARGARH" & State=="ORISSA"
replace district_code=2102 if District=="JHARSUGUDA" & State=="ORISSA"
replace district_code=2103 if District=="SAMBALPUR" & State=="ORISSA"
replace district_code=2104 if District=="DEOGARH" & State=="ORISSA"
replace district_code=2105 if District=="SUNDARGARH" & State=="ORISSA"
replace district_code=2106 if District=="KEONJHAR" & State=="ORISSA"
replace district_code=2107 if District=="MAYURBHANJ" & State=="ORISSA"
replace district_code=2114 if District=="DHENKANAL" & State=="ORISSA"
replace district_code=2115 if District=="ANGUL" & State=="ORISSA"
replace district_code=3401 if District=="YANAM" & State=="PUDUCHERRY"
replace district_code=3402 if District=="PUDUCHERRY" & State=="PUDUCHERRY"
replace district_code=3403 if District=="MAHE" & State=="PUDUCHERRY"
replace district_code=3404 if District=="KARAIKAL" & State=="PUDUCHERRY"
replace district_code=301 if District=="GURDASPUR" & State=="PUNJAB"
replace district_code=302 if District=="AMRITSAR" & State=="PUNJAB"
replace district_code=303 if District=="KAPURTHALA" & State=="PUNJAB"
replace district_code=304 if District=="JALANDHAR" & State=="PUNJAB"
replace district_code=305 if District=="HOSHIARPUR" & State=="PUNJAB"
replace district_code=306 if District=="NAWANSHAHR" & State=="PUNJAB"

* Senjuti_norm: its NOT a new district BUT NAWANSHAHR was renamed as Sha. bhagat singh nagar  
replace district_code=306 if District=="SHAHID BHAGAT SINGH NAGAR" & State=="PUNJAB"

replace district_code=307 if District=="RUPNAGAR" & State=="PUNJAB"
replace district_code=308 if District=="FATEHGARH SAHIB" & State=="PUNJAB"
replace district_code=309 if District=="LUDHIANA" & State=="PUNJAB"
replace district_code=310 if District=="MOGA" & State=="PUNJAB"
replace district_code=311 if District=="FIROZPUR" & State=="PUNJAB"
replace district_code=311 if District=="FEROZPUR" & State=="PUNJAB"
replace district_code=312 if District=="MUKTSAR" & State=="PUNJAB"
replace district_code=313 if District=="FARIDKOT" & State=="PUNJAB"
replace district_code=314 if District=="BATHINDA" & State=="PUNJAB"
replace district_code=315 if District=="MANSA" & State=="PUNJAB"
replace district_code=316 if District=="SANGRUR" & State=="PUNJAB"
replace district_code=317 if District=="PATIALA" & State=="PUNJAB"

* Norm61: assigning same code as Rupnagar
replace district_code=307 if District=="SAHIBZADA AJIT SINGH NAGA" & State=="PUNJAB"

* Norm61: assigning same code as Rupnagar
replace district_code=307 if District=="SAHIBZADA AJIT SINGH NAGAR" & State=="PUNJAB" // Source: https://en.wikipedia.org/wiki/Sahibzada_Ajit_Singh_Nagar_district


* Norm61: assigning same code as Sangrur
replace district_code=316 if District=="BARNALA" & State=="PUNJAB"

* Norm61: assigning same code as Amritsar
replace district_code=302 if District=="TARN TARAN" & State=="PUNJAB"


replace district_code=803 if District=="BIKANER" & State=="RAJASTHAN"
replace district_code=815 if District=="JODHPUR" & State=="RAJASTHAN"
replace district_code=816 if District=="JAISALMER" & State=="RAJASTHAN"
replace district_code=817 if District=="BARMER" & State=="RAJASTHAN"
replace district_code=818 if District=="JALOR" & State=="RAJASTHAN"
replace district_code=819 if District=="SIROHI" & State=="RAJASTHAN"
replace district_code=820 if District=="PALI" & State=="RAJASTHAN"
replace district_code=806 if District=="ALWAR" & State=="RAJASTHAN"
replace district_code=807 if District=="BHARATPUR" & State=="RAJASTHAN"
replace district_code=808 if District=="DHAULPUR" & State=="RAJASTHAN"
replace district_code=808 if District=="DHOLPUR" & State=="RAJASTHAN"
replace district_code=809 if District=="KARAULI" & State=="RAJASTHAN"
replace district_code=810 if District=="SAWAI MADHOPUR" & State=="RAJASTHAN"
replace district_code=811 if District=="DAUSA" & State=="RAJASTHAN"
replace district_code=812 if District=="JAIPUR" & State=="RAJASTHAN"
replace district_code=821 if District=="AJMER" & State=="RAJASTHAN"
replace district_code=822 if District=="TONK" & State=="RAJASTHAN"
replace district_code=824 if District=="BHILWARA" & State=="RAJASTHAN"
replace district_code=825 if District=="RAJSAMAND" & State=="RAJASTHAN"
replace district_code=826 if District=="UDAIPUR" & State=="RAJASTHAN"
replace district_code=827 if District=="DUNGARPUR" & State=="RAJASTHAN"
replace district_code=828 if District=="BANSWARA" & State=="RAJASTHAN"
replace district_code=823 if District=="BUNDI" & State=="RAJASTHAN"
replace district_code=829 if District=="CHITTAURGARH" & State=="RAJASTHAN"
replace district_code=830 if District=="KOTA" & State=="RAJASTHAN"
replace district_code=831 if District=="BARAN" & State=="RAJASTHAN"
replace district_code=832 if District=="JHALAWAR" & State=="RAJASTHAN"
replace district_code=801 if District=="GANGANAGAR" & State=="RAJASTHAN"
replace district_code=802 if District=="HANUMANGARH" & State=="RAJASTHAN"

*commenting out since Senjuti assigned a wrong code
*replace district_code=803 if District=="CHURU" & State=="RAJASTHAN"

replace district_code=805 if District=="JHUNJHUNUN" & State=="RAJASTHAN"
replace district_code=804 if District=="CHURU" & State=="RAJASTHAN"
replace district_code=805 if District=="JHUNJHUNU" & State=="RAJASTHAN"
replace district_code=813 if District=="SIKAR" & State=="RAJASTHAN"
replace district_code=814 if District=="NAGAUR" & State=="RAJASTHAN"
replace district_code=1101 if District=="NORTH SIKKIM" & State=="SIKKIM"
replace district_code=1102 if District=="WEST SIKKIM" & State=="SIKKIM"
replace district_code=1103 if District=="SOUTH SIKKIM" & State=="SIKKIM"
replace district_code=1104 if District=="EAST SIKKIM" & State=="SIKKIM"
replace district_code=3301 if District=="THIRUVALLUR" & State=="TAMIL NADU"
replace district_code=3302 if District=="CHENNAI" & State=="TAMIL NADU"
replace district_code=3303 if District=="KANCHEEPURAM" & State=="TAMIL NADU"
replace district_code=3304 if District=="VELLORE" & State=="TAMIL NADU"
replace district_code=3306 if District=="TIRUVANAMALAI" & State=="TAMIL NADU"
replace district_code=3306 if District=="TIRUVANNAMALAI" & State=="TAMIL NADU"
replace district_code=3307 if District=="VILUPPURAM" & State=="TAMIL NADU"
replace district_code=3307 if District=="VILLUPURAM" & State=="TAMIL NADU"
replace district_code=3318 if District=="CUDDALORE" & State=="TAMIL NADU"
replace district_code=3314 if District=="KARUR" & State=="TAMIL NADU"
replace district_code=3315 if District=="TIRUCHIRAPALLI" & State=="TAMIL NADU"
replace district_code=3316 if District=="PERAMBALUR" & State=="TAMIL NADU"
replace district_code=3317 if District=="ARIYALUR" & State=="TAMIL NADU"
replace district_code=3313 if District=="DINDIGUL" & State=="TAMIL NADU"
replace district_code=3323 if District=="SIVAGANGA" & State=="TAMIL NADU"
replace district_code=3324 if District=="MADURAI" & State=="TAMIL NADU"
replace district_code=3325 if District=="THENI" & State=="TAMIL NADU"
replace district_code=3326 if District=="VIRUDHUNAGAR" & State=="TAMIL NADU"
replace district_code=3319 if District=="NAGAPATTINAM" & State=="TAMIL NADU"
replace district_code=3320 if District=="THIRUVARUR" & State=="TAMIL NADU"
replace district_code=3321 if District=="THANJAVUR" & State=="TAMIL NADU"
replace district_code=3322 if District=="PUDUKKOTTAI" & State=="TAMIL NADU"

*commenting out since Senjuti assigned a wrong code
*replace district_code=3321 if District=="RAMANATHAPURAM" & State=="TAMIL NADU"

replace district_code=3328 if District=="TOOTHUKUDI" & State=="TAMIL NADU"
replace district_code=3327 if District=="RAMANATHAPURAM" & State=="TAMIL NADU"
replace district_code=3329 if District=="TIRUNELVELLI" & State=="TAMIL NADU"
replace district_code=3329 if District=="TIRUNELVALI" & State=="TAMIL NADU"
replace district_code=3330 if District=="KANYAKUMARI" & State=="TAMIL NADU"
replace district_code=3305 if District=="DHARMAPURI" & State=="TAMIL NADU"
replace district_code=3308 if District=="SALEM" & State=="TAMIL NADU"
replace district_code=3309 if District=="NAMAKKAL" & State=="TAMIL NADU"
replace district_code=3310 if District=="ERODE" & State=="TAMIL NADU"
replace district_code=3311 if District=="NILGIRIS" & State=="TAMIL NADU"
replace district_code=3312 if District=="COIMBATORE" & State=="TAMIL NADU"

* Norm61: assigning same code as Dharmapuri
replace district_code=3305 if District=="KRISHNAGIRI" & State=="TAMIL NADU"

replace district_code=1601 if District=="WEST TRIPURA" & State=="TRIPURA"
replace district_code=1602 if District=="SOUTH TRIPURA" & State=="TRIPURA"
replace district_code=1603 if District=="DHALAI" & State=="TRIPURA"
replace district_code=1604 if District=="NORTH TRIPURA" & State=="TRIPURA"
replace district_code=501 if District=="UTTAR KASHI" & State=="UTTARAKHAND"
replace district_code=502 if District=="CHAMOLI" & State=="UTTARAKHAND"
replace district_code=503 if District=="RUDRAPRAYAG" & State=="UTTARAKHAND"
replace district_code=504 if District=="TEHRI GARHWAL" & State=="UTTARAKHAND"
replace district_code=505 if District=="DEHRADUN" & State=="UTTARAKHAND"
replace district_code=505 if District=="DEHRA DUN" & State=="UTTARAKHAND"
replace district_code=506 if District=="GARHWAL" & State=="UTTARAKHAND"
replace district_code=507 if District=="PITHORAGARH" & State=="UTTARAKHAND"

* Norm61: assigning same code as Bageshwar of NSS-61
replace district_code=510 if District=="BAGESHWAR" & State=="UTTARAKHAND"

replace district_code=509 if District=="ALMORA" & State=="UTTARAKHAND"

* Norm61: assigning same code as Champawat of NSS-61
replace district_code=508 if District=="CHAMPAWAT" & State=="UTTARAKHAND"

replace district_code=511 if District=="NAINITAL" & State=="UTTARAKHAND"
replace district_code=512 if District=="UDHAM SINGH NAGAR" & State=="UTTARAKHAND"
replace district_code=513 if District=="HARIDWAR" & State=="UTTARAKHAND"
replace district_code=1901 if District=="DARJILING" & State=="WEST BENGAL"
replace district_code=1902 if District=="JALPAIGURI" & State=="WEST BENGAL"
replace district_code=1903 if District=="COACH BIHAR" & State=="WEST BENGAL"
replace district_code=1904 if District=="UTTAR DINAJPUR" & State=="WEST BENGAL"

*commenting out since Senjuti assigned a wrong code
*replace district_code=1904 if District=="DAKSHIN DINAJPUR" & State=="WEST BENGAL"

replace district_code=1905 if District=="DAKSHIN DINAJPUR" & State=="WEST BENGAL"
replace district_code=1906 if District=="MALDAH" & State=="WEST BENGAL"
replace district_code=1907 if District=="MURSHIDABAD" & State=="WEST BENGAL"
replace district_code=1908 if District=="BIRBHUM" & State=="WEST BENGAL"

*commenting out since Senjuti assigned a wrong code
*replace district_code=1909 if District=="NADIA" & State=="WEST BENGAL"

*commenting out since Senjuti assigned a wrong code
*replace district_code=1910 if District=="NORTH 24 PARGANAS" & State=="WEST BENGAL"

replace district_code=1911 if District=="NORTH 24 PARGANAS" & State=="WEST BENGAL"
replace district_code=1910 if District=="NADIA" & State=="WEST BENGAL"
replace district_code=1917 if District=="KOLKATA" & State=="WEST BENGAL"
replace district_code=1918 if District=="SOUTH 24 PARGANAS" & State=="WEST BENGAL"
replace district_code=1909 if District=="BARDDHAMAN" & State=="WEST BENGAL"
replace district_code=1912 if District=="HUGLI" & State=="WEST BENGAL"
replace district_code=1916 if District=="HOWRAH" & State=="WEST BENGAL"
replace district_code=1913 if District=="BANKURA" & State=="WEST BENGAL"
replace district_code=1914 if District=="PURULIYA" & State=="WEST BENGAL"
replace district_code=1915 if District=="PASCHIM MEDINIPUR" & State=="WEST BENGAL"

* Norm61: assigning same code as Medinipur (NSS 61 round)
replace district_code=1915 if District=="PURBA MEDINIPUR" & State=="WEST BENGAL"

replace district_code=211 if District=="SIMLA" & State=="HIMACHAL PRADESH"
replace district_code=901 if District=="SAHARANPUR" & State=="UTTAR PRADESH"
replace district_code=902 if District=="MUZAFFARNAGAR" & State=="UTTAR PRADESH"
replace district_code=903 if District=="BIJNOR" & State=="UTTAR PRADESH"
replace district_code=904 if District=="MORADABAD" & State=="UTTAR PRADESH"
replace district_code=905 if District=="RAMPUR" & State=="UTTAR PRADESH"
replace district_code=906 if District=="JYOTIBA PHULE NAGAR" & State=="UTTAR PRADESH"
replace district_code=907 if District=="MEERUT" & State=="UTTAR PRADESH"
replace district_code=908 if District=="BAGHPAT" & State=="UTTAR PRADESH"
replace district_code=909 if District=="GHAZIABAD" & State=="UTTAR PRADESH"
replace district_code=910 if District=="GAUTAM BUDDHA NAGAR " & State=="UTTAR PRADESH"
replace district_code=910 if District=="GAUTAM BUDDHA NAGAR" & State=="UTTAR PRADESH"
replace district_code=924 if District=="SITAPUR" & State=="UTTAR PRADESH"
replace district_code=925 if District=="HARDOI" & State=="UTTAR PRADESH"
replace district_code=926 if District=="UNNAO" & State=="UTTAR PRADESH"
replace district_code=927 if District=="LUCKNOW" & State=="UTTAR PRADESH"
replace district_code=928 if District=="RAE BARELI" & State=="UTTAR PRADESH"
replace district_code=928 if District=="RAI BARELI" & State=="UTTAR PRADESH"
replace district_code=933 if District=="KANPUR DEHAT" & State=="UTTAR PRADESH"
replace district_code=934 if District=="KANPUR NAGAR" & State=="UTTAR PRADESH"
replace district_code=942 if District=="FATEHPUR" & State=="UTTAR PRADESH"
replace district_code=946 if District=="BARA BANKI" & State=="UTTAR PRADESH"
replace district_code=943 if District=="PRATAPGARH" & State=="UTTAR PRADESH"
replace district_code=944 if District=="KAUSHAMBI" & State=="UTTAR PRADESH"
replace district_code=945 if District=="ALLAHABAD" & State=="UTTAR PRADESH"
replace district_code=947 if District=="FAIZABAD" & State=="UTTAR PRADESH"
replace district_code=948 if District=="AMBEDKAR NAGAR" & State=="UTTAR PRADESH"
replace district_code=949 if District=="SULTANPUR" & State=="UTTAR PRADESH"
replace district_code=950 if District=="BAHRAICH" & State=="UTTAR PRADESH"
replace district_code=951 if District=="SHRAWASTI" & State=="UTTAR PRADESH"
replace district_code=951 if District=="SHRAVASTI" & State=="UTTAR PRADESH"
replace district_code=952 if District=="BALRAMPUR" & State=="UTTAR PRADESH"
replace district_code=953 if District=="GONDA" & State=="UTTAR PRADESH"
replace district_code=954 if District=="SIDDHARTHANAGAR" & State=="UTTAR PRADESH"
replace district_code=955 if District=="BASTI" & State=="UTTAR PRADESH"
replace district_code=956 if District=="SANT KABIR NAGAR" & State=="UTTAR PRADESH"
replace district_code=957 if District=="MAHARAJGANJ" & State=="UTTAR PRADESH"
replace district_code=958 if District=="GORAKHPUR" & State=="UTTAR PRADESH"
replace district_code=959 if District=="KUSHINAGAR" & State=="UTTAR PRADESH"
replace district_code=959 if District=="KUSHI NAGAR" & State=="UTTAR PRADESH"
replace district_code=960 if District=="DEORIA" & State=="UTTAR PRADESH"
replace district_code=961 if District=="AZAMGARH" & State=="UTTAR PRADESH"
replace district_code=962 if District=="MAU" & State=="UTTAR PRADESH"
replace district_code=963 if District=="BALLIA" & State=="UTTAR PRADESH"
replace district_code=964 if District=="JAUNPUR" & State=="UTTAR PRADESH"
replace district_code=965 if District=="GHAZIPUR" & State=="UTTAR PRADESH"
replace district_code=966 if District=="CHANDAULI" & State=="UTTAR PRADESH"
replace district_code=967 if District=="VARANASI" & State=="UTTAR PRADESH"
replace district_code=968 if District=="SANT RAVIDAS NAGAR" & State=="UTTAR PRADESH"
replace district_code=969 if District=="MIRZAPUR" & State=="UTTAR PRADESH"
replace district_code=970 if District=="SONBHADRA" & State=="UTTAR PRADESH"

* Norm61: assigning same code as Etah
replace district_code=917 if District=="KANSHIRAM NAGAR" & State=="UTTAR PRADESH"

replace district_code=935 if District=="JALAUN" & State=="UTTAR PRADESH"
replace district_code=936 if District=="JHANSI" & State=="UTTAR PRADESH"
replace district_code=937 if District=="LALITPUR" & State=="UTTAR PRADESH"
replace district_code=938 if District=="HAMIRPUR" & State=="UTTAR PRADESH"
replace district_code=939 if District=="MAHOBA" & State=="UTTAR PRADESH"
replace district_code=940 if District=="BANDA" & State=="UTTAR PRADESH"
replace district_code=941 if District=="CHITRAKOOT" & State=="UTTAR PRADESH"
replace district_code=911 if District=="BULANDSHAHR" & State=="UTTAR PRADESH"
replace district_code=912 if District=="ALIGARH" & State=="UTTAR PRADESH"
replace district_code=913 if District=="HATHRAS" & State=="UTTAR PRADESH"
replace district_code=914 if District=="MATHURA" & State=="UTTAR PRADESH"
replace district_code=915 if District=="AGRA" & State=="UTTAR PRADESH"
replace district_code=916 if District=="FIROZABAD" & State=="UTTAR PRADESH"
replace district_code=917 if District=="ETAH" & State=="UTTAR PRADESH"
replace district_code=918 if District=="MANIPURI" & State=="UTTAR PRADESH"
replace district_code=918 if District=="MAINPURI" & State=="UTTAR PRADESH"
replace district_code=919 if District=="BUDAUN" & State=="UTTAR PRADESH"
replace district_code=920 if District=="BAREILLY" & State=="UTTAR PRADESH"
replace district_code=921 if District=="PILIBHIT" & State=="UTTAR PRADESH"
replace district_code=922 if District=="SHAHJAHANPUR" & State=="UTTAR PRADESH"
replace district_code=923 if District=="KHERI" & State=="UTTAR PRADESH"
replace district_code=929 if District=="FARRUKHABAD" & State=="UTTAR PRADESH"
replace district_code=930 if District=="KANNAUJ" & State=="UTTAR PRADESH"
replace district_code=930 if District=="KANAUJ" & State=="UTTAR PRADESH"
replace district_code=931 if District=="ETAWAH" & State=="UTTAR PRADESH"
replace district_code=932 if District=="AURAIYA" & State=="UTTAR PRADESH"
replace district_code=2813 if District=="VISAKHAPATNAM" & State=="ANDHRA PRADESH"
replace district_code=2801 if District=="ADILABAD" & State=="TELANGANA"
replace district_code=2802 if District=="NIZAMABAD" & State=="TELANGANA"
replace district_code=2803 if District=="KARIMNAGAR" & State=="TELANGANA"
replace district_code=2804 if District=="MEDAK" & State=="TELANGANA"
replace district_code=2805 if District=="HYDERABAD" & State=="TELANGANA"
replace district_code=2806 if District=="RANGAREDDI" & State=="TELANGANA"
replace district_code=2807 if District=="MAHBUBNAGAR" & State=="TELANGANA"
replace district_code=2808 if District=="NALGONDA" & State=="TELANGANA"
replace district_code=2809 if District=="WARANGAL" & State=="TELANGANA"
replace district_code=2810 if District=="KHAMMAM" & State=="TELANGANA"
replace district_code=2820 if District=="Y.S.R." & State=="ANDHRA PRADESH"

* Senjuti_norm: she already assigned correct code as Raipur
replace district_code=2211 if District=="GARIYABAND" & State=="CHHATTISGARH"

* Senjuti_norm: she already assigned correct code as Hazaribagh
replace district_code=2004 if District=="RAMGARH" & State=="JHARKHAND"

* Senjuti_norm: she already assigned correct code as Gulbarga
replace district_code=2904 if District=="YADGIR" & State=="KARNATAKA"

replace district_code=2726 if District=="AHMADNAGAR" & State=="MAHARASHTRA"
replace district_code=2108 if District=="BALESHWAR" & State=="ODISHA"
replace district_code=2109 if District=="BHADRAK" & State=="ODISHA"
replace district_code=2110 if District=="KENDRAPARA" & State=="ODISHA"
replace district_code=2111 if District=="JAGATSINGHAPUR" & State=="ODISHA"
replace district_code=2111 if District=="JAGATSINGHPUR" & State=="ODISHA"
replace district_code=2112 if District=="CUTTACK" & State=="ODISHA"
replace district_code=2113 if District=="JAJAPUR" & State=="ODISHA"
replace district_code=2113 if District=="JAJPUR" & State=="ODISHA"
replace district_code=2114 if District=="NAYAGARH" & State=="ODISHA"
replace district_code=2116 if District=="NAYAGARH" & State=="ODISHA"
replace district_code=2117 if District=="KHORDHA" & State=="ODISHA"
replace district_code=2117 if District=="KHURDA" & State=="ODISHA"
replace district_code=2118 if District=="PURI" & State=="ODISHA"
replace district_code=2119 if District=="GANJAM" & State=="ODISHA"
replace district_code=2120 if District=="GAJAPATI" & State=="ODISHA"
replace district_code=2120 if District=="KANDHAMAL" & State=="ODISHA"
replace district_code=2121 if District=="KANDHAMAL" & State=="ODISHA"
replace district_code=2122 if District=="BOUDH" & State=="ODISHA"
replace district_code=2123 if District=="SONEPUR" & State=="ODISHA"
replace district_code=2124 if District=="BALANGIR" & State=="ODISHA"
replace district_code=2125 if District=="NAWAPARA" & State=="ODISHA"
replace district_code=2126 if District=="KALAHANDI" & State=="ODISHA"
replace district_code=2127 if District=="RAYAGADA" & State=="ODISHA"
replace district_code=2128 if District=="NABARANGAPUR" & State=="ODISHA"
replace district_code=2128 if District=="NAWRANGPUR" & State=="ODISHA"
replace district_code=2129 if District=="KORAPUT" & State=="ODISHA"
replace district_code=2130 if District=="MALKANGIRI" & State=="ODISHA"
replace district_code=2101 if District=="BARGARH" & State=="ODISHA"
replace district_code=2102 if District=="JHARSUGUDA" & State=="ODISHA"
replace district_code=2103 if District=="SAMBALPUR" & State=="ODISHA"
replace district_code=2104 if District=="DEOGARH" & State=="ODISHA"
replace district_code=2105 if District=="SUNDARGARH" & State=="ODISHA"
replace district_code=2106 if District=="KEONJHAR" & State=="ODISHA"
replace district_code=2107 if District=="MAYURBHANJ" & State=="ODISHA"
replace district_code=2114 if District=="DHENKANAL" & State=="ODISHA"
replace district_code=2115 if District=="ANGUL" & State=="ODISHA"
replace district_code=1903 if District=="KOCH BIHAR" & State=="WEST BENGAL"
replace district_code=1916 if District=="HAORA" & State=="WEST BENGAL"

* Senjuti_norm: she already assigned correct code as Muzzafarnagar 
replace district_code=902 if District=="PRABUDH NAGAR" & State=="UTTAR PRADESH"

* Senjuti_norm: she already assigned correct code as Ghaziabad
replace district_code=909 if District=="PANCHSHEEL NAGAR" & State=="UTTAR PRADESH"

replace district_code=954 if District=="SIDHARTHANAGAR" & State=="UTTAR PRADESH"




*******************************************************************************************************
*******************************************************************************************************


*Oct 16

*pasting codes we have created while finding number of branches present in a district

*Adding disrict codes for districts for whom mapping was not possible for branch opening data


replace district_code=705 if District=="NEW DELHI" & State=="NCT OF DELHI" // Source: Source NSS : 66/68th round
replace district_code=2412 if District=="GIR SOMNATH" & State=="GUJARAT" // Source: https://en.wikipedia.org/wiki/Gir_Somnath_district

replace district_code=2419 if District=="CHHOTAUDEPUR" & State=="GUJARAT" // Source: https://en.wikipedia.org/wiki/Chhota_Udaipur_district

replace district_code=2410 if District=="DEVBHUMI DWARKA" & State=="GUJARAT" // Source: https://en.wikipedia.org/wiki/Devbhumi_Dwarka_district
replace district_code=301 if District=="PATHANKOT" & State=="PUNJAB" // Source: http://pathankot.gov.in/html/districtProfile.htm
replace district_code=311 if District=="FAZILKA" & State=="PUNJAB" // Source: https://en.wikipedia.org/wiki/Fazilka_district
replace district_code=2211 if District=="BALODABAZAR" & State=="CHHATTISGARH" // Source: https://en.wikipedia.org/wiki/Baloda_Bazar_district
replace district_code=2721 if District=="PALGHAR" & State=="MAHARASHTRA" // Source: https://en.wikipedia.org/wiki/Palghar_district

replace district_code=2422 if District=="TAPI" & State=="GUJARAT" // Source: https://tapidp.gujarat.gov.in/Tapi/english/jilla-vishe/history.htm
replace district_code=2014 if District=="KHUNTI" & State=="JHARKHAND" // Source: https://en.wikipedia.org/wiki/Khunti_district
replace district_code=1902 if District=="ALIPURDUAR" & State=="WEST BENGAL" // Source: http://www.thehindu.com/news/cities/kolkata/alipurduar-to-be-20th-district-of-west-bengal/article6136173.ece
replace district_code=619 if District=="PALWAL" & State=="HARYANA" // Source: https://en.wikipedia.org/wiki/Palwal_district#cite_note-7
replace district_code=702 if District=="NORTH DELHI" & State=="NCT OF DELHI" // Source: Source NSS : 66/68th round
replace district_code=2210 if District=="BEMETARA" & State=="CHHATTISGARH" // Source: http://dcmsme.gov.in/dips/Bemetara.pdf
replace district_code=2405 if District=="ARAVALLI" & State=="GUJARAT" // Source: https://en.wikipedia.org/wiki/Aravalli_district
replace district_code=2322 if District=="AGAR-MALWA" & State=="MADHYA PRADESH" // Source: https://en.wikipedia.org/wiki/Agar_Malwa_district

replace district_code=2207 if District=="MUNGELI" & State=="CHHATTISGARH" // Source: http://dcmsme.gov.in/dips/Mungeli.pdf
replace district_code=709 if District=="SOUTH DELHI" & State=="NCT OF DELHI" // Source: Source NSS : 66/68th round
replace district_code=708 if District=="SOUTH-WEST DELHI" & State=="NCT OF DELHI" // Source: Source NSS : 66/68th round
replace district_code=2215 if District=="KONDAGAON" & State=="CHHATTISGARH" // Source: https://en.wikipedia.org/wiki/Kondagaon_district
replace district_code=704 if District=="EAST DELHI" & State=="NCT OF DELHI" // Source: Source NSS : 66/68th round
replace district_code=706 if District=="CENTRAL DELHI" & State=="NCT OF DELHI" // Source: Source NSS : 66/68th round
replace district_code=701 if District=="NORTH-WEST DELHI" & State=="NCT OF DELHI" // Source: Source NSS : 66/68th round
replace district_code=2216 if District=="SUKMA" & State=="CHHATTISGARH" // Source: https://en.wikipedia.org/wiki/Dantewada_district
replace district_code=707 if District=="WEST DELHI" & State=="NCT OF DELHI" // Source: Source NSS : 66/68th round
replace district_code=703 if District=="NORTH-EAST DELHI" & State=="NCT OF DELHI" // Source: Source NSS : 66/68th round


***************************************************************************************

*Oct-17

replace district_code=2202 if District=="BALRAMPUR" & State=="CHHATTISGARH" //formed out of Surguja district Source: http://csridentity.com/balrampurchhattisgarh/index.asp    http://www.veethi.com/places/chhattisgarh-balrampur-district-656.htm 

replace district_code=2210 if District=="BALOD" & State=="CHHATTISGARH" // refer to excel file for more detials... https://pincode.net.in/CHHATTISGARH/DURG/B/BALOD
*replace district_code=2210 if District=="DURG" & State=="CHHATTISGARH" 

replace district_code=2202 if District=="SURAJPUR" & State=="CHHATTISGARH" // refer to excel file for more detials...Source: https://pincode.net.in/CHHATTISGARH/SURGUJA/S/SURAJPUR
*replace district_code=2202 if District=="SURGUJA" & State=="CHHATTISGARH"

replace district_code=709 if District=="SOUTH-EAST DELHI" & State=="NCT OF DELHI" // refer to excel file for more detials...
*replace district_code=709 if District=="SOUTH DELHI" & State=="NCT OF DELHI" // Source: Source NSS : 66/68th round


/* Nov 9 

These are districts for which we used pin-code/address mapping to figure out open and close branches and assigned
them to their parent district

*Tiruppur and Pratapgarh are present in NSS-71st round and bank branch/#loans account data. Hence, we have  mapped 
them to their original parent district

State			District     		Parent

GUJARAT			MORBI				Rajkot, Surendranagar and Jamnagar in 2013		
TAMIL NADU		TIRUPPUR			Coimbatore and Erode
UTTAR PRADESH	AMETHI				Sultanpur and Raebareli
GUJARAT			MAHISAGAR			Panchmahal & Kheda
GUJARAT			BOTAD				Ahemdabad & Bhavnagar
UTTAR PRADESH	BHIM NAGAR/Sambhal	Moradabad and Badaun
RAJASTHAN		PRATAPGARH			Chittorgarh, Udaipur & Banswara

*/


************************************************************************************************

*Oct 26

*for mapping education loan files we have assigned following FICTIONAL codes
replace district_code=7000 if State== "DELHI" & District== "DELHI"
replace district_code=7001 if State== "TAMIL NADU" & District== "MEWAT" //need to check this with other Tamil Nadu districts

************************************************************************************************

* for Tiruppur and Pratapgarh we are no longer assigning fictional codes

*Nov 9, assigning it code same as CHITTAURGARH
replace district_code=829 if State== "RAJASTHAN" & District== "PRATAPGARH" 

*Nov 9, assigning it code same as Coimbatore
replace district_code=3312 if State== "TAMIL NADU" & District== "TIRUPPUR"
