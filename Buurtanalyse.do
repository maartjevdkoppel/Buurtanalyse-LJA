*****************************************
**         Link Jong Amsterdam         **
** 		 Neighbourhood analyses        **
**              4 May 2021             **
*****************************************

********************************************************************************
* PREPARE DATA *
********************************************************************************

* Settings * 
	
	clear
	clear matrix
	set more off
	set seed 20082013
	cap log close
	set scheme plotplain

	global dir "/Users/Maartje/Desktop/LJA/Buurtanalyse"

	global data 	"$dir/data"
	global posted 	"$dir/posted" 	
	global tables 	"$dir/tables"	
	global figures 	"$dir/figures"
	
* Open data * 

	import delimited "$data/data_buurtanalyse.csv", clear case(preserve) ///
           numericcols(3/25) stringcols(1/2)

* Clean data *

// Label all variables 
	lab var imm_Sur "% Surinamese"
	lab var imm_Ant "% Antillean"
	lab var imm_Tur "% Turkish"
	lab var imm_Mar "% Moroccan"
	lab var imm_otherNW "% Other non-western immigrant"
	lab var imm_W "% Western immigrant "
	lab var imm_autoch "% Autochthonous"
	lab var age_18t26 "% 0 to 18 year-olds"
	lab var age_18t26 "% 18 to 26 year-olds"
	lab var age_66plus "% 66 plus"
	lab var unempl "% Unemployed"
	lab var edu_low "% Lower educated"
	lab var edu_mid "% Medium educated"
	lab var edu_high "% Higher educated"
	lab var stichting_density "Density of foundations"
	lab var vereniging_density "Density of associations"
	lab var leisure_density "Density of leisure organisations"

* Exclude observations with population < 500 * 
	keep if population > 500	
	

********************************************************************************
* Analysis 1: Density of foundations *  
********************************************************************************

// Add immigration variables
	reg stichting_density imm_Sur imm_Ant imm_Tur imm_Mar imm_otherNW imm_W
	eststo Immigration1

// Add age variables
	reg stichting_density age_18t26 age_66plus
	eststo Age1

// Add unemployment variables
	reg stichting_density unempl
	eststo Unemployment1

// Add education variables
	reg stichting_density edu_low edu_high
	eststo Education1
	
// Full model 
	reg stichting_density imm_Sur imm_Ant imm_Tur imm_Mar imm_otherNW imm_W ///
	    age_18t26 age_66plus unempl edu_low edu_high
	eststo Full1

// Plot 
	coefplot Immigration1 Age1 Unemployment1 Education1 Full1, /// 
	drop(_cons) scheme(uncluttered) xline(0)
	
// Clear stored estimates
	estimates clear
	
********************************************************************************
* Analysis 2: Density of associations *  
********************************************************************************

// Add immigration variables
	reg vereniging_density imm_Sur imm_Ant imm_Tur imm_Mar imm_otherNW imm_W
	eststo Immigration2

// Add age variables
	reg vereniging_density age_18t26 age_66plus
	eststo Age2

// Add unemployment variables
	reg vereniging_density unempl
	eststo Unemployment2

// Add education variables
	reg vereniging_density edu_low edu_high
	eststo Education2
	
// Full model 
	reg vereniging_density imm_Sur imm_Ant imm_Tur imm_Mar imm_otherNW imm_W ///
	    age_18t26 age_66plus unempl edu_low edu_high
	eststo Full2

// Plot 
	coefplot Immigration2 Age2 Unemployment2 Education2 Full2, /// 
	drop(_cons) scheme(uncluttered) xline(0)	

// Clear stored estimates
	estimates clear
	
********************************************************************************
* Analysis 3: Density of leisure organisations *  
********************************************************************************

// Add immigration variables
	reg leisure_density imm_Sur imm_Ant imm_Tur imm_Mar imm_otherNW imm_W
	eststo Immigration3

// Add age variables
	reg leisure_density age_18t26 age_66plus
	eststo Age3

// Add unemployment variables
	reg leisure_density unempl
	eststo Unemployment3

// Add education variables
	reg leisure_density edu_low edu_high
	eststo Education3
	
// Full model 
	reg leisure_density imm_Sur imm_Ant imm_Tur imm_Mar imm_otherNW imm_W ///
	    age_18t26 age_66plus unempl edu_low edu_high
	eststo Full3

// Plot 
	coefplot Immigration3 Age3 Unemployment3 Education3 Full3, /// 
	drop(_cons) scheme(uncluttered) xline(0)	

// Clear stored estimates
	estimates clear
