--ipd017รายงาน20อันดับโรคที่ผู้ป่วยใน
SELECT 
	b_icd10.icd10_number AS code
	, b_icd10.icd10_description AS Description
                  , Count(distinct t_visit.visit_hn) AS Counthn
	, Count(t_visit.t_visit_id) AS CountVisit 
FROM 
	(t_visit INNER JOIN t_diag_icd10 
		ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn) 
	INNER JOIN b_icd10 
		ON t_diag_icd10.diag_icd10_number = b_icd10.icd10_number 
WHERE
	(t_visit.f_visit_status_id <> '4') 
    AND t_diag_icd10.f_diag_icd10_type_id = '1'
	AND (t_visit.f_visit_type_id = '1') --OPD = 0 , IPD = 1
AND (substring(visit_financial_discharge_time,1,10)  between  substring('2558-01-01',1,10) and substring('2559-09-30',1,10) )
--	AND (substring(visit_financial_discharge_time,1,10)  between  substring(?,1,10) and substring(?,1,10) )
GROUP BY 
	b_icd10.icd10_number 
	, b_icd10.icd10_description 
ORDER BY
	CountVisit DESC 

limit 10


