--004 รายชื่อผู้ป่วยที่จำนวนวันนอนไม่ถูกต้อง
select
substring(t_visit.visit_begin_visit_time,1,10) AS dvisit
,t_visit.f_visit_type_id as typeid
,t_patient.patient_hn AS HN
,t_visit.visit_vn AS VN
, case when (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD')) = 0
then 1
else (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD'))
end AS los
,t_diag_tdrg.drg,adjrw
, r_rp1853_instype.maininscl AS inscl
FROM 
t_visit INNER JOIN t_patient ON t_patient.t_patient_id = t_visit.t_patient_id
INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id 
LEFT JOIN r_rp1853_instype ON (b_contract_plans.r_rp1853_instype_id = r_rp1853_instype.id) 
left join t_diag_tdrg on t_visit.t_visit_id = t_diag_tdrg.t_visit_id 
WHERE 
t_visit.f_visit_status_id <> '4' and t_visit.f_visit_type_id = '1' 
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) and substring('2559-09-30',1,10)
--and substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)
and visit_payment_priority ='0'
and (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD')) < 0