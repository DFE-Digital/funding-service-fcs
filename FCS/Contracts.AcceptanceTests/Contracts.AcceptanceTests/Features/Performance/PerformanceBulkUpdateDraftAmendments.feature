@#Feature576_Update_Draft_Contract_Amendments_in_Bulk
@UpdateDraftContractAmendmentsInBulk
Feature: PerformanceBulkUpdateDraftAmendments
   As an Allocations user
   I want to be able to update draft contract amendments in bulk 
   And apply validation rules
   And view the changes in CRM

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P006a Feature_BulkLoad_UpdateDraftAmendments_Test_Load 10 update draft amendments in 54 seconds
Given The file 'MAIN AY 1516 15062015150000 PerformanceUpdateDraftAmendment.xlsx' exists at 'DataFiles\Performance' with the following UKPRNs
   | UKPRN    |
   | 50040000 |
   | 50040001 |
   | 50040002 |
   | 50040003 |
   | 50040004 |
   | 50040005 |
   | 50040006 |
   | 50040007 |
   | 50040008 |
   | 50040009 |
   And CRM has an 'active' organisation for each UKPRN
   And the contract data is now removed for ukprn beginning with '5004'
   And the following data exists in the CRM Contract table
   | Contract No | Version | Provider | UKPRN    | Funding Type | Contract Status | Sub Status | Contract Value | Start Date | End Date   | Contract Owner | Contract Type         | Description | Hierarchy Type | Last Approved Version | Latest Version | Parent Contract | Period | Sub Version | Task Owner |
   | MUDA-5055   | 1       | NACRO    | 50040000 | Mainstream   | Approved        | Approved   | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | No             |                 |        | 0           | FCS2 Test |
   | UDA-5055    | 1       | NACRO    | 50040000 | Mainstream   | Approved        | Approved   | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | No             | MUDA-5055       |        | 0           | FCS2 Test |
   | MUDA-5056   | 1       | NACRO    | 50040001 | Mainstream   | Approved        | Approved   | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | No             |                 |        | 0           | FCS2 Test |
   | UDA-5056    | 1       | NACRO    | 50040001 | Mainstream   | Approved        | Approved   | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | No             | MUDA-5056       |        | 0           | FCS2 Test |
   | MUDA-5057   | 1       | NACRO    | 50040002 | Mainstream   | Approved        | Approved   | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | No             |                 |        | 0           | FCS2 Test |
   | UDA-5057    | 1       | NACRO    | 50040002 | Mainstream   | Approved        | Approved   | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | No             | MUDA-5057       |        | 0           | FCS2 Test |
   | MUDA-5058   | 1       | NACRO    | 50040003 | Mainstream   | Approved        | Approved   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | No             |                 |        | 0           | FCS2 Test |
   | UDA-5058    | 1       | NACRO    | 50040003 | Mainstream   | Approved        | Approved   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | No             | MUDA-5058       |        | 0           | FCS2 Test |
   | MUDA-5059   | 1       | NACRO    | 50040004 | Mainstream   | Approved        | Approved   | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | No             |                 |        | 0           | FCS2 Test |
   | UDA-5059    | 1       | NACRO    | 50040004 | Mainstream   | Approved        | Approved   | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | No             | MUDA-5059       |        | 0           | FCS2 Test |
   | MUDA-5060   | 1       | NACRO    | 50040005 | Mainstream   | Approved        | Approved   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | No             |                 |        | 0           | FCS2 Test |
   | UDA-5060    | 1       | NACRO    | 50040005 | Mainstream   | Approved        | Approved   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | No             | MUDA-5060       |        | 0           | FCS2 Test |
   | MUDA-5061   | 1       | NACRO    | 50040006 | Mainstream   | Approved        | Approved   | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | No             |                 |        | 0           | FCS2 Test |
   | UDA-5061    | 1       | NACRO    | 50040006 | Mainstream   | Approved        | Approved   | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | No             | MUDA-5061       |        | 0           | FCS2 Test |
   | MUDA-5062   | 1       | NACRO    | 50040007 | Mainstream   | Approved        | Approved   | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | No             |                 |        | 0           | FCS2 Test |
   | UDA-5062    | 1       | NACRO    | 50040007 | Mainstream   | Approved        | Approved   | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | No             | MUDA-5062       |        | 0           | FCS2 Test |
   | MUDA-5063   | 1       | NACRO    | 50040008 | Mainstream   | Approved        | Approved   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | No             |                 |        | 0           | FCS2 Test |
   | UDA-5063    | 1       | NACRO    | 50040008 | Mainstream   | Approved        | Approved   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | No             | MUDA-5063       |        | 0           | FCS2 Test |   
   | MUDA-5064   | 1       | NACRO    | 50040009 | Mainstream   | Approved        | Approved   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | No             |                 |        | 0           | FCS2 Test |
   | UDA-5064    | 1       | NACRO    | 50040009 | Mainstream   | Approved        | Approved   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | No             | MUDA-5064       |        | 0           | FCS2 Test |   
   And the following data exists in the CRM Allocations table
   | Contract Allocation Ref | Allocation Status | Contract | Contract Allocation Value (£) | Start Date | End Date   | Funding Stream | Funding Stream Period | Hierarchy type      | Period |
   | APPS-5055               | Approved          | UDA-5055 | 120                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5056               | Approved          | UDA-5056 | 240                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5057               | Approved          | UDA-5057 | 360                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5058               | Approved          | UDA-5058 | 120                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5059               | Approved          | UDA-5059 | 240                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5060               | Approved          | UDA-5060 | 360                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5061               | Approved          | UDA-5061 | 120                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5062               | Approved          | UDA-5062 | 240                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5063               | Approved          | UDA-5063 | 360                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5064               | Approved          | UDA-5064 | 120                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   And the following data exists in the CRM Deliverable table
   | Deliverable                         | Contract | Contract Allocation | Deliverable Code | Funding Stream Period Deliverable                 | Owner      | Planned Value (£) | Planned Volume | Actual Value (£) | Actual Volume |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | APPS-5055           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | APPS-5056           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | APPS-5057           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | APPS-5058           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | APPS-5059           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | APPS-5060           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | APPS-5061           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | APPS-5062           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | APPS-5063           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | APPS-5064           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5055           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Aug-15 | 20            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Sep-15 | 20            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Oct-15 | 20            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Nov-15 | 20            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Dec-15 | 20            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Jan-16 | 20            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Feb-16 | 20            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Mar-16 | 20            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Apr-16 | 20            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | May-16 | 20            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Jun-16 | 20            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5056           | Jul-16 | 20            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Aug-15 | 30            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Sep-15 | 30            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Oct-15 | 30            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Nov-15 | 30            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Dec-15 | 30            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Jan-16 | 30            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Feb-16 | 30            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Mar-16 | 30            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Apr-16 | 30            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | May-16 | 30            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Jun-16 | 30            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5057           | Jul-16 | 30            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5058           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Aug-15 | 20            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Sep-15 | 20            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Oct-15 | 20            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Nov-15 | 20            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Dec-15 | 20            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Jan-16 | 20            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Feb-16 | 20            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Mar-16 | 20            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Apr-16 | 20            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | May-16 | 20            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Jun-16 | 20            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5059           | Jul-16 | 20            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Aug-15 | 30            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Sep-15 | 30            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Oct-15 | 30            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Nov-15 | 30            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Dec-15 | 30            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Jan-16 | 30            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Feb-16 | 30            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Mar-16 | 30            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Apr-16 | 30            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | May-16 | 30            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Jun-16 | 30            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5060           | Jul-16 | 30            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5061           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Aug-15 | 20            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Sep-15 | 20            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Oct-15 | 20            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Nov-15 | 20            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Dec-15 | 20            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Jan-16 | 20            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Feb-16 | 20            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Mar-16 | 20            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Apr-16 | 20            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | May-16 | 20            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Jun-16 | 20            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5062           | Jul-16 | 20            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Aug-15 | 30            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Sep-15 | 30            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Oct-15 | 30            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Nov-15 | 30            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Dec-15 | 30            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Jan-16 | 30            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Feb-16 | 30            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Mar-16 | 30            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Apr-16 | 30            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | May-16 | 30            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Jun-16 | 30            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5063           | Jul-16 | 30            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | APPS-5064           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
#Draft from Approved Contract
   And the following data exists in the CRM Contract table
   | Contract No | Version | Provider | UKPRN    | Funding Type |Contract Status | Sub Status                 | Contract Value | Start Date | End Date   | Contract Owner | Contract Type         | Description | Hierarchy Type | Last Approved Version | Latest Version | Parent Contract | Period | Sub Version | Task Owner |
   | MUDA-5055   | 1       | NACRO    | 50040000 | Mainstream   |Approved        | Approved                   | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | No                    | Yes            |                 |        | 0           | FCS2 Test |
   | UDA-5055    | 2       | NACRO    | 50040000 | Mainstream   |Draft           | In Review                  | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | No                    | Yes            | MUDA-5055       |        | 0           | FCS2 Test |
   | MUDA-5056   | 1       | NACRO    | 50040001 | Mainstream   |Approved        | Approved                   | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | No                    | Yes            |                 |        | 0           | FCS2 Test |
   | UDA-5056	  | 2       | NACRO    | 50040001 | Mainstream   |Draft           | In Review                  | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | No                    | Yes            | MUDA-5056       |        | 0           | FCS2 Test |
   | MUDA-5057   | 1       | NACRO    | 50040002 | Mainstream   |Approved        | Approved                   | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | No                    | Yes            |                 |        | 0           | FCS2 Test |
   | UDA-5057    | 2       | NACRO    | 50040002 | Mainstream   |Draft           | In Review                  | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | No                    | Yes            | MUDA-5057       |        | 0           | FCS2 Test |
   | MUDA-5058   | 1       | NACRO    | 50040003 | Mainstream   |Approved        | Approved                   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | No                    | Yes            |                 |        | 0           | FCS2 Test |
   | UDA-5058	  | 2       | NACRO    | 50040003 | Mainstream   |Draft           | In Review                  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | No                    | Yes            | MUDA-5058       |        | 0           | FCS2 Test |
   | MUDA-5059   | 1       | NACRO    | 50040004 | Mainstream   |Approved        | Approved                   | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | No                    | Yes            |                 |        | 0           | FCS2 Test |
   | UDA-5059	  | 2       | NACRO    | 50040004 | Mainstream   |Draft           | In Review                  | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | No                    | Yes            | MUDA-5059       |        | 0           | FCS2 Test |
   | MUDA-5060   | 1       | NACRO    | 50040005 | Mainstream   |Approved        | Approved                   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | No                    | Yes            |                 |        | 0           | FCS2 Test |
   | UDA-5060	  | 2       | NACRO    | 50040005 | Mainstream   |Draft           | In Review                  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | No                    | Yes            | MUDA-5060       |        | 0           | FCS2 Test |
   | MUDA-5061   | 1       | NACRO    | 50040006 | Mainstream   |Approved        | Approved                   | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | No                    | Yes            |                 |        | 0           | FCS2 Test |
   | UDA-5061    | 2       | NACRO    | 50040006 | Mainstream   |Draft           | In Review                  | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | No                    | Yes            | MUDA-5061       |        | 0           | FCS2 Test |
   | MUDA-5062   | 1       | NACRO    | 50040007 | Mainstream   |Approved        | Approved                   | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | No                    | Yes            |                 |        | 0           | FCS2 Test |
   | UDA-5062	  | 2       | NACRO    | 50040007 | Mainstream   |Draft           | In Review                  | 240            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | No                    | Yes            | MUDA-5062       |        | 0           | FCS2 Test |
   | MUDA-5063   | 1       | NACRO    | 50040008 | Mainstream   |Approved        | Approved                   | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | No                    | Yes            |                 |        | 0           | FCS2 Test |
   | UDA-5063	  | 2       | NACRO    | 50040008 | Mainstream   |Draft           | In Review                  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | No                    | Yes            | MUDA-5063       |        | 0           | FCS2 Test |
   | MUDA-5064   | 1       | NACRO    | 50040009 | Mainstream   |Approved        | Approved                   | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | No                    | Yes            |                 |        | 0           | FCS2 Test |
   | UDA-5064    | 2       | NACRO    | 50040009 | Mainstream   |Draft           | In Review                  | 120            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | No                    | Yes            | MUDA-5064       |        | 0           | FCS2 Test |
   And the following data exists in the CRM Allocations table
   | Contract Allocation Ref | Allocation Status | Contract | Contract Version Number | Contract Allocation Value (£) | Start Date | End Date   | Funding Stream | Funding Stream Period | Hierarchy type      | Period |
   | APPS-5055               | Draft             | UDA-5055 | 2                       | 120                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5056               | Draft             | UDA-5056 | 2                       | 240                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5057               | Draft             | UDA-5057 | 2                       | 360                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5058               | Draft             | UDA-5058 | 2                       | 120                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5059               | Draft             | UDA-5059 | 2                       | 240                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5060               | Draft             | UDA-5060 | 2                       | 360                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5061               | Draft             | UDA-5061 | 2                       | 120                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5062               | Draft             | UDA-5062 | 2                       | 240                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5063               | Draft             | UDA-5063 | 2                       | 360                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   | APPS-5064               | Draft             | UDA-5064 | 2                       | 120                           | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
   And the following data exists in the CRM Deliverable table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Deliverable Code | Funding Stream Period Deliverable                 | Owner      | Planned Value (£) | Planned Volume | Actual Value (£) | Actual Volume |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | 2                | Total 24+ Advanced Learning Loans Bursary Funding | FCS2 Test | 120               | <Blank>        | <Blank>          | <Blank>       |  
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5055 | 2                       | APPS-5055           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Aug-15 | 20            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Sep-15 | 20            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Oct-15 | 20            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Nov-15 | 20            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Dec-15 | 20            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Jan-16 | 20            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Feb-16 | 20            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Mar-16 | 20            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Apr-16 | 20            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | May-16 | 20            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Jun-16 | 20            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5056 | 2                       | APPS-5056           | Jul-16 | 20            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Aug-15 | 30            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Sep-15 | 30            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Oct-15 | 30            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Nov-15 | 30            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Dec-15 | 30            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Jan-16 | 30            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Feb-16 | 30            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Mar-16 | 30            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Apr-16 | 30            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | May-16 | 30            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Jun-16 | 30            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5057 | 2                       | APPS-5057           | Jul-16 | 30            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5058 | 2                       | APPS-5058           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Aug-15 | 20            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Sep-15 | 20            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Oct-15 | 20            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Nov-15 | 20            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Dec-15 | 20            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Jan-16 | 20            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Feb-16 | 20            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Mar-16 | 20            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Apr-16 | 20            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | May-16 | 20            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Jun-16 | 20            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5059 | 2                       | APPS-5059           | Jul-16 | 20            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Aug-15 | 30            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Sep-15 | 30            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Oct-15 | 30            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Nov-15 | 30            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Dec-15 | 30            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Jan-16 | 30            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Feb-16 | 30            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Mar-16 | 30            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Apr-16 | 30            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | May-16 | 30            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Jun-16 | 30            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5060 | 2                       | APPS-5060           | Jul-16 | 30            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5061 | 2                       | APPS-5061           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Aug-15 | 20            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Sep-15 | 20            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Oct-15 | 20            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Nov-15 | 20            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Dec-15 | 20            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Jan-16 | 20            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Feb-16 | 20            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Mar-16 | 20            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Apr-16 | 20            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | May-16 | 20            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Jun-16 | 20            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5062 | 2                       | APPS-5062           | Jul-16 | 20            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Aug-15 | 30            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Sep-15 | 30            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Oct-15 | 30            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Nov-15 | 30            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Dec-15 | 30            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Jan-16 | 30            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Feb-16 | 30            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Mar-16 | 30            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Apr-16 | 30            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | May-16 | 30            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Jun-16 | 30            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5063 | 2                       | APPS-5063           | Jul-16 | 30            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                         | Contract | Contract Version Number | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding | UDA-5064 | 2                       | APPS-5064           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   When the file for syntax validation is copied from the source location to the 'Input'
   Then A file 'MAIN AY 1516 15062015150000 PerformanceUpdateDraftAmendment.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
   And A file 'MAIN AY 1516 15062015150000 PerformanceUpdateDraftAmendment..Results Report.xlsx' is created in location 'Reports' in less than 56 seconds
   #And 'Success' is in Row '2' of the 'Results' Column on the 'Contract' tab of the result report
   #And 'Success' is in Row '3' of the 'Results' Column on the 'Contract' tab of the result report
   #And 'Success' is in Row '4' of the 'Results' Column on the 'Contract' tab of the result report
   #And 'Success' is in Row '5' of the 'Results' Column on the 'Contract' tab of the result report
   #And 'Success' is in Row '6' of the 'Results' Column on the 'Contract' tab of the result report
   #And 'Success' is in Row '7' of the 'Results' Column on the 'Contract' tab of the result report
   #And 'Success' is in Row '8' of the 'Results' Column on the 'Contract' tab of the result report
   #And 'Success' is in Row '9' of the 'Results' Column on the 'Contract' tab of the result report
   #And 'Success' is in Row '10' of the 'Results' Column on the 'Contract' tab of the result report
   #And 'Success' is in Row '11' of the 'Results' Column on the 'Contract' tab of the result report
