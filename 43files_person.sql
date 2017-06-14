select  distinct
            b_site.b_visit_office_id as HOSPCODE
            , case when t_health_family.patient_pid <> '' and length(t_health_family.patient_pid) =13
                            then t_health_family.patient_pid
                    when t_health_family.patient_pid = '' 
/*                                 and t_health_family.health_family_foreigner_card_no = '' 
                                and t_health_family.r_rp1853_foreign_id in ('02','03','04','11','12','13','14','21','22','23')
                          then 
                                   lpad(t_patient.patient_hn,13,'0')                                      
                    when  t_health_family.health_family_foreigner_card_no <> '' and length(t_health_family.health_family_foreigner_card_no) =13
                            then  t_health_family.health_family_foreigner_card_no
                    else ''
                    end as CID */
                                and t_person_foreigner.foreigner_no = ''
                                and t_person_foreigner.f_person_foreigner_id in ('02','03','04','11','12','13','14','21','22','23')
                            then
                                lpad(t_patient.patient_hn,13,'0')
                     when t_person_foreigner.foreigner_no <> '' and length(t_person_foreigner.foreigner_no) = 13
                            then t_person_foreigner.foreigner_no
                     else ''
                        end as CID
            , t_health_family.health_family_hn_hcis  AS PID
            , t_health_home.home_serial AS HID

            , case when  r_rp1853_prefix.id is not null and  r_rp1853_prefix.id <> ''
                        then lpad( r_rp1853_prefix.id,3,'0')
                        else ''
                  end AS PRENAME
            , case when length(t_health_family.patient_name)>50
                            then substring(t_health_family.patient_name,1,50)
                            else t_health_family.patient_name
                      end as NAME
            , case when length(t_health_family.patient_last_name)>50
                            then substring(t_health_family.patient_last_name,1,50)
                            else t_health_family.patient_last_name
                      end as LNAME
            , t_patient.patient_hn as HN
            , case when t_health_family.f_sex_id is not null and trim(t_health_family.f_sex_id) in ('1','2')
                                then t_health_family.f_sex_id
                                else ''
                        end AS SEX
            , case  when length(t_health_family.patient_birthday)>9 and t_health_family.patient_birthday_true = '1'
                           then substring(t_health_family.patient_birthday,1,4)::int - 543
                                    || substring(t_health_family.patient_birthday,6,2)
                                    || substring(t_health_family.patient_birthday,9,2)
                           when length(t_health_family.patient_birthday)>9 and t_health_family.patient_birthday_true <> '1'
                           then substring(t_health_family.patient_birthday,1,4)::int - 543
                                    || '0101'
                          else '' end as BIRTH
            , f_patient_marriage_status.r_rp1853_marriage_id AS MSTATUS
            /* , '' as OCCUPATION_OLD */
            , case when r_rp1853_occupation.id is not null
                    then r_rp1853_occupation.id
                    else ''
              end as OCCUPATION_OLD
            , case when r_rp1855_occupation.code is not null
                     then r_rp1855_occupation.code
                     else ''
              end as OCCUPATION_NEW
            , case when r_rp1855_race.id is not null
                            then r_rp1855_race.id
                            else ''
                      end as RACE
            , case when r_rp1855_nation.id is not null
                            then r_rp1855_nation.id
                            else ''
                      end as NATION
            , case when b_map_rp1855_religion.r_rp1855_religion_id is not null 
                            then b_map_rp1855_religion.r_rp1855_religion_id
                            else ''
                      end as RELIGION
            , case when r_rp1855_education.id is not null 
                            then lpad(r_rp1855_education.id,2,'0')
                            else '' 
                       end as EDUCATION
            , t_health_family.f_patient_family_status_id AS FSTATUS
            , case when father.patient_pid is not null 
                            then father.patient_pid
                            else '' 
                     end as FATHER
            , case when mother.patient_pid is not null 
                            then mother.patient_pid
                            else '' 
                     end as MOTHER
            , case when couple.patient_pid is not null 
                            then couple.patient_pid
                            else '' 
                     end as COUPLE
            , t_health_family.f_person_village_status_id as VSTATUS
            , case when t_health_family.patient_move_in_date_time is not null
                                    and length(t_health_family.patient_move_in_date_time)>9
                            then substring(t_health_family.patient_move_in_date_time,1,4)::int - 543
                            || substring(t_health_family.patient_move_in_date_time,6,2)
                            || substring(t_health_family.patient_move_in_date_time,9,2)
                            else '' 
                        end as MOVEIN
            , case when t_patient.f_patient_discharge_status_id in ('1','2','3')
                            then t_patient.f_patient_discharge_status_id
                        else '9'  end as DISCHARGE
             , case when t_patient.patient_discharge_date_time is not null 
                                and length(t_patient.patient_discharge_date_time)>9
                                and t_patient.f_patient_discharge_status_id in ('1','2','3')
                            then substring(t_patient.patient_discharge_date_time,1,4)::int -543
                                || substring(t_patient.patient_discharge_date_time,6,2)
                                || substring(t_patient.patient_discharge_date_time,9,2)
                      when t_health_family.modify_date_time is not null
                                    and length(t_health_family.modify_date_time)>9
                                    and t_patient.f_patient_discharge_status_id in ('1','2','3')
                            then substring(t_health_family.modify_date_time,1,4)::int -543
                                            || substring(t_health_family.modify_date_time,6,2)
                                            || substring(t_health_family.modify_date_time,9,2)
                            else '' END AS DDISCHARGE
              , case when f_patient_blood_group.r_rp1853_blood_id is not null 
                            then  f_patient_blood_group.r_rp1853_blood_id 
                            else '' end as ABOGROUP

              , case when t_health_family.health_family_rh = '1' 
                            then '1'
                       when t_health_family.health_family_rh = '0' 
                             then '2'
                        else '' end as RHGROUP
              /* , case when t_health_family.r_rp1853_foreign_id  is not null 
                                    and t_health_family.r_rp1853_foreign_id <> ''
                                    and trim(t_health_family.r_rp1853_foreign_id) <> 'null'
                                    and t_health_family.r_rp1853_foreign_id <> '0'
                                then t_health_family.r_rp1853_foreign_id
                                else '' 
                        end AS LABOR  */
               , case when t_person_foreigner.f_person_foreigner_id is not null
                                and t_person_foreigner.f_person_foreigner_id <> ''
                                and trim(t_person_foreigner.f_person_foreigner_id) <> 'null'
                                and t_person_foreigner.f_person_foreigner_id <> '0'
                           then t_person_foreigner.f_person_foreigner_id
                            else ''
                            end AS LABOR
               , t_person_foreigner.passport_no as PASSPORT
               ,case when t_health_family.f_patient_area_status_id = '0'
                                then '5'
                                else t_health_family.f_patient_area_status_id  
                        end as TYPEAREA
              , case when length(t_health_family.modify_date_time) >= 10
                            then rpad(substr(t_health_family.modify_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_health_family.modify_date_time,5),'-',''),',',''),':',''),14,'0') 
                            else rpad(substr(t_health_family.record_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_health_family.record_date_time,5),'-',''),',',''),':',''),14,'0') end as D_UPDATE 

from 
        t_health_family left join t_patient on t_health_family.t_health_family_id = t_patient.t_health_family_id and  t_patient.patient_active = '1'
        left join t_person_foreigner on t_health_family.t_health_family_id = t_person_foreigner.t_person_id
        left join t_health_home on t_health_family.t_health_home_id = t_health_home.t_health_home_id
        left join f_patient_prefix on t_health_family.f_prefix_id = f_patient_prefix.f_patient_prefix_id
        left join b_map_rp1853_prefix on  f_patient_prefix.f_patient_prefix_id = b_map_rp1853_prefix.f_patient_prefix_id
        left join r_rp1853_prefix on b_map_rp1853_prefix.r_rp1853_prefix_id = r_rp1853_prefix.id
        left join f_patient_marriage_status  on t_health_family.f_patient_marriage_status_id = f_patient_marriage_status.f_patient_marriage_status_id
        left join f_patient_occupation on t_health_family.f_patient_occupation_id = f_patient_occupation.f_patient_occupation_id
        left join b_map_rp1853_occupation on f_patient_occupation.f_patient_occupation_id  = b_map_rp1853_occupation.f_patient_occupation_id
        left join r_rp1853_occupation on b_map_rp1853_occupation.r_rp1853_occupation_id = r_rp1853_occupation.id
        left join b_map_rp1855_occupation on f_patient_occupation.f_patient_occupation_id = b_map_rp1855_occupation.f_patient_occupation_id
        left join r_rp1855_occupation on b_map_rp1855_occupation.r_rp1855_occupation_id = r_rp1855_occupation.id

        left join f_patient_nation as race_1 on t_health_family.f_patient_race_id = race_1.f_patient_nation_id
        left join b_map_rp1855_nation as race on race_1.f_patient_nation_id = race.f_patient_nation_id
        left join r_rp1855_nation as r_rp1855_race on race.r_rp1855_nation_id = r_rp1855_race.id

        left join f_patient_nation as nation_1 on t_health_family.f_patient_nation_id = nation_1.f_patient_nation_id
        left join b_map_rp1855_nation as nation on nation_1.f_patient_nation_id = nation.f_patient_nation_id
        left join r_rp1855_nation as r_rp1855_nation on nation.r_rp1855_nation_id = r_rp1855_nation.id

        left join f_patient_religion on t_health_family.f_patient_religion_id = f_patient_religion.f_patient_religion_id
        left join b_map_rp1855_religion on f_patient_religion.f_patient_religion_id = b_map_rp1855_religion.f_patient_religion_id
        left join f_patient_education_type on t_health_family.f_patient_education_type_id = f_patient_education_type.f_patient_education_type_id
        left join b_map_rp1855_education on f_patient_education_type.f_patient_education_type_id = b_map_rp1855_education.f_patient_education_id
        left join r_rp1855_education on b_map_rp1855_education.r_rp1855_education_id = r_rp1855_education.id 
        left join f_patient_blood_group on t_health_family.f_patient_blood_group_id = f_patient_blood_group.f_patient_blood_group_id
        left join t_health_family as father on t_health_family.father_family_id = father.t_health_family_id
        left join t_health_family as mother on t_health_family.mother_family_id = mother.t_health_family_id
        left join t_health_family as couple  on t_health_family.couple_family_id = couple.t_health_family_id

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

        cross join b_site

where 
         t_health_family.health_family_active = '1'
					--and t_health_family.health_family_hn_hcis='073528'
          and case when length(t_health_family.modify_date_time) >= 10
                            then substr(t_health_family.modify_date_time,1,10)
                            else substr(t_health_family.record_date_time,1,10) 
                         end between '2559-09-01' and '2559-10-31' 

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

order by 
            CID asc
