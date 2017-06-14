SELECT 
b_site.b_visit_office_id as HOSPCODE
,t_visit_refer_in_out.visit_refer_in_out_number AS REFERID
,'' AS REFERID_PROVINCE
,(to_number(substring(t_order.order_date_time,1,4),'9999')-543)       
			|| substring(t_order.order_date_time,6,2)       
			|| substring(t_order.order_date_time,9,2) ||replace(substring(t_order.order_date_time,12),':','') as DATETIME_DSTART
,'' AS DATETIME_DFINISH
, substr(b_nhso_map_drug.f_nhso_drug_id,1,24) as DIDSTD 
, b_item.item_common_name as DNAME
,t_order_drug.order_drug_dose ||' '|| b_item_drug_uom.item_drug_uom_description ||' '|| b_item_drug_frequency.item_drug_frequency_description AS DDESCRIPTION
            , max(case when t_order.order_dispense_date_time <> '' and t_order.order_dispense_date_time >= t_order_drug.order_drug_modify_datetime
                              then rpad(substr(t_order.order_dispense_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order.order_dispense_date_time,5),'-',''),',',''),':',''),14,'0')
                      when t_order.order_dispense_date_time <> '' and t_order.order_dispense_date_time < t_order_drug.order_drug_modify_datetime
                              then rpad(substr(t_order_drug.order_drug_modifier,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order_drug.order_drug_modifier,5),'-',''),',',''),':',''),14,'0')
                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time <> '' 
                                    and t_order.order_executed_date_time >= t_order.order_verify_date_time
                              then rpad(substr(t_order.order_executed_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order.order_executed_date_time,5),'-',''),',',''),':',''),14,'0')
                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time <> '' 
                                    and t_order.order_executed_date_time < t_order_drug.order_drug_modify_datetime
                              then rpad(substr(t_order_drug.order_drug_modifier,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order_drug.order_drug_modifier,5),'-',''),',',''),':',''),14,'0')
                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time = '' 
                                    and t_order.order_verify_date_time >= t_order_drug.order_drug_modify_datetime
                              then rpad(substr(t_order.order_staff_verify,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order.order_staff_verify,5),'-',''),',',''),':',''),14,'0')
                       when t_order.order_dispense_date_time = '' and t_order.order_executed_date_time = '' 
                                    and t_order.order_verify_date_time < t_order_drug.order_drug_modify_datetime
                              then rpad(substr(t_order_drug.order_drug_modifier,1,4)::int -543
                                                ||replace(replace(replace(substr(t_order_drug.order_drug_modifier,5),'-',''),',',''),':',''),14,'0') end) as D_UPDATE 

FROM t_visit_refer_in_out INNER JOIN t_visit ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id
INNER JOIN t_order ON t_visit.t_visit_id = t_order.t_visit_id  AND t_order.f_order_status_id not in ('0','3') AND t_order.f_item_group_id = '1'
INNER JOIN b_item on b_item.b_item_id = t_order.b_item_id 
LEFT JOIN b_nhso_map_drug on t_order.b_item_id = b_nhso_map_drug.b_item_id
INNER JOIN t_order_drug on t_order.t_order_id=t_order_drug.t_order_id 
LEFT JOIN  b_item_drug_uom on t_order_drug.b_item_drug_uom_id_purch=b_item_drug_uom.b_item_drug_uom_id
LEFT JOIN b_item_drug_frequency on t_order_drug.b_item_drug_frequency_id = b_item_drug_frequency.b_item_drug_frequency_id
,b_site

where
 t_visit.f_visit_status_id ='3'
AND t_order_drug.order_drug_active ='1'
AND t_visit.visit_money_discharge_status ='1'
AND t_visit.visit_doctor_discharge_status ='1'
AND substr(t_visit.visit_staff_doctor_discharge_date_time,1,10)  between ':startDate' and ':endDate' 

group by
b_site.b_visit_office_id
,t_visit_refer_in_out.visit_refer_in_out_number
,t_order.order_date_time
,b_nhso_map_drug.f_nhso_drug_id
,b_item.item_common_name
,t_order_drug.order_drug_dose
,b_item_drug_uom.item_drug_uom_description
,b_item_drug_frequency.item_drug_frequency_description
order by t_visit_refer_in_out.visit_refer_in_out_number