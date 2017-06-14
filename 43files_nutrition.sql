select distinct
    b_site.b_visit_office_id   AS HOSPCODE  
    ,t_health_family.health_family_hn_hcis as PID 
    ,t_visit.visit_vn AS SEQ 	
    , case when t_visit.visit_begin_visit_time is not null
                then (to_number(substring(t_visit.visit_begin_visit_time,1,5),'9999')-543)
                        || substring(t_visit.visit_begin_visit_time,6,2)
                        || substring(t_visit.visit_begin_visit_time,9,2)
              when  t_health_nutrition.nutrition_survey_date is not null and trim(t_health_nutrition.nutrition_survey_date) <> ''
                then (to_number(substring(t_health_nutrition.nutrition_survey_date,1,5),'9999')-543)
                        || substring(t_health_nutrition.nutrition_survey_date,6,2)
                        || substring(t_health_nutrition.nutrition_survey_date,9,2)
               else (to_number(substring(t_health_nutrition.modify_date_time,1,5),'9999')-543)
                        || substring(t_health_nutrition.modify_date_time,6,2)
                        || substring(t_health_nutrition.modify_date_time,9,2)
     end AS DATE_SERV 
     ,t_health_nutrition.b_visit_office_id as NUTRITIONPLACE
    ,case when t_health_nutrition.health_nutrition_weight  ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$'
                    then t_health_nutrition.health_nutrition_weight::decimal(6,1)::text
                    else 0.0::decimal(6,1)::text
                    end as WEIGHT
    ,case when t_health_nutrition.health_nutrition_high ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$'
                then t_health_nutrition.health_nutrition_high::decimal(8,0)::text
                else 0::text end  AS HEIGHT
    ,case when trim(t_health_nutrition.health_nutrition_rim) <> ''
            then (round(t_health_nutrition.health_nutrition_rim::float)::text)
            else '' end as HEADCIRCUM
    ,case when t_health_grow_history.childdevelop is null then '' else t_health_grow_history.childdevelop end as CHILDDEVELOP
    ,t_health_nutrition.food as FOOD
    ,t_health_nutrition.bottle as BOTTLE
    ,b_employee.provider as PROVIDER
    ,(case when length(t_visit.visit_staff_doctor_discharge_date_time) >= 10
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
                                  else ''
                           end
                when length(t_health_nutrition.modify_date_time) >= 10
                then case when length(cast(substring(t_health_nutrition.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_nutrition.modify_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_nutrition.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_nutrition.modify_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_nutrition.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_nutrition.modify_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_nutrition.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_nutrition.modify_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_nutrition.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_nutrition.modify_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_nutrition.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_nutrition.modify_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_nutrition.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_nutrition.modify_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_nutrition.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_nutrition.modify_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end)  as D_UPDATE 

FROM  t_health_nutrition
    INNER JOIN t_visit  ON t_visit.t_visit_id = t_health_nutrition.t_visit_id 
    INNER JOIN t_health_family  ON t_health_nutrition.t_health_family_id = t_health_family.t_health_family_id
    LEFT JOIN t_health_grow_history ON t_visit.t_visit_id = t_health_grow_history.t_visit_id and t_health_grow_history.health_grow_history_active='1'
    LEFT JOIN  b_employee ON t_health_nutrition.health_nutrition_staff_record = b_employee.b_employee_id and b_employee.employee_active='1'

   left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
    cross join b_site

WHERE  
        t_health_nutrition.health_nutrition_active = '1'
        AND t_health_family.health_family_active = '1'
        AND t_visit.f_visit_type_id <> 'S'
        AND t_visit.f_visit_status_id ='3'
        AND t_visit.visit_money_discharge_status='1'
        AND t_visit.visit_doctor_discharge_status='1'
				--and t_health_family.health_family_hn_hcis='077360'
				--AND t_health_grow_history.childdevelop is not null --childdevelop
        AND substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between '2558-09-01' and '2559-09-30'

        and EXTRACT(years FROM age(((substr(t_visit.visit_begin_visit_time,1,4)::int-543)||substr(t_visit.visit_begin_visit_time,5,6))::date
                 ,((substr(t_health_family.patient_birthday,1,4)::int-543)||substr(t_health_family.patient_birthday,5,6))::date)) <= 18

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
