select 
        b_site.b_visit_office_id as HOSPCODE
        , t_health_family.health_family_hn_hcis as PID  
        , t_visit.visit_vn SEQ
        , to_char(t_health_functional.survey_date,'YYYYMMDD') as DATE_SERRV
        , f_functional_test.f_functional_test_id as FUNCTIONAL_TEST
        , t_health_functional.test_result::text as TESTRESULT
        , f_functional_dependent.f_functional_dependent_id as DEPENDENT
        , b_employee.provider as PROVIDER
        , to_char(t_health_functional.update_date_time,'YYYYMMDDHH24MISS') as D_UPDATE

from
        t_health_functional inner join t_visit on t_health_functional.t_visit_id = t_visit.t_visit_id
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id   
        inner join t_health_family on t_health_family.t_health_family_id = t_patient.t_health_family_id      
        inner join f_functional_test on t_health_functional.f_functional_test_id = f_functional_test.f_functional_test_id
        left join f_functional_dependent on t_health_functional.f_functional_dependent_id = f_functional_dependent.f_functional_dependent_id

        left join b_employee on t_health_functional.user_update_id = b_employee.b_employee_id
        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site

where
        t_health_family.health_family_active = '1'
        and t_visit.f_visit_status_id ='3'
        and t_visit.visit_money_discharge_status ='1'
        and t_visit.visit_doctor_discharge_status ='1'
        and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10) between '2559-07-01' and '2559-07-31' 
        and t_health_functional.active = '1'

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
order by
        D_UPDATE asc