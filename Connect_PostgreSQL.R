#########################################################
############################################################################
####### This script connects your R to your PostgreSQL database.  ##


# read username and password
source("keys.R")

# set up connection
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,
                 dbname = "TYPE YOUR DATABASE NAME HERE",
                 host = "TYPE YOUR HOST NAME HERE",
                 port = ????,
                 user = usrnm,
                 password = pss
                 )
rm(pss)

#######
######## If you don't know your data base name, host, or port, contact your server admin.
#######


