source("dmrun.R")

#########################################################################
### finding out how many patients don't have specific health variables.##
#########################################################################


if (CDM == "PCORNET3") {
  
  ##gender

  #define the only wanted values
  gender <- c("M","F")
  
  without_gender <- withoutdem(table = demographic, col = "sex", ref_date2 = "2014-01-01" ,list = gender)

   ##race -- make sure we understand what values are in accepted list!
  race <- c("05","03","07","02","01","04","06","OT")
  
  without_race <- withoutdem(table = demographic, col = "race", ref_date2 = "2014-01-01" ,list = race)
  
  
  #ethnicity
  ethnicity <- c("Y") 
  
  without_ethnicity <- withoutdem(table = demographic, col = "hispanic", ref_date2 = "2014-01-01" ,list = ethnicity)
  
  
  
  ##################
  ##################
  ######### Using Function "WITHOUT"
  ####################
  ####################
  
  # medication
  #define the uwanted values in addition to NULLs...
  medication <- c('+', '-', '_','', '$', "",'*', '?', '.', '&', '^', '%', '!', '@','NI')
  # 
  without_medication <- 
    without(table = "PRESCRIBING", col = "prescribingid", ref_date2 = "2014-01-01" ,list = medication)
  
  
  
  #Dx -------------
  #define the uwanted values in addition to NULLs...
  diagnosis <- c('+', '-', '_','', '$', "",'*', '?', '.', '&', '^', '%', '!', '@','NI')
  # 
  without_diagnosis <- 
    without(table = "DIAGNOSIS", col = "dx", ref_date2 = "2014-01-01" ,list = diagnosis)
  
  
  #Encounter -------------
  #define the uwanted values in addition to NULLs...
  encounter <- c('+', '-', '_','', '$', "",'*', '?', '.', '&', '^', '%', '!', '@','NI')
  # 
  without_encounter <- 
    without(table = "ENCOUNTER", col = "enc_type", ref_date2 = "2014-01-01" ,list = encounter)
  
  
  #Weight -------------
  #define the uwanted values in addition to NULLs...
  weight <- c('+', '-', '_','', '$', "",'*', '?', '.', '&', '^', '%', '!', '@','NI')
  # 
  without_weight <- 
    without(table = "VITAL", col = "wt", ref_date2 = "2014-01-01" ,list = weight)
  
  
  
  #Height -------------
  #define the uwanted values in addition to NULLs...
  height <- c('+', '-', '_','', '$', "",'*', '?', '.', '&', '^', '%', '!', '@','NI')
  # 
  without_height <- 
    without(table = "VITAL", col = "ht", ref_date2 = "2014-01-01" ,list = height)
  
  
  #blood_pressure -------------
  #define the uwanted values in addition to NULLs...
  blood_pressure <- c('+', '-', '_','', '$', "",'*', '?', '.', '&', '^', '%', '!', '@','NI')
  # 
  without_BP_sys <- 
    without(table = "VITAL", col = "systolic", ref_date2 = "2014-01-01" ,list = blood_pressure)
  
  without_BP_dias <- 
    without(table = "VITAL", col = "diastolic", ref_date2 = "2014-01-01" ,list = blood_pressure)
  
  without_BP <- rbind(without_BP_sys,without_BP_dias)
  
  
  #smoking -------------
  #define the uwanted values in addition to NULLs...
  smoking <- c('+', '-', '_','', '$', "",'*', '?', '.', '&', '^', '%', '!', '@','NI')
  # 
  without_smoking <- 
    without(table = "VITAL", col = "smoking", ref_date2 = "2014-01-01" ,list = smoking)
  
  
  
  withouts <- rbind(without_encounter,without_diagnosis,without_medication,without_ethnicity,without_race,without_gender,without_weight,
                    without_height,without_BP,without_smoking)
  
  

  withouts$perc <- percent(withouts$missing.percentage)
  withouts$organization <- org
  withouts$test_date <- as.character(format(Sys.Date(),"%m-%d-%Y"))
  withouts$CDM <- CDM
  
  write.csv(withouts, file = paste("reports/withouts_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))
  
  ## make another copy in the comparison directory for comparison
  # write.csv(withouts, file = paste("PATH/withouts_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))
  
}   
  
  
    
  