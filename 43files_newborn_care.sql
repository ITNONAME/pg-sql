SELECT distinct 
            b_site.b_visit_office_id AS HOSPCODE 
            ,t_health_family.health_family_hn_hcis as PID
            ,t_visit.visit_vn as SEQ
            , CASE WHEN length(t_patient.patient_birthday)>=10
                    THEN   (to_number(substring(t_patient.patient_birthday,1,4),'9999')-543) 
                    ||  substring(t_patient.patient_birthday,6,2) 
                    ||  substring(t_patient.patient_birthday,9,2) 
                ELSE '' END as BDATE
            ,(CASE WHEN (length(t_health_pp_care.pp_care_modify_date_time)>=10 )
                    then to_char(to_date(to_number(
                    substr(t_health_pp_care.pp_care_modify_date_time,1,4),'9999')-543 || 
                    substr(t_health_pp_care.pp_care_modify_date_time,5,6),'yyyy-mm-dd'),'yyyymmdd') 
                    WHEN (length(t_health_pp_care.pp_care_record_date_time)>=10 )
                    then to_char(to_date(to_number(
                    substr(t_health_pp_care.pp_care_record_date_time,1,4),'9999')-543 || 
                    substr(t_health_pp_care.pp_care_record_date_time,5,6),'yyyy-mm-dd'),'yyyymmdd') 
                                ELSE ''   END) AS BCARE
            ,b_site.b_visit_office_id AS BCPLACE
            ,case when t_health_pp_care.pp_care_result='0'
            then '9'
            else t_health_pp_care.pp_care_result end AS BCARERESULT
            ,t_health_pp_care.food as FOOD
            ,b_employee.provider as PROVIDER
            ,(case when length(t_health_pp_care.pp_care_modify_date_time) >= 10
                            then case when length(cast(substring(t_health_pp_care.pp_care_modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_modify_date_time,5),'-',''),',',''),':','')) = 14
                                              then (cast(substring(t_health_pp_care.pp_care_modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_modify_date_time,5),'-',''),',',''),':',''))
                                              when length(cast(substring(t_health_pp_care.pp_care_modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_modify_date_time,5),'-',''),',',''),':','')) =12
                                              then (cast(substring(t_health_pp_care.pp_care_modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_modify_date_time,5),'-',''),',',''),':','')) || '00'
                                              when length(cast(substring(t_health_pp_care.pp_care_modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_modify_date_time,5),'-',''),',',''),':','')) =10
                                              then (cast(substring(t_health_pp_care.pp_care_modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_modify_date_time,5),'-',''),',',''),':','')) || '0000'
                                              when length(cast(substring(t_health_pp_care.pp_care_modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_modify_date_time,5),'-',''),',',''),':','')) = 8
                                              then (cast(substring(t_health_pp_care.pp_care_modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_modify_date_time,5),'-',''),',',''),':','')) || '000000'
                                              else ''
                                       end
                            when length(t_health_pp_care.pp_care_record_date_time) >= 10
                            then case when length(cast(substring(t_health_pp_care.pp_care_record_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_record_date_time,5),'-',''),',',''),':','')) = 14
                                              then (cast(substring(t_health_pp_care.pp_care_record_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_record_date_time,5),'-',''),',',''),':',''))
                                              when length(cast(substring(t_health_pp_care.pp_care_record_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_record_date_time,5),'-',''),',',''),':','')) =12
                                              then (cast(substring(t_health_pp_care.pp_care_record_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_record_date_time,5),'-',''),',',''),':','')) || '00'
                                              when length(cast(substring(t_health_pp_care.pp_care_record_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_record_date_time,5),'-',''),',',''),':','')) =10
                                              then (cast(substring(t_health_pp_care.pp_care_record_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_record_date_time,5),'-',''),',',''),':','')) || '0000'
                                              when length(cast(substring(t_health_pp_care.pp_care_record_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_record_date_time,5),'-',''),',',''),':','')) = 8
                                              then (cast(substring(t_health_pp_care.pp_care_record_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_health_pp_care.pp_care_record_date_time,5),'-',''),',',''),':','')) || '000000'
                                              else ''
                                       end            
                            else ''
                   end)  as D_UPDATE 

FROM t_health_pp_care 
        INNER JOIN t_health_family ON t_health_family.t_health_family_id = t_health_pp_care.t_health_family_id
        INNER JOIN t_patient on t_health_family.t_health_family_id = t_patient.t_health_family_id
        LEFT JOIN t_visit ON t_health_pp_care.t_visit_id = t_visit.t_visit_id 
                            AND t_visit.f_visit_status_id <> '4'
        LEFT JOIN b_employee ON t_health_pp_care.pp_care_staff_record = b_employee.b_employee_id
        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site

WHERE  
        t_health_pp_care.pp_care_active  = '1' 
        AND t_health_family.health_family_active='1' 
        AND  (case when length(t_health_pp_care.pp_care_modify_date_time) >= 10
        then substr(t_health_pp_care.pp_care_modify_date_time,1,10)
        else substr(t_health_pp_care.pp_care_record_date_time,1,10)
        end between ':startDate' and ':endDate' )

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

