####################################
###preparations to run the analysis
####################################
if (schema != "") {schema = paste0(schema,".")}

if (SQL == "SQLServer") {
  source("Connect_SQLServer.R")
} else
  if (SQL == "PostgreSQL") {
    source("Connect_PostgreSQL.R")
  } else
    if (SQL == "Oracle") {
      source("Connect_Oracle.R")}

if (CDM == "PCORNET3") {
  DQTBL <- read.csv(file="DQTBL_pcornet_v3.csv",head=TRUE,sep=",")
  source("funcs_pcornet3.R")
} 


# create a vector of tables 
CDM_TABLES <- c(as.character(unique(DQTBL$TabNam)))

# create a list of tables in the SQL database
if (SQL == "SQLServer") {
  list <- dbGetQuery(conn,"SELECT * FROM INFORMATION_SCHEMA.TABLES")$TABLE_NAME
} else if (SQL == "Oracle") {
  list <- dbGetQuery(conn, "select table_name from all_tables")
}

list <- data.frame(list)
colnames(list)[1] <- "Repo_Tables"

list$Repo_Tables3 <- tolower(list$Repo_Tables)
list$Repo_Tables2 <- sub(paste0(".*",tolower(prefix)), "", list$Repo_Tables3)
list$Repo_Tables3 <- NULL

# ##manually modifying spelling errors for Oracle
# ########### remove this when tables names are corrected!#############################
if (SQL == "Oracle") { 
  list[list$Repo_Tables2 == "labresults_cm", ]$Repo_Tables2 <- "lab_result_cm"##########
  list[list$Repo_Tables2 == "death_cause", ]$Repo_Tables2 <- "death_condition"
  list[list$Repo_Tables2 == "procedure", ]$Repo_Tables2 <- "procedures"
}##########}
# #####################################################################################

# # pick CDM tables from all tables provided
tbls <- subset(list, list$Repo_Tables2 %in% CDM_TABLES)#| list$Repo_Tables2 %in% c("labresults_cm","death_cause"))
# tbls <- unique(tbls$Repo_Tables2)
rm(list)
# create a version of the list to save as a .csv table
tbls2 <- data.frame(tbls)
colnames(tbls2)[2] <- "CDM_Tables"
rownames(tbls2) <- NULL
rm(tbls)




## write list of provided CDM tables for the record
# write.csv(tbls2, file = paste("reports/tablelist_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))



##store test date in mm-YYYY format
test_date <- as.character(format(Sys.Date(),"%m-%Y"))



# this piece of code below contains code that I modified from internet: 
# http://stackoverflow.com/questions/7892334/get-size-of-all-tables-in-database 
# creates a data frame of all data frames in the 
# global environment and calculates their 
# size and number of rows
if (SQL == "SQLServer") { 
  tbls2 <- join(tbls2, dbGetQuery(conn,
                                  "SELECT 
                                  t.NAME AS Repo_Tables,
                                  p.rows AS Rows,
                                  SUM(a.total_pages) * 8 AS TotalSizeKB
                                  FROM 
                                  sys.tables t
                                  INNER JOIN      
                                  sys.indexes i ON t.OBJECT_ID = i.object_id
                                  INNER JOIN 
                                  sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
                                  INNER JOIN 
                                  sys.allocation_units a ON p.partition_id = a.container_id
                                  LEFT OUTER JOIN 
                                  sys.schemas s ON t.schema_id = s.schema_id
                                  WHERE 
                                  t.NAME NOT LIKE 'dt%' 
                                  AND t.is_ms_shipped = 0
                                  AND i.OBJECT_ID > 255 
                                  GROUP BY 
                                  t.Name, p.Rows
                                  ORDER BY 
                                  t.Name"),
                by = "Repo_Tables",
                type = "left")
} else
  if (SQL == "Oracle") {
    x1 <- dbGetQuery(conn,"select Repo_Tables, TotalSizeKB, NUM_ROWS from 
                     ((select SEGMENT_NAME Repo_Tables, 
                     bytes/1000 TotalSizeKB from user_segments where segment_name in (select table_name from all_tables)) d
                     inner join
                     (select TABLE_NAME, NUM_ROWS from all_tables) t
                     on d.Repo_Tables =t.TABLE_NAME)")
    names(x1)[1:3] = c("Repo_Tables", "TotalSizeKB", "Rows")
    tbls2 <- join(tbls2, x1 ,
                  by = "Repo_Tables",
                  type = "left")
    rm(x1)
  }


rownames(tbls2) <- NULL

## creating a source table, tbls3, that merges tbls2 with CDM tables
tbls3 <- data.frame(unique(DQTBL$TabNam))
colnames(tbls3)[1] <- "CDM_Tables"
tbls3 <- join(tbls3, tbls2, by="CDM_Tables",type = "left")

tbls3$loaded <- ifelse(is.na(tbls3$Repo_Tables), "No", "Yes")
tbls3$available <- ifelse((!is.na(tbls3$Rows) & tbls3$Rows > 0 & tbls3$loaded == "Yes"), "Yes", "No")
tbls3$index <- 1
tbls3$CDM_Tables <- as.character(tbls3$CDM_Tables)

tbls3 <- tbls3[order(CDM_TABLES),] 

rownames(tbls3) <- NULL

write.csv(tbls3, file = paste("reports/load_details_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))



# listing tables that should be deducted from DQTBL            
no_tab <- c(as.character(tbls3[(tbls3$loaded == "No" | tbls3$available == "No"),"CDM_Tables"]))


## write list of provided CDM tables for the record
write.csv(select(subset(tbls2, tbls2$Rows>0),CDM_Tables), file = paste("reports/tablelist_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))


# write.csv(no_tab, file = paste("reports/empty_tablelist_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))

## subsetting the empty/undelivered tables from DQTBL to avoid problems running loops in the analysis phase
DQTBL <- subset(DQTBL, !(DQTBL$TabNam %in% no_tab))




# copy DQTBL for date testing
dateTBL <-select(DQTBL[grep("_date", DQTBL[,"ColNam"]), ],TabNam, ColNam)


rm(tbls3)




