--ER041 รายชื่อผู้ป่วยกระดูกหัก
select t_patient.patient_hn AS hn  ,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_visit.visit_patient_age AS อายุ
    ,t_visit.visit_begin_visit_time AS วันรับบริการ
		,f_emergency_status.emergency_status_description AS ระดับความรุนแรง
    , t_diag_icd10.diag_icd10_number AS ICD10
    ,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท
    ,t_visit.visit_dx AS "DXแพทย์"
    ,b_visit_clinic.visit_clinic_description AS ประเภทโรค
     from t_visit inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <> '4' 
         INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id

        inner join f_emergency_status on t_visit.f_emergency_status_id=f_emergency_status.f_emergency_status_id
        inner join t_visit_refer_in_out ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id  
							--and t_visit_refer_in_out.f_visit_refer_type_id ='1'
							AND t_visit_refer_in_out.visit_refer_in_out_active ='1'
        LEFT JOIN t_diag_icd10 ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.diag_icd10_active ='1' 
                       AND t_diag_icd10.f_diag_icd10_type_id='1'
       
   --     LEFT JOIN b_icd10 ON b_icd10.icd10_number = t_diag_icd10.diag_icd10_number
        LEFT JOIN b_visit_clinic ON t_diag_icd10.b_visit_clinic_id = b_visit_clinic.b_visit_clinic_id
    
--where substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) AND substring(?,1,10)
where 
 (t_visit.visit_dx like '%Fracture%'
or t_visit.visit_dx like '%fracture%'
or t_visit.visit_dx like '% Fx %'
or t_visit.visit_dx like 'Fx %'
or t_visit.visit_dx like '% fx %'
or t_visit.visit_dx like 'fx %'
)
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2556-10-01',1,10) AND substring('2557-09-30',1,10)
--where t_visit_refer_in_out.record_date_time like '2552-08%'

ORDER BY วันรับบริการ