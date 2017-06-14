-- F43_student  For PDC  , HospitalOS Database
-- ดึงค่า schoolcode ตามโครงสร้าง ๕๐ แฟ้ม
SELECT DISTINCT
b_site.b_visit_office_id as HOSPCODE
,t_health_family.health_family_hn_hcis as PID

,(t_health_village.village_tambon||t_health_village.village_moo||t_health_school.school_number) as SCHOOLCODE
,t_health_visit_school.visit_school_term AS EDUCATIONYEAR
,(SELECT school_class_number
AS school_class_number
FROM b_school_class 
WHERE t_health_visit_school.b_school_class_id = b_school_class.b_school_class_id) AS CLASS
--,'' as GRUDATE_DATE
,'20160831135701' as D_UPDATE --แก้ก่อนส่ง
,t_health_student.student_pid AS ID
from  t_health_student
left join t_patient on t_health_student.t_health_student_id= t_patient.t_health_family_id and  t_patient.patient_active = '1' 
left join t_health_visit_school ON t_health_student.t_health_visit_school_id = t_health_visit_school.t_health_visit_school_id
left join t_health_family on t_health_student.student_pid = t_health_family.patient_pid
INNER JOIN t_health_school on t_health_visit_school.t_health_school_id = t_health_school.t_health_school_id
INNER JOIN t_health_village on t_health_village.t_health_village_id = t_health_school.t_health_village_id
cross join b_site

WHERE t_health_student.student_active = '1' AND t_health_student.student_pid <> '' AND t_health_student.student_pid  IS NOT NULL 
and t_health_visit_school.visit_school_term = '2559'
/*Design By HospitalOS TEAM ,Edit By MickyMouseNoo 16/04/2558 ,edit by PBhK.2559-03-21*/