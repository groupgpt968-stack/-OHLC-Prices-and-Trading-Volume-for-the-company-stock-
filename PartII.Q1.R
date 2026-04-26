# ===============================
# Part II Q1 
# ===============================

library(readxl)
library(TTR)

# 1. Load data
data_raw <- read_excel("PriceHistory-11.xlsx", skip = 2)

# 2. Rename columns
colnames(data_raw)[1] <- "Date"
colnames(data_raw)[2] <- "Close"

# 3. Clean Date and Close
data_raw$Date <- as.Date(data_raw$Date)
data_raw$Close <- as.numeric(data_raw$Close)

# 4. Remove missing values
data <- data_raw[!is.na(data_raw$Date) & !is.na(data_raw$Close), ]

# 5. Sort by date
data <- data[order(data$Date), ]

# 6. Keep assignment period
data <- data[data$Date >= as.Date("2022-07-01") &
               data$Date <= as.Date("2026-03-27"), ]

# ===============================
# Create technical indicators
# ===============================

data$SMA_10 <- SMA(data$Close, n = 10)

data$log_return <- 100 * c(NA, diff(log(data$Close)))

data$simple_return <- 100 * c(NA, diff(data$Close) / head(data$Close, -1))

data$EMA_10 <- EMA(data$Close, n = 10)

data$momentum_5 <- momentum(data$Close, n = 5)

# ===============================
# Create one-period lags
# ===============================

data$lag_SMA_10 <- c(NA, head(data$SMA_10, -1))
data$lag_log_return <- c(NA, head(data$log_return, -1))
data$lag_simple_return <- c(NA, head(data$simple_return, -1))
data$lag_EMA_10 <- c(NA, head(data$EMA_10, -1))
data$lag_momentum_5 <- c(NA, head(data$momentum_5, -1))

# ===============================
# Final model dataset
# ===============================

data_model <- data[, c(
  "Date",
  "Close",
  "lag_SMA_10",
  "lag_log_return",
  "lag_simple_return",
  "lag_EMA_10",
  "lag_momentum_5"
)]

data_model <- na.omit(data_model)

# View final dataset
head(data_model)
str(data_model)
write.csv(data_model, "data_model.csv", row.names = FALSE)

install.packages("writexl")
library(writexl)
write_xlsx(data_model, "data_model.xlsx")
