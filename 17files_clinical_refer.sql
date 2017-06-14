SELECT
'' AS HOSPCODE
,'' AS REFERID
,'' AS REFERID_PROVINCE
,'' AS DATETIME_ASSESS
,'' AS CLINICALCODE
,'' AS CLINICALNAME
,'' AS CLINICALVAULE
,'' AS CLINICALRESULT
,'' AS D_UPDATE


FROM  t_visit_refer_in_out INNER JOIN t_visit ON t_visit_refer_in_out.t_visit_id = t_visit.t_visit_id
,b_site