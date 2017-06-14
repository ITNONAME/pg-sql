SELECT
b_site.b_visit_office_id AS HOSPCODE
,t_visit_refer_in_out.visit_refer_in_out_number AS REFERID
,'' AS REFERID_PROVINCE
,t_visit_refer_in_out.f_care_type_id  AS CARETYPE
,rpad(substr(t_visit.visit_staff_doctor_discharge_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''),14,'0') as D_UPDATE 

FROM  t_visit_refer_in_out INNER JOIN t_visit ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id
,b_site

WHERE t_visit_refer_in_out.visit_refer_in_out_active='1'
AND t_visit_refer_in_out.visit_refer_in_out_status='1'
AND t_visit.f_visit_type_id <> 'S'
AND t_visit.f_visit_status_id ='3'
AND t_visit.visit_money_discharge_status='1'
AND t_visit.visit_doctor_discharge_status='1' 				
AND substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between '2558-10-01' and '2559-09-30'