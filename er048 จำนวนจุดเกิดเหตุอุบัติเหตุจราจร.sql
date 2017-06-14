--er020 รายชื่อผู้ป่วยอุบัติเหตุ
SELECT 
DISTINCT q.ตำบล as ตำบล
--,q.id as id1
,"count"( q.f1) as จำนวนครั้ง
FROM
(
select DISTINCT
t_visit.visit_hn as HN
--,t_visit.t_visit_id
,t_visit.visit_vn as vn
,f_patient_prefix.patient_prefix_description || ' ' || t_patient.patient_firstname || ' ' || t_patient.patient_lastname as ชื่อสกุล
,t_visit.visit_begin_visit_time as วันที่เข้ารับบริการ
,t_accident.accident_date as วันที่เกิดอุบัติเหตุ
,t_accident.accident_time as เวลาที่เกิดอุบัติเหตุ
  ,f_trama_status.description AS ประเภทการมา_รพ
,f_emergency_status.emergency_status_description AS ระดับความรุนแรง
,t_accident.accident_road_name as สถานที่เกิดเหตุ
,f1.address_description AS ตำบล
,b_employee.employee_firstname || ' ' || b_employee.employee_lastname as ผู้บันทึก
--,t_visit_primary_symptom.visit_primary_symptom_main_symptom AS อาการสำคัญ
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_main_symptom),' , ') AS อาการสำคัญ
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_current_illness),' , ') AS ประวัติปัจจุบัน
,f1.f_address_id as f1
from t_patient
inner join t_visit on t_patient.t_patient_id = t_visit.t_patient_id
inner join t_accident on t_visit.t_visit_id = t_accident.t_visit_id
and t_accident.accident_occur_type = 'A'
and t_accident.accident_accident_type in ('V','O','B')
--อุบัติเหตุจราจร
--and t_accident.accident_occur_type = 'E'
--and t_accident.accident_emergency_type in ('1','2','3')
--อุบัติเหตุทั่วไป
inner join b_employee on b_employee.b_employee_id = t_accident.accident_staff_record
inner join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
--inner join t_visit_primary_symptom on t_visit_primary_symptom.t_patient_id=t_patient.t_patient_id
inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id=t_visit.t_visit_id and t_visit_primary_symptom.visit_primary_symptom_active='1'
left JOIN f_address as f1 ON f1.f_address_id = t_accident.f_address_id_accident_tambon
left join f_trama_status on t_visit.f_trama_status_id=f_trama_status.f_trama_status_id
left join f_emergency_status on t_visit.f_emergency_status_id=f_emergency_status.f_emergency_status_id
where
 SUBSTRING(t_visit.visit_begin_visit_time,1,10) between substr('2560-01-01',1,10) and substr('2560-04-04',1,10)
 --SUBSTRING(t_visit.visit_begin_visit_time,1,10) between substr(?,1,10) and substr(?,1,10)
 and t_visit.f_visit_status_id <> '4'
GROUP BY hn,ชื่อสกุล,วันที่เข้ารับบริการ,วันที่เกิดอุบัติเหตุ,เวลาที่เกิดอุบัติเหตุ,สถานที่เกิดเหตุ,ผู้บันทึก,ตำบล,ประเภทการมา_รพ,ระดับความรุนแรง,vn,f1
order by t_visit.visit_begin_visit_time
) as q
GROUP BY ตำบล