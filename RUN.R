
##install/load required packages
source("libs.R")

###identify data model PCORnet V3
CDM = "PCORNET3" 

###identify SQL connection Oracle or SQL Server
SQL = "SQLServer" ##

## if you have your tables in a particular SQL schema, identify the schema here:
schema = "SET SCHEMA NAME, IF THERE IS ONE" ## default is that there is no schema

## is there a prefix for table names in your database?
prefix = "SET PREFIX, IF THERE IS ONE" ## default at none


## enter the organization name you are running the test on
org = "SET Organization Name"



##Now first run the test
source("Without.R")

source("Comp_test.R")



## then generate the html report
rmarkdown::render("Report.Rmd")



dbDisconnect(con)
rm(list = ls())