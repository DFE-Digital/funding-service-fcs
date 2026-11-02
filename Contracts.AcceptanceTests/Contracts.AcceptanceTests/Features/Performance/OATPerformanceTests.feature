Feature: OATPerformanceTests
   Load files with lots of data and then tidy up
#5000 new contracts and 5000 Amemendments to new contracts should be uploaded in 15 hours 
#100 contracts to be processed in 540 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P004 Feature_BulkLoad_UpdateDraft_Test_Load 1000 Update Drafts in 5400 seconds 
   Given an excel spreadsheet 'MAIN AY 1516 03062015143002 BUpdateDraftPerformance1000.xlsx' exist at 'DataFiles\Performance'
   And   a timer is started
   When  the file for syntax validation is copied from the source location to the 'Input'
   Then  a results report excel spreadsheet is generated in the storage less than 7400 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P005 Feature_BulkLoad_Amendment_Test_Load 1000 Amend contracts in 5400 seconds 
   Given an excel spreadsheet 'MAIN AY 1516 03062015143003 BAmendmentPerformance1000.xlsx' exist at 'DataFiles\Performance'
   And the contracts are all in approved state
   And  a timer is started
   When the file for syntax validation is copied from the source location to the 'Input'
   Then a results report excel spreadsheet is generated in the storage less than 7400 seconds
   Then results report is generated in 5400 seconds
   #And all contracts have been successful

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
	Scenario: P005b Feature_BulkLoad_Amendment_Test_Load 1000 Amend contracts in 5400 seconds 
    Given an excel spreadsheet 'MAIN AY 1516 03062015143003 BAmendmentPerformance1000.xlsx' exist at 'DataFiles\Performance'
	And there is no Contract, Task or Workflow data for contract 'MAIN-N26' and master contract 'NFR-N26' for '1000' iterations 
	And there is no Organisation data for '1000' UKPRN '50030001'
	And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50030001' and OrgId 'ORG61672' and has 'FCS1 Test' as a manager for 500 providers
	And all the '1000' set of DocMerge files for '50030001' and 'MAIN-3001' are cleared
	And the draft contract header details are as follows with '1000' iterations
	| UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId    |
	| 50030001 | Perfmnce Test Ltd | SFA-3001             | MAIN-3001      | 1                     | 01/08/2016        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG61672 |
	And   the draft contract allocations details are as follows with '1000' iterations
	| UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
	| 50030001 | MAIN-3001      | 16AP-N26      | 16-18 APPS        | AY                      | 01/08/2015          | 31/07/2016        | 64554.00        |
	| 50030001 | MAIN-3001      | ASC-N26       | ASC               | AY                      | 01/08/2015          | 31/07/2016        | 43764.00        |
	| 50030001 | MAIN-3001      | CL-N26        | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |
	| 50030001 | MAIN-3001      | DLS-N26       | DLS               | AY                      | 01/08/2015          | 31/07/2016        | 73225.00        | 	
	And   the draft contract deliverables details are as follows with '1000' iterations
	| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15  | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16   | May-16  | Jun-16  | Jul-16  | DeliverableDescription               | CRMIntent |
	| MAIN-N26       | 16AP-N26      | 1               | 0                     | 7418.00 | 5318.00 | 7433.00 | 7932.00 | 2923.00 | 4781.00 | 4797.00 | 2949.00 | 10111.00 | 4235.00 | 5638.00 | 1019.00 | Total 16-18 Funding                  | New       |
	| MAIN-N26       | 16AP-N26      | 2               | 1                     | 2731.00 | 1819.00 | 1517.00 | 3290.00 | 0.00    | 942.00  | 3289.00 | 1550.00 | 3612.00  | 641.00  | 2663.00 | 1019.00 | 16-18 Apprenticeships Total Funding  | New       |
	| MAIN-N26       | 16AP-N26      | 3               | 1                     | 4687.00 | 3499.00 | 5916.00 | 4642.00 | 2923.00 | 3839.00 | 1508.00 | 1399.00 | 6499.00  | 3594.00 | 2975.00 | 0.00    | 16-18 Traineeships Total Funding     | New       |
	| MAIN-N26       | 16AP-N26      | 4               | 3                     | 1431.00 | 3499.00 | 2136.00 | 3455.00 | 554.00  | 3839.00 | 992.00  | 0.00    | 3022.00  | 2784.00 | 2110.00 | 0.00    | 16-18 Traineeships Programme Funding | New       |
	| MAIN-N26       | 16AP-N26      | 5               | 3                     | 3256.00 | 0.00    | 3780.00 | 1187.00 | 2369.00 | 0.00    | 516.00  | 1399.00 | 3477.00  | 810.00  | 865.00  | 0.00    | 16-18 Traineeships Bursary Funding   | New       |
	| MAIN-N26       | ASC-N26       | 1               | 0                     | 1827.00 | 2358.00 | 4313.00 | 3416.00 | 4709.00 | 4527.00 | 3481.00 | 2537.00 | 5347.00  | 3420.00 | 2383.00 | 5446.00 | Total Adult Skills Funding           | New       |
	| MAIN-N26       | ASC-N26       | 2               | 1                     | 0.00    | 612.00  | 2223.00 | 2910.00 | 1039.00 | 3836.00 | 2647.00 | 0.00    | 1558.00  | 721.00  | 1665.00 | 3284.00 | Apprenticeships Total Funding        | New       |
	| MAIN-N26       | ASC-N26       | 3               | 1                     | 1827.00 | 1746.00 | 2090.00 | 506.00  | 3670.00 | 691.00  | 834.00  | 2537.00 | 3789.00  | 2699.00 | 718.00  | 2162.00 | Other ASB Total Funding              | New       |
	| MAIN-N26       | CL-N26        | 1               | 0                     | 0.00    | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00  | 2620.00 | 3061.00 | 3572.00  | 2287.00 | 0.00    | 0.00    | Community Learning                   | New       |
	| MAIN-N26       | DLS-N26       | 1               | 0                     | 9358.00 | 4602.00 | 6208.00 | 6624.00 | 3923.00 | 5514.00 | 3956.00 | 5584.00 | 4667.00  | 5530.00 | 8852.00 | 8407.00 | Total Discretionary Learner Support  | New       |
	| MAIN-N26       | DLS-N26       | 2               | 1                     | 3334.00 | 1427.00 | 445.00  | 3250.00 | 0.00    | 3979.00 | 0.00    | 3437.00 | 3125.00  | 581.00  | 1408.00 | 3091.00 | 19+ Hardship                         | New       |
	| MAIN-N26       | DLS-N26       | 3               | 1                     | 2296.00 | 1666.00 | 3356.00 | 2635.00 | 503.00  | 1535.00 | 1282.00 | 1259.00 | 420.00   | 3411.00 | 3762.00 | 2487.00 | 20+ Childcare                        | New       |
	| MAIN-N26       | DLS-N26       | 4               | 3                     | 3728.00 | 1509.00 | 2407.00 | 739.00  | 3420.00 | 0.00    | 2674.00 | 888.00  | 1122.00  | 1538.00 | 3682.00 | 2829.00 | Residential Access Fund              | New       |
	And   all the contract exists in CRM
	And   the contracts are all in approved state
	And   a timer is started
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a results report excel spreadsheet is generated in storage in less than 5400 seconds
     #And all contracts have been successful

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P005c Bulk amend 1000 1516 mainstream contracts in under 5400 seconds (Replaced by P033)
    Given an excel spreadsheet 'MAIN AY 1516 03062015143003 BAmendmentPerformance1000b.xlsx' exist at 'DataFiles\Performance'
    And   there is no Contract, Task or Workflow data for contract 'MAIN-44768' and master contract 'SFA-51950' for '1000' iterations 
    And   there is no Organisation data for '1000' consecutive UKPRNs commencing at '50030001'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50030001' and OrgId 'ORG61672' and has 'FCS1 Test' as a manager for 1000 providers
    And   all the '1000' set of DocMerge files for '50030001' and 'MAIN-44768' are cleared
    And   the draft contract header details are as follows with '1000' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId    |
    | 50030001 | Perfmnce Test Ltd | SFA-51950            | MAIN-44768     | 1                     | 01/08/2016        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG61672 |

    And   the draft contract allocations details are as follows with '1000' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50030001 | MAIN-44768     | CL-23113      | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |

    And   the draft contract deliverables details are as follows with '1000' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15  | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16   | May-16  | Jun-16  | Jul-16  | DeliverableDescription               | CRMIntent |
    | MAIN-44768     | CL-23113      | 1               | 0                     | 0.00    | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00  | 2620.00 | 3061.00 | 3572.00  | 2287.00 | 0.00    | 0.00    | Community Learning                   | New       |

    And   all the contracts exist in CRM
   # Contracts are now at Draft\Awaiting Documentation state

    And   all the contracts are approved
   # Contracts are now at Approved\Approved state

    And   a timer is started
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a results report excel spreadsheet is generated in storage in less than 5400 seconds

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P031 Bulk amend 5 1516 mainstream contracts in under 5400 seconds 
    Given there is no Contract, Task or Workflow data for contract 'MAIN-60000' and master contract 'SFA-60000' for '5' iterations 
    And   there is no Organisation data for '5' consecutive UKPRNs commencing at '50060000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50060000' and OrgId 'ORG0060000' and has 'FCS1 Test' as a manager for 5 providers
    And   all DocMerge files have been deleted for '5' consecutive UKPRNs starting at '50060000' and ContractNumbers starting at 'MAIN-60000'

    And   the draft contract header details are as follows with '5' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50060000 | Perfmnce Test Ltd | SFA-60000            | MAIN-60000     | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG0060000 |

    And   the draft contract allocations details are as follows with '5' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50060000 | MAIN-60000     | CL-60000      | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |

    And   the draft contract deliverables details are as follows with '5' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16 | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent | DisplayOrder |
    | MAIN-60000     | CL-60000      | 1               | 0                     | 0.00   | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00 | 2620.00 | 3061.00 | 3572.00 | 2287.00 | 0.00   | 0.00   | Community Learning     | New       | 1            |

    And   all the contracts exist in CRM
   # Contracts are now at Draft\Awaiting Documentation state

    And   all the contracts are approved
   # Contracts are now at Approved\Approved state

    And   a file named 'MAIN AY 1516 30122016000000 v2_P031.xlsx' exists in 'DataFiles\Performance'
    And   a timer is started
    When  the file is copied to the Sharepoint 'Input' folder
  
   # Set check of timer to a value much higher than desired until true time is known
    Then  a results report excel spreadsheet is generated in storage in less than 8000 seconds
   # Check that the bulk file has been processed successfully

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P032 Bulk new amend 5 CL mainstream contracts in under 5400 seconds 
    Given there is no Contract, Task or Workflow data for contract 'MAIN-70000' and master contract 'SFA-70000' for '5' iterations 
    And   there is no Organisation data for '5' consecutive UKPRNs commencing at '50070000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50070000' and OrgId 'ORG0070000' and has 'FCS1 Test' as a manager for 5 providers
    And   all DocMerge files have been deleted for '5' consecutive UKPRNs starting at '50070000' and ContractNumbers starting at 'MAIN-70000'

    And   the draft contract header details are as follows with '5' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50070000 | Perfmnce Test Ltd | SFA-70000            | MAIN-70000     | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG0070000 |

    And   the draft contract allocations details are as follows with '5' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50070000 | MAIN-70000     | CL-70000      | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |

    And   the draft contract deliverables details are as follows with '5' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16 | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent | DisplayOrder |
    | MAIN-70000     | CL-70000      | 1               | 0                     | 0.00   | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00 | 2620.00 | 3061.00 | 3572.00 | 2287.00 | 0.00   | 0.00   | Community Learning     | New       | 1            |

    And   all the contracts exist in CRM
    And   all the contracts are approved

    And   a file named 'MAIN AY 1617 09012017160543 v2_P032.xlsx' exists in 'DataFiles\Performance'
    And   a timer is started
    When  the file is copied to the Sharepoint 'Input' folder
  
   # Set check of timer to a value much higher than desired until true time is known
    Then  a results report excel spreadsheet is generated in storage in less than 8000 seconds
   # Check that the bulk file has been processed successfully

#@PerformanceDaily
@PerformanceWeekly
@ReportPerformance
Scenario: P033 Bulk amend 1000 1516 mainstream contracts in under 5400 seconds 
    Given there is no Contract, Task or Workflow data for contract 'MAIN-60000' and master contract 'SFA-60000' for '1000' iterations 
    And   there is no Organisation data for '1000' consecutive UKPRNs commencing at '50060000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50060000' and OrgId 'ORG0060000' and has 'FCS1 Test' as a manager for 1000 providers
    And   all DocMerge files have been deleted for '1000' consecutive UKPRNs starting at '50060000' and ContractNumbers starting at 'MAIN-60000'

    And   the draft contract header details are as follows with '1000' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50060000 | Perfmnce Test Ltd | SFA-60000            | MAIN-60000     | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG0060000 |

    And   the draft contract allocations details are as follows with '1000' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50060000 | MAIN-60000     | CL-60000      | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |

    And   the draft contract deliverables details are as follows with '1000' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16 | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent | DisplayOrder |
    | MAIN-60000     | CL-60000      | 1               | 0                     | 0.00   | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00 | 2620.00 | 3061.00 | 3572.00 | 2287.00 | 0.00   | 0.00   | Community Learning     | New       | 1            |

    And   all the contracts exist in CRM
   # Contracts are now at Draft\Awaiting Documentation state

    And   all the contracts are approved
   # Contracts are now at Approved\Approved state

    And   a file named 'MAIN AY 1516 30122016000000 v2_P033.xlsx' exists in 'DataFiles\Performance'
    And   a timer is started
    When  the file is copied to the Sharepoint 'Input' folder
  
   # Set check of timer to a value much higher than desired until true time is known
    Then  a results report excel spreadsheet is generated in storage in less than 8000 seconds
   # Check that the bulk file has been processed successfully

#@PerformanceDaily
@PerformanceWeekly
@ReportPerformance
Scenario: P034 Bulk new amend 1000 CL mainstream contracts in under 5400 seconds 
    Given there is no Contract, Task or Workflow data for contract 'MAIN-70000' and master contract 'SFA-70000' for '1000' iterations 
    And   there is no Organisation data for '1000' consecutive UKPRNs commencing at '50070000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50070000' and OrgId 'ORG0070000' and has 'FCS1 Test' as a manager for 1000 providers
    And   all DocMerge files have been deleted for '1000' consecutive UKPRNs starting at '50070000' and ContractNumbers starting at 'MAIN-70000'

    And   the draft contract header details are as follows with '1000' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50070000 | Perfmnce Test Ltd | SFA-70000            | MAIN-70000     | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG0070000 |

    And   the draft contract allocations details are as follows with '1000' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50070000 | MAIN-70000     | CL-70000      | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |

    And   the draft contract deliverables details are as follows with '1000' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16 | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent | DisplayOrder |
    | MAIN-70000     | CL-70000      | 1               | 0                     | 0.00   | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00 | 2620.00 | 3061.00 | 3572.00 | 2287.00 | 0.00   | 0.00   | Community Learning     | New       | 1            |

    And   all the contracts exist in CRM
    And   all the contracts are approved

    And   a file named 'MAIN AY 1617 09012017164222 v2_P034.xlsx' exists in 'DataFiles\Performance'
    And   a timer is started
    When  the file is copied to the Sharepoint 'Input' folder
  
   # Set check of timer to a value much higher than desired until true time is known
    Then  a results report excel spreadsheet is generated in storage in less than 8000 seconds
   # Check that the bulk file has been processed successfully

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P006 Feature_BulkLoad_UpdateDraftAmendments_Test_Load 1000 Draft Amendments in 5400 seconds 
   Given an excel spreadsheet 'MAIN AY 1516 03062015143004 BUpdateDraftAmendPerformance1000.xlsx' exist at 'DataFiles\Performance'
   And  a timer is started
   When the file for syntax validation is copied from the source location to the 'Input'
   Then a results report excel spreadsheet is generated in the storage less than 7400 seconds
   Then results report is generated in 5400 seconds
   #And all contracts have been successful
    
@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P013 Bulk load 25 new ESF contracts in 270 seconds 
   Given an excel spreadsheet 'ESF ESF 1420 10042015154100 ESFPerformance25.xlsx' exist at 'DataFiles\Performance' containing '25' contracts
   And   there is no contract data for any UKPRNs beginning with '5001'
   When  the file for syntax validation is copied from the source location to the 'Input'
   Then  a file 'ESF ESF 1420 10042015154100 ESFPerformance25.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
   And   a results report excel spreadsheet is generated in the storage less than 540 seconds
   And   the total time taken is less than 270 seconds

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P013a Bulk load 50 new ESF contracts in 540 seconds 
    Given an excel spreadsheet 'ESF ESF 1420 10042015154100 ESFPerformance50.xlsx' exist at 'DataFiles\Performance' containing '50' contracts
    And   there is no contract data for any UKPRNs beginning with '50010'
	And   a timer is started
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'ESF ESF 1420 10042015154100 ESFPerformance50.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    Then  a results report excel spreadsheet is generated in the storage less than 1080 seconds
    Then  the total time taken is less than 540 seconds

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P013b Bulk load 100 new ESF contracts in 1080 seconds 
    Given an excel spreadsheet 'ESF ESF 1420 10042015154100 ESFPerformance100.xlsx' exist at 'DataFiles\Performance' containing '100' contracts
    And   the contract data is now removed for ukprn beginning with '50010'
    And   a timer is started
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'ESF ESF 1420 10042015154100 ESFPerformance100.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 2160 seconds
    And   the total time taken is less than 1080 seconds

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P013c Bulk load 200 new 18mth ESF contracts with 5 deliverables each in 2160 seconds 
    Given an excel spreadsheet 'ESF ESF 1420 03012017115723 v2_P013c.xlsx' exists at 'DataFiles\Performance' containing '200' contracts
    And   there is no contract data for any UKPRNs beginning with '5001'
	And   a timer is started
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a file 'ESF ESF 1420 03012017115723 v2_P013c.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 4320 seconds
    And   the total time taken is less than 2160 seconds

#@PerformanceDaily
@PerformanceWeekly
@ReportPerformance
Scenario: P013d Bulk load 500 new 18mth ESF contracts with 5 deliverables each in 5400 seconds 
    Given an excel spreadsheet 'ESF ESF 1420 03012017115506 v2_P013d.xlsx' exists at 'DataFiles\Performance' containing '500' contracts
    And   there is no contract data for any UKPRNs beginning with '5001'
	And   a timer is started
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a file 'ESF ESF 1420 03012017115506 v2_P013d.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 10800 seconds
    And   the total time taken is less than 5400 seconds

@PerformanceDaily
@PerformanceWeekly
@ReportPerformance
Scenario: P013e Bulk load 1000 new 18mth ESF contracts with 5 deliverables each in 10800 seconds 
    Given an excel spreadsheet 'ESF ESF 1420 03012017111053 v2_P013e.xlsx' exists at 'DataFiles\Performance' containing '1000' contracts 
    And   there is no contract data for any UKPRNs beginning with '5001'
    And   a timer is started
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a file 'ESF ESF 1420 03012017111053 v2_P013e.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 21600 seconds
    And   the total time taken is less than 10800 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P014 Feature_BulkLoad_New_Test_Load 1000 new contracts in 5400 seconds 
   Given an excel spreadsheet 'MAIN AY 1516 03062015143001 BNPerformance1000.xlsx' exist at 'DataFiles\Performance' containing '1000' contracts 
   And the contract data is now removed for ukprn beginning with '5001'
   When the file for syntax validation is copied from the source location to the 'Input'
   Then a results report excel spreadsheet is generated in the storage less than 10800 seconds
   Then the total time taken is less than 5400 seconds
   #Then results report is generated in 5400 seconds
   #And the contract data is now removed
   #And all contracts have been successful

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P014a Feature_BulkLoad_New_Test_Load 500 new contracts in 2700 seconds 
   Given an excel spreadsheet 'MAIN AY 1516 03062015143001 BNPerformance500.xlsx' exist at 'DataFiles\Performance' containing '500' contracts 
   And the contract data is now removed for ukprn beginning with '5001'
   When the file for syntax validation is copied from the source location to the 'Input'
   Then a results report excel spreadsheet is generated in the storage less than 5400 seconds
   Then the total time taken is less than 2700 seconds
   #Then results report is generated in 5400 seconds
   #And the contract data is now removed
   #And all contracts have been successful

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P050 Create and approve a specified number of 1516 mainstream contracts 
    Given there is no Contract, Task or Workflow data for contract 'MAIN-80001' and master contract 'SFA-80001' for '10' iterations 
    And   there is no Organisation data for '10' consecutive UKPRNs commencing at '50080001'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50080001' and OrgId 'ORG0080001' and has 'FCS1 Test' as a manager for 10 providers
    And   all DocMerge files have been deleted for '10' consecutive UKPRNs starting at '50080001' and ContractNumbers starting at 'MAIN-80001'

    And   the draft contract header details are as follows with '10' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50080001 | Perfmnce Test Ltd | SFA-80001            | MAIN-80001     | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG0080001 |

    And   the draft contract allocations details are as follows with '10' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50080001 | MAIN-80001     | CL-80001      | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |

    And   the draft contract deliverables details are as follows with '10' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16 | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent | DisplayOrder |
    | MAIN-80001     | CL-80001      | 1               | 0                     | 0.00   | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00 | 2620.00 | 3061.00 | 3572.00 | 2287.00 | 0.00   | 0.00   | Community Learning     | New       | 1            |

    And   all the contracts exist in CRM
   # Contracts are now at Draft\Awaiting Documentation state

    And   all the contracts are approved
   # Contracts are now at Approved\Approved state

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P051 Consume 10 DAS Levy INITIATED events into CRM and process them through to PublishToProvider in under ? seconds
    Given there is no DAS Levy contract data in PaaS or CRM for any UKPRNs prefixed '5008'
    And   there are no entries in the ContractManagement.EngagementEvent table
    And   there is no Levy event data in the DAS agreement stub
    And   a timer is started
    When  the DAS Levy INITIATED events in 'DataFiles\Performance\P051.txt' are processed into CRM 
   # Data in P051.txt looks like this, including the header line:
   # Id,Event,CreatedOn,ProviderId,EmployerAccountId
   # 6063,INITIATED,2017-01-04T09:19:00.1018,50080001,10945
   # 6064,INITIATED,2017-01-04T09:19:00.1026,50080002,10960
   # 6065,INITIATED,2017-01-04T09:19:00.1033,50080003,10989

    Then  there should be 10 DAS Levy contracts in CRM within 500 seconds for UKPRNs prefixed '5008' with a sub-status of 'Published to Provider' 
    And   the timer should be less than 1000 seconds
	
@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P052 Consume 50 DAS Levy INITIATED events into CRM and process them through to PublishToProvider in under ? seconds
    Given there is no DAS Levy contract data in PaaS or CRM for any UKPRNs prefixed '5008'
    And   there are no entries in the ContractManagement.EngagementEvent table
	And   there is no Levy event data in the DAS agreement stub
    And   a timer is started
    When  the DAS Levy INITIATED events in 'DataFiles\Performance\P052.txt' are processed into CRM 
    Then  there should be 50 DAS Levy contracts in CRM within 500 seconds for UKPRNs prefixed '5008' with a sub-status of 'Published to Provider' 
    And   the timer should be less than 1000 seconds
   
#@PerformanceDaily
@PerformanceWeekly
@ReportPerformance
Scenario: P053 Consume 500 DAS Levy INITIATED events into CRM and process them through to PublishToProvider in under ? seconds
    Given there is no DAS Levy contract data in PaaS or CRM for any UKPRNs prefixed '5008'
    And   there are no entries in the ContractManagement.EngagementEvent table
    And   there is no Levy event data in the DAS agreement stub
    And   a timer is started
    When  the DAS Levy INITIATED events in 'DataFiles\Performance\P053.txt' are processed into CRM 
    Then  there should be 500 DAS Levy contracts in CRM within 5000 seconds for UKPRNs prefixed '5008' with a sub-status of 'Published to Provider' 
    And   the timer should be less than 10000 seconds

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P091 Consume summarised actuals for 10 1617 AATO (PoA) mainstream contracts
    Given there is no Contract, Task or Workflow data for contract 'MAIN-90000' and master contract 'SFA-90000' for '10' iterations
    And   there is no Organisation data for '10' consecutive UKPRNs commencing at '50090000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50090000' and OrgId 'ORG0090000' and has 'FCS1 Test' as a manager for 10 providers
    And   there is no Subnominal data for '10' consecutive contract allocations commencing with 'AATO-90000'    
    And   there are no entries in the DCFS stub table
    And   the override date is '29/07/2016'
    
    And   the draft contract header details are as follows with '10' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50090000 | Perfmnce Test Ltd | SFA-90000            | MAIN-90000     | 1                     | 01/08/2016        | 31/07/2017      | 32785.00      | Contract for Services | 1617   | New       | ORG0090000 |

    And   the draft contract allocations details are as follows with '10' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent |
    | 50090000 | MAIN-90000     | AATO-90000    | AATO              | AY                      | 01/08/2016          | 31/07/2017        | 32785.00        |         |         |                       | New       |

    And   the draft contract deliverables details are as follows with '10' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-16  | Sep-16  | Oct-16  | Nov-16  | Dec-16  | Jan-17  | Feb-17  | Mar-17  | Apr-17  | May-17  | Jun-17  | Jul-17  | DeliverableDescription               | CRMIntent | DisplayOrder |
    | MAIN-90000     | AATO-90000    | 1               | 0                     | 1200.00 | 1980.00 | 1250.00 | 4500.00 | 1800.00 | 1322.00 | 2038.00 | 6126.00 | 2894.00 | 2275.00 | 3580.00 | 3820.00 | Adult Apprenticeships Total Funding  | New       | 1            |

    And   all the contracts exist in CRM
   # All contracts are now at Draft\Awaiting Documentation

    And   all the contracts are approved
   # All contracts are now at Approved\Approved
   
    # 
    # Load DCFS Summarised Actuals data to the stub (12 months data for each allocation)
    # 
    And   the collections data in 'DataFiles\Performance\P091.txt' is added to the stub 

    # 
    # Note: Bear in mind that half the actuals data will be discarded with the
	#         override date set to 05/02/2017
    # 
    And   the override date is '05/02/2017'
    And   a timer is started

    # 
    # Pull the data from the stub and process it into CRM
    # 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    #
    # Check that the actuals have been processed through to the atom feed
    #
    Then  the AllocationDeliveryEntry Atom feed has '10' ContractAllocationActualsReceived rows with allocation numbers prefixed 'AATO-90'  

   # Set timer high until test runs ok 
    And   the timer should be less than 10000 seconds 

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P092 Consume summarised actuals for 100 1617 AATO (PoA) mainstream contracts
    Given there is no Contract, Task or Workflow data for contract 'MAIN-90000' and master contract 'SFA-90000' for '100' iterations
    And   there is no Organisation data for '100' consecutive UKPRNs commencing at '50090000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50090000' and OrgId 'ORG0090000' and has 'FCS1 Test' as a manager for 100 providers
    And   there is no Subnominal data for '100' consecutive contract allocations commencing with 'AATO-90000'    
    And   there are no entries in the DCFS stub table
    And   the override date is '29/07/2016'
    
    And   the draft contract header details are as follows with '100' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50090000 | Perfmnce Test Ltd | SFA-90000            | MAIN-90000     | 1                     | 01/08/2016        | 31/07/2017      | 32785.00      | Contract for Services | 1617   | New       | ORG0090000 |

    And   the draft contract allocations details are as follows with '100' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent |
    | 50090000 | MAIN-90000     | AATO-90000    | AATO              | AY                      | 01/08/2016          | 31/07/2017        | 32785.00        |         |         |                       | New       |

    And   the draft contract deliverables details are as follows with '100' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-16  | Sep-16  | Oct-16  | Nov-16  | Dec-16  | Jan-17  | Feb-17  | Mar-17  | Apr-17  | May-17  | Jun-17  | Jul-17  | DeliverableDescription               | CRMIntent | DisplayOrder |
    | MAIN-90000     | AATO-90000    | 1               | 0                     | 1200.00 | 1980.00 | 1250.00 | 4500.00 | 1800.00 | 1322.00 | 2038.00 | 6126.00 | 2894.00 | 2275.00 | 3580.00 | 3820.00 | Adult Apprenticeships Total Funding  | New       | 1            |

    And   all the contracts exist in CRM
   # All contracts are now at Draft\Awaiting Documentation

    And   all the contracts are approved
   # All contracts are now at Approved\Approved
   
    # 
    # Load DCFS Summarised Actuals data to the stub (12 months data for each allocation)
    # 
    And   the collections data in 'DataFiles\Performance\P092.txt' is added to the stub 

    # 
    # Note: Bear in mind that half the actuals data will be discarded with the
    #         override date set to 05/02/2017
    # 
    And   the override date is '05/02/2017'
    And   a timer is started

    # 
    # Pull the data from the stub and process it into CRM
    # 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    #
    # Check that the actuals have been processed through to the atom feed
    #
    Then  the AllocationDeliveryEntry Atom feed has '100' ContractAllocationActualsReceived rows with allocation numbers prefixed 'AATO-90'  

   # Set timer high until test runs ok 
    And   the timer should be less than 10000 seconds 

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P093 Consume summarised actuals for 1000 1617 AATO (PoA) mainstream contracts
    Given there is no Contract, Task or Workflow data for contract 'MAIN-90000' and master contract 'SFA-90000' for '1000' iterations
    And   there is no Organisation data for '1000' consecutive UKPRNs commencing at '50090000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50090000' and OrgId 'ORG0090000' and has 'FCS1 Test' as a manager for 1000 providers
    And   there is no Subnominal data for '1000' consecutive contract allocations commencing with 'AATO-90000'    
    And   there are no entries in the DCFS stub table
    And   the override date is '29/07/2016'
    
    And   the draft contract header details are as follows with '1000' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50090000 | Perfmnce Test Ltd | SFA-90000            | MAIN-90000     | 1                     | 01/08/2016        | 31/07/2017      | 32785.00      | Contract for Services | 1617   | New       | ORG0090000 |

    And   the draft contract allocations details are as follows with '1000' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent |
    | 50090000 | MAIN-90000     | AATO-90000    | AATO              | AY                      | 01/08/2016          | 31/07/2017        | 32785.00        |         |         |                       | New       |

    And   the draft contract deliverables details are as follows with '1000' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-16  | Sep-16  | Oct-16  | Nov-16  | Dec-16  | Jan-17  | Feb-17  | Mar-17  | Apr-17  | May-17  | Jun-17  | Jul-17  | DeliverableDescription               | CRMIntent | DisplayOrder |
    | MAIN-90000     | AATO-90000    | 1               | 0                     | 1200.00 | 1980.00 | 1250.00 | 4500.00 | 1800.00 | 1322.00 | 2038.00 | 6126.00 | 2894.00 | 2275.00 | 3580.00 | 3820.00 | Adult Apprenticeships Total Funding  | New       | 1            |

    And   all the contracts exist in CRM
   # All contracts are now at Draft\Awaiting Documentation

    And   all the contracts are approved
   # All contracts are now at Approved\Approved
   
    # 
    # Load DCFS Summarised Actuals data to the stub (12 months data for each allocation)
    # 
    And   the collections data in 'DataFiles\Performance\P093.txt' is added to the stub 

    # 
    # Note: Bear in mind that half the actuals data will be discarded with the
    #         override date set to 05/02/2017
    # 
    And   the override date is '05/02/2017'
    And   a timer is started

    # 
    # Pull the data from the stub and process it into CRM
    # 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    #
    # Check that the actuals have been processed through to the atom feed
    #
    Then  the AllocationDeliveryEntry Atom feed has '1000' ContractAllocationActualsReceived rows with allocation numbers prefixed 'AATO-90'  

   # Set timer high until test runs ok 
    And   the timer should be less than 100000 seconds 

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P094 Consume summarised actuals for 3000 1617 AATO (PoA) mainstream contracts
    Given there is no Contract, Task or Workflow data for contract 'MAIN-90000' and master contract 'SFA-90000' for '3000' iterations
    And   there is no Organisation data for '3000' consecutive UKPRNs commencing at '50090000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50090000' and OrgId 'ORG0090000' and has 'FCS1 Test' as a manager for 3000 providers
    And   there is no Subnominal data for '3000' consecutive contract allocations commencing with 'AATO-90000'    
    And   there are no entries in the DCFS stub table
    And   the override date is '29/07/2016'
    
    And   the draft contract header details are as follows with '3000' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50090000 | Perfmnce Test Ltd | SFA-90000            | MAIN-90000     | 1                     | 01/08/2016        | 31/07/2017      | 32785.00      | Contract for Services | 1617   | New       | ORG0090000 |

    And   the draft contract allocations details are as follows with '3000' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent |
    | 50090000 | MAIN-90000     | AATO-90000    | AATO              | AY                      | 01/08/2016          | 31/07/2017        | 32785.00        |         |         |                       | New       |

    And   the draft contract deliverables details are as follows with '3000' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-16  | Sep-16  | Oct-16  | Nov-16  | Dec-16  | Jan-17  | Feb-17  | Mar-17  | Apr-17  | May-17  | Jun-17  | Jul-17  | DeliverableDescription               | CRMIntent | DisplayOrder |
    | MAIN-90000     | AATO-90000    | 1               | 0                     | 1200.00 | 1980.00 | 1250.00 | 4500.00 | 1800.00 | 1322.00 | 2038.00 | 6126.00 | 2894.00 | 2275.00 | 3580.00 | 3820.00 | Adult Apprenticeships Total Funding  | New       | 1            |

    And   all the contracts exist in CRM
   # All contracts are now at Draft\Awaiting Documentation

    And   all the contracts are approved
   # All contracts are now at Approved\Approved
   
    # 
    # Load DCFS Summarised Actuals data to the stub (12 months data for each allocation)
    # 
    And   the collections data in 'DataFiles\Performance\P094.txt' is added to the stub 

    # 
    # Note: Bear in mind that half the actuals data will be discarded with the
    #         override date set to 05/02/2017
    # 
    And   the override date is '05/02/2017'
    And   a timer is started

    # 
    # Pull the data from the stub and process it into CRM
    # 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    #
    # Check that the actuals have been processed through to the atom feed
    #
    Then  the AllocationDeliveryEntry Atom feed has '3000' ContractAllocationActualsReceived rows with allocation numbers prefixed 'AATO-90'  

   # Set timer high until test runs ok 
    And   the timer should be less than 100000 seconds 

