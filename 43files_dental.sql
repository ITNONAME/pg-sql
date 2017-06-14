select distinct
b_site.b_visit_office_id as HOSPCODE
,t_health_family.health_family_hn_hcis as PID
,t_visit.visit_vn as SEQ
, (to_number(substring(t_visit.visit_begin_visit_time,1,4),'9999')-543)        			
		|| substring(t_visit.visit_begin_visit_time,6,2)       		
		|| substring(t_visit.visit_begin_visit_time,9,2) as	DATE_SERV  
,t_health_dental.f_dent_type_id as DENTTYPE
,case when t_visit.service_location='2'
then '2'
else '1' end SERVPLACE
,t_health_dental.dental_num_tooth as PTEETH
,t_health_dental.dental_num_bad_tooth as PCARIES
,t_health_dental.pfilling as PFILLING
,t_health_dental.pextract as PEXTRACT
,t_health_dental.dental_num_milktooth as DTEETH
,t_health_dental.dental_num_bad_milktooth as DCARIES
,t_health_dental.dfilling as DFILLING
,t_health_dental.dextract as DEXTRACT
,t_health_dental.need_fluoride as NEED_FLUORIDE
,t_health_dental.need_scaling as NEED_SCALING
,t_health_dental.need_sealant as NEED_SEALANT
,t_health_dental.need_pfilling as NEED_PFILLING
,t_health_dental.need_dfilling as NEED_DFILLING
,t_health_dental.need_pextract as NEED_PEXTRACT
,t_health_dental.need_dextract as NEED_DEXTRACT
,t_health_dental.nprosthesis as NPROSTHESIS
,t_health_dental.permanent_perma as PERMANENT_PERMA
,t_health_dental.permanent_prost as PERMANENT_PROST
,t_health_dental.prosthesis_prost as PROSTHESIS_PROST
,t_health_dental.gum_id as GUM
,case when t_health_dental.f_dent_type_id='3'
then  t_health_dental.f_school_type_id else '' end as SCHOOLTYPE
,t_health_dental.school_class as "CLASS"
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
             when length(t_health_dental.dental_modify_time) >= 10
                then case when length(cast(substring(t_health_dental.dental_modify_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_dental.dental_modify_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_dental.dental_modify_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_dental.dental_modify_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_dental.dental_modify_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_dental.dental_modify_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_dental.dental_modify_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_dental.dental_modify_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_dental.dental_modify_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_dental.dental_modify_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_dental.dental_modify_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_dental.dental_modify_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_dental.dental_modify_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_dental.dental_modify_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_dental.dental_modify_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_dental.dental_modify_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end)  as D_UPDATE 






from 
        t_health_dental inner join t_visit on t_health_dental.t_visit_id = t_visit.t_visit_id
        inner join t_health_family on t_health_dental.t_health_family_id = t_health_family.t_health_family_id
        left join b_employee on t_health_dental.dental_staff_record = b_employee.b_employee_id 

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site
where 
    t_health_dental.dental_active='1'
    and t_visit.f_visit_status_id <> '4'
    and t_health_family.health_family_active='1'
    AND t_visit.f_visit_type_id <> 'S'
    AND t_visit.visit_money_discharge_status='1'
    AND t_visit.visit_doctor_discharge_status='1' 				
    AND substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate'

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
