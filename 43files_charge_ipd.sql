select
            b_site.b_visit_office_id as HOSPCODE
            , t_health_family.health_family_hn_hcis as PID 
            , t_visit.visit_vn as AN  
             , rpad(substr(t_visit.visit_begin_admit_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_begin_admit_date_time,5),'-',''),',',''),':',''),14,'0') as DATETIME_ADMIT   

             , case when  b_report_12files_map_clinic.b_report_12files_std_clinic_id in ('1300','1301','1302','1303','1304','1305')
                        then (t_visit.f_visit_type_id || b_report_12files_map_clinic.b_report_12files_std_clinic_id )
                     when  b_report_12files_map_clinic.b_report_12files_std_clinic_id not in ('1300','1301','1302','1303','1304','1305')
                        then (t_visit.f_visit_type_id || b_report_12files_map_clinic.b_report_12files_std_clinic_id || '00' )
                    else '00000' end as WARDSTAY

            , case when b_map_rp1253_charitem.r_rp1253_charitem_id in ('1') then '01'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('2') then '02'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('3') then '03'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('4') then '04'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('5') then '05'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('6') then '06'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('7') then '07'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('8') then '08'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('9') then '09'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('A') then '10'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('B','G') then '11'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('C','H') then '12'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('D') then '13'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('E') then '14'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('F') then '15'
                         when b_map_rp1253_charitem.r_rp1253_charitem_id in ('I','J','K') then '16'
                end as CHARGEITEM

            , case when b_item.item_general_number ='' or b_item.item_general_number is null 
                            then '000000' 
                     else lpad(b_item.item_general_number,6,'0') end as CHARGELIST
            , sum(t_order.order_qty) as QUANTITY
            , r_rp1855_instype.id as INSTYPE 
            , sum(cast(case when t_order.order_cost IS NULL 
                            then '0.00'
                    else t_order.order_cost end as decimal(8,2)))::text as COST
            , cast(sum(ceil(t_order.order_qty*t_order.order_price)) as decimal(8,2))::text as PRICE
            , cast(sum(case when t_billing_receipt_item.billing_receipt_item_paid  is null then 0 
                                        else t_billing_receipt_item.billing_receipt_item_paid  end) as decimal(8,2))::text as PAYPRICE
             , max(rpad(substr(t_billing.billing_billing_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_billing.billing_billing_date_time,5),'-',''),',',''),':',''),14,'0')) as D_UPDATE    

from 
        t_billing inner join t_visit on t_billing.t_visit_id = t_visit.t_visit_id and t_billing.billing_active = '1'
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
        inner join t_health_family on t_health_family.t_health_family_id = t_patient.t_health_family_id
        inner join (select t_diag_icd10.*
                            from t_diag_icd10 inner join 
                                    (select
                                            t_diag_icd10.diag_icd10_vn as diag_icd10_vn
                                            ,max(t_diag_icd10.diag_icd10_record_date_time) as diag_icd10_record_date_time
                                    from t_diag_icd10
                                    where
                                            t_diag_icd10.diag_icd10_active = '1' 
                                            and t_diag_icd10.f_diag_icd10_type_id='1'
                                    group by
                                            t_diag_icd10.diag_icd10_vn) as max_diag_icd10
                                    on  t_diag_icd10.diag_icd10_vn  = max_diag_icd10.diag_icd10_vn
                                        and t_diag_icd10.diag_icd10_record_date_time =  max_diag_icd10.diag_icd10_record_date_time
                            where
                                     t_diag_icd10.diag_icd10_active = '1' 
                                    and t_diag_icd10.f_diag_icd10_type_id='1') as t_diag_icd10 
                         on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn 
        left join b_report_12files_map_clinic  ON t_diag_icd10.b_visit_clinic_id = b_report_12files_map_clinic.b_visit_clinic_id
        inner join t_billing_invoice on t_billing.t_billing_id = t_billing_invoice.t_billing_id and t_billing_invoice.billing_invoice_active = '1'
        left join t_billing_invoice_item on t_billing_invoice.t_billing_invoice_id = t_billing_invoice_item.t_billing_invoice_id  and t_billing_invoice_item.billing_invoice_item_active = '1'
        left join t_order on t_billing_invoice_item.t_order_item_id = t_order.t_order_id and t_order.f_order_status_id not in ('0','3') 
        left join b_item on t_order.b_item_id = b_item.b_item_id
        left join b_map_rp1253_charitem on b_item.b_item_id = b_map_rp1253_charitem.b_item_id
        left join b_item_subgroup on b_item.b_item_subgroup_id = b_item_subgroup.b_item_subgroup_id        
        left join t_billing_receipt_item on t_billing_invoice_item.t_billing_invoice_item_id = t_billing_receipt_item.t_billing_invoice_item_id and t_billing_receipt_item.billing_receipt_item_active = '1'
        left join t_visit_payment on t_billing_invoice_item.t_payment_id = t_visit_payment.t_visit_payment_id
        left join b_contract_plans on  t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id
        left join b_map_rp1855_instype on b_contract_plans.b_contract_plans_id = b_map_rp1855_instype.b_contract_plans_id
        left join r_rp1855_instype on b_map_rp1855_instype.r_rp1855_instype_id = r_rp1855_instype.id 

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site

where
        t_health_family.health_family_active = '1'
        and t_visit.f_visit_status_id ='3'
        and t_visit.visit_money_discharge_status ='1'
        and t_visit.visit_doctor_discharge_status ='1'
        and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate' 
        and t_visit.f_visit_type_id = '1'

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

group by
        HOSPCODE 
        ,PID  
        ,AN
        ,DATETIME_ADMIT
        ,WARDSTAY
        ,CHARGEITEM
        ,CHARGELIST

        ,INSTYPE


order by t_visit.visit_vn asc