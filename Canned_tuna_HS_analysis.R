# ==============================================================================
# Foreign Trade Analysis - BACI Canned Tuna (HS 160414 and 160420)
# GitHub-optimized version (11/17/2026)
# ==============================================================================

# Load packages
library(data.table)    
library(tidyverse)     
library(readr)         
library(scales)        
library(openxlsx)      
library(here)          # Essential for consistent relative paths

# 1. Read data using paths relative to the project root directory
# Note: Ensure that data files are stored inside the 'data/' folder of your project
BACI <- read_csv(here("data", "BACI_HS22_Y2023_V202601.csv"), 
                 col_types = cols(k = col_integer()))

## HS Canned Tuna (160420 and 160414)
BACI_Canned_Tuna160420 <- BACI %>%
  filter(k == 160420) %>%
  distinct() %>%
  rename(
    CO_SH6 = k,
    Value = v,
    Volume = q,
    Exporter = i,
    Importer = j
  )

BACI_Canned_Tuna160414 <- BACI %>%
  filter(k == 160414) %>%
  distinct() %>% 
  rename(
    CO_SH6 = k,
    Value = v,
    Volume = q,
    Exporter = i,
    Importer = j
  )

# 2. Load country codes and ICCAT mapping
BACI_country_codes <- read_csv(
  here("data", "BACI_country_codes_V202601.csv"), 
  locale = locale(encoding = "ISO-8859-1")
) %>% 
  rename(CO_PAIS_ISOA3 = country_iso3)

CPC_ICCAT <- read_delim(
  here("data", "CPC_ICCAT.csv"), 
  delim = ";", 
  escape_double = FALSE, 
  locale = locale(encoding = "ISO-8859-1"), 
  trim_ws = TRUE
)

CPC <- inner_join(BACI_country_codes, CPC_ICCAT, by = "CO_PAIS_ISOA3") %>%
  distinct() %>% 
  arrange(ICCAT) %>% 
  rename(Exporter = country_code)

# Clear raw BACI database from memory to free up RAM
rm(BACI_country_codes, CPC_ICCAT, BACI)
gc()

# 3. Processing and Aggregation - HS 160420
Tuna160420 <- BACI_Canned_Tuna160420 %>% 
  filter(Exporter %in% CPC$Exporter) %>%
  distinct() %>% 
  drop_na() %>% 
  group_by(Exporter) %>% 
  summarise(value = sum(Value), Volume = sum(Volume)) %>% 
  left_join(CPC %>% select(Exporter, ICCAT, NO_ICCAT_ING), by = "Exporter") %>%
  group_by(NO_ICCAT_ING) %>% 
  summarise(
    Total_Value = sum(value), 
    Total_Volume = sum(Volume),
    .groups = "drop"
  )

# 4. Processing and Aggregation - HS 160414
Tuna160414 <- BACI_Canned_Tuna160414 %>% 
  filter(Exporter %in% CPC$Exporter) %>%
  distinct() %>% 
  drop_na() %>% 
  group_by(Exporter) %>% 
  summarise(value = sum(Value), Volume = sum(Volume)) %>% 
  left_join(CPC %>% select(Exporter, ICCAT, NO_ICCAT_ING), by = "Exporter") %>%
  group_by(NO_ICCAT_ING) %>% 
  summarise(
    Total_Value = sum(value), 
    Total_Volume = sum(Volume),
    .groups = "drop"
  )

# Quick preview of consolidated results
print("--- Canned Tuna Summary (160420) ---")
print(head(Tuna160420))

print("--- Canned Tuna Summary (160414) ---")
print(head(Tuna160414))
