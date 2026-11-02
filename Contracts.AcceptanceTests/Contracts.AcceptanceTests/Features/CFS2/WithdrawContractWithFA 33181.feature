Feature: WithdrawContractWithFA 33181

@AcceptanceTest @Withdrawn20211216
@CFS
Scenario: A714 Create a draft EDSK contract for a Local Authority and two schools. Publish and withdraw contract. Check CRM, PaaS, and WF History
    Given there is no Contract, Task or Workflow data for UKPRN '10017714' 
    And   there is no Contract, Task or Workflow data for UKPRN '10034368'
    And   there is no Contract, Task or Workflow data for UKPRN '10042157'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017714'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10034368'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10042157'
    And   there is no Funding Allocation data in CRM for UKPRN '10017714'
    And   there is no Funding Allocation data in CRM for UKPRN '10034368'
    And   there is no Funding Allocation data in CRM for UKPRN '10042157'

    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017714' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017714' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-714      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-714      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2122      |
    | 1619ED2122        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-714       | 1                     | 0                        |

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017714' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017714' 
    And   there is no Organisation data for UKPRN '10034368' 
    And   there is no Organisation data for UKPRN '10042157'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017714 County Council' with UKPRN '10017714' and OrgId 'ORG0017714' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10034368 Sixth Form College' with UKPRN '10034368' and OrgId 'ORG0034368' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10042157 Sixth Form College' with UKPRN '10042157' and OrgId 'ORG0042157' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                        | SequenceNumber | Status        | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017714 | 117714 | 10017714 County Council     | 0              | Active        | Yes           | AA017714      | ?             | 35 Mosbach Gardens     | Hutton West            | ?                      | ?                      | Brentwood              | Essex                  | CM13 2UW  |
    | 10034368 | 134368 | 10034368 Sixth Form College | 0              | Active        | Yes           | AA034368      | ?             | 65-68 Moffats Lane     | Brookmans Park         | ?                      | ?                      | Brentford              | Essex                  | CM9 7RT   |
    | 10042157 | 142157 | 10042157 Sixth Form College | 0              | Active        | Yes           | AA042157      | ?             | Wilson Avenue          | Great Barton           | ?                      | ?                      | Brentford              | Essex                  | CM22 6RR  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017714 |
    | 10034368 |
    | 10042157 |





    # Populate the stub with 1619 (10LAU) data for the Local Authority

    # Change the date 
    Given the override date is '04/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017714 | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3     | 1_3            | 1619                        | AS-2122            | 29941.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017714-1_3  | 1_3                    | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3     | 10017714      | Local        | 10LAU           | 29941.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017714-1_3  | 1619-001        | 13484.00         | Payment         |
    | 1619-AS-2122-10017714-1_3  | 1619-007        | 12147.00         | Payment         |
    | 1619-AS-2122-10017714-1_3  | 1619-020        | 4310.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017714-1_3  | 1619-001        | FY-2021              | November               | 2021              | 2822.00                   |
    | 1619-AS-2122-10017714-1_3  | 1619-001        | FY-2021              | December               | 2021              | 4746.00                   |
    | 1619-AS-2122-10017714-1_3  | 1619-001        | FY-2021              | July                   | 2022              | 5916.00                   |
    #
    | 1619-AS-2122-10017714-1_3  | 1619-007        | FY-2021              | September              | 2021              | 2014.00                   |
    | 1619-AS-2122-10017714-1_3  | 1619-007        | FY-2021              | January                | 2022              | 3050.00                   |
    | 1619-AS-2122-10017714-1_3  | 1619-007        | FY-2021              | April                  | 2022              | 2067.00                   |
    | 1619-AS-2122-10017714-1_3  | 1619-007        | FY-2021              | July                   | 2022              | 5016.00                   |
    #
    | 1619-AS-2122-10017714-1_3  | 1619-020        | FY-2021              | March                  | 2022              | 4310.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '06/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider                | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017714 | 10017714 County Council | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3       | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 29941.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |





    # Populate the stub with NFF (08SSF) data for the two Sixth Form Colleges

    # Change the date 
    Given the override date is '08/07/2021'
    
    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017714 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8  | 1_8            | NMSS                        | AY-2122            | 110766.00         |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10034368-1_8  | 1_8                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8  | 10034368      | Schoo        | 08SSF           | 65377.00                  |
    | NMSS-AY-2122-10042157-1_8  | 1_8                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8  | 10042157      | Schoo        | 08SSF           | 45389.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10034368-1_8  | NMSS-001        | 12823.00         | Payment         |
    | NMSS-AY-2122-10034368-1_8  | NMSS-002        | 13554.00         | Payment         |
    | NMSS-AY-2122-10034368-1_8  | NMSS-006        | 12912.00         | Payment         |
    | NMSS-AY-2122-10034368-1_8  | NMSS-007        | 18968.00         | Payment         |
    | NMSS-AY-2122-10034368-1_8  | NMSS-008        | 7120.00          | Payment         |
    #
    | NMSS-AY-2122-10042157-1_8  | NMSS-005        | 13593.00         | Payment         |
    | NMSS-AY-2122-10042157-1_8  | NMSS-007        | 14101.00         | Payment         |
    | NMSS-AY-2122-10042157-1_8  | NMSS-008        | 17695.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10034368-1_8  | NMSS-001        | FY-2021              | August                 | 2021              | 2208.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-001        | FY-2021              | January                | 2022              | 2561.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-001        | FY-2021              | April                  | 2022              | 3629.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-001        | FY-2021              | June                   | 2022              | 4425.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-002        | FY-2021              | August                 | 2021              | 2846.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-002        | FY-2021              | February               | 2022              | 4769.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-002        | FY-2021              | May                    | 2022              | 5939.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-006        | FY-2021              | November               | 2021              | 3337.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-006        | FY-2021              | January                | 2022              | 5501.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-006        | FY-2021              | May                    | 2022              | 4074.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-007        | FY-2021              | August                 | 2021              | 2710.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-007        | FY-2021              | November               | 2021              | 4190.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-007        | FY-2021              | February               | 2022              | 3752.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-007        | FY-2021              | April                  | 2022              | 2940.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-007        | FY-2021              | June                   | 2022              | 5376.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-008        | FY-2021              | August                 | 2021              | 5061.00                   |
    | NMSS-AY-2122-10034368-1_8  | NMSS-008        | FY-2021              | March                  | 2022              | 2059.00                   |
    #
    | NMSS-AY-2122-10042157-1_8  | NMSS-005        | FY-2021              | September              | 2021              | 4442.00                   |
    | NMSS-AY-2122-10042157-1_8  | NMSS-005        | FY-2021              | December               | 2021              | 5238.00                   |
    | NMSS-AY-2122-10042157-1_8  | NMSS-005        | FY-2021              | July                   | 2022              | 3913.00                   |
    | NMSS-AY-2122-10042157-1_8  | NMSS-007        | FY-2021              | November               | 2021              | 4442.00                   |
    | NMSS-AY-2122-10042157-1_8  | NMSS-007        | FY-2021              | January                | 2022              | 5543.00                   |
    | NMSS-AY-2122-10042157-1_8  | NMSS-007        | FY-2021              | May                    | 2022              | 4116.00                   |
    | NMSS-AY-2122-10042157-1_8  | NMSS-008        | FY-2021              | September              | 2021              | 4718.00                   |
    | NMSS-AY-2122-10042157-1_8  | NMSS-008        | FY-2021              | November               | 2021              | 5855.00                   |
    | NMSS-AY-2122-10042157-1_8  | NMSS-008        | FY-2021              | February               | 2022              | 3505.00                   |
    | NMSS-AY-2122-10042157-1_8  | NMSS-008        | FY-2021              | July                   | 2022              | 3617.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '10/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider                | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017714 | 10017714 County Council | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3       | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 29941.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
    | 10017714 | 10017714 County Council | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | 1_8            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 110766.00   | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 140707.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017714 | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3       | 1_3            | AS-2122 | 1619                        | 29941.00    | [CofG_LA]    |
    | 10017714 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | 1_8            | AY-2122 | NMSS                        | 110766.00   | [CofG_LA]    |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'
    




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '12/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 140707.00       |

    # Retrieve parameters from CRM for the Contracting Org
   #When  I retrieve the latest contract details from CRM for provider '10017714' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017714' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017714'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider                 | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017714 | 10017714 County Council  | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3       | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 29941.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |
    | 10017714 | 10017714 County Council  | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | 1_8            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Released          | Released          | 110766.00   | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus    |
    | 10017714 | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3       | 1_3            | AS-2122 | 1619                        | 29941.00    | [CofG_LA]       | ?                 | ?            |
    | 10017714 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | 1_8            | AY-2122 | NMSS                        | 110766.00   | [CofG_LA]       | ?                 | ?            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3       | [ContractNo] | 1               | 0                  | Yes            |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017714 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017714 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName            | State  | TaskOwner                 | ContractValueVariation |
    | 10017714 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 140707.00     | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017714 County Council | Active | Document Management Team  | ?                      |
    | 10017714 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017714 County Council | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider            | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017714 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 29941.00        | 10017714      | 10017714 County Council     | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |
 #  | 10017714 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 65377.00        | 10034368      | 10034368 Sixth Form College | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |
 #  | 10017714 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 45389.00        | 10042157      | 10042157 Sixth Form College | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | 10017119 | [ContractNo]   | [AllocRef_16ED]    | 20              | 0                     | 13484.00  | 0.00     | 0.00     | 0.00     | 2822.00  | 4746.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5916.00  | 16-19 Programme Funding                                     |                          |
    | 10017119 | [ContractNo]   | [AllocRef_16ED]    | 52              | 0                     | 4310.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4310.00  | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing                       |                          |
    | 10017119 | [ContractNo]   | [AllocRef_16ED]    | 112             | 0                     | 12147.00  | 0.00     | 2014.00  | 0.00     | 0.00     | 0.00     | 3050.00  | 0.00     | 0.00     | 2067.00  | 0.00     | 0.00     | 5016.00  | 16-19 Capacity and Delivery                                 |                          |
    #
 #  | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 15              | 0                     | 13554.00  | 2846.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4769.00  | 0.00     | 0.00     | 5939.00  | 0.00     | 0.00     | SSF High Needs Element 2                                    |                          |
 #  | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 39              | 0                     | 12823.00  | 2208.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2561.00  | 0.00     | 0.00     | 3629.00  | 0.00     | 4425.00  | 0.00     | NMF Pre-16 Funding (NMSS)                                   |                          |
 #  | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 118             | 0                     | 12912.00  | 0.00     | 0.00     | 0.00     | 3337.00  | 0.00     | 5501.00  | 0.00     | 0.00     | 0.00     | 4074.00  | 0.00     | 0.00     | Teachers Pay Grant (NMSS)                                   |                          |
 #  | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 135             | 0                     | 18968.00  | 2710.00  | 0.00     | 0.00     | 4190.00  | 0.00     | 0.00     | 3752.00  | 0.00     | 2940.00  | 0.00     | 5376.00  | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
 #  | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 140             | 0                     | 7120.00   | 5061.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2059.00  | 0.00     | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                                        |                          |
    #
 #  | 10017121 | [ContractNo]   | [AllocRef_16ED]    | 43              | 0                     | 13593.00  | 0.00     | 4442.00  | 0.00     | 0.00     | 5238.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3913.00  | Primary PE and Sport Premium                                |                          |
 #  | 10017121 | [ContractNo]   | [AllocRef_16ED]    | 135             | 0                     | 14101.00  | 0.00     | 0.00     | 0.00     | 4442.00  | 0.00     | 5543.00  | 0.00     | 0.00     | 0.00     | 4116.00  | 0.00     | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
 #  | 10017121 | [ContractNo]   | [AllocRef_16ED]    | 140             | 0                     | 17695.00  | 0.00     | 4718.00  | 0.00     | 5855.00  | 0.00     | 0.00     | 3505.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3617.00  | Pupil Premium (NMSS)                                        |                          |



    # Retrieve parameters from CRM for the FIRST Delivery Org (10034368)
   #When  I retrieve the latest contract details from CRM for provider '10017714' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017714' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10034368'

    # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider            | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
 #  | 10017714 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 29941.00        | 10017714      | 10017714 County Council     | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |
    | 10017714 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 65377.00        | 10034368      | 10034368 Sixth Form College | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |
 #  | 10017714 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 45389.00        | 10042157      | 10042157 Sixth Form College | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
 #  | 10017119 | [ContractNo]   | [AllocRef_16ED]    | 20              | 0                     | 13484.00  | 0.00     | 0.00     | 0.00     | 2822.00  | 4746.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5916.00  | 16-19 Programme Funding                                     |                          |
 #  | 10017119 | [ContractNo]   | [AllocRef_16ED]    | 52              | 0                     | 4310.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4310.00  | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing                       |                          |
 #  | 10017119 | [ContractNo]   | [AllocRef_16ED]    | 112             | 0                     | 12147.00  | 0.00     | 2014.00  | 0.00     | 0.00     | 0.00     | 3050.00  | 0.00     | 0.00     | 2067.00  | 0.00     | 0.00     | 5016.00  | 16-19 Capacity and Delivery                                 |                          |
    #
    | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 15              | 0                     | 13554.00  | 2846.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4769.00  | 0.00     | 0.00     | 5939.00  | 0.00     | 0.00     | SSF High Needs Element 2                                    |                          |
    | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 39              | 0                     | 12823.00  | 2208.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2561.00  | 0.00     | 0.00     | 3629.00  | 0.00     | 4425.00  | 0.00     | NMF Pre-16 Funding (NMSS)                                   |                          |
    | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 118             | 0                     | 12912.00  | 0.00     | 0.00     | 0.00     | 3337.00  | 0.00     | 5501.00  | 0.00     | 0.00     | 0.00     | 4074.00  | 0.00     | 0.00     | Teachers Pay Grant (NMSS)                                   |                          |
    | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 135             | 0                     | 18968.00  | 2710.00  | 0.00     | 0.00     | 4190.00  | 0.00     | 0.00     | 3752.00  | 0.00     | 2940.00  | 0.00     | 5376.00  | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
    | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 140             | 0                     | 7120.00   | 5061.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2059.00  | 0.00     | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                                        |                          |
    #
 #  | 10017121 | [ContractNo]   | [AllocRef_16ED]    | 43              | 0                     | 13593.00  | 0.00     | 4442.00  | 0.00     | 0.00     | 5238.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3913.00  | Primary PE and Sport Premium                                |                          |
 #  | 10017121 | [ContractNo]   | [AllocRef_16ED]    | 135             | 0                     | 14101.00  | 0.00     | 0.00     | 0.00     | 4442.00  | 0.00     | 5543.00  | 0.00     | 0.00     | 0.00     | 4116.00  | 0.00     | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
 #  | 10017121 | [ContractNo]   | [AllocRef_16ED]    | 140             | 0                     | 17695.00  | 0.00     | 4718.00  | 0.00     | 5855.00  | 0.00     | 0.00     | 3505.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3617.00  | Pupil Premium (NMSS)                                        |                          |



    # Retrieve parameters from CRM for the SECOND Delivery Org (10042157)
   #When  I retrieve the latest contract details from CRM for provider '10017714' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017714' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10042157'

    # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider            | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
 #  | 10017714 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 29941.00        | 10017714      | 10017714 County Council     | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |
 #  | 10017714 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 65377.00        | 10034368      | 10034368 Sixth Form College | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |
    | 10017714 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 45389.00        | 10042157      | 10042157 Sixth Form College | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
 #  | 10017119 | [ContractNo]   | [AllocRef_16ED]    | 20              | 0                     | 13484.00  | 0.00     | 0.00     | 0.00     | 2822.00  | 4746.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5916.00  | 16-19 Programme Funding                                     |                          |
 #  | 10017119 | [ContractNo]   | [AllocRef_16ED]    | 52              | 0                     | 4310.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4310.00  | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing                       |                          |
 #  | 10017119 | [ContractNo]   | [AllocRef_16ED]    | 112             | 0                     | 12147.00  | 0.00     | 2014.00  | 0.00     | 0.00     | 0.00     | 3050.00  | 0.00     | 0.00     | 2067.00  | 0.00     | 0.00     | 5016.00  | 16-19 Capacity and Delivery                                 |                          |
    #
 #  | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 15              | 0                     | 13554.00  | 2846.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4769.00  | 0.00     | 0.00     | 5939.00  | 0.00     | 0.00     | SSF High Needs Element 2                                    |                          |
 #  | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 39              | 0                     | 12823.00  | 2208.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2561.00  | 0.00     | 0.00     | 3629.00  | 0.00     | 4425.00  | 0.00     | NMF Pre-16 Funding (NMSS)                                   |                          |
 #  | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 118             | 0                     | 12912.00  | 0.00     | 0.00     | 0.00     | 3337.00  | 0.00     | 5501.00  | 0.00     | 0.00     | 0.00     | 4074.00  | 0.00     | 0.00     | Teachers Pay Grant (NMSS)                                   |                          |
 #  | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 135             | 0                     | 18968.00  | 2710.00  | 0.00     | 0.00     | 4190.00  | 0.00     | 0.00     | 3752.00  | 0.00     | 2940.00  | 0.00     | 5376.00  | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
 #  | 10017120 | [ContractNo]   | [AllocRef_16ED]    | 140             | 0                     | 7120.00   | 5061.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2059.00  | 0.00     | 0.00     | 0.00     | 0.00     | Pupil Premium (NMSS)                                        |                          |
    #
    | 10017121 | [ContractNo]   | [AllocRef_16ED]    | 43              | 0                     | 13593.00  | 0.00     | 4442.00  | 0.00     | 0.00     | 5238.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3913.00  | Primary PE and Sport Premium                                |                          |
    | 10017121 | [ContractNo]   | [AllocRef_16ED]    | 135             | 0                     | 14101.00  | 0.00     | 0.00     | 0.00     | 4442.00  | 0.00     | 5543.00  | 0.00     | 0.00     | 0.00     | 4116.00  | 0.00     | 0.00     | Teachers Pension Scheme (NMSS)                              |                          |
    | 10017121 | [ContractNo]   | [AllocRef_16ED]    | 140             | 0                     | 17695.00  | 0.00     | 4718.00  | 0.00     | 5855.00  | 0.00     | 0.00     | 3505.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3617.00  | Pupil Premium (NMSS)                                        |                          |


    # Check the deliverable count in CRM
    Then  there are '132' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'





    # Publish the contract (32385)

    # Change the date 
    Given the override date is '14/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Withdraw contract and return FA to Scheduling (33181)

    # Change the date
    Given the override date is '16/07/2021'

    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017714 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the contents of the CRM Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017714 | [MasterContractNo] | [ContractNo]   | 1                     | Withdrawal On Behalf Of Provider Successful | CRM Integration               | FCS2 TEST        | Document Management Team    | Withdrawn         | Withdrawn By Provider                        | FCS2 TEST             | Document Management Team  | Draft          | Withdrawal In Progress                       |
    | 10017714 | [MasterContractNo] | [ContractNo]   | 1                     | Withdraw On Behalf Of Provider              | FCS2 TEST                     | FCS2 TEST        | Document Management Team    | Draft             | Withdrawal In Progress                       | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                             |
    | Withdrawal On Behalf Of Provider Successful    | CRM Integration               | ?                                   |
    | Withdraw On Behalf Of Provider                 | FCS2 TEST                     | The Provider was rude to me         |

    # Check Atom feed data for a type 2 'Withdrawal' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '2' event for contract number '[ContractNo]'
    And   the ItemType '2' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
    
    # Check the CRM Funding Allocation Workflow History data
    Then  the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3       | Contract Withdrawn              | CRM Integration   | Scheduling         | Returned to Scheduling          | Released       | Released                        | ?                             |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | Contract Withdrawn              | CRM Integration   | Scheduling         | Returned to Scheduling          | Released       | Released                        | ?                             |

    # Check the state of a Release Group (J129)  (Disassociate FA fom Release Group)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 0               | 0.00            |

    # Check the CRM Funding Allocations data  (Updated to reflect the contract withdrawal. Remove link to contract)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider                | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus              | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017714 | 10017714 County Council | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3       | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling | 29941.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |
    | 10017714 | 10017714 County Council | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | 1_8            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Scheduling        | Returned to Scheduling | 110766.00   | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)   (Remove link to Release Group)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus    |
    | 10017714 | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3       | 1_3            | AS-2122 | 1619                        | 29941.00    | ?               | ?                 | ?            |
    | 10017714 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | 1_8            | AY-2122 | NMSS                        | 110766.00   | ?               | ?                 | ?            |





    # 33181 ends here. Scenario continues for 33218





    # Withdraw Funding Allocation (33218)  (Change FA state: Scheduling\Returned to Scheduling -> Withdrawn\Withdrawn)

    # Change the date 
    Given the override date is '18/07/2021'

    # Invoke process to withdraw the NMSS Funding Allocation from Contract Control, leaving the 1619 FA in Scheduling (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                               | 
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | 

    # Check the CRM Funding Allocations data (J125)   (Change NMSS FA state to Withdrawn\Withdrawn)
    Then   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider                | FundingId                                             | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup  |
    | 10017714 | 10017714 County Council | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3     | 1_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 29941.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?             |
    | 10017714 | 10017714 County Council | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8  | 1_8            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 110766.00   | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?             |

    # Check the CRM Funding Allocation Workflow History.   Two new entries
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                      | CompletedBy       | NewStatus      | NewSubStatus              | PreviousStatus | PreviousSubStatus         | Comment                       |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | Withdrawn                   | CRM Integration   | Withdrawn      | Withdrawn                 | Scheduling     | Withdrawal in Progress    | Instructed by CFS             |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | Withdrawal in Progress      | FCS8 TEST         | Scheduling     | Withdrawal in Progress    | Scheduling     | Returned to Scheduling    | Instructed by CFS             |
    
    # Check PaaS FundingAllocation.FundingAllocation (J131)   (Disassociate FA from RG)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus    |
    | 10017714 | 1619-AS-2122-Contract-LocalAuthority-10017714-1_3       | 1_3            | AS-2122 | 1619                        | 29941.00    | ?               | ?                 | ?            |
    | 10017714 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017714-1_8    | 1_8            | AY-2122 | NMSS                        | 110766.00   | ?               | Withdrawn         | Withdrawn    |


    # Tidy Up
    And   the override date is reset

