--er024รายชื่อผู้ป่วยที่กู้ภัยEMSนำส่ง
select distinct 
     t_visit.visit_begin_visit_time AS วันรับบริการ
    ,t_visit.visit_hn as HN
    ,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
    ,date_part('year',age(cast(current_date as date)        
,cast((cast(substring(t_patient.patient_birthday,1,4) as numeric) - 543 
       || substring(t_patient.patient_birthday,5))   as date))) AS อายุ
,f_emergency_status.emergency_status_description AS ระดับความรุนแรง
 ,t_visit.visit_dx as dxแพทย์
,visit_primary_symptom_main_symptom
,visit_primary_symptom_current_illness
 ,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท
from t_visit 
inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id = t_visit.t_visit_id
inner join t_order on t_order.t_visit_id = t_visit.t_visit_id
inner join f_emergency_status on t_visit.f_emergency_status_id=f_emergency_status.f_emergency_status_id
inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2409144269314'	
where  (t_visit_primary_symptom.visit_primary_symptom_current_illness ilike ('%กู้%') 
or visit_primary_symptom_main_symptom ilike ('%กู้%') )
and t_visit.f_visit_status_id <> '4'	
and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-10-01',1,10) AND substring('2559-10-31',1,10)
--and substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) AND substring(?,1,10)
ORDER BY วันรับบริการ