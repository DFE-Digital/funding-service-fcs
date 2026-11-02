Feature: UnQueueFundingAllocsE 33397

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A940 Create draft non-CFS EDSK2122 contract. Update draft 2x adding CFS data. Contract to Internally Approved. NMSS data > queue. Revise contract and auto-unqueue > v1.3. Check CRM and PaaS

    # 1. Create a draft non-CFS EDSK2122 contract with ALLB and ALLF allocs > v1.0
    # 2. Update draft adding 1619 CFS data > v1.1
    # 3. Update draft adding NFF CFS data > v1.2
    # 4. Import but don't release NMSS CFS data
    # 5. Update contract v1.2 to Internally Approved
    # 6. Release NMSS FA > queue
    # 7. Revise contract v1.2 > Auto-unqueue

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017940'
    And   there is no Funding Allocation data in CRM for UKPRN '10017940'
    And   there are no allocations marked as Under Termination for UKPRN '10017940' 
    And   there are no terminated or closed allocations for UKPRN '10017940' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017940' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017940' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017940' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017940' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-940      |
    | ALLF-940      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-940      |
    | ALLF-940      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2122          |
    | ALLF2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-940       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017940'

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017940' 
    And   there is no caseload advisor for UKPRN '10017940' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017940 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017940' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017940 Co Ltd' with UKPRN '10017940' and OrgId 'ORG0017940' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017940 | 117940 | 10017940 Co Ltd | 0              | Active                | Yes           | AA017940      | ?             | 12 Highgate Centre     | Highgate Square        | Birmingham             | ?                      | ?                      | ?                      | B12 0DX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017940 |





    # Part 1: Create a draft non-CFS EDSK2122 contract with ALLB and ALLF allocs > v1.0

    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-940'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-940'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017940 | 10017940 Co Ltd      | ESFA-940             | EDSK-940       | 1                     | 01/08/2021        | 31/07/2022      | 49217.00      |                                       | Conditions of Funding (Grant) (College)    | 2122   | New          | ORG0017940 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017940 | EDSK-940       | ALLB-940      | ALLB              | ALLB2122                | AY                      | 01/08/2021          | 31/07/2022        | 22904.00        |                                         |            |                                                             | New          |             |
    | 10017940 | EDSK-940       | ALLF-940      | ALLF              | ALLF2122                | AY                      | 01/08/2021          | 31/07/2022        | 26313.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017940 | EDSK-940       | ALLB-940      | 1               | 0                     | 22904.00  | 16776.00  | 6128.00   | 1338.00  | 2326.00  | 3062.00  | 1837.00  | 1812.00  | 903.00   | 3631.00  | 1867.00  | 3458.00  | 651.00   | 1669.00  | 350.00   | Total Advanced Learner Loans Bursary Funding                    | New          |             | 
    | 10017940 | EDSK-940       | ALLF-940      | 5               | 0                     | 26313.00  | 17815.00  | 8498.00   | 2633.00  | 1630.00  | 1922.00  | 64.00    | 2920.00  | 2737.00  | 2302.00  | 3607.00  | 3394.00  | 1314.00  | 2871.00  | 919.00   | Advanced Learner Loans Facility                                 | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-940       | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017940 | EDSK-940           | 1                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | ESFA-940           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 2: Update draft adding 1619 CFS data > v1.1
   
    # Populate the stub with 1619 (01GFE) data

    # Change the date
    Given the override date is '01/08/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017940 | 1619-AS-2122-Contract-Provider-10017940-1_6           | 1_6            | 1619                        | AS-2122            | 8142.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017940-1_6  | 1_6                    | 1619-AS-2122-Contract-Provider-10017940-1_6           | 10017940      | Furth        | 01GFE           | 8142.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017940-1_6  | 1619-002        | 8142.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017940-1_6  | 1619-002        | FY-2122              | November               | 2021              | 5553.00                   |
    | 1619-AS-2122-10017940-1_6  | 1619-002        | FY-2122              | May                    | 2022              | 2589.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017940 | 10017940 Co Ltd  | 1619-AS-2122-Contract-Provider-10017940-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 8142.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 8142.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017940 | 1619-AS-2122-Contract-Provider-10017940-1_6             | 1_6            | AS-2122 | 1619                        | 8142.00     | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 8142.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017940' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017940' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017940 | 10017940 Co Ltd  | 1619-AS-2122-Contract-Provider-10017940-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 8142.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017940 | 1619-AS-2122-Contract-Provider-10017940-1_6             | 1_6            | AS-2122 | 1619                        | 8142.00     | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017940-1_6             | [ContractNo] | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017940 | EDSK-940           | 1                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | ESFA-940           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-940       | 1                     | 0                        | 2021-08-01 09:12:35.000 |





    # Part 3: Update draft adding NFF CFS data > v1.2

    # Clear down the CFS stub
    Given there is no data in the CFS stub

    # Populate the stub with NFF (01GFE) data

    # Change the date 
    Given the override date is '11/08/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017940 | NFF-AS-2122-Contract-Provider-10017940-2_1            | 2_1            | NFF                         | AS-2122            | 20708.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10017940-2_1   | 2_1                    | NFF-AS-2122-Contract-Provider-10017940-2_1            | 10017940      | Furth        | 01GFE           | 20708.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10017940-2_1   | NFF-002         | 20708.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10017940-2_1   | NFF-002         | FY-2122              | September              | 2021              | 3010.00                   |
    | NFF-AS-2122-10017940-2_1   | NFF-002         | FY-2122              | December               | 2021              | 3977.00                   |
    | NFF-AS-2122-10017940-2_1   | NFF-002         | FY-2122              | February               | 2022              | 5078.00                   |
    | NFF-AS-2122-10017940-2_1   | NFF-002         | FY-2122              | April                  | 2022              | 3651.00                   |
    | NFF-AS-2122-10017940-2_1   | NFF-002         | FY-2122              | June                   | 2022              | 4992.00                   |
 
 
 

 
    # Consume stub data
 
    # Change the date 
    Given the override date is '13/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College2             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College2 = [CofG_College2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017940 | 10017940 Co Ltd  | NFF-AS-2122-Contract-Provider-10017940-2_1              | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 20708.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 20708.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017940 | NFF-AS-2122-Contract-Provider-10017940-2_1              | 2_1            | AS-2122 | NFF                         | 20708.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '15/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College2]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College2 = [CofG_College2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 20708.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017940' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017940' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017940 | 10017940 Co Ltd  | NFF-AS-2122-Contract-Provider-10017940-2_1              | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Released          | Released                | 20708.00    | EDSK-940      | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017940 | 10017940 Co Ltd  | 1619-AS-2122-Contract-Provider-10017940-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released                | 8142.00     | EDSK-940      | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017940 | NFF-AS-2122-Contract-Provider-10017940-2_1              | 2_1            | AS-2122 | NFF                         | 20708.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017940 | 1619-AS-2122-Contract-Provider-10017940-1_6             | 1_6            | AS-2122 | 1619                        | 8142.00     | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017940 | EDSK-940           | 1                     | 2                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 1                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | ESFA-940           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 4: Import but don't release NMSS data

    # Change the date 
    Given the override date is '11/09/2021'
    
    # Clear down the CFS stub
    Given there is no data in the CFS stub

    # Populate the stub with NMSS (01GFE) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017940 | NMSS-AY-2122-Contract-Provider-10017940-3_2           | 3_2            | NMSS                        | AY-2122            | 14827.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017940-3_2  | 3_2                    | NMSS-AY-2122-Contract-Provider-10017940-3_2           | 10017940      | Furth        | 01GFE           | 14827.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017940-3_2  | NMSS-003        | 14827.00         | Payment         |
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017940-3_2  | NMSS-003        | FY-2122              | September              | 2021              | 3737.00                   |
    | NMSS-AY-2122-10017940-3_2  | NMSS-003        | FY-2122              | November               | 2021              | 3540.00                   |
    | NMSS-AY-2122-10017940-3_2  | NMSS-003        | FY-2122              | March                  | 2022              | 3070.00                   |
    | NMSS-AY-2122-10017940-3_2  | NMSS-003        | FY-2122              | June                   | 2022              | 4480.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '13/09/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College3             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College3 = [CofG_College3]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017940 | 10017940 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017940-3_2             | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 14827.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College3]   | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-Provider-10017940-3_2             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 14827.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017940 | NMSS-AY-2122-Contract-Provider-10017940-3_2             | 3_2            | AY-2122 | NMSS                        | 14827.00    | [CofG_College3] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College3]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017940 | EDSK-940           | 1                     | 2                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 1                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | ESFA-940           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |




    # Part 5: Update contract v1.2 to Internally Approved

    # Change the date 
    Given the override date is '15/09/2021'

    # Update the contract from 'Awaiting Documentation' to 'Internally Approved'
    And   the contract sub-status is updated to 'Internally Approved' on the latest version of contract '[ContractNo]'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017940 | EDSK-940           | 1                     | 2                        | Draft            | Internally Approved                       | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 1                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | ESFA-940           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 6: Release NMSS FA > queue

    # Change the date 
    Given the override date is '17/09/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College3]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College3 = [CofG_College3]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 14827.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017940' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017940' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017940 | EDSK-940           | 1                     | 2                        | Draft            | Internally Approved                       | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 1                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | ESFA-940           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017940 | 10017940 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017940-3_2             | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | In Release        | Queued                  | 14827.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College3] | 17/09/2021 | EDSK-940            |
    | 10017940 | 10017940 Co Ltd  | NFF-AS-2122-Contract-Provider-10017940-2_1              | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Released          | Released                | 20708.00    | EDSK-940      | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017940 | 10017940 Co Ltd  | 1619-AS-2122-Contract-Provider-10017940-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released                | 8142.00     | EDSK-940      | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017940 | NMSS-AY-2122-Contract-Provider-10017940-3_2             | 3_2            | AY-2122 | NMSS                        | 14827.00    | [CofG_College3] | InRelease         | Queued                            |
    | 10017940 | NFF-AS-2122-Contract-Provider-10017940-2_1              | 2_1            | AS-2122 | NFF                         | 20708.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017940 | 1619-AS-2122-Contract-Provider-10017940-1_6             | 1_6            | AS-2122 | 1619                        | 8142.00     | [CofG_College]  | ?                 | ?                                 |





    # Part 7: Revise contract v1.2 > Auto-unqueue

    # Change the date 
    Given the override date is '19/09/2021'

    # Manager rejects internal approval using the Next Action step
    When the next action performed by manager 'FCS8 Test' on the latest version of contract '[ContractNo]' is to 'Revise' specifying the reason as 'Test A940'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017940 | EDSK-940           | 1                     | 2                        | Draft            | In Review                                 | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 1                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | EDSK-940           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017940 | ESFA-940           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017940 | 10017940 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017940-3_2             | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Released          | Released                | 14827.00    | EDSK-940      | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College3] | ?          | ?                   |
    | 10017940 | 10017940 Co Ltd  | NFF-AS-2122-Contract-Provider-10017940-2_1              | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NFF                         | 16-19ED2122     | Released          | Released                | 20708.00    | EDSK-940      | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017940 | 10017940 Co Ltd  | 1619-AS-2122-Contract-Provider-10017940-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released                | 8142.00     | EDSK-940      | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017940 | NMSS-AY-2122-Contract-Provider-10017940-3_2             | 3_2            | AY-2122 | NMSS                        | 14827.00    | [CofG_College3] | ?                 | ?                                 |
    | 10017940 | NFF-AS-2122-Contract-Provider-10017940-2_1              | 2_1            | AS-2122 | NFF                         | 20708.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017940 | 1619-AS-2122-Contract-Provider-10017940-1_6             | 1_6            | AS-2122 | 1619                        | 8142.00     | [CofG_College]  | ?                 | ?                                 |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017940' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017940' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 


    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017940 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 92894.00      | 1                     | 3                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017940 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017940 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017940 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017940 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 43677.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |
    | 10017940 | [ContractNo]       | [AllocRef_ALLB]       | ?                             | 22904.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | ALLB          | ALLB2122            | Contract Allocation   | ?                        |
    | 10017940 | [ContractNo]       | [AllocRef_ALLF]       | ?                             | 26313.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | ALLF          | ALLF2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | EDSK-940       | [AllocRef_16ED]    | 13              | 14827.00  | 0.00     | 3737.00  | 0.00     | 3540.00  | 0.00     | 0.00     | 0.00     | 3070.00  | 0.00     | 0.00     | 4480.00  | 0.00     | SSF Bursary Funds                                           |                          |
    | EDSK-940       | [AllocRef_16ED]    | 19              | 8142.00   | 0.00     | 0.00     | 0.00     | 5553.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2589.00  | 0.00     | 0.00     | 16-19 Bursary Funds                                         |                          |
    | EDSK-940       | [AllocRef_16ED]    | 87              | 20708.00  | 0.00     | 3010.00  | 0.00     | 0.00     | 3977.00  | 0.00     | 5078.00  | 0.00     | 3651.00  | 0.00     | 4992.00  | 0.00     | Area Review Transition Grant                                |                          |
    #                                                        £43677.00 
    | EDSK-940       | ALLB-940           | 1               | 22904.00  | 1338.00  | 2326.00  | 3062.00  | 1837.00  | 1812.00  | 903.00   | 3631.00  | 1867.00  | 3458.00  | 651.00   | 1669.00  | 350.00   | Total Advanced Learner Loans Bursary Funding                |                          |
    | EDSK-940       | ALLF-940           | 5               | 26313.00  | 2633.00  | 1630.00  | 1922.00  | 64.00    | 2920.00  | 2737.00  | 2302.00  | 3607.00  | 3394.00  | 1314.00  | 2871.00  | 919.00   | Advanced Learner Loans Facility                             |                          |


    # Tidy Up
    Given the override date is reset

