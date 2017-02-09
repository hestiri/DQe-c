#########################################################
############################################################################
####### This script connects your R to your Oracle database.  ##


# read username and password
source("keys.R")

# set up connection
path01 <- getwd()
drv <- JDBC(driverClass="oracle.jdbc.OracleDriver", 
            classPath= paste0(path01,"/ojdbc6.jar"),
            identifier.quote="`")
# creating a connection object by calling dbConnect
conn <- dbConnect(drv, 
                  "jdbc:oracle:thin:@//database.hostname.com:port/service_name_or_sid",
                  usrnm, 
                  pss)



