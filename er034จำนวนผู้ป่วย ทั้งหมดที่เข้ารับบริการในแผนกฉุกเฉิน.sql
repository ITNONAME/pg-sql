--จำนวนผู้ป่วย ทั้งหมดที่เข้ารับบริการในแผนกฉุกเฉิน
SELECT
  'จำนวนผู้ป่วย ทั้งหมดที่เข้ารับบริการในแผนกฉุกเฉิน' as รายการ  
            ,count(p1.vn) as จำนวนราย
from (
select distinct
     t_visit.visit_begin_visit_time AS วันรับบริการ
    ,t_visit.visit_hn as HN
    ,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
    ,date_part('year',age(cast(current_date as date)        
,cast((cast(substring(t_patient.patient_birthday,1,4) as numeric) - 543 
       || substring(t_patient.patient_birthday,5))   as date))) AS อายุ
 --,visit_primary_symptom_main_symptom  as อาการสำคัญ
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_main_symptom),' , ') AS อาการสำคัญ
--,visit_primary_symptom_current_illness as อาการปัจจุบัน
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_current_illness),' , ') AS อาการปัจจุบัน
 ,t_visit.visit_dx as dxแพทย์
  --,t_diag_icd10.diag_icd10_number || ' : '  || b_icd10. icd10_description as icd10
,array_to_string(array_agg(DISTINCT t_diag_icd10.diag_icd10_number || ' : '  || b_icd10. icd10_description),' , ') AS icd10
from 
	t_visit inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
    inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
   inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id = t_visit.t_visit_id
	inner join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn
inner join b_icd10 on b_icd10.icd10_number= t_diag_icd10.diag_icd10_number
 inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2409144269314'
where 
	
 t_visit.f_visit_status_id <> '4'					 
	and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-09-01',1,10) AND substring('2559-09-30',1,10)
  --and substring(t_visit.visit_begin_visit_time,1,10) between substring (?,1,10) and substring(?,1 ,10)
GROUP BY 	วันรับบริการ , HN , VN ,	ชื่อสกุล , อายุ  , dxแพทย์ 	
ORDER BY วันรับบริการ

--ORDER BY ชื่อสกุล
) as p1