--manage009รายชื่อลูกหนี้ค่ารักษา-OPD-UC(ในCUP)
/*
2120000000009	เด็ก 0-12 ปี  ใน CUP
212000002342769512	ครอบครัว อสม. ใน CUP
2120000000018	อสม. ใน CUP
2120000000027	ผู้พิการ ใน CUP
2120000000022	ผู้นำชุมชน ใน CUP
2120000000042	ครอบครัวผู้นำชุมชน ใน CUP
2120000000014	พระภิกษุ / ผู้นำศาสนา ใน CUP
2120000000012	ผู้สูงอายุ  ใน CUP
212113544678261930	เสียค่าธรรมเนียม 30 บาท ใน CUP
212113542429178397	ครอบครัวผู้นำศาสนา ใน cup
2120000000034	นักเรียนมัธยมต้น ใน CUP
2120000000031	ผู้มีรายได้น้อย ใน CUP
2120000000041	อนุเคราะห์ ฟรี. ใน CUP
212113548271151416	ผู้พำนักในสถานที่ราชการ(ราชทัณฑ์)ใน cup
212113542162512911	ครอบครัวทหารผ่านศึก(ชั้น1-3)ในCUP
212113545577567248	ครอบครัวทหารผ่านศึก(ชั้น4)ในCup
212113549028875746	ทหารเกณฑ์ ในCup
212113549130332085	ทหารผ่านศึก(ชั้น4)ในCup
212113541291638550	ครอบครัวทหาร(ชั้น1-3)ในCup
2120000000030	ทหารผ่านศึก(ชั้น1-3)ในCUP
212113548961258055	ทหารพรานในCup
2121340126613	ผู้มีสิทธิลดหย่อนตามระเบียบสาธารณสุข
*/
SELECT query1.dateVisit as วันรับบริการ
--CASE WHEN (length(query1.dateVisit)>=10)
--THEN to_char(to_date(to_number(substr(query1.dateVisit,1,4),'9999') || substr(query1.dateVisit,5,6),'yyyy-mm-dd'),'dd-mm-yyyy')
--ELSE ''END AS วันรับบริการ
  ,query1.visit_hn AS HN
  ,query1.visit_vn AS VN
   ,query1.patient_pid AS pid
   ,query1.patient_payment_card_number as หมายเลขบัตร
   ,query1.patient_prefix_description || '' || query1.patient_firstname || '   ' || query1.patient_lastname  AS  ชื่อผู้ป่วย
--  ,query1.diag_icd10_number AS ICD10
,((query1.pdx) ||(query1.como)||(query1.compli) ||(query1.other) ||(query1.exc) ||(query1.addit)||(query1.mor)) AS ICD10
  , query1.employee_number AS แพทย์ผู้ตรวจ
--  , query1.contract_plans_description as สิทธิ
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = '1' 
THEN cast(query1.Price as numeric) 
ELSE 0 END) AS ค่าห้องและค่าอาหาร
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = '2' 
THEN cast(query1.Price as numeric) 
ELSE 0 END) AS ค่าอวัยวะเทียมและอุปกรณ์ในการบำบัดรักษาโรค
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = '3' 
THEN cast(query1.Price as numeric) 
ELSE 0 END) AS ค่ายาและสารอาหารทางเส้นเลือด
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = '4_OH' 
THEN cast(query1.Price as numeric)
ELSE 0 END) AS ค่ายากลับบ้าน
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = '5' 
THEN cast(query1.Price as numeric)
ELSE 0.00 END) AS ค่าเวชภัณฑ์ที่มิใช่ยา
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = '6' 
THEN cast(query1.Price as numeric) 
ELSE 0 END) AS ค่าบริการโลหิตและส่วนประกอบของเลือด
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = '7' 
THEN cast(query1.Price as numeric)
ELSE 0 END) AS ค่าตรวจวินิจฉัยทางเทคนิคการแพทย์และพยาธิวิทยา
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = '8' 
THEN cast(query1.Price as numeric)
ELSE 0 END) AS ค่าตรวจวินิจฉัยและรักษาทางรังสีวิทยา
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = '9' 
THEN cast(query1.Price as numeric)
ELSE 0 END) AS ค่าตรวจวินิจฉัยโดยวิธีพิเศษอื่นๆ
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = 'A' 
THEN cast(query1.Price as numeric) 
ELSE 0 END) AS ค่าอุปกรณ์ของใช้และเครื่องมือทางการแพทย์
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = 'B' 
THEN cast(query1.Price as numeric)
ELSE 0 END) AS ค่าทำหัตถการและวิสัญญี
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = 'C' 
THEN cast(query1.Price as numeric) 
ELSE 0 END) AS ค่าบริการทางการพยาบาล
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = 'D' 
THEN cast(query1.Price as numeric)
ELSE 0 END) AS ค่าบริการทางทันตกรรม
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = 'E' 
THEN cast(query1.Price as numeric)
ELSE 0 END) AS ค่าบริการทางกายภาพบำบัดและทางเวชกรรมฟื้นฟู
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = 'F' 
THEN cast(query1.Price as numeric)
ELSE 0 END) AS ค่าบริการฝังเข็มและค่าบริการการให้การบำบัดของผู้ประกอบโรคศิลปะอื่นๆ
,SUM(CASE WHEN TRIM(query1.item_16_group_number) = 'G' 
THEN cast(query1.Price as numeric) 
ELSE 0 END) AS ค่าบริการอื่นๆที่ไม่เกี่ยวกับการรักษาพยาบาล
,sum(cast(query1.Price as numeric))AS รวม
,query1.payer_share as สิทธิชำระให้
 ,query1.billing_paid  AS ชำระจริง
    ,query1.billing_remain  AS ค้าง
FROM 
        (SELECT  distinct
t_visit.visit_hn, t_visit.visit_vn, f_patient_prefix.patient_prefix_description, t_patient.patient_firstname, t_patient.patient_lastname,t_patient_payment.patient_payment_card_number
  , t_patient.patient_pid   ,t_patient.patient_birthday , b_employee.employee_number,concat_icd10_2(t_visit.t_visit_id,'1') as pdx,concat_icd10_2(t_visit.t_visit_id,'2') as como,
concat_icd10_2(t_visit.t_visit_id,'3') as compli,concat_icd10_2(t_visit.t_visit_id,'4') as other,concat_icd10_2(t_visit.t_visit_id,'5') as exc,
concat_icd10_2(t_visit.t_visit_id,'6') as addit,concat_icd10_2(t_visit.t_visit_id,'7') as mor,t_diag_icd9.diag_icd9_icd9_number , t_order.t_order_id
, t_order.order_price, t_order.order_qty,(t_order.order_price * t_order.order_qty) AS Price ,b_item_16_group.item_16_group_number
, b_contract_plans.contract_plans_description AS contract_plans_description 
, SUBSTRING(t_visit.visit_begin_visit_time,1,16) AS dateVisit
,sum(t_billing.billing_payer_share) as payer_share 
   ,sum(t_billing.billing_paid)  AS billing_paid
    ,sum(t_billing.billing_remain)  AS billing_remain
      FROM
 t_visit INNER JOIN t_patient ON (t_visit.t_patient_id = t_patient.t_patient_id AND t_visit.f_visit_status_id <> '4') 
        INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id  AND t_visit_payment.visit_payment_priority = '0'  AND t_visit_payment.visit_payment_active='1')
          inner join t_patient_payment on  t_patient.t_patient_id = t_patient_payment.t_patient_id
INNER JOIN b_contract_plans ON (t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id )
        LEFT JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
        LEFT JOIN t_diag_icd10	ON (t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.f_diag_icd10_type_id = '1' AND  t_diag_icd10.diag_icd10_active = '1' )
        LEFT  JOIN  t_diag_icd9 ON (t_visit.t_visit_id = t_diag_icd9.diag_icd9_vn AND t_diag_icd9.diag_icd9_active ='1' AND t_diag_icd9.f_diagnosis_operation_type_id = '1')
        LEFT JOIN b_employee	ON b_employee.b_employee_id = t_diag_icd10.diag_icd10_staff_doctor
      INNER JOIN t_billing ON (t_visit.t_visit_id = t_billing.t_visit_id AND t_billing.billing_active = '1')
      INNER JOIN t_order ON (t_visit.t_visit_id = t_order.t_visit_id AND t_order.f_order_status_id <> '3')  
INNER JOIN b_item ON t_order.b_item_id = b_item.b_item_id 
   INNER JOIN b_item_16_group ON b_item.b_item_16_group_id =b_item_16_group.b_item_16_group_id        
WHERE       
  t_visit_payment.b_contract_plans_id in   ('2120000000009','212000002342769512','2120000000018','2120000000027','2120000000022','2120000000042','2120000000014',
'2120000000012','212113544678261930','212113542429178397','2120000000034','2120000000031','2120000000041','212113548271151416','212113542162512911',
'212113545577567248','212113549028875746','212113549130332085','212113541291638550','2120000000030','212113548961258055','2121340126613') --กำหนด id ตามสิทธิที่ต้องการออกรายงาน
 AND t_visit.visit_money_discharge_status = '1'
AND t_visit.f_visit_type_id = '0' --เลือก 1 ผู้ป่วยใน 0 ผู้ป่วยนอก
       --AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring(?,1,10) and substring(?,1,10)--วันที่รับบริการ
       AND substring(t_visit.visit_begin_visit_time,1,10)   
				between  substring('2558-10-01',1,10) AND substring('2559-09-30',1,10)  
GROUP BY  t_visit.visit_hn, t_visit.visit_vn, f_patient_prefix.patient_prefix_description, t_patient.patient_firstname, t_patient.patient_lastname,t_patient_payment.patient_payment_card_number
  , t_patient.patient_pid   ,t_patient.patient_birthday , b_employee.employee_number,pdx, como ,compli, other, exc, addit, mor,t_diag_icd9.diag_icd9_icd9_number , t_order.t_order_id
, t_order.order_price, t_order.order_qty, Price ,b_item_16_group.item_16_group_number
, b_contract_plans.contract_plans_description 
,  dateVisit 
) AS query1 
GROUP BY  datevisit  ,ชื่อผู้ป่วย ,patient_pid ,visit_hn,visit_vn , pdx, como ,compli, other, exc, addit, mor,employee_number 
   ,diag_icd9_icd9_number ,employee_number  , ชำระจริง, ค้าง  , หมายเลขบัตร , สิทธิชำระให้ , vn
ORDER BY  dateVisit 
