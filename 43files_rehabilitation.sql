select
        b_site.b_visit_office_id as HOSPCODE
        , t_health_family.health_family_hn_hcis as PID  
        , case when t_visit.visit_vn is not null then t_visit.visit_vn else '' end as SEQ
        , case when t_visit.f_visit_type_id = '1' then t_visit.visit_vn else '' end  as AN
        , case when t_visit.f_visit_type_id = '1' 
                    then to_char(text_to_timestamp(t_visit.visit_begin_admit_date_time),'YYYYMMDDHH24MISS') 
                    else '' end as DATE_ADMIT
        , to_char(t_health_rehabilitation.survey_date,'YYYYMMDD')  as DATE_SERV
        , case when t_health_rehabilitation.start_date is not null and t_visit.f_visit_type_id = '1'
                    then to_char(t_health_rehabilitation.start_date,'YYYYMMDD') else '' end as DATE_START
        , case when t_health_rehabilitation.finish_date is not null and t_visit.f_visit_type_id = '1'
                    then to_char(t_health_rehabilitation.finish_date,'YYYYMMDD') else '' end as DATE_FINISH
        , f_rehabilitation_code.f_rehabilitation_code_id as REHABCODE
        , case when f_rehabilitation_device.f_rehabilitation_device_id is not null 
                    then f_rehabilitation_device.f_rehabilitation_device_id else '' end as AT_DEVICE
        , case when f_rehabilitation_device.f_rehabilitation_device_id is not null  
                    then t_health_rehabilitation.device_qty::text else '' end as AT_NO
        , t_health_rehabilitation.hospital as REHABPLACE
        , b_employee.provider as PROVIDER
        , to_char(t_health_rehabilitation.update_date_time,'YYYYMMDDHH24MISS') as D_UPDATE

from    
        t_health_rehabilitation inner join t_health_family on t_health_rehabilitation.t_person_id = t_health_family.t_health_family_id
        left join t_visit on t_health_rehabilitation.t_visit_id = t_visit.t_visit_id        
                                 and t_visit.f_visit_status_id ='3'
                                 and t_visit.visit_money_discharge_status ='1'
                                 and t_visit.visit_doctor_discharge_status ='1'
        inner join f_rehabilitation_code on t_health_rehabilitation.f_rehabilitation_code_id = f_rehabilitation_code.f_rehabilitation_code_id
        left join f_rehabilitation_device on t_health_rehabilitation.f_rehabilitation_device_id = f_rehabilitation_device.f_rehabilitation_device_id

        left join b_employee on t_health_rehabilitation.user_update_id = b_employee.b_employee_id
        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site

where
        t_health_family.health_family_active = '1'
        and t_health_rehabilitation.active = '1'
        and (to_char(t_health_rehabilitation.update_date_time ,'YYYY')::int + 543) 
            ||to_char(t_health_rehabilitation.update_date_time ,'-MM-DD') between ':startDate' and ':endDate' 

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
order by
        D_UPDATE asc