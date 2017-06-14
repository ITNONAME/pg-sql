select  distinct
            b_site.b_visit_office_id as HOSPCODE
            , t_health_family.health_family_hn_hcis as PID 
            , t_visit.visit_vn as AN
             , rpad(substr(t_visit.visit_begin_admit_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_begin_admit_date_time,5),'-',''),',',''),':',''),14,'0') as DATETIME_ADMIT  
            , case when  b_report_12files_map_clinic.b_report_12files_std_clinic_id in ('1300','1301','1302','1303','1304','1305')
                        then (t_visit.f_visit_type_id || b_report_12files_map_clinic.b_report_12files_std_clinic_id )
                     when  b_report_12files_map_clinic.b_report_12files_std_clinic_id not in ('1300','1301','1302','1303','1304','1305')
                        then (t_visit.f_visit_type_id || b_report_12files_map_clinic.b_report_12files_std_clinic_id || '00' )
                    else '00000' end as WARDDIAG
            , t_diag_icd10.f_diag_icd10_type_id as DIAGTYPE
            , case when t_diag_icd10.diag_icd10_number is not null
                        then replace(t_diag_icd10.diag_icd10_number,'.','')
                        else '' end as DIAGCODE  
            , case when b_employee.provider is not null 
                        then b_employee.provider 
                        else ''
                        end  as PROVIDER
            , case when length(t_diag_icd10.diag_icd10_update_date_time) >= 10 
                                then rpad(substr(t_diag_icd10.diag_icd10_update_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_diag_icd10.diag_icd10_update_date_time,5),'-',''),',',''),':',''),14,'0')
                     when length(t_diag_icd10.diag_icd10_update_date_time) < 10 and length(t_diag_icd10.diag_icd10_record_date_time) >= 10
                                then  rpad(substr( t_diag_icd10.diag_icd10_record_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr( t_diag_icd10.diag_icd10_record_date_time,5),'-',''),',',''),':',''),14,'0') 
                     else rpad(substr(t_visit.visit_staff_doctor_discharge_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''),14,'0') 
                     end as D_UPDATE 

from t_diag_icd10 inner join t_visit on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn  
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
        inner join t_health_family on t_health_family.t_health_family_id = t_patient.t_health_family_id
        left join b_report_12files_map_clinic  on t_diag_icd10.b_visit_clinic_id = b_report_12files_map_clinic.b_visit_clinic_id
        left join b_employee on (case when t_diag_icd10.diag_icd10_staff_doctor <> ''
                                                        then t_diag_icd10.diag_icd10_staff_doctor
                                                        else t_diag_icd10.diag_icd10_staff_update end ) = b_employee.b_employee_id

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site

where 
        t_health_family.health_family_active = '1'
        and t_diag_icd10.diag_icd10_active = '1' 
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

order by t_visit.visit_vn asc
