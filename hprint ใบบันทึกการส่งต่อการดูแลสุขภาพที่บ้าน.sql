select distinct b_site.site_phone_number as phone_number
,f_patient_prefix.patient_prefix_description||''||t_patient.patient_firstname||'   '||t_patient.patient_lastname as name
,f_sex.sex_description as sex
,t_visit_payment.visit_payment_sub_hospital as sub
--,b_visit_office.visit_office_name as sub_name
,case when b_visit_office.visit_office_name='ท้ายเหมืองชัยพัฒน์,รพช.' then 'PCU รพ. '||b_visit_office.visit_office_name ELSE b_visit_office.visit_office_name END as sub_name
,t_visit.visit_patient_age as age
,t_patient.patient_hn as hn
,t_visit.visit_vn as an
,t_patient.patient_house as house
,t_patient.patient_moo as moo
,t_patient.patient_road as road
,a3.address_description as province
,a2.address_description as amphur
,a1.address_description as tambon
,t_order.order_common_name  as order1
,replace(t_visit.visit_dx,E'\n',',') AS dx
,b_item_drug_instruction.item_drug_instruction_description|| '' ||t_order_drug.order_drug_dose|| '' ||b_item_drug_uom.item_drug_uom_description|| '' ||b_item_drug_frequency.item_drug_frequency_description   as use1
,(select array
            (select t_visit_primary_symptom.visit_primary_symptom_current_illness
                from t_visit_primary_symptom
                where t_visit.t_visit_id = t_visit_primary_symptom.t_visit_id)) as symptom_current
--,array_to_string(ARRAY[t_visit.visit_dx],',','*') as dx
,substr(t_visit.visit_lock_date_time,9,2)||'/'||substr(t_visit.visit_lock_date_time,6,2)||'/'||substr(t_visit.visit_lock_date_time,1,4)as date
,(select array (select t_visit_discharge_advice.visit_discharge_advice_advice
                from  t_visit_discharge_advice
                where t_visit.t_visit_id = t_visit_discharge_advice.t_visit_id)) as advice

,t_visit_discharge_advice.visit_discharge_advice_advice as appointment
--,t_visit_discharge_advice.visit_discharge_advice_advice_head  = 'อื่นๆ'

,t_visit.visit_lock_date_time as time
,b.employee_firstname || ' ' || b.employee_lastname as print
,case when t_visit.visit_have_appointment = '1' then  substr(t_patient_appointment.patient_appointment_date,9,2)||'/'||substr(t_patient_appointment.patient_appointment_date,6,2)||'/'||substr(t_patient_appointment.patient_appointment_date,1,4)
       else 'ไม่มีการนัด' end as have_appointment
--,t_patient_appointment.patient_appointment as appointment
,(select array
            (select t_patient_personal_disease.patient_personal_disease_description
                from t_patient_personal_disease
                where t_patient_personal_disease.t_patient_id = t_patient.t_patient_id)) as disease
,t_patient.patient_contact_firstname || ' ' || t_patient.patient_lastname as contact_name
,t_patient.patient_contact_mobile_phone as phone
from t_patient
inner join t_visit on t_visit.t_patient_id = t_patient.t_patient_id
inner join t_visit_payment on t_visit_payment.t_visit_id = t_visit.t_visit_id
left join b_visit_office on b_visit_office.b_visit_office_id = t_visit_payment.visit_payment_sub_hospital
left join t_order on t_order.t_visit_id = t_visit.t_visit_id and t_order.f_item_group_id = '1'
left join t_order_drug on t_order_drug.t_order_id = t_order.t_order_id
left join b_item
on t_order.b_item_id = b_item.b_item_id
left join b_item_drug
on b_item.b_item_id = b_item_drug.b_item_id
left join b_item_drug_instruction
on b_item_drug.b_item_drug_instruction_id = b_item_drug_instruction.b_item_drug_instruction_id
left join b_item_drug_uom
on b_item_drug.item_drug_use_uom = b_item_drug_uom.b_item_drug_uom_id
left join b_item_drug_frequency
on b_item_drug_frequency.b_item_drug_frequency_id = b_item_drug.b_item_drug_frequency_id
left join t_visit_primary_symptom on t_visit.t_visit_id = t_visit_primary_symptom.t_visit_id
left join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
left join f_sex on t_patient.f_sex_id = f_sex.f_sex_id
--left join (select * from f_address) as changwat on changwat.f_address_id = t_patient.patient_changwat
--left join (select * from f_address) as amphur on amphur.f_address_id = t_patient.patient_amphur
--left join (select * from f_address) as tambon on tambon.f_address_id = t_patient.patient_tambon

left join f_address a1 on a1.f_address_id = t_patient.patient_tambon
left join f_address a2 on a2.f_address_id = t_patient.patient_amphur
left join f_address a3 on a3.f_address_id = t_patient.patient_changwat
left join b_employee as b on b.b_employee_id = t_visit.visit_staff_lock
left join t_visit_discharge_advice on t_visit.t_visit_id = t_visit_discharge_advice.t_visit_id
left join t_patient_appointment on t_patient_appointment.t_visit_id  = t_visit.t_visit_id
,b_site
where t_visit.t_visit_id = '255113542920377409'--$P{visit_id}
and t_order_drug.order_drug_order_status <>'3'
and t_order.order_home = '1'
and t_visit_discharge_advice.visit_discharge_advice_advice_head  = 'อื่นๆ'
and b_visit_office.visit_office_name <> ''
group by
 name
, sex
, age
, hn
, an
, house
, moo
, road
, province
, amphur
, tambon
, order1
, use1
, symptom_current
, dx
, phone_number
, sub
, sub_name
, date
, advice
, time
, print
, disease
, appointment
, have_appointment
,contact_name
,phone
order by order1