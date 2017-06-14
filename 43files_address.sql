select distinct
            b_site.b_visit_office_id as HOSPCODE
            , t_health_family.health_family_hn_hcis AS PID
            , '1' as ADDRESSTYPE
            , t_health_home.health_home_number as HOUSE_ID
            , '9' as HOUSETYPE
            , '' as ROOMNO
            , '' as CONDO
            , t_patient.patient_house as HOUSENO
            , '' as SOISUB
            , '' as SOIMAIN
            , t_patient.patient_road as ROAD
            , '' as VILLANAME
            , case when t_patient.patient_moo is not null 
                           then lpad(t_patient.patient_moo,2,'0') 
                        else '99' end as VILLAGE
            , case when t_patient.patient_tambon <> '' 
                            then substr(t_patient.patient_tambon,5,2) 
                        else '99' end as TAMBON
            , case when t_patient.patient_amphur <> '' 
                            then substr(t_patient.patient_amphur,3,2) 
                        else '99' end as AMPUR
            , case when t_patient.patient_changwat <> '' 
                            then substr(t_patient.patient_changwat,1,2) 
                        else '99' end as CHANGWAT

            ,substr(t_patient.patient_phone_number,1,15) as TELEPHONE

            ,substr(t_patient.patient_patient_mobile_phone,1,15)  as MOBILE

            , case when length(t_health_family.modify_date_time) >= 10
                            then rpad(substr(t_health_family.modify_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_health_family.modify_date_time,5),'-',''),',',''),':',''),14,'0') 
                            else rpad(substr(t_health_family.record_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_health_family.record_date_time,5),'-',''),',',''),':',''),14,'0') end as D_UPDATE 

from 
        t_health_family left join t_patient on t_patient.t_health_family_id = t_health_family.t_health_family_id
        left join t_health_home on t_health_family.t_health_home_id = t_health_home.t_health_home_id

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site

where
         t_health_family.health_family_active = '1'
         and t_health_family.f_patient_area_status_id <> '1'
         and case when length(t_health_family.modify_date_time) >= 10
                            then substr(t_health_family.modify_date_time,1,10)
                            else substr(t_health_family.record_date_time,1,10) 
                         end between ':startDate' and ':endDate'
 
        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

order by
        PID asc