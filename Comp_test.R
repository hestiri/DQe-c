
###########################################
############ COMPLETENESS ANALYSIS ########
###################++++++##################
##This scripts counts and stores frequency of missing values

if (SQL == "SQLServer") {
  #############################################################################
  ##loop 3: goes through all columns in all tables and count rows with a NULL/NA value or empty string 
  ## and store in DQTBL table as a new column, called MS1_FRQ, for each row
  #############################################################################
  
  
  for (j in 1: length(unique(DQTBL$TabNam))) 
    ##DQTBL$TabNam has all table names
  {
    NAM <-  unique(DQTBL$TabNam)[j]
    ##extracted name of table j in CDM
    NAM_Repo <- as.character(tbls2[(tbls2$CDM_Tables == NAM),"Repo_Tables"])
    
    # L <- as.numeric(tbls2[(tbls2$CDM_Tables == NAM),"NCols"])
    id.NAM <- which(DQTBL$TabNam == NAM)
    id.repotabs <- which(repotabs$TABLE_NAME == NAM_Repo)
    ##extracting the row numbers
    NAMTB <- DQTBL[id.NAM,]
    REPOTB <- repotabs[id.repotabs,]
    ##subsetting the DQTBL and repository table to only the rows from table j
    ##saving the name of table j as characters
    
    for (i in 1:dim(REPOTB)[1])
      ##now going through the columns of table j
    {
      col <- REPOTB$COLUMN_NAME[i]
      MS1_FRQ <- as.numeric(dbGetQuery(conn, paste0("SELECT COUNT('", col,"') FROM ",schema,NAM_Repo," WHERE [", col, "] IS NULL OR CAST(", col, " AS CHAR(54)) IN ('')")))
      ##calculated length (number of total rows) of each column from each table
      DQTBL$MS1_FRQ <- ifelse(DQTBL$ColNam == tolower(col) & DQTBL$TabNam == NAM, MS1_FRQ, DQTBL$MS1_FRQ )
      ##stored frequency in the culumn FRQ
    }
  }
  
  
  
  #############################################################################
  ##loop 4: goes through all columns in all tables and count rows with a + - _ # $ * \ ? . , & ^ % ! @ flag, 
  # meaning that there is nothing in the cell, but also not marked as NULL/NA 
  ## and store in DQTBL table as a new column, called MS2_FRQ, for each row
  #############################################################################
  
  
  for (j in 1: length(unique(DQTBL$TabNam))) 
    ##DQTBL$TabNam has all table names
  {
    NAM <-  unique(DQTBL$TabNam)[j]
    ##extracted name of table j in CDM
    NAM_Repo <- as.character(tbls2[(tbls2$CDM_Tables == NAM),"Repo_Tables"])
    
    # L <- as.numeric(tbls2[(tbls2$CDM_Tables == NAM),"NCols"])
    id.NAM <- which(DQTBL$TabNam == NAM)
    id.repotabs <- which(repotabs$TABLE_NAME == NAM_Repo)
    ##extracting the row numbers
    NAMTB <- DQTBL[id.NAM,]
    REPOTB <- repotabs[id.repotabs,]
    ##subsetting the DQTBL and repository table to only the rows from table j
    ##saving the name of table j as characters
    
    for (i in 1:dim(REPOTB)[1])
      ##now going through the columns of table j
    {
      col <- REPOTB$COLUMN_NAME[i]
      MS2_FRQ <- as.numeric(dbGetQuery(conn, paste0("SELECT COUNT('", col,"') FROM ",schema,NAM_Repo," WHERE CAST(", col, " AS CHAR(54)) IN ('+', '-', '_','#', '$', '*', '\', '?', '.', '&', '^', '%', '!', '@','NI')")))
      ##calculated length (number of total rows) of each column from each table
      DQTBL$MS2_FRQ <- ifelse(DQTBL$ColNam == tolower(col) & DQTBL$TabNam == NAM, MS2_FRQ, DQTBL$MS2_FRQ )
      ##stored frequency in the culumn FRQ
    }
  }
  
} else if (SQL == "Oracle") {
  
  #############################################################################
  ##loop 3: goes through all columns in all tables and count rows with a NULL/NA value or empty string 
  ## and store in DQTBL table as a new column, called MS1_FRQ, for each row
  #############################################################################
  
  
  for (j in 1: length(unique(DQTBL$TabNam))) 
    ##DQTBL$TabNam has all table names
  {
    NAM <-  unique(DQTBL$TabNam)[j]
    ##extracted name of table j in CDM
    NAM_Repo <- as.character(tbls2[(tbls2$CDM_Tables == NAM),"Repo_Tables"])
    
    # L <- as.numeric(tbls2[(tbls2$CDM_Tables == NAM),"NCols"])
    id.NAM <- which(DQTBL$TabNam == NAM)
    id.repotabs <- which(repotabs$TABLE_NAME == NAM_Repo)
    ##extracting the row numbers
    NAMTB <- DQTBL[id.NAM,]
    REPOTB <- repotabs[id.repotabs,]
    ##subsetting the DQTBL and repository table to only the rows from table j
    ##saving the name of table j as characters
    
    for (i in 1:dim(REPOTB)[1])
      ##now going through the columns of table j
    {
      col <- REPOTB$COLUMN_NAME[i]
      MS1_FRQ <- as.numeric(dbGetQuery(conn, paste0("SELECT COUNT('", col,"') FROM ",schema,NAM_Repo," WHERE ", col, " IS NULL OR TO_CHAR(", col, ") IN ('')")))
      ##calculated length (number of total rows) of each column from each table
      DQTBL$MS1_FRQ <- ifelse(DQTBL$ColNam == tolower(col) & DQTBL$TabNam == NAM, MS1_FRQ, DQTBL$MS1_FRQ )
      ##stored frequency in the culumn FRQ
    }
  }
  
  
  
  #############################################################################
  ##loop 4: goes through all columns in all tables and count rows with a + - _ # $ * \ ? . , & ^ % ! @ flag, 
  # meaning that there is nothing in the cell, but also not marked as NULL/NA 
  ## and store in DQTBL table as a new column, called MS2_FRQ, for each row
  #############################################################################
  
  
  for (j in 1: length(unique(DQTBL$TabNam))) 
    ##DQTBL$TabNam has all table names
  {
    NAM <-  unique(DQTBL$TabNam)[j]
    ##extracted name of table j in CDM
    NAM_Repo <- as.character(tbls2[(tbls2$CDM_Tables == NAM),"Repo_Tables"])
    
    # L <- as.numeric(tbls2[(tbls2$CDM_Tables == NAM),"NCols"])
    id.NAM <- which(DQTBL$TabNam == NAM)
    id.repotabs <- which(repotabs$TABLE_NAME == NAM_Repo)
    ##extracting the row numbers
    NAMTB <- DQTBL[id.NAM,]
    REPOTB <- repotabs[id.repotabs,]
    ##subsetting the DQTBL and repository table to only the rows from table j
    ##saving the name of table j as characters
    
    for (i in 1:dim(REPOTB)[1])
      ##now going through the columns of table j
    {
      col <- REPOTB$COLUMN_NAME[i]
      MS2_FRQ <- as.numeric(dbGetQuery(conn, paste0("SELECT COUNT('", col,"') FROM ",schema,NAM_Repo," WHERE TO_CHAR(",col,") IN ('+', '-', '_','#', '$', '*', '\', '?', '.', '&', '^', '%', '!', '@','NI')")))
      ##calculated length (number of total rows) of each column from each table
      DQTBL$MS2_FRQ <- ifelse(DQTBL$ColNam == tolower(col) & DQTBL$TabNam == NAM, MS2_FRQ, DQTBL$MS2_FRQ )
      ##stored frequency in the culumn FRQ
    }
  }
  
}
############# lets see what is going on with the providers table...
# providchars <- dbGetQuery(conn, "SELECT providerid FROM dbo.pmndiagnosis WHERE CAST(providerid AS CHAR(54)) IN ('+', '-', '_','#', '$', '*', '\', '?', '.', '&', '^', '%', '!', '@')")
# unique(providchars)
### everything is an @ !!!!!!!!!!!!

DQTBL$FRQ <- as.numeric(DQTBL$FRQ)
DQTBL$MS1_FRQ <- as.numeric(DQTBL$MS1_FRQ)
DQTBL$MS2_FRQ <- as.numeric(DQTBL$MS2_FRQ)

##calculating percent missing compared to the entire rows in each column/table
DQTBL$MSs_PERC <- round((DQTBL$MS1_FRQ+DQTBL$MS2_FRQ)/DQTBL$FRQ,2)
##saving the master DQ table
write.csv(DQTBL, file = paste("reports/mstabs/DQ_Master_Table_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))

##saving a copy for aggregated analysis, if the aggregated analysis add-on is installed.

#set the PATH below to aggregatted analysis directory
# write.csv(DQTBL, file = paste("PATH/DQ_Master_Table_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))





##### Creating FRQ_comp table to compare frequencies from MSDQ table over time.
path = "reports/mstabs"
msnames <- list.files(path)
n <- length(msnames)

##reading and storing master DQ tables
compr <- list()
N <- length(msnames)
for (n in 1:N) {
  compr[[n]] = data.frame(read.csv(paste0(path,"/",msnames[n],sep="")))
}

#binding the tables together to create a masters table
if (CDM %in% c("PCORNET3","PCORNET31")) {
  FRQ_comp <- subset(rbindlist(compr), (ColNam == "patid" & TabNam == "demographic") |
                       (ColNam == "dispensingid" & TabNam == "dispensing") |
                       (ColNam == "vitalid" & TabNam == "vital") |
                       (ColNam == "conditionid" & TabNam == "condition") |
                       (ColNam == "pro_cm_id" & TabNam == "pro_cm") |
                       (ColNam == "encounterid" & TabNam == "encounter") |
                       (ColNam == "diagnosisid" & TabNam == "diagnosis") |
                       (ColNam == "proceduresid" & TabNam == "procedures") |
                       # (ColNam == "providerid" & TabNam == "encounter") |
                       (ColNam == "prescribingid" & TabNam == "prescribing") |
                       (ColNam == "trialid" & TabNam == "pcornet_trial") |
                       (ColNam == "networkid" & TabNam == "harvest") 
  )
}


write.csv(FRQ_comp, file = paste("reports/FRQ_comp_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))


