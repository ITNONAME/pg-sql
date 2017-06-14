select 
        b_site.b_visit_office_id as HOSPCODE 
        , t_health_family.health_family_hn_hcis as PID    
        , case when t_visit.visit_vn is not null then t_visit.visit_vn else '' end as SEQ  
        , to_char(t_health_specialpp.survey_date,'YYYYMMDD')  as DATE_SERV
        , t_health_specialpp.survey_place as SERVPLACE
        , f_specialpp_code.f_specialpp_code_id as PPSPECIAL
        , t_health_specialpp.hospital as PPSPLACE
        , b_employee.provider as PROVIDER
        , to_char(t_health_specialpp.update_date_time,'YYYYMMDDHH24MISS') as D_UPDATE

from 
        t_health_specialpp inner join t_health_family on t_health_specialpp.t_person_id = t_health_family.t_health_family_id
        left join t_visit on t_health_specialpp.t_visit_id = t_visit.t_visit_id        
                                 and t_visit.f_visit_status_id ='3'
                                 and t_visit.visit_money_discharge_status ='1'
                                 and t_visit.visit_doctor_discharge_status ='1'                                  
        inner join f_specialpp_code on t_health_specialpp.f_specialpp_code_id = f_specialpp_code.f_specialpp_code_id

        left join b_employee on t_health_specialpp.user_update_id = b_employee.b_employee_id
        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site

where
        t_health_family.health_family_active = '1'
        and t_health_specialpp.active = '1'
        and (to_char(t_health_specialpp.update_date_time ,'YYYY')::int + 543) 
            ||to_char(t_health_specialpp.update_date_time ,'-MM-DD') between '2559-07-01' and '2559-07-31' 

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
order by
        D_UPDATE asc