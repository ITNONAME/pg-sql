select distinct
b_site.b_visit_office_id as HOSPCODE
,case when t_health_disability.health_disability_number <> ''
then  t_health_disability.health_disability_number
else '' end as DISABID
,t_health_family.health_family_hn_hcis as PID
,b_health_maim.health_maim_number as DISABTYPE
,case when t_health_maim.disability_cause='0'
then ''
else t_health_maim.disability_cause end as DISABCAUSE
,replace(b_icd10.icd10_number,'.','') as DIAGCODE
,case when t_health_maim.health_maim_survey_date <> ''
then (to_number(substring(t_health_maim.health_maim_survey_date,1,4),'9999') - 543)
                    || substring(t_health_maim.health_maim_survey_date,6,2)
                    || substring(t_health_maim.health_maim_survey_date,9,2)
else '' end AS DATE_DETECT

,case when t_health_maim.health_maim_date <> ''
then (to_number(substring(t_health_maim.health_maim_date,1,4),'9999') - 543)
                    || substring(t_health_maim.health_maim_date,6,2)
                    || substring(t_health_maim.health_maim_date,9,2)
else '' end AS DATE_DISAB
, case when length(t_health_maim.health_maim_modify_date_time) >= 10
                then cast(substring(t_health_maim.health_maim_modify_date_time,1,4) as numeric) - 543
                         || replace(replace(replace(substring(t_health_maim.health_maim_modify_date_time,5),'-',''),',',''),':','')
                when length(t_health_maim.health_maim_record_date_time) >= 10
                then cast(substring(t_health_maim.health_maim_record_date_time,1,4) as numeric) - 543
                         || replace(replace(replace(substring(t_health_maim.health_maim_record_date_time,5),'-',''),',',''),':','')
                else ''
end as D_UPDATE 


from 
        t_health_maim inner join t_health_family
        on t_health_maim.t_health_family_id = t_health_family.t_health_family_id
        inner join b_health_maim on t_health_maim.b_health_maim_id = b_health_maim.b_health_maim_id
        left join t_health_disability on t_health_family.t_health_family_id=t_health_disability.t_person_id
        left join b_icd10  on t_health_maim.b_icd10_id = b_icd10.icd10_number 

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site

where 
        t_health_maim.health_maim_active='1'
        and t_health_family.health_family_active='1'
        and b_health_maim.health_maim_active='1'
        AND (case when length(t_health_maim.health_maim_modify_date_time) >= 10
                  then substr(t_health_maim.health_maim_modify_date_time,1,10)
                  else substr(t_health_maim.health_maim_record_date_time,1,10)
                 end between  ':startDate' and ':endDate' )

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)