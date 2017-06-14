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
            , replace(diag_icd9_icd9_number,'.','') AS PROCEDCODE

            , max(case when length(t_diag_icd9.diag_icd9_start_time) > 10
                            then rpad(substr(t_diag_icd9.diag_icd9_start_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_diag_icd9.diag_icd9_start_time,5),'-',''),',',''),':',''),14,'0') 
                     when length(t_diag_icd9.diag_icd9_start_time) < 10 and length(t_diag_icd9.diag_icd9_finish_time) > 10
                            then rpad(substr(substr(t_diag_icd9.diag_icd9_finish_time,1,10)||t_diag_icd9.diag_icd9_start_time,1,4)::int -543
                                                ||replace(replace(replace(substr(substr(t_diag_icd9.diag_icd9_finish_time,1,10)||t_diag_icd9.diag_icd9_start_time,5),'-',''),',',''),':',''),14,'0')    
                            else rpad(substr(substr(t_visit.visit_begin_admit_date_time,1,10)||t_diag_icd9.diag_icd9_start_time,1,4)::int -543
                                                ||replace(replace(replace(substr(substr(t_visit.visit_begin_admit_date_time,1,10)||t_diag_icd9.diag_icd9_start_time,5),'-',''),',',''),':',''),14,'0')                           
                            end) as TIMESTART

            , max(case when length(t_diag_icd9.diag_icd9_finish_time) > 10
                            then rpad(substr(t_diag_icd9.diag_icd9_finish_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_diag_icd9.diag_icd9_finish_time,5),'-',''),',',''),':',''),14,'0')
                     when length(t_diag_icd9.diag_icd9_start_time) > 10 and length(t_diag_icd9.diag_icd9_finish_time) < 10
                            then rpad(substr(substr(t_diag_icd9.diag_icd9_start_time,1,10)||t_diag_icd9.diag_icd9_finish_time,1,4)::int -543
                                                ||replace(replace(replace(substr(substr(t_diag_icd9.diag_icd9_start_time,1,10)||t_diag_icd9.diag_icd9_finish_time,5),'-',''),',',''),':',''),14,'0')  
                            else rpad(substr(substr(t_visit.visit_begin_admit_date_time,1,10)||t_diag_icd9.diag_icd9_finish_time,1,4)::int -543
                                                ||replace(replace(replace(substr(substr(t_visit.visit_begin_admit_date_time,1,10)||t_diag_icd9.diag_icd9_finish_time,5),'-',''),',',''),':',''),14,'0')                           
                            end) as TIMEFINISH

            , sum(case when icd9_order.order_price is not null 
                            then  icd9_order.order_price
                            else 0
                        end::decimal(8,2)) as SERVICEPRICE

            , case when b_employee.provider is not null 
                        then b_employee.provider 
                        else ''
                        end as PROVIDER

            , max(case when length(t_diag_icd9.diag_icd9_update_date_time) >= 10 
                                then rpad(substr(t_diag_icd9.diag_icd9_update_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_diag_icd9.diag_icd9_update_date_time,5),'-',''),',',''),':',''),14,'0')
                     when length(t_diag_icd9.diag_icd9_update_date_time) < 10 and length(t_diag_icd9.diag_icd9_record_date_time) >= 10
                                then  rpad(substr(t_diag_icd9.diag_icd9_record_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_diag_icd9.diag_icd9_record_date_time,5),'-',''),',',''),':',''),14,'0') 
                     else rpad(substr(t_visit.visit_staff_doctor_discharge_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''),14,'0') 
                     end) as D_UPDATE 

from t_diag_icd9 inner join t_visit on t_visit.t_visit_id = t_diag_icd9.diag_icd9_vn 

        left join (select 
                                    t_order.t_visit_id as t_visit_id
                                    ,t_order.order_price as order_price
                                    ,b_item_service.icd9_number as icd9_number
                            from t_order inner join b_item_service on t_order.b_item_id = b_item_service.b_item_id
                                    inner join t_visit on t_order.t_visit_id = t_visit.t_visit_id
                            where
                                        b_item_service.item_service_active ='1'
                                        and t_order.f_order_status_id not in ('0','3')
                                        and t_order.f_item_group_id = '5' 
                                        and t_visit.f_visit_status_id ='3'
                                        and t_visit.visit_money_discharge_status ='1'
                                        and t_visit.visit_doctor_discharge_status ='1'
                                        and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate' 
                                        and t_visit.f_visit_type_id = '1') as icd9_order
                    on t_diag_icd9.diag_icd9_icd9_number = icd9_order.icd9_number
                                and t_visit.t_visit_id = icd9_order.t_visit_id

        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
        inner join t_health_family on t_health_family.t_health_family_id = t_patient.t_health_family_id
        left join b_report_12files_map_clinic  on t_diag_icd9.b_visit_clinic_id = b_report_12files_map_clinic.b_visit_clinic_id
        left join b_employee on (case when t_diag_icd9.diag_icd9_staff_doctor <> ''
                                                        then t_diag_icd9.diag_icd9_staff_doctor
                                                        else t_diag_icd9.diag_icd9_staff_update end ) = b_employee.b_employee_id

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site

where 
        t_health_family.health_family_active = '1'
        and t_diag_icd9.diag_icd9_active = '1'
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
        ,PROCEDCODE

        ,PROVIDER


order by t_visit.visit_vn asc
