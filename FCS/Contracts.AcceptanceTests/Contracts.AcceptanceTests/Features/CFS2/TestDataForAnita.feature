Feature: TestDataForAnita

@AcceptanceTest @Manual
@CFS
Scenario: A401X Create 3x 20/21 DADA contracts. Import 3x 21/22 DADA FAs from CFS. Release and queue

    # 1. Create 3 draft 20/21 DADA contracts
    # 2. Import 3 21/22 DADA FAs

    Given there are no allocations marked as Under Termination for UKPRN '10055637' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10055637'
    And   there is no Funding Allocation data in CRM for UKPRN '10055637'
    And   there are no terminated or closed allocations for UKPRN '10055637' 
    And   there is no Contract, Task or Workflow data for UKPRN '10055637' 

    Given there are no allocations marked as Under Termination for UKPRN '10055638' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10055638'
    And   there is no Funding Allocation data in CRM for UKPRN '10055638'
    And   there are no terminated or closed allocations for UKPRN '10055638' 
    And   there is no Contract, Task or Workflow data for UKPRN '10055638' 

    Given there are no allocations marked as Under Termination for UKPRN '10055639' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10055639'
    And   there is no Funding Allocation data in CRM for UKPRN '10055639'
    And   there are no terminated or closed allocations for UKPRN '10055639' 
    And   there is no Contract, Task or Workflow data for UKPRN '10055639' 

    # Clear down ContractManagement.FundingAllocationRelease table (J155) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10055637' 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10055638' 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10055639' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10055637' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10055637' in the Sharepoint 'DADA-2122-Input-Appendices' folder
    #
    And   there are no files prefixed '10055638' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10055638' in the Sharepoint 'DADA-2122-Input-Appendices' folder
    #
    And   there are no files prefixed '10055639' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10055639' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-637      |
    | DADA-638      |
    | DADA-639      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-637      |
    | DADA-638      |
    | DADA-639      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |
    | DADA2122          |


    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10055637' 
    Given there is no Organisation data for UKPRN '10055638' 
    Given there is no Organisation data for UKPRN '10055639' 


    And   caseload advisor 'FCS2 Test' is assigned to provider 'Train & Grow Co' with UKPRN '10055637' and OrgId 'ORG0055637' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'The JCB Academy' with UKPRN '10055638' and OrgId 'ORG0055638' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Royal Air Force' with UKPRN '10055639' and OrgId 'ORG0055639' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10055637 | 155637 | Train & Grow Co | 0              | Active                | Yes           | AA055637      | ?             | 139 High Street        | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |
    | 10055638 | 155638 | The JCB Academy | 0              | Active                | Yes           | AA055638      | ?             | 12 Highgate Centre     | Highgate Square        | Birmingham             | ?                      | ?                      | ?                      | B12 0DX   |
    | 10055639 | 155639 | Royal Air Force | 0              | Active                | Yes           | AA055639      | ?             | 10 St. Mary at Hill    | London                 | ?                      | ?                      | ?                      | ?                      | EC3R 8EE  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10055637 |
    | 10055638 |
    | 10055639 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-637'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-637'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10055637 | Train & Grow Co      | ESFA-637             | DADAS-637      | 1                     | 01/08/2020        | 31/07/2021      | 2135.00       |                                       | Contract for Services                      | 2021   | New          | ORG0055637 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10055637 | DADAS-637      | DADA-637      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 2135.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10055637 | DADAS-637      | DADA-637      | 1               | 0                     | 2135.00   | 1411.00   | 724.00    | 0.00     | 1411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 724.00   | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | DADAS-637      | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10055637 | DADAS-637          | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10055637 | ESFA-637           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-638'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-638'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10055638 | The JCB Academy      | ESFA-638             | DADAS-638      | 1                     | 01/08/2020        | 31/07/2021      | 4809.00       |                                       | Contract for Services                      | 2021   | New          | ORG0055638 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10055638 | DADAS-638      | DADA-638      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 4809.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10055638 | DADAS-638      | DADA-638      | 1               | 0                     | 4809.00   | 2748.00   | 2061.00   | 0.00     | 2748.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2061.00  | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | DADAS-638      | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10055638 | DADAS-638          | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10055638 | ESFA-638           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-639'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-639'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10055639 | Royal Air Force      | ESFA-639             | DADAS-639      | 1                     | 01/08/2020        | 31/07/2021      | 4555.00       |                                       | Contract for Services                      | 2021   | New          | ORG0055639 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10055639 | DADAS-639      | DADA-639      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 4555.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10055639 | DADAS-639      | DADA-639      | 1               | 0                     | 4555.00   | 1404.00   | 2961.00   | 0.00     | 1404.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2961.00  | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | DADAS-639      | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10055639 | DADAS-639          | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10055639 | ESFA-639           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Create the 2122 DADA contract

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10055637 | DADA-AY-2122-Contract-Provider-10055637-2_3           | 2_3            | DADA                        | AY-2122            | 15654.00          |
    | Contracting    | 10055638 | DADA-AY-2122-Contract-Provider-10055638-1_1           | 1_1            | DADA                        | AY-2122            | 14377.00          |
    | Contracting    | 10055639 | DADA-AY-2122-Contract-Provider-10055639-3_6           | 3_6            | DADA                        | AY-2122            | 2426.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10055637-2_3  | 2_3                    | DADA-AY-2122-Contract-Provider-10055637-2_3           | 10055637      | Furth        | 07HEP           | 15654.00                  |
    | DADA-AY-2122-10055638-1_1  | 1_1                    | DADA-AY-2122-Contract-Provider-10055638-1_1           | 10055638      | Furth        | 07HEP           | 14377.00                  |
    | DADA-AY-2122-10055639-3_6  | 3_6                    | DADA-AY-2122-Contract-Provider-10055639-3_6           | 10055639      | Furth        | 07HEP           | 2426.00                   |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10055637-2_3  | DADA-001        | 15654.00         | Payment         |
    | DADA-AY-2122-10055638-1_1  | DADA-001        | 14377.00         | Payment         |
    | DADA-AY-2122-10055639-3_6  | DADA-001        | 2426.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10055637-2_3  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10055637-2_3  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10055637-2_3  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10055637-2_3  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
    #
    | DADA-AY-2122-10055638-1_1  | DADA-001        | FY-2122              | October                | 2021              | 2555.00                   |
    | DADA-AY-2122-10055638-1_1  | DADA-001        | FY-2122              | November               | 2021              | 4266.00                   |
    | DADA-AY-2122-10055638-1_1  | DADA-001        | FY-2122              | March                  | 2022              | 5233.00                   |
    | DADA-AY-2122-10055638-1_1  | DADA-001        | FY-2122              | June                   | 2022              | 2332.00                   |
    #
    | DADA-AY-2122-10055639-3_6  | DADA-001        | FY-2122              | November               | 2021              | 2426.00                   |

 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2021'

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
    | 10055637 | Train & Grow Co  | DADA-AY-2122-Contract-Provider-10055637-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 15654.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |
    | 10055638 | The JCB Academy  | DADA-AY-2122-Contract-Provider-10055638-1_1             | 1_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 14377.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |
    | 10055639 | Royal Air Force  | DADA-AY-2122-Contract-Provider-10055639-3_6             | 3_6            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 2426.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 32457.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10055637 | DADA-AY-2122-Contract-Provider-10055637-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |
    | 10055638 | DADA-AY-2122-Contract-Provider-10055638-1_1             | 1_1            | AY-2122 | DADA                        | 14377.00    | [CfS]           | ?                 | ?                                 |
    | 10055639 | DADA-AY-2122-Contract-Provider-10055639-3_6             | 3_6            | AY-2122 | DADA                        | 2426.00     | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'


    # Tidy Up
    And   the override date is reset

