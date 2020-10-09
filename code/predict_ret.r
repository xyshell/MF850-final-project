# install.packages("data.table")
# install.packages("caret")
# install.packages("neuralnet")
library(caret)
library(neuralnet)

# setwd("/Users/xieyou/r/MF850final") # change work directory to current folder
source("data_proc.r")

main <- function(df) {
	df <- data_proc(df)
	selected = c("depamor_start"    ,         "fcf_start"         ,        "ncfo_start"     ,           "netinc_start"  ,           
	             "opinc_start"      ,         "retearn_start"     ,        "rnd_start"      ,           "sbcomp_start"  ,           
	             "sgna_start"        ,        "retmonth_spx_start" ,       "capex_start_ncfx_start"  ,  "depamor_start_fxusd_start",
	             "fcf_start_fxusd_start" ,    "fxusd_start_opinc_start"  , "fxusd_start_retearn_start", "fxusd_start_sgna_start",   
	             "gp_start_sps_start"     ,   "rnd_start_sbcomp_start" ,   "tbvps_start_Volume_start"      )

	my_nnt <- readRDS("onelayer_nnt_allin.rds")
	xx_test <- df[, selected]
	pred <- predict(my_nnt , xx_test)
	return <- pred
}

# how to use:
# df <- read.csv(file="mf850-finalproject-data.csv", header=TRUE, sep=",")
# df <- df[, names(df)[!(names(df) %in% c("RETMONTH_end"))]]
# pred <- main(df) 
# length(pred)

# df <- read.csv(file="mf850-finalproject-data.csv", header=TRUE, sep=",")
# df <- data_proc(df)
# yy <- df$RETMONTH_end
# 1 - sum((pred - yy)^2) / sum((yy - mean(yy))^2)

