select distinct f_patient_prefix.patient_prefix_description ||''||
      	 t_patient.patient_firstname ||  '  ' ||
	t_patient.patient_lastname as name,
	t_visit.visit_dx as dx,
array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_main_symptom),' , ') AS argan,
       b_employee.employee_firstname || ' ' || b_employee.employee_lastname as doctor,
	substring(b_employee.employee_number,2,6)	 as license,
       substring(t_visit.visit_begin_visit_time,1,10) as date,
       substring(t_visit.visit_begin_visit_time,1,4) as year,
       substring(t_visit.visit_begin_visit_time,12,5) as time,
        substring(b_site.site_name,9,14) as organize,
	b_site.site_full_name as orga,
       t_visit.visit_patient_age as age
,t_patient.patient_birthday as birthdate
	,t_patient.patient_pid as Pid
    ,t_person_foreigner.foreigner_no as npid
  ,case when t_patient.f_sex_id ='1' then 'ชาย'
              when t_patient.f_sex_id ='2' then 'หญิง'
              else 'ไม่ระบุ'
              end as sex
       ,t_patient.patient_hn as hn
       ,t_patient.patient_phone_number as telephone
       , t_visit_vital_sign.visit_vital_sign_weight as weight
	,t_visit_vital_sign.visit_vital_sign_height as height
	,t_visit_vital_sign. visit_vital_sign_bmi as bmi
	,t_visit_vital_sign.record_date as vital
    ,t_person_foreigner.employer_name as emp_name
       ,t_visit_vital_sign.visit_vital_sign_blood_presure as bp
	,t_visit_vital_sign.visit_vital_sign_heart_rate as heart
	,t_visit_vital_sign.visit_vital_sign_respiratory_rate as rate
,f_patient_marriage_status.patient_marriage_status_description as marital
   ,case when f_patient_blood_group.patient_blood_group_description <> ''
            then f_patient_blood_group.patient_blood_group_description else '' end || ' ' ||
   case when f_rh_group.f_rh_group_id <> '9'
            then f_rh_group.rh_group_description else '' end as blood_group
,t_patient.patient_house
 || ' ม. ' || t_patient.patient_moo
 || ' ถ.' || t_patient.patient_road
 || ' ต.' || tambon_ct.address_description
 || ' อ.' || amphur_ct.address_description
 || ' จ.' || changwat_ct.address_description as address
,race.patient_nation_description as race

from t_visit left join t_visit_vital_sign on t_visit_vital_sign.t_visit_id = t_visit.t_visit_id
                cross join b_site
              inner join t_patient on t_patient.t_patient_id = t_visit.t_patient_id
	    left join b_employee ON b_employee.b_employee_id = t_visit.visit_patient_self_doctor
	    left join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id = t_visit.t_visit_id
              left join t_person_foreigner on t_patient.t_person_id = t_person_foreigner.t_person_id
              left join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
              left join f_patient_marriage_status on t_patient.f_patient_marriage_status_id = f_patient_marriage_status.f_patient_marriage_status_id
                left join t_health_family on t_patient.t_health_family_id = t_health_family.t_health_family_id
                left join f_patient_blood_group on t_patient.f_patient_blood_group_id = f_patient_blood_group.f_patient_blood_group_id
                left join f_rh_group on t_health_family.health_family_rh = f_rh_group.f_rh_group_id
                left join (select * from f_address) as changwat_ct on changwat_ct.f_address_id = t_patient.patient_changwat
                left join (select * from f_address) as amphur_ct on amphur_ct.f_address_id = t_patient.patient_amphur
                left join (select * from f_address) as tambon_ct on tambon_ct.f_address_id = t_patient.patient_tambon
                left join (select * from f_patient_nation) as race on race.f_patient_nation_id = t_patient.f_patient_race_id

where   f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id
and   t_visit.t_visit_id = '255113546456379322'--$P{visit_id}

  and   t_visit.t_patient_id = t_patient.t_patient_id
group by
        f_patient_prefix.patient_prefix_description
        ,t_patient.patient_firstname
        ,t_visit.visit_begin_visit_time
,t_patient.patient_house
,t_patient.patient_moo
,t_patient.patient_road
,tambon_ct.address_description
,amphur_ct.address_description
,changwat_ct.address_description
        ,b_site.site_name
        ,b_site.site_full_name
        ,t_visit.visit_patient_age
        ,t_patient.patient_pid
        ,t_patient.patient_hn
        ,t_person_foreigner.employer_name
        ,t_patient.patient_phone_number
,t_visit_vital_sign.visit_vital_sign_weight
,t_visit_vital_sign.visit_vital_sign_height
,t_visit_vital_sign.visit_vital_sign_bmi
,t_visit_vital_sign.record_date
,t_visit_vital_sign.visit_vital_sign_blood_presure
,t_visit_vital_sign.visit_vital_sign_heart_rate
,t_visit_vital_sign.visit_vital_sign_respiratory_rate
,f_patient_blood_group.patient_blood_group_description
,f_rh_group.f_rh_group_id
,t_patient.patient_birthday
,t_patient.f_sex_id
,race.patient_nation_description
,f_patient_marriage_status.patient_marriage_status_description
,t_person_foreigner.foreigner_no
,t_patient.patient_lastname
,f_rh_group.rh_group_description
,dx
,doctor
,license
