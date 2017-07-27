
##install/load required packages
source("libs.R")

###identify data model PCORnet V3
CDM = "PCORNET3" #set to PCORNET31, if you have the latest CDM

###identify SQL connection Oracle or SQL Server
SQL = "SQLServer" ## SET to "Oracle" is Oracle is your RDBMS

## if you have your tables in a particular SQL schema, identify the schema here:
schema = "" ## default is that there is no schema. SET SCHEMA NAME, IF THERE IS ONE

## is there a prefix for table names in your database?
prefix = "" ## default at none. SET PREFIX, IF THERE IS ONE


## enter the organization name you are running the test on
org = "" # SET Your Organization Name



##Now first run the test
source("Without.R")

source("Comp_test.R")



## then generate the html report
rmarkdown::render("Report.Rmd")



source("DQe-v_queries.R")
