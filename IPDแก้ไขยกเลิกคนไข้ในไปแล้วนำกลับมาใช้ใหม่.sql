--IPDแก้ไขยกเลิกคนไข้ในไปแล้วนำกลับมาใช้ใหม่
t_visit
+++++++++++++++
--UPDATE t_visit set visit_vn='159002013',visit_an='059069270',f_visit_type_id='1'
,b_visit_clinic_id='1313085667988'
,b_visit_ward_id='2231139210212'
,visit_bed='18'
,visit_begin_admit_date_time='2559-11-20,16:45:01'
--WHERE t_visit_id='255113541150173250'

***************

t_visit_bed
+++++++++++++++

--update t_visit_bed set current_bed = '2',active='1' 
--where t_visit_bed_id = '853113549764887154'