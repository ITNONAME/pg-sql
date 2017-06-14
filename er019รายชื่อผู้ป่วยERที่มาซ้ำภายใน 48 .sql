--รายชื่อผู้ป่วยERที่มาซ้ำภายใน 48 ชม.020309
SELECT  distinct
f_patient_prefix.patient_prefix_description || ' ' ||t_patient.patient_firstname|| ' ' ||t_patient.patient_lastname as "ชื่อ-สกุล"
, lst_hn as "HN"
, lst_an as "AN ล่าสุด"
, lst_date AS "วันที่รับบริการล่าสุด"
,fes as ระดับความรุนแรง
, lst_icd AS "รหัสโรคล่าสุด"
,dx1 as dxล่าสุด
--, bf_an As "AN ครั้งที่ก่อน"
, bf_date AS "วันที่รับบริการครั้งก่อน"
, bf_icd AS "รหัสโรคครั้งก่อน"
,dx2 as dxครั้งก่อน
--,f_appointment_status.appointment_status_name as สถานะการนัด
,อาการ as อาการสำคัญ
,อาการ2 as ประวัติปัจจุบัน
,(TO_DATE(que1.lst_date,'YYYY-MM-DD') - TO_DATE(que2.bf_date,'YYYY-MM-DD')) as DiffDay
FROM
(SELECT vis.visit_hn AS lst_hn
, vis.visit_vn AS lst_an
, vis.t_visit_id as lst_vid
, vis.t_patient_id as pt_id
,vis.visit_dx as dx1
,SUBSTRING(vis.visit_begin_visit_time,1,16) AS lst_Date
, icd.diag_icd10_number AS lst_icd
,visit_primary_symptom_main_symptom as อาการ
,t_visit_primary_symptom.visit_primary_symptom_current_illness as อาการ2
  ,f_emergency_status.emergency_status_description AS fes
FROM t_visit AS vis 
INNER JOIN t_diag_icd10 AS icd ON vis.t_visit_id = icd.diag_icd10_vn
inner join t_visit_service AS service on vis.t_visit_id = service.t_visit_id 
inner join b_service_point AS point1 on point1.b_service_point_id = service.b_service_point_id
inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id = vis.t_visit_id
inner join f_emergency_status on vis.f_emergency_status_id=f_emergency_status.f_emergency_status_id
        --inner join t_visit_refer_in_out ON t_visit_refer_in_out.t_visit_id = vis.t_visit_id--t_visit.t_visit_id  
						--	AND t_visit_refer_in_out.visit_refer_in_out_active ='1'
WHERE SUBSTRING(vis.visit_begin_visit_time,1,16) between substring('2559-10-01',1,16) and substring('2560-09-30',1,16)
--WHERE SUBSTRING(vis.visit_begin_visit_time,1,16) between substring(?,1,16) and substring(?,1,16)
AND f_visit_type_id = '0' 
AND vis.f_visit_status_id in ('1','2','3') 
AND point1.b_service_point_id ='2409144269314' --er
AND icd.f_diag_icd10_type_id = '1'
and icd.diag_icd10_number  <> 'Z48.0' 
) AS que1
INNER JOIN
(SELECT vis.visit_hn AS bf_hn
, vis.visit_vn AS bf_an
, vis.t_visit_id as bf_vid
,vis.visit_dx as dx2
, SUBSTRING(vis.visit_begin_visit_time,1,16) AS bf_Date
,icd.diag_icd10_number AS bf_icd
FROM t_visit AS vis 
INNER JOIN t_diag_icd10 AS icd 
ON vis.t_visit_id = icd.diag_icd10_vn
--WHERE SUBSTRING(vis.visit_begin_visit_time,1,16) BETWEEN TO_CHAR(CAST( substring(?,1,16) AS date)-2,'yyyy-mm-dd') AND substring(?,1,16)
WHERE SUBSTRING(vis.visit_begin_visit_time,1,16) BETWEEN TO_CHAR(CAST( substring('2559-10-01',1,16) AS date)-2,'yyyy-mm-dd') AND substring('2560-09-30',1,16)
AND f_visit_type_id = '0' 
AND vis.f_visit_status_id IN ('2','3') 
and icd.diag_icd10_number  <> 'Z48.0' 
AND icd.f_diag_icd10_type_id = '1') AS que2
ON que1.lst_hn = que2.bf_hn AND que1.lst_icd = que2.bf_icd
INNER JOIN t_patient ON t_patient.t_patient_id = que1.pt_id
LEFT JOIN f_patient_prefix ON f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id
inner join t_patient_appointment on t_patient.t_patient_id = t_patient_appointment.t_patient_id
inner join f_appointment_status on t_patient_appointment.patient_appointment_status = f_appointment_status.f_appointment_status_id 
--inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id = t_visit.t_visit_id
        INNER join t_health_family on t_health_family.t_health_family_id = t_patient.t_health_family_id 
        and  t_patient.patient_active = '1' and t_health_family.f_patient_discharge_status_id = '1'--คนตาย
WHERE TO_DATE(que1.lst_date,'YYYY-MM-DD') - TO_DATE(que2.bf_date,'YYYY-MM-DD') <= 2 AND que1.lst_an > que2.bf_an
and t_patient_appointment.patient_appointment_status = '0'
ORDER BY lst_hn DESC