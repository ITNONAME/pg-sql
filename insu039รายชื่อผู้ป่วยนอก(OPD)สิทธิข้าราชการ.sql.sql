--insu039รายชื่อผู้ป่วยนอก(OPD)สิทธิข้าราชการ.sql
select 
t_visit.visit_hn AS HN
,t_visit.visit_vn AS AN
,f_patient_prefix.patient_prefix_description || ' ' ||t_patient.patient_firstname || '  ' || t_patient.patient_lastname AS "ชื่อ-สกุล"
,t_patient.patient_pid AS PID
,b_contract_plans.contract_plans_description AS สิทธิการรักษา
,t_visit.visit_begin_visit_time AS วันที่เข้ารับบริการ
,t_billing.billing_total AS รวม
   ,t_billing.billing_paid  AS ชำระจริง
   ,t_billing.billing_remain  AS ค้าง
from
t_visit 
INNER JOIN t_visit_payment ON t_visit.t_visit_id = t_visit_payment.t_visit_id
INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id
INNER JOIN t_patient ON t_visit.t_patient_id = t_patient.t_patient_id
LEFT JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
INNER JOIN t_billing ON (t_visit.t_visit_id = t_billing.t_visit_id )--AND t_billing.billing_active = '1')
INNER JOIN t_order ON (t_visit.t_visit_id = t_order.t_visit_id AND t_order.f_order_status_id <> '3')  
where
t_visit.f_visit_type_id = '0' AND --ผู้ป่วยใน 1 ผู้ป่วยนอก 0
 t_visit.f_visit_status_id <> '4' AND
--substr(t_visit.visit_begin_visit_time,1,10) between  substring(?,1,10) and substring(?,1,10)
substr(t_visit.visit_begin_visit_time,1,10) between  substring('2559-11-30',1,10) and substring('2559-11-30',1,10)
and
b_contract_plans.contract_plans_pttype = 'A2'
--and t_patient.patient_pid='1829900082746'
GROUP BY 
HN , AN, "ชื่อ-สกุล" , PID,สิทธิการรักษา,วันที่เข้ารับบริการ,รวม,ชำระจริง,ค้าง
order by  
t_visit.visit_vn