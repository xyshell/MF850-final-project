### How to run our code:

the two required functions are in predict_ret.r and predict_direction.r. Each contains a main function taking input of an R object data.frame <- read.csv("mf850-finalproject-data.csv") and doing the prediction task.

Please use setwd() to set working directory as the current folder.

Please refer to the commented "how to use" as explanation of the interface.


### File structure:

predict_ret.r: required function to predict return

predict_direction.r: required function to predict direction

*.rds files including trained model

data_proc.r: function to process data (required by predict_ret.r and predict_direction.r)



