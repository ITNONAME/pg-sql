--รายชื่อผู้ป่วยนอกเครือข่าย ใน จังหวัดพังงา 
SELECT
  'จำนวนผู้ป่วย ' as รายการ  
   ,count(DISTINCT p1.hn) as คน
	,count(distinct (case when p1.main_hosp='11347' then p1.hn end)) as "11347 เกาะยาว,รพช."
	,count(distinct (case when p1.main_hosp='11348' then p1.hn end)) as "11348 กะปง,รพช."
	,count(distinct (case when p1.main_hosp='11349' then p1.hn end)) as "11349 ตะกั่วทุ่ง,รพช"
	,count(distinct (case when p1.main_hosp='11350' then p1.hn end)) as "11350 บางไทร,รพช."
	,count(distinct (case when p1.main_hosp='11352' then p1.hn end)) as "11352 คุระบุรี,รพช."
	,count(distinct (case when p1.main_hosp='11353' then p1.hn end)) as "11353 ทับปุด,รพช."
	,count(distinct (case when p1.main_hosp='10739' then p1.hn end)) as "10739 พังงา,รพท"
	,count(distinct (case when p1.main_hosp='10740' then p1.hn end)) as "10740 ตะกั่วป่า,รพท."
FROM(
SELECT
         CASE WHEN (length(query1.dateVisit)>=10)
THEN to_char(to_date(to_number(substr(query1.dateVisit,1,4),'9999') || substr(query1.dateVisit,5,6),'yyyy-mm-dd'),'dd-mm-yyyy')
ELSE ''
END AS วันรับบริการ
        ,query1.visit_hn as HN
		-- ,query1.visit_vn as VN
		 ,query1.patient_prefix_description ||''|| query1.patient_firstname ||' '||  query1.patient_lastname  as ชือผู้รับบริการ
	   ,query1.patient_pid as เลขบัตรประชาชน
	 ,query1.contract_plans_description as PTTYPE
         ,query1.visit_payment_card_number as เลขบัตร
		 ,query1.visit_payment_main_hospital as main_hosp
		 ,query1.visit_payment_sub_hospital as sub_hosp
 ,((query1.pdx) ||(query1.como)) AS ICD10
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
 ,query1.billing_paid  AS ชำระจริง
    ,query1.billing_remain  AS ค้าง
  FROM (SELECT  distinct
   t_visit.visit_hn, t_visit.visit_vn, f_patient_prefix.patient_prefix_description, t_patient.patient_firstname, t_patient.patient_lastname
  , t_patient.patient_pid, concat_icd10_2(t_visit.t_visit_id,'1') as pdx,concat_icd10_2(t_visit.t_visit_id,'2') as como,t_diag_icd9.diag_icd9_icd9_number, t_order.t_order_id, t_order.order_price, t_order.order_qty,(t_order.order_price * t_order.order_qty) AS Price
 ,b_item_16_group.item_16_group_number	, b_contract_plans.contract_plans_description
        ,t_visit_payment.visit_payment_card_number 
		,t_visit_payment.visit_payment_main_hospital 
		,t_visit_payment.visit_payment_sub_hospital 
, SUBSTRING(t_visit.visit_begin_visit_time,1,16) AS dateVisit 
  ,sum(t_billing.billing_paid)  AS billing_paid
    ,sum(t_billing.billing_remain)  AS billing_remain 
FROM
    t_patient  INNER JOIN t_visit  ON (t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <> '4' )
            INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id  AND t_visit_payment.visit_payment_priority = '0'  AND t_visit_payment.visit_payment_active='1')
             inner join b_visit_office  as b1 on b1.b_visit_office_id = t_visit_payment.visit_payment_sub_hospital
              inner join b_visit_office as b2 on b2.b_visit_office_id = t_visit_payment.visit_payment_main_hospital
            INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id   
 INNER JOIN t_diag_icd10	ON (t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.f_diag_icd10_type_id = '1' AND  t_diag_icd10.diag_icd10_active = '1' )
        LEFT  JOIN  t_diag_icd9 ON (t_visit.t_visit_id = t_diag_icd9.diag_icd9_vn AND t_diag_icd9.diag_icd9_active ='1' AND t_diag_icd9.f_diagnosis_operation_type_id = '1')                                                 
           INNER JOIN t_billing ON (t_billing.t_visit_id = t_visit.t_visit_id AND t_billing.billing_active = '1')
                 LEFT JOIN f_patient_prefix ON f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id 
          INNER JOIN t_order ON (t_visit.t_visit_id = t_order.t_visit_id AND t_order.f_order_status_id <> '3')  
 INNER JOIN b_item ON t_order.b_item_id = b_item.b_item_id 
   INNER JOIN b_item_16_group ON b_item.b_item_16_group_id =b_item_16_group.b_item_16_group_id  

WHERE b_contract_plans.b_contract_plans_id in ('212000008919672804','2120000000019','2120000000028','2120000000021','2120000000022',
'212113549808215961','212113540105814574','2120000000013','212113543090706951',
'212113549940502508','2120000000010','2120000000035','212113546023828807','212113540927281070',
'212113542262532145','212113549893612557','212113544087470497','2120000000032',
'212113546901375997','212113546059199998','212113547276983024')  --กำหนด id ตามสิทธิที่ต้องการออกรายงาน
            AND t_visit.f_visit_type_id = '0' --เลือก 1 ผู้ป่วยใน 0 ผู้ป่วยนอก
            and t_visit_payment.visit_payment_main_hospital in ('11349','10739','11352','11350','10740','11353','11348','11347')   
        --    and t_visit_payment.visit_payment_main_hospital = '10739' -- 10739 พังงา
        --    and t_visit_payment.visit_payment_main_hospital = '11354' -- 11354 ท้ายเหมือง
        --    and t_visit_payment.visit_payment_main_hospital = '11352' -- 11352 คุระบุรี,รพช.
        --    and t_visit_payment.visit_payment_main_hospital = '11350' --11350 บางไทร,รพช.
        --    and t_visit_payment.visit_payment_main_hospital = '10740' --10740 ตะกั่วป่า,รพท.
        --    and t_visit_payment.visit_payment_main_hospital = '11353' --11353 ทับปุด,รพช.
        --    and t_visit_payment.visit_payment_main_hospital = '11348' --11348 กะปง,รพช.
        --    and t_visit_payment.visit_payment_main_hospital = '11347' --11347 เกาะยาว,รพช.
       --     and t_visit_payment.visit_payment_main_hospital = '11349' --11349 ตะกั่วทุ่ง,รพช.
       
           -- AND  t_visit_payment.visit_payment_main_hospital not in (Select  hospital_incup_code from r_hospital_incup)
 	         --  AND t_visit_payment.visit_payment_sub_hospital   NOT IN (Select  hospital_incup_code from r_hospital_incup)  -- เอาออก คิวรี่ ออกมาเยอะกว่าน่ะ
            AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring('2558-10-01',1,10) and substring('2559-09-30',1,10)--วันที่รับบริการ 
						--AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring(?,1,10) and substring(?,1,10)--วันที่รับบริการ 
GROUP BY  t_visit.visit_hn, t_visit.visit_vn, f_patient_prefix.patient_prefix_description, t_patient.patient_firstname, t_patient.patient_lastname ,t_visit_payment.visit_payment_card_number
  , t_patient.patient_pid, t_order.t_order_id,t_visit_payment.visit_payment_main_hospital ,t_visit_payment.visit_payment_sub_hospital , pdx, como,t_diag_icd9.diag_icd9_icd9_number
, t_order.order_price, t_order.order_qty, Price ,b_item_16_group.item_16_group_number, b_contract_plans.contract_plans_description ,  dateVisit 
) AS query1 
 GROUP BY  datevisit  ,ชือผู้รับบริการ ,patient_pid ,visit_hn ,PTTYPE
        ,เลขบัตร,main_hosp,sub_hosp,ICD10 , ชำระจริง, ค้าง 
ORDER BY  dateVisit
) as p1