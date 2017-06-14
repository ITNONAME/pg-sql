select distinct
b_site.b_visit_office_id as HOSPCODE
,t_health_family.health_family_hn_hcis as PID
,t_health_pregnancy.health_pregnancy_gravida_number as GRAVIDA
, case when t_health_pregnancy.health_pregnancy_menses_issue_date is not null
                then (to_number(substring(t_health_pregnancy.health_pregnancy_menses_issue_date,1,5),'9999')-543)
                        || substring(t_health_pregnancy.health_pregnancy_menses_issue_date,6,2)
                        || substring(t_health_pregnancy.health_pregnancy_menses_issue_date,9,2)

end AS LMP
, case when t_health_pregnancy.health_pregnancy_menses_expire_date is not null
                then (to_number(substring(t_health_pregnancy.health_pregnancy_menses_expire_date,1,5),'9999')-543)
                        || substring(t_health_pregnancy.health_pregnancy_menses_expire_date,6,2)
                        || substring(t_health_pregnancy.health_pregnancy_menses_expire_date,9,2)

end AS EDC
, CASE WHEN (length(t_health_delivery.health_delivery_born_date)>=10)
                then to_char(to_date(to_number(
                substr(t_health_delivery.health_delivery_born_date,1,4),'9999')-543 || 
                substr(t_health_delivery.health_delivery_born_date,5,6),'yyyy-mm-dd'),'yyyymmdd') 
                ELSE '' END AS BDATE 
	, b_icd10.icd10_number AS BRESULT 
	, t_health_delivery.f_health_postpartum_birth_place_id AS BPLACE  
	, t_health_delivery.b_visit_office_birth_place AS BHOSP  
	, CASE  WHEN (t_health_delivery.f_health_birth_method_id = '1'         
			OR  t_health_delivery.f_health_birth_method_id = '2'        
			OR  t_health_delivery.f_health_birth_method_id = '3'       
			OR  t_health_delivery.f_health_birth_method_id = '4'       
			OR  t_health_delivery.f_health_birth_method_id = '5'
			OR  t_health_delivery.f_health_birth_method_id = '6')       
			THEN t_health_delivery.f_health_birth_method_id   
		ELSE '' END AS BTYPE 
	, t_health_delivery.f_health_pregnancy_birth_doctor_type_id AS BDOCTOR  
	, CASE WHEN (t_health_delivery.health_delivery_parity is null or t_health_delivery.health_delivery_parity='') THEN '0'
            ELSE t_health_delivery.health_delivery_parity END AS LBORN
	, CASE WHEN (t_health_delivery.health_delivery_stillborn is null or t_health_delivery.health_delivery_stillborn='') THEN '0'
            ELSE t_health_delivery.health_delivery_stillborn END AS SBORN
,(case when length(t_health_delivery.update_date_time) >= 10
                then case when length(cast(substring(t_health_delivery.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.update_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_delivery.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.update_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_delivery.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.update_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_delivery.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.update_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_delivery.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.update_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_delivery.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.update_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_delivery.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.update_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_delivery.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.update_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end
                when length(t_health_delivery.record_date_time) >= 10
                then case when length(cast(substring(t_health_delivery.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.record_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_delivery.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.record_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_delivery.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.record_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_delivery.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.record_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_delivery.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.record_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_delivery.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.record_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_delivery.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.record_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_delivery.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_delivery.record_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end)  as D_UPDATE 



from 
        t_health_delivery 
        inner join t_health_family on t_health_delivery.t_health_family_id = t_health_family.t_health_family_id
        left join t_health_pregnancy on t_health_pregnancy.t_health_family_id = t_health_family.t_health_family_id and t_health_pregnancy.health_pregnancy_active='1'
        left join b_icd10 on t_health_delivery.b_icd10_id = b_icd10.b_icd10_id 
        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site

where
        t_health_family.health_family_active='1'
        and t_health_delivery.health_delivery_active='1'
        and t_health_delivery.gravida_number = t_health_pregnancy.health_pregnancy_gravida_number
        and (case when length(t_health_delivery.update_date_time) >= 10
        then substr(t_health_delivery.update_date_time,1,10)
        else substr(t_health_delivery.record_date_time,1,10)
        end between '2558-10-01' and '2559-09-30' )

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)


