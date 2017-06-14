select 

        b_site.b_visit_office_id as HOSPCODE
        , case when t_health_disability.health_disability_number is not null 
                     then substr(t_health_disability.health_disability_number,1,13) else '' end as DISABID
        , t_health_family.health_family_hn_hcis as PID
        , t_visit.visit_vn SEQ
        , to_char(t_health_icf.survey_date,'YYYYMMDD') as DATE_SERRV
        , f_icf_code.f_icf_code_id as ICF
        , '' as QUALIFIER
        , b_employee.provider as PROVIDER
        , to_char(t_health_icf.update_date_time,'YYYYMMDDHH24MISS') as D_UPDATE

from
        t_health_icf inner join t_visit on t_health_icf.t_visit_id = t_visit.t_visit_id
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id   
        inner join t_health_family on t_health_family.t_health_family_id = t_patient.t_health_family_id
        left join t_health_disability on t_health_family.t_health_family_id = t_health_disability.t_person_id        
        inner join f_icf_code on t_health_icf.f_icf_code_id = f_icf_code.f_icf_code_id

        left join b_employee on t_health_icf.user_update_id = b_employee.b_employee_id
        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site

where
        t_health_family.health_family_active = '1'
        and t_visit.f_visit_status_id ='3'
        and t_visit.visit_money_discharge_status ='1'
        and t_visit.visit_doctor_discharge_status ='1'
        and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate' 
        and t_health_icf.active = '1'

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
order by
        D_UPDATE asc