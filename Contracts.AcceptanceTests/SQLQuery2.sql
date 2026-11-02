select *
from DocumentsDomain.UploadedDocumentTemplate
where TemplateName like '%2023-08-01%'
 and (TemplateName like '%EDSK2324%' or TemplateName like 'SOF_EDSK_2023%')
 order by 1






