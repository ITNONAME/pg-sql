select distinct
b_site.b_visit_office_id as HOSPCODE
,t_health_family.health_family_hn_hcis as PID
,t_visit.visit_vn as SEQ
,(to_number(substring(t_visit.visit_begin_visit_time,1,4),'9999')-543)       
			|| substring(t_visit.visit_begin_visit_time,6,2)       
			|| substring(t_visit.visit_begin_visit_time,9,2)  as date_serv
,f_comservice.code as COMSERVICE
,b_employee.provider as PROVIDER
, case when length(t_visit.visit_staff_doctor_discharge_date_time) >= 10
                then cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                         || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')
                when length(t_health_community_service.modify_date_time) >= 10
                then cast(substring(t_health_community_service.modify_date_time,1,4) as numeric) - 543
                         || replace(replace(replace(substring(t_health_community_service.modify_date_time,5),'-',''),',',''),':','')
                else ''
end as D_UPDATE 

from 
        t_health_community_service 
        inner join t_visit on t_health_community_service.t_visit_id = t_visit.t_visit_id
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
        inner join t_health_family on t_patient.t_health_family_id = t_health_family.t_health_family_id
        inner join f_comservice on t_health_community_service.f_comservice_id = f_comservice.f_comservice_id
        left join b_employee on t_health_community_service.staff_record = b_employee.b_employee_id

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site

where 
        t_health_community_service.active ='1'
        and t_visit.f_visit_status_id <> '4'
        AND t_visit.f_visit_type_id <> 'S'
        AND t_visit.visit_money_discharge_status='1'
        AND t_visit.visit_doctor_discharge_status='1' 				
        AND substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate'
        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)