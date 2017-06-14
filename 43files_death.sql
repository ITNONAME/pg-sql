select distinct
            b_site.b_visit_office_id as HOSPCODE
            , t_health_family.health_family_hn_hcis AS PID
            , case when t_death.death_site = '1'
                        then b_site.b_visit_office_id
                        else '00000' 
                     end as HOSPDEATH
            , case when t_visit.f_visit_type_id = '1'
                         then t_visit.visit_vn
                         else ''
                      end as AN
           , t_visit.visit_vn as SEQ
           , case when length( t_death.death_date_time) > 11 
                        then  substr(t_death.death_date_time,1,4)::int -543
                                   ||substr(t_death.death_date_time,6,2)
                                   ||substr(t_death.death_date_time,9,2)
                        else ''
                     end as DDEATH

            , replace(cdeath_a.icd10_number,'.','') as CDEATH_A
            , case when cdeath_b.icd10_number is not null 
                          then replace(cdeath_b.icd10_number,'.','')
                          else ''
                      end  as CDEATH_B
            , case when cdeath_c.icd10_number is not null 
                          then replace(cdeath_c.icd10_number,'.','')
                          else ''
                      end as CDEATH_C
            , case when cdeath_d.icd10_number is not null 
                          then replace(cdeath_d.icd10_number,'.','') 
                          else ''
                      end as CDEATH_D
            , case when t_death.death_external_cause_of_injury <> 'null'
                        then replace(t_death.death_external_cause_of_injury,'.','')
                        else ''
                      end as ODISEASE
            , case when t_death.death_cause NOT SIMILAR TO '(S|T|Z)%' 
                        then replace(t_death.death_cause,'.','') 
                        else ''
                      end as CDEATH

            , case when t_health_family.f_sex_id = '1' then '4'
                            when t_health_family.f_sex_id = '2' and t_death.death_pregnancy_status = '1' then '1'
                            when t_health_family.f_sex_id = '2' and t_death.death_pregnancy_status = '2' then '2'
                            when t_health_family.f_sex_id = '2' and t_death.death_pregnancy_status = '0' then '3'                            
                            when t_health_family.f_sex_id = '2' and t_death.death_pregnancy_status = '9' then '9'
                            else '9' end as PREGDEATH

            , t_death.death_site AS PDEATH
            , b_employee.provider as PROVIDER
            , rpad(substr(t_death.death_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_death.death_date_time,5),'-',''),',',''),':',''),14,'0') as D_UPDATE

from 
        t_death inner join t_health_family on t_death.t_health_family_id = t_health_family.t_health_family_id
        left join t_visit on t_death.t_visit_id = t_visit.t_visit_id
        left join b_icd10 as cdeath_a on t_death.death_primary_diagnosis = cdeath_a.b_icd10_id
        left join b_icd10 as cdeath_b on t_death.death_comorbidity = cdeath_b.b_icd10_id
        left join b_icd10 as cdeath_c on t_death.death_complication = cdeath_c.b_icd10_id
        left join b_icd10 as cdeath_d on t_death.death_others = cdeath_d.b_icd10_id
        left join b_employee on t_death.death_staff_record = b_employee.b_employee_id

        cross join b_site

where
        t_death.death_active = '1'
        and  t_health_family.health_family_active = '1'
        and substr(t_death.death_date_time,1,10) between '2559-11-01' and '2559-11-30' 

order by
        SEQ asc