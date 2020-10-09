library(data.table)
library(zoo)

data_proc <- function(df) {
	
	# shift "_end" upward by group "compid" to get "_start"
	end_cols <- grep("end",colnames(df),value=TRUE) # find col with suffix "_end"
	end_cols <- end_cols[end_cols != "RETMONTH_end"] # exclude RETMONTH_end
	tostart_cols = sub("end", "start", end_cols) # create new col names
	dt <- data.table(df)
	dt[, (tostart_cols) := shift(.SD, 1, NA, "lead"), by=compid, .SDcols=end_cols] # shift
	dt <- dt[ , .SD, .SDcols = !end_cols] # drop "_end"
	dt <- na.locf(dt)
	df <- data.frame(dt)
	
	# remove size effect
	unscaled_cols <- c(
	    "assets_start", "debtusd_start", "capex_start", "cashnequsd_start", "cor_start", "consolinc_start",
	    "depamor_start", "deposits_start", "ebitdausd_start", "ebitusd_start", "ebt_start",
	    "equityusd_start", "ebt_start", "fcf_start", "gp_start", "intangibles_start",
	    "intexp_start", "invcap_start", "inventory_start", "investments_start", "liabilities_start",
	    "ncf_start", "ncfbus_start", "ncfcommon_start", "ncfdebt_start", "ncfdiv_start",
	    "ncff_start", "ncfi_start", "ncfinv_start", "ncfo_start", "ncfx_start",
	    "netinc_start", "opex_start", "opinc_start", "payables_start", "ppnenet_start",
	    "prefdivis_start", "retearn_start","revenueusd_start","sbcomp_start","sgna_start",
	    "sharesbas_start","shareswa_start","shareswadil_start","tangibles_start","taxexp_start",
	    "workingcapital_start", "rnd_start", "taxassets_start","taxliabilities_start")
	for (col in unscaled_cols){
	    df[, col] <- df[ ,col] / df[ ,"marketcap_start"]
	}
	
	# cross-sectional standardization
	apply_cols <- names(df)[!(names(df) %in% c("Date", "compid", "Industry", "RETMONTH_end",
	    "retmonth_spx_start","sentiment_bullish_start","sentiment_neutral_start",
	    "sentiment_bearish_start","realized_vol_spx_start", "fxusd_start"))]
	uni_date <- unique(df$Date)
	for (date in uni_date){
	    sub_df <- df[df$Date == date, apply_cols] # subset df by T
	    for (col in apply_cols) {
	        sub_s <- sub_df[, col] # sub series by col
	        mu <- mean(sub_s)
	        sigma <- sd(sub_s)
	        df[df$Date == date, col] <- (df[df$Date == date, col] - mu) / sigma
	    }
	}
	
	# add cross effect
	apply_cols <- names(df)[!(names(df) %in% c(
	    "Date", "compid", "Industry", "RETMONTH_end", "retmonth_spx_start", 
	    "sentiment_bullish_start","sentiment_neutral_start","sentiment_bearish_start","realized_vol_spx_start"))]
	n = length(apply_cols)
	for (i in 1:(n-1)){
	    for (j in (i+1):n){
	        new_col <- paste(apply_cols[i], apply_cols[j], sep="_")
	        df[, new_col] <- df[, apply_cols[i]] * df[, apply_cols[j]]
	    }
	}
	
	# drop useless col
	df <- df[, names(df)[!(names(df) %in% c("Date", "compid", "Industry"))]]
	
	return <- df
}

#how to use:
#setwd("/Users/xieyou/r/MF850final")
#df <- read.csv(file="mf850-finalproject-data.csv", header=TRUE, sep=",")
#df <- df[, names(df)[!(names(df) %in% c("RETMONTH_end"))]]
#df <- data_proc(df) 
#str(df)

