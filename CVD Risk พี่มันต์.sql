select distinct(t_visit.visit_vn) as vn
,t_patient.patient_hn as hn
,t_patient.patient_firstname as fname
,t_patient.patient_lastname as lname
,t_result_lab.result_lab_name as Lname
,t_diag_icd10.diag_icd10_number as icd10
from t_visit 
INNER JOIN t_patient on t_visit.t_patient_id = t_patient.t_patient_id
INNER JOIN t_order on t_visit.t_visit_id = t_order.t_visit_id
INNER JOIN t_result_lab on t_visit.t_visit_id = t_result_lab.t_visit_id
INNER JOIN t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn
where t_visit.f_visit_status_id <> '4'
and t_patient.patient_active = '1'
and t_diag_icd10.diag_icd10_active = '1'
and t_result_lab.result_lab_name like 'CVD Risk'
and (t_diag_icd10.diag_icd10_number BETWEEN 'E10' and 'E14.9' 
or t_diag_icd10.diag_icd10_number BETWEEN 'I10' and 'I15.9')

and substring(t_visit.visit_begin_visit_time,1,10) between '2559-10-01' and '2559-12-31'
order by t_patient.patient_hn