--รายงานอันดับโรคของผู้ป่วยER
select p1.icd10  as "รหัส ICD 10"
  ,p1. icdname as ชื่อโรค
            ,count(distinct p1.hn) as คน  
            ,count(p1.vn) as ครั้ง 
            ,sum(p1.invoice) as ค่ารักษา   
from(select distinct
	 t_visit.visit_begin_visit_time AS วันรับบริการ
    ,t_visit.visit_hn AS HN
    ,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
    ,t_visit.visit_patient_age AS อายุ
    ,t_diag_icd10.diag_icd10_number as icd10
    ,b_icd10.icd10_description as icdname
    ,t_billing_invoice.billing_invoice_total AS invoice
from 
	t_visit inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
    inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
	inner join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.diag_icd10_active ='1' 
                       AND t_diag_icd10.f_diag_icd10_type_id='1'
   LEFT JOIN b_icd10 ON b_icd10.icd10_number = t_diag_icd10.diag_icd10_number
inner join t_visit_payment on t_visit.t_visit_id = t_visit_payment.t_visit_id
inner join t_billing ON t_visit.t_visit_id = t_billing.t_visit_id
inner join t_billing_invoice ON t_billing_invoice.t_visit_id = t_visit_payment.t_visit_id and t_billing_invoice.billing_invoice_active ='1'
 inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id 
				and t_visit_service.b_service_point_id ='2409144269314'
where 
 t_visit.f_visit_status_id <> '4' and  t_visit.f_visit_type_id = '0' --เลือก 1 ผู้ป่วยใน 0 ผู้ป่วยนอก					 
 and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-10-01',1,10) AND substring('2560-01-31',1,10)
 --and substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) AND substring(?,1,10)
	)as p1
group by p1.icd10  ,p1. icdname 
ORDER BY ครั้ง DESC 