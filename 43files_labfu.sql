select distinct
            b_site.b_visit_office_id as HOSPCODE
            ,t_health_family.health_family_hn_hcis as PID
            ,t_visit.visit_vn as SEQ
            ,(to_number(substring(t_visit.visit_begin_visit_time,1,4),'9999')-543)       
                        || substring(t_visit.visit_begin_visit_time,6,2)       
                        || substring(t_visit.visit_begin_visit_time,9,2)  as DATE_SERV
            ,case when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000004'
            then '01'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000005'
            then '02'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000002'
            then '03'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000003'
            then '04'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000006'
            then '05'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000008'
            then '06'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000007'
            then '07'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000009'
            then '08'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000010'
            then '09'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000011'
            then '10'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000012'
            then '11'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000021'
            then '12'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000028'
            then '13'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000013'
            then '14'
	    when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000015'
            then '16'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000017'
            then '17'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000016'
            then '18'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000018'
            then '19'
	    when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000019'
            then '20'
            when b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000020'
            then '21'
            else '' end as LABTEST

            ,case when lower(t_result_lab.result_lab_value) ilike '%neg%'
            then '0.00'
            when lower(t_result_lab.result_lab_value) ilike '%trace%'
            then '1.00'
            when lower(t_result_lab.result_lab_value) ilike '%pos%' OR t_result_lab.result_lab_value ilike '1+' OR t_result_lab.result_lab_value ilike '2+'
            OR t_result_lab.result_lab_value ilike '3+' OR t_result_lab.result_lab_value ilike '4+'
            then '2.00'
            when t_result_lab.result_lab_value ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$'
            then t_result_lab.result_lab_value::decimal(10,2)::text
            else t_result_lab.result_lab_value end as LABRESULT

            ,(case  when length(t_visit.visit_staff_doctor_discharge_date_time) >= 10
                            then case when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) = 14
                                              then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''))
                                              when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) =12
                                              then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '00'
                                              when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) =10
                                              then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '0000'
                                              when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) = 8
                                              then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '000000'
                                              else '' end
                            when length(t_chronic.modify_date_time) >= 10
                            then case when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) = 14
                                              then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':',''))
                                              when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) =12
                                              then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) || '00'
                                              when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) =10
                                              then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) || '0000'
                                              when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) = 8
                                              then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) || '000000'
                                              else ''
                                       end
                            else ''
                   end) as d_update     


from  
        t_chronic inner join t_visit on t_chronic.t_visit_id = t_visit.t_visit_id
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
        inner join t_health_family on t_patient.t_health_family_id = t_health_family.t_health_family_id
        inner join t_result_lab on t_visit.t_visit_id = t_result_lab.t_visit_id
        inner join t_order on t_result_lab.t_order_id = t_order.t_order_id
        inner join b_item_map_lab_ncd on t_result_lab.b_item_id = b_item_map_lab_ncd.b_item_id and b_item_map_lab_ncd.active='1'
        inner join b_item_lab_ncd_std on b_item_map_lab_ncd.b_item_lab_ncd_std_id = b_item_lab_ncd_std.b_item_lab_ncd_std_id and b_item_lab_ncd_std.active='1'

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site

where  
        t_result_lab.result_lab_active='1'
        and t_order.f_order_status_id <> '3'
        and (b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000004' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000005' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000002'
        OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000003' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000006' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000008'
        OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000007' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000009' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000010'
        OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000011' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000012' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000021'
        OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000028' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000013' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000015'
		OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000017' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000016' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000018'
		OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000019' OR b_item_lab_ncd_std.b_item_lab_ncd_std_id='ncd201000000000020')
        AND t_visit.f_visit_type_id <> 'S'
        AND t_visit.f_visit_status_id ='3'
        AND t_visit.visit_money_discharge_status='1'
        AND t_visit.visit_doctor_discharge_status='1' 				
        AND substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate'    

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

union

-- labtest = 15
select distinct
            b_site.b_visit_office_id as HOSPCODE
            ,t_health_family.health_family_hn_hcis as PID
            ,t_visit.visit_vn as SEQ
            ,(to_number(substring(t_visit.visit_begin_visit_time,1,4),'9999')-543)       
                        || substring(t_visit.visit_begin_visit_time,6,2)       
                        || substring(t_visit.visit_begin_visit_time,9,2)  as DATE_SERV
            ,'15' as LABTEST

            ,case when t_visit_egfr.gfr_value ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$'
            then t_visit_egfr.gfr_value::decimal(10,2)::text
            else t_visit_egfr.gfr_value end as LABRESULT

            ,(case  when length(t_visit.visit_staff_doctor_discharge_date_time) >= 10
                            then case when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) = 14
                                              then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''))
                                              when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) =12
                                              then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '00'
                                              when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) =10
                                              then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '0000'
                                              when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) = 8
                                              then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '000000'
                                              else '' end
                            when length(t_chronic.modify_date_time) >= 10
                            then case when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) = 14
                                              then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':',''))
                                              when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) =12
                                              then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) || '00'
                                              when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) =10
                                              then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) || '0000'
                                              when length(cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) = 8
                                              then (cast(substring(t_chronic.modify_date_time,1,4) as numeric) - 543
                                                            || replace(replace(replace(substring(t_chronic.modify_date_time,5),'-',''),',',''),':','')) || '000000'
                                              else ''
                                       end
                            else ''
                   end) as d_update     


from  
        t_chronic inner join t_visit on t_chronic.t_visit_id = t_visit.t_visit_id
        inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
        inner join t_health_family on t_patient.t_health_family_id = t_health_family.t_health_family_id
        inner join t_result_lab on t_visit.t_visit_id = t_result_lab.t_visit_id
        inner join t_order on t_result_lab.t_order_id = t_order.t_order_id
        inner join t_visit_egfr on t_visit_egfr.t_order_id = t_order.t_order_id
                                            and t_visit_egfr.f_egfr_formula_id = '3'
        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site

where  
        t_result_lab.result_lab_active='1'
        and t_order.f_order_status_id <> '3'
        AND t_visit.f_visit_type_id <> 'S'
        AND t_visit.f_visit_status_id ='3'
        AND t_visit.visit_money_discharge_status='1'
        AND t_visit.visit_doctor_discharge_status='1' 				
        AND substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between ':startDate' and ':endDate' 

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
