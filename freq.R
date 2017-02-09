source("prep.R")

# add columns needed for completeness analysis
DQTBL$test_date <- as.factor(test_date)
DQTBL$FRQ <- 0
DQTBL$UNIQFRQ <- 0
DQTBL$MS1_FRQ <- 0 # for NULL/NAs
DQTBL$MS2_FRQ <- 0 # for ""s
DQTBL$MSs_PERC<- 0 # for percent missingness
DQTBL$organization <- org #ORGANIZATION NAME
DQTBL$test_date <- as.character(format(Sys.Date(),"%m-%d-%Y"))
DQTBL$CDM <- CDM # Data Model


##store a table with list of all tables and columns in the repository

if (SQL == "SQLServer") {repotabs <- dbGetQuery(conn,"SELECT COLUMN_NAME, TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS") 
} else if (SQL == "Oracle") {repotabs <- dbGetQuery(conn,"SELECT COLUMN_NAME, TABLE_NAME FROM user_tab_cols")}



#############################################################################
##loop 1: go through all columns in all tables and count number of rows 
##Results will be stored in column "FRQ" of the DQTBL table
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
    FRQ <- as.numeric(dbGetQuery(conn, paste0("SELECT COUNT(*) FROM ",schema,NAM_Repo)))
    ##calculated length (number of total rows) of each column from each table
    DQTBL$FRQ <- ifelse(DQTBL$ColNam == tolower(col) & DQTBL$TabNam == NAM, FRQ, DQTBL$FRQ )
    ##stored frequency in the culumn FRQ
  }
}



#############################################################################
##loop 2: goes through all columns in all tables and count number of UNIQUE rows 
##Results will be stored in column "UNIQFRQ" of the DQTBL table
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
    UNIQ <- as.numeric(dbGetQuery(conn, paste0("SELECT COUNT(DISTINCT ", col,") FROM ",schema,NAM_Repo)))
    ##calculated length (number of total rows) of each column from each table
    DQTBL$UNIQFRQ <- ifelse(DQTBL$ColNam == tolower(col) & DQTBL$TabNam == NAM, UNIQ, DQTBL$UNIQFRQ )
    ##stored frequency in the culumn FRQ
  }
}









