select 
            b_site.b_visit_office_id as HOSPCODE
            , t_health_family.health_family_hn_hcis as PID  
            , r_rp1853_instype.id as INSTYPE_OLD
            , r_rp1855_instype.id as INSTYPE_NEW
            , t_patient_payment.patient_payment_card_number as INSID
            , (case when length(t_patient_payment.patient_payment_card_issue_date) > 9
                            then substr(t_patient_payment.patient_payment_card_issue_date,1,4)::int -543
                                                ||replace(substr(t_patient_payment.patient_payment_card_issue_date,5,6),'-','')
                            else ''
                      end) as STARTDATE
            , (case when length(t_patient_payment.patient_payment_card_expire_date) > 9
                            then substr(t_patient_payment.patient_payment_card_expire_date,1,4)::int -543
                                                ||replace(substr(t_patient_payment.patient_payment_card_expire_date,5,6),'-','')
                            else ''
                       end) as EXPIREDATE
            , case when t_patient_payment.patient_payment_main_hospital <> 'null' 
                                and t_patient_payment.patient_payment_main_hospital <> ''
                                and length(t_patient_payment.patient_payment_main_hospital) = 5
                            then t_patient_payment.patient_payment_main_hospital
                            else ''
                       end as MAIN
            , case when t_patient_payment.patient_payment_sub_hospital <> 'null' 
                                and t_patient_payment.patient_payment_sub_hospital <> ''
                                and length(t_patient_payment.patient_payment_sub_hospital) = 5
                            then t_patient_payment.patient_payment_sub_hospital
                            else ''
                       end as SUB
            , (rpad(substr(t_patient_payment.patient_payment_record_date,1,4)::int -543
                                                ||replace(replace(replace(substr(t_patient_payment.patient_payment_record_date,5),'-',''),',',''),':',''),14,'0'))  as D_UPDATE 


from
        (select 
                     t_patient_payment.*
        from t_patient_payment inner join 
                                            (select
                                                    t_patient_payment.t_patient_id as t_patient_id
                                                    ,min(t_patient_payment.b_contact_plans_id) as min_b_contact_plans_id
                                                    ,max_payment_record_date.patient_payment_record_date as patient_payment_record_date
                                                    ,max_payment_record_date.checkplan_date as checkplan_date
                                              from t_patient_payment inner join 
                                                                                (select 
                                                                                        t_patient_payment.t_patient_id as t_patient_id
                                                                                        ,max(t_patient_payment.patient_payment_record_date) as patient_payment_record_date
                                                                                        ,max_checkplan_date.checkplan_date as checkplan_date
                                                                                 from t_patient_payment inner join 
                                                                                                                        (select  
                                                                                                                                t_patient_payment.t_patient_id as t_patient_id                                                                                                                                
                                                                                                                                ,max(t_patient_payment.checkplan_date) as checkplan_date
                                                                                                                            from t_patient_payment
                                                                                                                            where
                                                                                                                                    t_patient_payment.patient_payment_priority = '0'                                                                                                                                    
                                                                                                                            group by
                                                                                                                                    t_patient_payment.t_patient_id) as max_checkplan_date
                                                                                                                                                     on t_patient_payment.t_patient_id = max_checkplan_date.t_patient_id
                                                                                                                                                    and t_patient_payment.checkplan_date = max_checkplan_date.checkplan_date
                                                                                                                     
                                                                                where
                                                                                            t_patient_payment.patient_payment_priority = '0'             
                                                                                group by
                                                                                            t_patient_payment.t_patient_id 
                                                                                            ,max_checkplan_date.checkplan_date) as max_payment_record_date
                                                                                                                    on t_patient_payment.t_patient_id = max_payment_record_date.t_patient_id
                                                                                                                        and t_patient_payment.patient_payment_record_date = max_payment_record_date.patient_payment_record_date
                                                                                                                        and t_patient_payment.checkplan_date = max_payment_record_date.checkplan_date
                                                    where
                                                                t_patient_payment.patient_payment_priority = '0'
                                                    group by
                                                                t_patient_payment.t_patient_id
                                                                ,max_payment_record_date.patient_payment_record_date
                                                                ,max_payment_record_date.checkplan_date  ) as min_b_contact_plans
                                                                                    on 
                                                                                        t_patient_payment.t_patient_id = min_b_contact_plans.t_patient_id
                                                                                        and t_patient_payment.patient_payment_record_date = min_b_contact_plans.patient_payment_record_date
                                                                                        and t_patient_payment.checkplan_date = min_b_contact_plans.checkplan_date
                                                                                        and t_patient_payment.b_contact_plans_id = min_b_contact_plans.min_b_contact_plans_id) as t_patient_payment
 
        inner join t_patient on t_patient_payment.t_patient_id = t_patient.t_patient_id   
        inner join t_health_family on t_health_family.t_health_family_id = t_patient.t_health_family_id
        left join b_contract_plans on  t_patient_payment.b_contact_plans_id = b_contract_plans.b_contract_plans_id
        left join b_map_rp1853_instype on b_contract_plans.b_contract_plans_id = b_map_rp1853_instype.b_contract_plans_id
        left join r_rp1853_instype on b_map_rp1853_instype.r_rp1853_instype_id =  r_rp1853_instype.id
        left join b_map_rp1855_instype on b_contract_plans.b_contract_plans_id = b_map_rp1855_instype.b_contract_plans_id
        left join r_rp1855_instype on b_map_rp1855_instype.r_rp1855_instype_id = r_rp1855_instype.id

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'       

        cross join b_site
where
        t_health_family.health_family_active = '1'
        and t_patient_payment.patient_payment_priority = '0'
        and substr(t_patient_payment.patient_payment_record_date,1,10)  between ':startDate' and ':endDate'  

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
 group by
        HOSPCODE
        ,PID
        ,INSTYPE_OLD
        ,INSTYPE_NEW
        ,INSID
        ,STARTDATE
        ,EXPIREDATE
        ,MAIN
        ,SUB
        ,D_UPDATE 


order by
            PID asc
