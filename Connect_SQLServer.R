#########################################################
############################################################################
####### This script connects your R to your SQL Server database.  ##


# read username and password
source("keys.R")

# set up connection
path01 <- getwd()
drv <- JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver", paste0(path01,"/sqljdbc4.jar"),
            identifier.quote="`")
# creating a connection object by calling dbConnect
conn <- dbConnect(drv, 
                  "jdbc:sqlserver://DATABASE ADDRESS;databaseName=DATABASE NAME", 
                  usrnm, 
                  pss)
rm(pss)

#######
######## If you don't know your data base name and address, contact your server admin.
#######