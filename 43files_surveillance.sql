select distinct
            b_site.b_visit_office_id as HOSPCODE
            , t_health_family.health_family_hn_hcis as PID  
            , t_visit.visit_vn as SEQ  
            , substr(t_visit.visit_begin_visit_time,1,4)::int -543
                ||replace(replace(replace(substr(t_visit.visit_begin_visit_time,5,6),'-',''),',',''),':','') as DATE_SERV 
            , case when t_visit.f_visit_type_id = '1' 
                        then t_visit.visit_vn 
                    else '' end as AN
             , case when length(t_visit.visit_begin_admit_date_time) > 10 and t_visit.f_visit_type_id ='1'
                        then rpad(substr(t_visit.visit_begin_admit_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_begin_admit_date_time,5),'-',''),',',''),':',''),14,'0') 
                        else rpad(substr(t_visit.visit_begin_visit_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_begin_visit_time,5),'-',''),',',''),':',''),14,'0')  
                        end as DATETIME_ADMIT  
            , '' as SYNDROME
            , case when t_surveil.surveil_icd10_number is not null     
                        then replace(t_surveil.surveil_icd10_number,'.','')
                        else '' end as  DIAGCODE  
            , substr(b_group_icd10.group_icd10_group_rp506,1,2) as CODE506 

            , '' as DIAGCODELAST 
            , '' as CODE506LAST
   
            ,case when length(t_surveil.surveil_sick_date) < 10
                            then  substr(t_visit.visit_begin_visit_time,1,4)::int -543
                                        ||replace(substr(t_visit.visit_begin_visit_time,5,6),'-','') 
                            else substr(t_surveil.surveil_sick_date,1,4)::int -543
                                        ||replace(substr(t_surveil.surveil_sick_date,5,6),'-','')  
                        end as ILLDATE  
            , case when t_visit_illness_address.visit_illness_address_house is not null 
                        then t_visit_illness_address.visit_illness_address_house
                      else '' end as ILLHOUSE
             , case when t_visit_illness_address.visit_illness_address_moo is not null or t_visit_illness_address.visit_illness_address_moo <> ''
                         then lpad(t_visit_illness_address.visit_illness_address_moo,2,'0')
                       else '99' end as ILLVILLAGE
            , case when t_visit_illness_address.visit_illness_address_tambon is not null or t_visit_illness_address.visit_illness_address_tambon <> ''
                         then substr(t_visit_illness_address.visit_illness_address_tambon,5,2)
                       else '99' end as ILLTAMBON
            , case when t_visit_illness_address.visit_illness_address_amphur is not null or t_visit_illness_address.visit_illness_address_amphur <>''
                         then substr(t_visit_illness_address.visit_illness_address_amphur,3,2)
                       else '99' end as ILLAMPUR
            , case when t_visit_illness_address.visit_illness_address_changwat is not null or t_visit_illness_address.visit_illness_address_changwat <> ''
                         then substr(t_visit_illness_address.visit_illness_address_changwat,1,2)
                       else '99' end as ILLCHANGWAT 
            , case when t_visit_illness_address.visit_illness_address_latitude is not null 
                        then t_visit_illness_address.visit_illness_address_latitude
                     else null end as LATITUDE
            , case when t_visit_illness_address.visit_illness_address_longitude is not null 
                        then t_visit_illness_address.visit_illness_address_longitude
                     else null end as LONGITUDE

            , case when t_surveil.f_chronic_discharge_status_id in ('1','2','3') 
                  then t_surveil.f_chronic_discharge_status_id 
                  else '9' end as PTSTATUS
            , case when length(t_death.death_date_time)>9 
                    then
                    substr(t_death.death_date_time,1,4)::int -543    
                    || substr(t_death.death_date_time,6,2)       
                    || substr(t_death.death_date_time,9,2) 
                    else '' end as  DATE_DEATH 
            , t_surveil.r_rp1853_surveilcomplicate_id as COMPLICATION 
            , t_surveil.r_rp1853_surveiloganism_id as ORGANISM  

            , b_employee.provider as PROVIDER
             , rpad(substr(t_visit.visit_staff_doctor_discharge_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''),14,'0') as D_UPDATE 
from 
        t_surveil inner join t_visit on t_surveil.t_visit_id = t_visit.t_visit_id
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
        inner join t_health_family on t_patient.t_health_family_id =  t_health_family.t_health_family_id
        left join b_group_icd10 on t_surveil.surveil_icd10_number = b_group_icd10.group_icd10_number 
        left join t_death on t_death.t_health_family_id = t_health_family.t_health_family_id and t_death.death_active = '1'
        left join t_visit_illness_address on t_visit.t_visit_id = t_visit_illness_address.t_visit_id
        left join b_employee on t_visit.visit_staff_doctor_discharge = b_employee.b_employee_id

        cross join b_site
where
        t_health_family.health_family_active = '1'
        and t_visit.f_visit_status_id ='3'
        and t_visit.visit_money_discharge_status ='1'
        and t_visit.visit_doctor_discharge_status ='1'
        and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate' 

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)


order by SEQ asc