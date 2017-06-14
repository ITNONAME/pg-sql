select distinct 
t_patient.patient_hn as hn
,t_visit.visit_vn as vn
--,t_visit.t_visit_id as vid
--,t_visit.visit_begin_visit_time as วันที่เข้ารับบริการ
,t_visit.visit_begin_admit_date_time AS admit
,t_visit.visit_ipd_discharge_date_time AS ipd_discharge
,(case when (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
    to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD')) = 0
            then 1
            else (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
    to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD'))
    end) as วันนอน
,t_visit.visit_financial_discharge_time AS วันจำหน่ายทางการเงิน
,t_diag_tdrg.record_date_time as วันที่ลงDRG
,f_patient_prefix.patient_prefix_description|| ' ' || t_patient.patient_firstname || ' ' || t_patient.patient_lastname as  "ชื่อ-สกุล"
,t_visit.visit_patient_age as อายุ
,b_contract_plans.contract_plans_description as สิทธิการรักษา
,t_billing.billing_total AS ค่ารักษา

,t_diag_tdrg.adjrw as adjrw
--,t_visit.visit_bed as status
from t_visit 
inner join t_patient on  t_visit.t_patient_id = t_patient.t_patient_id
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
--inner join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn
left join t_billing ON t_billing.t_visit_id=t_visit.t_visit_id
			AND t_billing.billing_active = '1'
left join t_visit_vital_sign on t_visit_vital_sign.t_visit_id=t_visit.t_visit_id
left join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id=t_visit.t_visit_id
left join t_diag_tdrg on t_visit.t_visit_id = t_diag_tdrg.t_visit_id
        LEFT JOIN t_visit_payment ON t_visit.t_visit_id = t_visit_payment.t_visit_id 
						AND t_visit_payment.visit_payment_priority ='0'
						AND t_visit_payment.visit_payment_active ='1'
        LEFT JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id 
						and b_contract_plans.contract_plans_active='1'
where  t_visit.f_visit_status_id <> '4'
and t_visit.f_visit_type_id='1'
and t_visit.visit_bed = 'IPD Discharge'
--and t_diag_tdrg.adjrw is null
--and  substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)
and  substring(t_visit.visit_begin_visit_time,1,10) between substring('2560-01-01',1,10) and substring('2560-01-31',1,10)
group by 
hn
,vn
--,วันที่เข้ารับบริการ
,"ชื่อ-สกุล"
,อายุ
,สิทธิการรักษา
,วันนอน
,admit
,ipd_discharge
,วันจำหน่ายทางการเงิน
--,status
--,อาการสำคัญ
--,ประวัติปัจจุบัน
,adjrw
,วันที่ลงDRG
--,vid
,ค่ารักษา
ORDER BY
--ipd_discharge
"ชื่อ-สกุล"
