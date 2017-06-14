SELECT distinct
b_site.b_visit_office_id as HOSPCODE
,substr(t_health_community.health_community_id,1,8) as VID
,case when t_health_community_activity.start_date <> ''
then (to_number(substring(t_health_community_activity.start_date,1,4),'9999') - 543)
                    || substring(t_health_community_activity.start_date,6,2)
                    || substring(t_health_community_activity.start_date,9,2)
else '' end AS DATE_START
,case when t_health_community_activity.finish_date <> ''
then (to_number(substring(t_health_community_activity.finish_date,1,4),'9999') - 543)
                    || substring(t_health_community_activity.finish_date,6,2)
                    || substring(t_health_community_activity.finish_date,9,2)
else '' end AS DATE_FINISH
,f_comactivity.code as COMACTIVITY
,b_employee.provider as PROVIDER
, case when length(t_health_community_activity.modify_date_time ) >= 10
                then cast(substring(t_health_community_activity.modify_date_time,1,4) as numeric) - 543
                         || replace(replace(replace(substring(t_health_community_activity.modify_date_time,5),'-',''),',',''),':','')
                when length(t_health_community_activity.record_date_time ) >= 10
                then cast(substring(t_health_community_activity.record_date_time ,1,4) as numeric) - 543
                         || replace(replace(replace(substring(t_health_community_activity.record_date_time ,5),'-',''),',',''),':','')
                else ''
end as D_UPDATE  



FROM 
        t_health_community
        INNER JOIN t_health_community_activity
        ON t_health_community.t_health_community_id = t_health_community_activity.t_health_community_id
        INNER JOIN f_comactivity
        ON t_health_community_activity.f_comactivity_id = f_comactivity.f_comactivity_id
        LEFT JOIN b_employee ON t_health_community_activity.user_record_id = b_employee.b_employee_id 
        cross join b_site

WHERE t_health_community.active='1'
AND t_health_community_activity.active='1'
AND (case when length(t_health_community_activity.modify_date_time) >= 10
          then substr(t_health_community_activity.modify_date_time,1,10)
          else substr(t_health_community_activity.record_date_time,1,10)
         end between  ':startDate' and ':endDate' )