# Canned Tuna Trade Analysis (BACI HS Data)

## Overview
This repository contains an automated R pipeline designed to process, harmonize, and analyze international trade data for canned tuna (Harmonized System codes **HS 160414** and **HS 160420**). 

The script integrates trade flows from the **BACI database** [https://www.cepii.fr/DATA_DOWNLOAD/baci/data/BACI_HS22_V202601.zip] (CEPII) with official country codes and a list of ICCAT (International Commission for the Conservation of Atlantic Tunas) Contracting Parties (CPC) to calculate canned tuna volume (tons) exported by CPC.

The calculated canned tuna volume (tons) is to be used as a reference for the contribution to the Commission.

## Project Structure
```text
baci-tuna-canned/
│
├── data/                      # Raw BACI and ICCAT CSV files (ignored by Git / local only)
├── Canned_tuna_HS_analysis.R  # Main R script for data processing and analysis
├── .gitignore                 # Specifies intentionally untracked files
└── README.md                  # Project documentation