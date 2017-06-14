--er040 จำนวนครั้งของผู้ป่วยอุบัติเหตุจากการจราจร
SELECT
'จำนวนครั้งที่ผู้ป่วยอุบัติเหตุเข้ารับบริการ' as รายการ
,count(q.vn) as ครั้ง
from (
select DISTINCT
t_visit.visit_hn as HN
--,t_visit.t_visit_id
,t_visit.visit_vn as vn
,f_patient_prefix.patient_prefix_description || ' ' || t_patient.patient_firstname || ' ' || t_patient.patient_lastname as ชื่อสกุล
,t_visit.visit_begin_visit_time as วันที่เข้ารับบริการ
,t_accident.accident_date as วันที่เกิดอุบัติเหตุ
,t_accident.accident_time as เวลาที่เกิดอุบัติเหตุ
,t_accident.accident_road_name as สถานที่เกิดเหตุ
,b_employee.employee_firstname || ' ' || b_employee.employee_lastname as ผู้บันทึก
,b_contract_plans.contract_plans_description
from t_visit
inner join t_patient on t_patient.t_patient_id = t_visit.t_patient_id
inner join t_accident on t_visit.t_visit_id = t_accident.t_visit_id
inner join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join b_employee on b_employee.b_employee_id = t_accident.accident_staff_record

INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id                                                       
      and b_contract_plans.b_contract_plans_id in ('2120000000007','212113540280771959','212113545802782533')
where
 SUBSTRING(t_visit.visit_begin_visit_time,1,10) between substr('2558-10-01',1,10) and substr('2559-09-30',1,10)
 --SUBSTRING(t_visit.visit_begin_visit_time,1,10) between substr(?,1,10) and substr(?,1,10)
 and t_visit.f_visit_status_id <> '4'
) as q