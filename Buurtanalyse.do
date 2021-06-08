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

	global dir "/Users/Maartje/Desktop/LJA/Paper politicologenetmaal/Analyses"

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
	lab var edu_mid "% Medium edsucated"
	lab var edu_high "% Higher educated"
	lab var housing_soc "% Social housing"
	lab var stichting_density "Density of foundations"
	lab var vereniging_density "Density of associations"
	lab var leisure_density "Density of leisure organisations"
	
	
	
	
	
