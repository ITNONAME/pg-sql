select
            b_site.b_visit_office_id as HOSPCODE
            , t_health_family.health_family_hn_hcis as PID 
            , case when t_visit.f_visit_type_id = '1' then t_visit.visit_vn else '' end AN
            , t_visit.visit_vn AS SEQ 
            , substr(t_visit.visit_begin_visit_time,1,4)::int -543
                 ||substr(t_visit.visit_begin_visit_time,6,2) 
                 ||substr(t_visit.visit_begin_visit_time,9,2) as  DATE_SERV
            , case when  b_report_12files_map_clinic.b_report_12files_std_clinic_id in ('1300','1301','1302','1303','1304','1305')
                        then (t_visit.f_visit_type_id || b_report_12files_map_clinic.b_report_12files_std_clinic_id )
                     when  b_report_12files_map_clinic.b_report_12files_std_clinic_id not in ('1300','1301','1302','1303','1304','1305')
                        then (t_visit.f_visit_type_id || b_report_12files_map_clinic.b_report_12files_std_clinic_id || '00' )
                    else '00000' end AS CLINIC  

             , min(substr(t_patient_appointment.patient_appointment_date,1,4)::int-543
                        ||substr(t_patient_appointment.patient_appointment_date,6,2)
                        ||substr(t_patient_appointment.patient_appointment_date,9,2))  as APDATE 
            ,case when (t_patient_appointment.r_rp1853_aptype_id ='') then '181' 
                else substring(t_patient_appointment.r_rp1853_aptype_id,1,3) end AS APTYPE  
            , replace(t_diag_icd10.diag_icd10_number,'.','') AS APDIAG

           , b_employee.provider as PROVIDER

            , min(case when length(t_patient_appointment.patient_appointment_update_date_time) >= 10
                                then rpad(substr(t_patient_appointment.patient_appointment_update_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_patient_appointment.patient_appointment_update_date_time,5),'-',''),',',''),':',''),14,'0')
                     else  rpad(substr(t_patient_appointment.patient_appointment_record_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_patient_appointment.patient_appointment_record_date_time,5),'-',''),',',''),':',''),14,'0')
                     end )as D_UPDATE  
from t_patient_appointment inner join t_visit 
                    on (case when t_patient_appointment.visit_id_make_appointment is not null 
                                            then t_patient_appointment.visit_id_make_appointment
                                            else t_patient_appointment.t_visit_id end ) = t_visit.t_visit_id
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
        inner join t_health_family on t_patient.t_health_family_id =  t_health_family.t_health_family_id
        inner join (select
                                    t_diag_icd10.*
                            from t_diag_icd10 inner join (select
                                                                                t_diag_icd10.diag_icd10_vn as diag_icd10_vn
                                                                                ,max(t_diag_icd10.diag_icd10_record_date_time) as max_date_time
                                                                        from t_diag_icd10
                                                                        where 
                                                                                t_diag_icd10.f_diag_icd10_type_id = '1' 
                                                                                and t_diag_icd10.diag_icd10_active = '1' 
                                                                                and t_diag_icd10.diag_icd10_record_date_time <> ''
                                                                        group by
                                                                                t_diag_icd10.diag_icd10_vn) as diag_icd10
                        on  t_diag_icd10.diag_icd10_vn = diag_icd10.diag_icd10_vn
                               and t_diag_icd10.diag_icd10_record_date_time  = diag_icd10.max_date_time) as t_diag_icd10 
                        on (case when t_patient_appointment.visit_id_make_appointment is not null 
                                            then t_patient_appointment.visit_id_make_appointment
                                            else t_patient_appointment.t_visit_id end ) = t_diag_icd10.diag_icd10_vn 
                                and t_diag_icd10.f_diag_icd10_type_id = '1' 
                                and t_diag_icd10.diag_icd10_active = '1' 
                                and t_diag_icd10.diag_icd10_record_date_time <> ''
        left join b_report_12files_map_clinic  ON t_diag_icd10.b_visit_clinic_id = b_report_12files_map_clinic.b_visit_clinic_id
        left join b_employee on (case when t_patient_appointment.patient_appointment_staff_update <> ''                                           
                                                then t_patient_appointment.patient_appointment_staff_update  
                                                 else t_patient_appointment.patient_appointment_staff_record end) = b_employee.b_employee_id

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        
        cross join b_site
where
        t_patient_appointment.patient_appointment_active = '1'
        and t_health_family.health_family_active = '1'
        and t_visit.f_visit_status_id ='3'
        and t_patient_appointment.patient_appointment_status in  ('1','4','5')
        and t_patient_appointment.patient_appointment_vn  <> ''
        and t_visit.visit_money_discharge_status ='1'
        and t_visit.visit_doctor_discharge_status ='1'
        and length(t_patient_appointment.patient_appointment_date) =10
        and (t_patient_appointment.patient_appointment_update_date_time <> ''
        or t_patient_appointment.patient_appointment_record_date_time <> '') 
       and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate'  

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

group by
        HOSPCODE 
        ,PID  
        ,AN
        ,SEQ 
        ,DATE_SERV
        ,CLINIC

        ,APTYPE 
        ,APDIAG 
        ,PROVIDER


order by
        SEQ asc
