-- eGFR-< 4 state 3-5
SELECT  distinct(t_patient.patient_hn) as hn
 --,substring(t_visit.visit_begin_visit_time,1,10) as วันรับบริการ
 ,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '  ' || t_patient.patient_lastname AS ชื่อผู้ป่วย
 --,t_visit.visit_patient_age AS อายุ
 ,t_patient.patient_house as บ้านเลขที่
 ,t_patient.patient_moo as หมู่
 ,f1.address_description as ตำบล
 ,f2.address_description as อำเภอ
 ,f3.address_description as จังหวัด
,case  when t_diag_icd10.diag_icd10_number = 'N18.3' then 'CKD_ST3'
 when t_diag_icd10.diag_icd10_number= 'N18.4' then 'CKD_ST4'
 when t_diag_icd10.diag_icd10_number = 'N18.5' then 'CKD_ST5' end as  CKDST3_5
 --when t_diag_icd10.diag_icd10_number = 'N18.9' then 'ไม่ระบุ_ST' 
 --,t_diag_icd10.diag_icd10_number AS ICD10
 --,(case when trim(t_result_lab.result_lab_name) ilike '%eGFR%'  then result_lab_value else '' end) as "eGFR"
 ,case when q.egfr[1] <>'' then q.egfr[1] else '' end as "eGFR ครั้งที่ 1"
 ,case when q.egfr[2] <>'' then q.egfr[2] else '' end as "eGFR ครั้งที่ 2"
 ,case when q.egfr[3] <>'' then q.egfr[3] else '' end as "eGFR ครั้งที่ 3"
/*   ,case when t_visit.f_visit_type_id = '1' 
        then 'IPD' else 'OPD' end as ประเภท */

 FROM t_patient
         INNER join f_address as f1 on t_patient.patient_tambon = f1.f_address_id
         INNER join f_address as f2 on t_patient.patient_amphur = f2.f_address_id
         INNER join f_address as f3 on t_patient.patient_changwat = f3.f_address_id
         INNER JOIN t_visit ON t_patient.t_patient_id = t_visit.t_patient_id
         --INNER JOIN t_order ON (t_visit.t_visit_id = t_order.t_visit_id and f_order_status_id <> '3' )
         INNER join t_diag_icd10 on t_diag_icd10.diag_icd10_vn = t_visit.t_visit_id
/*          LEFT JOIN t_result_lab ON (t_order.t_order_id = t_result_lab.t_order_id 
                 and t_result_lab.result_lab_value <> '' 
                 and t_result_lab.result_lab_active ='1'
                 AND (trim(t_result_lab.result_lab_name) ilike '%eGFR%'))  */       
         LEFT JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
         left join (select 
                t_visit.t_patient_id
                ,t_visit.visit_hn
                --,t_visit.visit_vn
                ,array_agg(case when trim(t_result_lab.result_lab_name) ilike '%eGFR%'  
                    then result_lab_value else '' end) as egfr

            from t_order
                left join t_visit on t_visit.t_visit_id = t_order.t_visit_id
                left join t_result_lab ON (t_order.t_order_id = t_result_lab.t_order_id 
                    and t_result_lab.result_lab_value <> '' 
                    and t_result_lab.result_lab_active ='1'
                    and (trim(t_result_lab.result_lab_name) ilike '%eGFR%')) 

            where t_result_lab.result_lab_name ilike '%eGFR%'
                and f_order_status_id <> '3'
                and  substr(t_visit.visit_begin_visit_time,1,10) between '2558-10-01' and '2559-03-31'
                --and substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)
                --and t_visit.visit_hn='520000133'
            group by t_visit.t_patient_id
                ,t_visit.visit_hn
               -- ,t_visit.visit_vn
         ) as q on q.t_patient_id = t_visit.t_patient_id

WHERE 
 substring(t_visit.visit_begin_visit_time,1,10) between '2558-10-01' and '2559-03-31'
-- substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)
 and t_diag_icd10.diag_icd10_number  in ('N18.3','N18.4','N18.5')        
 --and (t_order.order_common_name ilike '%eGFR%')
  --and t_visit.visit_hn='520000133'
GROUP BY
hn,ชื่อผู้ป่วย,บ้านเลขที่,หมู่,ตำบล,อำเภอ,จังหวัด,"eGFR ครั้งที่ 1","eGFR ครั้งที่ 2" ,"eGFR ครั้งที่ 3",CKDST3_5