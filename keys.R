### This script is supposed to be confidential and only used by the person it is generated for.

if (!require("tcltk")) install.packages('tcltk')


getLoginDetails <- function(){
  ## Based on code by Barry Rowlingson
  ## http://r.789695.n4.nabble.com/tkentry-that-exits-after-RETURN-tt854721.html#none
  require(tcltk)
  tt <- tktoplevel()
  tkwm.title(tt, "Get login details")
  Name <- tclVar("Login ID")
  Password <- tclVar("Password")
  entry.Name <- tkentry(tt,width="20", textvariable=Name)
  entry.Password <- tkentry(tt, width="20", show="*", 
                            textvariable=Password)
  tkgrid(tklabel(tt, text="Please enter your login details."))
  tkgrid(entry.Name)
  tkgrid(entry.Password)
  
  OnOK <- function()
  { 
    tkdestroy(tt) 
  }
  OK.but <-tkbutton(tt,text=" Login ", command=OnOK)
  tkbind(entry.Password, "<Return>", OnOK)
  tkgrid(OK.but)
  tkfocus(tt)
  tkwait.window(tt)
  
  invisible(c(loginID=tclvalue(Name), password=tclvalue(Password)))
}
credentials <- getLoginDetails()
## Do what needs to be done



## username for JDBC/ODBC connection?
usrnm = credentials[[1]]

## password for JDBC/ODBC connection
pss = credentials[[2]]

# who is running the test?
tester <- "TESTER NAME" 

## Delete credentials
rm(credentials)

## reading organization name
org <- org

###identifying data model PCORnet V3, OMOP V4-V5
CDM <- CDM

###identifying SQL connection PostgreSQL or SQL Server
SQL <- SQL

