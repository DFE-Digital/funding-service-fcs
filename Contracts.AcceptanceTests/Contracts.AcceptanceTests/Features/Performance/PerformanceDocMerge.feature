Feature: PerformanceDocMerge
	Initiate 250 Doc merges in 2700 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P015 Merge contract documentation for 250 1516 mainstream contracts in 2700 seconds (Replaced by P041)
    Given there is no Contract, Task or Workflow data for contract 'MAIN-N600' and master contract 'NFR-N600' for '250' iterations 
    And   there is no Organisation data for '250' UKPRN '50067200'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50067200' and OrgId 'ORG50672' and has 'FCS1 Test' as a manager for 250 providers
    And   all the '250' set of DocMerge files for '50067200' and 'MAIN=N600' are cleared

    And   the draft contract header details are as follows with '250' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId    |
    | 50067200 | Perfmnce Test Ltd | NFR-N600             | MAIN-N600      | 1                     | 01/08/2016        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG50672 |
    
    And   the draft contract allocations details are as follows with '250' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50067200 | MAIN-N600      | 16AP-N600     | 16-18 APPS        | AY                      | 01/08/2015          | 31/07/2016        | 64554.00        |
    | 50067200 | MAIN-N600      | ASC-N600      | ASC               | AY                      | 01/08/2015          | 31/07/2016        | 43764.00        |
    | 50067200 | MAIN-N600      | CL-N600       | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |
    | 50067200 | MAIN-N600      | DLS-N600      | DLS               | AY                      | 01/08/2015          | 31/07/2016        | 73225.00        |  	

    And   the draft contract deliverables details are as follows with '250' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15  | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16   | May-16  | Jun-16  | Jul-16  | DeliverableDescription               | CRMIntent |
    | MAIN-N600      | 16AP-N600     | 1               | 0                     | 7418.00 | 5318.00 | 7433.00 | 7932.00 | 2923.00 | 4781.00 | 4797.00 | 2949.00 | 10111.00 | 4235.00 | 5638.00 | 1019.00 | Total 16-18 Funding                  | New       |
    | MAIN-N600      | 16AP-N600     | 2               | 1                     | 2731.00 | 1819.00 | 1517.00 | 3290.00 | 0.00    | 942.00  | 3289.00 | 1550.00 | 3612.00  | 641.00  | 2663.00 | 1019.00 | 16-18 Apprenticeships Total Funding  | New       |
    | MAIN-N600      | 16AP-N600     | 3               | 1                     | 4687.00 | 3499.00 | 5916.00 | 4642.00 | 2923.00 | 3839.00 | 1508.00 | 1399.00 | 6499.00  | 3594.00 | 2975.00 | 0.00    | 16-18 Traineeships Total Funding     | New       |
    | MAIN-N600      | 16AP-N600     | 4               | 3                     | 1431.00 | 3499.00 | 2136.00 | 3455.00 | 554.00  | 3839.00 | 992.00  | 0.00    | 3022.00  | 2784.00 | 2110.00 | 0.00    | 16-18 Traineeships Programme Funding | New       |
    | MAIN-N600      | 16AP-N600     | 5               | 3                     | 3256.00 | 0.00    | 3780.00 | 1187.00 | 2369.00 | 0.00    | 516.00  | 1399.00 | 3477.00  | 810.00  | 865.00  | 0.00    | 16-18 Traineeships Bursary Funding   | New       |
    | MAIN-N600      | ASC-N600      | 1               | 0                     | 1827.00 | 2358.00 | 4313.00 | 3416.00 | 4709.00 | 4527.00 | 3481.00 | 2537.00 | 5347.00  | 3420.00 | 2383.00 | 5446.00 | Total Adult Skills Funding           | New       |
    | MAIN-N600      | ASC-N600      | 2               | 1                     | 0.00    | 612.00  | 2223.00 | 2910.00 | 1039.00 | 3836.00 | 2647.00 | 0.00    | 1558.00  | 721.00  | 1665.00 | 3284.00 | Apprenticeships Total Funding        | New       |
    | MAIN-N600      | ASC-N600      | 3               | 1                     | 1827.00 | 1746.00 | 2090.00 | 506.00  | 3670.00 | 691.00  | 834.00  | 2537.00 | 3789.00  | 2699.00 | 718.00  | 2162.00 | Other ASB Total Funding              | New       |
    | MAIN-N600      | CL-N600       | 1               | 0                     | 0.00    | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00  | 2620.00 | 3061.00 | 3572.00  | 2287.00 | 0.00    | 0.00    | Community Learning                   | New       |
    | MAIN-N600      | DLS-N600      | 1               | 0                     | 9358.00 | 4602.00 | 6208.00 | 6624.00 | 3923.00 | 5514.00 | 3956.00 | 5584.00 | 4667.00  | 5530.00 | 8852.00 | 8407.00 | Total Discretionary Learner Support  | New       |
    | MAIN-N600      | DLS-N600      | 2               | 1                     | 3334.00 | 1427.00 | 445.00  | 3250.00 | 0.00    | 3979.00 | 0.00    | 3437.00 | 3125.00  | 581.00  | 1408.00 | 3091.00 | 19+ Hardship                         | New       |
    | MAIN-N600      | DLS-N600      | 3               | 1                     | 2296.00 | 1666.00 | 3356.00 | 2635.00 | 503.00  | 1535.00 | 1282.00 | 1259.00 | 420.00   | 3411.00 | 3762.00 | 2487.00 | 20+ Childcare                        | New       |
    | MAIN-N600      | DLS-N600      | 4               | 3                     | 3728.00 | 1509.00 | 2407.00 | 739.00  | 3420.00 | 0.00    | 2674.00 | 888.00  | 1122.00  | 1538.00 | 3682.00 | 2829.00 | Residential Access Fund              | New       |
   	
    And   all the contract exists in CRM
    And   the contract status is set to 'Draft'
    And   the contract sub-status is set to 'Awaiting Documentation'
    And   '250' files named '50067200' concatenated with '_MAIN-N600' concatenated with '_v1.pdf' are created in the location 'MAIN-1516-Input-Appendices' based on file '22228858_MAIN-861_v1.pdf'
    And   '250' files named '50067200' concatenated with '_MAIN-N600' concatenated with '_01.pdf' are created in the location 'Main-1516-Input-Terms And Conditions' based on file '22228858_MAIN-861_01.pdf'
    And   a timer is started
    When  the latest version of '250' contract 'MAIN-N600' is 'Initiate Document Merge'
    Then  '250' files named '50067200' concatenated with '_MAIN-N600' concatenated with '_v1.pdf' is created in the location 'Main-1516-Output-Merged Document' 
    And   the contract sub-status is now set to 'In Review'
    And   the timer should be less than 2700 seconds 

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P041 Merge contract documentation for 5 1516 mainstream contracts in 2700 seconds
    Given there is no Contract, Task or Workflow data for contract 'MAIN-20000' and master contract 'SFA-20000' for '5' iterations 
    And   there is no Organisation data for '5' consecutive UKPRNs commencing at '50020000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50020000' and OrgId 'ORG0020000' and has 'FCS1 Test' as a manager for 5 providers
    And   all DocMerge files have been deleted for '5' consecutive UKPRNs starting at '50020000' and ContractNumbers starting at 'MAIN-20000'

    And   the draft contract header details are as follows with '5' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50020000 | Perfmnce Test Ltd | SFA-20000            | MAIN-20000     | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG0020000 |

    And   the draft contract allocations details are as follows with '5' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50020000 | MAIN-20000     | CL-20000      | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |

    And   the draft contract deliverables details are as follows with '5' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16 | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent | DisplayOrder |
    | MAIN-20000     | CL-20000      | 1               | 0                     | 0.00   | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00 | 2620.00 | 3061.00 | 3572.00 | 2287.00 | 0.00   | 0.00   | Community Learning     | New       | 1            |

    And   all the contracts exist in CRM
   # Contracts are now at Draft\Awaiting Documentation state   
	
    And   file '50000000_MAIN-00000_v1.pdf' is copied '5' times from Sharepoint folder 'PerformanceDataFiles' to 'MAIN-1516-Input-Appendices' with incremented UKPRNs and contract numbers 
    And   file '50000000_MAIN-00000_01.pdf' is copied '5' times from Sharepoint folder 'PerformanceDataFiles' to 'MAIN-1516-Input-Terms And Conditions' with incremented UKPRNs and contract numbers

    And   a timer is started
    When  an 'Initiate Document Merge' action is triggered in CRM for each of the '5' contracts in this test
	Then  there are '5' files in 500 seconds in Sharepoint folder 'Main-1516-Output-Merged Document' prefixed '5002' 
  
   # Set timer high until test runs E2E ok 
	And   the timer should be less than 10000 seconds 

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P042 Merge contract documentation for 250 1516 mainstream contracts in 2700 seconds
    Given there is no Contract, Task or Workflow data for contract 'MAIN-20000' and master contract 'SFA-20000' for '250' iterations 
    And   there is no Organisation data for '250' consecutive UKPRNs commencing at '50020000'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Perfmnce Test Ltd' with UKPRN '50020000' and OrgId 'ORG0020000' and has 'FCS1 Test' as a manager for 250 providers
    And   all DocMerge files have been deleted for '250' consecutive UKPRNs starting at '50020000' and ContractNumbers starting at 'MAIN-20000'

    And   the draft contract header details are as follows with '250' iterations
    | UKPRN    | LegalName         | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 50020000 | Perfmnce Test Ltd | SFA-20000            | MAIN-20000     | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG0020000 |

    And   the draft contract allocations details are as follows with '250' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50020000 | MAIN-20000     | CL-20000      | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |

    And   the draft contract deliverables details are as follows with '250' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16 | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent | DisplayOrder |
    | MAIN-20000     | CL-20000      | 1               | 0                     | 0.00   | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00 | 2620.00 | 3061.00 | 3572.00 | 2287.00 | 0.00   | 0.00   | Community Learning     | New       | 1            |

    And   all the contracts exist in CRM
   # Contracts are now at Draft\Awaiting Documentation state   
	
    And   file '50000000_MAIN-00000_V1.pdf' is copied '250' times from Sharepoint folder 'PerformanceDataFiles' to 'MAIN-1516-Input-Appendices' with incremented UKPRNs and contract numbers 
    And   file '50000000_MAIN-00000_01.pdf' is copied '250' times from Sharepoint folder 'PerformanceDataFiles' to 'MAIN-1516-Input-Terms And Conditions' with incremented UKPRNs and contract numbers

    And   a timer is started
    When  an 'Initiate Document Merge' action is triggered in CRM for each of the '250' contracts in this test
	Then  there are '250' files in 5000 seconds in Sharepoint folder 'Main-1516-Output-Merged Document' prefixed '5002' 
  
   # Set timer high until test runs E2E ok 
	And   the timer should be less than 10000 seconds 


