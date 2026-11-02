select *
from ContractManagement.CreatedContract
where ContractNumber = 'SBP-1112'

select top 8*
from DocumentsDomain.UploadedDocumentTemplate
where TemplateName like 'SB_W3%'
where TemplateName like 'SB_W3_TAC_2022-08-01%'

Update DocumentsDomain.UploadedDocumentTemplate
set DateUploaded = '2023-03-21 14:55:00.000'
where TemplateName like 'SB_W3_TAC_2022-08-01%'
