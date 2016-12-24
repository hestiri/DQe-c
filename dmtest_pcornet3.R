################ PCORnet V3 Data Model Orphan Keys test

# Reference means that the column value is reference for all other tables that have the same column
DQTBL_KEYS$Index <- ifelse(((DQTBL_KEYS$TabNam == "demographic" & DQTBL_KEYS$ColNam == "patid") |
                              (DQTBL_KEYS$TabNam == "prescribing" & DQTBL_KEYS$ColNam == "prescribingid") |
                              (DQTBL_KEYS$TabNam == "encounter" & DQTBL_KEYS$ColNam == "encounterid") |
                              (DQTBL_KEYS$TabNam == "encounter" & DQTBL_KEYS$ColNam == "enc_type") |
                              (DQTBL_KEYS$TabNam == "encounter" & DQTBL_KEYS$ColNam == "providerid")),
                           "Reference",
                           DQTBL_KEYS$Index)



#Copy the data frame to store not counted ids (the ones that are not available in the reference coulumn)
DQTBL_KEYS2 <- subset(DQTBL_KEYS, DQTBL_KEYS$Index != "Reference")
DQTBL_KEYS2$Index <- "Count_Out"
DQTBL_KEYS2$UNIQFRQ <- 0

DQTBL_KEYS <- rbind(DQTBL_KEYS,DQTBL_KEYS2);rm(DQTBL_KEYS2)

### Now let's count the number of unique ids that do not exist in the reference column and assign related values to them
## and then subtracting the number of counted outs from the number of counted ins
########## ##### #####   ########## ##### #####
########## ##### #####
########## ##### #####   ########## ##### #####
#patid
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "enrollment" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "enrollment", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "enrollment" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "enrollment" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "enrollment" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

####
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "encounter" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "encounter", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "encounter" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "encounter" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) -
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "encounter" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "diagnosis", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) -
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "procedures", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) -
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "vital" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "vital", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "vital" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "vital" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) -
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "vital" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "dispensing" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "dispensing", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "dispensing" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "dispensing" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) -
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "dispensing" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "lab_result_cm" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "lab_result_cm", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "lab_result_cm" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "lab_result_cm" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "lab_result_cm" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "condition", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pro_cm" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "pro_cm", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pro_cm" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pro_cm" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pro_cm" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "prescribing" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "prescribing", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "prescribing" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "prescribing" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "prescribing" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pcornet_trial" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "pcornet_trial", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pcornet_trial" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pcornet_trial" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pcornet_trial" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "death" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "death", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "death" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "death" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "death" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "death_condition" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "demographic", table2 = "death_condition", col = "patid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "death_condition" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "death_condition" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "death_condition" & DQTBL_KEYS$ColNam == "patid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 
########## ##### #####   ########## ##### #####
########## ##### #####
########## ##### #####   ########## ##### #####
#enc_type
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "enc_type" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "diagnosis", col = "enc_type")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "enc_type" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "enc_type" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "enc_type" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "enc_type" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "procedures", col = "enc_type")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "enc_type" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "enc_type" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "enc_type" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 
########## ##### #####   ########## ##### #####
########## ##### #####
########## ##### #####   ########## ##### #####
#encounterid
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "diagnosis", col = "encounterid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "procedures", col = "encounterid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "vital" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "vital", col = "encounterid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "vital" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "vital" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "vital" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "lab_result_cm" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "lab_result_cm", col = "encounterid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "lab_result_cm" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "lab_result_cm" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "lab_result_cm" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "condition", col = "encounterid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"])

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pro_cm" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "pro_cm", col = "encounterid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pro_cm" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pro_cm" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "pro_cm" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"])

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "prescribing" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "prescribing", col = "encounterid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "prescribing" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "prescribing" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "prescribing" & DQTBL_KEYS$ColNam == "encounterid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"])
########## ##### #####   ########## ##### #####
########## ##### #####
########## ##### #####   ########## ##### #####
# providerid
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "providerid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "diagnosis", col = "providerid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "providerid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "providerid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "diagnosis" & DQTBL_KEYS$ColNam == "providerid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 

###
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "providerid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphankeys(table1 = "encounter", table2 = "procedures", col = "providerid")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "providerid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "providerid" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"]) - 
  as.numeric(DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedures" & DQTBL_KEYS$ColNam == "providerid" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"]) 



write.csv(DQTBL_KEYS, file = paste("reports/DM_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))

