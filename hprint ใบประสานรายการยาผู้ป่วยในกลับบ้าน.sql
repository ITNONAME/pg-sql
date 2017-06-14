select t_order.order_common_name as name
,b_item_drug_instruction.item_drug_instruction_description|| '  ' ||t_order_drug.order_drug_dose|| '  ' ||b_item_drug_uom.item_drug_uom_description||' '||b_item_drug_frequency.item_drug_frequency_description  as use
,b_item_drug.item_drug_caution as wait
,patient_prefix_description || t_patient.patient_firstname || ' ' || t_patient.patient_lastname AS nn
,t_visit.visit_patient_age as age
,t_visit.visit_hn as hn
,t_visit.visit_vn as an
--,t_patient.t_patient_id as ptid
--,t_patient_drug_allergy.f_allergy_warning_type_id as ty
,case when t_patient_drug_allergy.f_allergy_warning_type_id='1' 
then array_to_string(array_agg(DISTINCT b_item_drug_standard.item_drug_standard_description),' , ')
else '' END as t1
,case when t_patient_drug_allergy.f_allergy_warning_type_id='2' 
then array_to_string(array_agg(DISTINCT b_item_drug_standard.item_drug_standard_description),' , ')
else '' END as t2
,case when t_patient_drug_allergy.f_allergy_warning_type_id='3' 
then array_to_string(array_agg(DISTINCT b_item_drug_standard.item_drug_standard_description),' , ')
else '' END as t3
--,array_to_string(array_agg(DISTINCT b_item_drug_standard.item_drug_standard_description),' , ') as drug_allergy
from t_order
left join t_order_drug on (t_order.t_order_id = t_order_drug.t_order_id  and t_order_drug.order_drug_active = '1')
left join t_visit on t_visit.t_visit_id = t_order.t_visit_id
left join t_patient on t_patient.t_patient_id = t_visit.t_patient_id
left join b_item_drug_frequency on t_order_drug.b_item_drug_frequency_id = b_item_drug_frequency.b_item_drug_frequency_id
left join b_item_drug_instruction on t_order_drug.b_item_drug_instruction_id = b_item_drug_instruction.b_item_drug_instruction_id
left join b_item on t_order.b_item_id = b_item.b_item_id
left join b_item_drug on b_item.b_item_id = b_item_drug.b_item_id
left join b_item_drug_uom on t_order_drug.b_item_drug_uom_id_use = b_item_drug_uom.b_item_drug_uom_id
left join f_patient_prefix on f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id

left join t_patient_drug_allergy on t_patient.t_patient_id = t_patient_drug_allergy.t_patient_id
left join b_item_drug_standard on t_patient_drug_allergy.b_item_drug_standard_id = b_item_drug_standard.b_item_drug_standard_id

where t_order_drug.order_drug_active = '1'
and t_order.order_home = '1'
and t_order.f_order_status_id <>'3'
and t_visit.t_visit_id = '255113540318625695'--$P{visit_id}
GROUP BY
name
,use
,wait
,nn
,age
,hn
,an
--,ptid
--,ty
,f_allergy_warning_type_id