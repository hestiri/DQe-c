##DQe-v queries



if (SQL == "SQLServer") {
# -- Compute population by quarter

pop = dbGetQuery(conn, "select location_cd u_Loc,datepart(year,start_date)*10+(2.4*(datepart(quarter,start_date))) u_Time,count(distinct patient_num) population
from visit_dimension where year(start_date)>2000 and year(start_date)<2020 group by datepart(year,start_date)*10+(2.4*(datepart(quarter,start_date))), location_cd")


# -- Compute diabetes mellitus by quarter 
diabetes = dbGetQuery(conn, "select u_Loc,u_Time,u_Cond,patient,ltrim(str(l_Time1))+' Q'+ltrim(str(l_Time2)) l_Time from
(select v.location_cd u_Loc,datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))) u_Time,'Diabetes Mellitus' u_Cond,count(distinct f.patient_num) patient,max(datepart(year,f.start_date)) l_Time1,max(datepart(quarter,f.start_date)) l_Time2  
  from observation_fact f inner join SCILHS_diag o on f.concept_cd=o.c_basecode
  inner join visit_dimension v on f.encounter_num=v.encounter_num
  where year(f.start_date)>2000 and year(f.start_date)<2020 
  and (c_fullname like '\\PCORI\\DIAGNOSIS\\10\\(E00-E89) Endo~c157\\(E08-E13) Diab~1uxc\\%' or c_fullname like '\\PCORI\\DIAGNOSIS\\09\\(001-999.99) D~qlur\\(240-279.99) E~ro7n\\(249-259.99) D~eqap\\(250) Diabetes~kvrx\\%')
  group by datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))), v.location_cd) x")

# -- Compute vitals by quarter

vitals = dbGetQuery(conn, "select u_Loc,u_Time,u_Cond,patient,ltrim(str(l_Time1))+' Q'+ltrim(str(l_Time2)) l_Time from
(select v.location_cd u_Loc,datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))) u_Time,'Vitals' u_Cond,count(distinct f.patient_num) patient,max(datepart(year,f.start_date)) l_Time1,max(datepart(quarter,f.start_date)) l_Time2
  from observation_fact f inner join pcornet_master_vw o on f.concept_cd=o.c_basecode
  inner join visit_dimension v on f.encounter_num=v.encounter_num
  where year(f.start_date)>2000 and year(f.start_date)<2020 
  and (c_fullname like '\\PCORI\\VITAL\\%')
  group by datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))), v.location_cd) x")


# -- labs by quarter
labs = dbGetQuery(conn, "select u_Loc,u_Time,u_Cond,patient,ltrim(str(l_Time1))+' Q'+ltrim(str(l_Time2)) l_Time from (select v.location_cd u_Loc,datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))) u_Time,'Labs' u_Cond,count(distinct f.patient_num) patient,max(datepart(year,f.start_date)) l_Time1,max(datepart(quarter,f.start_date)) l_Time2 from 
observation_fact f inner join pcornet_master_vw o on f.concept_cd=o.c_basecode 
inner join visit_dimension v on f.encounter_num=v.encounter_num 
where year(f.start_date)>2000 and year(f.start_date)<2020
and (c_fullname like '\\PCORI\\LAB_RESULT_CM\\%')
group by datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))), v.location_cd) x")

# -- encounters by quarter
encs = dbGetQuery(conn, "select u_Loc,u_Time,u_Cond,patient,ltrim(str(l_Time1))+' Q'+ltrim(str(l_Time2)) l_Time from (select v.location_cd u_Loc,datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))) u_Time,'Encounters' u_Cond,count(distinct f.patient_num) patient,max(datepart(year,f.start_date)) l_Time1,max(datepart(quarter,f.start_date)) l_Time2 from 
observation_fact f inner join pcornet_master_vw o on f.concept_cd=o.c_basecode 
inner join visit_dimension v on f.encounter_num=v.encounter_num 
where year(f.start_date)>2000 and year(f.start_date)<2020
and (c_fullname like '\\PCORI\\ENCOUNTER\\%')
group by datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))), v.location_cd) x")

# -- medications by quarter
meds = dbGetQuery(conn, "select u_Loc,u_Time,u_Cond,patient,ltrim(str(l_Time1))+' Q'+ltrim(str(l_Time2)) l_Time from (select v.location_cd u_Loc,datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))) u_Time,'Medications' u_Cond,count(distinct f.patient_num) patient,max(datepart(year,f.start_date)) l_Time1,max(datepart(quarter,f.start_date)) l_Time2 from 
observation_fact f inner join pcornet_master_vw o on f.concept_cd=o.c_basecode 
inner join visit_dimension v on f.encounter_num=v.encounter_num 
where year(f.start_date)>2000 and year(f.start_date)<2020
and (c_fullname like '\\PCORI\\MEDICATION\\%')
group by datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))), v.location_cd) x")


# -- procedures by quarter
procs = dbGetQuery(conn, "select u_Loc,u_Time,u_Cond,patient,ltrim(str(l_Time1))+' Q'+ltrim(str(l_Time2)) l_Time from (select v.location_cd u_Loc,datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))) u_Time,'Procedures' u_Cond,count(distinct f.patient_num) patient,max(datepart(year,f.start_date)) l_Time1,max(datepart(quarter,f.start_date)) l_Time2 from 
observation_fact f inner join pcornet_master_vw o on f.concept_cd=o.c_basecode 
inner join visit_dimension v on f.encounter_num=v.encounter_num 
where year(f.start_date)>2000 and year(f.start_date)<2020
and (c_fullname like '\\PCORI\\PROCEDURE\\%')
group by datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))), v.location_cd) x")

# -- diagnoses by quarter
# diags = dbGetQuery(conn, "select u_Loc,u_Time,u_Cond,patient,ltrim(str(l_Time1))+' Q'+ltrim(str(l_Time2)) l_Time from (select v.location_cd u_Loc,datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))) u_Time,’Diagnoses' u_Cond,count(distinct f.patient_num) patient,max(datepart(year,f.start_date)) l_Time1,max(datepart(quarter,f.start_date)) l_Time2 from 
# observation_fact f inner join pcornet_master_vw o on f.concept_cd=o.c_basecode 
# inner join visit_dimension v on f.encounter_num=v.encounter_num 
# where year(f.start_date)>2000 and year(f.start_date)<2020
# and (c_fullname like '\\PCORI\\DIAGNOSIS\\%')
# group by datepart(year,f.start_date)*10+(2.4*(datepart(quarter,f.start_date))), v.location_cd) x")

} 

  
pat = rbind(procs, meds, encs,labs,vitals, diabetes)
srcdt = merge(pat,pop, by =c("u_Loc", "u_Time"))

write.csv(srcdt, file = paste("reports/dqev_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))

