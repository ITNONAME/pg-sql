--OPD075รายชื่อผู้ป่วย DMรายใหม่ รพ
SELECT 
t.patient_hn AS HN
,f_patient_prefix.patient_prefix_description|| ' ' || t.patient_firstname || ' ' || t.patient_lastname as  "ชื่อ-สกุล"
,   date_part('year',age(cast(current_date as date)
        ,cast((cast(substring(t.patient_birthday,1,4) as numeric) - 543 
        || substring(t.patient_birthday,5))   as date)))   as "อายุ(ปี)"
 ,t.patient_pid AS เลขบัตรประชาชน
 ,t.patient_house as บ้านเลขที่
 , t.patient_moo as หมู่
 , f1.address_description as ตำบล
 , f2.address_description as อำเภอ
 ,f3.address_description as จังหวัด
,bng.ncd_group_description as description 
FROM t_patient t
INNER JOIN t_patient_ncd tpn on tpn.t_patient_id=t.t_patient_id
INNER JOIN b_ncd_group bng on bng.b_ncd_group_id=tpn.b_ncd_group_id
inner join f_patient_prefix ON t.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
 LEFT JOIN f_address as f1 ON t.patient_tambon = f1.f_address_id
 LEFT JOIN f_address as f2 ON t.patient_amphur =f2.f_address_id
 LEFT JOIN f_address as f3 ON t.patient_changwat= f3.f_address_id
WHERE 
--tpn.b_ncd_group_id='289113542235064925' --DMรพ
tpn.b_ncd_group_id='289113548725590889' --HTรพ
--WHERE tpn.b_ncd_group_id='289113549849011367' --HTรายใหม่ รพ
and substring(tpn.patient_ncd_record_date_time,1,10) between substring('2556-10-01',1,10) and substring('2560-09-30',1,10) 
--and substring(tpn.patient_ncd_record_date_time,1,10) between substring(?,1,10) and substring(?,1,10) 
and t.patient_active='1'

--LIMIT 10