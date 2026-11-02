Feature: CreateDADA2122contracts 33841

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A401 Create a 20/21 DADA contract. Import a 21/22 DADA FA from CFS and queue

    # 1. Create a draft 20/21 DADA contract
    # 2. Import and release a 21/22 DADA FA
    # 3. Queue 21/22 DADA FA

    Given there are no allocations marked as Under Termination for UKPRN '10017401' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017401'
    And   there is no Funding Allocation data in CRM for UKPRN '10017401'
    And   there are no terminated or closed allocations for UKPRN '10017401' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017401' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017401' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017401' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017401' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017401' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-401      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-401      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |
    | DADA2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-401      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017401'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017401' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Train & Grow Co' with UKPRN '10017401' and OrgId 'ORG0017401' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017401' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017401 | 117401 | Train & Grow Co | 0              | Locked Restructure    | Yes           | AA017401      | ?             | 139 High Street        | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017401 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-401'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-401'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017401 | Train & Grow Co      | ESFA-401             | DADAS-401      | 1                     | 01/08/2020        | 31/07/2021      | 2135.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017401 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017401 | DADAS-401      | DADA-401      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 2135.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017401 | DADAS-401      | DADA-401      | 1               | 0                     | 2135.00   | 1411.00   | 724.00    | 0.00     | 1411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 724.00   | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | DADAS-401      | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017401 | DADAS-401          | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017401 | ESFA-401           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Create the 2122 DADA contract

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017401 | DADA-AY-2122-Contract-Provider-10017401-2_3           | 2_3            | DADA                        | AY-2122            | 15654.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017401-2_3  | 2_3                    | DADA-AY-2122-Contract-Provider-10017401-2_3           | 10017401      | Furth        | 07HEP           | 15654.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017401-2_3  | DADA-001        | 15654.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017401-2_3  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017401-2_3  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017401-2_3  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017401-2_3  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
 
 
 
 
 
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
    | 10017401 | Train & Grow Co  | DADA-AY-2122-Contract-Provider-10017401-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 15654.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017401-2_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15654.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017401 | DADA-AY-2122-Contract-Provider-10017401-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2021'

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

#   The following lines were removed when Queuing was introduced by 33387 (and [CfS2] was no longer created)
#
#    # Capture the Release Group parameter value (J127)  (A new Release Group is created)
#   #Given the Release Groups for the following Contracting Profiles have been saved
#    Given the Release Group for the following Contracting Profile has been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS2                      |
#
#    # Write the following values to the output window
#    And   message 'ReleaseGroup CfS2 = [CfS2]' is written to the Output window
#
#    # Check the state of a Release Group (J129)  (The new Release Group contains the FA which failed because of MBR-005)
#    Then  Release Group '[CfS2]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Awaiting Release  | 1               | 15654.00        |
    
    # Check the CRM Funding Allocations data (J125) 
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017401 | Train & Grow Co  | DADA-AY-2122-Contract-Provider-10017401-2_3             | 2_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 15654.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | 08/07/2021 | DADAS-401           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017401-2_3             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017401-2_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017401 | DADA-AY-2122-Contract-Provider-10017401-2_3             | 2_3            | AY-2122 | DADA                        | 15654.00    | [CfS]           | InRelease         | Queued                            |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
@Long2Run @Long2Run45
Scenario: A402 Create and approve a 20/21 DADA contract. Import a 21/22 DADA FA from CFS and link to 20/21 contract by Master. Check docs, CRM, CDA, PaaS and feed. Add 22/23 DADA FA and repeat

    #  1. Create and approve a 20/21 DADA contract

    #  2. Import and release a 21/22 DADA FA
    #  3. 21/22 should identify intent as 'New Amendment' and link to 20/21 Master
    #  4. Check docs
    #  5. Publish and approve 21/22 contract
    #  6. CDA
    #  7. Payment batch   
    #  8. Check financials and feed

    #  9. Import and release a 22/23 DADA FA
    # 10. 22/23 should identify intent as 'New Amendment' and link to 20/21 Master
    # 11. Check docs
    # 12. Publish and approve 22/23 contract
    # 13. CDA
    # 14. Payment batch   
    # 15. Check financials and feed
    # 16. Run Consolidated Payment Summary Report


    Given there are no allocations marked as Under Termination for UKPRN '10017402' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017402'
    And   there is no Funding Allocation data in CRM for UKPRN '10017402'
    And   there are no terminated or closed allocations for UKPRN '10017402' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017402' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017402' 

    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017402' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017402' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017402' in the Sharepoint 'DADA-2122-Input-Appendices' folder
    And   there are no files prefixed '10017402' in the Sharepoint 'DADA-2223-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-402      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-402      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |
    | DADA2122          |
    | DADA2223          |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 2207010        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-402      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017402'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017402' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017402 Co Ltd' with UKPRN '10017402' and OrgId 'ORG0017402' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017402' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017402 | 117402 | 10017402 Co Ltd | 0              | Locked Restructure    | Yes           | AA017402      | ?             | 139 High Street        | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017402 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-402'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-402'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017402 | 10017402 Co Ltd      | ESFA-402             | DADAS-402      | 1                     | 01/08/2020        | 31/07/2021      | 2135.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017402 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017402 | DADAS-402      | DADA-402      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 2135.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017402 | DADAS-402      | DADA-402      | 1               | 0                     | 2135.00   | 1411.00   | 724.00    | 0.00     | 1411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 724.00   | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'
   
    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | DADAS-402      | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-402'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-402' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-402' and actual ContractNumber 'DADAS-402'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-402' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017402 | DADAS-402          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017402 | ESFA-402           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'DADAS-402' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'DADAS-402'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | DADA-402        | 2207010          | Jul-21 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017402 | DADAS-402      | 1               | DADA-402      | 1               | 0                     | 2135.00      | 0             | 0        | Dance and Drama Awards Scheme                                   | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'DADAS-402' agree with the most recent entry for this contract in the ContractManagement feed





    # Create the 2122 DADA contract

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017402 | DADA-AY-2122-Contract-Provider-10017402-2_1           | 2_1            | DADA                        | AY-2122            | 16654.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017402-2_1  | 2_1                    | DADA-AY-2122-Contract-Provider-10017402-2_1           | 10017402      | Furth        | 07HEP           | 16654.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017402-2_1  | DADA-001        | 16654.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017402-2_1  | DADA-001        | FY-2122              | August                 | 2021              | 1000.00                   |
    | DADA-AY-2122-10017402-2_1  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017402-2_1  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017402-2_1  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017402-2_1  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
 
 
 
 
 
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
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017402 | 10017402 Co Ltd  | DADA-AY-2122-Contract-Provider-10017402-2_1             | 2_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 16654.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017402-2_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 16654.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017402 | DADA-AY-2122-Contract-Provider-10017402-2_1             | 2_1            | AY-2122 | DADA                        | 16654.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS = [CfS]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 16654.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017402' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017402' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017402 | 10017402 Co Ltd  | DADA-AY-2122-Contract-Provider-10017402-2_1             | 2_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 16654.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017402-2_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | DADA-AY-2122-Contract-Provider-10017402-2_1             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017402-2_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017402 | DADA-AY-2122-Contract-Provider-10017402-2_1             | 2_1            | AY-2122 | DADA                        | 16654.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017402-2_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM (21/22 contract shares Master Contract Number with 20/21 contract)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017402 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017402 | ESFA-402           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017402 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 16654.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-402           | AY2122 | ?               | 10017402 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017402 | ESFA-402           | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017402 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017402 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 16654.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 16654.00  | 1000.00  | 5439.00  | 0.00     | 3088.00  | 0.00     | 0.00     | 3200.00  | 0.00     | 0.00     | 0.00     | 3927.00  | 0.00     | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017402_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING
    Organisation Name: 10017402 Co Ltd UKPRN: 10017402
    Master Contract Number: ESFA-402
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    Dance and Drama Awards (DaDA) DADA-402 £1,411 £724 £2,135 
    Total: £2,135 
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £12,727 £3,927 £16,654
    Total: £16,654
    Total Funding for this contract: £18,789
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2020 to 31 July 2023
    Between the Secretary of State for Education
    And 10017402 Co Ltd
    Funding for Dance and Drama Awards (DaDA)
    Master Contract Number ESFA-402
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    DaDA Version 2 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017402 Co Ltd THE SECRETARY OF STATE FOR
    139 High Street EDUCATION
    Beckenham DEPARTMENT FOR EDUCATION
    Kent 20 GREAT SMITH STREET
    AND
    BR3 1AG LONDON
    SW1P 3BT
    Company No: AA017402
    Hereinafter called Hereinafter called
    the Contractor the Department
    DaDA Version 2 (April 2022) Page 2
    DaDA Version 2 (April 2022) Page 77
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    DANCE AND DRAMA AWARDS (DaDA) SPECIFICATION
    DaDA Schedule 1 Version 1 (July 2021) – Page 1
    DaDA Schedule 1 Version 1 (July 2021) – Page 4
    SCHEDULE 1: ANNEX 1
    DaDA Schedule 1 – Annex 1 Version 1 (July 2021) – Page 1
    DaDA Schedule 1 – Annex 1 Version 1 (July 2021) – Page 47
    
    SCHEDULE 2: PAYMENT
    DANCE AND DRAMA AWARDS (DaDA) PAYMENT
    DaDA Schedule 2 Version 1 (July 2021) – Page 1
    
    SCHEDULE 2
    Funding Agreement
    Provider: 10017402 Co Ltd UKPRN: 10017402
    Master Contract Number: ESFA-402 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_DADA]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Dance and Drama Awards (DaDA) £16,654 £1,000 £5,439 £0 £3,088 £0 £0 £3,200 £0 £0 £0 £3,927 £0
    Total Funding £16,654 £1,000 £5,439 £0 £3,088 £0 £0 £3,200 £0 £0 £0 £3,927 £0
    Schedule 2 – Funding Agreement [AllocRef_DADA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    DaDA Schedule 3 Version 1 (July 2021) – Page 1
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017402_[ContractNo]_v1.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A402.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-08 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017402'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017402 - 10017402 Co Ltd Awaiting documentation  | [AllocRef_DADA] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017402 | ESFA-402           | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017402 | ESFA-402           | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017402 | ESFA-402           | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '11/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Approve the contract

    # Change the date 
    Given the override date is '14/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-402' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017402 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017402 | ESFA-402           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_DADA] | 2207010          | Jul-22 | Profile        |    
       
    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017402 | 10017402 Co Ltd  | DADA-AY-2122-Contract-Provider-10017402-2_1             | 2_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved | 16654.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017402 | DADA-AY-2122-Contract-Provider-10017402-2_1             | 2_1            | AY-2122 | DADA                        | 16654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017402-2_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017402 | [ContractNo]   | 1               | [AllocRef_DADA]  | 1               | 0                     | 16654.00     | 0             | 0        | Dance and Drama Awards Scheme                  | ?                           |



    # Check the PROFILE PAYMENTS in CRM 
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | 
    | [ContractNo]   | [AllocRef_DADA]    | 1               | 16654.00  | 1000.00  | 5439.00  | 0.00     | 3088.00  | 0.00     | 0.00     | 3200.00  | 0.00     | 0.00     | 0.00     | 3927.00  | 0.00     | 

    # Check the PROFILE subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202108               | PROFILE         | CM             | False       | 1000.00         |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202109               | PROFILE         | CM             | False       | 5439.00         |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202110               | PROFILE         | CM             | False       | 0.00            |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202111               | PROFILE         | CM             | False       | 3088.00         |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202112               | PROFILE         | CM             | False       | 0.00            |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202201               | PROFILE         | CM             | False       | 0.00            |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202202               | PROFILE         | CM             | False       | 3200.00         |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202203               | PROFILE         | CM             | False       | 0.00            |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202204               | PROFILE         | CM             | False       | 0.00            |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202205               | PROFILE         | CM             | False       | 0.00            |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202206               | PROFILE         | CM             | False       | 3927.00         |
    | 10017402 | ORG0017402 | [AllocRef_DADA]   | 2207010         | DADA2122                   | 202207               | PROFILE         | CM             | False       | 0.00            |





#    #CDA
#    
#    # Change the date
#    Given the override date is '16/07/2021'
#
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version A402.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | DADA2122              | Latest Version        | A402   |
#
#    Then  a report named 'CDA Latest Version A402.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription      | Deliverable                        | DeliverableParent      | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 8                 | 2021            | 2021/22       |              | 1000         |              |               |              | Yes                | 1000.00        | 0.00             | 0.00                  | 0.00           | 1000.00         |             | No            |                   |        | 2207010           |                          |                   | Aug              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 9                 | 2021            | 2021/22       |              | 5439         |              |               |              | Yes                | 5439.00        |                  | 0.00                  | 0.00           | 5439.00         |             | No            |                   |        | 2207010           |                          |                   | Sep              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 10                | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Oct              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 11                | 2021            | 2021/22       |              | 3088         |              |               |              | Yes                | 3088.00        |                  | 0.00                  | 0.00           | 3088.00         |             | No            |                   |        | 2207010           |                          |                   | Nov              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 12                | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Dec              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 1                 | 2022            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Jan              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 2                 | 2022            | 2021/22       |              | 3200         |              |               |              | Yes                | 3200.00        |                  | 0.00                  | 0.00           | 3200.00         |             | No            |                   |        | 2207010           |                          |                   | Feb              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 3                 | 2022            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Mar              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 4                 | 2022            | 2022/23       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Apr              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 5                 | 2022            | 2022/23       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | May              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 6                 | 2022            | 2022/23       |              | 3927         |              |               |              | Yes                | 3927.00        |                  | 0.00                  | 0.00           | 3927.00         |             | No            |                   |        | 2207010           |                          |                   | Jun              |
#    | DADA2122                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                             | Dance and Drama Awards Scheme      |                        | 7                 | 2022            | 2022/23       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Jul              |





    # Payment Batch for DADA2122 (PoP)

    # Change the date
    Given the override date is '05/08/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'DADA2122' AccountingPaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_DADA]          | 202108 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | DADA2122                   | 202108               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | DADA2122                   | 202108               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'DADA2122' PaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A402.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'DADA2122' PaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef   | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | DADA                   | 2021          | 05             | 05          | ?       | [AllocRef_DADA] | 1000.00         | PROFILE          | Dance & Drama Awards               | 2021-08-25 | 2021-08-01   | 2022-07-31 | ?              | 10017402 | 2207010    |





    # Start of 22/23 test (36304)

    # Change the date
    Given the override date is '01/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2223        | DADA2223     | Contract for Services                   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table





    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '02/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017402 | DADA-AY-2223-Contract-Provider-10017402-1_0           | 1_0            | DADA                        | AY-2223            | 22361.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2223-10017402-1_0  | 1_0                    | DADA-AY-2223-Contract-Provider-10017402-1_0           | 10017402      | Furth        | 07HEP           | 22361.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2223-10017402-1_0  | DADA-001        | 22361.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2223-10017402-1_0  | DADA-001        | FY-2223              | October                | 2022              | 3162.00                   |
    | DADA-AY-2223-10017402-1_0  | DADA-001        | FY-2223              | January                | 2023              | 4881.00                   |
    | DADA-AY-2223-10017402-1_0  | DADA-001        | FY-2223              | February               | 2023              | 5848.00                   |
    | DADA-AY-2223-10017402-1_0  | DADA-001        | FY-2223              | April                  | 2023              | 2948.00                   |
    | DADA-AY-2223-10017402-1_0  | DADA-001        | FY-2223              | June                   | 2023              | 5522.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2223        | DADA2223     | Contract for Services                   | CfS2                      |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS2 = [CfS2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017402 | 10017402 Co Ltd  | DADA-AY-2223-Contract-Provider-10017402-1_0             | 1_0            | Dance and Drama Awards     | AY2223  | Contract for Services                    | DADA                        | DADA2223        | Scheduling        | Awaiting Release  | 22361.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS2]            | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2223-Contract-Provider-10017402-1_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 22361.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017402 | DADA-AY-2223-Contract-Provider-10017402-1_0             | 1_0            | AY-2223 | DADA                        | 22361.00    | [CfS2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '04/07/2022'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS2]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS2 = [CfS2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 22361.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017402' for FundingType 'DADA' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017402' for FundingType 'DADA' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017402 | 10017402 Co Ltd  | DADA-AY-2223-Contract-Provider-10017402-1_0             | 1_0            | Dance and Drama Awards     | AY2223  | Contract for Services                    | DADA                        | DADA2223        | Released          | Released          | 22361.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS2]          | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2223-Contract-Provider-10017402-1_0             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2223-Contract-Provider-10017402-1_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017402 | DADA-AY-2223-Contract-Provider-10017402-1_0             | 1_0            | AY-2223 | DADA                        | 22361.00    | [CfS2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2223-Contract-Provider-10017402-1_0             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017402 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017402 | ESFA-402           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017402 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 22361.00      | 1                     | 0                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-402           | AY2223 | ?               | 10017402 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017402 | ESFA-402           | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017402 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017402 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 22361.00        | ?             | ?                | 01/08/2022 | 31/07/2023 | DADA          | DADA2223            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                  | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 22361.00  | 0.00     | 0.00     | 3162.00  | 0.00     | 0.00     | 4881.00  | 5848.00  | 0.00     | 2948.00  | 0.00     | 5522.00  | 0.00     | Dance and Drama Awards Scheme    |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017402_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017402 Co Ltd UKPRN: 10017402
    Master Contract Number: ESFA-402
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    Dance and Drama Awards (DaDA) DADA-402 £1,411 £724 £2,135
    Total: £2,135
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Total: £16,654
    Allocation
    1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £13,891 £8,470 £22,361
    Total: £22,361
    Total Funding for this contract: £41,150
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2020 to 31 July 2023
    Between the Secretary of State for Education
    And 10017402 Co Ltd
    Funding for Dance and Drama Awards (DaDA)
    Master Contract Number ESFA-402
    ACCEPTANCE BY THE CONTRACTOR
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    DaDA Version 1 (July 2022) Page 1
    10017402 Co Ltd THE SECRETARY OF STATE FOR
    139 High Street EDUCATION
    Beckenham DEPARTMENT FOR EDUCATION
    Kent 20 GREAT SMITH STREET
    AND
    BR3 1AG LONDON
    SW1P 3BT
    Company No: AA017402
    Hereinafter called Hereinafter called
    the Contractor the Department
    DaDA Version 1 (July 2022) Page 2
    1.4 Precedence of Documentation
    In the event of any inconsistency between the provisions of the Terms
    and Conditions and the Schedules, or between any of the Schedules,
    the conflict will be resolved according to the following descending order
    of priority:
    1.4.1 the Terms and Conditions,
    1.4.2 Schedule 1 (the Specification);
    1.4.3 the remaining Schedules,
    for the avoidance of doubt, in the event of any inconsistency between
    this Contract and the Funding Rules, this Contract will take precedence.
    1.5 In relation to any provision in the Contract, the Secretary of State may
    act through the Department for Education and / or its executive agency,
    ESFA. As such where the Contract refers to the Department, both the
    Department for Education and the ESFA are entitled to act in
    accordance with; and / or benefit from; and / or enforce the relevant
    provision.
    1.6 Without prejudice to the position set out in Clause 1.5 the Department for
    Education will principally manage provider registers, the relationship with
    the Contractor and any intervention. The ESFA will principally be
    responsible for allocations, payments, Contract administration and
    assurance.
    DaDA Version 1 (July 2022) Page 77
        
    SCHEDULE 1: SPECIFICATION & MONITORING
    DaDA Schedule 1 Version 1 (July 2022) – Page 1
    DaDA Schedule 1 Version 1 (July 2022) – Page 4
    DaDA Schedule 1 – Annex 1 Version 1 (July 2022) – Page 1
    DaDA Schedule 1 – Annex 1 Version 1 (July 2022) – Page 47
    
    SCHEDULE 2: PAYMENT
    DANCE AND DRAMA AWARDS (DaDA) PAYMENT
    DaDA Schedule 2 Version 1 (July 2022) – Page 1
    
    SCHEDULE 2
    Funding Agreement
    Provider: 10017402 Co Ltd UKPRN: 10017402
    Master Contract Number: ESFA-402 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_DADA]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Dance and Drama Awards (DaDA) £22,361 £0 £0 £3,162 £0 £0 £4,881 £5,848 £0 £2,948 £0 £5,522 £0
    Total Funding £22,361 £0 £0 £3,162 £0 £0 £4,881 £5,848 £0 £2,948 £0 £5,522 £0
    Schedule 2 – Funding Agreement [AllocRef_DADA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    DaDA Schedule 3 Version 1 (July 2022) – Page 1
    DaDA Schedule 10 Version 1 (July 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017402_[ContractNo]_v1.pdf' in 'DADA-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A402a.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017402'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017402 - 10017402 Co Ltd Awaiting documentation  | [AllocRef_DADA] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017402 | ESFA-402           | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017402 | ESFA-402           | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017402 | ESFA-402           | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '05/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017402_[ContractNo]_v1.pdf' is created in 'DADA-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master 'ESFA-402' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017402 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017402 | ESFA-402           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '06/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-402' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017402 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017402 | ESFA-402           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_DADA] | 2207010          | Jul-23 | Profile        |    

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017402 | 10017402 Co Ltd  | DADA-AY-2223-Contract-Provider-10017402-1_0             | 1_0            | Dance and Drama Awards     | AY2223  | Contract for Services                    | DADA                        | DADA2223        | Contract Approved | Contract Approved | 22361.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS2]          | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017402 | DADA-AY-2223-Contract-Provider-10017402-1_0             | 1_0            | AY-2223 | DADA                        | 22361.00    | [CfS2]          | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2223-Contract-Provider-10017402-1_0             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017402 | [ContractNo]   | 1               | [AllocRef_DADA]  | 1               | 0                     | 22361.00     | 0             | 0        | Dance and Drama Awards Scheme                  | ?                           |





#    # CDA
#    
#    # Change the date
#    Given the override date is '08/07/2022'
#
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version A402a.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version                | Suffix |
#    | DADA2223              | Last Approved Version  | A402a  |
#
#    Then  a report named 'CDA Last Approved Version A402a.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 8                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Aug              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 9                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Sep              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 10                | 2022            | 2022/23       |              | 3162         |              | 0             |              | Yes                | 3162.00        |                  | 0.00                  | 0.00           | 3162.00         |             | No            |                   |        | 2207010           |                          |                   | Oct              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 11                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Nov              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 12                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Dec              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 1                 | 2023            | 2022/23       |              | 4881         |              | 0             |              | Yes                | 4881.00        |                  | 0.00                  | 0.00           | 4881.00         |             | No            |                   |        | 2207010           |                          |                   | Jan              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 2                 | 2023            | 2022/23       |              | 5848         |              | 0             |              | Yes                | 5848.00        |                  | 0.00                  | 0.00           | 5848.00         |             | No            |                   |        | 2207010           |                          |                   | Feb              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 3                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Mar              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 4                 | 2023            | 2023/24       |              | 2948         |              | 0             |              | Yes                | 2948.00        |                  | 0.00                  | 0.00           | 2948.00         |             | No            |                   |        | 2207010           |                          |                   | Apr              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 5                 | 2023            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | May              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 6                 | 2023            | 2023/24       |              | 5522         |              | 0             |              | Yes                | 5522.00        |                  | 0.00                  | 0.00           | 5522.00         |             | No            |                   |        | 2207010           |                          |                   | Jun              |
#    | DADA2223                | 10017402 | 10017402 Co Ltd             |               |                             | [AllocRef_DADA]          | [ContractNo]   | ESFA-402                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 7                 | 2023            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Jul              |





    # Payment Batch for DADA2223 (PoP)

    # Change the date
    Given the override date is '04/10/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'DADA2223' AccountingPaymentPeriod '202207' CensusEndDate '04/10/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_DADA]          | 202210 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | DADA2223                   | 202210               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | DADA2223                   | 202210               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'DADA2223' PaymentPeriod '202207' CensusEndDate '04/10/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A402a.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'DADA2223' PaymentPeriod '202207' CensusEndDate '04/10/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef   | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | DADA                   | 2022          | 07             | 04          | ?       | [AllocRef_DADA] | 3162.00         | PROFILE          | Dance & Drama Awards               | 2022-10-18 | 2022-08-01   | 2023-07-31 | ?              | 10017402 | 2207010    |





    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_DADA]    | 1               | 22361.00  | 13891.00 | 8470.00  | 0.00     | 0.00     | 3162.00  | 0.00     | 0.00     | 4881.00  | 5848.00  | 0.00     | 2948.00  | 0.00     | 5522.00  | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_DADA]    | 1               | 22361.00  | 0.00     | 0.00     | 3162.00  | 0.00     | 0.00     | 4881.00  | 5848.00  | 0.00     | 2948.00  | 0.00     | 5522.00  | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_DADA]    | 1               | 22361.00  | 0.00     | 0.00     | 3162.00  | 0.00     | 0.00     | 4881.00  | 5848.00  | 0.00     | 2948.00  | 0.00     | 5522.00  | 0.00     | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber  | AllocationRef     | ProfileSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
    | 10017402 | [ContractNo]    | [AllocRef_DADA]   | 2207010           | 0.00      | 0.00      | 3162.00   | 0.00      | 0.00      | 4881.00   | 5848.00   | 0.00      | 2948.00   | 0.00      | 5522.00   | 0.00      | 





    # Consolidated Payment Summary Report
    
    # Set the override date, run the report and save output in Sharepoint (30759) (J050)
    When a Consolidated Payment Summary Report is created in Sharepoint for '12/10/2022'
    # Check the above report manually


    # Tidy Up
 #  Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
   
@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A403 Import and release a 2122 DADA FA. Import and park a second FA. Delete contract. Withdraw first FA. Release RG2. Publish and approve. Check docs, CRM, PaaS and feed

    # 1. Import and release a 21/22 DADA Funding Allocation
    # 2. Import and release a second 21/22 Funding Allocation for the same UKPRN (Update Draft)
    # 3. FA2 is parked awaiting outcome 
    # 4. Delete 21/22 contract
    # 5. Withdraw FA1
    # 6. Release RG2
    # 7. Check docs
    # 8. Publish and approve
    # 9. Check CRM and PaaS

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017403'
    And   there is no Funding Allocation data in CRM for UKPRN '10017403'
    And   there is no Contract, Task or Workflow data for UKPRN '10017403'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017403'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017403'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017403' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017403' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017403 Co Ltd' with UKPRN '10017403' and OrgId 'ORG0017403' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017403' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017403 | 117403 | 10017403 Co Ltd | 0              | Active                | Yes           | AA017403      | ?             | 51 Stephens House      | Bank Court             | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1DH   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017403 |






    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017403 | DADA-AY-2122-Contract-Provider-10017403-4_5           | 4_5            | DADA                        | AY-2122            | 21900.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017403-4_5  | 4_5                    | DADA-AY-2122-Contract-Provider-10017403-4_5           | 10017403      | Furth        | 07HEP           | 21900.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017403-4_5  | DADA-001        | 21900.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017403-4_5  | DADA-001        | FY-2122              | September              | 2021              | 4383.00                   |
    | DADA-AY-2122-10017403-4_5  | DADA-001        | FY-2122              | January                | 2022              | 5452.00                   |
    | DADA-AY-2122-10017403-4_5  | DADA-001        | FY-2122              | February               | 2022              | 2246.00                   |
    | DADA-AY-2122-10017403-4_5  | DADA-001        | FY-2122              | April                  | 2022              | 4923.00                   |
    | DADA-AY-2122-10017403-4_5  | DADA-001        | FY-2122              | July                   | 2022              | 4896.00                   |
 
 
 
 
 
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
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017403 | 10017403 Co Ltd  | DADA-AY-2122-Contract-Provider-10017403-4_5             | 4_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 21900.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017403-4_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 21900.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017403 | DADA-AY-2122-Contract-Provider-10017403-4_5             | 4_5            | AY-2122 | DADA                        | 21900.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS = [CfS]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 21900.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017403' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017403' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017403 | 10017403 Co Ltd  | DADA-AY-2122-Contract-Provider-10017403-4_5             | 4_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 21900.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017403-4_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | DADA-AY-2122-Contract-Provider-10017403-4_5             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017403-4_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017403 | DADA-AY-2122-Contract-Provider-10017403-4_5             | 4_5            | AY-2122 | DADA                        | 21900.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017403-4_5             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017403 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017403 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017403 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 21900.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017403 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017403 | [MasterContractNo] | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017403 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017403 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 21900.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 21900.00  | 0.00     | 4383.00  | 0.00     | 0.00     | 0.00     | 5452.00  | 2246.00  | 0.00     | 4923.00  | 0.00     | 0.00     | 4896.00  | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017403 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation  | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017403 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |




       
    # Populate the stub with DADA (07HEP) data again (Intent should be Update Draft)

    Given the override date is '10/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017403 | DADA-AY-2122-Contract-Provider-10017403-5_0           | 5_0            | DADA                        | AY-2122            | 12191.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017403-5_0  | 5_0                    | DADA-AY-2122-Contract-Provider-10017403-5_0           | 10017403      | Furth        | 07HEP           | 12191.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017403-5_0  | DADA-001        | 12191.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017403-5_0  | DADA-001        | FY-2122              | November               | 2021              | 3200.00                   |
    | DADA-AY-2122-10017403-5_0  | DADA-001        | FY-2122              | January                | 2022              | 4610.00                   |
    | DADA-AY-2122-10017403-5_0  | DADA-001        | FY-2122              | June                   | 2022              | 4381.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '12/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

   # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017403 | 10017403 Co Ltd  | DADA-AY-2122-Contract-Provider-10017403-4_5             | 4_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 21900.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017403-4_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | DADA-AY-2122-Contract-Provider-10017403-4_5             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017403-4_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017403 | DADA-AY-2122-Contract-Provider-10017403-5_0             | 5_0            | AY-2122 | DADA                        | 12191.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017403 | DADA-AY-2122-Contract-Provider-10017403-4_5             | 4_5            | AY-2122 | DADA                        | 21900.00    | [CfS]           | ?                 | ?                                 |





    # Delete contract and set the FA to 'Return to Scheduling'

    # Change the date 
    Given the override date is '14/07/2021'

    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
   #When  a request is initiated in CRM to delete the following contracts
    When User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017403 | [ContractNo]   | 1                     | 0                  |

    Then  wait '10' seconds


     


    # Withdraw a Funding Allocation from Contract Control (33032)
    
    # Change the date 
    Given the override date is '16/07/2021'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Contracting query'
    | FundingId                                               |
    | DADA-AY-2122-Contract-Provider-10017403-4_5             |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS2                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017403 | 10017403 Co Ltd  | DADA-AY-2122-Contract-Provider-10017403-5_0             | 5_0            | Dance and Drama Awards       | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling         | Awaiting Release        | 12191.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS2]          |
    | 10017403 | 10017403 Co Ltd  | DADA-AY-2122-Contract-Provider-10017403-4_5             | 4_5            | Dance and Drama Awards       | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Withdrawn          | Withdrawn               | 21900.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '18/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS2]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS2 = [CfS2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 12191.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017403' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017403' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017403 | 10017403 Co Ltd  | DADA-AY-2122-Contract-Provider-10017403-5_0             | 5_0            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 12191.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS2]          |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017403-5_0             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | DADA-AY-2122-Contract-Provider-10017403-5_0             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017403-5_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017403 | DADA-AY-2122-Contract-Provider-10017403-5_0             | 5_0            | AY-2122 | DADA                        | 12191.00    | [CfS2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017403-5_0             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017403 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017403 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017403 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 12191.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017403 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017403 | [MasterContractNo] | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017403 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017403 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 12191.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 12191.00  | 0.00     | 0.00     | 0.00     | 3200.00  | 0.00     | 4610.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4381.00  | 0.00     | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017403_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017403 Co Ltd UKPRN: 10017403
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £7,810 £4,381 £12,191
    Total: £12,191
    Total Funding for this contract: £12,191
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2020 to 31 July 2023
    Between the Secretary of State for Education
    And 10017403 Co Ltd
    Funding for Dance and Drama Awards (DaDA)
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    DaDA Version 2 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017403 Co Ltd THE SECRETARY OF STATE FOR
    51 Stephens House EDUCATION
    Bank Court DEPARTMENT FOR EDUCATION
    Hemel Hempstead 20 GREAT SMITH STREET
    AND
    Hertfordshire LONDON
    HP1 1DH SW1P 3BT
    Company No: AA017403
    Hereinafter called Hereinafter called
    the Contractor the Department
    DaDA Version 2 (April 2022) Page 2
    DaDA Version 2 (April 2022) Page 77
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    DANCE AND DRAMA AWARDS (DaDA) SPECIFICATION
    DaDA Schedule 1 Version 1 (July 2021) – Page 1
    
    SCHEDULE 2: PAYMENT
    DANCE AND DRAMA AWARDS (DaDA) PAYMENT
    DaDA Schedule 2 Version 1 (July 2021) – Page 1
    
    SCHEDULE 2
    Funding Agreement
    Provider: 10017403 Co Ltd UKPRN: 10017403
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_DADA]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Dance and Drama Awards (DaDA) £12,191 £0 £0 £0 £3,200 £0 £4,610 £0 £0 £0 £0 £4,381 £0
    Total Funding £12,191 £0 £0 £0 £3,200 £0 £4,610 £0 £0 £0 £0 £4,381 £0
    Schedule 2 – Funding Agreement [AllocRef_DADA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    DaDA Schedule 3 Version 1 (July 2021) – Page 1
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017403_[ContractNo]_v1.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A403.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017403'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017403 - 10017403 Co Ltd Awaiting documentation  | [AllocRef_DADA] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017403 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017403 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017403 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '20/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Approve the contract

    # Change the date 
    Given the override date is '22/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017403 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017403 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017403 | 10017403 Co Ltd  | DADA-AY-2122-Contract-Provider-10017403-5_0             | 5_0            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved | 12191.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS2]          |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017403 | DADA-AY-2122-Contract-Provider-10017403-5_0             | 5_0            | AY-2122 | DADA                        | 12191.00    | [CfS2]          | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017403-5_0             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017403 | [ContractNo]   | 1               | [AllocRef_DADA]  | 1               | 0                     | 12191.00     | 0             | 0        | Dance and Drama Awards Scheme                  | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A404 Create and approve a 20/21 DADA. Import, release and approve a 21/22 DADA FA. NFA against 21/22 DADA contract. Import and release updated 21/22 DADA FA. Check docs.

    # 1. Create and approve a 20/21 DADA contract
    # 2. Import, release and approve a 21/22 DADA FA and link to 20/21 by Master
    # 3. NFA against 21/22 contract to create draft v2.0
    # 4. Import and release an updated 21/22 DADA FA  
    # 5. Check docs
    
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017404'
    And   there is no Funding Allocation data in CRM for UKPRN '10017404'
    And   there are no allocations marked as Under Termination for UKPRN '10017404' 
    And   there are no terminated or closed allocations for UKPRN '10017404' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017404' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017404' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017404' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017404' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017404' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-404      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-404      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-404      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017404'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017404' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017404 Co Ltd' with UKPRN '10017404' and OrgId 'ORG0017404' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017404' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017404 | 117404 | 10017404 Co Ltd | 0              | Active                | Yes           | AA017404      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017404 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-404'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-404'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017404 | 10017404 Co Ltd      | ESFA-404             | DADAS-404      | 1                     | 01/08/2020        | 31/07/2021      | 3460.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017404 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017404 | DADAS-404      | DADA-404      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 3460.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017404 | DADAS-404      | DADA-404      | 1               | 0                     | 3460.00   | 223.00    | 3237.00   | 0.00     | 223.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3237.00  | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | DADAS-404      | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-404'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-404' and actual ContractNumber 'DADAS-404'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-404' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017404 | DADAS-404          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017404 | ESFA-404           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017404 | DADA-AY-2122-Contract-Provider-10017404-4_7           | 4_7            | DADA                        | AY-2122            | 13195.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017404-4_7  | 4_7                    | DADA-AY-2122-Contract-Provider-10017404-4_7           | 10017404      | Furth        | 07HEP           | 13195.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017404-4_7  | DADA-001        | 13195.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017404-4_7  | DADA-001        | FY-2122              | November               | 2021              | 5597.00                   |
    | DADA-AY-2122-10017404-4_7  | DADA-001        | FY-2122              | January                | 2022              | 3316.00                   |
    | DADA-AY-2122-10017404-4_7  | DADA-001        | FY-2122              | May                    | 2022              | 4282.00                   |
 
 
 
 
 
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
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017404 | 10017404 Co Ltd  | DADA-AY-2122-Contract-Provider-10017404-4_7             | 4_7            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 13195.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017404-4_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 13195.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017404 | DADA-AY-2122-Contract-Provider-10017404-4_7             | 4_7            | AY-2122 | DADA                        | 13195.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS = [CfS]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 13195.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017404' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017404' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017404 | 10017404 Co Ltd  | DADA-AY-2122-Contract-Provider-10017404-4_7             | 4_7            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 13195.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017404 | DADA-AY-2122-Contract-Provider-10017404-4_7             | 4_7            | AY-2122 | DADA                        | 13195.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017404-4_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017404 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017404 | ESFA-404           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017404 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 13195.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017404 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017404 | ESFA-404           | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017404 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017404 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 13195.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 13195.00  | 0.00     | 0.00     | 0.00     | 5597.00  | 0.00     | 3316.00  | 0.00     | 0.00     | 0.00     | 4282.00  | 0.00     | 0.00     | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017404_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017404 Co Ltd UKPRN: 10017404
    Master Contract Number: ESFA-404
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    Dance and Drama Awards (DaDA) DADA-404 £223 £3,237 £3,460
    Total: £3,460
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £8,913 £4,282 £13,195
    Total: £13,195
    Total Funding for this contract: £16,655
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2020 to 31 July 2023
    Between the Secretary of State for Education
    And 10017404 Co Ltd
    Funding for Dance and Drama Awards (DaDA)
    Master Contract Number ESFA-404
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    DaDA Version 2 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017404 Co Ltd THE SECRETARY OF STATE FOR
    9 Kneesworth Street EDUCATION
    Royston DEPARTMENT FOR EDUCATION
    Hertfordshire 20 GREAT SMITH STREET
    AND
    SG8 5AA LONDON
    SW1P 3BT
    Company No: AA017404
    Hereinafter called Hereinafter called
    the Contractor the Department
    DaDA Version 2 (April 2022) Page 2
    DaDA Version 2 (April 2022) Page 77

    SCHEDULE 1: SPECIFICATION & MONITORING
    DANCE AND DRAMA AWARDS (DaDA) SPECIFICATION
    DaDA Schedule 1 Version 1 (July 2021) – Page 1
    DaDA Schedule 1 – Annex 1 Version 1 (July 2021) – Page 47

    SCHEDULE 2: PAYMENT
    DANCE AND DRAMA AWARDS (DaDA) PAYMENT
    DaDA Schedule 2 Version 1 (July 2021) – Page 1

    SCHEDULE 2
    Funding Agreement
    Provider: 10017404 Co Ltd UKPRN: 10017404
    Master Contract Number: ESFA-404 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_DADA]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Dance and Drama Awards (DaDA) £13,195 £0 £0 £0 £5,597 £0 £3,316 £0 £0 £0 £4,282 £0 £0
    Total Funding £13,195 £0 £0 £0 £5,597 £0 £3,316 £0 £0 £0 £4,282 £0 £0
    Schedule 2 – Funding Agreement [AllocRef_DADA] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    DaDA Schedule 3 Version 1 (July 2021) – Page 1
    DaDA Schedule 10 Version 1 (July 2021) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017404_[ContractNo]_v1.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A404.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-08 09:12:35.000 |






    # Publish the contract

    # Change the date 
    Given the override date is '11/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Approve the contract

    # Change the date 
    Given the override date is '14/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017404 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017404 | ESFA-404           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017404 | 10017404 Co Ltd  | DADA-AY-2122-Contract-Provider-10017404-4_7             | 4_7            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved | 13195.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017404 | DADA-AY-2122-Contract-Provider-10017404-4_7             | 4_7            | AY-2122 | DADA                        | 13195.00    | [CfS]           | ContractApproved  | ContractApproved                  |





    # Execute a NON-FINANCIAL amendment to create a draft v2

    # Change the date
    Given the override date is '16/07/2021'

    # Issue a non-financial VARIATION amendment on v3 to create v4
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017404 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation  | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017404 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017404 | ESFA-404           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '22/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017404 | DADA-AY-2122-Contract-Provider-10017404-5_1           | 5_1            | DADA                        | AY-2122            | 12723.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017404-5_1  | 5_1                    | DADA-AY-2122-Contract-Provider-10017404-5_1           | 10017404      | Furth        | 07HEP           | 12723.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017404-5_1  | DADA-001        | 12723.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017404-5_1  | DADA-001        | FY-2122              | October                | 2021              | 5156.00                   |
    | DADA-AY-2122-10017404-5_1  | DADA-001        | FY-2122              | January                | 2022              | 2838.00                   |
    | DADA-AY-2122-10017404-5_1  | DADA-001        | FY-2122              | June                   | 2022              | 4729.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '25/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS2                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017404 | 10017404 Co Ltd  | DADA-AY-2122-Contract-Provider-10017404-5_1             | 5_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 12723.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS2]            |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017404-5_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 12723.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017404 | DADA-AY-2122-Contract-Provider-10017404-5_1             | 5_1            | AY-2122 | DADA                        | 12723.00    | [CfS2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '28/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS2]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS2 = [CfS2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 12723.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017404' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017404' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017404 | 10017404 Co Ltd  | DADA-AY-2122-Contract-Provider-10017404-5_1             | 5_1            | Dance and Drama Awards       | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released           | Released                | 12723.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS2]          |
    | 10017404 | 10017404 Co Ltd  | DADA-AY-2122-Contract-Provider-10017404-4_7             | 4_7            | Dance and Drama Awards       | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved  | Contract Approved       | 13195.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017404 | DADA-AY-2122-Contract-Provider-10017404-5_1             | 5_1            | AY-2122 | DADA                        | 12723.00    | [CfS2]          | ?                 | ?                                 |
    | 10017404 | DADA-AY-2122-Contract-Provider-10017404-4_7             | 4_7            | AY-2122 | DADA                        | 13195.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017404-5_1             | [ContractNo] | 2               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017404 | [ContractNo]       | 2                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017404 | [ContractNo]       | 2                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017404 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017404 | ESFA-404           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017404 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 12723.00      | 2                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | Variation     | Initiate Document Merge  | Yes                   | ESFA-404           | AY2122 | ?               | 10017404 Co Ltd  | Active | Document Management Team  | -472.00                |
    | 10017404 | ESFA-404           | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017404 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017404 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 12723.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | -472.00                  |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                   | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 12723.00  | 0.00     | 0.00     | 5156.00  | 0.00     | 0.00     | 2838.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4729.00  | 0.00     | Dance and Drama Awards Scheme     |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017404_[ContractNo]_v2.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """  
    SUMMARY OF FUNDING
    Organisation Name: 10017404 Co Ltd UKPRN: 10017404
    Master Contract Number: ESFA-404
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    Dance and Drama Awards (DaDA) DADA-404 £223 £3,237 £3,460
    Total: £3,460
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £7,994 £4,729 £12,723
    Total: £12,723
    Total Funding for this contract: £16,183
    Summary of Funding – Page 1
    
    SCHEDULE 2
    Funding Agreement
    Provider: 10017404 Co Ltd UKPRN: 10017404
    Master Contract Number: ESFA-404 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_DADA]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Dance and Drama Awards (DaDA) £12,723 £0 £0 £5,156 £0 £0 £2,838 £0 £0 £0 £0 £4,729 £0
    Total Funding £12,723 £0 £0 £5,156 £0 £0 £2,838 £0 £0 £0 £0 £4,729 £0
    Schedule 2 – Funding Agreement [AllocRef_DADA] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """
  
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017404_[ContractNo]_v2.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A404.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-07-28 09:12:35.000 |


    # Tidy Up
    Given the override date is reset
        
