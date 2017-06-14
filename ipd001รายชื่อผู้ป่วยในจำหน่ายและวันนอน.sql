--ipd001รายชื่อผู้ป่วยในจำหน่ายและวันนอน

SELECT distinct
t_patient.patient_hn as "HN", t_visit.visit_vn as "AN"
,f_patient_prefix.patient_prefix_description || '' || t_patient.patient_firstname || '   ' || t_patient.patient_lastname as ชื่อผู้ป่วย
,t_visit.visit_patient_age as อายุ
,t_visit.visit_begin_admit_date_time AS admit 
,t_visit.visit_staff_doctor_discharge_date_time AS ipd_discharge
,t_visit.visit_financial_discharge_time AS วันจำหน่ายทางการเงิน
,b_contract_plans.contract_plans_description as สิทธิการรักษา
,sum(t_billing_invoice.billing_invoice_total) AS ค่ารักษา
,(case when (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
    to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD')) = 0
            then 1
            else (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
    to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD'))
    end) as วันนอน
,t_visit.visit_bed As เตียง
,b_visit_ward.visit_ward_description As ward
FROM t_visit
        INNER JOIN t_patient ON t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <>'4' AND t_visit.f_visit_type_id = '1' 
        INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
        INNER JOIN b_visit_ward ON t_visit.b_visit_ward_id = b_visit_ward.b_visit_ward_id
        LEFT JOIN t_visit_payment ON t_visit.t_visit_id = t_visit_payment.t_visit_id 
                                        AND t_visit_payment.visit_payment_priority ='0' AND t_visit_payment.visit_payment_active ='1'
        LEFT JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id 
        LEFT JOIN t_billing_invoice ON t_billing_invoice.t_visit_id = t_visit_payment.t_visit_id AND t_billing_invoice.billing_invoice_active ='1'
				left join t_diag_tdrg on t_visit.t_visit_id = t_diag_tdrg.t_visit_id                                              
WHERE  
substr(t_visit.visit_financial_discharge_time,1,10) between  substring('2559-02-01',1,10) and substring('2559-02-31',1,10) 
--substr (t_visit.visit_financial_discharge_time,1,10) between  substring(?,1,10) and substring(?,1,10)
GROUP by "HN","AN",ชื่อผู้ป่วย,อายุ,admit,ipd_discharge,วันจำหน่ายทางการเงิน,สิทธิการรักษา,วันนอน,เตียง,ward
ORDER BY  วันจำหน่ายทางการเงิน
