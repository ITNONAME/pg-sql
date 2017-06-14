SELECT
b_site.b_visit_office_id AS HOSPCODE
,t_visit_refer_in_out.visit_refer_in_out_number AS REFERID
,'' AS REFERID_PROVINCE
,case when t_diag_icd9.diag_icd9_start_time <> ''
 then (to_number(substring(t_diag_icd9.diag_icd9_start_time,1,4),'9999')-543)       
			|| substring(t_diag_icd9.diag_icd9_start_time,6,2)       
			|| substring(t_diag_icd9.diag_icd9_start_time,9,2) ||replace(substring(t_diag_icd9.diag_icd9_start_time,12),':','')
 else '' end as TIMESTART

,case when t_diag_icd9.diag_icd9_finish_time <> ''
 then (to_number(substring(t_diag_icd9.diag_icd9_finish_time,1,4),'9999')-543)       
			|| substring(t_diag_icd9.diag_icd9_finish_time,6,2)       
			|| substring(t_diag_icd9.diag_icd9_finish_time,9,2) ||replace(substring(t_diag_icd9.diag_icd9_finish_time,12),':','')
 else '' end as TIMEFINISH
,t_order.order_common_name AS PROCEDURENAME
,replace(b_icd9.icd9_number,'.','') AS PROCEDCODE
,'' AS PDESCRIPTION
,'' AS PROCEDRESULT
 , b_employee.provider as PROVIDER
, case when length(t_diag_icd9.diag_icd9_update_date_time) >= 10
                                then rpad(substr(t_diag_icd9.diag_icd9_update_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_diag_icd9.diag_icd9_update_date_time,5),'-',''),',',''),':',''),14,'0')
                                else  rpad(substr( t_diag_icd9.diag_icd9_record_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr( t_diag_icd9.diag_icd9_record_date_time,5),'-',''),',',''),':',''),14,'0') 
                     end as D_UPDATE

FROM  t_visit_refer_in_out INNER JOIN t_visit ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id
INNER JOIN t_order ON t_visit.t_visit_id = t_order.t_visit_id  AND t_order.f_order_status_id not in ('0','3') AND t_order.f_item_group_id = '5'
INNER JOIN t_diag_icd9 ON t_visit.t_visit_id = t_diag_icd9.diag_icd9_vn AND t_diag_icd9.diag_icd9_active='1'
INNER JOIN b_icd9 ON t_diag_icd9.diag_icd9_icd9_number = b_icd9.icd9_number AND b_icd9.active='1'
LEFT JOIN  b_employee on (case when t_diag_icd9.diag_icd9_staff_update <> ''
                                                        then t_diag_icd9.diag_icd9_staff_update
                                                        else t_diag_icd9.diag_icd9_staff_record end ) = b_employee.b_employee_id
,b_site


where 
        t_diag_icd9.diag_icd9_active = '1'
        and t_visit.f_visit_status_id ='3'
        and t_visit.visit_money_discharge_status ='1'
        and t_visit.visit_doctor_discharge_status ='1'
        and substr(t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate' 
