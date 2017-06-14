SELECT distinct
b_site.b_visit_office_id AS HOSPCODE
,t_visit_refer_in_out.visit_refer_in_out_number AS REFERID
,'' AS REFERID_PROVINCE
,t_health_family.health_family_hn_hcis AS PID
,t_visit.visit_vn AS SEQ
,case when t_visit.f_visit_type_id='1'
 then t_visit.visit_vn
else '' end AS AN
,'' AS REFERID_ORIGIN
,case when t_visit_refer_in_out.f_visit_refer_type_id='0'
      then t_visit_refer_in_out.visit_refer_in_out_refer_hospital
else '' end AS HOSPCODE_ORIGIN
,(to_number(substring(t_visit.visit_begin_visit_time,1,4),'9999')-543)       
			|| substring(t_visit.visit_begin_visit_time,6,2)       
			|| substring(t_visit.visit_begin_visit_time,9,2) ||replace(substring(t_visit.visit_begin_visit_time,12),':','') as DATETIME_SERV
,case when t_visit.f_visit_type_id='1'
 then (to_number(substring(t_visit.visit_begin_admit_date_time,1,4),'9999')-543)       
			|| substring(t_visit.visit_begin_admit_date_time,6,2)       
			|| substring(t_visit.visit_begin_admit_date_time,9,2) ||replace(substring(t_visit.visit_begin_visit_time,12),':','')
else '' end AS DATETIME_ADMIT
,(to_number(substring(t_visit_refer_in_out.record_date_time,1,4),'9999')-543)       
			|| substring(t_visit_refer_in_out.record_date_time,6,2)       
			|| substring(t_visit_refer_in_out.record_date_time,9,2) ||'000000'AS DATETIME_REFER
, case when  b_report_12files_map_clinic.b_report_12files_std_clinic_id in ('1300','1301','1302','1303','1304','1305')
                        then (t_visit.f_visit_type_id || b_report_12files_map_clinic.b_report_12files_std_clinic_id )
                     when  b_report_12files_map_clinic.b_report_12files_std_clinic_id not in ('1300','1301','1302','1303','1304','1305')
                        then (t_visit.f_visit_type_id || b_report_12files_map_clinic.b_report_12files_std_clinic_id || '00' )
                    else '00000' end  AS CLINIC_REFER
, t_visit_refer_in_out.visit_refer_in_out_refer_hospital AS HOSP_DESTINATION
,'' AS CHIEFCOMP
,'' AS PHYSICALEXAM
,'' AS DIAGFIRST
,replace(t_diag_icd10.diag_icd10_number,'.','') AS DIAGLAST
,t_visit_refer_in_out.visit_refer_in_out_current_symptom AS PSTATUS
,case when t_visit.f_trama_status_id ='1'
 then '2'
      when t_visit.f_trama_status_id ='2'
 then '1'
else '3' end AS PTYPE
,case when t_visit.f_emergency_status_id ='4'
 then '1'
 when t_visit.f_emergency_status_id ='3'
 then '2'
 when t_visit.f_emergency_status_id ='2'
 then '3'
 when t_visit.f_emergency_status_id ='5'
 then '4'
else '5' end AS EMERGENCY
,case when t_visit_refer_in_out.f_ptypedis_id in ('01','02','03','04','05','06','07','99')
 then t_visit_refer_in_out.f_ptypedis_id 
else '' end AS PTYPEDIS
, case when  t_visit.f_refer_cause_id in ('2','3','4','5','6') then '1'  
       when t_visit.f_refer_cause_id in ('1') then '2'
       when t_visit.f_refer_cause_id in ('7','8') then '5'
else '' end as CAUSEOUT
,t_visit_refer_in_out.visit_refer_in_out_treatment_continue AS REQUEST
,b_employee.provider AS PROVIDER
, rpad(substr(t_visit.visit_staff_doctor_discharge_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''),14,'0') as D_UPDATE 





FROM t_visit_refer_in_out INNER JOIN t_visit ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id
INNER JOIN t_patient ON t_visit.t_patient_id = t_patient.t_patient_id
INNER JOIN t_health_family ON t_patient.t_health_family_id = t_health_family.t_health_family_id
INNER JOIN t_diag_icd10 ON t_visit.t_visit_id  = t_diag_icd10.diag_icd10_vn and t_diag_icd10.f_diag_icd10_type_id = '1' and t_diag_icd10.diag_icd10_active = '1' 
LEFT JOIN t_visit_primary_symptom ON t_visit.t_visit_id = t_visit_primary_symptom.t_visit_id and t_visit_primary_symptom.visit_primary_symptom_active='1'
LEFT JOIN t_visit_physical_exam ON t_visit.t_visit_id = t_visit_physical_exam.t_visit_id 
LEFT JOIN b_report_12files_map_clinic  ON t_diag_icd10.b_visit_clinic_id = b_report_12files_map_clinic.b_visit_clinic_id 
LEFT JOIN b_employee ON t_visit_refer_in_out.visit_refer_in_out_staff_refer = b_employee.b_employee_id and b_employee.employee_active='1'
,b_site

WHERE t_visit_refer_in_out.visit_refer_in_out_active='1'
AND t_health_family.health_family_active = '1'
AND t_visit_refer_in_out.visit_refer_in_out_status='1'
AND t_visit.f_visit_type_id <> 'S'
AND t_visit.f_visit_status_id ='3'
AND t_visit.visit_money_discharge_status='1'
AND t_visit.visit_doctor_discharge_status='1' 				
AND substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate' 