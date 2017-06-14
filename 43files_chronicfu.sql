select distinct
        b_site.b_visit_office_id as HOSPCODE
        ,t_health_family.health_family_hn_hcis as  PID
        ,t_visit.visit_vn as SEQ
        ,case when t_visit.visit_begin_visit_time <> ''
                then (to_number(substring(t_visit.visit_begin_visit_time,1,4),'9999')-543)       
                            || substring(t_visit.visit_begin_visit_time,6,2)       
                            || substring(t_visit.visit_begin_visit_time,9,2) 
                else '' end as DATE_SERV
        ,case when t_visit_vital_sign.visit_vital_sign_weight = '' 
                    then '0'
                    else t_visit_vital_sign.visit_vital_sign_weight end::decimal(8,1)::text  as WEIGHT 
        ,case when t_visit_vital_sign.visit_vital_sign_height = '' 
                    then '0'
                    else t_visit_vital_sign.visit_vital_sign_height end::decimal(8,0)::text   as "HEIGHT" 
        ,case when t_visit_vital_sign.visit_vital_sign_waistline =''
                    then '0'
                    else t_visit_vital_sign.visit_vital_sign_waistline end::decimal(8,0)::text as WAIST_CM 
        ,case when position('/'in t_visit_vital_sign.visit_vital_sign_blood_presure) > 0 
                   then  substr(t_visit_vital_sign.visit_vital_sign_blood_presure,1,position('/'in t_visit_vital_sign.visit_vital_sign_blood_presure)-1)
                    else '0' end as SBP
        ,case when position('/'in t_visit_vital_sign.visit_vital_sign_blood_presure) > 0 
                   then  substr(t_visit_vital_sign.visit_vital_sign_blood_presure,position('/'in t_visit_vital_sign.visit_vital_sign_blood_presure)+1)
                    else '0' end as DBP

        ,case when ncd_screen.foot is null
                    then '9'
                    else ncd_screen.foot end  as FOOT
        ,case when ncd_screen.retina is null
                    then '9'
                    else ncd_screen.retina end as RETINA

        ,b_employee.provider  as PROVIDER
        ,rpad(substr(t_visit.visit_staff_doctor_discharge_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''),14,'0') as D_UPDATE

from  
        (select distinct 
                t_chronic.t_patient_id as t_patient_id
        from t_chronic
        where
                t_chronic.chronic_active = '1'
				 AND (t_chronic.chronic_icd10 ilike 'I10%' OR t_chronic.chronic_icd10 ilike 'E10%' OR
                        t_chronic.chronic_icd10 ilike 'E11%' OR t_chronic.chronic_icd10 ilike 'E12%' OR t_chronic.chronic_icd10 ilike 'E13%' OR
                        t_chronic.chronic_icd10 ilike 'E14%'OR t_chronic.chronic_icd10 ilike 'N18' OR t_chronic.chronic_icd10 ilike 'N18.0' OR 
                        t_chronic.chronic_icd10 ilike 'N18.8' OR t_chronic.chronic_icd10 ilike 'N18.9' )) as t_chronic 
        inner join t_patient on t_chronic.t_patient_id = t_patient.t_patient_id
        inner join t_visit on t_visit.t_patient_id = t_patient.t_patient_id
        inner join t_health_family on t_patient.t_health_family_id = t_health_family.t_health_family_id

        inner join (select t_visit_vital_sign.*
                            from t_visit_vital_sign 
                                    inner join (select 
                                                            t_visit_vital_sign.t_visit_id as t_visit_id
                                                            ,max(t_visit_vital_sign.record_date ||','|| t_visit_vital_sign.record_time) AS record_datetime
                                                    from
                                                            t_visit inner join t_visit_vital_sign on t_visit.t_visit_id=t_visit_vital_sign.t_visit_id
                                                    where 
                                                            t_visit.f_visit_type_id <> 'S' 
                                                            and t_visit.f_visit_status_id ='3'
                                                            and t_visit.visit_money_discharge_status='1'
                                                            and t_visit.visit_doctor_discharge_status='1' 	
                                                            and substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate'  

                                                            and t_visit_vital_sign.visit_vital_sign_weight <> ''
                                                            and t_visit_vital_sign.visit_vital_sign_height <> ''
                                                            and t_visit_vital_sign.visit_vital_sign_waistline <> ''
                                                            and t_visit_vital_sign.visit_vital_sign_blood_presure <> ''                                                            

                                                    group by t_visit_vital_sign.t_visit_id) as max_vital_sign 
                                     on t_visit_vital_sign.t_visit_id = max_vital_sign.t_visit_id
                                        and t_visit_vital_sign.record_date ||','|| t_visit_vital_sign.record_time = max_vital_sign.record_datetime) as t_visit_vital_sign
                on t_visit.t_visit_id = t_visit_vital_sign.t_visit_id

        left join (select
                            t_visit.t_visit_id
                            ,max(case when t_ncd_disease_complications.f_ncd_disease_complications_id = '3' then 
                                       (case when t_ncd_disease_complications.screen_disease_complications='1' 
                                                  and t_ncd_foot_result.f_ncd_foot_screen_result_id in ('1','2')
                                            then  '1'
                                        when t_ncd_disease_complications.screen_disease_complications='1' 
                                                and t_ncd_foot_result.f_ncd_foot_screen_result_id in ('3','4','5')
                                            then  '3'
                                        when t_ncd_disease_complications.screen_disease_complications='1' 
                                                 and t_ncd_foot_result.f_ncd_foot_screen_result_id ='9'
                                            then  '2'
                                            else '9' end)
                                            end) as FOOT

                            ,max(case when t_ncd_disease_complications.f_ncd_disease_complications_id = '1' then 
                                          (case when t_ncd_eyes_complications.method_eye_exam = '1' 
                                                    and t_ncd_eyes_complications.result_eye_exam='1'
                                                then  '1'
                                            when t_ncd_eyes_complications.method_eye_exam = '2' 
                                                    and t_ncd_eyes_complications.result_eye_exam='1'
                                                then  '2'
                                            when t_ncd_eyes_complications.method_eye_exam = '1' 
                                                    and t_ncd_eyes_complications.result_eye_exam='2'
                                                then  '3'
                                            when t_ncd_eyes_complications.method_eye_exam = '2' 
                                                    and t_ncd_eyes_complications.result_eye_exam='2'
                                                then  '4'
                                            when t_ncd_eyes_complications.method_eye_exam = '8' 
                                                then  '8'
                                                else '9' end) 
                                                end) as RETINA

                                  ,t_ncd_screen_disease_complications.user_record_id as user_record_id

                from t_visit        
                         inner join (select t_ncd_screen_disease_complications.*
                                            from t_ncd_screen_disease_complications 
                                         inner join (select
                                                t_ncd_screen_disease_complications.t_visit_id as t_visit_id
                                                ,max(t_ncd_screen_disease_complications.screen_date_time) as screen_date_time
                                        from t_ncd_screen_disease_complications
                                        where
                                                t_ncd_screen_disease_complications.active = '1'
                                        group by
                                                 t_ncd_screen_disease_complications.t_visit_id) as max_ncd_screen
                         on t_ncd_screen_disease_complications.t_visit_id = max_ncd_screen.t_visit_id
                            and t_ncd_screen_disease_complications.screen_date_time = max_ncd_screen.screen_date_time) as t_ncd_screen_disease_complications  on t_visit.t_visit_id = t_ncd_screen_disease_complications.t_visit_id
                                                                                           and t_ncd_screen_disease_complications.active = '1'
                        inner join t_ncd_disease_complications on t_ncd_screen_disease_complications.t_ncd_screen_disease_complications_id = t_ncd_disease_complications.t_ncd_screen_disease_complications_id
                                                                                            and t_ncd_disease_complications.f_ncd_disease_complications_id in ('1','3')
                                                                                            and t_ncd_disease_complications.screen_disease_complications = '1' 
                        left join t_ncd_foot_complications on t_ncd_disease_complications.t_ncd_disease_complications_id = t_ncd_foot_complications.t_ncd_disease_complications_id
                                                                                            and t_ncd_foot_complications.active = '1'
                        left join t_ncd_foot_result on t_ncd_foot_complications.t_ncd_foot_complications_id = t_ncd_foot_result.t_ncd_foot_complications_id
                        left join t_ncd_eyes_complications  on t_ncd_disease_complications.t_ncd_disease_complications_id = t_ncd_eyes_complications.t_ncd_disease_complications_id
                                                                                            and t_ncd_eyes_complications.active ='1'


                    where
                            t_visit.f_visit_type_id <> 'S' 
                            and t_visit.f_visit_status_id ='3'
                            and t_visit.visit_money_discharge_status='1'
                            and t_visit.visit_doctor_discharge_status='1' 	
                            and substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate'  
                group by
                            t_visit.t_visit_id 
                            ,t_ncd_screen_disease_complications.user_record_id) as ncd_screen
                on t_visit.t_visit_id = ncd_screen.t_visit_id

        left join b_employee on (case when ncd_screen.user_record_id is null
                                                        then t_visit_vital_sign.visit_vital_sign_staff_record
                                                        else ncd_screen.user_record_id end) = b_employee.b_employee_id 

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site
        
where
        t_visit.f_visit_type_id <> 'S' 
        and t_visit.f_visit_status_id ='3'
        and t_visit.visit_money_discharge_status='1'
        and t_visit.visit_doctor_discharge_status='1' 	
        and substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate'  
 
        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)


