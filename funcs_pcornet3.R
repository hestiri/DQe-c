# a function to count patients without a given parameter within the source patient table
if (SQL == "SQLServer") {
  
  withoutdem <- function(table,col,list,ref_date1 = "1900-01-01", ref_date2=Sys.Date()) {
    df.name <- deparse(substitute(table))
    list.name <- deparse(substitute(list))
    ##set the denominator
    denominator <- dbGetQuery(conn,
                              paste0("SELECT COUNT(DISTINCT(PATID)) FROM DEMOGRAPHIC WHERE BIRTH_DATE > '",ref_date1,"' AND BIRTH_DATE  < '",
                                     ref_date2,"'"))
    
    #count patients with unacceptable values for the given column and table
    notin <- dbGetQuery(conn,
                        paste0("SELECT COUNT(PATID) FROM (SELECT * FROM ",schema,prefix,"DEMOGRAPHIC WHERE BIRTH_DATE > '",ref_date1,"' AND BIRTH_DATE  < '",
                               ref_date2,"') dd WHERE ",
                               toupper(col), " NOT IN ('",paste(list,collapse = "','"),"')"))
    
    whattheyhave <- dbGetQuery(conn,
                               paste0("SELECT DISTINCT(",toupper(col),") FROM (SELECT * FROM ",schema,prefix,"DEMOGRAPHIC WHERE BIRTH_DATE > '",ref_date1,"' AND BIRTH_DATE  < '",
                                      ref_date2,"') dd WHERE ",
                                      toupper(col), " NOT IN ('",paste(list,collapse = "','"),"')"))
    
    d1 <- round((notin/denominator)*100,4)
    
    message(d1, "% of patients born between ",ref_date1," and ",ref_date2, " are missing ", list.name," information.",appendLF=T)
    if (d1 > 0) message(notin, " of the ",denominator, " patients born between ",ref_date1," and ",ref_date2, " don't have an acceptable ", toupper(list.name), " record in the ",toupper(df.name), " table.",appendLF=T)
    if (d1 > 0) message("Unacceptable values in column ", toupper(col), " are ",whattheyhave,".",appendLF=T)
    output <- data.frame("group"=list.name, "missing percentage" = as.numeric(d1), "missing population"= as.numeric(notin), "denominator"= as.numeric(denominator))
    return(output)
  }
  
  
  ## a function to count patients that are not available in the list of certain condition/drug/lab/...
  without <- function(table,col,list, # this list here works opposite to the list in the function above. here we identify what we don't want.
                      ref_date1 = "1900-01-01", ref_date2=Sys.Date()) {
    df.name <- deparse(substitute(table))
    list.name <- deparse(substitute(list))
    ##set the denominator
    denominator <- dbGetQuery(conn,
                              paste0("SELECT COUNT(DISTINCT(PATID)) FROM ",schema,prefix,"DEMOGRAPHIC WHERE BIRTH_DATE > '",ref_date1,"' AND BIRTH_DATE  < '",ref_date2,"'")
    )
    
    # orphanids <- dbGetQuery(conn,
    #                         paste0(
    #                           "SELECT COUNT(DISTINCT(PATID)) FROM ",schema,subset(tbls2$Repo_Tables,tbls2$CDM_Tables == tolower(table))," WHERE PATID NOT IN (SELECT DISTINCT(PATID) FROM ",schema,prefix,"DEMOGRAPHIC WHERE BIRTH_DATE > '",ref_date1,"' AND BIRTH_DATE  < '",ref_date2,"')"
    #                         ))
    # if (orphanids > 0) message(orphanids, " unique patient ids not available in the source table.",appendLF=T)
    
    
    #patients with at least one value out of what we want
    pats_wit_oneout <- dbGetQuery(conn,
                                  paste0("SELECT COUNT(DISTINCT(PATID)) FROM ",schema,subset(tbls2$Repo_Tables,tbls2$CDM_Tables == tolower(table))," WHERE ",toupper(col), " IS NULL OR CAST(",toupper(col), " AS CHAR(54)) IN  ('",paste(list,collapse = "','"),"')")
    )
    #calculate the percentage
    ppwo <- round((pats_wit_oneout/denominator)*100,4)
    if (ppwo > 1) message(pats_wit_oneout, " of the patients -- ",ppwo,"% of patients -- are missing at least 1 acceptable ",toupper(col)," value in the ",toupper(table)," table.",appendLF=T)
    
    
    #patients who don't have any records whatsoever
    # we calculate valid patients first
    whatsoever <- dbGetQuery(conn,
                             paste0("SELECT COUNT(DISTINCT(PATID)) FROM ",schema,prefix,"DEMOGRAPHIC WHERE BIRTH_DATE > '",ref_date1,"' AND BIRTH_DATE  < '",ref_date2,"'"," AND PATID IN (SELECT DISTINCT(PATID) FROM ",schema,subset(tbls2$Repo_Tables,tbls2$CDM_Tables == tolower(table))," WHERE ",toupper(col), " IS NOT NULL AND CAST(",toupper(col), " AS CHAR(54)) NOT IN  ('",paste(list,collapse = "','"),"'))")
    )
    #the we calculate the percentage of invalid 
    pwse <- round(((denominator-whatsoever)/denominator)*100,4)
    if (pwse > 1) message(whatsoever, " of the patients -- ",pwse,"% of patients -- are missing any acceptable ",toupper(col)," value in the ",toupper(table)," table.",appendLF=T)
    
    
    message(pwse, "% of unique patients don't have any '", list.name,"' record in the ",df.name, " table.",appendLF=T)
    output <- data.frame("group"=list.name, "missing percentage" = as.numeric(pwse), "missing population"=as.numeric(whatsoever),"denominator"=as.numeric(denominator))
    return(output)
  }
  
} else
  if (SQL == "Oracle") {
    withoutdem <- function(table,col,list,ref_date1 = "1900-01-01", ref_date2=Sys.Date()) {
      df.name <- deparse(substitute(table))
      list.name <- deparse(substitute(list))
      ##set the denominator
      denominator <- dbGetQuery(conn,
                                paste0("SELECT COUNT(DISTINCT(PATID)) FROM DEMOGRAPHIC WHERE BIRTH_DATE > TO_DATE('",ref_date1,"', 'yyyy-mm-dd') AND BIRTH_DATE  < TO_DATE('",ref_date2,"', 'yyyy-mm-dd')"))
      
      #count patients with unacceptable values for the given column and table
      notin <- dbGetQuery(conn,
                          paste0("SELECT COUNT(PATID) FROM (SELECT * FROM ",schema,prefix,"DEMOGRAPHIC WHERE BIRTH_DATE > TO_DATE('",ref_date1,"', 'yyyy-mm-dd') AND BIRTH_DATE  < TO_DATE('",ref_date2,"', 'yyyy-mm-dd')) WHERE ",
                                 toupper(col), " NOT IN ('",paste(list,collapse = "','"),"')"))
      
      whattheyhave <- dbGetQuery(conn,
                                 paste0("SELECT DISTINCT(",toupper(col),") FROM (SELECT * FROM ",schema,prefix,"DEMOGRAPHIC WHERE BIRTH_DATE > TO_DATE('",ref_date1,"', 'yyyy-mm-dd') AND BIRTH_DATE  < TO_DATE('",ref_date2,"', 'yyyy-mm-dd')) WHERE ",
                                        toupper(col), " NOT IN ('",paste(list,collapse = "','"),"')"))
      
      d1 <- round((notin/denominator)*100,4)
      
      message(d1, "% of patients born between ",ref_date1," and ",ref_date2, " are missing ", list.name," information.",appendLF=T)
      if (d1 > 0) message(notin, " of the ",denominator, " patients born between ",ref_date1," and ",ref_date2, " don't have an acceptable ", toupper(list.name), " record in the ",toupper(df.name), " table.",appendLF=T)
      if (d1 > 0) message("Unacceptable values in column ", toupper(col), " are ",whattheyhave,".",appendLF=T)
      output <- data.frame("group"=list.name, "missing percentage" = as.numeric(d1), "missing population"= as.numeric(notin), "denominator"= as.numeric(denominator))
      return(output)
    }
    
    
    ## a function to count patients that are not available in the list of certain condition/drug/lab/...
    without <- function(table,col,list, # this list here works opposite to the list in the function above. here we identify what we don't want.
                        ref_date1 = "1900-01-01", ref_date2=Sys.Date()) {
      df.name <- deparse(substitute(table))
      list.name <- deparse(substitute(list))
      ##set the denominator
      denominator <- dbGetQuery(conn,
                                paste0("SELECT COUNT(DISTINCT(PATID)) FROM ",schema,prefix,"DEMOGRAPHIC WHERE BIRTH_DATE > TO_DATE('",ref_date1,"', 'yyyy-mm-dd') AND BIRTH_DATE  < TO_DATE('",ref_date2,"', 'yyyy-mm-dd')"))
      
      # orphanids <- dbGetQuery(conn,
      #                         paste0(
      #                           "SELECT COUNT(DISTINCT(PATID)) FROM ",schema,subset(tbls2$Repo_Tables,tbls2$CDM_Tables == tolower(table))," WHERE PATID NOT IN (SELECT DISTINCT(PATID) FROM ",schema,prefix,"DEMOGRAPHIC WHERE BIRTH_DATE > TO_DATE('",ref_date1,"', 'yyyy-mm-dd') OR BIRTH_DATE  < TO_DATE('",ref_date2,"', 'yyyy-mm-dd'))"))
      # if (orphanids > 0) message(orphanids, " unique patient ids not available in the source table.",appendLF=T)
      # 
      
      #patients with at least one value out of what we want
      pats_wit_oneout <- dbGetQuery(conn,
                                    paste0("SELECT COUNT(DISTINCT(PATID)) FROM ",schema,subset(tbls2$Repo_Tables,tbls2$CDM_Tables == tolower(table))," WHERE ",toupper(col), " IS NULL OR TO_CHAR(",toupper(col),") IN  ('",paste(list,collapse = "','"),"')")
      )
      #calculate the percentage
      ppwo <- round((pats_wit_oneout/denominator)*100,4)
      if (ppwo > 1) message(pats_wit_oneout, " of the patients -- ",ppwo,"% of patients -- are missing at least 1 acceptable ",toupper(col)," value in the ",toupper(table)," table.",appendLF=T)
      
      
      #patients who don't have any records whatsoever
      # we calculate valid patients first
      whatsoever <- dbGetQuery(conn,
                               paste0("SELECT COUNT(DISTINCT(PATID)) FROM ",schema,prefix,"DEMOGRAPHIC WHERE BIRTH_DATE > TO_DATE('",ref_date1,"', 'yyyy-mm-dd') AND BIRTH_DATE  < TO_DATE('",ref_date2,"', 'yyyy-mm-dd') AND PATID IN (SELECT DISTINCT(PATID) FROM ",schema,subset(tbls2$Repo_Tables,tbls2$CDM_Tables == tolower(table))," WHERE ",toupper(col), " IS NOT NULL AND TO_CHAR(",toupper(col),") NOT IN  ('",paste(list,collapse = "','"),"'))")
      )
      
      #the we calculate the percentage of invalid 
      pwse <- round(((denominator-whatsoever)/denominator)*100,4)
      if (pwse > 1) message(whatsoever, " of the patients -- ",pwse,"% of patients -- are missing any acceptable ",toupper(col)," value in the ",toupper(table)," table.",appendLF=T)
      
      
      message(pwse, "% of unique patients don't have any '", list.name,"' record in the ",df.name, " table.",appendLF=T)
      output <- data.frame("group"=list.name, "missing percentage" = as.numeric(pwse), "missing population"=as.numeric(whatsoever),"denominator"=as.numeric(denominator))
      return(output)
    }  
  }




## a function to count orphan foriegn keys
orphankeys <- function(table1, #source table
                       table2, #table to be compared with source table
                       col # common column
) {
  
  orphans <- dbGetQuery(conn,
                        paste0(
                          "SELECT COUNT(DISTINCT(",toupper(col),")) FROM ",schema,subset(tbls2$Repo_Tables,tbls2$CDM_Tables == tolower(table2))," WHERE ",toupper(col)," NOT IN (SELECT DISTINCT(",toupper(col),") FROM ",schema,subset(tbls2$Repo_Tables,tbls2$CDM_Tables == tolower(table1)),")"
                        ))
  return(as.numeric(orphans))
}


#a function to print out percentages for the text labels
percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(x, format = format, digits = digits, ...), "%")
}

