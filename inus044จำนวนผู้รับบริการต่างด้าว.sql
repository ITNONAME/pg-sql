--inus044จำนวนผู้รับบริการต่างด้าว
select  'จำนวนต่างด้าว(ไม่มีบัตรIPD)' as รายการ
            ,count(distinct p1.hn) as คน  
            ,count(p1.vn) as ครั้ง 
,sum(p1.ค่ารักษา) as ค่ารักษา
,sum(p1.สิทธิชำระให้) as สิทธิชำระให้
,sum(p1.ผู้ป่วยต้องชำระ) as ผู้ป่วยต้องชำระ
,sum(p1.ผู้ป่วยจ่ายแล้วเท่าไร) as ผู้ป่วยจ่ายแล้วเท่าไร
,sum(p1.ค้างอยู่เท่าไร) as ค้างอยู่เท่าไร
from(select
     t_visit.visit_hn AS HN
   ,t_visit.visit_vn as vn
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_patient.patient_pid AS PID
    ,t_visit.visit_begin_visit_time as วันรับบริการ
    ,t_visit.visit_financial_discharge_time AS วันจำหน่าย
    ,b_contract_plans.contract_plans_description as สิทธิ
    ,t_billing.billing_total as ค่ารักษา
    ,t_billing.billing_payer_share as สิทธิชำระให้
    ,t_billing.billing_patient_share as	ผู้ป่วยต้องชำระ
    ,t_billing.billing_paid as ผู้ป่วยจ่ายแล้วเท่าไร
    ,t_billing.billing_remain as ค้างอยู่เท่าไร

FROM
    t_patient  INNER JOIN t_visit  ON t_patient.t_patient_id = t_visit.t_patient_id
            INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
            INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id                                                       
            LEFT JOIN t_billing ON (t_billing.t_visit_id = t_visit.t_visit_id AND t_billing.billing_active = '1')
            LEFT JOIN f_patient_prefix ON (f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id AND f_patient_prefix.active ='1')
         --  inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2404095259815' --08.ห้องทันตกรรม
WHERE   b_contract_plans.b_contract_plans_id ='212000002594847647' 
            and t_visit.f_visit_type_id = '1' --เลือก 1 ผู้ป่วยใน 0 ผู้ป่วยนอก
--and    t_billing.billing_remain not in ( '0')
            AND  t_visit_payment.visit_payment_priority = '0'
            AND t_visit.f_visit_status_id <> '4'
         --AND SUBSTRING(t_visit.visit_begin_visit_time,1,10) between substr('2555-10-01',1,10) and substr('2556-09-30',1,10)
and substring(t_visit.visit_begin_visit_time,1,10) between '2557-10-01' and '2558-09-30'
     --   AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring(?,1,10) and substring(?,1,10)--วันที่รับบริการ 
group by  HN, vn,คำนำ,ชื่อ,สกุล,PID,วันรับบริการ,วันจำหน่าย,สิทธิ ,ค่ารักษา,สิทธิชำระให้ ,ผู้ป่วยต้องชำระ ,ผู้ป่วยจ่ายแล้วเท่าไร,ค้างอยู่เท่าไร
ORDER BY วันรับบริการ
)as p1
UNION
select  'จำนวนต่างด้าว(ไม่มีบัตรOPD)' as รายการ
            ,count(distinct p1.hn) as คน  
            ,count(p1.vn) as ครั้ง 
,sum(p1.ค่ารักษา) as ค่ารักษา
,sum(p1.สิทธิชำระให้) as สิทธิชำระให้
,sum(p1.ผู้ป่วยต้องชำระ) as ผู้ป่วยต้องชำระ
,sum(p1.ผู้ป่วยจ่ายแล้วเท่าไร) as ผู้ป่วยจ่ายแล้วเท่าไร
,sum(p1.ค้างอยู่เท่าไร) as ค้างอยู่เท่าไร
from(select
     t_visit.visit_hn AS HN
   ,t_visit.visit_vn as vn
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_patient.patient_pid AS PID
    ,t_visit.visit_begin_visit_time as วันรับบริการ
    ,t_visit.visit_financial_discharge_time AS วันจำหน่าย
    ,b_contract_plans.contract_plans_description as สิทธิ
    ,t_billing.billing_total as ค่ารักษา
    ,t_billing.billing_payer_share as สิทธิชำระให้
    ,t_billing.billing_patient_share as	ผู้ป่วยต้องชำระ
    ,t_billing.billing_paid as ผู้ป่วยจ่ายแล้วเท่าไร
    ,t_billing.billing_remain as ค้างอยู่เท่าไร

FROM
    t_patient  INNER JOIN t_visit  ON t_patient.t_patient_id = t_visit.t_patient_id
            INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
            INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id                                                       
            LEFT JOIN t_billing ON (t_billing.t_visit_id = t_visit.t_visit_id AND t_billing.billing_active = '1')
            LEFT JOIN f_patient_prefix ON (f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id AND f_patient_prefix.active ='1')
         --  inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2404095259815' --08.ห้องทันตกรรม
WHERE   b_contract_plans.b_contract_plans_id ='212000002594847647' 
            and t_visit.f_visit_type_id = '0' --เลือก 1 ผู้ป่วยใน 0 ผู้ป่วยนอก
--and    t_billing.billing_remain not in ( '0')
            AND  t_visit_payment.visit_payment_priority = '0'
            AND t_visit.f_visit_status_id <> '4'
         --AND SUBSTRING(t_visit.visit_begin_visit_time,1,10) between substr('2555-10-01',1,10) and substr('2556-09-30',1,10)
and substring(t_visit.visit_begin_visit_time,1,10) between '2557-10-01' and '2558-09-30'
     --   AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring(?,1,10) and substring(?,1,10)--วันที่รับบริการ 
group by  HN, vn,คำนำ,ชื่อ,สกุล,PID,วันรับบริการ,วันจำหน่าย,สิทธิ ,ค่ารักษา,สิทธิชำระให้ ,ผู้ป่วยต้องชำระ ,ผู้ป่วยจ่ายแล้วเท่าไร,ค้างอยู่เท่าไร
ORDER BY วันรับบริการ
)as p1
UNION
select  'จำนวนต่างด้าว(มีบัตรOPD)' as รายการ
            ,count(distinct p1.hn) as คน  
            ,count(p1.vn) as ครั้ง 
,sum(p1.ค่ารักษา) as ค่ารักษา
,sum(p1.สิทธิชำระให้) as สิทธิชำระให้
,sum(p1.ผู้ป่วยต้องชำระ) as ผู้ป่วยต้องชำระ
,sum(p1.ผู้ป่วยจ่ายแล้วเท่าไร) as ผู้ป่วยจ่ายแล้วเท่าไร
,sum(p1.ค้างอยู่เท่าไร) as ค้างอยู่เท่าไร
from(select
     t_visit.visit_hn AS HN
   ,t_visit.visit_vn as vn
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_patient.patient_pid AS PID
    ,t_visit.visit_begin_visit_time as วันรับบริการ
    ,t_visit.visit_financial_discharge_time AS วันจำหน่าย
    ,b_contract_plans.contract_plans_description as สิทธิ
    ,t_billing.billing_total as ค่ารักษา
    ,t_billing.billing_payer_share as สิทธิชำระให้
    ,t_billing.billing_patient_share as	ผู้ป่วยต้องชำระ
    ,t_billing.billing_paid as ผู้ป่วยจ่ายแล้วเท่าไร
    ,t_billing.billing_remain as ค้างอยู่เท่าไร

FROM
    t_patient  INNER JOIN t_visit  ON t_patient.t_patient_id = t_visit.t_patient_id
            INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
            INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id                                                       
            LEFT JOIN t_billing ON (t_billing.t_visit_id = t_visit.t_visit_id AND t_billing.billing_active = '1')
            LEFT JOIN f_patient_prefix ON (f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id AND f_patient_prefix.active ='1')
         --  inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2404095259815' --08.ห้องทันตกรรม
WHERE   b_contract_plans.b_contract_plans_id in ('2120000000039','212113547107760953')
            and t_visit.f_visit_type_id = '0' --เลือก 1 ผู้ป่วยใน 0 ผู้ป่วยนอก
--and    t_billing.billing_remain not in ( '0')
            AND  t_visit_payment.visit_payment_priority = '0'
            AND t_visit.f_visit_status_id <> '4'
         --AND SUBSTRING(t_visit.visit_begin_visit_time,1,10) between substr('2555-10-01',1,10) and substr('2556-09-30',1,10)
and substring(t_visit.visit_begin_visit_time,1,10) between '2557-10-01' and '2558-09-30'
     --   AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring(?,1,10) and substring(?,1,10)--วันที่รับบริการ 
group by  HN, vn,คำนำ,ชื่อ,สกุล,PID,วันรับบริการ,วันจำหน่าย,สิทธิ ,ค่ารักษา,สิทธิชำระให้ ,ผู้ป่วยต้องชำระ ,ผู้ป่วยจ่ายแล้วเท่าไร,ค้างอยู่เท่าไร
ORDER BY วันรับบริการ
)as p1
UNION
select  'จำนวนต่างด้าว(มีบัตรIPD)' as รายการ
            ,count(distinct p1.hn) as คน  
            ,count(p1.vn) as ครั้ง 
,sum(p1.ค่ารักษา) as ค่ารักษา
,sum(p1.สิทธิชำระให้) as สิทธิชำระให้
,sum(p1.ผู้ป่วยต้องชำระ) as ผู้ป่วยต้องชำระ
,sum(p1.ผู้ป่วยจ่ายแล้วเท่าไร) as ผู้ป่วยจ่ายแล้วเท่าไร
,sum(p1.ค้างอยู่เท่าไร) as ค้างอยู่เท่าไร
from(select
     t_visit.visit_hn AS HN
   ,t_visit.visit_vn as vn
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_patient.patient_pid AS PID
    ,t_visit.visit_begin_visit_time as วันรับบริการ
    ,t_visit.visit_financial_discharge_time AS วันจำหน่าย
    ,b_contract_plans.contract_plans_description as สิทธิ
    ,t_billing.billing_total as ค่ารักษา
    ,t_billing.billing_payer_share as สิทธิชำระให้
    ,t_billing.billing_patient_share as	ผู้ป่วยต้องชำระ
    ,t_billing.billing_paid as ผู้ป่วยจ่ายแล้วเท่าไร
    ,t_billing.billing_remain as ค้างอยู่เท่าไร

FROM
    t_patient  INNER JOIN t_visit  ON t_patient.t_patient_id = t_visit.t_patient_id
            INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
            INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id                                                       
            LEFT JOIN t_billing ON (t_billing.t_visit_id = t_visit.t_visit_id AND t_billing.billing_active = '1')
            LEFT JOIN f_patient_prefix ON (f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id AND f_patient_prefix.active ='1')
         --  inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2404095259815' --08.ห้องทันตกรรม
WHERE   b_contract_plans.b_contract_plans_id in ('2120000000039','212113547107760953')
            and t_visit.f_visit_type_id = '1' --เลือก 1 ผู้ป่วยใน 0 ผู้ป่วยนอก
--and    t_billing.billing_remain not in ( '0')
            AND  t_visit_payment.visit_payment_priority = '0'
            AND t_visit.f_visit_status_id <> '4'
         --AND SUBSTRING(t_visit.visit_begin_visit_time,1,10) between substr('2555-10-01',1,10) and substr('2556-09-30',1,10)
and substring(t_visit.visit_begin_visit_time,1,10) between '2557-10-01' and '2558-09-30'
     --   AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring(?,1,10) and substring(?,1,10)--วันที่รับบริการ 
group by  HN, vn,คำนำ,ชื่อ,สกุล,PID,วันรับบริการ,วันจำหน่าย,สิทธิ ,ค่ารักษา,สิทธิชำระให้ ,ผู้ป่วยต้องชำระ ,ผู้ป่วยจ่ายแล้วเท่าไร,ค้างอยู่เท่าไร
ORDER BY วันรับบริการ
)as p1