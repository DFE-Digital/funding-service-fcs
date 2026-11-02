Feature: UnQueueFundingAllocsB 33397

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A931 Create draft EDSK2122 contract with 16-18TRN and AEBC-ASCL allocs. Import and release 1619 and NFF FAs. Queue. Delete contract v1. Auto-unqueue FAs. Check CRM and PaaS

    # 1. Create draft EDSK2122 contract v1 with 16-18TRN2122 and AEBC-ASCL2122 allocations at 'Internally Approved'
    # 2. Import and release 1619 and NFF Funding Allocs. Queue
    # 3. 'Revise' draft contract > 'In Review'. Auto-unqueue 1619 and NFF Funding Allocs and create new contract v1


    Given there are no allocations marked as Under Termination for UKPRN '10017931' 
    And   there are no terminated or closed allocations for UKPRN '10017931' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017931' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017931' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017931'
    And   there is no Funding Allocation data in CRM for UKPRN '10017931'
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017931' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017931' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-931      |
    | AECA-931      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-931      |
    | AECA-931      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2122      |
    | AEBC-ASCL2122     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-931       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017931'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017931' 
    And   there is no caseload advisor for UKPRN '10017931' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017931 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017931' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017931 Co Ltd' with UKPRN '10017931' and OrgId 'ORG0017931' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017931 | 117931 | 10017931 Co Ltd | 0              | Active                | Yes           | AA017931      | ?             | 27 Kingfisher Court    | Hambridge Lane         | ?                      | ?                      | Newbury                | Berkshire              | RG14 5SJ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017931 |





    # Part 1: Create draft EDSK2122 contract v1 with 16-18TRN2122 and AEBC-ASCL2122 allocations at 'Internally Approved'
    
    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-931'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-931'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017931 | 10017931 Co Ltd      | ESFA-931             | EDSK-931       | 1                     | 01/08/2021        | 31/07/2022      | 87959.00      |                                       | Conditions of Funding (Grant) (LA)         | 2122   | New          | ORG0017931 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017931 | EDSK-931       | 16TR-931      | 16-18TRN          | 16-18TRN2122            | AY                      | 01/08/2021          | 31/07/2022        | 41772.00        |                                         |            |                                                             | New          |             |
    | 10017931 | EDSK-931       | AECA-931      | AEBC-ASCL         | AEBC-ASCL2122           | AY                      | 01/08/2021          | 31/07/2022        | 46187.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017931 | EDSK-931       | 16TR-931      | 1               | 0                     | 41772.00  | 28396.00  | 13376.00  | 1809.00  | 5496.00  | 6523.00  | 3439.00  | 2570.00  | 1477.00  | 3771.00  | 3311.00  | 4689.00  | 3503.00  | 2377.00  | 2807.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017931 | EDSK-931       | 16TR-931      | 2               | 1                     | 22602.00  | 15342.00  | 7260.00   | 1621.00  | 2610.00  | 3346.00  | 2120.00  | 2096.00  | 1186.00  | 213.00   | 2150.00  | 3741.00  | 934.00   | 1952.00  | 633.00   | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017931 | EDSK-931       | 16TR-931      | 3               | 1                     | 19170.00  | 13054.00  | 6116.00   | 188.00   | 2886.00  | 3177.00  | 1319.00  | 474.00   | 291.00   | 3558.00  | 1161.00  | 948.00   | 2569.00  | 425.00   | 2174.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 
    | 10017931 | EDSK-931       | AECA-931      | 1               | 0                     | 46187.00  | 30760.00  | 15427.00  | 5003.00  | 2459.00  | 4657.00  | 4479.00  | 4781.00  | 4860.00  | 1905.00  | 2616.00  | 3200.00  | 3184.00  | 4213.00  | 4830.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10017931 | EDSK-931       | AECA-931      | 2               | 1                     | 24143.00  | 16118.00  | 8025.00   | 1671.00  | 1395.00  | 2225.00  | 2452.00  | 3505.00  | 1330.00  | 1434.00  | 2106.00  | 2808.00  | 2437.00  | 832.00   | 1948.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017931 | EDSK-931       | AECA-931      | 5               | 1                     | 22044.00  | 14642.00  | 7402.00   | 3332.00  | 1064.00  | 2432.00  | 2027.00  | 1276.00  | 3530.00  | 471.00   | 510.00   | 392.00   | 747.00   | 3381.00  | 2882.00  | Community Learning                                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-931       | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Internally Approved'
    And   the contract sub-status is updated to 'Internally Approved' on the latest version of contract 'EDSK-931'





    # Part 2: Import and release 1619 and NFF Funding Allocs. Queue

    # Change the date 
    Given the override date is '03/07/2021'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table





   # Populate the stub with 1619 and NFF (10LAU) data

    # Change the date 
    Given the override date is '05/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017931 | 1619-AS-2122-Contract-LocalAuthority-10017931-3_1     | 3_1            | 1619                        | AS-2122            | 15612.00          |
    | Contracting    | 10017931 | NFF-AS-2122-Contract-LocalAuthority-10017931-3_2      | 3_2            | NFF                         | AS-2122            | 33891.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017931-3_1  | 3_1                    | 1619-AS-2122-Contract-LocalAuthority-10017931-3_1     | 10017931      | Local        | 10LAU           | 15612.00                  |
    | NFF-AS-2122-10017931-3_2   | 3_2                    | NFF-AS-2122-Contract-LocalAuthority-10017931-3_2      | 10017931      | Local        | 10LAU           | 33891.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017931-3_1  | 1619-003        | 6981.00          | Payment         |
    | 1619-AS-2122-10017931-3_1  | 1619-004        | 8631.00          | Payment         |
    #
    | NFF-AS-2122-10017931-3_2   | NFF-001         | 14095.00         | Payment         |
    | NFF-AS-2122-10017931-3_2   | NFF-003         | 11877.00         | Payment         |
    | NFF-AS-2122-10017931-3_2   | NFF-005         | 7919.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017931-3_1  | 1619-003        | FY-2122              | November               | 2021              | 2871.00                   |
    | 1619-AS-2122-10017931-3_1  | 1619-003        | FY-2122              | May                    | 2022              | 4110.00                   |
    | 1619-AS-2122-10017931-3_1  | 1619-004        | FY-2122              | October                | 2021              | 3423.00                   |
    | 1619-AS-2122-10017931-3_1  | 1619-004        | FY-2122              | May                    | 2022              | 5208.00                   |
    #
    | NFF-AS-2122-10017931-3_2   | NFF-001         | FY-2122              | August                 | 2021              | 5728.00                   |
    | NFF-AS-2122-10017931-3_2   | NFF-001         | FY-2122              | March                  | 2022              | 3751.00                   |
    | NFF-AS-2122-10017931-3_2   | NFF-001         | FY-2122              | July                   | 2022              | 4616.00                   |
    | NFF-AS-2122-10017931-3_2   | NFF-003         | FY-2122              | November               | 2021              | 5866.00                   |
    | NFF-AS-2122-10017931-3_2   | NFF-003         | FY-2122              | January                | 2022              | 2522.00                   |
    | NFF-AS-2122-10017931-3_2   | NFF-003         | FY-2122              | June                   | 2022              | 3489.00                   |
    | NFF-AS-2122-10017931-3_2   | NFF-005         | FY-2122              | November               | 2021              | 2049.00                   |
    | NFF-AS-2122-10017931-3_2   | NFF-005         | FY-2122              | March                  | 2022              | 2401.00                   |
    | NFF-AS-2122-10017931-3_2   | NFF-005         | FY-2122              | April                  | 2022              | 3469.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '07/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017931 | 10017931 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017931-3_1       | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 15612.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         | ?          | ?                   |
    | 10017931 | 10017931 Co Ltd  | NFF-AS-2122-Contract-LocalAuthority-10017931-3_2        | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 33891.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 49503.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017931 | 1619-AS-2122-Contract-LocalAuthority-10017931-3_1       | 3_1            | AS-2122 | 1619                        | 15612.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017931 | NFF-AS-2122-Contract-LocalAuthority-10017931-3_2        | 3_2            | AS-2122 | NFF                         | 33891.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '09/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 49503.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017931' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017931' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017931 | 10017931 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017931-3_1       | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | In Release        | Queued            | 15612.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA]       | 09/07/2021 | [ContractNo]        |
    | 10017931 | 10017931 Co Ltd  | NFF-AS-2122-Contract-LocalAuthority-10017931-3_2        | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | In Release        | Queued            | 33891.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA]       | 09/07/2021 | [ContractNo]        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017931 | NFF-AS-2122-Contract-LocalAuthority-10017931-3_2        | 3_2            | AS-2122 | NFF                         | 33891.00    | [CofG_LA]       | InRelease         | Queued                            |
    | 10017931 | 1619-AS-2122-Contract-LocalAuthority-10017931-3_1       | 3_1            | AS-2122 | 1619                        | 15612.00    | [CofG_LA]       | InRelease         | Queued                            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NFF-AS-2122-Contract-LocalAuthority-10017931-3_2        | [ContractNo] | 1               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthority-10017931-3_1       | [ContractNo] | 1               | 0                  | Yes            |


    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'





    # Part 3: 'Revise' draft contract > 'In Review'. Auto-unqueue 1619 and NFF Funding Allocs and create new contract v1

    # Change the date
    Given the override date is '11/07/2021'

#    # Trigger WF28 in CRM to issue a delete request against v2 of the draft 20/21 contract (J090)
#    When  User 'FCS8 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10017931 | EDSK-931       | 1                     | 0                  |

    # Manager rejects internal approval using the Next Action step
    When the next action performed by manager 'FCS8 Test' on the latest version of contract 'EDSK-931' is to 'Revise' specifying the reason as 'Test A931'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017931 | EDSK-931           | 1                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017931 | ESFA-931           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM
    And   there are '132' deliverable period rows in CRM linked to the latest version of contract 'EDSK-931'

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017931' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017931' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017931 | EDSK-931           | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 137462.00     | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-931           | AY2122 | ?               | 10017931 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017931 | ESFA-931           | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017931 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017931 | EDSK-931           | 16TR-931              | ?                             | 41772.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 16-18TRN      | 16-18TRN2122        | Contract Allocation   | ?                        |
    | 10017931 | EDSK-931           | AECA-931              | ?                             | 46187.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | AEBC-ASCL     | AEBC-ASCL2122       | Contract Allocation   | ?                        |
    | 10017931 | EDSK-931           | [AllocRef_16ED]       | ?                             | 49503.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                          | DeliverableDescription   |
    # 1619
    | EDSK-931       | [AllocRef_16ED] | 33              | 6981.00   | 0.00     | 0.00     | 0.00     | 2871.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4110.00  | 0.00     | 0.00     | Residential Bursary Fund                                 |                          |
    | EDSK-931       | [AllocRef_16ED] | 85              | 8631.00   | 0.00     | 0.00     | 3423.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5208.00  | 0.00     | 0.00     | Residential Support Scheme                               |                          |
    # NFF
    | EDSK-931       | [AllocRef_16ED] | 89              | 11877.00  | 0.00     | 0.00     | 0.00     | 5866.00  | 0.00     | 2522.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3489.00  | 0.00     | 16+ Factor Removal (DSG) SSF                             |                          |
    | EDSK-931       | [AllocRef_16ED] | 155             | 7919.00   | 0.00     | 0.00     | 0.00     | 2049.00  | 0.00     | 0.00     | 0.00     | 2401.00  | 3469.00  | 0.00     | 0.00     | 0.00     | Employer Incentive Fund for T-level                      |                          |
    | EDSK-931       | [AllocRef_16ED] | 931             | 14095.00  | 5728.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3751.00  | 0.00     | 0.00     | 0.00     | 4616.00  | Cadets Vocational Programme                              |                          |
    # 16-18TRN & AEBC-ASCL
    | EDSK-931       | 16TR-931        | 1               | 41772.00  | 1809.00  | 5496.00  | 6523.00  | 3439.00  | 2570.00  | 1477.00  | 3771.00  | 3311.00  | 4689.00  | 3503.00  | 2377.00  | 2807.00  | Total 16-18 Traineeships Funding                         |                          |
    | EDSK-931       | 16TR-931        | 2               | 22602.00  | 1621.00  | 2610.00  | 3346.00  | 2120.00  | 2096.00  | 1186.00  | 213.00   | 2150.00  | 3741.00  | 934.00   | 1952.00  | 633.00   | 16-18 Traineeships Programme Funding                     |                          | 
    | EDSK-931       | 16TR-931        | 3               | 19170.00  | 188.00   | 2886.00  | 3177.00  | 1319.00  | 474.00   | 291.00   | 3558.00  | 1161.00  | 948.00   | 2569.00  | 425.00   | 2174.00  | 16-18 Traineeships Bursary Funding                       |                          | 
    | EDSK-931       | AECA-931        | 1               | 46187.00  | 5003.00  | 2459.00  | 4657.00  | 4479.00  | 4781.00  | 4860.00  | 1905.00  | 2616.00  | 3200.00  | 3184.00  | 4213.00  | 4830.00  | Adult Skills and Community Learning Total Funding        |                          | 
    | EDSK-931       | AECA-931        | 2               | 24143.00  | 1671.00  | 1395.00  | 2225.00  | 2452.00  | 3505.00  | 1330.00  | 1434.00  | 2106.00  | 2808.00  | 2437.00  | 832.00   | 1948.00  | Adult Skills Total Funding                               |                          | 
    | EDSK-931       | AECA-931        | 5               | 22044.00  | 3332.00  | 1064.00  | 2432.00  | 2027.00  | 1276.00  | 3530.00  | 471.00   | 510.00   | 392.00   | 747.00   | 3381.00  | 2882.00  | Community Learning                                       |                          | 


    # Contract status is now at 'Awaiting Documentation'


    # Check PaaS and CRM

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A932 Create draft EDSK2122 contract with 16-18TRN and AEBC-ASCL allocs. Import and release 1619 FA then NFF FA. Queue both. Delete contract v1. Auto-unqueue Fas. Check CRM and PaaS

    # 1. Create draft EDSK2122 contract v1 with 16-18TRN2122 and AEBC-ASCL2122 allocations at 'Published to Provider'
    # 2. Import and release 1619 Funding Alloc. Queue
    # 3. Import and release NFF Funding Alloc. Queue
    # 4. Withdraw draft contract v1. Auto-unqueue 1619 and NFF Funding Allocs and create new contract v2


    Given there are no allocations marked as Under Termination for UKPRN '10017932' 
    And   there are no terminated or closed allocations for UKPRN '10017932' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017932' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017932' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017932'
    And   there is no Funding Allocation data in CRM for UKPRN '10017932'
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017932' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017932' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-932      |
    | AECA-932      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-932      |
    | AECA-932      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2122      |
    | AEBC-ASCL2122     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-932       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017932'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017932' 
    And   there is no caseload advisor for UKPRN '10017932' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017932 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017932' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017932 Co Ltd' with UKPRN '10017932' and OrgId 'ORG0017932' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017932 | 117932 | 10017932 Co Ltd | 0              | Active                | Yes           | AA017932      | ?             | 27 Kingfisher Court    | Hambridge Lane         | ?                      | ?                      | Newbury                | Berkshire              | RG14 5SJ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017932 |





    # Part 1: Create draft EDSK2122 contract v1 with 16-18TRN2122 and AEBC-ASCL2122 allocations at 'Published to Provider'
    
    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-932'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-932'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017932 | 10017932 Co Ltd      | ESFA-932             | EDSK-932       | 1                     | 01/08/2021        | 31/07/2022      | 87959.00      |                                       | Conditions of Funding (Grant) (LA)         | 2122   | New          | ORG0017932 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017932 | EDSK-932       | 16TR-932      | 16-18TRN          | 16-18TRN2122            | AY                      | 01/08/2021          | 31/07/2022        | 41772.00        |                                         |            |                                                             | New          |             |
    | 10017932 | EDSK-932       | AECA-932      | AEBC-ASCL         | AEBC-ASCL2122           | AY                      | 01/08/2021          | 31/07/2022        | 46187.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017932 | EDSK-932       | 16TR-932      | 1               | 0                     | 41772.00  | 28396.00  | 13376.00  | 1809.00  | 5496.00  | 6523.00  | 3439.00  | 2570.00  | 1477.00  | 3771.00  | 3311.00  | 4689.00  | 3503.00  | 2377.00  | 2807.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017932 | EDSK-932       | 16TR-932      | 2               | 1                     | 22602.00  | 15342.00  | 7260.00   | 1621.00  | 2610.00  | 3346.00  | 2120.00  | 2096.00  | 1186.00  | 213.00   | 2150.00  | 3741.00  | 934.00   | 1952.00  | 633.00   | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017932 | EDSK-932       | 16TR-932      | 3               | 1                     | 19170.00  | 13054.00  | 6116.00   | 188.00   | 2886.00  | 3177.00  | 1319.00  | 474.00   | 291.00   | 3558.00  | 1161.00  | 948.00   | 2569.00  | 425.00   | 2174.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 
    | 10017932 | EDSK-932       | AECA-932      | 1               | 0                     | 46187.00  | 30760.00  | 15427.00  | 5003.00  | 2459.00  | 4657.00  | 4479.00  | 4781.00  | 4860.00  | 1905.00  | 2616.00  | 3200.00  | 3184.00  | 4213.00  | 4830.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10017932 | EDSK-932       | AECA-932      | 2               | 1                     | 24143.00  | 16118.00  | 8025.00   | 1671.00  | 1395.00  | 2225.00  | 2452.00  | 3505.00  | 1330.00  | 1434.00  | 2106.00  | 2808.00  | 2437.00  | 832.00   | 1948.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017932 | EDSK-932       | AECA-932      | 5               | 1                     | 22044.00  | 14642.00  | 7402.00   | 3332.00  | 1064.00  | 2432.00  | 2027.00  | 1276.00  | 3530.00  | 471.00   | 510.00   | 392.00   | 747.00   | 3381.00  | 2882.00  | Community Learning                                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-932       | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-932'





    # Part 2: Import and release 1619 Funding Alloc. Queue

    # Change the date 
    Given the override date is '03/07/2021'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table





   # Populate the stub with 1619 (10LAU) data

    # Change the date 
    Given the override date is '05/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017932 | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1     | 3_1            | 1619                        | AS-2122            | 15612.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017932-3_1  | 3_1                    | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1     | 10017932      | Local        | 10LAU           | 15612.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017932-3_1  | 1619-003        | 6981.00          | Payment         |
    | 1619-AS-2122-10017932-3_1  | 1619-004        | 8631.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017932-3_1  | 1619-003        | FY-2122              | November               | 2021              | 2871.00                   |
    | 1619-AS-2122-10017932-3_1  | 1619-003        | FY-2122              | May                    | 2022              | 4110.00                   |
    | 1619-AS-2122-10017932-3_1  | 1619-004        | FY-2122              | October                | 2021              | 3423.00                   |
    | 1619-AS-2122-10017932-3_1  | 1619-004        | FY-2122              | May                    | 2022              | 5208.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '07/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017932 | 10017932 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 15612.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA]         | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15612.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017932 | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | 3_1            | AS-2122 | 1619                        | 15612.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '09/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 15612.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017932' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017932' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017932 | 10017932 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | In Release        | Queued            | 15612.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA]       | 09/07/2021 | EDSK-932            |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017932 | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | 3_1            | AS-2122 | 1619                        | 15612.00    | [CofG_LA]       | InRelease         | Queued                            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | EDSK-932     | 1               | 0                  | Yes            |


    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'





    # Part 3: Import and release NFF Funding Alloc. Queue

    # Populate the stub with NFF (10LAU) data

    # Change the date 
    Given the override date is '15/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017932 | NFF-AS-2122-Contract-LocalAuthority-10017932-3_2      | 3_2            | NFF                         | AS-2122            | 33891.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10017932-3_2   | 3_2                    | NFF-AS-2122-Contract-LocalAuthority-10017932-3_2      | 10017932      | Local        | 10LAU           | 33891.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10017932-3_2   | NFF-001         | 14095.00         | Payment         |
    | NFF-AS-2122-10017932-3_2   | NFF-003         | 11877.00         | Payment         |
    | NFF-AS-2122-10017932-3_2   | NFF-005         | 7919.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10017932-3_2   | NFF-001         | FY-2122              | August                 | 2021              | 5728.00                   |
    | NFF-AS-2122-10017932-3_2   | NFF-001         | FY-2122              | March                  | 2022              | 3751.00                   |
    | NFF-AS-2122-10017932-3_2   | NFF-001         | FY-2122              | July                   | 2022              | 4616.00                   |
    | NFF-AS-2122-10017932-3_2   | NFF-003         | FY-2122              | November               | 2021              | 5866.00                   |
    | NFF-AS-2122-10017932-3_2   | NFF-003         | FY-2122              | January                | 2022              | 2522.00                   |
    | NFF-AS-2122-10017932-3_2   | NFF-003         | FY-2122              | June                   | 2022              | 3489.00                   |
    | NFF-AS-2122-10017932-3_2   | NFF-005         | FY-2122              | November               | 2021              | 2049.00                   |
    | NFF-AS-2122-10017932-3_2   | NFF-005         | FY-2122              | March                  | 2022              | 2401.00                   |
    | NFF-AS-2122-10017932-3_2   | NFF-005         | FY-2122              | April                  | 2022              | 3469.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '17/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA2                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA2 = [CofG_LA2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017932 | 10017932 Co Ltd  | NFF-AS-2122-Contract-LocalAuthority-10017932-3_2        | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 33891.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_LA2]        | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 33891.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017932 | NFF-AS-2122-Contract-LocalAuthority-10017932-3_2        | 3_2            | AS-2122 | NFF                         | 33891.00    | [CofG_LA2]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '19/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA2]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA2 = [CofG_LA2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 33891.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017932' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017932' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017932 | 10017932 Co Ltd  | NFF-AS-2122-Contract-LocalAuthority-10017932-3_2        | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | In Release        | Queued            | 33891.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA2]      | 19/07/2021 | EDSK-932            |
    | 10017932 | 10017932 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | In Release        | Queued            | 15612.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA]       | 09/07/2021 | EDSK-932            |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017932 | NFF-AS-2122-Contract-LocalAuthority-10017932-3_2        | 3_2            | AS-2122 | NFF                         | 33891.00    | [CofG_LA2]      | InRelease         | Queued                            |
    | 10017932 | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | 3_1            | AS-2122 | 1619                        | 15612.00    | [CofG_LA]       | InRelease         | Queued                            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NFF-AS-2122-Contract-LocalAuthority-10017932-3_2        | EDSK-932     | 1               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | EDSK-932     | 1               | 0                  | Yes            |


    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA2]' in FundingAllocation.ReleaseGroup has a status of 'Released'





    # Part 4: Withdraw draft contract v1. Auto-unqueue 1619 and NFF Funding Allocs and create new contract v2

    # Change the date
    Given the override date is '22/07/2021'

    # Contract Withdrawal
    When  the next action performed on the latest version of contract 'EDSK-932' is 'Withdraw On Behalf Of Provider' with reason 'Provider has ceased trading' by 'FCS2 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017932 | EDSK-932           | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017932 | EDSK-932           | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017932 | ESFA-932           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM (5x12=60)
   #And   there are '60' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '60' deliverable period rows in CRM linked to the latest version of contract 'EDSK-932'

    # Check the CRM Funding Allocations data (J125)  No longer queued
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017932 | 10017932 Co Ltd  | NFF-AS-2122-Contract-LocalAuthority-10017932-3_2        | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Released          | Released                | 33891.00    | EDSK-932      | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA2]      | ?          | ?                   |
    | 10017932 | 10017932 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 15612.00    | EDSK-932      | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)  No longer queued
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017932 | NFF-AS-2122-Contract-LocalAuthority-10017932-3_2        | 3_2            | AS-2122 | NFF                         | 33891.00    | [CofG_LA2]      | ?                 | ?                                 |
    | 10017932 | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | 3_1            | AS-2122 | 1619                        | 15612.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NFF-AS-2122-Contract-LocalAuthority-10017932-3_2        | [ContractNo] | 2               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthority-10017932-3_1       | [ContractNo] | 2               | 0                  | Yes            |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017932' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017932' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check that the Contract has been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017932 | EDSK-932           | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 49503.00      | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-932           | AY2122 | ?               | 10017932 Co Ltd  | Active | Document Management Team  | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017932 | EDSK-932           | [AllocRef_16ED]       | ?                             | 49503.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | 10017572 | EDSK-932       | [AllocRef_16ED]    | 33              | 0                     | 6981.00   | 0.00     | 0.00     | 0.00     | 2871.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4110.00  | 0.00     | 0.00     | Residential Bursary Fund                                    |                          |
    | 10017572 | EDSK-932       | [AllocRef_16ED]    | 85              | 0                     | 8631.00   | 0.00     | 0.00     | 3423.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5208.00  | 0.00     | 0.00     | Residential Support Scheme                                  |                          |
    | 10017572 | EDSK-932       | [AllocRef_16ED]    | 89              | 0                     | 11877.00  | 0.00     | 0.00     | 0.00     | 5866.00  | 0.00     | 2522.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3489.00  | 0.00     | 16+ Factor Removal (DSG) SSF                                |                          |
    | 10017572 | EDSK-932       | [AllocRef_16ED]    | 155             | 0                     | 7919.00   | 0.00     | 0.00     | 0.00     | 2049.00  | 0.00     | 0.00     | 0.00     | 2401.00  | 3469.00  | 0.00     | 0.00     | 0.00     | Employer Incentive Fund for T-level                         |                          |
    | 10017572 | EDSK-932       | [AllocRef_16ED]    | 931             | 0                     | 14095.00  | 5728.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3751.00  | 0.00     | 0.00     | 0.00     | 4616.00  | Cadets Vocational Programme                                 |                          |


    # Tidy up
    Given the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A933 Create and approve DADA2021. Import, release and approve DADA2122. Request Termination Initiation. Update DADA2122 FA. NFA. Reject Termination Initiation. Delete draft DADA2021. Unqueue FA. Check CRM and PaaS

    # 1. Create and approve DADA 20/21 contract v1  
    # 2. Import and release DADA 21/22 FA. Approve contract v1  
    # 3. Request termination initiation approval of 21/22 contract  
    # 4. Release an update to the DADA 21/22 FA > queue due to 21/22 contract
    # 5. NFA amendment to the 20/21 contract > draft v2
    # 6. Reject termination initiation request. 21/22 FA remains queued but now due to 20/21 contract
    # 7. Delete draft 20/21 contract v2. 21/22 FA auto-unqueued. Draft 21/22 v2 created

    Given there are no allocations marked as Under Termination for UKPRN '10017933' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017933'
    And   there is no Funding Allocation data in CRM for UKPRN '10017933'
    And   there are no terminated or closed allocations for UKPRN '10017933' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017933' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017933' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017933' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017933' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017933' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-933      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-933      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |
    | DADA2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-933      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017933'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017933' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017933 Co Ltd' with UKPRN '10017933' and OrgId 'ORG0017933' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017933' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017933 | 117933 | 10017933 Co Ltd | 0              | Locked Restructure    | Yes           | AA017933      | ?             | 1a Sultan Street       | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017933 |





    # Part 1: Create and approve DADA 20/21 contract v1 
    
    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-933'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-933'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017933 | 10017933 Co Ltd      | ESFA-933             | DADAS-933      | 1                     | 01/08/2020        | 31/07/2021      | 2135.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017933 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017933 | DADAS-933      | DADA-933      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 2135.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017933 | DADAS-933      | DADA-933      | 1               | 0                     | 2135.00   | 1411.00   | 724.00    | 0.00     | 1411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 724.00   | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'DADAS-933' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-933' and actual ContractNumber 'DADAS-933'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-933' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017933 | DADAS-933          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017933 | ESFA-933           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 2: Import and release DADA 21/22 FA. Approve contract v1  

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '06/08/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017933 | DADA-AY-2122-Contract-Provider-10017933-1_5           | 1_5            | DADA                        | AY-2122            | 15654.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017933-1_5  | 1_5                    | DADA-AY-2122-Contract-Provider-10017933-1_5           | 10017933      | Furth        | 07HEP           | 15654.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017933-1_5  | DADA-001        | 15654.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017933-1_5  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017933-1_5  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017933-1_5  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017933-1_5  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '08/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017933 | 10017933 Co Ltd  | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 15654.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15654.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017933 | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '10/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS = [CfS]' is written to the Output window

    # Check the state of a Release Group (J129)  (The FA is still included in the RG)
    Then  Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 15654.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017933' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017933 | 10017933 Co Ltd  | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017933 | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017933 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017933 | DADAS-933          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017933 | ESFA-933           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    
    
    
    
    # Publish and approve 21/22 DADA contract v1

    # Change the date
    Given the override date is '12/08/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-933' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017933 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017933 | DADAS-933          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017933 | ESFA-933           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 3: Request termination initiation approval of 21/22 contract

    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '05/10/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 1               | 0                  | 05/10/2021              | Notice from Agency          | Acquisition in progress             |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_DADA]    | 03/09/2021                   | 10/09/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017933 | [ContractNo]   | 1                     | 0                        | 05/10/2021                 | Notice from Agency           | ?                              | 05/10/2021              | Notice from Agency          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017933 | [ContractNo]  | [AllocRef_DADA]  | 1                     | 0                        | 03/09/2021                   | 03/09/2021        | 10/09/2021                      | 10/09/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017933'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017933 - 10017933 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017933 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017933 | DADAS-933          | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017933 | ESFA-933           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |



 

    # Part 4: Release an update to the DADA 21/22 FA > queue due to 21/22 contract

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '07/10/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017933 | DADA-AY-2122-Contract-Provider-10017933-3_1           | 3_1            | DADA                        | AY-2122            | 20000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017933-3_1  | 3_1                    | DADA-AY-2122-Contract-Provider-10017933-3_1           | 10017933      | Furth        | 07HEP           | 20000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017933-3_1  | DADA-001        | 20000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017933-3_1  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017933-3_1  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017933-3_1  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017933-3_1  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
    | DADA-AY-2122-10017933-3_1  | DADA-001        | FY-2122              | July                   | 2022              | 4346.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '09/10/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS2                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017933 | 10017933 Co Ltd  | DADA-AY-2122-Contract-Provider-10017933-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release        | 20000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CfS2]          | ?          | ?                   |
    | 10017933 | 10017933 Co Ltd  | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '11/10/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS2]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS2 = [CfS2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The FA is still included in the RG)
    Then  Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 20000.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017933' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017933 | 10017933 Co Ltd  | DADA-AY-2122-Contract-Provider-10017933-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 11/10/2021 | [ContractNo]        |
    | 10017933 | 10017933 Co Ltd  | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017933 | DADA-AY-2122-Contract-Provider-10017933-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017933 | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract (Queued behind the 21/22 DADAS contract)
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | [ContractNo] | 1               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017933 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017933 | DADAS-933          | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017933 | ESFA-933           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Part 5: NFA amendment to the 20/21 contract > draft v2

    # Change the date
    Given the override date is '13/10/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-933' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017933 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017933 | DADAS-933          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017933 | DADAS-933          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017933 | ESFA-933           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 6: Reject termination initiation request. 21/22 FA remains queued but now due to 20/21 contract

    # Change the date
    Given the override date is '15/10/2021'
    
#   # Manager rejects termination initiation request (23810)
#   When  CRM user 'FCS5 Test' rejects the termination request for Contract '[ContractNo]' Version '1' SubVersion '0' with free-text reason 'Termination requested in error'

    # Reject Termination Initiation using the Next Action step
    When the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Reject Termination Initiation' specifying the reason as 'Test 933'


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017933 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017933 | DADAS-933          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017933 | DADAS-933          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017933 | ESFA-933           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017933 | 10017933 Co Ltd  | DADA-AY-2122-Contract-Provider-10017933-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 15/10/2021 | DADAS-933           |
    | 10017933 | 10017933 Co Ltd  | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131) (Queued behind 20/21 contract)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017933 | DADA-AY-2122-Contract-Provider-10017933-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017933 | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | DADAS-933    | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | [ContractNo] | 1               | 0                  | Yes            |





    # Part 7: Delete draft 20/21 contract v2. 21/22 FA auto-unqueued. Draft 21/22 v2 created

    # Change the date
    Given the override date is '22/10/2021'

    # Trigger WF28 in CRM to issue a delete request against v2 of contract DADA-933 (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017933 | DADAS-933      | 2                     | 0                  |


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017933 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017933 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017933 | DADAS-933          | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017933 | ESFA-933           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017933 | 10017933 Co Ltd  | DADA-AY-2122-Contract-Provider-10017933-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 20000.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | ?          | ?                   |
    | 10017933 | 10017933 Co Ltd  | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | In Release     | Queued                          | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
  
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017933 | DADA-AY-2122-Contract-Provider-10017933-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | ?                 | ?                                 |
    | 10017933 | DADA-AY-2122-Contract-Provider-10017933-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017933-3_1             | [ContractNo] | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017933-1_5             | [ContractNo] | 1               | 0                  | Yes            |


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A934 Create and approve DADA2021. Import, release and approve DADA2122. NFA. Queue DADA2122 FA. Termination Initiation on DADA2122. Approve 21/22 draft. Reject Termination Initiation. Unqueue FA. Check CRM and PaaS

    # 1. Create and approve DADA 20/21 contract v1  
    # 2. Import and release DADA 21/22 FA. Approve contract v1  
    # 3. NFA amendment of 20/21 contract > draft v2
    # 4. Release an update to the DADA 21/22 FA > queue due to 20/21 contract
    # 5. Request Termination Initiation Approval on 21/22 contract
    # 6. Publish and approve 20/21 draft v2 > 21/22 FA remains queued but now due to 21/22 contract
    # 7. Reject Termination Initiation request on 21/22 conract > auto-unqueue 21/22 FA > draft 21/22 contract v2

    Given there are no allocations marked as Under Termination for UKPRN '10017934' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017934'
    And   there is no Funding Allocation data in CRM for UKPRN '10017934'
    And   there are no terminated or closed allocations for UKPRN '10017934' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017934' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017934' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017934' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017934' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017934' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-934      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-934      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |
    | DADA2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-934      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017934'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017934' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017934 Co Ltd' with UKPRN '10017934' and OrgId 'ORG0017934' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017934' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017934 | 117934 | 10017934 Co Ltd | 0              | Locked Restructure    | Yes           | AA017934      | ?             | 1a Sultan Street       | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017934 |





    # Part 1: Create and approve DADA 20/21 contract v1 
    
    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-934'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-934'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017934 | 10017934 Co Ltd      | ESFA-934             | DADAS-934      | 1                     | 01/08/2020        | 31/07/2021      | 2135.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017934 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017934 | DADAS-934      | DADA-934      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 2135.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017934 | DADAS-934      | DADA-934      | 1               | 0                     | 2135.00   | 1411.00   | 724.00    | 0.00     | 1411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 724.00   | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'DADAS-934' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-934' and actual ContractNumber 'DADAS-934'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-934' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017934 | DADAS-934          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017934 | ESFA-934           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 2: Import and release DADA 21/22 FA. Approve contract v1  

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '06/08/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017934 | DADA-AY-2122-Contract-Provider-10017934-1_5           | 1_5            | DADA                        | AY-2122            | 15654.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017934-1_5  | 1_5                    | DADA-AY-2122-Contract-Provider-10017934-1_5           | 10017934      | Furth        | 07HEP           | 15654.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017934-1_5  | DADA-001        | 15654.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017934-1_5  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017934-1_5  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017934-1_5  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017934-1_5  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '08/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017934 | 10017934 Co Ltd  | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 15654.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15654.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017934 | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '10/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS = [CfS]' is written to the Output window

    # Check the state of a Release Group (J129)  (The FA is still included in the RG)
    Then  Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 15654.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017934' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017934 | 10017934 Co Ltd  | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017934 | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017934 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017934 | DADAS-934          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017934 | ESFA-934           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    
    
    
    
    # Publish and approve 21/22 DADA contract v1

    # Change the date
    Given the override date is '12/08/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-934' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017934 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017934 | DADAS-934          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017934 | ESFA-934           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 3: NFA amendment of 20/21 contract > draft v2

    # Change the date
    Given the override date is '05/10/2021'

    # Issue a non-financial amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-934' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-934' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017934 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017934 | DADAS-934          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017934 | DADAS-934          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017934 | ESFA-934           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 4: Release an update to the DADA 21/22 FA > queue due to 21/22 contract

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '07/10/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017934 | DADA-AY-2122-Contract-Provider-10017934-3_1           | 3_1            | DADA                        | AY-2122            | 20000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017934-3_1  | 3_1                    | DADA-AY-2122-Contract-Provider-10017934-3_1           | 10017934      | Furth        | 07HEP           | 20000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017934-3_1  | DADA-001        | 20000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017934-3_1  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017934-3_1  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017934-3_1  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017934-3_1  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
    | DADA-AY-2122-10017934-3_1  | DADA-001        | FY-2122              | July                   | 2022              | 4346.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '09/10/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS2                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017934 | 10017934 Co Ltd  | DADA-AY-2122-Contract-Provider-10017934-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release        | 20000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CfS2]          | ?          | ?                   |
    | 10017934 | 10017934 Co Ltd  | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '11/10/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS2]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS2 = [CfS2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The FA is still included in the RG)
    Then  Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 20000.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017934' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017934 | 10017934 Co Ltd  | DADA-AY-2122-Contract-Provider-10017934-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 11/10/2021 | DADAS-934           |
    | 10017934 | 10017934 Co Ltd  | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017934 | DADA-AY-2122-Contract-Provider-10017934-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017934 | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017934 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017934 | DADAS-934          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017934 | DADAS-934          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017934 | ESFA-934           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 5: Request termination initiation approval of 21/22 contract

    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '02/11/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 1               | 0                  | 05/10/2021              | Notice from Agency          | Acquisition in progress             |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_DADA]    | 03/09/2021                   | 10/09/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017934 | [ContractNo]   | 1                     | 0                        | 05/10/2021                 | Notice from Agency           | ?                              | 05/10/2021              | Notice from Agency          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017934 | [ContractNo]  | [AllocRef_DADA]  | 1                     | 0                        | 03/09/2021                   | 03/09/2021        | 10/09/2021                      | 10/09/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017934'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017934 - 10017934 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017934 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017934 | DADAS-934          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017934 | DADAS-934          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017934 | ESFA-934           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


 




    # Part 6: Publish and approve 20/21 draft v2 > 21/22 FA remains queued but now due to 21/22 contract

    # Change the date
    Given the override date is '03/11/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'DADAS-934' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-934' and actual ContractNumber 'DADAS-934'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-934' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017934 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017934 | DADAS-934          | 2                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017934 | DADAS-934          | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017934 | ESFA-934           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017934 | 10017934 Co Ltd  | DADA-AY-2122-Contract-Provider-10017934-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 03/11/2021 | [ContractNo]        |
    | 10017934 | 10017934 Co Ltd  | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | In Release     | Queued                          | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017934 | DADA-AY-2122-Contract-Provider-10017934-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017934 | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | [ContractNo] | 1               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | [ContractNo] | 1               | 0                  | Yes            |





    # green up to here






    # Part 7: Reject Termination Initiation request on 21/22 conract > auto-unqueue 21/22 FA > draft 21/22 contract v2

    # Change the date
    Given the override date is '06/11/2021'
    
#   # Manager rejects termination initiation request (23810)
#   When  CRM user 'FCS5 Test' rejects the termination request for Contract '[ContractNo]' Version '1' SubVersion '0' with free-text reason 'Termination requested in error'

    # Reject Termination Initiation using the Next Action step
    When the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Reject Termination Initiation' specifying the reason as 'Test 934'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017934 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017934 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017934 | DADAS-934          | 2                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017934 | DADAS-934          | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017934 | ESFA-934           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017934 | 10017934 Co Ltd  | DADA-AY-2122-Contract-Provider-10017934-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 20000.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | ?          | ?                   |
    | 10017934 | 10017934 Co Ltd  | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | In Release     | Queued                          | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017934 | DADA-AY-2122-Contract-Provider-10017934-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | ?                 | ?                                 |
    | 10017934 | DADA-AY-2122-Contract-Provider-10017934-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017934-3_1             | [ContractNo] | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017934-1_5             | [ContractNo] | 1               | 0                  | Yes            |


    # Tidy Up
    Given the override date is reset

