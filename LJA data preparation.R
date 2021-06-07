# LINK JONG AMSTERDAM - BUURTANALYSES
# Last update: 07/06/21

# SET-UP ---------------------------------------------------------------------------------------

rm(list=ls())

library(raster)
library(foreign) 
library(tidyverse)
library(ggplot2)
library(readxl)
library(dplyr)
library(stats)
library(tidyr)
library(haven)


# READ DATA ------------------------------------------------------------------------------------

# Read 'CMAIN177' for KvK data for 2017
KVKdata <- read_xls("/Users/Maartje/Desktop/LJA/Buurtanalyse-LJA/Data/CMAIN177.xls", 
            col_names = TRUE)

# Read 'Basisbestand Gebieden Amsterdam' (BBGA) for neighbourhood variables
# Data can be retrieved from https://data.amsterdam.nl/datasets/G5JpqNbhweXZSw/basisbestand-gebieden-amsterdam-bbga/
columnnames <- names(read_xlsx("/Users/Maartje/Desktop/LJA/Buurtanalyse-LJA/Data/Buurtkenmerken (versie 10-3-21).xlsx", n_max = 0))
columntypes <- ifelse(grepl("^[A-Z]", columnnames),"numeric", "guess")
buurtdata   <- read_xlsx("/Users/Maartje/Desktop/LJA/Buurtanalyse-LJA/Data/Buurtkenmerken (versie 10-3-21).xlsx", sheet = 1, col_names = TRUE, col_types = columntypes)

# Read translation table: postal codes to neighbourhood codes
koppeltabel <- read_dta("/Users/Maartje/Desktop/LJA/Buurtanalyse-LJA/Data/koppeltabel postcode naar buurt.dta")


# KVK DATA - Add dummies -----------------------------------------------------------------------

# Dummy for 'stichting' (rechtsvorm = 74)
KVKdata$stichting <- ifelse(KVKdata$RECHTSVORM == 74, 1, 0)

# Dummy for 'vereniging' (rechtsvorm = 71, 72 of 73)
KVKdata$vereniging <- ifelse(KVKdata$RECHTSVORM == 71 | KVKdata$RECHTSVORM == 72 | KVKdata$RECHTSVORM == 73, 1, 0)

# Dummy for 'leisure society'
leisure <- read_xlsx("/Users/Maartje/Desktop/LJA/Buurtanalyse-LJA/Data/selectiecodesleisureorganisations.xlsx",
           col_names = TRUE) # read list of KvK codes that designate leisure organisations
leisure_codes <- leisure$code
KVKdata$leisure_org <- ifelse(KVKdata$HAKT %in% leisure_codes, 1, 0) 


# NEIGHBOURHOOD DATA - Prepare data -------------------------------------------------------------

# Subset to neighbourhood-level data only ('Wijken')
buurtdata <- buurtdata %>% filter(buurtdata$niveaunaam == "Wijken")

# Select relevant variables - drop all others
independentvars <- c("gebiedcode15", "gebiednaam", "jaar", "BEVTOTAAL", "BEVSUR_P", "BEVANTIL_P", 
                     "BEVTURK_P", "BEVMAROK_P", "BEVOVNW_P", "BEVWEST_P", 
                     "BEVAUTOCH_P", "BEV0_18_P", "BEV18_26_P", "BEV27_65_P", 
                     "BEV66PLUS_P", "BEVOPLLAAG_P", "BEVOPLMID_P", 
                     "BEVOPLHOOG_P", "PREGWERKL_P")

buurtdata <- buurtdata[independentvars]

# Subset to 2016
buurtdata <- buurtdata %>% filter(buurtdata$jaar == 2016)

# Drop observation for 'Z99': not a real neighbourhood
buurtdata <- buurtdata[buurtdata$gebiedcode15 != "Z99",]


# MERGE DATA ------------------------------------------------------------------------------------

# Merge KVKdata to koppeldata
KVKdata <- KVKdata %>% rename(postcode = PC)
KVKdata_m <- merge(KVKdata, koppeltabel, by="postcode") # 46 of the 46725 observations are lost

# Variable for neighbourhood (99 Wijken) code
KVKdata_m$bc_code <- substring(KVKdata_m$buurt_vollcode, 1, 3)

# Variables for number of organisations etc. per neighbourhood
KVKdata_stichting  <- aggregate(KVKdata_m$stichting, by=list(KVKdata_m$bc_code), FUN=sum)
KVKdata_stichting  <- KVKdata_stichting %>% rename(stichting_count = x)
KVKdata_stichting  <- KVKdata_stichting %>% rename(bc_code = Group.1)

KVKdata_vereniging <- aggregate(KVKdata_m$vereniging, by=list(KVKdata_m$bc_code), FUN=sum)
KVKdata_vereniging <- KVKdata_vereniging %>% rename(vereniging_count = x)
KVKdata_vereniging <- KVKdata_vereniging %>% rename(bc_code = Group.1)
  
KVKdata_leisure    <- aggregate(KVKdata_m$leisure_org, by=list(KVKdata_m$bc_code), FUN=sum)
KVKdata_leisure    <- KVKdata_leisure %>% rename(leisure_count = x)
KVKdata_leisure    <- KVKdata_leisure %>% rename(bc_code = Group.1)

KVKdata_buurt <- merge(KVKdata_stichting, KVKdata_vereniging, by="bc_code")
KVKdata_buurt <- merge(KVKdata_buurt, KVKdata_leisure, by="bc_code")

# Merge KVKdata_buurt with buurtdata
buurtdata <- buurtdata %>% rename(bc_code = gebiedcode15)
data <- merge(buurtdata, KVKdata_buurt, by="bc_code") # M50 is dropped, KVK data not available for this neighbourhood

# Variables for organisation density: number of organisations per 1000 inhabitants

data$stichting_density  <- (data$stichting_count  / data$BEVTOTAAL) * 1000
data$vereniging_density <- (data$vereniging_count / data$BEVTOTAAL) * 1000
data$leisure_density    <- (data$leisure_count    / data$BEVTOTAAL) * 1000


# EXPORT DATA ------------------------------------------------------------------------------------

data <- data %>% rename(bc_n         = gebiednaam)
data <- data %>% rename(year         = jaar)
data <- data %>% rename(population   = BEVTOTAAL)
data <- data %>% rename(imm_Sur      = BEVSUR_P)
data <- data %>% rename(imm_Ant      = BEVANTIL_P)
data <- data %>% rename(imm_Tur      = BEVTURK_P)
data <- data %>% rename(imm_Mar      = BEVMAROK_P)
data <- data %>% rename(imm_otherNW  = BEVOVNW_P)
data <- data %>% rename(imm_W        = BEVWEST_P)
data <- data %>% rename(imm_autoch   = BEVAUTOCH_P)
data <- data %>% rename(age_0t18     = BEV0_18_P)
data <- data %>% rename(age_18t26    = BEV18_26_P)
data <- data %>% rename(age_27t65    = BEV27_65_P)
data <- data %>% rename(edu_low      = BEVOPLLAAG_P)
data <- data %>% rename(edu_mid      = BEVOPLMID_P)
data <- data %>% rename(edu_high     = BEVOPLHOOG_P)
data <- data %>% rename(age_66plus   = BEV66PLUS_P)
data <- data %>% rename(unempl       = PREGWERKL_P)

write.csv(data, "/Users//Maartje/Desktop/LJA/Buurtanalyse-LJA/data_buurtanalyse.csv", row.names = FALSE)
