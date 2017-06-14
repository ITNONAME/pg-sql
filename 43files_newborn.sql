SELECT distinct 
            b_site.b_visit_office_id AS HOSPCODE 
            , t_health_family.health_family_hn_hcis as PID 
            ,mother.health_family_hn_hcis AS MPID 
            , t_health_pp.pp_gravida AS GRAVIDA 
            ,(t_health_pp.pp_gestational_age_week::int)::text AS GA
            , CASE WHEN length(t_health_delivery.health_delivery_born_date)>9
                            THEN   (to_number(substring(t_health_delivery.health_delivery_born_date,1,4),'9999')-543) 
                            ||  substring(t_health_delivery.health_delivery_born_date,6,2) 
                            ||  substring(t_health_delivery.health_delivery_born_date,9,2) 
                        ELSE '' END as BDATE
            ,  case when t_health_delivery.health_delivery_born_time <> ''
                            then replace(t_health_delivery.health_delivery_born_time,':','')|| '00' 
                           else '' end as BTIME

            , t_health_delivery.f_health_postpartum_birth_place_id as BPLACE
            , t_health_delivery.b_visit_office_birth_place as BHOSP
            , t_health_pp.pp_number  AS BIRTHNO
            , CASE WHEN (t_health_delivery.f_health_birth_method_id='1'
                    OR t_health_delivery.f_health_birth_method_id='2'
                    OR t_health_delivery.f_health_birth_method_id='3'
                    OR t_health_delivery.f_health_birth_method_id='4'
                    OR t_health_delivery.f_health_birth_method_id='5')
                THEN t_health_delivery.f_health_birth_method_id 
                    ELSE '' END AS   BTYPE
            , CASE WHEN (t_health_delivery.f_health_pregnancy_birth_doctor_type_id='1'
                    OR t_health_delivery.f_health_pregnancy_birth_doctor_type_id='2'
                    OR t_health_delivery.f_health_pregnancy_birth_doctor_type_id='3'
                    OR t_health_delivery.f_health_pregnancy_birth_doctor_type_id='4'
                    OR t_health_delivery.f_health_pregnancy_birth_doctor_type_id='5')
                THEN t_health_delivery.f_health_pregnancy_birth_doctor_type_id 
                    ELSE '6' END   as  BDOCTOR  
            , t_health_pp.pp_weight AS BWEIGHT
            , CASE WHEN (t_health_pp.pp_lost_oxygen= '0') THEN '1'
                        WHEN (t_health_pp.pp_lost_oxygen = '1')  THEN '2'
                        ELSE '9' END AS ASPHYXIA
            , case when t_health_pp.pp_vit_k ='0'  then '2'
                        when t_health_pp.pp_vit_k ='1'  then '1'
                        else '9' end AS VITK
            ,t_health_pp.tsh as TSH
            ,t_health_pp.tshresult as TSHRESULT
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


FROM   (select 
                    t_health_pp.* 
              from t_health_pp inner join (select
                                                                    t_health_pp.t_patient_id as t_patient_id
                                                                    ,max(case when t_health_pp.pp_modify_date_time <> ''
                                                                                        then t_health_pp.pp_modify_date_time
                                                                                        else t_health_pp.pp_record_date_time
                                                                                        end)  as update_date_time

                                                            from t_health_pp 
                                                            where 
                                                                    t_health_pp.pp_active = '1'
                                                            group by
                                                                    t_health_pp.t_patient_id) as max_health_pp
                                           on  t_health_pp.t_patient_id =  max_health_pp.t_patient_id
                                                    and (case when t_health_pp.pp_modify_date_time <> ''
                                                                                        then t_health_pp.pp_modify_date_time
                                                                                        else t_health_pp.pp_record_date_time
                                                                                        end) = max_health_pp.update_date_time ) as t_health_pp
            INNER JOIN t_patient  ON t_health_pp.t_patient_id = t_patient.t_patient_id
            INNER JOIN t_health_family  AS mother  ON (mother.t_health_family_id = t_patient.t_health_family_id)
            INNER JOIN t_health_family ON t_health_family.t_health_family_id = t_health_pp.t_health_family_id
            INNER JOIN (select 
                                        t_health_delivery.*
                                from t_health_delivery inner join (select
                                                                                            t_health_delivery.t_health_family_id as t_health_family_id
                                                                                            ,t_health_delivery.gravida_number as gravida_number
                                                                                            ,max(case when t_health_delivery.update_date_time <> ''
                                                                                                            then t_health_delivery.update_date_time
                                                                                                            else t_health_delivery.record_date_time
                                                                                                            end)  as update_date_time
                                                                                    from t_health_delivery
                                                                                    where
                                                                                            t_health_delivery.health_delivery_active = '1'                                                                                            
                                                                                    group by
                                                                                            t_health_delivery.t_health_family_id
                                                                                            ,t_health_delivery.gravida_number) as max_delivery
                                                                 on t_health_delivery.t_health_family_id = max_delivery.t_health_family_id
                                                                      and t_health_delivery.gravida_number = max_delivery.gravida_number
                                                                      and (case when t_health_delivery.update_date_time <> ''
                                                                                                            then t_health_delivery.update_date_time
                                                                                                            else t_health_delivery.record_date_time
                                                                                                            end)  =  max_delivery.update_date_time ) as t_health_delivery
                            
                 ON (mother.t_health_family_id = t_health_delivery.t_health_family_id
                AND t_health_pp.pp_gravida = t_health_delivery.gravida_number
                AND t_health_delivery.health_delivery_active = '1')

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site

WHERE   
        mother.health_family_active = '1'
        and t_health_family.health_family_active = '1'
        and t_health_pp.pp_active = '1'
        and (case when length(t_health_delivery.update_date_time) >= 10
                                then substr(t_health_delivery.update_date_time,1,10)
                                else substr(t_health_delivery.record_date_time,1,10)
                                end between ':startDate' and ':endDate' )  

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

