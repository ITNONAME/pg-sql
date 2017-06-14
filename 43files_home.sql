select
            b_site.b_visit_office_id as HOSPCODE 
            , t_health_home.home_serial AS HID
            , t_health_home.health_home_number AS HOUSE_ID
            , t_health_home.f_address_housetype_id as HOUSETYPE
            , t_health_home.health_home_roomno as ROOMNO
            , t_health_home.health_home_building as CONDO
            , t_health_home.health_home_house as HOUSE
            , t_health_home.health_home_soisub as SOISUB
            , t_health_home.health_home_soimain as SOIMAIN
            , t_health_home.health_home_road as ROAD
            , t_health_village.village_name as VILLANAME

            , case when t_health_home.health_home_moo <> '' 
                            then lpad(t_health_home.health_home_moo,2,'0')
                            else '99'
                         end as VILLAGE

            , case when t_health_home.health_home_tambon <> '' 
                            then substr(t_health_home.health_home_tambon,5,2) 
                        else '99' end as TAMBON
            , case when t_health_home.health_home_amphur <> '' 
                            then substr(t_health_home.health_home_amphur,3,2) 
                        else '99' end as AMPUR
            , case when t_health_home.health_home_changwat <> '' 
                            then substr(t_health_home.health_home_changwat,1,2) 
                        else '99' end as CHANGWAT

            , case when length(case when position(',' in t_health_home.health_home_telephone) = 0
                                                then substr(replace(t_health_home.health_home_telephone,'-',''),1,10)
                                                else substr(replace(substr(t_health_home.health_home_telephone,1,position(',' in t_health_home.health_home_telephone)-1),'-',''),1,10)
                                             end) in (9,10)
                     then (case when position(',' in t_health_home.health_home_telephone) = 0
                                                then substr(replace(t_health_home.health_home_telephone,'-',''),1,10)
                                                else substr(replace(substr(t_health_home.health_home_telephone,1,position(',' in t_health_home.health_home_telephone)-1),'-',''),1,10)
                                             end)
                      else ''
                      end as TELEPHONE

            , t_health_home.health_home_latitude as LATITUDE
            , t_health_home.health_home_longitude as LONGITUDE
            , case when t_health_home.health_home_family is null or t_health_home.health_home_family  = ''
                            then '0'
                            else t_health_home.health_home_family 
                        end as NFAMILY
            , case when (t_health_home.health_home_responsible_zone = '0') 
                            then '2'          	
                     when (t_health_home.health_home_responsible_zone = '1')         		
                            then t_health_home.health_home_responsible_zone         	
                           else '1'  
                    end as LOCATYPE
            , case when volunteer.health_family_hn_hcis is not null
                            then volunteer.health_family_hn_hcis
                            else ''
                      end as VHVID 
            , case when headid.health_family_hn_hcis is not null
                            then headid.health_family_hn_hcis
                            else ''
                      end as HEADID
            , case when t_health_home_water_eradicate.health_home_toilet in ('0','1')
                            then t_health_home_water_eradicate.health_home_toilet
                            else '9' 
                        end AS TOILET
            , case when t_health_home_water_eradicate.health_home_water in ('0','1')
                            then t_health_home_water_eradicate.health_home_water
                            else '9' 
                        end AS WATER
            , case when t_health_home_water_eradicate.f_health_home_water_type_id <> ''
                            then  t_health_home_water_eradicate.f_health_home_water_type_id
                            else '9' 
                        end AS WATERTYPE
            , case when t_health_home_water_eradicate.f_health_home_garbage_method_id in ('1','2','3','4')
                            then t_health_home_water_eradicate.f_health_home_garbage_method_id
                            else '9' 
                        end as GARBAGE
            , case when t_health_home_house_standard.health_home_care in ('0','1')
                            then t_health_home_house_standard.health_home_care
                            else '9' 
                        end as HOUSING
            , '9' as DURABILITY
            , case when t_health_home_house_standard.health_home_cleanness in ('0','1')
                            then t_health_home_house_standard.health_home_cleanness 
                            else '9' 
                        end as CLEANLINESS
            , case when t_health_home_house_standard.health_home_ventilation  in ('0','1')
                            then t_health_home_house_standard.health_home_ventilation
                            else '9' 
                        end as VENTILATION
            , case when t_health_home_house_standard.health_home_light in ('0','1')
                            then t_health_home_house_standard.health_home_light
                            else '9' 
                        end as LIGHT
            , case when t_health_home_water_eradicate.health_home_water_eradicate in ('0','1')
                            then t_health_home_water_eradicate.health_home_water_eradicate
                            else '9' 
                        end as WATERTM
            , case when t_health_home_food_standard.health_home_mixture_food in ('0','1')
                            then t_health_home_food_standard.health_home_mixture_food 
                            else '9' 
                        end as MFOOD
            , case when t_health_home_bug_control.health_home_bug_control in ('0','1')
                            then t_health_home_bug_control.health_home_bug_control
                            else '9' 
                        end as BCONTROL
            , case when t_health_home_bug_control.health_home_animal_control  in ('0','1')
                            then t_health_home_bug_control.health_home_animal_control
                            else '9' 
                        end as ACONTROL
            , '9' as CHEMICAL
            , '' as OUTDATE
            , case when length( t_health_home.home_modify_date_time) >= 10
                                then rpad(substr( t_health_home.home_modify_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr( t_health_home.home_modify_date_time,5),'-',''),',',''),':',''),14,'0')
                                else  rpad(substr(t_health_home.home_record_date_time,1,4)::int -543
                                                ||replace(replace(replace(substr(t_health_home.home_record_date_time,5),'-',''),',',''),':',''),14,'0') 
                     end as D_UPDATE
                            

from 
        t_health_home  inner join t_health_village on t_health_home.t_health_village_id =  t_health_village.t_health_village_id
        left join (select t_health_family.*
                        from t_health_family inner join (select
                                                                                    t_health_family.t_health_home_id as t_health_home_id
                                                                                    ,max(t_health_family.modify_date_time) as modify_date_time     
                                                                        from 
                                                                               t_health_family 
                                                                        where
                                                                                t_health_family.f_patient_family_status_id = '1'
                                                                                and t_health_family.health_family_active = '1'

                                                                        group by
                                                                                 t_health_family.t_health_home_id) as max_headid
                                                        on  t_health_family.t_health_home_id = max_headid.t_health_home_id
                                                        and t_health_family.modify_date_time = max_headid.modify_date_time)  as headid 
                        on t_health_home.t_health_home_id = headid.t_health_home_id 
                            and headid.f_patient_family_status_id = '1'
                            and headid.health_family_active = '1'
        left join (select
                            t_health_sub_home.*
                        from t_health_sub_home inner join (
                                                                                select
                                                                                        t_health_sub_home.t_health_home_id  as t_health_home_id
                                                                                        ,max(t_health_sub_home.sub_home_record_date_time) as sub_home_record_date_time
                                                                                from t_health_sub_home
                                                                                group by
                                                                                         t_health_sub_home.t_health_home_id ) as max_health_sub_home
                      on  t_health_sub_home.t_health_home_id  = max_health_sub_home.t_health_home_id
                            and t_health_sub_home.sub_home_record_date_time = max_health_sub_home.sub_home_record_date_time) as t_health_sub_home
                on t_health_home.t_health_home_id = t_health_sub_home.t_health_home_id
        left join t_health_home_water_eradicate on t_health_home_water_eradicate.t_health_sub_home_id = t_health_sub_home.t_health_sub_home_id  
        left join t_health_home_house_standard on t_health_home_house_standard.t_health_sub_home_id = t_health_sub_home.t_health_sub_home_id  
        left join t_health_home_food_standard on t_health_home_food_standard.t_health_sub_home_id = t_health_sub_home.t_health_sub_home_id         
        left join t_health_home_bug_control on t_health_home_bug_control.t_health_sub_home_id = t_health_sub_home.t_health_sub_home_id

        left join t_health_family as volunteer on t_health_home.health_home_volunteer_family_id = volunteer.t_health_family_id
                                                                  and volunteer.health_family_active = '1'

        cross join b_site
where
        t_health_home.home_active = '1'
        and t_health_village.village_moo <> '0'
        and case when length(t_health_home.home_modify_date_time) >=10
                            then substr(t_health_home.home_modify_date_time,1,10)
                            else substr(t_health_home.home_record_date_time,1,10)
                       end between '2558-10-01' and '2559-09-30'     
 
group by
            HOSPCODE 
            ,HID  
            ,HOUSE_ID
            ,HOUSETYPE
            ,ROOMNO
            ,CONDO
            ,HOUSE
            ,SOISUB
            ,SOIMAIN
            ,ROAD
            ,VILLANAME
            ,VILLAGE
            ,TAMBON
            ,AMPUR
            ,CHANGWAT
            ,TELEPHONE
            ,LATITUDE
            ,LONGITUDE
            ,NFAMILY
            ,LOCATYPE
            ,VHVID
            ,HEADID
            ,TOILET
            ,WATER
            ,WATERTYPE
            ,GARBAGE
            ,HOUSING
            ,DURABILITY
            ,CLEANLINESS
            ,VENTILATION
            ,LIGHT
            ,WATERTM
            ,MFOOD
            ,BCONTROL
            ,ACONTROL
            ,CHEMICAL
            ,OUTDATE
            ,D_UPDATE
