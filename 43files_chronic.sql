select distinct
        b_site.b_visit_office_id as HOSPCODE
        ,t_health_family.health_family_hn_hcis as PID  
        ,max(CASE  
		WHEN length( trim(t_chronic.chronic_diagnosis_date)) >9    
			THEN (to_number(substring(t_chronic.chronic_diagnosis_date,1,4),'9999')-543)       
				|| substring(t_chronic.chronic_diagnosis_date,6,2)       
				|| substring(t_chronic.chronic_diagnosis_date,9,2) 
		ELSE '' END) as DATE_DIAG
        ,replace(t_chronic.chronic_icd10,'.','') as CHRONIC 
        , b_site.b_visit_office_id as HOSP_DX
        , b_site.b_visit_office_id as HOSP_RX
	, max(CASE  WHEN  length( trim(t_chronic.chronic_discharge_date)) >9    
			THEN  (to_number(substring(t_chronic.chronic_discharge_date,1,4),'9999')-543)       
				|| substring(t_chronic.chronic_discharge_date,6,2)       
				|| substring(t_chronic.chronic_discharge_date,9,2) 
		ELSE (to_number(substring(t_chronic.record_date_time,1,4),'9999')-543)       
				|| substring(t_chronic.record_date_time,6,2)       
				|| substring(t_chronic.record_date_time,9,2) 
             END)  as DATE_DISCH
        ,lpad(t_chronic.f_chronic_discharge_status_id,2,'0') as TYPEDISCH
            , MAX(case when length(t_chronic.modify_date_time) >= 10
                then case when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end
                when length(t_chronic.record_date_time) >= 10
                then case when length(cast(substring(t_chronic.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.record_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_chronic.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.record_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_chronic.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.record_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_chronic.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.record_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_chronic.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.record_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_chronic.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.record_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_chronic.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.record_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_chronic.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_chronic.record_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end) D_UPDATE



from 
        (select
                   t_chronic.*
        from t_chronic inner join 
                (select
                        t_chronic.t_patient_id
                        ,t_chronic.chronic_icd10 
                        ,max(t_chronic.record_date_time) as record_date_time
                from t_chronic
                where
                         t_chronic.chronic_active = '1'
                        AND (case when length(t_chronic.modify_date_time) >= 10
                            then substr(t_chronic.modify_date_time,1,10)
                            else substr(t_chronic.record_date_time,1,10)
                            end between ':startDate' and ':endDate' ) 
                         AND (t_chronic.chronic_icd10 ilike 'I10%' OR t_chronic.chronic_icd10 ilike 'E10%' OR
                        t_chronic.chronic_icd10 ilike 'E11%' OR t_chronic.chronic_icd10 ilike 'E12%' OR t_chronic.chronic_icd10 ilike 'E13%' OR
                        t_chronic.chronic_icd10 ilike 'E14%'OR t_chronic.chronic_icd10 ilike 'N18' OR t_chronic.chronic_icd10 ilike 'N18.0' OR 
                        t_chronic.chronic_icd10 ilike 'N18.8' OR t_chronic.chronic_icd10 ilike 'N18.9' )
               
                 group by
                        t_chronic.t_patient_id
                        ,t_chronic.chronic_icd10 ) as max_chronic
         on t_chronic.t_patient_id = max_chronic.t_patient_id
              and t_chronic.chronic_icd10  = max_chronic.chronic_icd10 
              and t_chronic.record_date_time = max_chronic.record_date_time ) as t_chronic

        INNER JOIN t_health_family  ON t_chronic.t_health_family_id = t_health_family.t_health_family_id
        INNER JOIN t_health_home ON t_health_family.t_health_home_id = t_health_home.t_health_home_id
        INNER JOIN t_health_village ON t_health_home.t_health_village_id = t_health_village.t_health_village_id
        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site

WHERE  
        t_health_family.health_family_active = '1'

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

group by
        HOSPCODE
        ,PID  
       -- ,DATE_DIAG
        ,CHRONIC 
        ,HOSP_DX
        ,HOSP_RX
       -- ,DATE_DISCH
        ,TYPEDISCH
       -- ,D_UPDATE

