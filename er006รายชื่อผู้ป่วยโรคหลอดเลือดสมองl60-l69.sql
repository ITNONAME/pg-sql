--er006รายชื่อผู้ป่วยโรคหลอดเลือดสมอง
select distinct
	t_patient.patient_hn AS HN
	,t_visit.visit_vn AS vn_an
	,f_patient_prefix.patient_prefix_description || '  ' 
	|| t_patient.patient_firstname || '  ' 
	|| t_patient.patient_lastname AS ชื่อผู้ป่วย
    ,t_patient.patient_pid AS เลขบัตรประชาชน
	, t_diag_icd10.diag_icd10_number AS ICD10
     ,t_visit.visit_begin_visit_time  AS วันรับบริการ
	,t_visit.visit_financial_discharge_time AS วันจำหน่าย
   ,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท
,t_patient.patient_house || '  ม.' || t_patient.patient_moo || '  ต.' ||  f1.address_description || '  อ.' || f2.address_description  || '  จ.' ||  f3.address_description as ที่อยู่
,t_patient.patient_phone_number as เบอร์โทรศัพท์
from
	t_visit INNER JOIN t_diag_icd10 
		ON (t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn 
		and (t_diag_icd10.diag_icd10_number like 'I6%' 
         	    or t_diag_icd10.diag_icd10_number like 'G45%') )--ใช้ OR  ในกรณีมีหลายรหัสโรค ที่ไม่ต่อเนื่อง
INNER join t_death on t_death.t_visit_id = t_visit.t_visit_id --ข้อมูลการตาย
	INNER JOIN t_patient 
		ON t_visit.t_patient_id = t_patient.t_patient_id 
	INNER JOIN f_patient_prefix
		ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id	
LEFT JOIN f_address as f1 ON t_patient.patient_tambon = f1.f_address_id
LEFT JOIN f_address as f2 ON t_patient.patient_amphur =f2.f_address_id
LEFT JOIN f_address as f3 ON t_patient.patient_changwat= f3.f_address_id
where 
	t_visit.f_visit_status_id <> '4' 
  and t_diag_icd10.f_diag_icd10_type_id = '1'  --primary 
--  and  substring(t_visit.visit_begin_visit_time ,1,10) between substring(?,1,10) and substring(?,1,10)
  and  substring(t_visit.visit_begin_visit_time ,1,10) between substring('2558-10-01',1,10) and substring('2559-09-30',1,10)
order by 
	t_visit.visit_begin_visit_time