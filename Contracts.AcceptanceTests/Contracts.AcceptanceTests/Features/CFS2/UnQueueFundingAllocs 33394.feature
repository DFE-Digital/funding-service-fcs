Feature: UnQueueFundingAllocs 33394

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A340 Create a 21/22 EDSK contract with 16-18TRN2122 alloc. Import 1619 and NFF FAs from CFS > queue. Import 1619 FA for a delivery org > queue. Publish and approve contract v1. Auto-release FAs > draft contract v2
    Given there are no allocations marked as Under Termination for UKPRN '10017340' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017340'
    And   there is no Funding Allocation data in CRM for UKPRN '10017340'   
    And   there are no terminated or closed allocations for UKPRN '10017340' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017340' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017340' 
 
    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017340' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017340' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-340      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-340      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2122      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-340       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017340'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017340' 
    And   there is no caseload advisor for UKPRN '10017340' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017340 | 
    | 10032350 |
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017340' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017340 CC' with UKPRN '10017340' and OrgId 'ORG0017340' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name             | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017340 | 117340 | 10017340 CC      | 0              | Active                | Yes           | AA017340      | ?             | 3 Egremont Street      | ?                      | ?                      | ?                      | Ely                    | Cambridge              | CB6 1AE   |
    | 10032350 | 132350 | 10032350 College | 0              | Active                | Yes           | AA032350      | ?             | 8 Egremont Street      | ?                      | ?                      | ?                      | Ely                    | Cambridge              | CB6 1AE   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017340 |
    | 10032350 |



    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-340'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-340'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017340 | 10017340 CC          | ESFA-340             | EDSK-340       | 1                     | 01/08/2021        | 31/07/2022      | 48734.00      |                                       | Conditions of Funding (Grant) (HEI)        | 2122   | New          | ORG0017340 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017340 | EDSK-340       | 16TR-340      | 16-18TRN          | 16-18TRN2122            | AY                      | 01/08/2021          | 31/07/2022        | 48734.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017340 | EDSK-340       | 16TR-340      | 1               | 0                     | 48734.00  | 33239.00  | 15495.00  | 3479.00  | 4063.00  | 4049.00  | 5076.00  | 5693.00  | 4824.00  | 3731.00  | 2324.00  | 5565.00  | 3242.00  | 2056.00  | 4632.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017340 | EDSK-340       | 16TR-340      | 2               | 1                     | 22935.00  | 17062.00  | 5873.00   | 2477.00  | 1820.00  | 2809.00  | 3545.00  | 2319.00  | 2295.00  | 1385.00  | 412.00   | 2349.00  | 239.00   | 1133.00  | 2152.00  | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017340 | EDSK-340       | 16TR-340      | 3               | 1                     | 25799.00  | 16341.00  | 9622.00   | 1002.00  | 2243.00  | 1240.00  | 1531.00  | 3374.00  | 2529.00  | 2346.00  | 1912.00  | 3216.00  | 3003.00  | 923.00   | 2480.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-340       | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Awaiting Internal Approval'
    And   the contract sub-status is updated to 'Awaiting Internal Approval' on the latest version of contract 'EDSK-340'





    # Part 2: Import and release two FAs (1619 and NFF) > Queued

    # Change the date 
    Given the override date is '01/08/2021'

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
    Given the override date is '02/08/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017340 | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2     | 2_2            | 1619                        | AS-2122            | 67939.00          |
    | Contracting    | 10017340 | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0      | 3_0            | NFF                         | AS-2122            | 47225.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017340-2_2  | 2_2                    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2     | 10017340      | Local        | 10LAU           | 67939.00                  |
    | NFF-AS-2122-10017340-3_0   | 3_0                    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0      | 10017340      | Local        | 10LAU           | 47225.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017340-2_2  | 1619-001        | 34178.00         | Payment         |
    | 1619-AS-2122-10017340-2_2  | 1619-003        | 15234.00         | Payment         |
    | 1619-AS-2122-10017340-2_2  | 1619-005        | 11017.00         | Payment         |
    | 1619-AS-2122-10017340-2_2  | 1619-010        | 20207.00         | Payment         |
    | 1619-AS-2122-10017340-2_2  | 1619-020        | 3703.00          | Payment         |
    #
    | NFF-AS-2122-10017340-3_0   | NFF-001         | 17084.00         | Payment         |
    | NFF-AS-2122-10017340-3_0   | NFF-002         | 4885.00          | Payment         |
    | NFF-AS-2122-10017340-3_0   | NFF-005         | 25256.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017340-2_2  | 1619-001        | FY-2122              | August                 | 2021              | 4671.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-001        | FY-2122              | December               | 2021              | 4030.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-001        | FY-2122              | February               | 2022              | 5954.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-001        | FY-2122              | May                    | 2022              | 3123.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-003        | FY-2122              | September              | 2021              | 5770.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-003        | FY-2122              | January                | 2022              | 3660.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-003        | FY-2122              | March                  | 2022              | 3052.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-003        | FY-2122              | July                   | 2022              | 2752.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-005        | FY-2122              | January                | 2022              | 5076.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-005        | FY-2122              | March                  | 2022              | 5941.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-010        | FY-2122              | September              | 2021              | 5057.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-010        | FY-2122              | December               | 2021              | 2125.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-010        | FY-2122              | March                  | 2022              | 2921.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-010        | FY-2122              | April                  | 2022              | 4534.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-010        | FY-2122              | June                   | 2022              | 5570.00                   |
    | 1619-AS-2122-10017340-2_2  | 1619-020        | FY-2122              | September              | 2021              | 3703.00                   |
    #
    | NFF-AS-2122-10017340-3_0   | NFF-001         | FY-2122              | October                | 2021              | 2949.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-001         | FY-2122              | December               | 2021              | 4461.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-001         | FY-2122              | March                  | 2022              | 2863.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-001         | FY-2122              | May                    | 2022              | 4717.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-001         | FY-2122              | June                   | 2022              | 2094.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-002         | FY-2122              | June                   | 2022              | 4885.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-005         | FY-2122              | September              | 2021              | 4182.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-005         | FY-2122              | November               | 2021              | 5011.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-005         | FY-2122              | January                | 2022              | 5465.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-005         | FY-2122              | March                  | 2022              | 5165.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-005         | FY-2122              | April                  | 2022              | 2062.00                   |
    | NFF-AS-2122-10017340-3_0   | NFF-005         | FY-2122              | June                   | 2022              | 3371.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/08/2021'

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
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017340 | 10017340 CC      | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 67939.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017340 | 10017340 CC      | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | 3_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release        | 47225.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 115164.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017340 | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | 2_2            | AS-2122 | 1619                        | 67939.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017340 | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | 3_0            | AS-2122 | NFF                         | 47225.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '04/08/2021'

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
    | Released          | 2               | 115164.00       |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017340' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017340' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017340 | 10017340 CC      | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | In Release        | Queued            | 67939.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA]       | 04/08/2021 | [ContractNo]        |
    | 10017340 | 10017340 CC      | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | 3_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | In Release        | Queued            | 47225.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_LA]       | 04/08/2021 | [ContractNo]        |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017340 | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | 2_2            | AS-2122 | 1619                        | 67939.00    | [CofG_LA]       | InRelease         | Queued                            |
    | 10017340 | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | 3_0            | AS-2122 | NFF                         | 47225.00    | [CofG_LA]       | InRelease         | Queued                            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | [ContractNo] | 1               | 0                  | Yes            |
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017340 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Internal Approval               | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017340 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM has not changed                            
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'





    # Populate the stub with 1619 (08SSF) data

    # Change the date 
    Given the override date is '08/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017340 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5  | 3_5            | 1619                        | AS-2122            | 67261.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10032350-3_5  | 3_5                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5  | 10032350      | Schoo        | 08SSF           | 67261.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10032350-3_5  | 1619-004        | 12391.00         | Payment         |
    | 1619-AS-2122-10032350-3_5  | 1619-008        | 18519.00         | Payment         |
    | 1619-AS-2122-10032350-3_5  | 1619-013        | 13815.00         | Payment         |
    | 1619-AS-2122-10032350-3_5  | 1619-024        | 14043.00         | Payment         |
    | 1619-AS-2122-10032350-3_5  | 1619-025        | 8493.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10032350-3_5  | 1619-004        | FY-2122              | September              | 2021              | 3128.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-004        | FY-2122              | January                | 2022              | 2931.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-004        | FY-2122              | February               | 2022              | 2461.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-004        | FY-2122              | May                    | 2022              | 3871.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-008        | FY-2122              | October                | 2021              | 5268.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-008        | FY-2122              | December               | 2021              | 4488.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-008        | FY-2122              | March                  | 2022              | 4702.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-008        | FY-2122              | May                    | 2022              | 4061.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-013        | FY-2122              | August                 | 2021              | 4313.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-013        | FY-2122              | January                | 2022              | 2407.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-013        | FY-2122              | March                  | 2022              | 3064.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-013        | FY-2122              | July                   | 2022              | 4031.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-024        | FY-2122              | November               | 2021              | 5413.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-024        | FY-2122              | March                  | 2022              | 4670.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-024        | FY-2122              | June                   | 2022              | 3960.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-025        | FY-2122              | October                | 2021              | 5985.00                   |
    | 1619-AS-2122-10032350-3_5  | 1619-025        | FY-2122              | June                   | 2022              | 2508.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '09/08/2021'

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
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017340 | 10017340 CC      | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | 3_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 67261.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA2]      | ?          | ?                   |
    | 10017340 | 10017340 CC      | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | In Release        | Queued                  | 67939.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | 04/08/2021 | EDSK-340            |
    | 10017340 | 10017340 CC      | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | 3_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | In Release        | Queued                  | 47225.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | 04/08/2021 | EDSK-340            |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 67261.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017340 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | 3_5            | AS-2122 | 1619                        | 67261.00    | [CofG_LA2]      | ?                 | ?                                 |
    | 10017340 | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | 2_2            | AS-2122 | 1619                        | 67939.00    | [CofG_LA]       | InRelease         | Queued                            |
    | 10017340 | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | 3_0            | AS-2122 | NFF                         | 47225.00    | [CofG_LA]       | InRelease         | Queued                            |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '10/08/2021'

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
    | Released          | 1               | 67261.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017340' for FundingType 'EDSK' and period '2122'

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017340 | 10017340 CC      | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | 3_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | In Release        | Queued                  | 67261.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA2]      | 10/08/2021 | EDSK-340            |
    | 10017340 | 10017340 CC      | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | In Release        | Queued                  | 67939.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | 04/08/2021 | EDSK-340            |
    | 10017340 | 10017340 CC      | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | 3_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | In Release        | Queued                  | 47225.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | 04/08/2021 | EDSK-340            |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017340 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | 3_5            | AS-2122 | 1619                        | 67261.00    | [CofG_LA2]      | InRelease         | Queued                            |
    | 10017340 | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | 3_0            | AS-2122 | NFF                         | 47225.00    | [CofG_LA]       | InRelease         | Queued                            |
    | 10017340 | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | 2_2            | AS-2122 | 1619                        | 67939.00    | [CofG_LA]       | InRelease         | Queued                            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | [ContractNo] | 1               | 0                  | Yes            |
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | [ContractNo] | 1               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017340 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Internal Approval               | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017340 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 4: Publish and approve contract v1. Queued FAs to un-queue

    # Change the date 
    Given the override date is '12/08/2021'
    
    # Update the contract from 'Awaiting Internal Approval' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-340'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-340' and actual ContractNumber 'EDSK-340'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-340' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017340 | EDSK-340           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017340 | ESFA-340           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017340 | 10017340 CC      | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | 3_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 67261.00    | EDSK-340      | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA2]      | ?          | ?                   |
    | 10017340 | 10017340 CC      | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released                | 67939.00    | EDSK-340      | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017340 | 10017340 CC      | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | 3_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Released          | Released                | 47225.00    | EDSK-340      | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017340 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | 3_5            | AS-2122 | 1619                        | 67261.00    | [CofG_LA2]      | ?                 | ?                                 |
    | 10017340 | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | 3_0            | AS-2122 | NFF                         | 47225.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017340 | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | 2_2            | AS-2122 | 1619                        | 67939.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | [ContractNo] | 2               | 0                  | Yes            |
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | [ContractNo] | 2               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | [ContractNo] | 2               | 0                  | Yes            |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10017340-2_2       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017340-3_5    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2122-Contract-LocalAuthority-10017340-3_0        | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A341 Create and approve 20/21 DADA contract. Import a 21/22 DADA FA from CFS and approve. Notification NFA 20/21. Import and queue 21/22 FA. Publish and auto-approve 20/21. Un-queue 21/22 FA. Check docs, CRM and PaaS

    # 1. Create and approve DADA 20/21 contract                            DADAS-341
    # 2. Import and release DADA 21/22 FA > Approved                       [ContractNo]
    # 3. Notification NFA on 20/21 contract > Awaiting Documentation       DADAS-341
    # 4. Import non-material DADA 21/22 FA > Discarded\NonmaterialUpdate   [ContractNo]
    # 5. Import updated DADA 21/22 FA > Queue                              [ContractNo]
    # 6. Publish draft 20/21 DADA contract > auto-approve.                 DADAS-341
    # 7. Un-queue 21/22 FA > draft contract v2                             [ContractNo]
    #    Check docs (36304)

    Given there are no allocations marked as Under Termination for UKPRN '10017341' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017341'
    And   there is no Funding Allocation data in CRM for UKPRN '10017341'
    And   there are no terminated or closed allocations for UKPRN '10017341' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017341' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017341' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017341' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017341' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017341' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-341      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-341      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |
    | DADA2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-341      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017341'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017341' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017341 Co Ltd' with UKPRN '10017341' and OrgId 'ORG0017341' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017341' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017341 | 117341 | 10017341 Co Ltd | 0              | Locked Restructure    | Yes           | AA017341      | ?             | 1a Sultan Street       | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017341 |





    # Part 1: Create and approve 20/21 DADA contract
    
    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-341'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-341'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017341 | 10017341 Co Ltd      | ESFA-341             | DADAS-341      | 1                     | 01/08/2020        | 31/07/2021      | 2135.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017341 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017341 | DADAS-341      | DADA-341      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 2135.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017341 | DADAS-341      | DADA-341      | 1               | 0                     | 2135.00   | 1411.00   | 724.00    | 0.00     | 1411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 724.00   | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'DADAS-341' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-341' and actual ContractNumber 'DADAS-341'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-341' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017341 | DADAS-341          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017341 | ESFA-341           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 2: Import and release DADA 21/22 FA > Approved

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '06/08/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-2_3           | 2_3            | DADA                        | AY-2122            | 15654.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017341-2_3  | 2_3                    | DADA-AY-2122-Contract-Provider-10017341-2_3           | 10017341      | Furth        | 07HEP           | 15654.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017341-2_3  | DADA-001        | 15654.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017341-2_3  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017341-2_3  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017341-2_3  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017341-2_3  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
 
 
 
 
 
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
    | 10017341 | 10017341 Co Ltd  | DADA-AY-2122-Contract-Provider-10017341-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 15654.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017341-2_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15654.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

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
    When  I retrieve the latest contract details from CRM for provider '10017341' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017341 | 10017341 Co Ltd  | DADA-AY-2122-Contract-Provider-10017341-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017341-2_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017341-2_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017341 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017341 | DADAS-341          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017341 | ESFA-341           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    
    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices for 21/22 DADA contract (SoF, TAC, Sch1, Sch2, FA, Sch3ON)
    And   the file named '10017341_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017341 Co Ltd UKPRN: 10017341
    Master Contract Number: ESFA-341
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    Dance and Drama Awards (DaDA) DADA-341 £1,411 £724 £2,135
    Total: £2,135
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £11,727 £3,927 £15,654
    Total: £15,654
    Total Funding for this contract: £17,789
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2020 to 31 July 2023
    Between the Secretary of State for Education
    And 10017341 Co Ltd
    Funding for Dance and Drama Awards (DaDA)
    Master Contract Number ESFA-341
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    DaDA Version 2 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017341 Co Ltd THE SECRETARY OF STATE FOR
    1a Sultan Street EDUCATION
    Beckenham DEPARTMENT FOR EDUCATION
    Kent 20 GREAT SMITH STREET
    AND
    BR3 1AG LONDON
    SW1P 3BT
    Company No: AA017341
    Hereinafter called Hereinafter called
    the Contractor the Department
    DaDA Version 2 (April 2022) Page 2
    DaDA Version 2 (April 2022) Page 77
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    DANCE AND DRAMA AWARDS (DaDA) SPECIFICATION
    DaDA Schedule 1 Version 1 (July 2021) – Page 1
    DaDA Schedule 1 Version 1 (July 2021) – Page 4
    SCHEDULE 1: ANNEX 1
    DANCE AND DRAMA AWARD SCHEME (DaDA) INSTITUTION GUIDE TO
    SCHEME RULES AND INCOME ASSESSMENT
    DaDA Schedule 1 – Annex 1 Version 1 (July 2021) – Page 1
    DaDA Schedule 1 – Annex 1 Version 1 (July 2021) – Page 47
    
    SCHEDULE 2: PAYMENT
    DANCE AND DRAMA AWARDS (DaDA) PAYMENT
    DaDA Schedule 2 Version 1 (July 2021) – Page 1
    
    SCHEDULE 2
    Funding Agreement
    Provider: 10017341 Co Ltd UKPRN: 10017341
    Master Contract Number: ESFA-341 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_DADA]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Dance and Drama Awards (DaDA) £15,654 £0 £5,439 £0 £3,088 £0 £0 £3,200 £0 £0 £0 £3,927 £0
    Total Funding £15,654 £0 £5,439 £0 £3,088 £0 £0 £3,200 £0 £0 £0 £3,927 £0
    Schedule 2 – Funding Agreement [AllocRef_DADA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    DaDA Schedule 3 Version 1 (July 2021) – Page 1
    DaDA Schedule 10 Version 1 (July 2021) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017341_[ContractNo]_v1.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A341a.pdf'



    
    
    # Publish and approve 21/22 DADA contract v1

    # Change the date
    Given the override date is '12/08/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-341' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017341 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017341 | DADAS-341          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017341 | ESFA-341           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 3: Issue a NOTIFICATION NFA against v1 of the 20/21 contract > Awaiting Documentation

    # Change the date
    Given the override date is '14/08/2021'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2 of the 20/21 DADA contract
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-341' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017341 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017341 | DADAS-341          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017341 | DADAS-341          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017341 | ESFA-341           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check the contents of the Appendices (SoF only)
    And   the file named '10017341_DADAS-341_v2.pdf' in Sharepoint location 'DADA-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017341 Co Ltd UKPRN: 10017341
    Master Contract Number: ESFA-341
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    Dance and Drama Awards (DaDA) DADA-341 £1,411 £724 £2,135
    Total: £2,135
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £11,727 £3,927 £15,654
    Total: £15,654
    Total Funding for this contract: £17,789
    Summary of Funding – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017341_DADAS-341_v2.pdf' in 'DADA-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A341b.pdf'



    # Part 4: Import a non-material update to the DADA 21/22 FA > Discarded\NonMaterialUpdate

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '16/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-3_1           | 3_1            | DADA                        | AY-2122            | 15654.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017341-3_1  | 3_1                    | DADA-AY-2122-Contract-Provider-10017341-3_1           | 10017341      | Furth        | 07HEP           | 15654.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017341-3_1  | DADA-001        | 15654.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017341-3_1  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017341-3_1  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017341-3_1  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017341-3_1  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '18/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-3_1             | 3_1            | AY-2122 | DADA                        | 15654.00    | ?               | Discarded         | NonMaterialUpdate                 |
    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |





    # Part 5 Import a material update to the DADA 21/22 FA > Queued

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '20/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-4_4           | 4_4            | DADA                        | AY-2122            | 20000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017341-4_4  | 4_4                    | DADA-AY-2122-Contract-Provider-10017341-4_4           | 10017341      | Furth        | 07HEP           | 20000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017341-4_4  | DADA-001        | 20000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017341-4_4  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017341-4_4  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017341-4_4  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017341-4_4  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
    | DADA-AY-2122-10017341-4_4  | DADA-001        | FY-2122              | July                   | 2022              | 4346.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '22/08/2021'

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
    | 10017341 | 10017341 Co Ltd  | DADA-AY-2122-Contract-Provider-10017341-4_4             | 4_4            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release        | 20000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CfS2]          | ?          | ?                   |
    | 10017341 | 10017341 Co Ltd  | DADA-AY-2122-Contract-Provider-10017341-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '24/08/2021'

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
    When  I retrieve the latest contract details from CRM for provider '10017341' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017341 | 10017341 Co Ltd  | DADA-AY-2122-Contract-Provider-10017341-4_4             | 4_4            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 24/08/2021 | DADAS-341           |
    | 10017341 | 10017341 Co Ltd  | DADA-AY-2122-Contract-Provider-10017341-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | DADAS-2856    | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |


    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017341-4_4             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017341-4_4             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017341-2_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017341-2_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017341-2_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-4_4             | 4_4            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-3_1             | 3_1            | AY-2122 | DADA                        | 15654.00    | ?               | Discarded         | NonMaterialUpdate                 |
    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017341 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017341 | DADAS-341          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017341 | DADAS-341          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017341 | ESFA-341           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 6: Publish and auto-approve the 20/21 notification amendment

    # Change the date 
    Given the override date is '26/08/2021'

    # Create dummy Ts&Cs doc in Sharepoint
    And   there are no files prefixed '10017341' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017341' in the Sharepoint 'DADA-2021-Input-Terms And Conditions' folder
    And   a file with filename '10017341_DADAS-341_v2.pdf' is created in 'DADA-2021-Input-Appendices'
    And   a file with filename '10017341_DADAS-341_11.pdf' is created in 'DADA-2021-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '2' of contract 'DADAS-341' for provider '10017341' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'DADAS-341' for provider '10017341'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017341 - 10017341 Co Ltd Please review the contract       | DADAS-341      | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |
    | Initiate Document Merge          | 10017341 - 10017341 Co Ltd Awaiting documentation           | DADAS-341      | Document Management Team  | ?                        | Completed       | Completed        |

    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '2' of contract 'DADAS-341' for provider '10017341' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'DADAS-341' for provider '10017341'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017341 - 10017341 Co Ltd                                  | DADAS-341      | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |
    | Review Contract Details          | 10017341 - 10017341 Co Ltd Please review the contract       | DADAS-341      | FCS2 Test                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017341 - 10017341 Co Ltd Awaiting documentation           | DADAS-341      | Document Management Team  | ?                        | Completed       | Completed        |

    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '2' of contract 'DADAS-341' for provider '10017341' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'DADAS-341' for provider '10017341'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017341 - 10017341 Co Ltd                                  | DADAS-341      | Lead Manager Team         | ?                        | Open            | Not Started      |
    | Confirm Internal Approval        | 10017341 - 10017341 Co Ltd                                  | DADAS-341      | FCS1 Test                 | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017341 - 10017341 Co Ltd Please review the contract       | DADAS-341      | FCS2 Test                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017341 - 10017341 Co Ltd Awaiting documentation           | DADAS-341      | Document Management Team  | ?                        | Completed       | Completed        |

    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '2' of contract 'DADAS-341' for provider '10017341' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # The 20/21 contract should auto-approve and the queued 21/22 FA should auto-unqueue and create 21/22 contract v2

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017341 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation   | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017341 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                 | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017341 | DADAS-341          | 2                     | 0                        | Approved         | Approved                 | True          | True                | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017341 | DADAS-341          | 1                     | 0                        | Replaced         | Approved                 | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017341 | ESFA-341           | 1                     | 0                        | Draft            | ?                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-4_4             | 4_4            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | ?                 | ?                                 |
    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-3_1             | 3_1            | AY-2122 | DADA                        | 15654.00    | ?               | Discarded         | NonMaterialUpdate                 |
    | 10017341 | DADA-AY-2122-Contract-Provider-10017341-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017341-4_4             | [ContractNo] | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017341-2_3             | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017341 | 10017341 Co Ltd  | DADA-AY-2122-Contract-Provider-10017341-4_4             | 4_4            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 20000.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | ?          | ?                   |
    | 10017341 | 10017341 Co Ltd  | DADA-AY-2122-Contract-Provider-10017341-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |


    # Check the contents of the Appendices (SoF and FA only)
    And   the file named '10017341_[ContractNo]_v2.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017341 Co Ltd UKPRN: 10017341
    Master Contract Number: ESFA-341
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    Dance and Drama Awards (DaDA) DADA-341 £1,411 £724 £2,135
    Total: £2,135
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £11,727 £8,273 £20,000
    Total: £20,000
    Total Funding for this contract: £22,135
    Summary of Funding – Page 1
    
    SCHEDULE 2
    Funding Agreement
    Provider: 10017341 Co Ltd UKPRN: 10017341
    Master Contract Number: ESFA-341 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_DADA]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Dance and Drama Awards (DaDA) £20,000 £0 £5,439 £0 £3,088 £0 £0 £3,200 £0 £0 £0 £3,927 £4,346
    Total Funding £20,000 £0 £5,439 £0 £3,088 £0 £0 £3,200 £0 £0 £0 £3,927 £4,346
    Schedule 2 – Funding Agreement [AllocRef_DADA] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017341_[ContractNo]_v2.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A341c.pdf'


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A342 Create and approve a 20/21 DADA contract. Import a 21/22 DADA FA. Release and approve. Variation NFA 20/21. Import and queue 21/22 FA. Initiate Termination on 21/22. Publish and approve 20/21. 21/22 should queue with 21/22 contract no.

    # 1. Create and approve DADA 20/21 contract                            DADAS-342
    # 2. Import and release DADA 21/22 FA > Approved                       [ContractNo]
    # 3. Variation NFA on 20/21 contract > Awaiting Documentation          DADAS-342
    # 4. Import 21/22 FA > queue with 2021 contract number                 [ContractNo]
    # 5. Request termination initiation approval on 21/22 contract         [ContractNo]
    # 6. Publish and approve draft 20/21 DADA contract                     DADAS-342
    # 7. 21/22 FA > re-queue with 21/22 contract number                    [ContractNo]

    Given there are no allocations marked as Under Termination for UKPRN '10017342' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017342'
    And   there is no Funding Allocation data in CRM for UKPRN '10017342'
    And   there are no terminated or closed allocations for UKPRN '10017342' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017342' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017342' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017342' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017342' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017342' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-342      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-342      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |
    | DADA2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-342      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017342'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017342' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017342 Co Ltd' with UKPRN '10017342' and OrgId 'ORG0017342' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017342' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017342 | 117342 | 10017342 Co Ltd | 0              | Locked Restructure    | Yes           | AA017342      | ?             | 1a Sultan Street       | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017342 |





    # Part 1: Create and approve 20/21 DADA contract
    
    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-342'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-342'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017342 | 10017342 Co Ltd      | ESFA-342             | DADAS-342      | 1                     | 01/08/2020        | 31/07/2021      | 2135.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017342 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017342 | DADAS-342      | DADA-342      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 2135.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017342 | DADAS-342      | DADA-342      | 1               | 0                     | 2135.00   | 1411.00   | 724.00    | 0.00     | 1411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 724.00   | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'DADAS-342' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-342' and actual ContractNumber 'DADAS-342'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-342' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017342 | DADAS-342          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017342 | ESFA-342           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 2: Import and release DADA 21/22 FA > Approved

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '06/08/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017342 | DADA-AY-2122-Contract-Provider-10017342-2_3           | 2_3            | DADA                        | AY-2122            | 15654.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017342-2_3  | 2_3                    | DADA-AY-2122-Contract-Provider-10017342-2_3           | 10017342      | Furth        | 07HEP           | 15654.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017342-2_3  | DADA-001        | 15654.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017342-2_3  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017342-2_3  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017342-2_3  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017342-2_3  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
 
 
 
 
 
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
    | 10017342 | 10017342 Co Ltd  | DADA-AY-2122-Contract-Provider-10017342-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 15654.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017342-2_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15654.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017342 | DADA-AY-2122-Contract-Provider-10017342-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

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
    When  I retrieve the latest contract details from CRM for provider '10017342' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017342 | 10017342 Co Ltd  | DADA-AY-2122-Contract-Provider-10017342-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017342-2_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017342-2_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017342 | DADA-AY-2122-Contract-Provider-10017342-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017342 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017342 | DADAS-342          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017342 | ESFA-342           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    
    
    
    
    # Publish and approve 21/22 DADA contract v1

    # Change the date
    Given the override date is '12/08/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-342' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017342 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017342 | DADAS-342          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017342 | ESFA-342           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 3: Issue a VARIATION NFA against v1 of the 20/21 contract > Awaiting Documentation

    # Change the date
    Given the override date is '14/08/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-342' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017342 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017342 | DADAS-342          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017342 | DADAS-342          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017342 | ESFA-342           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |



 
 
    # Part 4: Import a material update to the DADA 21/22 FA > Queued

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '16/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017342 | DADA-AY-2122-Contract-Provider-10017342-4_4           | 4_4            | DADA                        | AY-2122            | 20000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017342-4_4  | 4_4                    | DADA-AY-2122-Contract-Provider-10017342-4_4           | 10017342      | Furth        | 07HEP           | 20000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017342-4_4  | DADA-001        | 20000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017342-4_4  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017342-4_4  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017342-4_4  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017342-4_4  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
    | DADA-AY-2122-10017342-4_4  | DADA-001        | FY-2122              | July                   | 2022              | 4346.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '20/08/2021'

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
    | 10017342 | 10017342 Co Ltd  | DADA-AY-2122-Contract-Provider-10017342-4_4             | 4_4            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release        | 20000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CfS2]          | ?          | ?                   |
    | 10017342 | 10017342 Co Ltd  | DADA-AY-2122-Contract-Provider-10017342-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '24/08/2021'

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
    When  I retrieve the latest contract details from CRM for provider '10017342' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017342 | 10017342 Co Ltd  | DADA-AY-2122-Contract-Provider-10017342-4_4             | 4_4            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 24/08/2021 | DADAS-342           |
    | 10017342 | 10017342 Co Ltd  | DADA-AY-2122-Contract-Provider-10017342-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017342-4_4             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017342-4_4             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017342-2_3             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017342-2_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017342-2_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017342 | DADA-AY-2122-Contract-Provider-10017342-4_4             | 4_4            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017342 | DADA-AY-2122-Contract-Provider-10017342-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017342 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017342 | DADAS-342          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017342 | DADAS-342          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017342 | ESFA-342           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 5: Request termination initiation approval of 21/22 contract

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
    | 10017342 | [ContractNo]   | 1                     | 0                        | 05/10/2021                 | Notice from Agency           | ?                              | 05/10/2021              | Notice from Agency          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017342 | [ContractNo]  | [AllocRef_DADA]  | 1                     | 0                        | 03/09/2021                   | 03/09/2021        | 10/09/2021                      | 10/09/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017342'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017342 - 10017342 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017342 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017342 | DADAS-342          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017342 | DADAS-342          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017342 | ESFA-342           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




#
#    # Approve Termination Initiation (30635)
#
#    # Change the date - CRM ignores this
#    Given the override date is '06/10/2021'
#
#    # Clear down CM feed
#    And   the Contract Management atom feed is empty
#
#    # Complete an existing open Task
#    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017342' is triggered by User 'FCS5 TEST'
#    | Task                                     | Owner                     |
#    | Confirm Termination Initiation Approval  | FCS1 TEST                 |
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017342 | [ContractNo]       | 1                     | 0                        | Approved         | Under Termination                         | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
#    #
#    | 10017342 | DADAS-342          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
#    | 10017342 | DADAS-342          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
#    | 10017342 | ESFA-342           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
#




    # Parts 6/7: Publish and approve draft 20/21 DADA contract

    # Change the date
    Given the override date is '08/10/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'DADAS-342' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-342' and actual ContractNumber 'DADAS-342'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-342' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017342 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017342 | DADAS-342          | 2                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017342 | DADAS-342          | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017342 | ESFA-342           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017342 | 10017342 Co Ltd  | DADA-AY-2122-Contract-Provider-10017342-4_4             | 4_4            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 08/10/2021 | [ContractNo]        |
    | 10017342 | 10017342 Co Ltd  | DADA-AY-2122-Contract-Provider-10017342-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017342 | DADA-AY-2122-Contract-Provider-10017342-4_4             | 4_4            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017342 | DADA-AY-2122-Contract-Provider-10017342-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |
     
    
    # Tidy Up
    Given the override date is reset

