SELECT 
	b_site.b_visit_office_id AS HOSPCODE  	
    ,t_health_family.health_family_hn_hcis as PID 	
	,t_health_pregnancy.health_pregnancy_gravida_number AS GRAVIDA 	
	, CASE WHEN (length(t_health_pregnancy.health_pregnancy_menses_issue_date)>=10)
        then to_char(to_date(to_number(
        substr(t_health_pregnancy.health_pregnancy_menses_issue_date,1,4),'9999')-543 || 
        substr(t_health_pregnancy.health_pregnancy_menses_issue_date,5,6),'yyyy-mm-dd'),'yyyymmdd') 
                    ELSE t_health_pregnancy.health_pregnancy_menses_issue_date   END AS LMP     
	, CASE WHEN (length(t_health_pregnancy.health_pregnancy_menses_expire_date)>=10)
        then to_char(to_date(to_number(
        substr(t_health_pregnancy.health_pregnancy_menses_expire_date,1,4),'9999')-543 || 
        substr(t_health_pregnancy.health_pregnancy_menses_expire_date,5,6),'yyyy-mm-dd'),'yyyymmdd') 
                    ELSE t_health_pregnancy.health_pregnancy_menses_expire_date  END AS EDC 
   
	, max(CASE WHEN (t_health_anc.health_anc_vdrl ='0' OR t_health_anc.health_anc_vdrl ='' OR t_health_anc.health_anc_vdrl is null)  
                then '3' WHEN t_health_anc.health_anc_vdrl ='3'  then '4'  
                else t_health_anc.health_anc_vdrl END) AS VDRL_RESULT  
	,max(CASE WHEN (t_health_anc.health_anc_hb ='0' OR t_health_anc.health_anc_hb ='' OR t_health_anc.health_anc_hb is null)  
                then '3' WHEN t_health_anc.health_anc_hb ='3' then '4' 
                else t_health_anc.health_anc_hb END) AS HB_RESULT
	,max(CASE WHEN (t_health_anc.health_anc_hiv ='0'OR t_health_anc.health_anc_hiv =''OR t_health_anc.health_anc_hiv is null) 
                then '3' WHEN t_health_anc.health_anc_hiv ='3' then '4'   
                else t_health_anc.health_anc_hiv END) AS  HIV_RESULT
	,max(CASE WHEN (length(t_health_anc.health_anc_hct_date)>=10  and t_health_anc.health_anc_hct <> '0' )
            then to_char(to_date(to_number(
            substr(t_health_anc.health_anc_hct_date,1,4),'9999')-543 || 
            substr(t_health_anc.health_anc_hct_date,5,6),'yyyy-mm-dd'),'yyyymmdd') 
                        ELSE ''   END) AS DATE_HCT  
	,max( CASE WHEN t_health_anc.health_anc_hct_result  is not null
            THEN t_health_anc.health_anc_hct_result    ELSE '' END)  AS HCT_RESULT
	, max(CASE WHEN (t_health_anc.health_anc_thalassemia ='0' OR t_health_anc.health_anc_thalassemia ='' OR t_health_anc.health_anc_thalassemia is null)  
                then '3' WHEN t_health_anc.health_anc_thalassemia ='3'  then '4'  
                else t_health_anc.health_anc_thalassemia END) AS THALASSEMIA
    ,max(case when length(t_health_pregnancy.modify_date_time) >= 10
                then case when length(cast(substring(t_health_pregnancy.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.modify_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_pregnancy.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.modify_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_pregnancy.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.modify_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_pregnancy.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.modify_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_pregnancy.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.modify_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_pregnancy.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.modify_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_pregnancy.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.modify_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_pregnancy.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.modify_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end
                when length(t_health_pregnancy.record_date_time) >= 10
                then case when length(cast(substring(t_health_pregnancy.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.record_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_pregnancy.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.record_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_pregnancy.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.record_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_pregnancy.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.record_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_pregnancy.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.record_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_pregnancy.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.record_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_pregnancy.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.record_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_pregnancy.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_pregnancy.record_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end)  as D_UPDATE




FROM 
        t_health_anc INNER JOIN t_health_family ON t_health_anc.t_health_family_id = t_health_family.t_health_family_id
        INNER JOIN t_health_pregnancy ON t_health_anc.t_health_pregnancy_id = t_health_pregnancy.t_health_pregnancy_id
        INNER JOIN t_patient ON t_health_anc.t_patient_id = t_patient.t_patient_id 
                                        and t_health_pregnancy.t_patient_id =t_patient.t_patient_id

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site
			
WHERE  
        t_health_family.health_family_active = '1'
        AND  t_health_anc.health_anc_active='1'
        AND t_health_pregnancy.health_pregnancy_active='1'
        and (case when length(t_health_pregnancy.modify_date_time) >= 10
        then substr(t_health_pregnancy.modify_date_time,1,10)
        else substr(t_health_pregnancy.record_date_time,1,10)
        end between  ':startDate' and ':endDate'  )
        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
     

group by
b_site.b_visit_office_id
,t_health_family.health_family_hn_hcis
,t_health_pregnancy.health_pregnancy_gravida_number
,t_health_pregnancy.health_pregnancy_menses_issue_date
,t_health_pregnancy.health_pregnancy_menses_expire_date