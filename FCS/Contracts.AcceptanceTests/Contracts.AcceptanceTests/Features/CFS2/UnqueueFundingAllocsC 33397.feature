Feature: UnqueueFundingAllocsC 33397

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A935 Create and approve DADA2021. Import, release and approve DADA2122. Request Termination Initiation of 2021 and 2122 contracts. Update DADA2122 FA. Reject Termination Initiation of 2122. Unqueue FA. Check CRM and PaaS

    # 1. Create and approve DADA 20/21 contract v1  
    # 2. Import and release DADA 21/22 FA. Approve contract v1  
    # 3. Request termination initiation approval of 20/21 contract  
    # 4. Request termination initiation approval of 21/22 contract  
    # 5. Release an update to the DADA 21/22 FA > queue due to 21/22 contract
    # 6. Reject 21/22 termination initiation request. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    Given there are no allocations marked as Under Termination for UKPRN '10017935' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017935'
    And   there is no Funding Allocation data in CRM for UKPRN '10017935'
    And   there are no terminated or closed allocations for UKPRN '10017935' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017935' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017935' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017935' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017935' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017935' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-935      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-935      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |
    | DADA2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-935      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017935'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017935' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017935 Co Ltd' with UKPRN '10017935' and OrgId 'ORG0017935' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017935' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017935 | 117935 | 10017935 Co Ltd | 0              | Locked Restructure    | Yes           | AA017935      | ?             | 1a Sultan Street       | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017935 |





    # Part 1: Create and approve DADA 20/21 contract v1 
    
    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-935'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-935'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017935 | 10017935 Co Ltd      | ESFA-935             | DADAS-935      | 1                     | 01/08/2020        | 31/07/2021      | 2135.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017935 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017935 | DADAS-935      | DADA-935      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 2135.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017935 | DADAS-935      | DADA-935      | 1               | 0                     | 2135.00   | 1411.00   | 724.00    | 0.00     | 1411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 724.00   | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'DADAS-935' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-935' and actual ContractNumber 'DADAS-935'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-935' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017935 | DADAS-935          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017935 | ESFA-935           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 2: Import and release DADA 21/22 FA. Approve contract v1  

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '06/08/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017935 | DADA-AY-2122-Contract-Provider-10017935-1_5           | 1_5            | DADA                        | AY-2122            | 15654.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017935-1_5  | 1_5                    | DADA-AY-2122-Contract-Provider-10017935-1_5           | 10017935      | Furth        | 07HEP           | 15654.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017935-1_5  | DADA-001        | 15654.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017935-1_5  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017935-1_5  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017935-1_5  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017935-1_5  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
 
 
 
 
 
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
    | 10017935 | 10017935 Co Ltd  | DADA-AY-2122-Contract-Provider-10017935-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 15654.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017935-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15654.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017935 | DADA-AY-2122-Contract-Provider-10017935-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

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
    When  I retrieve the latest contract details from CRM for provider '10017935' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017935 | 10017935 Co Ltd  | DADA-AY-2122-Contract-Provider-10017935-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017935-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017935-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017935 | DADA-AY-2122-Contract-Provider-10017935-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017935 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017935 | DADAS-935          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017935 | ESFA-935           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    
    
    
    
    # Publish and approve 21/22 DADA contract v1

    # Change the date
    Given the override date is '12/08/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-935' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017935 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017935 | DADAS-935          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017935 | ESFA-935           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 3: Request termination initiation approval of 20/21 contract

    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '05/10/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | DADAS-935     | 1               | 0                  | 05/05/2021              | Notice from Agency          | Acquisition in progress             |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | DADA-935           | 03/05/2021                   | 10/05/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017935 | DADAS-935      | 1                     | 0                        | 05/05/2021                 | Notice from Agency           | ?                              | 05/05/2021              | Notice from Agency          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017935 | DADAS-935     | DADA-935         | 1                     | 0                        | 03/05/2021                   | 03/05/2021        | 10/05/2021                      | 10/05/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract 'DADAS-935' for provider '10017935'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017935 - 10017935 Co Ltd     | DADAS-935      | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017935 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017935 | DADAS-935          | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017935 | ESFA-935           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |



 

    # Part 4: Request termination initiation approval of 21/22 contract

    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '06/10/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 1               | 0                  | 06/10/2021              | Notice from Agency          | Acquisition in progress             |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_DADA]    | 03/09/2021                   | 10/09/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017935 | [ContractNo]   | 1                     | 0                        | 06/10/2021                 | Notice from Agency           | ?                              | 06/10/2021              | Notice from Agency          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017935 | [ContractNo]  | [AllocRef_DADA]  | 1                     | 0                        | 03/09/2021                   | 03/09/2021        | 10/09/2021                      | 10/09/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017935'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017935 - 10017935 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017935 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017935 | DADAS-935          | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017935 | ESFA-935           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 5: Release an update to the DADA 21/22 FA > queue due to 21/22 contract

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '07/10/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017935 | DADA-AY-2122-Contract-Provider-10017935-3_1           | 3_1            | DADA                        | AY-2122            | 20000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017935-3_1  | 3_1                    | DADA-AY-2122-Contract-Provider-10017935-3_1           | 10017935      | Furth        | 07HEP           | 20000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017935-3_1  | DADA-001        | 20000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017935-3_1  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017935-3_1  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017935-3_1  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017935-3_1  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
    | DADA-AY-2122-10017935-3_1  | DADA-001        | FY-2122              | July                   | 2022              | 4346.00                   |





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
    | 10017935 | 10017935 Co Ltd  | DADA-AY-2122-Contract-Provider-10017935-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release        | 20000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CfS2]          | ?          | ?                   |
    | 10017935 | 10017935 Co Ltd  | DADA-AY-2122-Contract-Provider-10017935-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |





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
    When  I retrieve the latest contract details from CRM for provider '10017935' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017935 | 10017935 Co Ltd  | DADA-AY-2122-Contract-Provider-10017935-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 11/10/2021 | [ContractNo]        |
    | 10017935 | 10017935 Co Ltd  | DADA-AY-2122-Contract-Provider-10017935-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017935-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017935-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017935-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017935-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017935-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017935 | DADA-AY-2122-Contract-Provider-10017935-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017935 | DADA-AY-2122-Contract-Provider-10017935-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017935 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017935 | DADAS-935          | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017935 | ESFA-935           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 6: Reject 21/22 termination initiation request. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    # Change the date
    Given the override date is '15/10/2021'
    
#   # Manager rejects termination initiation request (23810)
#   When  CRM user 'FCS5 Test' rejects the termination request for Contract '[ContractNo]' Version '1' SubVersion '0' with free-text reason 'Termination requested in error'

    # Reject Termination Initiation using the Next Action step
    When the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Reject Termination Initiation' specifying the reason as 'Test 935'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017935 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017935 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017935 | DADAS-935          | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017935 | ESFA-935           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017935 | 10017935 Co Ltd  | DADA-AY-2122-Contract-Provider-10017935-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 20000.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | ?          | ?                   |
    | 10017935 | 10017935 Co Ltd  | DADA-AY-2122-Contract-Provider-10017935-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017935-3_1             | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | DADA-AY-2122-Contract-Provider-10017935-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017935-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017935-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017935-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017935-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017935 | DADA-AY-2122-Contract-Provider-10017935-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | ?                 | ?                                 |
    | 10017935 | DADA-AY-2122-Contract-Provider-10017935-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017935-3_1             | [ContractNo] | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017935-1_5             | [ContractNo] | 1               | 0                  | Yes            |

 
    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A936 Create and approve DADA2021. Import, release and approve DADA2122. 2021 NFA. Termination Initiation on DADA2122. Update DADA2122 FA. Queue. Reject Termination Initiation of 2122. Delete draft 2021. Unqueue FA. Check CRM and PaaS

    # 1. Create and approve DADA 20/21 contract v1  
    # 2. Import and release DADA 21/22 FA. Approve contract v1  
    # 3. NFA on DADA 20/21 > contract v2
    # 4. Request termination initiation approval of 21/22 contract  
    # 5. Release an update to the DADA 21/22 FA > queue due to 21/22 contract
    # 6. Reject 21/22 termination initiation request. Remain queued, but due to 20/21 contract
    # 7. Delete draft 20/21 contract. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    Given there are no allocations marked as Under Termination for UKPRN '10017936' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017936'
    And   there is no Funding Allocation data in CRM for UKPRN '10017936'
    And   there are no terminated or closed allocations for UKPRN '10017936' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017936' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017936' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017936' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017936' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017936' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-936      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-936      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |
    | DADA2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-936      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017936'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017936' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017936 Co Ltd' with UKPRN '10017936' and OrgId 'ORG0017936' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017936' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017936 | 117936 | 10017936 Co Ltd | 0              | Locked Restructure    | Yes           | AA017936      | ?             | 1a Sultan Street       | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017936 |





    # Part 1: Create and approve DADA 20/21 contract v1 
    
    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-936'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-936'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017936 | 10017936 Co Ltd      | ESFA-936             | DADAS-936      | 1                     | 01/08/2020        | 31/07/2021      | 2135.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017936 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017936 | DADAS-936      | DADA-936      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 2135.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017936 | DADAS-936      | DADA-936      | 1               | 0                     | 2135.00   | 1411.00   | 724.00    | 0.00     | 1411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 724.00   | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'DADAS-936' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-936' and actual ContractNumber 'DADAS-936'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-936' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017936 | DADAS-936          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017936 | ESFA-936           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 2: Import and release DADA 21/22 FA. Approve contract v1  

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '06/08/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017936 | DADA-AY-2122-Contract-Provider-10017936-1_5           | 1_5            | DADA                        | AY-2122            | 15654.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017936-1_5  | 1_5                    | DADA-AY-2122-Contract-Provider-10017936-1_5           | 10017936      | Furth        | 07HEP           | 15654.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017936-1_5  | DADA-001        | 15654.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017936-1_5  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017936-1_5  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017936-1_5  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017936-1_5  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
 
 
 
 
 
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
    | 10017936 | 10017936 Co Ltd  | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 15654.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15654.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017936 | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

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
    When  I retrieve the latest contract details from CRM for provider '10017936' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017936 | 10017936 Co Ltd  | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017936 | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017936 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017936 | DADAS-936          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017936 | ESFA-936           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    
    
    
    
    # Publish and approve 21/22 DADA contract v1

    # Change the date
    Given the override date is '12/08/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-936' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017936 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017936 | DADAS-936          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017936 | ESFA-936           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 3: NFA on DADA 20/21 > contract v2

    # Change the date
    And   the override date is '12/09/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-936' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017936 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017936 | DADAS-936          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017936 | DADAS-936          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017936 | ESFA-936           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 4: Request termination initiation approval of 21/22 contract

    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '06/10/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 1               | 0                  | 06/10/2021              | Notice from Agency          | Acquisition in progress             |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_DADA]    | 03/09/2021                   | 10/09/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017936 | [ContractNo]   | 1                     | 0                        | 06/10/2021                 | Notice from Agency           | ?                              | 06/10/2021              | Notice from Agency          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017936 | [ContractNo]  | [AllocRef_DADA]  | 1                     | 0                        | 03/09/2021                   | 03/09/2021        | 10/09/2021                      | 10/09/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017936'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017936 - 10017936 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017936 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017936 | DADAS-936          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017936 | DADAS-936          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017936 | ESFA-936           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 5: Release an update to the DADA 21/22 FA > queue due to 21/22 contract

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '07/10/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017936 | DADA-AY-2122-Contract-Provider-10017936-3_1           | 3_1            | DADA                        | AY-2122            | 20000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017936-3_1  | 3_1                    | DADA-AY-2122-Contract-Provider-10017936-3_1           | 10017936      | Furth        | 07HEP           | 20000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017936-3_1  | DADA-001        | 20000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017936-3_1  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017936-3_1  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017936-3_1  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017936-3_1  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
    | DADA-AY-2122-10017936-3_1  | DADA-001        | FY-2122              | July                   | 2022              | 4346.00                   |





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
    | 10017936 | 10017936 Co Ltd  | DADA-AY-2122-Contract-Provider-10017936-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release        | 20000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CfS2]          | ?          | ?                   |
    | 10017936 | 10017936 Co Ltd  | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |





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
    When  I retrieve the latest contract details from CRM for provider '10017936' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017936 | 10017936 Co Ltd  | DADA-AY-2122-Contract-Provider-10017936-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 11/10/2021 | [ContractNo]        |
    | 10017936 | 10017936 Co Ltd  | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017936 | DADA-AY-2122-Contract-Provider-10017936-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017936 | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | [ContractNo] | 1               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017936 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017936 | DADAS-936          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017936 | DADAS-936          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017936 | ESFA-936           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 6: Reject 21/22 termination initiation request. Remain queued, but due to 2021 contract

    # Change the date 
    Given the override date is '14/10/2021'

#   # Manager rejects termination initiation request (23810)
#   When  CRM user 'FCS5 Test' rejects the termination request for Contract '[ContractNo]' Version '1' SubVersion '0' with free-text reason 'Termination requested in error'

    # Reject Termination Initiation using the Next Action step
    When the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Reject Termination Initiation' specifying the reason as 'Test 936'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017936 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017936 | DADAS-936          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017936 | DADAS-936          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017936 | ESFA-936           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017936 | 10017936 Co Ltd  | DADA-AY-2122-Contract-Provider-10017936-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 14/10/2021 | DADAS-936           |
    | 10017936 | 10017936 Co Ltd  | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017936 | DADA-AY-2122-Contract-Provider-10017936-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017936 | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | DADAS-936    | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | [ContractNo] | 1               | 0                  | Yes            |





    # Part 7: Delete draft 20/21 contract. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    # Change the date 
    Given the override date is '16/10/2021'

    # Trigger WF28 in CRM to issue a delete request against v2 of contract DADA-936 (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017936 | DADAS-936      | 2                     | 0                  |


    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017936 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017936 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017936 | DADAS-936          | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017936 | ESFA-936           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017936 | 10017936 Co Ltd  | DADA-AY-2122-Contract-Provider-10017936-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 20000.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | ?          | ?                   |
    | 10017936 | 10017936 Co Ltd  | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | In Release     | Queued                          | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017936 | DADA-AY-2122-Contract-Provider-10017936-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | ?                 | ?                                 |
    | 10017936 | DADA-AY-2122-Contract-Provider-10017936-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017936-3_1             | [ContractNo] | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017936-1_5             | [ContractNo] | 1               | 0                  | Yes            |


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A937 Create and approve DADA2021. Import, release and approve DADA2122. 2021 NFA. Termination Initiation on DADA2122. Update DADA2122 FA. Queue. Delete draft 2021. Reject Termination Initiation of 2122. Unqueue FA. Check CRM and PaaS

    # 1. Create and approve DADA 20/21 contract v1  
    # 2. Import and release DADA 21/22 FA. Approve contract v1  
    # 3. NFA on DADA 20/21 > contract v2
    # 4. Request termination initiation approval of 21/22 contract  
    # 5. Release an update to the DADA 21/22 FA > queue due to 21/22 contract
    # 6. Delete draft 20/21 contract. Remain queued, due to 20/21 contract
    # 7. Reject 21/22 termination initiation request. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    Given there are no allocations marked as Under Termination for UKPRN '10017937' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017937'
    And   there is no Funding Allocation data in CRM for UKPRN '10017937'
    And   there are no terminated or closed allocations for UKPRN '10017937' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017937' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017937' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017937' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017937' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed '10017937' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-937      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-937      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |
    | DADA2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-937      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017937'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017937' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017937 Co Ltd' with UKPRN '10017937' and OrgId 'ORG0017937' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017937' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017937 | 117937 | 10017937 Co Ltd | 0              | Locked Restructure    | Yes           | AA017937      | ?             | 1a Sultan Street       | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017937 |





    # Part 1: Create and approve DADA 20/21 contract v1 
    
    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'DADAS-937'
    And   there are no details in ContractManagement.CreatedContract for 'DADAS-937'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017937 | 10017937 Co Ltd      | ESFA-937             | DADAS-937      | 1                     | 01/08/2020        | 31/07/2021      | 2135.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017937 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017937 | DADAS-937      | DADA-937      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 2135.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017937 | DADAS-937      | DADA-937      | 1               | 0                     | 2135.00   | 1411.00   | 724.00    | 0.00     | 1411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 724.00   | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'DADAS-937' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-937' and actual ContractNumber 'DADAS-937'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-937' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017937 | DADAS-937          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017937 | ESFA-937           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 2: Import and release DADA 21/22 FA. Approve contract v1  

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '06/08/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017937 | DADA-AY-2122-Contract-Provider-10017937-1_5           | 1_5            | DADA                        | AY-2122            | 15654.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017937-1_5  | 1_5                    | DADA-AY-2122-Contract-Provider-10017937-1_5           | 10017937      | Furth        | 07HEP           | 15654.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017937-1_5  | DADA-001        | 15654.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017937-1_5  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017937-1_5  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017937-1_5  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017937-1_5  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
 
 
 
 
 
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
    | 10017937 | 10017937 Co Ltd  | DADA-AY-2122-Contract-Provider-10017937-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 15654.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15654.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017937 | DADA-AY-2122-Contract-Provider-10017937-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

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
    When  I retrieve the latest contract details from CRM for provider '10017937' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017937 | 10017937 Co Ltd  | DADA-AY-2122-Contract-Provider-10017937-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017937 | DADA-AY-2122-Contract-Provider-10017937-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ?                 | ?                                 |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017937 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017937 | DADAS-937          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017937 | ESFA-937           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    
    
    
    
    # Publish and approve 21/22 DADA contract v1

    # Change the date
    Given the override date is '12/08/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-937' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017937 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017937 | DADAS-937          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017937 | ESFA-937           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 3: NFA on DADA 20/21 > contract v2

    # Change the date
    And   the override date is '12/09/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-937' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017937 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017937 | DADAS-937          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017937 | DADAS-937          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017937 | ESFA-937           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 4: Request termination initiation approval of 21/22 contract

    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '06/10/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 1               | 0                  | 06/10/2021              | Notice from Agency          | Acquisition in progress             |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_DADA]    | 03/09/2021                   | 10/09/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017937 | [ContractNo]   | 1                     | 0                        | 06/10/2021                 | Notice from Agency           | ?                              | 06/10/2021              | Notice from Agency          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017937 | [ContractNo]  | [AllocRef_DADA]  | 1                     | 0                        | 03/09/2021                   | 03/09/2021        | 10/09/2021                      | 10/09/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017937'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017937 - 10017937 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017937 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017937 | DADAS-937          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017937 | DADAS-937          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017937 | ESFA-937           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 5: Release an update to the DADA 21/22 FA > queue due to 21/22 contract

    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '07/10/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017937 | DADA-AY-2122-Contract-Provider-10017937-3_1           | 3_1            | DADA                        | AY-2122            | 20000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017937-3_1  | 3_1                    | DADA-AY-2122-Contract-Provider-10017937-3_1           | 10017937      | Furth        | 07HEP           | 20000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017937-3_1  | DADA-001        | 20000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017937-3_1  | DADA-001        | FY-2122              | September              | 2021              | 5439.00                   |
    | DADA-AY-2122-10017937-3_1  | DADA-001        | FY-2122              | November               | 2021              | 3088.00                   |
    | DADA-AY-2122-10017937-3_1  | DADA-001        | FY-2122              | February               | 2022              | 3200.00                   |
    | DADA-AY-2122-10017937-3_1  | DADA-001        | FY-2122              | June                   | 2022              | 3927.00                   |
    | DADA-AY-2122-10017937-3_1  | DADA-001        | FY-2122              | July                   | 2022              | 4346.00                   |





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
    | 10017937 | 10017937 Co Ltd  | DADA-AY-2122-Contract-Provider-10017937-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release        | 20000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CfS2]          | ?          | ?                   |
    | 10017937 | 10017937 Co Ltd  | DADA-AY-2122-Contract-Provider-10017937-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |





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
    When  I retrieve the latest contract details from CRM for provider '10017937' for FundingType 'DADA' and period '2122'
        
    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017937 | 10017937 Co Ltd  | DADA-AY-2122-Contract-Provider-10017937-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 11/10/2021 | [ContractNo]        |
    | 10017937 | 10017937 Co Ltd  | DADA-AY-2122-Contract-Provider-10017937-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017937-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131) 
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017937 | DADA-AY-2122-Contract-Provider-10017937-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | InRelease         | Queued                            |
    | 10017937 | DADA-AY-2122-Contract-Provider-10017937-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017937-3_1             | [ContractNo] | 1               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017937 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017937 | DADAS-937          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017937 | DADAS-937          | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017937 | ESFA-937           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 6: Delete draft 20/21 contract. Remain queued, due to 21/22 contract

    # Change the date 
    Given the override date is '14/10/2021'

    # Trigger WF28 in CRM to issue a delete request against v2 of contract DADA-937 (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017937 | DADAS-937      | 2                     | 0                  |


    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017937 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017937 | DADAS-937          | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017937 | ESFA-937           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017937 | 10017937 Co Ltd  | DADA-AY-2122-Contract-Provider-10017937-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | In Release        | Queued                  | 20000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | 11/10/2021 | [ContractNo]        |
    | 10017937 | 10017937 Co Ltd  | DADA-AY-2122-Contract-Provider-10017937-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017937-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |


    # Check PaaS


    # Part 7: Reject 21/22 termination initiation request. Auto-unqueue 21/22 FA > draft 21/22 contract v2

    # Change the date 
    Given the override date is '16/10/2021'

#   # Manager rejects termination initiation request (23810)
#   When  CRM user 'FCS5 Test' rejects the termination request for Contract '[ContractNo]' Version '1' SubVersion '0' with free-text reason 'Termination requested in error'

    # Reject Termination Initiation using the Next Action step
    When the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Reject Termination Initiation' specifying the reason as 'Test 937'


    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017937 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017937 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    #
    | 10017937 | DADAS-937          | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017937 | ESFA-937           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017937 | 10017937 Co Ltd  | DADA-AY-2122-Contract-Provider-10017937-3_1             | 3_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released                | 20000.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS2]          | ?          | ?                   |
    | 10017937 | 10017937 Co Ltd  | DADA-AY-2122-Contract-Provider-10017937-1_5             | 1_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved       | 15654.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017937-3_1             | Release Successful              | CRM Integration   | Released           | Released                        | In Release     | Queued                          | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-3_1             | Release Queued                  | CRM Integration   | In Release         | Queued                          | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-3_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017937 | DADA-AY-2122-Contract-Provider-10017937-3_1             | 3_1            | AY-2122 | DADA                        | 20000.00    | [CfS2]          | ?                 | ?                                 |
    | 10017937 | DADA-AY-2122-Contract-Provider-10017937-1_5             | 1_5            | AY-2122 | DADA                        | 15654.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017937-3_1             | [ContractNo] | 2               | 0                  | Yes            |
    | DADA-AY-2122-Contract-Provider-10017937-1_5             | [ContractNo] | 1               | 0                  | Yes            |

 
    # Tidy Up
    Given the override date is reset

