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

            , case when t_order.order_home = '0' then '1'
                     when t_order.order_home = '1' then '2' end as TYPEDRUG

            , substr(b_nhso_map_drug.f_nhso_drug_id,1,24) as DIDSTD 
            , b_item.item_common_name as DNAME

            , '' as DATESTART
            , '' as DATEFINISH

            , sum(cast(t_order.order_qty as decimal(8,2))) AS AMOUNT 
            , case when b_map_rp4356_drug_unit.r_rp4356_drug_unit_id is not null
                        then b_map_rp4356_drug_unit.r_rp4356_drug_unit_id
                        else ''
                        end as UNIT
            , case when b_item_drug_uom.b_item_drug_uom_id in ('2520000000025','2520000000009')
                            then '1'
                    when (b_item.item_unit_packing_qty ='' OR b_item.item_unit_packing_qty IS NULL)
                            then NULL
                    else b_item.item_unit_packing_qty end as UNIT_PACKING
           , (t_order.order_price::decimal(8,2)) as DRUGPRICE
            , case when t_order.order_cost IS NULL 
                            then '0.00'
                    else cast(t_order.order_cost as decimal(8,2)) end as DRUGCOST

             , max(case when t_order.order_dispense_date_time <> '' and t_order.order_dispense_date_time >= t_order_drug.order_drug_modify_datetime
                              then staff_dispense.provider
                      when t_order.order_dispense_date_time <> '' and t_order.order_dispense_date_time < t_order_drug.order_drug_modify_datetime
                              then staff_modifier.provider
                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time <> '' 
                                    and t_order.order_executed_date_time >= t_order.order_verify_date_time
                              then staff_execute.provider
                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time <> '' 
                                    and t_order.order_executed_date_time < t_order_drug.order_drug_modify_datetime
                              then staff_modifier.provider
                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time = '' 
                                    and t_order.order_verify_date_time >= t_order_drug.order_drug_modify_datetime
                              then staff_verify.provider 
                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time = '' 
                                    and t_order.order_verify_date_time < t_order_drug.order_drug_modify_datetime
                              then staff_modifier.provider  end ) as PROVIDER

            , max(case when t_order.order_dispense_date_time <> '' and t_order.order_dispense_date_time >= t_order_drug.order_drug_modify_datetime
                              then rpad(substr(t_order.order_dispense_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order.order_dispense_date_time,5),'-',''),',',''),':',''),14,'0')

                      when t_order.order_dispense_date_time <> '' and t_order.order_dispense_date_time < t_order_drug.order_drug_modify_datetime
                              then rpad(substr(t_order_drug.order_drug_modify_datetime,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order_drug.order_drug_modify_datetime,5),'-',''),',',''),':',''),14,'0')

                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time <> '' 
                                    and t_order.order_executed_date_time >= t_order.order_verify_date_time
                              then rpad(substr(t_order.order_executed_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order.order_executed_date_time,5),'-',''),',',''),':',''),14,'0')

                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time <> '' 
                                    and t_order.order_executed_date_time < t_order_drug.order_drug_modify_datetime
                              then rpad(substr(t_order_drug.order_drug_modify_datetime,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order_drug.order_drug_modify_datetime,5),'-',''),',',''),':',''),14,'0')

                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time = '' 
                                    and t_order.order_verify_date_time >= t_order_drug.order_drug_modify_datetime
                              then rpad(substr(t_order.order_verify_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order.order_verify_date_time,5),'-',''),',',''),':',''),14,'0')

                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time = '' 
                                    and t_order.order_verify_date_time < t_order_drug.order_drug_modify_datetime
                              then rpad(substr(t_order_drug.order_drug_modify_datetime,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order_drug.order_drug_modify_datetime,5),'-',''),',',''),':',''),14,'0') end) as D_UPDATE 
    
from t_order inner join t_visit on t_visit.t_visit_id = t_order.t_visit_id  
                                                and t_order.f_order_status_id not in ('0','3') 
                                                and t_order.f_item_group_id = '1'
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id   
        inner join t_health_family on t_health_family.t_health_family_id = t_patient.t_health_family_id
        inner join b_item on b_item.b_item_id = t_order.b_item_id 
        left join b_nhso_map_drug on t_order.b_item_id = b_nhso_map_drug.b_item_id
        inner join t_order_drug on t_order.t_order_id=t_order_drug.t_order_id 
        left join b_item_drug_uom on t_order_drug.b_item_drug_uom_id_purch=b_item_drug_uom.b_item_drug_uom_id
        left join b_map_rp4356_drug_unit on b_item_drug_uom.b_item_drug_uom_id = b_map_rp4356_drug_unit.b_item_drug_uom_id

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

        left join b_employee as staff_dispense on t_order.order_staff_dispense = staff_dispense.b_employee_id
        left join b_employee as staff_modifier on t_order_drug.order_drug_modifier = staff_modifier.b_employee_id
        left join b_employee as staff_execute on t_order.order_staff_execute = staff_execute.b_employee_id
        left join b_employee as staff_verify on t_order.order_staff_verify  = staff_verify.b_employee_id

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site
where
        t_health_family.health_family_active = '1'
        and t_visit.f_visit_status_id ='3'
        and t_order_drug.order_drug_active ='1'
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
        ,TYPEDRUG
        ,DIDSTD
        ,DNAME
        ,DATESTART
        ,DATEFINISH
        --,AMOUNT
        ,UNIT
        ,UNIT_PACKING
        ,DRUGPRICE
        ,DRUGCOST
       -- ,PROVIDER
        --,D_UPDATE


order by t_visit.visit_vn asc