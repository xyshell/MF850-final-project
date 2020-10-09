# install.packages("data.table")
# install.packages("caret")
# install.packages("randomForest")

library(data.table)
library(caret)
library(randomForest)

# # set the directory 
# setwd("/Users/qc/Desktop/BU/Fall2019/MF850/final project/Q2/coding")
source("data_proc.r") # data process

main <- function(df) {
  df <- data_proc(df)
  indicators = c("retmonth_spx_start","realized_vol_spx_start",
                 "pe1_start", "sps_start", "gp_start" )
  
  my_rf <- readRDS("my_random_forest.rds")
  xx_test <- df[, indicators]
  pred <- predict(my_rf , xx_test)
  return <- pred
}

## how to use:
# df <- read.csv(file="mf850-finalproject-data.csv", header=TRUE, sep=",")
# df <- df[, names(df)[!(names(df) %in% c("RETMONTH_end"))]]
# pred <- main(df)
# length(pred)
# 
# df <- read.csv(file="mf850-finalproject-data.csv", header=TRUE, sep=",")
# df <- data_proc(df)
# yy <- 1*(df$RETMONTH_end>0)
# y_hat <- 1*(pred>0) # predicted direction: 1-up, 0-down
# mean(y_hat==yy) # prediction accuracy
