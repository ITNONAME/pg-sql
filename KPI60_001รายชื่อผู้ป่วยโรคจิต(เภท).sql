--KPI60_001รายชื่อผู้ป่วยโรคจิต(เภท)
select t_patient.patient_hn AS hn  
		,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
		,t_patient.patient_pid as เลขที่บัตรประชาชน
    ,t_visit.visit_patient_age AS อายุ
    ,t_visit.visit_begin_visit_time AS วันรับบริการ
    ,t_visit.visit_dx AS "DXแพทย์"
    ,t_diag_icd10.diag_icd10_number AS ICD10
		,t_patient.patient_phone_number as เบอร์โทร
		,t_patient.patient_contact_phone_number as เบอร์โทรผู้ติดต่อ
		,t_patient.patient_house as บ้านเลขที่
		,t_patient.patient_moo as หมู่
		,f1.address_description as ตำบล
		,f2.address_description as อำเภอ
		,f3.address_description as จังหวัด
     from t_visit 
				inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <> '4' 
        INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
        LEFT JOIN t_diag_icd10 ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.diag_icd10_active ='1' 
                       AND t_diag_icd10.f_diag_icd10_type_id='1'       
   --     LEFT JOIN b_icd10 ON b_icd10.icd10_number = t_diag_icd10.diag_icd10_number
        LEFT JOIN b_visit_clinic ON t_diag_icd10.b_visit_clinic_id = b_visit_clinic.b_visit_clinic_id
        LEFT join f_address as f1 on t_patient.patient_tambon = f1.f_address_id
        LEFT join f_address as f2 on t_patient.patient_amphur = f2.f_address_id
        LEFT join f_address as f3 on t_patient.patient_changwat = f3.f_address_id   

where t_diag_icd10.diag_icd10_number BETWEEN 'F20.0' and 'F29.9'
--and substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) AND substring(?,1,10)
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) AND substring('2559-12-26',1,10)


ORDER BY วันรับบริการ