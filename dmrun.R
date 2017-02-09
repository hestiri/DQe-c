source("freq.R")

################################################################################################################################
################################################################################################################################
################################################################################################################################
########## THIS SCRIPT RUNS ORPHAN KEYS' TESTS
################################################################################################################################
################################################################################################################################



## create data frame to store only columns and tables that have related key and/or primary keys for data model test 
if (CDM == "PCORNET3") {
  DQTBL_KEYS <- select(subset(DQTBL, ColNam %in% c("patid","encounterid","providerid","prescribingid","enc_type")),TabNam, ColNam, UNIQFRQ)
  ## creating an index for plotting: Count In means number rof unique frequencies that exist in the reference table
  DQTBL_KEYS$Index <- "Count_In"
  dmtest <- parse(file = "dmtest_pcornet3.R")
  
} 


for (i in seq_along(dmtest)) {
  tryCatch(eval(dmtest[[i]]), 
           error = function(e) message("No Worries!! HE thinks it is fine if there is an ", as.character(e)))
}




###### this test is working based on DQTBL_KEYS 

















