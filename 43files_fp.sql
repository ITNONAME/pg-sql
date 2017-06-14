SELECT  distinct
	b_site.b_visit_office_id  AS HOSPCODE  
    ,t_health_family.health_family_hn_hcis as PID 
    ,case when t_visit.visit_vn is not null and t_visit.visit_vn <> ''
            then t_visit.visit_vn
         else '' end AS SEQ 	
    , case when t_visit.visit_begin_visit_time is not null
                then (to_number(substring(t_visit.visit_begin_visit_time,1,5),'9999')-543)
                        || substring(t_visit.visit_begin_visit_time,6,2)
                        || substring(t_visit.visit_begin_visit_time,9,2)
              when  t_health_family_planing.health_family_planing_date is not null and trim(t_health_family_planing.health_family_planing_date) <> ''
                then (to_number(substring(t_health_family_planing.health_family_planing_date,1,5),'9999')-543)
                        || substring(t_health_family_planing.health_family_planing_date,6,2)
                        || substring(t_health_family_planing.health_family_planing_date,9,2)
               else (to_number(substring(t_health_family_planing.update_record_date_time,1,5),'9999')-543)
                        || substring(t_health_family_planing.update_record_date_time,6,2)
                        || substring(t_health_family_planing.update_record_date_time,9,2)
     end AS DATE_SERV 
    , t_health_family_planing.f_health_family_planing_method_id AS FPTYPE 
    , case when (b_site.b_visit_office_id  is not null)  or  (b_site.b_visit_office_id <>'')
 then  b_site.b_visit_office_id
else '00000' end AS FPPLACE 
    ,b_employee.provider as PROVIDER
    ,(case  when length(t_visit.visit_staff_doctor_discharge_date_time) >= 10
                then case when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else '' end
             when length(t_health_family_planing.update_record_date_time) >= 10
                then case when length(cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end)  as D_UPDATE 


FROM  
        t_health_family_planing INNER JOIN t_health_family 
        ON t_health_family.t_health_family_id = t_health_family_planing.t_health_family_id  
        LEFT JOIN b_health_family_planing_group  
        ON t_health_family_planing.b_health_family_planing_group_id = b_health_family_planing_group.b_health_family_planing_group_id  AND b_health_family_planing_group.health_family_planning_group_active='1' 
        INNER JOIN t_visit
        ON t_health_family_planing.t_visit_id = t_visit.t_visit_id
        LEFT JOIN b_employee
        ON t_health_family_planing.health_family_planing_staff_record = b_employee.b_employee_id and b_employee.employee_active='1'

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site

WHERE
         t_health_family_planing.health_family_planing_active ='1'
        AND t_health_family_planing.f_health_family_planing_method_id in ('1','2','3','4','5','6','7')
        AND t_visit.f_visit_type_id <> 'S'
        AND t_visit.f_visit_status_id ='3'
        AND t_visit.visit_money_discharge_status='1'
        AND t_visit.visit_doctor_discharge_status='1' 				
        AND substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate'   

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
