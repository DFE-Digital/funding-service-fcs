select *
from OverrideDate.OverrideDate
order by 4 desc

select *
from DocumentsDomain.UploadedDocumentTemplate
where TemplateName like '%EDSK2324%'
or TemplateName like '%EDSK_2023%'