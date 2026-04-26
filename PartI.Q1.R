# ===============================
# AFIN8015 - Q2 Descriptive Statistics
# ===============================

# 1. Install packages

# 2. Load packages
library(readxl)
library(moments)
library(tseries)

# 3. Read my FactSet Excel file
data_raw <- read_excel("PriceHistory-11.xlsx", skip = 2)
