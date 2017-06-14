select
women.HOSPCODE
,women.PID
,women.FPTYPE
,women.NOFPCAUSE
,women.TOTALSON
,women.NUMBERSON
,women.ABORTION
,women.STILLBIRTH
,women.D_UPDATE
from

((SELECT
	b_site.b_visit_office_id AS HOSPCODE
    ,t_health_family.health_family_hn_hcis as PID 
	, CASE  WHEN (t_health_family_planing.f_health_family_planing_method_id = '1'
                OR  t_health_family_planing.f_health_family_planing_method_id = '2'
                OR  t_health_family_planing.f_health_family_planing_method_id = '3'
                OR  t_health_family_planing.f_health_family_planing_method_id = '4'  
                OR  t_health_family_planing.f_health_family_planing_method_id = '5'
                OR  t_health_family_planing.f_health_family_planing_method_id = '6'
                OR  t_health_family_planing.f_health_family_planing_method_id = '7' )
                THEN t_health_family_planing.f_health_family_planing_method_id
		ELSE '9' END AS FPTYPE   
    , case when t_health_family_planing.f_health_family_planing_id is not null
            then t_health_family_planing.f_health_family_planing_id
            else '3' 
      end  AS NOFPCAUSE
	, case when t_health_family_planing.health_family_planing_parity is not null
            then t_health_family_planing.health_family_planing_parity 
            else '0' 
      end AS TOTALSON
     ,'0' AS NUMBERSON
     ,'0' AS ABORTION
     ,'0' AS STILLBIRTH
     ,(case when length(t_health_family_planing.update_record_date_time) >= 10
                then case when length(cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_family_planing.update_record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.update_record_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end
                when length(t_health_family_planing.record_date_time) >= 10
                then case when length(cast(substring(t_health_family_planing.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.record_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_family_planing.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.record_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_family_planing.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.record_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_family_planing.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.record_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_family_planing.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.record_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_family_planing.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.record_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_family_planing.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.record_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_family_planing.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_family_planing.record_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end)  as D_UPDATE 

FROM t_health_family
	INNER JOIN t_health_home  ON t_health_home.t_health_home_id = t_health_family.t_health_home_id
	INNER JOIN t_health_village  ON t_health_village.t_health_village_id = t_health_home.t_health_village_id
	INNER JOIN (
		SELECT t_health_family_planing.t_health_family_id AS t_health_family_id
                ,max(t_health_family_planing.health_family_planing_date) AS family_planing_date
			FROM t_health_family_planing WHERE health_family_planing_active = '1'
			GROUP BY t_health_family_planing.t_health_family_id
        ) AS fp1  ON ( fp1.t_health_family_id = t_health_family.t_health_family_id )
     INNER JOIN t_health_family_planing ON (t_health_family.t_health_family_id = t_health_family_planing.t_health_family_id
            AND fp1.family_planing_date = t_health_family_planing.health_family_planing_date  )

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

	cross join b_site

WHERE  t_health_village.village_moo <> '0'
    AND  t_health_family.f_sex_id  = '2'
    AND health_family_active = '1' 
  --  AND t_health_family.patient_birthday <> '' AND length(t_health_family.patient_birthday) = 10
  --  AND cast(substr(cast(current_date as varchar),1,4) as numeric) + 543- cast(substr(t_health_family.patient_birthday,1,4) as numeric)  >= 15
  --  AND cast(substr(cast(current_date as varchar),1,4) as numeric) + 543 - cast(substr(t_health_family.patient_birthday,1,4) as numeric)  <= 49
    AND (case when length(t_health_family_planing.update_record_date_time) >= 10
          then substr(t_health_family_planing.update_record_date_time,1,10)
          else substr(t_health_family_planing.record_date_time,1,10)
         end between ':startDate' and ':endDate'  )

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

order by t_health_family.health_family_hn_hcis)



UNION





(select
b_site.b_visit_office_id as HOSPCODE 
,t_health_family.health_family_hn_hcis AS PID  
, CASE  WHEN (t_health_women.f_health_family_planing_method_id = '1'
                OR  t_health_women.f_health_family_planing_method_id = '2'
                OR  t_health_women.f_health_family_planing_method_id = '3'
                OR  t_health_women.f_health_family_planing_method_id = '4'
                OR  t_health_women.f_health_family_planing_method_id = '5'
                OR  t_health_women.f_health_family_planing_method_id = '6'
                OR  t_health_women.f_health_family_planing_method_id = '7' )
                THEN t_health_women.f_health_family_planing_method_id
		ELSE '9' END AS FPTYPE   
, case when t_health_women.f_health_family_planing_id is not null
            then t_health_women.f_health_family_planing_id
            else '3' 
end  AS NOFPCAUSE
, case when t_health_women.totalson is not null
            then t_health_women.totalson 
            else '0' 
 end AS TOTALSON
,case when t_health_women.numberson <> ''
then t_health_women.numberson
else '0' end AS NUMBERSON
,case when t_health_women.abortion <> ''
then t_health_women.abortion
else '0' end AS ABORTION
,case when t_health_women.stillbirth <> ''
then t_health_women.stillbirth
else '0' end AS STILLBIRTH
,(case when length(t_health_women.update_date_time) >= 10
                then case when length(cast(substring(t_health_women.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.update_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_women.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.update_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_women.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.update_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_women.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.update_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_women.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.update_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_women.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.update_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_women.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.update_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_women.update_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.update_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end
                when length(t_health_women.record_date_time) >= 10
                then case when length(cast(substring(t_health_women.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.record_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_women.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.record_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_women.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.record_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_women.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.record_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_women.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.record_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_women.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.record_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_women.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.record_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_women.record_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_women.record_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end)  as D_UPDATE 



from 
        t_health_women INNER JOIN t_health_family 
        ON t_health_women.t_health_family_id = t_health_family.t_health_family_id
        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'
        cross join b_site

where  case when length(t_health_women.update_date_time) >= 10
          then substr(t_health_women.update_date_time,1,10)
          else substr(t_health_women.record_date_time,1,10)
         end between  ':startDate' and ':endDate' 
        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)
)) as women

INNER JOIN

((select 
max(cast(substring(q1.datetime,1,4) as numeric) - 543 ||(replace(replace(replace(substr(q1.datetime,5) ,'-',''),',',''),':','' )) )as datetime
,q1.pid
from
(select
max(case when length(t_health_family_planing.update_record_date_time) >= 10
          then t_health_family_planing.update_record_date_time
          else t_health_family_planing.record_date_time end ) as datetime
,t_health_family.health_family_hn_hcis as pid
FROM t_health_family
	INNER JOIN t_health_home  ON t_health_home.t_health_home_id = t_health_family.t_health_home_id
	INNER JOIN t_health_village  ON t_health_village.t_health_village_id = t_health_home.t_health_village_id
	INNER JOIN (
		SELECT t_health_family_planing.t_health_family_id AS t_health_family_id
                ,max(t_health_family_planing.health_family_planing_date) AS family_planing_date
			FROM t_health_family_planing WHERE health_family_planing_active = '1'
			GROUP BY t_health_family_planing.t_health_family_id
        ) AS fp1  ON ( fp1.t_health_family_id = t_health_family.t_health_family_id )
     INNER JOIN t_health_family_planing ON (t_health_family.t_health_family_id = t_health_family_planing.t_health_family_id
            AND fp1.family_planing_date = t_health_family_planing.health_family_planing_date  )


WHERE  t_health_village.village_moo <> '0'
    AND  t_health_family.f_sex_id  = '2'
    AND health_family_active = '1' 

    AND (case when length(t_health_family_planing.update_record_date_time) >= 10
          then substr(t_health_family_planing.update_record_date_time,1,10)
          else substr(t_health_family_planing.record_date_time,1,10)
         end between ':startDate' and ':endDate'  )
group by t_health_family.health_family_hn_hcis


UNION

select 
max( case when length(t_health_women.update_date_time) >= 10
          then t_health_women.update_date_time
          else t_health_women.record_date_time end ) as datetime
,t_health_family.health_family_hn_hcis as pid
from t_health_women INNER JOIN t_health_family 
ON t_health_women.t_health_family_id = t_health_family.t_health_family_id
,b_site

where  case when length(t_health_women.update_date_time) >= 10
          then substr(t_health_women.update_date_time,1,10)
          else substr(t_health_women.record_date_time,1,10)
         end between  ':startDate' and ':endDate' 

group by t_health_family.health_family_hn_hcis) as q1

group by q1.pid) ) as datetime

ON women.pid = datetime.pid and women.d_update = datetime.datetime


