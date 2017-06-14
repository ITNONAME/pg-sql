
select t_patient.patient_hn AS hn ,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
   ,t_patient.patient_lastname AS สกุล
    ,t_visit.visit_patient_age AS อายุ
    ,t_visit.visit_begin_visit_time AS วันรับบริการ
    ,t_visit_refer_in_out.refer_date|| ',' || t_visit_refer_in_out.refer_time as วันส่งต่อ
    ,b_visit_office.visit_office_name AS ส่งไปหน่วยงาน
    ,b_service_point.service_point_description AS จุดบริการที่ส่ง
    ,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท
,t_visit.visit_dx AS "DXแพทย์"
  ,b_visit_clinic.visit_clinic_description AS ประเภทโรค
,t_visit_refer_in_out.visit_refer_in_out_cause as สาเหตุที่ส่งต่อ
,b_employee.employee_firstname||' '||b_employee.employee_lastname as ผู้บันทึก
from t_visit 
				inner join t_visit_refer_in_out ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id  
          and t_visit_refer_in_out.f_visit_refer_type_id ='1'  
					AND t_visit_refer_in_out.visit_refer_in_out_active ='1'
        inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <> '4' 
        INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
         INNER JOIN b_visit_office ON b_visit_office.b_visit_office_id = t_visit_refer_in_out.visit_refer_in_out_refer_hospital
        INNER JOIN b_employee ON b_employee.b_employee_id = t_visit_refer_in_out.visit_refer_in_out_staff_refer
        INNER JOIN b_service_point ON b_service_point.b_service_point_id = b_employee.b_service_point_id
        INNER JOIN t_order ON t_order.t_visit_id = t_visit.t_visit_id and t_order.f_order_status_id  <>'3'
                                and t_order.b_item_id in ('1741124177876','174113548132787133','174113542471980829','174113541069220632','113548771168085','113543975674323','174113549570800108','174113542682464727',
'113540862170804','174113548197758130','174000001994631008','113545037651834','113540471478801','174113541985393565','174113544360247187','174113543187872749','113543832827766','174000003223108912','174113547727995542')
                                                                         
       LEFT JOIN t_diag_icd10 ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.diag_icd10_active ='1' 
                       AND t_diag_icd10.f_diag_icd10_type_id='1'
       LEFT JOIN b_icd10 ON b_icd10.icd10_number = t_diag_icd10.diag_icd10_number
       LEFT JOIN b_visit_clinic ON t_diag_icd10.b_visit_clinic_id = b_visit_clinic.b_visit_clinic_id
where substring(t_visit_refer_in_out.record_date_time,1,10) between substring('2559-05-14',1,10) AND substring('2559-05-14',1,10)

--where substring(t_visit_refer_in_out.record_date_time,1,10) between substring(?,1,10) AND substring(?,1,10)
 ORDER BY t_visit_refer_in_out.record_date_time