Feature: PerformanceBulkUpdateDraftContracts

   Load files with lots of update Data
#5000 new contracts and 5000 Amemendments to new contracts should be uploaded in 15 hours 
#100 contracts to be processed in 540 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P004a Seed Data for Update Draft Contract file with 1000 contracts
   Given the contract data is now removed for ukprn beginning with '5002'

  #
  # Load data for one hundred mainstream Contracts: MAIN-5001 to MAIN-5100 inclusive
  #
   And the following data in spreadsheet 'UpdateDraftOATSeedContractData.csv' existing at 'DataFiles\Performance' exists in the CRM Contract table
   | Contract No     | Version | Provider | UKPRN    | Funding Type | Contract Status  | Sub Status | Contract Value | Start Date | End Date   | Contract Owner | Contract Type         | ContractIdentifier | Current Task | Description | Documentation | Hierarchy Type | Last Approved Version | Last Workflow History | Latest Version | Parent Contract | Period | Previous Version | Reason | State | Status Reason | Sub Version | Task Owner | UPIN |

  #
  # Load data for one hundred 16-18Apps Allocations: 16AP-5001 to 16AP-5100 inclusive
  #    
   And the following data in spreadsheet 'UpdateDraftOATSeedAllocationsData.csv' existing at 'DataFiles\Performance' exists in the CRM Allocations table
   | Contract Allocation Ref | Allocation Status | Award Reference | Contract        | Contract Allocation Description | Contract Allocation Value (£) | Contract Status updated | Start Date | End Date   | Funding Stream | Funding Stream Period | Hierarchy type      | ITT Reference | LEP | LEP Code | Lot Reference | Owner      | Period | Priority | Project Description | Status | Status Reason | UoP Code | UoP Name |
   
  #
  # Load data for Deliverables 2, 4 and 5 for each of the above allocations
  #
   And the following data in spreadsheet 'UpdateDraftOATSeedDeliverablesData.csv' existing at 'DataFiles\Performance' exists in the CRM Deliverable table
   | Deliverable                          | Actual Value (£) | Actual Volume | Contract        | Contract Allocation | Deliverable Code | Deliverable Description | Funding Stream Period Deliverable    | Owner      | Planned Value (£) | Planned Volume | SSA Code | Status | Status Reason | Unit Cost |
   
  #
  # Load Deliverable Period data from 4 csv files for each of the above Deliverables
  #
   And the following data data in spreadsheet 'UpdateDraftOATSeedDeliverablePeriodData1.csv' existing at 'DataFiles\Performance' exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   
   And the following data data in spreadsheet 'UpdateDraftOATSeedDeliverablePeriodData2.csv' existing at 'DataFiles\Performance' exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   
   And the following data data in spreadsheet 'UpdateDraftOATSeedDeliverablePeriodData3.csv' existing at 'DataFiles\Performance' exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   
   And the following data data in spreadsheet 'UpdateDraftOATSeedDeliverablePeriodData4.csv' existing at 'DataFiles\Performance' exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P004b Feature_BulkLoad_UpdateDraft_Test_Load a Update Draft Contract file with 100 contracts in CRM in 540 seconds 
    Given The file 'MAIN AY 1516 09042015143000 UpdateDraftContractOATPerformance.xlsx' exists at 'DataFiles\Performance' with the following UKPRNs
    | UKPRN    |
    | 50020001 |
   
    And   CRM has an 'active' organisation for each UKPRN
    When  the file is copied from the source location to the 'Input'
    Then  a file 'MAIN AY 1516 09042015143000 UpdateDraftContractOATPerformance.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a file 'MAIN AY 1516 09042015143000 UpdateDraftContractOATPerformance.Results Report.xlsx' is created in location 'Reports' in less than 540 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P004c Feature_BulkLoad_UpdateDraft_Test_Load a Update Draft Contract file with 10 contracts in CRM in 54 seconds 
   Given The file 'MAIN AY 1516 09042015143000 UpdateDraftContractPerformance.xlsx' exists at 'DataFiles\Performance' with the following UKPRNs
   | UKPRN    |
   | 50022327 |
   | 50022356 |
   | 50022368 |
   | 50022370 |	
   | 50022375 |
   | 50022407 | 
   | 50022412 |
   | 50022424 |
   | 50022471 |
   | 50022554 |
   And CRM has an 'active' organisation for each UKPRN
   #And the contract data is now removed for ukprn beginning with '5002'
   And the following data exists in the CRM Contract table
   | Contract No     | Version | Provider | UKPRN    | Funding Type | Contract Status  | Sub Status | Contract Value | Start Date | End Date   | Contract Owner | Contract Type         | ContractIdentifier | Current Task | Description | Documentation | Hierarchy Type | Last Approved Version | Last Workflow History | Latest Version | Parent Contract | Period | Previous Version | Reason | State | Status Reason | Sub Version | Task Owner | UPIN |
   | SFA-2025        | 1       | NACRO    | 50022327 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Master         | No                    |                       | Yes            |                 |        |                  |        |       |               | 0           | FCS2 Test |      |
   | MAIN-2020       | 1       | NACRO    | 50022327 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Contract       | No                    |                       | Yes            | SFA-2025        | AY1516 |                  |        |       |               | 0           | FCS2 Test |      |
   | SFA-2026        | 1       | NACRO    | 50022356 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Master         | No                    |                       | Yes            |                 |        |                  |        |       |               | 0           | FCS2 Test |      |
   | MAIN-2021       | 1       | NACRO    | 50022356 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Contract       | No                    |                       | Yes            | SFA-2026        | AY1516 |                  |        |       |               | 0           | FCS2 Test |      |
   | SFA-2027        | 1       | NACRO    | 50022368 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Master         | No                    |                       | Yes            |                 |        |                  |        |       |               | 0           | FCS2 Test |      |
   | MAIN-2022       | 1       | NACRO    | 50022368 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Contract       | No                    |                       | Yes            | SFA-2027        | AY1516 |                  |        |       |               | 0           | FCS2 Test |      |
   | SFA-2028        | 1       | NACRO    | 50022370 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Master         | No                    |                       | Yes            |                 |        |                  |        |       |               | 0           | FCS2 Test |      |
   | MAIN-2023       | 1       | NACRO    | 50022370 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Contract       | No                    |                       | Yes            | SFA-2028        | AY1516 |                  |        |       |               | 0           | FCS2 Test |      |
   | SFA-2029        | 1       | NACRO    | 50022375 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Master         | No                    |                       | Yes            |                 |        |                  |        |       |               | 0           | FCS2 Test |      |
   | MAIN-2024       | 1       | NACRO    | 50022375 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Contract       | No                    |                       | Yes            | SFA-2029        | AY1516 |                  |        |       |               | 0           | FCS2 Test |      |
   | SFA-2030        | 1       | NACRO    | 50022407 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Master         | No                    |                       | Yes            |                 |        |                  |        |       |               | 0           | FCS2 Test |      |
   | MAIN-2025       | 1       | NACRO    | 50022407 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Contract       | No                    |                       | Yes            | SFA-2030        | AY1516 |                  |        |       |               | 0           | FCS2 Test |      |
   | SFA-2031        | 1       | NACRO    | 50022412 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Master         | No                    |                       | Yes            |                 |        |                  |        |       |               | 0           | FCS2 Test |      |
   | MAIN-2026       | 1       | NACRO    | 50022412 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Contract       | No                    |                       | Yes            | SFA-2031        | AY1516 |                  |        |       |               | 0           | FCS2 Test |      |
   | SFA-2032        | 1       | NACRO    | 50022424 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Master         | No                    |                       | Yes            |                 |        |                  |        |       |               | 0           | FCS2 Test |      |
   | MAIN-2027       | 1       | NACRO    | 50022424 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Contract       | No                    |                       | Yes            | SFA-2032        | AY1516 |                  |        |       |               | 0           | FCS2 Test |      |
   | SFA-2033        | 1       | NACRO    | 50022471 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Master         | No                    |                       | Yes            |                 |        |                  |        |       |               | 0           | FCS2 Test |      |
   | MAIN-2028       | 1       | NACRO    | 50022471 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Contract       | No                    |                       | Yes            | SFA-2033        | AY1516 |                  |        |       |               | 0           | FCS2 Test |      |
   | SFA-2034        | 1       | NACRO    | 50022554 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Master         | No                    |                       | Yes            |                 |        |                  |        |       |               | 0           | FCS2 Test |      |
   | MAIN-2029       | 1       | NACRO    | 50022554 | Mainstream   | Draft            | In Review  | 360            | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services |                    |              | Desc1       |               | Contract       | No                    |                       | Yes            | SFA-2034        | AY1516 |                  |        |       |               | 0           | FCS2 Test |      |
   And the following data exists in the CRM Allocations table
   | Contract Allocation Ref | Allocation Status | Award Reference | Contract        | Contract Allocation Description | Contract Allocation Value (£) | Contract Status updated | Start Date | End Date   | Funding Stream | Funding Stream Period | Hierarchy type      | ITT Reference | LEP | LEP Code | Lot Reference | Owner      | Period | Priority | Project Description | Status | Status Reason | UoP Code | UoP Name |
   | 16AP-2019               | Draft             |                 | MAIN-2020       |                                 | 360                           |                         | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation |               |     |          |               | FCS2 Test | AY1516 |          |                     |        |               |          |          |
   | 16AP-2020               | Draft             |                 | MAIN-2021       |                                 | 360                           |                         | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation |               |     |          |               | FCS2 Test | AY1516 |          |                     |        |               |          |          |
   | 16AP-2021               | Draft             |                 | MAIN-2022       |                                 | 360                           |                         | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation |               |     |          |               | FCS2 Test | AY1516 |          |                     |        |               |          |          |
   | 16AP-2022               | Draft             |                 | MAIN-2023       |                                 | 360                           |                         | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation |               |     |          |               | FCS2 Test | AY1516 |          |                     |        |               |          |          |
   | 16AP-2023               | Draft             |                 | MAIN-2024       |                                 | 360                           |                         | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation |               |     |          |               | FCS2 Test | AY1516 |          |                     |        |               |          |          |
   | 16AP-2024               | Draft             |                 | MAIN-2025       |                                 | 360                           |                         | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation |               |     |          |               | FCS2 Test | AY1516 |          |                     |        |               |          |          |
   | 16AP-2025               | Draft             |                 | MAIN-2026       |                                 | 360                           |                         | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation |               |     |          |               | FCS2 Test | AY1516 |          |                     |        |               |          |          |
   | 16AP-2026               | Draft             |                 | MAIN-2027       |                                 | 360                           |                         | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation |               |     |          |               | FCS2 Test | AY1516 |          |                     |        |               |          |          |
   | 16AP-2027               | Draft             |                 | MAIN-2028       |                                 | 360                           |                         | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation |               |     |          |               | FCS2 Test | AY1516 |          |                     |        |               |          |          |
   | 16AP-2028               | Draft             |                 | MAIN-2029       |                                 | 360                           |                         | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation |               |     |          |               | FCS2 Test | AY1516 |          |                     |        |               |          |          |
   And the following data exists in the CRM Deliverable table
   | Deliverable                          | Actual Value (£) | Actual Volume | Contract        | Contract Allocation | Deliverable Code | Deliverable Description | Funding Stream Period Deliverable    | Owner      | Planned Value (£) | Planned Volume | SSA Code | Status | Status Reason | Unit Cost |
   | 16-18 Apprenticeships Total Funding  |                  |               | MAIN-2020       | 16AP-2019           | 2                |                         | 16-18 Apprenticeships Total Funding  | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Programme Funding |                  |               | MAIN-2020       | 16AP-2019           | 4                |                         | 16-18 Traineeships Programme Funding | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Bursary Funding   |                  |               | MAIN-2020       | 16AP-2019           | 5                |                         | 16-18 Traineeships Bursary Funding   | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Apprenticeships Total Funding  |                  |               | MAIN-2021       | 16AP-2020           | 2                |                         | 16-18 Apprenticeships Total Funding  | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Programme Funding |                  |               | MAIN-2021       | 16AP-2020           | 4                |                         | 16-18 Traineeships Programme Funding | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Bursary Funding   |                  |               | MAIN-2021       | 16AP-2020           | 5                |                         | 16-18 Traineeships Bursary Funding   | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Apprenticeships Total Funding  |                  |               | MAIN-2022       | 16AP-2021           | 2                |                         | 16-18 Apprenticeships Total Funding  | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Programme Funding |                  |               | MAIN-2022       | 16AP-2021           | 4                |                         | 16-18 Traineeships Programme Funding | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Bursary Funding   |                  |               | MAIN-2022       | 16AP-2021           | 5                |                         | 16-18 Traineeships Bursary Funding   | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Apprenticeships Total Funding  |                  |               | MAIN-2023       | 16AP-2022           | 2                |                         | 16-18 Apprenticeships Total Funding  | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Programme Funding |                  |               | MAIN-2023       | 16AP-2022           | 4                |                         | 16-18 Traineeships Programme Funding | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Bursary Funding   |                  |               | MAIN-2023       | 16AP-2022           | 5                |                         | 16-18 Traineeships Bursary Funding   | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Apprenticeships Total Funding  |                  |               | MAIN-2024       | 16AP-2023           | 2                |                         | 16-18 Apprenticeships Total Funding  | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Programme Funding |                  |               | MAIN-2024       | 16AP-2023           | 4                |                         | 16-18 Traineeships Programme Funding | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Bursary Funding   |                  |               | MAIN-2024       | 16AP-2023           | 5                |                         | 16-18 Traineeships Bursary Funding   | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Apprenticeships Total Funding  |                  |               | MAIN-2025       | 16AP-2024           | 2                |                         | 16-18 Apprenticeships Total Funding  | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Programme Funding |                  |               | MAIN-2025       | 16AP-2024           | 4                |                         | 16-18 Traineeships Programme Funding | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Bursary Funding   |                  |               | MAIN-2025       | 16AP-2024           | 5                |                         | 16-18 Traineeships Bursary Funding   | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Apprenticeships Total Funding  |                  |               | MAIN-2026       | 16AP-2025           | 2                |                         | 16-18 Apprenticeships Total Funding  | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Programme Funding |                  |               | MAIN-2026       | 16AP-2025           | 4                |                         | 16-18 Traineeships Programme Funding | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Bursary Funding   |                  |               | MAIN-2026       | 16AP-2025           | 5                |                         | 16-18 Traineeships Bursary Funding   | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Apprenticeships Total Funding  |                  |               | MAIN-2027       | 16AP-2026           | 2                |                         | 16-18 Apprenticeships Total Funding  | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Programme Funding |                  |               | MAIN-2027       | 16AP-2026           | 4                |                         | 16-18 Traineeships Programme Funding | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Bursary Funding   |                  |               | MAIN-2027       | 16AP-2026           | 5                |                         | 16-18 Traineeships Bursary Funding   | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Apprenticeships Total Funding  |                  |               | MAIN-2028       | 16AP-2027           | 2                |                         | 16-18 Apprenticeships Total Funding  | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Programme Funding |                  |               | MAIN-2028       | 16AP-2027           | 4                |                         | 16-18 Traineeships Programme Funding | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Bursary Funding   |                  |               | MAIN-2028       | 16AP-2027           | 5                |                         | 16-18 Traineeships Bursary Funding   | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Apprenticeships Total Funding  |                  |               | MAIN-2029       | 16AP-2028           | 2                |                         | 16-18 Apprenticeships Total Funding  | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Programme Funding |                  |               | MAIN-2029       | 16AP-2028           | 4                |                         | 16-18 Traineeships Programme Funding | FCS2 Test | 120               |                |          |        |               |           |
   | 16-18 Traineeships Bursary Funding   |                  |               | MAIN-2029       | 16AP-2028           | 5                |                         | 16-18 Traineeships Bursary Funding   | FCS2 Test | 120               |                |          |        |               |           |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2019           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2019           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2019           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2020           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2020           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2020           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2021           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2021           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2021           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2022           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2022           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2022           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2023           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2023           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2023           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2024           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2024           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2024           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2025           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2025           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2025           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2026           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2026           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2026           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2027           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2027           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2027           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Apprenticeships Total Funding  | 16AP-2028           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Bursary Funding   | 16AP-2028           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   And the following data exists in the CRM Deliverable Period table
   | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Aug-15 | 10            |                | 201508        | CM          | 8             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Sep-15 | 10            |                | 201509        | CM          | 9             | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Oct-15 | 10            |                | 201510        | CM          | 10            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Nov-15 | 10            |                | 201511        | CM          | 11            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Dec-15 | 10            |                | 201512        | CM          | 12            | 2015 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Jan-16 | 10            |                | 201601        | CM          | 1             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Feb-16 | 10            |                | 201602        | CM          | 2             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Mar-16 | 10            |                | 201603        | CM          | 3             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Apr-16 | 10            |                | 201604        | CM          | 4             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | May-16 | 10            |                | 201605        | CM          | 5             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Jun-16 | 10            |                | 201606        | CM          | 6             | 2016 |
   | 16-18 Traineeships Programme Funding | 16AP-2028           | Jul-16 | 10            |                | 201607        | CM          | 7             | 2016 |
   When The file is copied from the source location to the 'Input'
   Then a file 'MAIN AY 1516 09042015143000 UpdateDraftContractPerformance.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
   And a file 'MAIN AY 1516 09042015143000 UpdateDraftContractPerformance.Results Report.xlsx' is created in location 'Reports' in less than 56 seconds


#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P004d Bulk Update Draft 1000 1516 mainstream contracts in 5400 seconds (Replaced by P081)
    Given the file 'MAIN AY 1516 09042015143000 UpdateDraftContractPerformance1000.xlsx' exists at 'DataFiles\Performance' with the following UKPRNs
    | UKPRN    |
    | 50020001 |

   # And   CRM has an 'active' organisation for each UKPRN
   # And   the contract data is now removed for ukprn beginning with '5002'
    When  The file is copied from the source location to the 'Input'
	And   a timer is started
    Then  a file 'MAIN AY 1516 09042015143000 UpdateDraftContractPerformance1000.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a file 'MAIN AY 1516 09042015143000 UpdateDraftContractPerformance1000.Results Report.xlsx' is created in location 'Reports' in less than 5400 seconds
	And   the total time taken is less than 5400 seconds

@PerformanceDaily
@PerformanceWeekly
@ReportPerformance
Scenario: P081 Bulk Update Draft 10 1516 mainstream contracts in 5400 seconds 
    Given there is no Contract, Task or Workflow data for contract 'MAIN-20000' and master contract 'SFA-20000' for '10' iterations 
    And   there is no Organisation data for '10' consecutive UKPRNs commencing at '50020000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50020000' and OrgId 'ORG0020000' and has 'FCS1 Test' as a manager for 10 providers
    And   all DocMerge files have been deleted for '1000' consecutive UKPRNs starting at '50020000' and ContractNumbers starting at 'MAIN-20000'

    And   the draft contract header details are as follows with '10' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50020000 | Perfmnce Test Ltd | SFA-20000            | MAIN-20000     | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG0020000 |

    And   the draft contract allocations details are as follows with '10' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50020000 | MAIN-20000     | CL-20000      | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |

    And   the draft contract deliverables details are as follows with '10' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16 | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent | DisplayOrder |
    | MAIN-20000     | CL-20000      | 1               | 0                     | 0.00   | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00 | 2620.00 | 3061.00 | 3572.00 | 2287.00 | 0.00   | 0.00   | Community Learning     | New       | 1            |

    And   all the contracts exist in CRM
   # Contracts are now at Draft\Awaiting Documentation state  

    And   a file named 'MAIN AY 1516 03012017162112 v2_P081.xlsx' exists in 'DataFiles\Performance'
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax results report named 'MAIN AY 1516 03012017162112 v2_P081.xlsx.Syntax Report' is created in the Sharepoint 'Reports' folder
    And   a results report excel spreadsheet is generated in storage in less than 1000 seconds
   
   # Set the check high until the test has run E2E ok
    And   the total time taken is less than 1000 seconds

@PerformanceDaily
@PerformanceWeekly
@ReportPerformance
Scenario: P082 Bulk Update Draft 1000 1516 mainstream contracts in 5400 seconds 
    Given there is no Contract, Task or Workflow data for contract 'MAIN-20000' and master contract 'SFA-20000' for '1000' iterations 
    And   there is no Organisation data for '1000' consecutive UKPRNs commencing at '50020000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50020000' and OrgId 'ORG0020000' and has 'FCS1 Test' as a manager for 1000 providers
    And   all DocMerge files have been deleted for '1000' consecutive UKPRNs starting at '50020000' and ContractNumbers starting at 'MAIN-20000'

    And   the draft contract header details are as follows with '1000' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50020000 | Perfmnce Test Ltd | SFA-20000            | MAIN-20000     | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG0020000 |

    And   the draft contract allocations details are as follows with '1000' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50020000 | MAIN-20000     | CL-20000      | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |

    And   the draft contract deliverables details are as follows with '1000' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16 | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent | DisplayOrder |
    | MAIN-20000     | CL-20000      | 1               | 0                     | 0.00   | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00 | 2620.00 | 3061.00 | 3572.00 | 2287.00 | 0.00   | 0.00   | Community Learning     | New       | 1            |

    And   all the contracts exist in CRM
   # Contracts are now at Draft\Awaiting Documentation state  

    And   a file named 'MAIN AY 1516 03012017162112 v2_P082.xlsx' exists in 'DataFiles\Performance'
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax results report named 'MAIN AY 1516 03012017162112 v2_P082.xlsx.Syntax Report' is created in the Sharepoint 'Reports' folder
    And   a results report excel spreadsheet is generated in storage in less than 10000 seconds
   
   # Set the check high until the test has run E2E ok
    And   the total time taken is less than 10000 seconds

