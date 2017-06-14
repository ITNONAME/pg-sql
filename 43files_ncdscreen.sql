select distinct
b_site.b_visit_office_id as HOSPCODE
,t_health_family.health_family_hn_hcis as PID
,t_visit.visit_vn as SEQ
,(to_number(substring(t_ncd_screen.screen_date,1,4),'9999')-543)       
			|| substring(t_ncd_screen.screen_date,6,2)       
			|| substring(t_ncd_screen.screen_date,9,2) AS DATE_SERV
,case when t_visit.service_location='' OR t_visit.service_location IS NULL
then '1'
else t_visit.service_location end as SERVPLACE
,case when t_ncd_screen_risk.f_cigarette_feq_id='0'
then '1'
when t_ncd_screen_risk.f_cigarette_feq_id='1'
then '2'
when t_ncd_screen_risk.f_cigarette_feq_id='2'
then '3'
when t_ncd_screen_risk.f_cigarette_feq_id='3'
then '4'
else '9' end as SMOKE
,case when t_ncd_screen_risk.f_alcohol_feq_id ='0'
then '1'
when t_ncd_screen_risk.f_alcohol_feq_id ='1'
then '2'
when t_ncd_screen_risk.f_cigarette_feq_id='2'
then '3'
when t_ncd_screen_risk.f_alcohol_feq_id ='3'
then '4'
else '9' end as ALCOHOL
,case when t_ncd_screen_family_history.dm_result ='0' 
then '2'
when t_ncd_screen_family_history.dm_result ='1' 
then '1'
else '9' end as DMFAMILY
,case when t_ncd_screen_family_history.ht_result ='0' 
then '2'
when t_ncd_screen_family_history.ht_result ='1' 
then '1'
else '9' end as HTFAMILY
,(case when strpos(t_ncd_screen.weight,'.') <> 0
then substr(t_ncd_screen.weight,0,strpos(t_ncd_screen.weight,'.')+2)
when strpos(t_ncd_screen.weight,'.') = 0 and t_ncd_screen.weight <> ''
then t_ncd_screen.weight||'.0'
else '0.0' end) WEIGHT
,(case when t_ncd_screen.height = ''
then '0'
else round(cast(t_ncd_screen.height as numeric)) end) as "HEIGHT"
,(case when t_ncd_screen.waist =''
then '0'
else round(cast(t_ncd_screen.waist as numeric)) end) as WAIST_CM
,(case when t_ncd_screen.hbp_s1 = ''
then '0'
else round(cast(t_ncd_screen.hbp_s1 as numeric)) end) as SBP_1
,(case when t_ncd_screen.hbp_d1= ''
then '0'
else round(cast(t_ncd_screen.hbp_d1 as numeric)) end) as DBP_1
,(case when t_ncd_screen.hbp_s2=''
then '0'
else round(cast(t_ncd_screen.hbp_s2 as numeric)) end) as SBP_2
,(case when t_ncd_screen.hbp_d2=''
then '0'
else round(cast(t_ncd_screen.hbp_d2 as numeric)) end) as DBP_2


,case 
    when strpos(t_ncd_screen_result_blood.fcg_result,'.') <> 0
then substr(t_ncd_screen_result_blood.fcg_result,0,strpos(t_ncd_screen_result_blood.fcg_result,'.')+2)
when strpos(t_ncd_screen_result_blood.fcg_result,'.') = 0 and t_ncd_screen_result_blood.fcg_result <> ''
then t_ncd_screen_result_blood.fcg_result||'.00'
    when strpos(t_ncd_screen_result_blood.fpg_result,'.') <> 0
then substr(t_ncd_screen_result_blood.fpg_result,0,strpos(t_ncd_screen_result_blood.fpg_result,'.')+2)
when strpos(t_ncd_screen_result_blood.fpg_result,'.') = 0 and t_ncd_screen_result_blood.fpg_result <> ''
then t_ncd_screen_result_blood.fpg_result||'.00'
    when strpos(t_ncd_screen_result_blood.ppg_result,'.') <> 0
then substr(t_ncd_screen_result_blood.ppg_result,0,strpos(t_ncd_screen_result_blood.ppg_result,'.')+2)
when strpos(t_ncd_screen_result_blood.ppg_result,'.') = 0 and t_ncd_screen_result_blood.ppg_result <> ''
then t_ncd_screen_result_blood.ppg_result||'.00'
    when strpos(t_ncd_screen_result_blood.dtx_result,'.') <> 0
then substr(t_ncd_screen_result_blood.dtx_result,0,strpos(t_ncd_screen_result_blood.dtx_result,'.')+2)
when strpos(t_ncd_screen_result_blood.dtx_result,'.') = 0 and t_ncd_screen_result_blood.dtx_result <> ''
then t_ncd_screen_result_blood.dtx_result||'.00'
    when strpos(t_ncd_screen_result_blood.fbs_result,'.') <> 0
then substr(t_ncd_screen_result_blood.fbs_result,0,strpos(t_ncd_screen_result_blood.fbs_result,'.')+2)
when strpos(t_ncd_screen_result_blood.fbs_result,'.') = 0 and t_ncd_screen_result_blood.fbs_result <> ''
then t_ncd_screen_result_blood.fbs_result||'.00'
else '0.00' end BSLEVEL

,case when t_ncd_screen_result_blood."8hr_eat" ='1' and t_ncd_screen_result_blood.fbs_result <> ''
then '1'
when t_ncd_screen_result_blood."8hr_eat" ='0' and t_ncd_screen_result_blood.fbs_result <> ''
then '2'
when t_ncd_screen_result_blood."8hr_eat" ='1' and t_ncd_screen_result_blood.dtx_result <> ''
then '3'
when t_ncd_screen_result_blood."8hr_eat" ='0' and t_ncd_screen_result_blood.dtx_result <> ''
then '4'
else '' end as BSTEST
,b_site.b_visit_office_id as SCREENPLACE
,b_employee.provider as PROVIDER
,(case  when length(t_ncd_screen.d_update) >= 10
                then case when length(cast(substring(t_ncd_screen.d_update,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_ncd_screen.d_update,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_ncd_screen.d_update,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_ncd_screen.d_update,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_ncd_screen.d_update,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_ncd_screen.d_update,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_ncd_screen.d_update,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_ncd_screen.d_update,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_ncd_screen.d_update,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_ncd_screen.d_update,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_ncd_screen.d_update,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_ncd_screen.d_update,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_ncd_screen.d_update,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_ncd_screen.d_update,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_ncd_screen.d_update,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_ncd_screen.d_update,5),'-',''),',',''),':','')) || '000000'
                                  else '' end
else ''
                           end) as D_UPDATE  


from t_ncd_screen inner join t_health_family on t_ncd_screen.t_health_family_id = t_health_family.t_health_family_id
        inner join
        (select t_health_family_id as t_health_family_id
        ,max(screen_date) as screen_date
         from t_ncd_screen where substr( t_ncd_screen.d_update,1,10) between ':startDate' and ':endDate'   
        group by t_health_family_id) as q1
        on t_ncd_screen.t_health_family_id = q1.t_health_family_id and t_ncd_screen.screen_date = q1.screen_date
        left join t_visit on t_ncd_screen.t_visit_id = t_visit.t_visit_id and t_visit.f_visit_status_id <> '4'
        inner join  t_ncd_screen_behavior on t_ncd_screen.t_ncd_screen_id = t_ncd_screen_behavior.t_ncd_screen_id 
        inner join t_ncd_screen_risk on t_ncd_screen_risk.t_ncd_screen_id = t_ncd_screen_behavior.t_ncd_screen_id
        inner join t_ncd_screen_result_blood on t_ncd_screen.t_ncd_screen_id = t_ncd_screen_result_blood.t_ncd_screen_id
        inner join  t_ncd_screen_family_history on t_ncd_screen.t_ncd_screen_id = t_ncd_screen_family_history.t_ncd_screen_id 
        left join b_employee on t_ncd_screen.user_record_id = b_employee.b_employee_id 

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site


where 
        t_ncd_screen_family_history.f_ncd_family_relation_id='2'
        and t_ncd_screen.active ='1'
        AND substr( t_ncd_screen.d_update,1,10) between ':startDate' and ':endDate'   
        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

