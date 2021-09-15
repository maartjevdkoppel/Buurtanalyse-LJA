*****************************************
**         Link Jong Amsterdam         **
** 		 Neighbourhood analyses        **
**          15 September 2021          **
*****************************************

********************************************************************************
* Prepare data *
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

* Clean / prepare data *

// New immigration variables

	gen imm_NW = imm_Sur + imm_Ant + imm_Tur + imm_Mar + imm_otherNW
	gen imm = 100 - imm_autoch

// Label all variables 
	lab var imm_Sur "% Surinaams"
	lab var imm_Ant "% Antilliaans"
	lab var imm_Tur "% Turks"
	lab var imm_Mar "% Marokaans"
	lab var imm_otherNW "% overig niet-westers"
	lab var imm_NW "% niet-westerse immigr."
	lab var imm_W "% westerse immigr."
	lab var imm "% migratieachtergrond"
	lab var age_0t18 "% 0 t/m 18 jaar"
	lab var age_18t26 "% 18 t/m 26 jaar"
	lab var age_66plus "% 66 plus"
	lab var unempl "% werkloos"
	lab var edu_low "% laag opgeleid"
	lab var edu_high "% hoog opgeleid"
	lab var stichting_density "Stichtingen dichtheid"
	lab var vereniging_density "Verenigingen dichtheid"
	lab var leisure_density "Vrijetijdsorganisaties dichtheid"

// Exclude observations with population < 500 * 
	keep if population > 500	
	

********************************************************************************
* Analysis 1: Density of foundations (stichtingen) *  
********************************************************************************

* Separate migration background variables * 

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
	
// Export 
	graph export "$figures/Stichting-separate-imm.png", replace	
	
// Clear stored estimates
	estimates clear
	
	
* Western + non-western migration *

// Add immigration variables
	reg stichting_density imm_NW imm_W
	eststo Immigration1A

// Add age variables
	reg stichting_density age_18t26 age_66plus
	eststo Age1A

// Add unemployment variables
	reg stichting_density unempl
	eststo Unemployment1A

// Add education variables
	reg stichting_density edu_low edu_high
	eststo Education1A
	
// Full model 
	reg stichting_density imm_NW imm_W age_18t26 age_66plus unempl edu_low /// 
	    edu_high
	eststo Full1A

// Plot 
	coefplot Immigration1A Age1A Unemployment1A Education1A Full1A, /// 
	drop(_cons) scheme(uncluttered) xline(0)
	
// Export 
	graph export "$figures/Stichting-NW+W-imm.png", replace	
	
// Clear stored estimates
	estimates clear
	
	
* Migration background * 
	
// Add immigration variables
	reg stichting_density imm
	eststo Immigration1B

// Add age variables
	reg stichting_density age_18t26 age_66plus
	eststo Age1B

// Add unemployment variables
	reg stichting_density unempl
	eststo Unemployment1B

// Add education variables
	reg stichting_density edu_low edu_high
	eststo Education1B
	
// Full model 
	reg stichting_density imm age_18t26 age_66plus unempl edu_low /// 
	    edu_high
	eststo Full1B

// Plot 
	coefplot Immigration1B Age1B Unemployment1B Education1B Full1B, /// 
	drop(_cons) scheme(uncluttered) xline(0)
	
// Export 
	graph export "$figures/Stichting-imm.png", replace	
	
// Clear stored estimates
	estimates clear
	
	
* Outlier check *

/* Note: Zuidas seems to present an outlier in stichting_density, as it has a relatively high density of ~565, compared to the other neighbourhoods; the second-highest density is ~166. We therefore run the same models for stichting_density again without Zuidas to check if the effect sizes are affected significantly.*/ 
	
	preserve 
	keep if bc_code != "K23"

// Add immigration variables
	reg stichting_density imm_NW imm_W
	eststo Immigration1A_K23

// Add age variables
	reg stichting_density age_18t26 age_66plus
	eststo Age1A_K23

// Add unemployment variables
	reg stichting_density unempl
	eststo Unemployment1A_K23

// Add education variables
	reg stichting_density edu_low edu_high
	eststo Education1A_K23
	
// Full model 
	reg stichting_density imm_NW imm_W age_18t26 age_66plus unempl edu_low /// 
	    edu_high
	eststo Full1A_K23

// Plot 
	coefplot Immigration1A_K23 Age1A_K23 Unemployment1A_K23 Education1A_K23 Full1A_K23, /// 
	drop(_cons) scheme(uncluttered) xline(0)
	
// Export 
	graph export "$figures/Stichting-NW+W-imm-geenZuidas.png", replace	
	
// Clear stored estimates
	estimates clear
	
	restore 
	
	
********************************************************************************
* Analysis 2: Density of associations (verenigingen) *  
********************************************************************************

* Separate migration background variables * 

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
	
// Export 
	graph export "$figures/Vereniging-separate-imm.png", replace	

// Clear stored estimates
	estimates clear

	
* Western + non-western migration *

// Add immigration variables
	reg vereniging_density imm_NW imm_W
	eststo Immigration2A

// Add age variables
	reg vereniging_density age_18t26 age_66plus
	eststo Age2A

// Add unemployment variables
	reg vereniging_density unempl
	eststo Unemployment2A

// Add education variables
	reg vereniging_density edu_low edu_high
	eststo Education2A
	
// Full model 
	reg vereniging_density imm_NW imm_W age_18t26 age_66plus unempl edu_low ///
	    edu_high
	eststo Full2A

// Plot 
	coefplot Immigration2A Age2A Unemployment2A Education2A Full2A, /// 
	drop(_cons) scheme(uncluttered) xline(0)
	
// Export 
	graph export "$figures/Vereniging-NW+W-imm.png", replace	

// Clear stored estimates
	estimates clear
	
	
* Migration background * 

// Add immigration variables
	reg vereniging_density imm
	eststo Immigration2B

// Add age variables
	reg vereniging_density age_18t26 age_66plus
	eststo Age2B

// Add unemployment variables
	reg vereniging_density unempl
	eststo Unemployment2B

// Add education variables
	reg vereniging_density edu_low edu_high
	eststo Education2B
	
// Full model 
	reg vereniging_density imm age_18t26 age_66plus unempl edu_low ///
	    edu_high
	eststo Full2B

// Plot 
	coefplot Immigration2B Age2B Unemployment2B Education2B Full2B, /// 
	drop(_cons) scheme(uncluttered) xline(0)

// Export 
	graph export "$figures/Vereniging-imm.png", replace	

// Clear stored estimates
	estimates clear


	
********************************************************************************
* Analysis 3: Density of leisure organisations (vrijetijds(buurt)organisaties) *  
********************************************************************************

* Separate migration background variables * 

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
	
// Export 
	graph export "$figures/Leisure-separate-imm.png", replace	

// Clear stored estimates
	estimates clear
	

* Western + non-western migration *

// Add immigration variables
	reg leisure_density imm_NW imm_W
	eststo Immigration3A

// Add age variables
	reg leisure_density age_18t26 age_66plus
	eststo Age3A

// Add unemployment variables
	reg leisure_density unempl
	eststo Unemployment3A

// Add education variables
	reg leisure_density edu_low edu_high
	eststo Education3A
	
// Full model 
	reg leisure_density imm_NW imm_W age_18t26 age_66plus unempl edu_low ///
	    edu_high
	eststo Full3A

// Plot 
	coefplot Immigration3A Age3A Unemployment3A Education3A Full3A, /// 
	drop(_cons) scheme(uncluttered) xline(0)
	
// Export 
	graph export "$figures/Leisure-NW+W-imm.png", replace	

// Clear stored estimates
	estimates clear

	
* Migration background * 

// Add immigration variables
	reg leisure_density imm
	eststo Immigration3B

// Add age variables
	reg leisure_density age_18t26 age_66plus
	eststo Age3B

// Add unemployment variables
	reg leisure_density unempl
	eststo Unemployment3B

// Add education variables
	reg leisure_density edu_low edu_high
	eststo Education3B
	
// Full model 
	reg leisure_density imm age_18t26 age_66plus unempl edu_low ///
	    edu_high
	eststo Full3B

// Plot 
	coefplot Immigration3B Age3B Unemployment3B Education3B Full3B, /// 
	drop(_cons) scheme(uncluttered) xline(0)
	
// Export 
	graph export "$figures/Leisure-imm.png", replace	

// Clear stored estimates
	estimates clear
	

* Outlier check *

/* Note: Sloterdijk seems to present an outlier in leisure_density, as it has a relatively high density of ~370, compared to the other neighbourhoods; the second-highest density is ~250. We therefore run the same models for leisure_density again without Sloterdijk to check if the effect sizes are affected significantly.*/	

	preserve
	keep if bc_code != "E36"

// Add immigration variables
	reg leisure_density imm_NW imm_W
	eststo Immigration3A_E36

// Add age variables
	reg leisure_density age_18t26 age_66plus
	eststo Age3A_E36

// Add unemployment variables
	reg leisure_density unempl
	eststo Unemployment3A_E36

// Add education variables
	reg leisure_density edu_low edu_high
	eststo Education3A_E36
	
// Full model 
	reg leisure_density imm_NW imm_W age_18t26 age_66plus unempl edu_low ///
	    edu_high
	eststo Full3A_E36

// Plot 
	coefplot Immigration3A_E36 Age3A_E36 Unemployment3A_E36 Education3A_E36 Full3A_E36, /// 
	drop(_cons) scheme(uncluttered) xline(0)
	
// Export 
	graph export "$figures/Leisure-NW+W-imm-geenSloterdijk.png", replace	

// Clear stored estimates
	estimates clear

	restore


	
********************************************************************************
* Map visualisation *  
********************************************************************************

/* Notes: for the map visualisation, need shapefiles (.shp and .dbf) defining 
the geographical areas, here the Amsterdam municipal 'gebiedsindeling'. We used 
the 2015 gebiedsindeling. First extract coordinates from shapefiles, merge with 
data to be visualised, then use grmap (needs to be activated) to visualise in a 
map */


	ssc install shp2dta

	cd "/Users/Maartje/Desktop/LJA/Buurtanalyse/Kaarten maken" 

// make databases out of shapefile 
	shp2dta using "/Users/Maartje/Desktop/LJA/Buurtanalyse/Kaarten maken/bc2015def_region.shp", database(db15) coordinates(coord15) replace

// merge buurtdata + geodata
	rename bc_code BC2015
	merge m:m BC2015 using "/Users/Maartje/Desktop/LJA/Buurtanalyse/Kaarten maken/db15.dta", gen(m3)
	/* 5 neighbourhoods are not matched; present in the geodata but not in the 
	 buurtanalyse data */
	
	drop _ID
	merge m:m BC2015 using "/Users/Maartje/Desktop/LJA/Buurtanalyse/Kaarten maken/db15.dta", gen(m4)
	/* all 99 neighbourhoods are matched (so including the 5 that should not be 
	included in data, bc e.g. industrial) */
	
	collapse _ID imm_autoch imm_NW imm_W age_18t26 age_66plus edu_low edu_high unempl  stichting_density vereniging_density leisure_density, by(BC)
	
	
	shp2dta using "/Users/Maartje/Desktop/LJA/Buurtanalyse/Kaarten maken/bc2015def_region.shp", database(db15) coordinates(coord15) replace
	drop if _ID==. // not strictly necessary here because all were matched
	spset _ID
	spset, modify shpfile(coord) 
	

* Density of foundations (stichtingen) *

	grmap, activate
	format stichting_density %12.1f
	grmap stichting_density,  clmethod(quantile) clnumber(6) ndfcolor(gs12) legstyle(2) fcolor(PuBu) legtitle("Stichtingsdichtheid (per 1000 inwoners)")
	
	graph export "$figures/map-stichtingen.png", replace 
	
* Density of leisure organisations (vrijetijdsorganisaties) *  	

	format leisure_density %12.1f
	grmap leisure_density,  clmethod(quantile) clnumber(6) ndfcolor(gs12) legstyle(2) fcolor(PuBu) legtitle("Vrijetijdsorganisatiesdichtheid (per 1000 inwoners)")
	
	graph export "$figures/map-leisure.png", replace 




	
	
	
	
