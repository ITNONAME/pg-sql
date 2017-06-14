select distinct
            b_site.b_visit_office_id as HOSPCODE
            , t_health_family.health_family_hn_hcis as PID  
            , t_visit.visit_vn as SEQ  
             , substr(t_visit.visit_begin_visit_time,1,4)::int -543
                ||replace(replace(replace(substr(t_visit.visit_begin_visit_time,5),'-',''),',',''),':','') as DATETIME_SERV
            , rpad(substr(t_accident.accident_date,1,4)::int -543
                ||replace(replace(replace(substr(t_accident.accident_date||t_accident.accident_time,5),'-',''),',',''),':',''),14,'0') as DATETIME_AE  
            , case when r_accident_group.accident_group_number is not null 
                            then lpad(r_accident_group.accident_group_number,2,'0')
                            else ''
                        end as AETYPE
            , lpad(t_accident.f_accident_place_id,2,'0') as AEPLACE 
            , t_accident.f_accident_visit_type_id as TYPEIN_AE
            , case when t_accident.f_accident_victim_type_id = '1' then  '1'
                      when t_accident.f_accident_victim_type_id = '2' then  '2' 
                      when t_accident.f_accident_victim_type_id = '4' then  '3' 
                      when t_accident.f_accident_victim_type_id = '8' then  '8'
                      when t_accident.f_accident_victim_type_id = '0' then  '9'  
                    else '9' end as  TRAFFIC
             , case  when t_accident.f_accident_patient_vechicle_type_id in ('2','10') then '01'
                        when t_accident.f_accident_patient_vechicle_type_id in ('3') then '02'
                        when t_accident.f_accident_patient_vechicle_type_id in ('11') then '03'
                        when t_accident.f_accident_patient_vechicle_type_id in ('4') then '04'
                        when t_accident.f_accident_patient_vechicle_type_id in ('5') then '05' 
                        when t_accident.f_accident_patient_vechicle_type_id in ('14') then '06' 
                        when t_accident.f_accident_patient_vechicle_type_id in ('7') then '07' 
                        when t_accident.f_accident_patient_vechicle_type_id in ('8') then '08' 
                        when t_accident.f_accident_patient_vechicle_type_id in ('6') then '09' 
                        when t_accident.f_accident_patient_vechicle_type_id in ('15') then '10' 
                        when t_accident.f_accident_patient_vechicle_type_id in ('16') then '11' 
                        when t_accident.f_accident_patient_vechicle_type_id in ('17') then '12' 
                        when t_accident.f_accident_patient_vechicle_type_id in ('1','9','12','13') then '98' 
                        when t_accident.f_accident_patient_vechicle_type_id in ('0') then '99' 
                        else '99' end as VEHICLE
            , case when t_accident.accident_alcohol = '1' then '1'
                        when t_accident.accident_alcohol = '0' then '2'
                        when t_accident.accident_alcohol = '9' then '9'
                        else '9' end  as ALCOHOL
            , t_accident.accident_narcotic as NACROTIC_DRUG
            , case when t_accident.f_accident_patient_vechicle_type_id in ('4','5','14','6') and t_accident.f_accident_protection_type_id ='0' then '9'
                        when t_accident.f_accident_patient_vechicle_type_id in ('4','5','14','6') and t_accident.f_accident_protection_type_id ='2' then '1'
                        when t_accident.f_accident_patient_vechicle_type_id in ('4','5','14','6') and t_accident.f_accident_protection_type_id ='1' then '2'
                        else '' end as BELT
            , case when t_accident.f_accident_patient_vechicle_type_id in ('2','10','3','11') and t_accident.f_accident_protection_type_id ='0' then '9'
                        when t_accident.f_accident_patient_vechicle_type_id in ('2','10','3','11') and t_accident.f_accident_protection_type_id ='2' then '1'
                        when t_accident.f_accident_patient_vechicle_type_id in ('2','10','3','11') and t_accident.f_accident_protection_type_id ='1' then '2'
                        else '' end  as HELMET
            , t_accident.accident_airway  as AIRWAY
            , t_accident.accident_stopbleed  as STOPBLEED
            , t_accident.accident_splint  as SPLINT
            , t_accident.accident_fluid  as FLUID
            , case --when t_visit.f_emergency_status_id in ('3') then '1'
                        when t_visit.f_emergency_status_id in ('3') then '2'
                        when t_visit.f_emergency_status_id in ('2') then '3'
                        --when t_visit.f_emergency_status_id in ('3') then '4'
                        when t_visit.f_emergency_status_id in ('1') then '5'
                        when t_visit.f_emergency_status_id in ('0') then '6' 
                    else '6' end as URGENCY
            , t_accident.f_accident_symptom_eye_id as COMA_EYE
            , t_accident.f_accident_symptom_speak_id as COMA_SPEAK
            , t_accident.f_accident_symptom_movement_id as COMA_MOVEMENT
              , case when length(t_accident.accident_update_date_time) >= 10
                                then rpad(substr(t_accident.accident_update_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_accident.accident_update_date_time,5),'-',''),',',''),':',''),14,'0')
                     else  rpad(substr(t_accident.accident_staff_record_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_accident.accident_staff_record_date_time,5),'-',''),',',''),':',''),14,'0')
                     end as D_UPDATE  
from
        t_accident inner join t_visit on t_accident.t_visit_id = t_visit.t_visit_id
        left join b_icd10 on t_accident.icd10_number = b_icd10.icd10_number and b_icd10.icd10_accident = '1'
        left join r_accident_group_code on b_icd10.icd10_number between accident_group_code_begin and accident_group_code_end
                            and r_accident_group_code.r_accident_group_id not in ('8150000000020','8150000000021','8150000000022')
        left join r_accident_group on r_accident_group_code.r_accident_group_id  = r_accident_group.r_accident_group_id 
                            and r_accident_group.r_accident_group_id not in ('8150000000020','8150000000021','8150000000022')
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
        inner join t_health_family on t_patient.t_health_family_id =  t_health_family.t_health_family_id
        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site
where
        t_accident.accident_active = '1'
        and t_health_family.health_family_active = '1'
        and t_visit.f_visit_status_id = '3'
        and t_visit.visit_money_discharge_status ='1'
        and t_visit.visit_doctor_discharge_status ='1'
        and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10)  between ':startDate' and ':endDate'

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

order by  t_visit.visit_vn asc