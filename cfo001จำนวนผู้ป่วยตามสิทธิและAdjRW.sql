-- cfo001จำนวนผู้ป่วยตามสิทธิและAdjRW
select  q2.* from (
(SELECT  case when q1.inscl= 'UCS' then '11 จำนวนครั้งผู้ป่วยนอกUC'
                           when q1.inscl='SSS' then '12 จำนวนครั้งผู้ป่วยนอกประกันสังคม'
														when q1.inscl ='OFC' then '13 จำนวนครั้งผู้ป่วยนอกข้าราชการ'
                            	when q1.inscl ='LGO' then '14 จำนวนครั้งผู้ป่วยนอก อปท.'
                          else  '1zอื่นๆผู้ป่วยนอก(ไม่รายงาน)' 
end  as รายงาน
,count(distinct q1.vn)  as จำนวน
from ( select
substring(t_visit.visit_begin_visit_time,1,10) AS dvisit
,t_visit.f_visit_type_id as typeid
,t_patient.patient_hn AS HN
,t_visit.visit_vn AS VN
, r_rp1853_instype.maininscl AS inscl

FROM 
t_visit
INNER JOIN t_patient ON t_patient.t_patient_id = t_visit.t_patient_id
INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id 
LEFT JOIN r_rp1853_instype ON (b_contract_plans.r_rp1853_instype_id = r_rp1853_instype.id) 

WHERE 
t_visit.f_visit_status_id <> '4' and t_visit.f_visit_type_id = '0' 
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-08-01',1,10) and substring('2559-08-31',1,10)
and visit_payment_priority ='0')q1
group by รายงาน 
)
UNION
select
'15 จำนวนครั้งผู้ป่วยนอกทั้งหมด' as รายงาน
,count( distinct t_visit.visit_vn)  as ราย
FROM 
t_visit INNER JOIN t_patient ON t_patient.t_patient_id = t_visit.t_patient_id
INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id 
LEFT JOIN r_rp1853_instype ON (b_contract_plans.r_rp1853_instype_id = r_rp1853_instype.id) 
left join t_diag_tdrg on t_visit.t_visit_id = t_diag_tdrg.t_visit_id 
WHERE 
t_visit.f_visit_status_id <> '4' and t_visit.f_visit_type_id = '0' 
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-08-01',1,10) and substring('2559-08-31',1,10)
and visit_payment_priority ='0'

UNION
select  '16 จำนวนผู้ป่วยนอกที่มารับบริการ' as รายการ
            ,count(distinct p1.hn) as คนHN 
from(
select visit_hn as hn
,visit_vn as vn
,t_billing_invoice.billing_invoice_total AS invoice
from t_visit
inner join t_visit_payment on t_visit.t_visit_id = t_visit_payment.t_visit_id
inner join t_billing ON t_visit.t_visit_id = t_billing.t_visit_id
inner join t_billing_invoice ON t_billing_invoice.t_visit_id = t_visit_payment.t_visit_id and t_billing_invoice.billing_invoice_active ='1'
where  t_visit.f_visit_type_id = '0' --เลือก 1 ผู้ป่วยใน 0 ผู้ป่วยนอก
and t_visit.f_visit_status_id <>'4'
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-08-01',1,10) and substring('2559-08-31',1,10)
)as p1

union
(SELECT  case when q1.inscl= 'UCS' then '21 จำนวนผู้ป่วยในUC'
                           when q1.inscl='SSS' then '22 จำนวนผู้ป่วยในประกันสังคม'
														when q1.inscl ='OFC' then '23 จำนวนผู้ป่วยในข้าราชการ'
                            	when q1.inscl ='LGO' then '24 จำนวนผู้ป่วยใน อปท'
                          else  '2z.อื่นๆ ผู้ป่วยใน(ไม่รายงาน)' 
end  as รายงาน
,count(distinct q1.vn)  as ครั้ง 
from ( select
substring(t_visit.visit_begin_visit_time,1,10) AS dvisit
,t_visit.f_visit_type_id as typeid
,t_patient.patient_hn AS HN
,t_visit.visit_vn AS VN
, r_rp1853_instype.maininscl AS inscl
FROM 
t_visit INNER JOIN t_patient ON t_patient.t_patient_id = t_visit.t_patient_id
INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id 
LEFT JOIN r_rp1853_instype ON (b_contract_plans.r_rp1853_instype_id = r_rp1853_instype.id) 
left join t_diag_tdrg on t_visit.t_visit_id = t_diag_tdrg.t_visit_id 
WHERE 
t_visit.f_visit_status_id <> '4' and t_visit.f_visit_type_id = '1' 
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-08-01',1,10) and substring('2559-08-31',1,10)
and visit_payment_priority ='0')q1
group by รายงาน )

union
select
'25 จำนวนผู้ป่วยในทั้งหมด' as รายงาน
,count( distinct t_visit.visit_vn)  as ราย
FROM 
t_visit INNER JOIN t_patient ON t_patient.t_patient_id = t_visit.t_patient_id
INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id 
LEFT JOIN r_rp1853_instype ON (b_contract_plans.r_rp1853_instype_id = r_rp1853_instype.id) 
left join t_diag_tdrg on t_visit.t_visit_id = t_diag_tdrg.t_visit_id 
WHERE 
t_visit.f_visit_status_id <> '4' and t_visit.f_visit_type_id = '1' 
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-08-01',1,10) and substring('2559-08-31',1,10)
and visit_payment_priority ='0'

union
(SELECT  case when q1.inscl= 'UCS' then '41.AdjRW ผู้ป่วยในUC'
                           when q1.inscl='SSS' then '42 AdjRW ผู้ป่วยในประกันสังคม'
														when q1.inscl ='OFC' then '43 .AdjRW ผู้ป่วยข้าราชการ'
                            	when q1.inscl ='LGO' then '44 .AdjRW ผู้ป่วย อปท'
                          else  '4z.อื่นๆผู้ป่วยใน(ไม่รายงาน)' 
end  as รายงาน
,sum(distinct q1.adjrw)  as ครั้ง 
from ( select
substring(t_visit.visit_begin_visit_time,1,10) AS dvisit
,t_visit.f_visit_type_id as typeid
,t_patient.patient_hn AS HN
,t_visit.visit_vn AS VN
, case when (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD')) = 0
then 1
else (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD'))
end AS จำนวนวันนอน
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
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-08-01',1,10) and substring('2559-08-31',1,10)
and visit_payment_priority ='0')q1
group by รายงาน )

UNION
SELECT '31. จำนวนวันนอนทั้งหมด',sum(q1.los)
from (
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
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-08-01',1,10) and substring('2559-08-31',1,10)
and visit_payment_priority ='0')q1
UNION
select '32 จำนวนผู้ป่วยโรคความดันเบาหวาน' as ชื่อบัญชี 
,count(distinct t_visit.visit_hn) as จำนวน 
from t_visit
inner join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn
where t_visit.f_visit_status_id <> '4' 
and t_diag_icd10.diag_icd10_active = '1'
and (t_diag_icd10.diag_icd10_number  between 'I10' and 'I15' 
 or t_diag_icd10.diag_icd10_number between 'E10' and 'E14')
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-08-01',1,10) and substring('2559-08-31',1,10)
UNION
 SELECT '45. จำนวน AdjRW ทั้งหมด',sum(q1.adjrw)
from (
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
,t_diag_tdrg.drg,adjrw as adjrw
, r_rp1853_instype.maininscl AS inscl

FROM 
t_visit INNER JOIN t_patient ON t_patient.t_patient_id = t_visit.t_patient_id
INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id 
LEFT JOIN r_rp1853_instype ON (b_contract_plans.r_rp1853_instype_id = r_rp1853_instype.id) 
left join t_diag_tdrg on t_visit.t_visit_id = t_diag_tdrg.t_visit_id 
WHERE 
t_visit.f_visit_status_id <> '4' and t_visit.f_visit_type_id = '1' 
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-08-01',1,10) and substring('2559-08-31',1,10)
and visit_payment_priority ='0')q1
)q2
order by รายงาน