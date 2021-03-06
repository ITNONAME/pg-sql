--insu049จำนวนบุคคลที่มีปัญหาสถานะสิทธิ
SELECT
'จำนวนบุคคลที่มีปัญหาสถานะสิทธิ' as รายการ
,count(DISTINCT q.hn) as คน
,count(DISTINCT q.vn) as ครั้ง
,SUM(q.money) as จำนวนเงิน
FROM
(
select t_patient.patient_hn AS hn  ,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_visit.visit_patient_age AS อายุ
    ,t_visit.visit_begin_visit_time AS วันรับบริการ
		,t_billing.billing_total AS money
    ,t_visit_refer_in_out.record_date_time AS วันส่งต่อ
		,f_emergency_status.emergency_status_description AS ระดับความรุนแรง
    ,b_visit_office.visit_office_name AS ส่งไปหน่วยงาน
    ,b_service_point.service_point_description AS จุดบริการที่ส่ง
    , t_diag_icd10.diag_icd10_number AS ICD10
 --  ,case when t_visit_refer_in_out.f_visit_refer_type_id ='1' then 'refer_out' else 'refer_in' end as refer_type
    ,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท

  --  ,b_icd10.icd10_description AS dx_icd10
    ,b_visit_clinic.visit_clinic_description AS ประเภทโรค
,f_refer_cause.refer_cause_description as สาเหตุที่ส่งต่อ
,b_employee.employee_firstname||' '||b_employee.employee_lastname as ผู้บันทึก
     from t_visit inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <> '4' 
         INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
         inner join t_visit_refer_in_out ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id  
         and t_visit_refer_in_out.f_visit_refer_type_id ='1'  AND t_visit_refer_in_out.visit_refer_in_out_active ='1'
        INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id  AND t_visit_payment.visit_payment_priority = '0'  AND t_visit_payment.visit_payment_active='1')
        INNER JOIN b_contract_plans ON (t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id )
        INNER JOIN b_visit_office ON b_visit_office.b_visit_office_id = t_visit_refer_in_out.visit_refer_in_out_refer_hospital
         INNER JOIN f_refer_cause ON f_refer_cause.f_refer_cause_id = t_visit.f_refer_cause_id
        INNER JOIN b_employee ON b_employee.b_employee_id = t_visit_refer_in_out.visit_refer_in_out_staff_refer
        INNER JOIN b_service_point ON b_service_point.b_service_point_id = b_employee.b_service_point_id
        inner join f_emergency_status on t_visit.f_emergency_status_id=f_emergency_status.f_emergency_status_id
				inner join t_billing ON t_billing.t_visit_id=t_visit.t_visit_id
        LEFT JOIN t_diag_icd10 ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.diag_icd10_active ='1' 
                       AND t_diag_icd10.f_diag_icd10_type_id='1'
       
   --     LEFT JOIN b_icd10 ON b_icd10.icd10_number = t_diag_icd10.diag_icd10_number
        LEFT JOIN b_visit_clinic ON t_diag_icd10.b_visit_clinic_id = b_visit_clinic.b_visit_clinic_id
    
--where substring(t_visit_refer_in_out.record_date_time,1,10) between substring(?,1,10) AND substring(?,1,10)
where substring(t_visit_refer_in_out.record_date_time,1,10) between substring('2558-10-01',1,10) AND substring('2559-09-30',1,10)
--where t_visit_refer_in_out.record_date_time like '2552-08%'
   AND  t_visit_payment.b_contract_plans_id = '212113542523243037' --บุคคลที่มีปัญหาสถานะสิทธิ
--   AND  t_visit_payment.b_contract_plans_id = '212113545494833446' --บุคคลที่มีปัญหาสถานะและสิทธิ(ต่างจังหวัด)
ORDER BY t_visit_refer_in_out.record_date_time
) as q

UNION
SELECT
'จำนวนบุคคลที่มีปัญหาสถานะและสิทธิ(ต่างจังหวัด)' as รายการ
,count(DISTINCT q.hn) as คน
,count(DISTINCT q.vn) as ครั้ง
,SUM(q.money) as จำนวนเงิน
FROM
(
select t_patient.patient_hn AS hn  ,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_visit.visit_patient_age AS อายุ
    ,t_visit.visit_begin_visit_time AS วันรับบริการ
		,t_billing.billing_total AS money
    ,t_visit_refer_in_out.record_date_time AS วันส่งต่อ
		,f_emergency_status.emergency_status_description AS ระดับความรุนแรง
    ,b_visit_office.visit_office_name AS ส่งไปหน่วยงาน
    ,b_service_point.service_point_description AS จุดบริการที่ส่ง
    , t_diag_icd10.diag_icd10_number AS ICD10
 --  ,case when t_visit_refer_in_out.f_visit_refer_type_id ='1' then 'refer_out' else 'refer_in' end as refer_type
    ,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท

  --  ,b_icd10.icd10_description AS dx_icd10
    ,b_visit_clinic.visit_clinic_description AS ประเภทโรค
,f_refer_cause.refer_cause_description as สาเหตุที่ส่งต่อ
,b_employee.employee_firstname||' '||b_employee.employee_lastname as ผู้บันทึก
     from t_visit inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <> '4' 
         INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
         inner join t_visit_refer_in_out ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id  
         and t_visit_refer_in_out.f_visit_refer_type_id ='1'  AND t_visit_refer_in_out.visit_refer_in_out_active ='1'
        INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id  AND t_visit_payment.visit_payment_priority = '0'  AND t_visit_payment.visit_payment_active='1')
        INNER JOIN b_contract_plans ON (t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id )
        INNER JOIN b_visit_office ON b_visit_office.b_visit_office_id = t_visit_refer_in_out.visit_refer_in_out_refer_hospital
         INNER JOIN f_refer_cause ON f_refer_cause.f_refer_cause_id = t_visit.f_refer_cause_id
        INNER JOIN b_employee ON b_employee.b_employee_id = t_visit_refer_in_out.visit_refer_in_out_staff_refer
        INNER JOIN b_service_point ON b_service_point.b_service_point_id = b_employee.b_service_point_id
        inner join f_emergency_status on t_visit.f_emergency_status_id=f_emergency_status.f_emergency_status_id
				inner join t_billing ON t_billing.t_visit_id=t_visit.t_visit_id
        LEFT JOIN t_diag_icd10 ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.diag_icd10_active ='1' 
                       AND t_diag_icd10.f_diag_icd10_type_id='1'
       
   --     LEFT JOIN b_icd10 ON b_icd10.icd10_number = t_diag_icd10.diag_icd10_number
        LEFT JOIN b_visit_clinic ON t_diag_icd10.b_visit_clinic_id = b_visit_clinic.b_visit_clinic_id
    
--where substring(t_visit_refer_in_out.record_date_time,1,10) between substring(?,1,10) AND substring(?,1,10)
where substring(t_visit_refer_in_out.record_date_time,1,10) between substring('2558-10-01',1,10) AND substring('2559-09-30',1,10)
--where t_visit_refer_in_out.record_date_time like '2552-08%'
--   AND  t_visit_payment.b_contract_plans_id = '212113542523243037' --บุคคลที่มีปัญหาสถานะสิทธิ
   AND  t_visit_payment.b_contract_plans_id = '212113545494833446' --บุคคลที่มีปัญหาสถานะและสิทธิ(ต่างจังหวัด)
ORDER BY t_visit_refer_in_out.record_date_time
) as q
