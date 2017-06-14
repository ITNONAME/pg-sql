SELECT 
	b_site.b_visit_office_id AS HOSPCODE
    ,t_health_family.health_family_hn_hcis as PID 
	, t_visit.visit_vn AS SEQ
   , case when t_health_epi_detail.health_epi_start is not null and trim(t_health_epi_detail.health_epi_start) <> ''
                then (to_number(substring(t_health_epi_detail.health_epi_start,1,5),'9999')-543)
                        || substring(t_health_epi_detail.health_epi_start,6,2)
                        || substring(t_health_epi_detail.health_epi_start,9,2)
              when  t_health_epi.epi_survey_date is not null and trim(t_health_epi.epi_survey_date) <> ''
                then (to_number(substring(t_health_epi.epi_survey_date,1,5),'9999')-543)
                        || substring(t_health_epi.epi_survey_date,6,2)
                        || substring(t_health_epi.epi_survey_date,9,2)
               else (to_number(substring(t_health_epi.modify_date_time,1,5),'9999')-543)
                        || substring(t_health_epi.modify_date_time,6,2)
                        || substring(t_health_epi.modify_date_time,9,2)
     end AS DATE_SERV  
	, epi_code.epi_code AS VACCINETYPE  
	, b_site.b_visit_office_id AS VACCINEPLACE
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
            when length(t_health_epi.modify_date_time) >= 10
                then case when length(cast(substring(t_health_epi.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi.modify_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_epi.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi.modify_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_epi.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi.modify_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_epi.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi.modify_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_epi.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi.modify_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_epi.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi.modify_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_epi.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi.modify_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_epi.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi.modify_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end)  as D_UPDATE 




FROM   t_health_epi
	INNER JOIN t_health_epi_detail  ON (t_health_epi.t_health_epi_id = t_health_epi_detail.t_health_epi_id AND health_epi_detail_active = '1')
	INNER JOIN b_health_epi_group  ON t_health_epi_detail.b_health_epi_set_id = b_health_epi_group.b_health_epi_group_id
	INNER JOIN t_health_family  ON t_health_epi_detail.t_health_family_id = t_health_family.t_health_family_id
	INNER JOIN t_visit  ON (t_visit.t_visit_id = t_health_epi.t_visit_id )
	INNER JOIN 
	(select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, health_epi_group_description_particular as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) = 0
and length(health_epi_group_description_particular) = 3
union
select  b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,1,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 7
union
select  b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,5,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 7
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,1,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 11
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,5,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 11
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,9,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 11
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,1,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 15
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,5,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 15
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,9,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 15
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,13,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 15) epi_code
ON epi_code.b_health_epi_group_id = b_health_epi_group.b_health_epi_group_id
LEFT JOIN b_employee
ON t_health_epi.health_epi_staff_record = b_employee.b_employee_id and b_employee.employee_active='1'

            left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
            cross join b_site

WHERE  	
        t_health_epi.health_epi_active = '1'
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

UNION

SELECT 
	b_site.b_visit_office_id AS HOSPCODE
    ,t_health_family.health_family_hn_hcis as PID 
	, '' AS SEQ
   , case when t_health_epi_outsite.epi_outsite_date <> ''
                then (to_number(substring(t_health_epi_outsite.epi_outsite_date,1,5),'9999')-543)
                        || substring(t_health_epi_outsite.epi_outsite_date,6,2)
                        || substring(t_health_epi_outsite.epi_outsite_date,9,2)
               else (to_number(substring(t_health_epi_outsite.record_date_time,1,5),'9999')-543)
                        || substring(t_health_epi_outsite.record_date_time,6,2)
                        || substring(t_health_epi_outsite.record_date_time,9,2)
     end AS DATE_SERV  
	, epi_code.epi_code AS VACCINETYPE  
	, case when t_health_epi_outsite.b_epi_outsite_office_id <> '' then t_health_epi_outsite.b_epi_outsite_office_id else '00000' end AS VACCINEPLACE
    ,b_employee.provider as PROVIDER
    ,(case  when length(t_health_epi_outsite.modify_date_time) >= 10
                then case when length(cast(substring(t_health_epi_outsite.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.modify_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_epi_outsite.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.modify_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_epi_outsite.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.modify_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_epi_outsite.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.modify_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_epi_outsite.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.modify_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_epi_outsite.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.modify_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_epi_outsite.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.modify_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_epi_outsite.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.modify_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else '' end
            when length(t_health_epi_outsite.record_date_time) >= 10
                then case when length(cast(substring(t_health_epi_outsite.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.record_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_epi_outsite.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.record_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_epi_outsite.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.record_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_epi_outsite.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.record_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_epi_outsite.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.record_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_epi_outsite.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.record_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_epi_outsite.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.record_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_epi_outsite.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_epi_outsite.record_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end)  as D_UPDATE 




FROM   t_health_epi_outsite
	INNER JOIN b_health_epi_group  ON t_health_epi_outsite.b_health_epi_group_id = b_health_epi_group.b_health_epi_group_id
	INNER JOIN t_health_family  ON t_health_epi_outsite.t_health_family_id = t_health_family.t_health_family_id
	INNER JOIN 
	(select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, health_epi_group_description_particular as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) = 0
and length(health_epi_group_description_particular) = 3
union
select  b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,1,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 7
union
select  b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,5,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 7
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,1,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 11
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,5,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 11
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,9,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 11
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,1,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 15
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,5,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 15
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,9,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 15
union 
select b_health_epi_group_id,  health_epi_group_description, health_epi_group_description_particular, substring(health_epi_group_description_particular,13,3) as epi_code
from b_health_epi_group
where position(':' in health_epi_group_description_particular) > 0
and length(health_epi_group_description_particular) = 15) epi_code
ON epi_code.b_health_epi_group_id = b_health_epi_group.b_health_epi_group_id
LEFT JOIN b_employee
ON t_health_epi_outsite.health_epi_outsite_staff_record = b_employee.b_employee_id 

            left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
            cross join b_site

WHERE  	
        t_health_epi_outsite.epi_outsite_active = '1'
        AND substr((case when t_health_epi_outsite.modify_date_time ='' 
                                    then t_health_epi_outsite.record_date_time
                                    else t_health_epi_outsite.modify_date_time end) ,1,10) between '2559-06-01' and '2560-01-31'   
        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)


