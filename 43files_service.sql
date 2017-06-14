select 
            b_site.b_visit_office_id as HOSPCODE
            , t_health_family.health_family_hn_hcis as PID 
            , t_patient.patient_hn as HN
            , t_visit.visit_vn as SEQ  
            , substr(t_visit.visit_begin_visit_time,1,4)::int - 543
                    ||substr(t_visit.visit_begin_visit_time,6,2)
                    ||substr(t_visit.visit_begin_visit_time,9,2) as DATE_SERV 
            , replace(substr(t_visit.visit_begin_visit_time,12,8),':','') as TIME_SERV
           	, case when t_patient.f_patient_area_status_id in ('1','2')
                            then '1'   	
                        else '2'   
                       end as  LOCATION
            , case when substr(t_visit.visit_begin_visit_time,12,5) between '08:30' and '16:30' 
                            then '1'
                            else '2' 
                        end    as INTIME
            , r_rp1855_instype.id as INSTYPE
            , t_visit_payment.visit_payment_card_number as INSID
            , case when t_visit_payment.visit_payment_main_hospital <> 'null' and t_visit_payment.visit_payment_main_hospital <> ''
                            then t_visit_payment.visit_payment_main_hospital
                            else ''
                       end as MAIN
            , t_visit.f_visit_service_type_id as TYPEIN
            , max(case when t_visit_refer_in_out.f_visit_refer_type_id = '0' 
                            then t_visit_refer_in_out.visit_refer_in_out_refer_hospital
                            else ''
                        end )as REFERINHOSP
            , max(case when t_visit_refer_in_out.f_visit_refer_type_id = '0' and t_visit.f_refer_cause_id in ('2','3','4','5','6') then '1'  
                        when t_visit_refer_in_out.f_visit_refer_type_id = '0' and t_visit.f_refer_cause_id in ('1') then '2'
                        when t_visit_refer_in_out.f_visit_refer_type_id = '0' and t_visit.f_refer_cause_id in ('7','8') then '5'
                        else '' 
                    end ) as CAUSEIN
            , case when symptom.main_symptom is not null 
                            then substr(symptom.main_symptom,1,255)
                            else '' 
                       end as CHIEFCOMP
            , case when t_visit.service_location in ('1','2')
                            then t_visit.service_location
                        when t_visit_payment.visit_payment_main_hospital = b_site.b_visit_office_id
                            then '1'
                            else '2'
                        end as SERVPLACE
             , case when t_vital_sign.visit_vital_sign_temperature is not null and t_vital_sign.visit_vital_sign_temperature <> ''
                              then t_vital_sign.visit_vital_sign_temperature::decimal(8,1)::text
                              else ''
                            end as BTEMP
             , case when position('/' in t_vital_sign.visit_vital_sign_blood_presure) > 0
                            then substr(t_vital_sign.visit_vital_sign_blood_presure,1,position('/' in t_vital_sign.visit_vital_sign_blood_presure)-1)
                            else ''
                        end as SBP
             , case when position('/' in t_vital_sign.visit_vital_sign_blood_presure) > 0
                            then substr(t_vital_sign.visit_vital_sign_blood_presure,position('/' in t_vital_sign.visit_vital_sign_blood_presure)+1)
                            else ''
                        end as DBP
             , case when t_vital_sign.visit_vital_sign_heart_rate is not null
                            then t_vital_sign.visit_vital_sign_heart_rate
                            else ''
                         end as PR
             , case when t_vital_sign.visit_vital_sign_respiratory_rate is not null 
                            then t_vital_sign.visit_vital_sign_respiratory_rate
                            else ''
                        end as RR
            , case when t_visit.f_visit_opd_discharge_status_id in ('51','53') or t_visit.f_visit_ipd_discharge_type_id in ('1','5') then '1' 
                        when t_visit.f_visit_opd_discharge_status_id in ('54') or t_visit.f_visit_ipd_discharge_type_id in ('4') then '3' 
                        when t_visit.f_visit_opd_discharge_status_id in ('52','56') or t_visit.f_visit_ipd_discharge_type_id in ('8','9') then '4' 
                        when t_visit.f_visit_opd_discharge_status_id in ('55') then '5' 
                        when t_visit.f_visit_ipd_discharge_type_id in ('2') then '7' 
                        when t_visit.f_visit_ipd_discharge_type_id in ('3') then '8' 
                           end  as TYPEOUT
            , max(case when t_visit_refer_in_out.f_visit_refer_type_id = '1' 
                            then t_visit_refer_in_out.visit_refer_in_out_refer_hospital
                            else ''
                        end )as REFEROUTHOSP

            , max(case when t_visit_refer_in_out.f_visit_refer_type_id = '1' and t_visit.f_refer_cause_id in ('2','3','4','5','6') then '1'  
                            when t_visit_refer_in_out.f_visit_refer_type_id = '1' and t_visit.f_refer_cause_id in ('1') then '2'
                            when t_visit_refer_in_out.f_visit_refer_type_id = '1' and t_visit.f_refer_cause_id in ('7','8') then '5'
                            else '' 
                        end) as CAUSEOUT

            , case when service_billing.cost is not null
                            then service_billing.cost::decimal(8,2)
                            else 0
                            end as COST
            , case when service_billing.total is not null
                            then service_billing.total::decimal(8,2)
                            else 0
                            end as PRICE
            , case when service_billing.patient_share is not null
                            then service_billing.patient_share::decimal(8,2)
                            else 0
                            end as PAYPRICE
            , case when service_billing.paid is not null
                            then service_billing.paid::decimal(8,2) 
                            else 0
                            end as ACTUALPAY



              , rpad(substr(t_visit.visit_staff_doctor_discharge_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''),14,'0') as D_UPDATE   
from
        t_visit inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id   
        inner join t_health_family on t_health_family.t_health_family_id = t_patient.t_health_family_id
        inner join t_health_home on t_health_family.t_health_home_id = t_health_home.t_health_home_id
        inner join t_health_village on t_health_home.t_health_village_id = t_health_village.t_health_village_id
        left join t_visit_payment on t_visit.t_visit_id = t_visit_payment.t_visit_id 
                                                and t_visit_payment.visit_payment_priority = '0' 
                                                and t_visit_payment.visit_payment_active = '1'
        left join b_contract_plans on  t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id 
        left join b_map_rp1855_instype on b_contract_plans.b_contract_plans_id = b_map_rp1855_instype.b_contract_plans_id
        left join r_rp1855_instype on b_map_rp1855_instype.r_rp1855_instype_id = r_rp1855_instype.id
        left join t_visit_refer_in_out on t_visit.t_visit_id = t_visit_refer_in_out.t_visit_id

        left join (select
                                t_visit_primary_symptom.t_visit_id as t_visit_id
                                ,array_to_string(array_agg(t_visit_primary_symptom.visit_primary_symptom_main_symptom),' , ') as main_symptom
                        from
                                t_visit_primary_symptom
                        where
                                t_visit_primary_symptom.visit_primary_symptom_active = '1'
                        group by
                                t_visit_primary_symptom.t_visit_id) as symptom
                    on t_visit.t_visit_id = symptom.t_visit_id

         left join (select
                                    t_visit_vital_sign.*
                            from 
                                    t_visit_vital_sign inner join (select
                                                                                        t_visit_vital_sign.t_visit_id as t_visit_id
                                                                                        ,max(case when length(t_visit_vital_sign.visit_vital_sign_modify_date_time) >=10
                                                                                                        then t_visit_vital_sign.visit_vital_sign_modify_date_time
                                                                                                        else t_visit_vital_sign.record_date||','||t_visit_vital_sign.record_time
                                                                                                        end) as vital_sign_date_time
                                                                                from t_visit_vital_sign inner join t_visit on t_visit_vital_sign.t_visit_id = t_visit.t_visit_id
                                                                                where
                                                                                        t_visit_vital_sign.visit_vital_sign_active = '1'
                                                                                        and t_visit.f_visit_status_id ='3'
                                                                                        and t_visit.visit_money_discharge_status ='1'
                                                                                        and t_visit.visit_doctor_discharge_status ='1'
                                                                                        and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate' 
                                                                                group by
                                                                                        t_visit_vital_sign.t_visit_id) as vital_sign
                                                           on t_visit_vital_sign.t_visit_id = vital_sign.t_visit_id
                                                                and (case when length(t_visit_vital_sign.visit_vital_sign_modify_date_time) >=10
                                                                                                        then t_visit_vital_sign.visit_vital_sign_modify_date_time
                                                                                                        else t_visit_vital_sign.record_date||','||t_visit_vital_sign.record_time
                                                                                                        end) = vital_sign.vital_sign_date_time
                                                                and t_visit_vital_sign.visit_vital_sign_active = '1') as t_vital_sign
                            on t_visit.t_visit_id = t_vital_sign.t_visit_id
        left join (select
                                billing.t_visit_id as t_visit_id
                                ,sum(billing.total) as total
                                ,sum(billing.patient_share) as patient_share
                                ,sum(billing.paid) as paid
                                ,sum(billing.cost) as cost
                        from
                                    (select
                                            t_billing.t_visit_id as t_visit_id
                                            ,t_billing.billing_total as total
                                            ,t_billing.billing_patient_share as patient_share
                                            ,t_billing.billing_paid as paid
                                            ,sum(t_billing_invoice_item.billing_invoice_item_total)
                                            ,sum(ceil(t_order.order_qty*t_order.order_price))
                                            ,sum(t_order.order_qty*t_order.order_cost::numeric) as cost
                                    from 
                                            t_visit inner join t_billing on t_visit.t_visit_id = t_billing.t_visit_id
                                            inner join t_billing_invoice on t_billing.t_billing_id = t_billing_invoice.t_billing_id 
                                                                                                    and t_billing_invoice.billing_invoice_active = '1'
                                            left join t_billing_invoice_item on t_billing_invoice.t_billing_invoice_id = t_billing_invoice_item.t_billing_invoice_id 
                                                                                                    and t_billing_invoice_item.billing_invoice_item_active ='1'
                                            left join t_order on t_billing_invoice_item.t_order_item_id = t_order.t_order_id
                                    where
                                            t_billing.billing_active = '1'
                                            and t_order.f_order_status_id not in ('0','3') 
                                            and t_visit.f_visit_status_id ='3'
                                            and t_visit.visit_money_discharge_status ='1'
                                            and t_visit.visit_doctor_discharge_status ='1'
                                            and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate'  
                                    group by
                                            t_billing.t_visit_id
                                            ,t_billing.billing_total
                                            ,t_billing.billing_patient_share
                                            ,t_billing.billing_paid) as billing
                        group by
                                billing.t_visit_id) as service_billing
         on t_visit.t_visit_id = service_billing.t_visit_id

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site
where
        t_health_family.health_family_active = '1'
        and t_visit.f_visit_status_id ='3'
        and t_visit.visit_money_discharge_status ='1'
        and t_visit.visit_doctor_discharge_status ='1'
        and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate' 

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

group by
            HOSPCODE 
            ,PID  
            ,HN
            ,SEQ  
            ,DATE_SERV
            ,TIME_SERV
            ,LOCATION
            ,INTIME
            ,INSTYPE
            ,INSID
            ,MAIN
            ,TYPEIN
        --  ,REFERINHOSP
        --    ,CAUSEIN
            ,CHIEFCOMP
            ,SERVPLACE
            ,BTEMP
            ,SBP
            ,DBP
            ,PR
            ,RR
            ,TYPEOUT
         --   ,REFEROUTHOSP
         --   ,CAUSEOUT
            ,COST
            ,PRICE
            ,PAYPRICE
            ,ACTUALPAY
            ,D_UPDATE

order by t_visit.visit_vn asc