SELECT distinct
        b_site.b_visit_office_id AS HOSPCODE
        ,t_health_family.health_family_hn_hcis AS PID
        ,t_visit.visit_vn AS SEQ
        ,t_health_delivery.gravida_number AS gravida
        ,case when t_health_delivery.health_delivery_born_date <> ''
        then (to_number(substring(t_health_delivery.health_delivery_born_date,1,4),'9999') - 543)
                            || substring(t_health_delivery.health_delivery_born_date,6,2)
                            || substring(t_health_delivery.health_delivery_born_date,9,2)
        else '' end AS BDATE
        , (CASE WHEN (length(t_health_postpartum.update_date_time)>=10)
                then to_char(to_date(to_number(
                substr(t_health_postpartum.update_date_time,1,4),'9999')-543 || 
                substr(t_health_postpartum.update_date_time,5,6),'yyyy-mm-dd'),'yyyymmdd') 
                            ELSE ''   END) AS PPCARE
        ,b_site.b_visit_office_id AS PPPLACE
        ,case when t_health_postpartum.health_postpartum_summary_verify ='1'
        then '1'
        when t_health_postpartum.health_postpartum_summary_verify ='0'
        then '2'
        else '9' end AS PPRESULT
        ,b_employee.provider AS PROVIDER
        ,(case when length(t_health_postpartum.update_date_time) >= 10
                        then case when length(cast(substring(t_health_postpartum.update_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.update_date_time,5),'-',''),',',''),':','')) = 14
                                          then (cast(substring(t_health_postpartum.update_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.update_date_time,5),'-',''),',',''),':',''))
                                          when length(cast(substring(t_health_postpartum.update_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.update_date_time,5),'-',''),',',''),':','')) =12
                                          then (cast(substring(t_health_postpartum.update_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.update_date_time,5),'-',''),',',''),':','')) || '00'
                                          when length(cast(substring(t_health_postpartum.update_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.update_date_time,5),'-',''),',',''),':','')) =10
                                          then (cast(substring(t_health_postpartum.update_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.update_date_time,5),'-',''),',',''),':','')) || '0000'
                                          when length(cast(substring(t_health_postpartum.update_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.update_date_time,5),'-',''),',',''),':','')) = 8
                                          then (cast(substring(t_health_postpartum.update_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.update_date_time,5),'-',''),',',''),':','')) || '000000'
                                          else ''
                                   end
                        when length(t_health_postpartum.record_date_time) >= 10
                        then case when length(cast(substring(t_health_postpartum.record_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.record_date_time,5),'-',''),',',''),':','')) = 14
                                          then (cast(substring(t_health_postpartum.record_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.record_date_time,5),'-',''),',',''),':',''))
                                          when length(cast(substring(t_health_postpartum.record_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.record_date_time,5),'-',''),',',''),':','')) =12
                                          then (cast(substring(t_health_postpartum.record_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.record_date_time,5),'-',''),',',''),':','')) || '00'
                                          when length(cast(substring(t_health_postpartum.record_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.record_date_time,5),'-',''),',',''),':','')) =10
                                          then (cast(substring(t_health_postpartum.record_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.record_date_time,5),'-',''),',',''),':','')) || '0000'
                                          when length(cast(substring(t_health_postpartum.record_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.record_date_time,5),'-',''),',',''),':','')) = 8
                                          then (cast(substring(t_health_postpartum.record_date_time,1,4) as numeric) - 543
                                                        || replace(replace(replace(substring(t_health_postpartum.record_date_time,5),'-',''),',',''),':','')) || '000000'
                                          else ''
                                   end            
                        else ''
               end)  as D_UPDATE 



from 
        t_health_postpartum inner join t_health_family on t_health_postpartum.t_health_family_id = t_health_family.t_health_family_id
        inner join t_health_delivery on t_health_postpartum.t_health_family_id = t_health_delivery.t_health_family_id
                                                and t_health_postpartum.health_postpartum_pregnant_number = t_health_delivery.gravida_number
        inner join t_patient on t_health_postpartum.t_patient_id = t_patient.t_patient_id and t_health_delivery.t_patient_id = t_patient.t_patient_id
        left join  t_visit on t_health_postpartum.t_visit_id = t_visit.t_visit_id
        left JOIN b_employee ON t_health_postpartum.health_postpartum_staff_record = b_employee.b_employee_id 

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site

WHERE 
        t_health_family.health_family_active='1'
        AND t_health_delivery.health_delivery_active='1'
        AND t_health_postpartum.health_postpartum_active='1'
        and (case when length(t_health_postpartum.update_date_time) >= 10
        then substr(t_health_postpartum.update_date_time,1,10)
        else substr(t_health_postpartum.record_date_time,1,10)
        end between ':startDate' and ':endDate'  )

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)