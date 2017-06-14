SELECT
'จำนวนผู้ป่วยต่างด้าวกรณีอุบัติเหตุฉุกเฉิน IPD (มีบัตร)' as รายการ
,"count"(DISTINCT q.hn) as จำนวนคน
,"count"(DISTINCT q.vn) as จำนวนครั้ง
,sum(q.ยอดรวม) as จำนวนเงิน
FROM (
select
DISTINCT
 t_patient.patient_hn AS hn  ,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_visit.visit_patient_age AS อายุ
    ,t_visit.visit_begin_visit_time AS วันรับบริการ
		,b_contract_plans.contract_plans_description AS contract_plans_description
		,f_emergency_status.emergency_status_description AS ระดับความรุนแรง
    , t_diag_icd10.diag_icd10_number AS ICD10
 --  ,case when t_visit_refer_in_out.f_visit_refer_type_id ='1' then 'refer_out' else 'refer_in' end as refer_type
    ,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท
    ,t_visit.visit_dx AS "DXแพทย์"
  --  ,b_icd10.icd10_description AS dx_icd10
    ,b_visit_clinic.visit_clinic_description AS ประเภทโรค
,f_refer_cause.refer_cause_description as สาเหตุที่ส่งต่อ
		,t_billing.billing_total AS ยอดรวม
     from t_visit inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <> '4' 
         INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
				inner join t_billing ON t_billing.t_visit_id=t_visit.t_visit_id
					AND t_billing.billing_active = '1'
				inner join t_billing_receipt ON t_billing_receipt.t_visit_id=t_visit.t_visit_id
					AND	t_billing_receipt.billing_receipt_active = '1' --รายการรับชำระ สถานะของการรับชำระ 	
				inner join t_billing_invoice ON t_billing_invoice.t_visit_id=t_visit.t_visit_id
					AND t_billing_invoice.billing_invoice_active = '1' --รายการแจ้งหนี้  
         INNER JOIN f_refer_cause ON f_refer_cause.f_refer_cause_id = t_visit.f_refer_cause_id
        inner join f_emergency_status on t_visit.f_emergency_status_id=f_emergency_status.f_emergency_status_id
        INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id  
								AND t_visit_payment.visit_payment_priority = '0'  AND t_visit_payment.visit_payment_active='1')
					INNER JOIN b_contract_plans ON (t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id )
        LEFT JOIN t_diag_icd10 ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.diag_icd10_active ='1' 
                       AND t_diag_icd10.f_diag_icd10_type_id='1'
				inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2409144269314'       
   --     LEFT JOIN b_icd10 ON b_icd10.icd10_number = t_diag_icd10.diag_icd10_number
        LEFT JOIN b_visit_clinic ON t_diag_icd10.b_visit_clinic_id = b_visit_clinic.b_visit_clinic_id
    
--where substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) AND substring(?,1,10)
where substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) AND substring('2559-09-30',1,10)
and t_visit_payment.b_contract_plans_id in ('2120000000039','212113547107760953')
and t_visit.f_visit_type_id = '1'
and t_visit.f_visit_status_id = '3'		--จบกระบวนการ
) as q
UNION
SELECT
'จำนวนผู้ป่วยต่างด้าวกรณีอุบัติเหตุฉุกเฉิน IPD (ไม่มีบัตร)' as รายการ
,"count"(DISTINCT q.hn) as จำนวนคน
,"count"(DISTINCT q.vn) as จำนวนครั้ง
,sum(q.ยอดรวม) as จำนวนเงิน
FROM (
select
DISTINCT
 t_patient.patient_hn AS hn  ,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_visit.visit_patient_age AS อายุ
    ,t_visit.visit_begin_visit_time AS วันรับบริการ
		,b_contract_plans.contract_plans_description AS contract_plans_description
		,f_emergency_status.emergency_status_description AS ระดับความรุนแรง
    , t_diag_icd10.diag_icd10_number AS ICD10
 --  ,case when t_visit_refer_in_out.f_visit_refer_type_id ='1' then 'refer_out' else 'refer_in' end as refer_type
    ,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท
    ,t_visit.visit_dx AS "DXแพทย์"
  --  ,b_icd10.icd10_description AS dx_icd10
    ,b_visit_clinic.visit_clinic_description AS ประเภทโรค
,f_refer_cause.refer_cause_description as สาเหตุที่ส่งต่อ
		,t_billing.billing_total AS ยอดรวม
     from t_visit inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <> '4' 
         INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
				inner join t_billing ON t_billing.t_visit_id=t_visit.t_visit_id
					AND t_billing.billing_active = '1'
				inner join t_billing_receipt ON t_billing_receipt.t_visit_id=t_visit.t_visit_id
					AND	t_billing_receipt.billing_receipt_active = '1' --รายการรับชำระ สถานะของการรับชำระ 	
				inner join t_billing_invoice ON t_billing_invoice.t_visit_id=t_visit.t_visit_id
					AND t_billing_invoice.billing_invoice_active = '1' --รายการแจ้งหนี้  
         INNER JOIN f_refer_cause ON f_refer_cause.f_refer_cause_id = t_visit.f_refer_cause_id
        inner join f_emergency_status on t_visit.f_emergency_status_id=f_emergency_status.f_emergency_status_id
        INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id  
								AND t_visit_payment.visit_payment_priority = '0'  AND t_visit_payment.visit_payment_active='1')
					INNER JOIN b_contract_plans ON (t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id )
        LEFT JOIN t_diag_icd10 ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.diag_icd10_active ='1' 
                       AND t_diag_icd10.f_diag_icd10_type_id='1'
				inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2409144269314'       
   --     LEFT JOIN b_icd10 ON b_icd10.icd10_number = t_diag_icd10.diag_icd10_number
        LEFT JOIN b_visit_clinic ON t_diag_icd10.b_visit_clinic_id = b_visit_clinic.b_visit_clinic_id
    
--where substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) AND substring(?,1,10)
where substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) AND substring('2559-09-30',1,10)
and t_visit_payment.b_contract_plans_id in ('212000002594847647','212113540938711809')
and t_visit.f_visit_type_id = '1'
and t_visit.f_visit_status_id = '3'		--จบกระบวนการ
) as q