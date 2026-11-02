Feature: PerformancePaymentProfileCalculator

   payment profile calculation for multiple contracts

#2950 Contracts with 5960 allocations of which 2010 are pop allocations (10 deliverables per allocation)Payment profile to be calculated in 120 minutes 
#25 Payment profile to be calculated in 60 seconds
#50 Allocation with (17 PoP) Payment profile to be calculated in 60 seconds

# just do bulk import
#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P011 Feature_Contract Approvals_Test_Generate payment profile for 50 contract approvals in 120 seconds
    Given there is no Contract, Task or Workflow data for contract 'MAIN-N190' and master contract 'NFR-N190' for '50' iterations
   #And   there is no Organisation data for UKPRN '50057204'
    And   there is no Organisation data for '50' UKPRN '50057200'
    And   the contract data is now removed for ukprn beginning with '50057'
    And   caseload advisor 'FCS2 Test' is assigned to provider '24+ Learners Ltd' with UKPRN '50057200' and OrgId 'ORG50572' and has 'FCS1 Test' as a manager for 50 providers
    And   the draft contract header details are as follows with '50' iterations
    | UKPRN    | LegalName        | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId    |
    | 50057200 | 24+ Learners Ltd | NFR-N190             | MAIN-N190      | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG50572 |
   
    And   the draft contract allocations details are as follows with '50' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50057200 | MAIN-N190      | 16AP-N190     | 16-18 APPS        | AY                      | 01/08/2015          | 31/07/2016        | 64554.00        |
    | 50057200 | MAIN-N190      | ASC-N190      | ASC               | AY                      | 01/08/2015          | 31/07/2016        | 43764.00        |
    | 50057200 | MAIN-N190      | CL-N190       | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |
    | 50057200 | MAIN-N190      | DLS-N190      | DLS               | AY                      | 01/08/2015          | 31/07/2016        | 73225.00        |  
   
    And   the draft contract deliverables details are as follows with '50' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15  | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16   | May-16  | Jun-16  | Jul-16  | DeliverableDescription               | CRMIntent |
    | MAIN-N190      | 16AP-N190     | 1               | 0                     | 7418.00 | 5318.00 | 7433.00 | 7932.00 | 2923.00 | 4781.00 | 4797.00 | 2949.00 | 10111.00 | 4235.00 | 5638.00 | 1019.00 | Total 16-18 Funding                  | New       |
    | MAIN-N190      | 16AP-N190     | 2               | 1                     | 2731.00 | 1819.00 | 1517.00 | 3290.00 | 0.00    | 942.00  | 3289.00 | 1550.00 | 3612.00  | 641.00  | 2663.00 | 1019.00 | 16-18 Apprenticeships Total Funding  | New       |
    | MAIN-N190      | 16AP-N190     | 3               | 1                     | 4687.00 | 3499.00 | 5916.00 | 4642.00 | 2923.00 | 3839.00 | 1508.00 | 1399.00 | 6499.00  | 3594.00 | 2975.00 | 0.00    | 16-18 Traineeships Total Funding     | New       |
    | MAIN-N190      | 16AP-N190     | 4               | 3                     | 1431.00 | 3499.00 | 2136.00 | 3455.00 | 554.00  | 3839.00 | 992.00  | 0.00    | 3022.00  | 2784.00 | 2110.00 | 0.00    | 16-18 Traineeships Programme Funding | New       |
    | MAIN-N190      | 16AP-N190     | 5               | 3                     | 3256.00 | 0.00    | 3780.00 | 1187.00 | 2369.00 | 0.00    | 516.00  | 1399.00 | 3477.00  | 810.00  | 865.00  | 0.00    | 16-18 Traineeships Bursary Funding   | New       |
    | MAIN-N190      | ASC-N190      | 1               | 0                     | 1827.00 | 2358.00 | 4313.00 | 3416.00 | 4709.00 | 4527.00 | 3481.00 | 2537.00 | 5347.00  | 3420.00 | 2383.00 | 5446.00 | Total Adult Skills Funding           | New       |
    | MAIN-N190      | ASC-N190      | 2               | 1                     | 0.00    | 612.00  | 2223.00 | 2910.00 | 1039.00 | 3836.00 | 2647.00 | 0.00    | 1558.00  | 721.00  | 1665.00 | 3284.00 | Apprenticeships Total Funding        | New       |
    | MAIN-N190      | ASC-N190      | 3               | 1                     | 1827.00 | 1746.00 | 2090.00 | 506.00  | 3670.00 | 691.00  | 834.00  | 2537.00 | 3789.00  | 2699.00 | 718.00  | 2162.00 | Other ASB Total Funding              | New       |
    | MAIN-N190      | CL-N190       | 1               | 0                     | 0.00    | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00  | 2620.00 | 3061.00 | 3572.00  | 2287.00 | 0.00    | 0.00    | Community Learning                   | New       |
    | MAIN-N190      | DLS-N190      | 1               | 0                     | 9358.00 | 4602.00 | 6208.00 | 6624.00 | 3923.00 | 5514.00 | 3956.00 | 5584.00 | 4667.00  | 5530.00 | 8852.00 | 8407.00 | Total Discretionary Learner Support  | New       |
    | MAIN-N190      | DLS-N190      | 2               | 1                     | 3334.00 | 1427.00 | 445.00  | 3250.00 | 0.00    | 3979.00 | 0.00    | 3437.00 | 3125.00  | 581.00  | 1408.00 | 3091.00 | 19+ Hardship                         | New       |
    | MAIN-N190      | DLS-N190      | 3               | 1                     | 2296.00 | 1666.00 | 3356.00 | 2635.00 | 503.00  | 1535.00 | 1282.00 | 1259.00 | 420.00   | 3411.00 | 3762.00 | 2487.00 | 20+ Childcare                        | New       |
    | MAIN-N190      | DLS-N190      | 4               | 3                     | 3728.00 | 1509.00 | 2407.00 | 739.00  | 3420.00 | 0.00    | 2674.00 | 888.00  | 1122.00  | 1538.00 | 3682.00 | 2829.00 | Residential Access Fund              | New       |
   
    And   all the contracts exist in CRM
    And   the contracts are in a state of 'Published to Provider'
    And   todays date is '28/08/2015'
    When  all contracts are approved
    Then  the contract sub-status is now set to 'Approved'
    And   poll CRM every '2' minutes to check if the esb message has been successfull for '50' contracts in '24' seconds.
    And   the contract data is now removed from CRM

# just do bulk import
#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P011a Feature_Contract Approvals_Test_Generate payment profile for 250 contract approvals in 120 seconds
    Given there is no Contract, Task or Workflow data for contract 'MAIN-N190' and master contract 'NFR-N190' for '250' iterations
   #And   there is no Organisation data for UKPRN '50057204'
    And   there is no Organisation data for '250' UKPRN '50057200'
    And   the contract data is now removed for ukprn beginning with '5005'
    And   caseload advisor 'FCS2 Test' is assigned to provider '24+ Learners Ltd' with UKPRN '50057200' and OrgId 'ORG50572' and has 'FCS1 Test' as a manager for 250 providers
    And   the draft contract header details are as follows with '250' iterations
    | UKPRN    | LegalName        | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId    |
    | 50057200 | 24+ Learners Ltd | NFR-N190             | MAIN-N190      | 1                     | 01/08/2015        | 31/07/2016      | 30138.00      | Contract for Services | 1516   | New       | ORG50572 |
   
    And   the draft contract allocations details are as follows with '250' iterations
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue |
    | 50057200 | MAIN-N190      | 16AP-N190     | 16-18 APPS        | AY                      | 01/08/2015          | 31/07/2016        | 64554.00        |
    | 50057200 | MAIN-N190      | ASC-N190      | ASC               | AY                      | 01/08/2015          | 31/07/2016        | 43764.00        |
    | 50057200 | MAIN-N190      | CL-N190       | CL                | AY                      | 01/08/2015          | 31/07/2016        | 23763.00        |
    | 50057200 | MAIN-N190      | DLS-N190      | DLS               | AY                      | 01/08/2015          | 31/07/2016        | 73225.00        |  
   
    And   the draft contract deliverables details are as follows with '250' iterations
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15  | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16   | May-16  | Jun-16  | Jul-16  | DeliverableDescription               | CRMIntent |
    | MAIN-N190      | 16AP-N190     | 1               | 0                     | 7418.00 | 5318.00 | 7433.00 | 7932.00 | 2923.00 | 4781.00 | 4797.00 | 2949.00 | 10111.00 | 4235.00 | 5638.00 | 1019.00 | Total 16-18 Funding                  | New       |
    | MAIN-N190      | 16AP-N190     | 2               | 1                     | 2731.00 | 1819.00 | 1517.00 | 3290.00 | 0.00    | 942.00  | 3289.00 | 1550.00 | 3612.00  | 641.00  | 2663.00 | 1019.00 | 16-18 Apprenticeships Total Funding  | New       |
    | MAIN-N190      | 16AP-N190     | 3               | 1                     | 4687.00 | 3499.00 | 5916.00 | 4642.00 | 2923.00 | 3839.00 | 1508.00 | 1399.00 | 6499.00  | 3594.00 | 2975.00 | 0.00    | 16-18 Traineeships Total Funding     | New       |
    | MAIN-N190      | 16AP-N190     | 4               | 3                     | 1431.00 | 3499.00 | 2136.00 | 3455.00 | 554.00  | 3839.00 | 992.00  | 0.00    | 3022.00  | 2784.00 | 2110.00 | 0.00    | 16-18 Traineeships Programme Funding | New       |
    | MAIN-N190      | 16AP-N190     | 5               | 3                     | 3256.00 | 0.00    | 3780.00 | 1187.00 | 2369.00 | 0.00    | 516.00  | 1399.00 | 3477.00  | 810.00  | 865.00  | 0.00    | 16-18 Traineeships Bursary Funding   | New       |
    | MAIN-N190      | ASC-N190      | 1               | 0                     | 1827.00 | 2358.00 | 4313.00 | 3416.00 | 4709.00 | 4527.00 | 3481.00 | 2537.00 | 5347.00  | 3420.00 | 2383.00 | 5446.00 | Total Adult Skills Funding           | New       |
    | MAIN-N190      | ASC-N190      | 2               | 1                     | 0.00    | 612.00  | 2223.00 | 2910.00 | 1039.00 | 3836.00 | 2647.00 | 0.00    | 1558.00  | 721.00  | 1665.00 | 3284.00 | Apprenticeships Total Funding        | New       |
    | MAIN-N190      | ASC-N190      | 3               | 1                     | 1827.00 | 1746.00 | 2090.00 | 506.00  | 3670.00 | 691.00  | 834.00  | 2537.00 | 3789.00  | 2699.00 | 718.00  | 2162.00 | Other ASB Total Funding              | New       |
    | MAIN-N190      | CL-N190       | 1               | 0                     | 0.00    | 1338.00 | 3287.00 | 3999.00 | 2934.00 | 665.00  | 2620.00 | 3061.00 | 3572.00  | 2287.00 | 0.00    | 0.00    | Community Learning                   | New       |
    | MAIN-N190      | DLS-N190      | 1               | 0                     | 9358.00 | 4602.00 | 6208.00 | 6624.00 | 3923.00 | 5514.00 | 3956.00 | 5584.00 | 4667.00  | 5530.00 | 8852.00 | 8407.00 | Total Discretionary Learner Support  | New       |
    | MAIN-N190      | DLS-N190      | 2               | 1                     | 3334.00 | 1427.00 | 445.00  | 3250.00 | 0.00    | 3979.00 | 0.00    | 3437.00 | 3125.00  | 581.00  | 1408.00 | 3091.00 | 19+ Hardship                         | New       |
    | MAIN-N190      | DLS-N190      | 3               | 1                     | 2296.00 | 1666.00 | 3356.00 | 2635.00 | 503.00  | 1535.00 | 1282.00 | 1259.00 | 420.00   | 3411.00 | 3762.00 | 2487.00 | 20+ Childcare                        | New       |
    | MAIN-N190      | DLS-N190      | 4               | 3                     | 3728.00 | 1509.00 | 2407.00 | 739.00  | 3420.00 | 0.00    | 2674.00 | 888.00  | 1122.00  | 1538.00 | 3682.00 | 2829.00 | Residential Access Fund              | New       |
    
	And   all the contracts exist in CRM
    And   the contracts are in a state of 'Published to Provider'
    And   todays date is '28/08/2015'
    When  all contracts are approved
    Then  the contract sub-status is now set to 'Approved'
    And   poll CRM every '2' minutes to check if the esb message has been successfull for '250' contracts in '120' seconds.
    Then  the contract data is now removed from CRM