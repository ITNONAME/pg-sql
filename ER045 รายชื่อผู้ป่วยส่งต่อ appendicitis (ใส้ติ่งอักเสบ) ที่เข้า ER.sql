--ER043 รายชื่อผู้ป่วย appendicitis (ใส้ติ่งอักเสบ) ที่เข้า ER
select DISTINCT t_patient.patient_hn AS hn  ,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_visit.visit_patient_age AS อายุ
    ,t_visit.visit_begin_visit_time AS วันรับบริการ
    ,t_visit_refer_in_out.record_date_time AS วันส่งต่อ
    ,b_visit_office.visit_office_name AS ส่งไปหน่วยงาน
		,f_emergency_status.emergency_status_description AS ระดับความรุนแรง
    , t_diag_icd10.diag_icd10_number AS ICD10
    ,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท
    ,t_visit.visit_dx AS "DXแพทย์"
    ,b_visit_clinic.visit_clinic_description AS ประเภทโรค
     from t_visit 
				inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <> '4' 
        INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
        inner join f_emergency_status on t_visit.f_emergency_status_id=f_emergency_status.f_emergency_status_id
        inner join t_visit_refer_in_out ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id 
        INNER JOIN b_employee ON b_employee.b_employee_id = t_visit_refer_in_out.visit_refer_in_out_staff_refer
        INNER JOIN b_service_point ON b_service_point.b_service_point_id = b_employee.b_service_point_id 
            and t_visit_refer_in_out.f_visit_refer_type_id ='1'  AND t_visit_refer_in_out.visit_refer_in_out_active ='1'
        INNER JOIN b_visit_office ON b_visit_office.b_visit_office_id = t_visit_refer_in_out.visit_refer_in_out_refer_hospital
				inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id = '2409144269314'
        LEFT JOIN t_diag_icd10 ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.diag_icd10_active ='1' 
                       AND t_diag_icd10.f_diag_icd10_type_id='1'      
   --     LEFT JOIN b_icd10 ON b_icd10.icd10_number = t_diag_icd10.diag_icd10_number
        LEFT JOIN b_visit_clinic ON t_diag_icd10.b_visit_clinic_id = b_visit_clinic.b_visit_clinic_id    
where t_diag_icd10.diag_icd10_number like 'K35%'
--where substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) AND substring(?,1,10)
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) AND substring('2559-09-30',1,10)
ORDER BY วันรับบริการ