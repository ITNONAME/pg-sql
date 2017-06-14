SELECT
b_site.b_visit_office_id AS HOSPCODE
,'' AS REFERID_SOURCE
,'' AS REFERID_PROVINCE
,t_visit_refer_in_out.visit_refer_in_out_refer_hospital AS HOSP_SOURCE
,t_visit_refer_in_out.f_refer_result_id  AS REFER_RESULT
,case  when t_visit_refer_in_out.refer_care_date <> '' AND t_visit_refer_in_out.refer_care_time <> ''
then (to_number(substring(t_visit_refer_in_out.refer_care_date,1,4),'9999')-543)       
			|| substring(t_visit_refer_in_out.refer_care_date,6,2)       
			|| substring(t_visit_refer_in_out.refer_care_date,9,2) ||replace((t_visit_refer_in_out.refer_care_time),':','')||'00' else '' end as DATETIME_IN
,t_visit_refer_in_out.refer_pid AS PID_IN
,t_visit_refer_in_out.refer_an AS AN_IN
,t_visit_refer_in_out.reason AS REASON
,rpad(substr(t_visit.visit_staff_doctor_discharge_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''),14,'0') as D_UPDATE 
FROM t_visit_refer_in_out INNER JOIN t_visit ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id
,b_site

WHERE t_visit_refer_in_out.visit_refer_in_out_active='1'
AND t_visit_refer_in_out.visit_refer_in_out_status='1'
AND t_visit.f_visit_type_id <> 'S'
AND t_visit.f_visit_status_id ='3'
AND t_visit.visit_money_discharge_status='1'
AND t_visit.visit_doctor_discharge_status='1' 				
AND substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between '2558-10-01' and '2559-09-30' 