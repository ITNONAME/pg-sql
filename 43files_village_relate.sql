select distinct
q0.b_visit_office_id as HOSPCODE
,q0.VID as VID
,'' as NTRADITIONAL
,q1.NMONK as NMONK
,'' as NRELIGIONLEADER
,q2.resource as NBROADCAST
,q3.NRADIO as NRADIO
,''as NPCHC
,'' as NCLINIC
,q4.NDRUGSTORE as NDRUGSTORE
,'' as NCHILDCENTER
,'' as NPSCHOOL
,'' as NSSCHOOL
,q5.NTEMPLE as NTEMPLE
,'' as NRELIGIOUSPLACE
,q6.NMARKET as NMARKET
,q7.NSHOP as NSHOP
,q8.NFOODSHOP as NFOODSHOP
,q9.NSTALL as NSTALL
,'' as NRAINTANK
,'' as NCHICKENFARM
,'' as NPIGFARM
,'2' as WASTEWATER
,'9' as GARBAGE
,'' as NFACTORY
,''as LATITUDE
,'' as LONGITUDE
,'' as OUTDATE
,'' as NUMACTUALLY
,'' as RISKTYPE
,'' as NUMSTATELESS
,q10.NEXERCISECLUB as NEXERCISECLUB
,q11.NOLDERLYCLUB as NOLDERLYCLUB
,'' as NDISABLECLUB
,q12.NNUMBERONECLUB as NNUMBERONECLUB
,q0.D_UPDATE as D_UPDATE

from 
(select distinct
b_site.b_visit_office_id as b_visit_office_id
,substr(t_health_village.village_changwat,1,2)|| substr(t_health_village.village_ampur,3,2) ||substr(t_health_village.village_tambon,5,2)||case when length(t_health_village.village_moo)  = 1 
then '0'||t_health_village.village_moo 
else t_health_village.village_moo end as VID
,t_health_village.t_health_village_id as t_health_village_id
,(case when length(t_health_village.village_modify_date_time) >= 10
                then case when length(cast(substring(t_health_village.village_modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_village.village_modify_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_village.village_modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_village.village_modify_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_village.village_modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_village.village_modify_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_village.village_modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_village.village_modify_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_village.village_modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_village.village_modify_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_village.village_modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_village.village_modify_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_village.village_modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_village.village_modify_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_village.village_modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_village.village_modify_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end
        
                else ''
       end)  as D_UPDATE 
from t_health_village ,b_site where t_health_village.village_moo not in ('0','00') ) as q0

LEFT JOIN
(select
sum(cast(t_health_temple_history_detail.temple_amount_personel as numeric)) as NMONK
,t_health_temple.t_health_village_id as t_health_village_id
from 
t_health_temple  INNER JOIN t_health_temple_history
ON t_health_temple.t_health_temple_id = t_health_temple_history.t_health_temple_id 
INNER JOIN t_health_temple_history_detail
ON t_health_temple_history.t_health_temple_history_id = t_health_temple_history_detail.t_health_temple_history_id 
LEFT JOIN b_health_temple_personel
ON t_health_temple_history.temple_staff_record = b_health_temple_personel.b_health_temple_personel_id AND b_health_temple_personel.temple_personel_active='1'
where t_health_temple_history_detail.temple_personel='7365651748410'
group by t_health_temple.t_health_village_id) as q1

ON q0.t_health_village_id = q1.t_health_village_id


LEFT JOIN

(select 
count(  case when t_health_resource.resource_name='7614827179321'
then t_health_resource.resource_name else null end) as resource
,t_health_resource.t_health_village_id  as t_health_village_id
from t_health_resource group by t_health_resource.t_health_village_id) as q2

ON q0.t_health_village_id = q2.t_health_village_id

LEFT JOIN

(select 
count(  case when t_health_resource.resource_name='7618963938213'
then t_health_resource.resource_name else null end) as NRADIO
,t_health_resource.t_health_village_id 
from t_health_resource group by t_health_resource.t_health_village_id) as q3


ON q0.t_health_village_id = q3.t_health_village_id

LEFT JOIN
(select 
count(  case when t_health_company_history.b_health_company_type_id='7027255557328'
then t_health_company_history.b_health_company_type_id else null end) as NDRUGSTORE
,t_health_company.t_health_village_id 
from t_health_company INNER JOIN t_health_company_history
on t_health_company.t_health_company_id = t_health_company_history.t_health_company_id
group by t_health_company.t_health_village_id) as q4
ON q0.t_health_village_id = q4.t_health_village_id

LEFT JOIN

(select
count( case when t_health_temple.temple_type ='7093089289189'
then t_health_temple.temple_type
else null end )as NTEMPLE
,t_health_temple.t_health_village_id as t_health_village_id
from 
t_health_temple  group by t_health_temple.t_health_village_id ) as q5

ON q0.t_health_village_id = q5.t_health_village_id

LEFT JOIN

(select 
count(  case when t_health_company_history.b_health_company_type_id='7028552971515'
then t_health_company_history.b_health_company_type_id else null end) as NMARKET
,t_health_company.t_health_village_id 
from t_health_company INNER JOIN t_health_company_history
on t_health_company.t_health_company_id = t_health_company_history.t_health_company_id
group by t_health_company.t_health_village_id) as q6

ON q0.t_health_village_id = q6.t_health_village_id


LEFT JOIN
(select 
count(  case when t_health_company_history.b_health_company_type_id='7023248651590'
then t_health_company_history.b_health_company_type_id else null end) as NSHOP
,t_health_company.t_health_village_id 
from t_health_company INNER JOIN t_health_company_history
on t_health_company.t_health_company_id = t_health_company_history.t_health_company_id
group by t_health_company.t_health_village_id) as q7
ON q0.t_health_village_id = q7.t_health_village_id

LEFT JOIN

(select 
count(  case when t_health_company_history.b_health_company_type_id='7023347181370'
then t_health_company_history.b_health_company_type_id else null end) as NFOODSHOP
,t_health_company.t_health_village_id 
from t_health_company INNER JOIN t_health_company_history
on t_health_company.t_health_company_id = t_health_company_history.t_health_company_id
group by t_health_company.t_health_village_id) as q8

ON q0.t_health_village_id = q8.t_health_village_id

LEFT JOIN

(select 
count(  case when t_health_company_history.b_health_company_type_id='7024877778807'
then t_health_company_history.b_health_company_type_id else null end) as NSTALL
,t_health_company.t_health_village_id 
from t_health_company INNER JOIN t_health_company_history
on t_health_company.t_health_company_id = t_health_company_history.t_health_company_id
group by t_health_company.t_health_village_id)  as q9
ON q0.t_health_village_id = q9.t_health_village_id

LEFT JOIN 

(select 
count(  case when t_health_agr_history.agr_history_group='7644314835965'
then t_health_agr_history.agr_history_group else null end) as NEXERCISECLUB
,t_health_agr.t_health_village_id 
from t_health_agr INNER JOIN t_health_agr_history 
ON t_health_agr.t_health_agr_id = t_health_agr_history.t_health_agr_id
group by t_health_agr.t_health_village_id) as q10
ON q0.t_health_village_id = q10.t_health_village_id

LEFT JOIN

(select 
count(  case when t_health_agr_history.agr_history_group='7643585476920'
then t_health_agr_history.agr_history_group else null end) as NOLDERLYCLUB
,t_health_agr.t_health_village_id 
from t_health_agr INNER JOIN t_health_agr_history 
ON t_health_agr.t_health_agr_id = t_health_agr_history.t_health_agr_id
group by t_health_agr.t_health_village_id) as q11

ON q0.t_health_village_id = q11.t_health_village_id

LEFT JOIN

(select 
count(  case when t_health_agr_history.agr_history_group='7648783292931'
then t_health_agr_history.agr_history_group else null end) as NNUMBERONECLUB
,t_health_agr.t_health_village_id 
from t_health_agr INNER JOIN t_health_agr_history 
ON t_health_agr.t_health_agr_id = t_health_agr_history.t_health_agr_id
group by t_health_agr.t_health_village_id) as q12

ON q0.t_health_village_id = q12.t_health_village_id

where     
        q0.b_visit_office_id||'|'||q0.VID in (:in_pk)
        and q0.b_visit_office_id||'|'||q0.VID not in (:notin_pk)   
order by VID