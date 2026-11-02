Feature: ParkingAfterContractDeletion 33588

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A721 Create and release a 1619 FA. Delete draft contract. FA1 back to Return to Scheduling. Import FA2 and park awaiting outcome. Check CRM and PaaS
    
    # 1. Create a draft contract with a 1619 FA
    # 2. Delete the draft contract. FA1 -> Return to Scheduling
    # 3. Import FA2 to supersede FA1
    # 4. FA2 should park in PaaS awaiting outcome of FA1
    
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017721'
    And   there is no Funding Allocation data in CRM for UKPRN '10017721'
    And   there is no Contract, Task or Workflow data for UKPRN '10017721'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017721'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017721'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017721' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017721' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017721 Co Ltd' with UKPRN '10017721' and OrgId 'ORG0017721' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017721' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017721 | 117721 | 10017721 Co Ltd | 0              | Active                | Yes           | AA017721      | ?             | 13 Coniston Road       | ?                      | ?                      | ?                      | Chippenham             | Wiltshire              | SN14 0PX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017721 |

    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     |
    | NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      |
    | NMSS                        | AY-2021            | EDSK            | AY2021            | 16-19ED2021  |

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2021            | DEFAULT          | Contract for Services                     |
    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   |
    | EDSK            | AY2021            | HEI              | Conditions of Funding (Grant) (HEI)       |
    | EDSK            | AY2021            | SSF              | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      |
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)       |
    | EDSK            | AY2021            | ITP              | Contract for Services (ITP)               |
    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        |

    # Load FundingAllocation.ProviderTypeConfig (J143)
    And   the following data replaces that currently in FundingAllocation.ProviderTypeConfig
    | ProviderType    | ProviderSubType   | ProviderCategory | 
    | Furth           | 01GFE             | College          |
    | Furth           | 02IPP             | ITP              |
    | Furth           | 03SFC             | College          |
    | Furth           | 04AHC             | College          |
    | Furth           | 05ADC             | College          |
    | Furth           | 06SDC             | College          |
    | Furth           | 07HEP             | HEI              |
    | Furth           | 18ISP             | SPI              |
    | Local           | 10LAU             | LA               |
    | Schoo           | 08SSF             | SSF              |
    | Schoo           | 21NMS             | NMSS             |

    # Load FundingAllocation.AllocationLineConfig (J144)
    And   the following data replaces that currently in FundingAllocation.AllocationLineConfig
    | FundingStreamCode | PeriodId   | FundingLineCode | ProviderCategory | FSPCode     | DeliverableCode | 
    | 1619              | AS-2021    | 1619-001        | SSF              | 1619ED2021  | 2               |
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021  | 20              |
    | 1619              | AS-2021    | 1619-001        | SPI              | 1619ED2021  | 32              |
    | 1619              | AS-2021    | 1619-002        | SSF              | 1619ED2021  | 13              |
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021  | 19              |
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021  | 33              |
    | 1619              | AS-2021    | 1619-004        | DEFAULT          | 1619ED2021  | 85              |
    | 1619              | AS-2021    | 1619-005        | DEFAULT          | 1619ED2021  | 31              |
    | 1619              | AS-2021    | 1619-005        | SSF              | 1619ED2021  | 47              |
    | 1619              | AS-2021    | 1619-006        | SSF              | 1619ED2021  | 15              |
    | 1619              | AS-2021    | 1619-006        | DEFAULT          | 1619ED2021  | 22              |
    | 1619              | AS-2021    | 1619-007        | DEFAULT          | 1619ED2021  | 112             |
    | 1619              | AS-2021    | 1619-007        | SSF              | 1619ED2021  | 114             |
    | 1619              | AS-2021    | 1619-008        | SSF              | 1619ED2021  | 48              |
    | 1619              | AS-2021    | 1619-008        | DEFAULT          | 1619ED2021  | 914             |
    | 1619              | AS-2021    | 1619-009        | DEFAULT          | 1619ED2021  | 136             |
    | 1619              | AS-2021    | 1619-009        | SSF              | 1619ED2021  | 138             |
    | 1619              | AS-2021    | 1619-010        | DEFAULT          | 1619ED2021  | 125             |
    | 1619              | AS-2021    | 1619-011        | DEFAULT          | 1619ED2021  | 51              |
    | 1619              | AS-2021    | 1619-013        | DEFAULT          | 1619ED2021  | 18              |
    | 1619              | AS-2021    | 1619-020        | DEFAULT          | 1619ED2021  | 52              |
    | 1619              | AS-2021    | 1619-021        | DEFAULT          | 1619ED2021  | 53              |
    | 1619              | AS-2021    | 1619-024        | DEFAULT          | 1619ED2021  | 149             |
    | 1619              | AS-2021    | 1619-024        | SSF              | 1619ED2021  | 151             |
    | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               |
    | NFF               | AS-2021    | NFF-001         | DEFAULT          | 1619ED2021  | 931             |
    | NFF               | AS-2021    | NFF-002         | DEFAULT          | 1619ED2021  | 87              |
    | NFF               | AS-2021    | NFF-003         | DEFAULT          | 1619ED2021  | 89              |
    | NFF               | AS-2021    | NFF-004         | DEFAULT          | 1619ED2021  | 119             |
    | NFF               | AS-2021    | NFF-005         | DEFAULT          | 1619ED2021  | 126             |
    | NFF               | AS-2021    | NFF-005         | SSF              | 1619ED2021  | 129             |
    | NFF               | AS-2021    | NFF-006         | DEFAULT          | 1619ED2021  | 127             |
    | NFF               | AS-2021    | NFF-006         | SSF              | 1619ED2021  | 130             |
    | NFF               | AS-2021    | NFF-007         | DEFAULT          | 1619ED2021  | 124             |
    | NFF               | AS-2021    | NFF-008         | DEFAULT          | 1619ED2021  | 120             |
    | NFF               | AS-2021    | NFF-008         | SSF              | 1619ED2021  | 121             |
    | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             |
    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             |
    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             |
    | NMSS              | AY-2021    | NMSS-001        | DEFAULT          | 1619ED2021  | 39              |
    | NMSS              | AY-2021    | NMSS-002        | DEFAULT          | 1619ED2021  | 15              |
    | NMSS              | AY-2021    | NMSS-003        | DEFAULT          | 1619ED2021  | 13              |
    | NMSS              | AY-2021    | NMSS-004        | DEFAULT          | 1619ED2021  | 49              |
    | NMSS              | AY-2021    | NMSS-005        | DEFAULT          | 1619ED2021  | 43              |
    | NMSS              | AY-2021    | NMSS-006        | DEFAULT          | 1619ED2021  | 118             |
    | NMSS              | AY-2021    | NMSS-007        | DEFAULT          | 1619ED2021  | 135             |
    | NMSS              | AY-2021    | NMSS-008        | DEFAULT          | 1619ED2021  | 140             |





    # Populate the stub with 1619 (05ADC) data

    # Change the date 
    Given the override date is '01/07/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017721 | 1619-AS-2021-Contract-Provider-10017721-3_2           | 3_2            | 1619                        | AS-2021            | 20008.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017721-3_2  | 3_2                    | 1619-AS-2021-Contract-Provider-10017721-3_2           | 10017721      | Furth        | 05ADC           | 20008.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017721-3_2  | 1619-007        | 20008.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017721-3_2  | 1619-007        | FY-2021              | August                 | 2020              | 2737.00                   |
    | 1619-AS-2021-10017721-3_2  | 1619-007        | FY-2021              | November               | 2020              | 3533.00                   |
    | 1619-AS-2021-10017721-3_2  | 1619-007        | FY-2021              | January                | 2021              | 2208.00                   |
    | 1619-AS-2021-10017721-3_2  | 1619-007        | FY-2021              | February               | 2021              | 2182.00                   |
    | 1619-AS-2021-10017721-3_2  | 1619-007        | FY-2021              | May                    | 2021              | 5200.00                   |
    | 1619-AS-2021-10017721-3_2  | 1619-007        | FY-2021              | July                   | 2021              | 4148.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '02/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017721 | 10017721 Co Ltd  | 1619-AS-2021-Contract-Provider-10017721-3_2             | 3_2            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 20008.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2021-Contract-Provider-10017721-3_2             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 20008.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017721 | 1619-AS-2021-Contract-Provider-10017721-3_2             | 3_2            | AS-2021 | 1619                        | 20008.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '03/07/2020'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the value of the ReleaseGroupParameter to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

#   # Check the state of a Release Group (J129)  (The count and value are unchanged)
#   Then  Release Group '[CofG_College]' has the following characteristics
#   | ReleaseStatus     | AllocationCount | AllocationValue |
#   | Released          | 1               | 20008.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017721' for FundingType 'EDSK' and period '2021'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017721' for FundingType 'EDSK' and period '2021' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017721 | 10017721 Co Ltd  | 1619-AS-2021-Contract-Provider-10017721-3_2             | 3_2            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Released          | Released          | 20008.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2021-Contract-Provider-10017721-3_2             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2021-Contract-Provider-10017721-3_2             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017721 | 1619-AS-2021-Contract-Provider-10017721-3_2             | 3_2            | AS-2021 | 1619                        | 20008.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2021-Contract-Provider-10017721-3_2             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017721 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017721 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017721 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 20008.00      | 1                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017721 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017721 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017721 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017721 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 20008.00        | ?             | ?                | 01/08/2020 | 31/07/2021 | 1619ED        | 1619ED2021          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 112             | 20008.00  | 2737.00  | 0.00     | 0.00     | 3533.00  | 0.00     | 2208.00  | 2182.00  | 0.00     | 0.00     | 5200.00  | 0.00     | 4148.00  | 16-19 Capacity and Delivery                                 |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#   # Check the contents of the Appendices
#   And   the file named '10017721_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
#   """
#   blah
#   """
#
#   # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017721_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A721.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'





    # 2. Delete the draft contract. FA1 -> Return to Scheduling

    # Change to date
    Given the override date is '04/07/2020'

    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017721 | [ContractNo]   | 1                     | 0                  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)   Funding Allocations are not linked to a contract or a Release Group
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017721 | 1619-AS-2021-Contract-Provider-10017721-3_2             | 3_2            | AS-2021 | 1619                        | 20008.00    | ?               | ?                 | ?                                 |

    # Check the CRM Funding Allocations data (J125)  Funding Allocations are not linked to a contract or a Release Group
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017721 | 10017721 Co Ltd  | 1619-AS-2021-Contract-Provider-10017721-3_2             | 3_2            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling         | Returned to Scheduling  | 20008.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               |


#   # Check the state of a Release Group in CRM (J129)  
#   And   Release Group '[CofG_College]' has the following characteristics
#   | ReleaseStatus     | AllocationCount | AllocationValue |
#   | Released          | 0               | 0.00            |





    # 3. Import FA2 to supersede FA1. FA2 should park pending an outcome for FA1 

    # Populate the stub with 1619 (05ADC) data

    # Change the date 
    Given the override date is '05/07/2020'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017721 | 1619-AS-2021-Contract-Provider-10017721-4_1           | 4_1            | 1619                        | AS-2021            | 23719.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017721-4_1  | 4_1                    | 1619-AS-2021-Contract-Provider-10017721-4_1           | 10017721      | Furth        | 05ADC           | 23719.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017721-4_1  | 1619-021        | 23719.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017721-4_1  | 1619-021        | FY-2021              | August                 | 2020              | 2899.00                   |
    | 1619-AS-2021-10017721-4_1  | 1619-021        | FY-2021              | November               | 2020              | 4790.00                   |
    | 1619-AS-2021-10017721-4_1  | 1619-021        | FY-2021              | March                  | 2021              | 5244.00                   |
    | 1619-AS-2021-10017721-4_1  | 1619-021        | FY-2021              | May                    | 2021              | 4944.00                   |
    | 1619-AS-2021-10017721-4_1  | 1619-021        | FY-2021              | July                   | 2021              | 5842.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '06/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017721 | 10017721 Co Ltd  | 1619-AS-2021-Contract-Provider-10017721-3_2             | 3_2            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling         | Returned to Scheduling  | 20008.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017721 | 1619-AS-2021-Contract-Provider-10017721-4_1             | 4_1            | AS-2021 | 1619                        | 23719.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017721 | 1619-AS-2021-Contract-Provider-10017721-3_2             | 3_2            | AS-2021 | 1619                        | 20008.00    | ?               | ?                 | ?                                 |


    # Tidy Up
    And   the override date is reset   

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A722 Create and publish 2021 EDSK (ALLF) contract. Import and release FA1 2x. Import non-material FA2. Withdraw published contract. Release FA1. Approve contract. Check CRM and PaaS
    
    # 1. Create and publish EDSK (ALLF) contract
    # 2. Input FA1 for the same contract > Scheduling\AwaitingRelease
    # 3. Release RG1. 
    # 4. FA1 > Scheduling\AwaitingRelease in RG2
    # 5. Import FA2 (non-material update to FA1). Park FA2 in PaaS > Parked/AwaitingOutcome
    # 6. Withdraw EDSK (ALLF) contract
    # 7. Release RG2 (with FA1)
    # 8. Approve contract. 
    # 9. FA2 Discarded/NonMaterialUpdate   
    
    Given there are no allocations marked as Under Termination for UKPRN '10017722' 
    And   there are no terminated or closed allocations for UKPRN '10017722' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017722' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017722' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |

    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017722' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-722      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-722      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLF2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-722       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017722'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017722' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017722 Co Ltd' with UKPRN '10017722' and OrgId 'ORG0017722' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017722' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017722 | 117722 | 10017722 Co Ltd | 0              | In Administration     | Yes           | AA017722      | ?             | 27 Kingfisher Court    | Hambridge Lane         | ?                      | ?                      | Newbury                | Berkshire              | RG14 5SJ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017722 |


    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     |
    | NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      |
    | NMSS                        | AY-2021            | EDSK            | AY2021            | 16-19ED2021  |

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2021            | DEFAULT          | Contract for Services                     |
    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   |
    | EDSK            | AY2021            | HEI              | Conditions of Funding (Grant) (HEI)       |
    | EDSK            | AY2021            | SSF              | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      |
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)       |
    | EDSK            | AY2021            | ITP              | Contract for Services (ITP)               |
    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        |

    # Load FundingAllocation.ProviderTypeConfig (J143)
    And   the following data replaces that currently in FundingAllocation.ProviderTypeConfig
    | ProviderType    | ProviderSubType   | ProviderCategory | 
    | Furth           | 01GFE             | College          |
    | Furth           | 02IPP             | ITP              |
    | Furth           | 03SFC             | College          |
    | Furth           | 04AHC             | College          |
    | Furth           | 05ADC             | College          |
    | Furth           | 06SDC             | College          |
    | Furth           | 07HEP             | HEI              |
    | Furth           | 18ISP             | SPI              |
    | Local           | 10LAU             | LA               |
    | Schoo           | 08SSF             | SSF              |
    | Schoo           | 21NMS             | NMSS             |

    # Load FundingAllocation.AllocationLineConfig (J144)
    And   the following data replaces that currently in FundingAllocation.AllocationLineConfig
    | FundingStreamCode | PeriodId   | FundingLineCode | ProviderCategory | FSPCode     | DeliverableCode | 
    | 1619              | AS-2021    | 1619-001        | SSF              | 1619ED2021  | 2               |
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021  | 20              |
    | 1619              | AS-2021    | 1619-001        | SPI              | 1619ED2021  | 32              |
    | 1619              | AS-2021    | 1619-002        | SSF              | 1619ED2021  | 13              |
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021  | 19              |
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021  | 33              |
    | 1619              | AS-2021    | 1619-004        | DEFAULT          | 1619ED2021  | 85              |
    | 1619              | AS-2021    | 1619-005        | DEFAULT          | 1619ED2021  | 31              |
    | 1619              | AS-2021    | 1619-005        | SSF              | 1619ED2021  | 47              |
    | 1619              | AS-2021    | 1619-006        | SSF              | 1619ED2021  | 15              |
    | 1619              | AS-2021    | 1619-006        | DEFAULT          | 1619ED2021  | 22              |
    | 1619              | AS-2021    | 1619-007        | DEFAULT          | 1619ED2021  | 112             |
    | 1619              | AS-2021    | 1619-007        | SSF              | 1619ED2021  | 114             |
    | 1619              | AS-2021    | 1619-008        | SSF              | 1619ED2021  | 48              |
    | 1619              | AS-2021    | 1619-008        | DEFAULT          | 1619ED2021  | 914             |
    | 1619              | AS-2021    | 1619-009        | DEFAULT          | 1619ED2021  | 136             |
    | 1619              | AS-2021    | 1619-009        | SSF              | 1619ED2021  | 138             |
    | 1619              | AS-2021    | 1619-010        | DEFAULT          | 1619ED2021  | 125             |
    | 1619              | AS-2021    | 1619-011        | DEFAULT          | 1619ED2021  | 51              |
    | 1619              | AS-2021    | 1619-013        | DEFAULT          | 1619ED2021  | 18              |
    | 1619              | AS-2021    | 1619-020        | DEFAULT          | 1619ED2021  | 52              |
    | 1619              | AS-2021    | 1619-021        | DEFAULT          | 1619ED2021  | 53              |
    | 1619              | AS-2021    | 1619-024        | DEFAULT          | 1619ED2021  | 149             |
    | 1619              | AS-2021    | 1619-024        | SSF              | 1619ED2021  | 151             |
    | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               |
    | NFF               | AS-2021    | NFF-001         | DEFAULT          | 1619ED2021  | 931             |
    | NFF               | AS-2021    | NFF-002         | DEFAULT          | 1619ED2021  | 87              |
    | NFF               | AS-2021    | NFF-003         | DEFAULT          | 1619ED2021  | 89              |
    | NFF               | AS-2021    | NFF-004         | DEFAULT          | 1619ED2021  | 119             |
    | NFF               | AS-2021    | NFF-005         | DEFAULT          | 1619ED2021  | 126             |
    | NFF               | AS-2021    | NFF-005         | SSF              | 1619ED2021  | 129             |
    | NFF               | AS-2021    | NFF-006         | DEFAULT          | 1619ED2021  | 127             |
    | NFF               | AS-2021    | NFF-006         | SSF              | 1619ED2021  | 130             |
    | NFF               | AS-2021    | NFF-007         | DEFAULT          | 1619ED2021  | 124             |
    | NFF               | AS-2021    | NFF-008         | DEFAULT          | 1619ED2021  | 120             |
    | NFF               | AS-2021    | NFF-008         | SSF              | 1619ED2021  | 121             |
    | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             |
    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             |
    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             |
    | NMSS              | AY-2021    | NMSS-001        | DEFAULT          | 1619ED2021  | 39              |
    | NMSS              | AY-2021    | NMSS-002        | DEFAULT          | 1619ED2021  | 15              |
    | NMSS              | AY-2021    | NMSS-003        | DEFAULT          | 1619ED2021  | 13              |
    | NMSS              | AY-2021    | NMSS-004        | DEFAULT          | 1619ED2021  | 49              |
    | NMSS              | AY-2021    | NMSS-005        | DEFAULT          | 1619ED2021  | 43              |
    | NMSS              | AY-2021    | NMSS-006        | DEFAULT          | 1619ED2021  | 118             |
    | NMSS              | AY-2021    | NMSS-007        | DEFAULT          | 1619ED2021  | 135             |
    | NMSS              | AY-2021    | NMSS-008        | DEFAULT          | 1619ED2021  | 140             |





    # Create and publish EDSK (ALLF) contract
    
    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-722'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-722'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017722 | 10017722 Co Ltd      | ESFA-722             | EDSK-722       | 1                     | 01/08/2020        | 31/07/2021      | 30396.00      |                                       | Conditions of Funding (Grant) (SPI)        | 2021   | New          | ORG0017722 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017722 | EDSK-722       | ALLF-722      | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 30396.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017722 | EDSK-722       | ALLF-722      | 5               | 0                     | 30396.00  | 19569.00  | 10827.00  | 3716.00  | 3059.00  | 346.00   | 1082.00  | 3558.00  | 3533.00  | 2624.00  | 1651.00  | 3588.00  | 1477.00  | 2372.00  | 3390.00  | Advanced Learner Loans Facility                                 | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-722       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-722'
     




    # Populate the stub with 1619 (05ADC) data 

    # Change the date 
    Given the override date is '03/07/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017722 | 1619-AS-2021-Contract-Provider-10017722-1_0           | 1_0            | 1619                        | AS-2021            | 23911.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017722-1_0  | 1_0                    | 1619-AS-2021-Contract-Provider-10017722-1_0           | 10017722      | Furth        | 05ADC           | 23911.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017722-1_0  | 1619-006        | 23911.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017722-1_0  | 1619-006        | FY-2021              | September              | 2020              | 5196.00                   |
    | 1619-AS-2021-10017722-1_0  | 1619-006        | FY-2021              | October                | 2020              | 3118.00                   |
    | 1619-AS-2021-10017722-1_0  | 1619-006        | FY-2021              | January                | 2021              | 4288.00                   |
    | 1619-AS-2021-10017722-1_0  | 1619-006        | FY-2021              | February               | 2021              | 3716.00                   |
    | 1619-AS-2021-10017722-1_0  | 1619-006        | FY-2021              | April                  | 2021              | 2493.00                   |
    | 1619-AS-2021-10017722-1_0  | 1619-006        | FY-2021              | July                   | 2021              | 5100.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017722 | 10017722 Co Ltd  | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 23911.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2021-Contract-Provider-10017722-1_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 23911.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017722 | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | AS-2021 | 1619                        | 23911.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release the Release Group (32953)   Contract does not have an outcome so on release from RG1 FA is queued (33387)

    # Change the date 
    Given the override date is '09/07/2020'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the value of the ReleaseGroupParameter to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 23911.00        |

#   # Capture the Release Group parameter value (J127)
#   #Given the Release Groups for the following Contracting Profiles have been saved
#    Given the Release Group for the following Contracting Profile has been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) | CofG_College2             |
#
#    # Check the state of a Release Group in CRM (J129)
#    Then  Release Group '[CofG_College2]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Awaiting Release  | 1               | 23911.00        |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017722 | EDSK-722           | 1                     | 0                        | Draft            | Published to Provider                     | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017722 | ESFA-722           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017722 | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | AS-2021 | 1619                        | 23911.00    | [CofG_College]  | InRelease         | Queued                            |





    # Populate the stub with 1619 (05ADC) data.   v2_1 is a non-material update of v1_0

    # Change the date 
    Given the override date is '11/07/2020'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017722 | 1619-AS-2021-Contract-Provider-10017722-2_1           | 2_1            | 1619                        | AS-2021            | 23911.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017722-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10017722-2_1           | 10017722      | Furth        | 05ADC           | 23911.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017722-2_1  | 1619-006        | 23911.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017722-2_1  | 1619-006        | FY-2021              | September              | 2020              | 5196.00                   |
    | 1619-AS-2021-10017722-2_1  | 1619-006        | FY-2021              | October                | 2020              | 3118.00                   |
    | 1619-AS-2021-10017722-2_1  | 1619-006        | FY-2021              | January                | 2021              | 4288.00                   |
    | 1619-AS-2021-10017722-2_1  | 1619-006        | FY-2021              | February               | 2021              | 3716.00                   |
    | 1619-AS-2021-10017722-2_1  | 1619-006        | FY-2021              | April                  | 2021              | 2493.00                   |
    | 1619-AS-2021-10017722-2_1  | 1619-006        | FY-2021              | July                   | 2021              | 5100.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '13/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)   FA1 is in RG1. FA2 is awaiting an outcome for FA1   
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#   | 10017722 | 1619-AS-2021-Contract-Provider-10017722-2_1             | 2_1            | AS-2021 | 1619                        | 23911.00    | ?               | Parked            | AwaitingOutcome                   |
#   | 10017722 | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | AS-2021 | 1619                        | 23911.00    | [CofG_College2] | Scheduling        | AwaitingRelease                   |
    | 10017722 | 1619-AS-2021-Contract-Provider-10017722-2_1             | 2_1            | AS-2021 | 1619                        | 23911.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017722 | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | AS-2021 | 1619                        | 23911.00    | [CofG_College]  | InRelease         | Queued                            |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#   | 10017722 | 10017722 Co Ltd  | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | In Release         | Queued                  | 23911.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | 09/07/2021 | EDSK-722            |
    | 10017722 | 10017722 Co Ltd  | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | In Release         | Queued                  | 23911.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | 09/07/2020 | EDSK-722            |




    # 33387 ends here




#    # Withdraw the contract
#
#    # Change the date 
#    Given the override date is '16/07/2020'
#
#    # Retrieve parameters from CRM
#    When  I retrieve the latest contract details from CRM for provider '10017722' for FundingType 'EDSK' and period '2021'
#
#    # Withdraw contract
#    When  the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Withdraw On Behalf Of Provider' specifying the reason as 'Test A722'
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017722 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
#
#
#
#
#
#    # Release the Release Group (32953)
#
#    # Change the date 
#    Given the override date is '17/07/2020'
#
#    # Release Funding Allocations from Contract Control (J128)
#   #When  a request is triggered to release the following Release Groups together
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CofG_College2]   |
#
#    # Write the value of the ReleaseGroupParameter to the output window
#    And   message 'ReleaseGroup CofG_College = [CofG_College2]' is written to the Output window
#
##    # Check the state of a Release Group (J129) 
##    Then  Release Group '[CofG_College2]' has the following characteristics
##    | ReleaseStatus     | AllocationCount | AllocationValue |
##    | Released          | 1               | 23911.00        |
#
#    # Retrieve parameters from CRM
#    When  I retrieve the latest contract details from CRM for provider '10017722' for FundingType 'EDSK' and period '2021'
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017722 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
#    | 10017722 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
#    | 10017722 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    Then  the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10017722 | 1619-AS-2021-Contract-Provider-10017722-2_1             | 2_1            | AS-2021 | 1619                        | 23911.00    | ?               | Parked            | AwaitingOutcome                   |
#    | 10017722 | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | AS-2021 | 1619                        | 23911.00    | [CofG_College2] | ?                 | ?                                 |
#
#    # Check the CRM Funding Allocations data (J125)
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
#    | 10017722 | 10017722 Co Ltd  | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Released           | Released                | 23911.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College2] |
#
#    # Retrieve parameters from CRM
#    When  I retrieve the latest contract details from CRM for provider '10017722' for FundingType 'EDSK' and period '2021'
#    
#    # Write the value of the ReleaseGroupParameter to the output window
#    Then  message 'ContractNo = [ContractNo] AllocRef_16ED = [AllocRef_16ED]' is written to the Output window
#
#    # Check that the Contract and Master Contract have been created correctly in CRM.    ContractType on MasterContract not the same as on Contract. Dave unconcerned.
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10017722 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 23911.00      | 2                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017722 Co Ltd  | Active | Document Management Team  | ?                      |
#    | 10017722 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017722 Co Ltd  | Active | CRM Integration           | ?                      |
#
#    # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10017722 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 23911.00        | ?             | ?                | 01/08/2020 | 31/07/2021 | 1619ED        | 1619ED2021          | Contract Allocation   | ?                        |
#
#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName               | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_16ED] | 22              | 23911.00  | 0.00     | 5196.00  | 3118.00  | 0.00     | 0.00     | 4288.00  | 3716.00  | 0.00     | 2493.00  | 0.00     | 0.00     | 5100.00  | 16-19 High Needs Element 2    |                          |
#
#    # Contract status is now at 'Awaiting Documentation'   
#    
#
#
#
#
#    # Publish the contract
#
#    # Change the date 
#    Given the override date is '19/07/2020'
#
#    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#
#
#
#
#    # Approve the contract
#
#    # Change the date 
#    Given the override date is '20/07/2020'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017722 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
#    | 10017722 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
#
#    # Check the CRM Funding Allocations data (J125) 
#    And   the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
#    | 10017722 | 10017722 Co Ltd  | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Contract Approved | Contract Approved | 23911.00    | [ContractNo]  | 2                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College2] |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10017722 | 1619-AS-2021-Contract-Provider-10017722-1_0             | 1_0            | AS-2021 | 1619                        | 23911.00    | [CofG_College2] | ContractApproved  | ContractApproved                  |
#
#
#
#
#
#    # FA v2_1 should be discarded as a non-material update
#
#    # Check CRM and PaaS
#
#    # Tidy Up
#    And   the override date is reset    
     
@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A723 Create NLG contract from FA1. Publish then withdraw contract. Reinstate FA1. Import FA2 with extra Funding Lines. Release reinstated FA1 to create draft contract v2. Delete contract v2 then withdraw FA1. Release RG(FA2) to create contract from FA2 data. Check contract, CRM and PaaS.

    # 1. FA1 imported and RG1 released. Contract v1 created
    # 2. Contract v1 is published then withdrawn. FA1 > Scheduling\ReturnedToScheduling
    # 3. Re-Instate FA1 (Scheduling\AwaitingRelease) and add it to RG2
    # 4. Import FA2 with additional funding lines to FA1
    # 5. Release RG2 (FA1) to create draft contact v2 
    # 6. Delete Draft contract v2. FA1 > Scheduling\ReturnedToScheduling
    # 7. Withdraw FA1.
    # 8. Release RG2 (FA2)
    # 9. Create contract v2 from FA2 data

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017723'
    And   there is no Funding Allocation data in CRM for UKPRN '10017723'
    And   there is no Contract, Task or Workflow data for UKPRN '10017723'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017723'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017723'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017723' in the Sharepoint 'NLG-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017723' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017723 Co Ltd' with UKPRN '10017723' and OrgId 'ORG0017723' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017723' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017723 | 117723 | 10017723 Co Ltd | 0              | Active                | Yes           | AA017723      | ?             | 74 Lenelby Road        | Surbiton               | Surrey                 | ?                      | ?                      | ?                      | RT7 6BH   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017723 |




    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     |
    | NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      |
    | NMSS                        | AY-2021            | EDSK            | AY2021            | 16-19ED2021  |

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2021            | DEFAULT          | Contract for Services                     |
    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   |
    | EDSK            | AY2021            | HEI              | Conditions of Funding (Grant) (HEI)       |
    | EDSK            | AY2021            | SSF              | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      |
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)       |
    | EDSK            | AY2021            | ITP              | Contract for Services (ITP)               |
    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        |

    # Load FundingAllocation.ProviderTypeConfig (J143)
    And   the following data replaces that currently in FundingAllocation.ProviderTypeConfig
    | ProviderType    | ProviderSubType   | ProviderCategory | 
    | Furth           | 01GFE             | College          |
    | Furth           | 02IPP             | ITP              |
    | Furth           | 03SFC             | College          |
    | Furth           | 04AHC             | College          |
    | Furth           | 05ADC             | College          |
    | Furth           | 06SDC             | College          |
    | Furth           | 07HEP             | HEI              |
    | Furth           | 18ISP             | SPI              |
    | Local           | 10LAU             | LA               |
    | Schoo           | 08SSF             | SSF              |
    | Schoo           | 21NMS             | NMSS             |

    # Load FundingAllocation.AllocationLineConfig (J144)
    And   the following data replaces that currently in FundingAllocation.AllocationLineConfig
    | FundingStreamCode | PeriodId   | FundingLineCode | ProviderCategory | FSPCode     | DeliverableCode | 
    | 1619              | AS-2021    | 1619-001        | SSF              | 1619ED2021  | 2               |
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021  | 20              |
    | 1619              | AS-2021    | 1619-001        | SPI              | 1619ED2021  | 32              |
    | 1619              | AS-2021    | 1619-002        | SSF              | 1619ED2021  | 13              |
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021  | 19              |
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021  | 33              |
    | 1619              | AS-2021    | 1619-004        | DEFAULT          | 1619ED2021  | 85              |
    | 1619              | AS-2021    | 1619-005        | DEFAULT          | 1619ED2021  | 31              |
    | 1619              | AS-2021    | 1619-005        | SSF              | 1619ED2021  | 47              |
    | 1619              | AS-2021    | 1619-006        | SSF              | 1619ED2021  | 15              |
    | 1619              | AS-2021    | 1619-006        | DEFAULT          | 1619ED2021  | 22              |
    | 1619              | AS-2021    | 1619-007        | DEFAULT          | 1619ED2021  | 112             |
    | 1619              | AS-2021    | 1619-007        | SSF              | 1619ED2021  | 114             |
    | 1619              | AS-2021    | 1619-008        | SSF              | 1619ED2021  | 48              |
    | 1619              | AS-2021    | 1619-008        | DEFAULT          | 1619ED2021  | 914             |
    | 1619              | AS-2021    | 1619-009        | DEFAULT          | 1619ED2021  | 136             |
    | 1619              | AS-2021    | 1619-009        | SSF              | 1619ED2021  | 138             |
    | 1619              | AS-2021    | 1619-010        | DEFAULT          | 1619ED2021  | 125             |
    | 1619              | AS-2021    | 1619-011        | DEFAULT          | 1619ED2021  | 51              |
    | 1619              | AS-2021    | 1619-013        | DEFAULT          | 1619ED2021  | 18              |
    | 1619              | AS-2021    | 1619-020        | DEFAULT          | 1619ED2021  | 52              |
    | 1619              | AS-2021    | 1619-021        | DEFAULT          | 1619ED2021  | 53              |
    | 1619              | AS-2021    | 1619-024        | DEFAULT          | 1619ED2021  | 149             |
    | 1619              | AS-2021    | 1619-024        | SSF              | 1619ED2021  | 151             |
    | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               |
    | NFF               | AS-2021    | NFF-001         | DEFAULT          | 1619ED2021  | 931             |
    | NFF               | AS-2021    | NFF-002         | DEFAULT          | 1619ED2021  | 87              |
    | NFF               | AS-2021    | NFF-003         | DEFAULT          | 1619ED2021  | 89              |
    | NFF               | AS-2021    | NFF-004         | DEFAULT          | 1619ED2021  | 119             |
    | NFF               | AS-2021    | NFF-005         | DEFAULT          | 1619ED2021  | 126             |
    | NFF               | AS-2021    | NFF-005         | SSF              | 1619ED2021  | 129             |
    | NFF               | AS-2021    | NFF-006         | DEFAULT          | 1619ED2021  | 127             |
    | NFF               | AS-2021    | NFF-006         | SSF              | 1619ED2021  | 130             |
    | NFF               | AS-2021    | NFF-007         | DEFAULT          | 1619ED2021  | 124             |
    | NFF               | AS-2021    | NFF-008         | DEFAULT          | 1619ED2021  | 120             |
    | NFF               | AS-2021    | NFF-008         | SSF              | 1619ED2021  | 121             |
    | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             |
    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             |
    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             |
    | NMSS              | AY-2021    | NMSS-001        | DEFAULT          | 1619ED2021  | 39              |
    | NMSS              | AY-2021    | NMSS-002        | DEFAULT          | 1619ED2021  | 15              |
    | NMSS              | AY-2021    | NMSS-003        | DEFAULT          | 1619ED2021  | 13              |
    | NMSS              | AY-2021    | NMSS-004        | DEFAULT          | 1619ED2021  | 49              |
    | NMSS              | AY-2021    | NMSS-005        | DEFAULT          | 1619ED2021  | 43              |
    | NMSS              | AY-2021    | NMSS-006        | DEFAULT          | 1619ED2021  | 118             |
    | NMSS              | AY-2021    | NMSS-007        | DEFAULT          | 1619ED2021  | 135             |
    | NMSS              | AY-2021    | NMSS-008        | DEFAULT          | 1619ED2021  | 140             |





    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '01/07/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-1_1            | 1_1            | NLG                         | AS-2021            | 18050.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017723-1_1   | 1_1                    | NLG-AS-2021-Contract-Provider-10017723-1_1            | 10017723      | Furth        | 02IPP           | 18050.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017723-1_1   | NLG-001         | 18050.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017723-1_1   | NLG-001         | FY-2021              | September              | 2020              | 5138.00                   |
    | NLG-AS-2021-10017723-1_1   | NLG-001         | FY-2021              | December               | 2020              | 3129.00                   |
    | NLG-AS-2021-10017723-1_1   | NLG-001         | FY-2021              | February               | 2021              | 2216.00                   |
    | NLG-AS-2021-10017723-1_1   | NLG-001         | FY-2021              | April                  | 2021              | 2018.00                   |
    | NLG-AS-2021-10017723-1_1   | NLG-001         | FY-2021              | June                   | 2021              | 5549.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '02/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017723 | 10017723 Co Ltd  | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling        | Awaiting Release  | 18050.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG]             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18050.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | AS-2021 | NLG                         | 18050.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '03/07/2020'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG]             |

    # Write the value of the ReleaseGroupParameter to the output window
    And   message 'ReleaseGroup NLG = [NLG]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 18050.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017723' for FundingType 'NLG' and period '2021'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017723' for FundingType 'NLG' and period '2021' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017723 | 10017723 Co Ltd  | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Released          | Released          | 18050.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | AS-2021 | NLG                         | 18050.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2021-Contract-Provider-10017723-1_1              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017723 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017723 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017723 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 18050.00      | 1                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017723 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017723 | [MasterContractNo] | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017723 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017723 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 18050.00        | ?             | ?                | 01/08/2020 | 31/07/2021 | NLG           | NLG2021             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 18050.00  | 0.00     | 5138.00  | 0.00     | 0.00     | 3129.00  | 0.00     | 2216.00  | 0.00     | 2018.00  | 0.00     | 5549.00  | 0.00     | Isles of Scilly: Boarding and Accommodation Grant           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'





    # Publish the contract

    # Change the date 
    Given the override date is '04/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Withdraw the contract

    # Change the date 
    Given the override date is '05/07/2020'

    # Withdraw contract
    When  the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Withdraw On Behalf Of Provider' specifying the reason as 'Test A722'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017723 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Re-instate the Funding Allocation (33228)  (Substatus Scheduling\ReturnToScheduling -> Scheduling\AwaitingRelease) 

    # Change the date 
    Given the override date is '06/07/2020'

    # Move FA from 'Return to Scheduling' to 'Awaiting Release' (J136)
   #When  User 'FCS8 TEST' opts to re-instate the following Funding Allocations together
    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocation
    | FundingId                                      |
    | NLG-AS-2021-Contract-Provider-10017723-1_1     |


    # FA gets added to release group NLG2

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG2                      |

    # Write the value of the ReleaseGroupParameter to the output window
    And   message 'ReleaseGroup NLG2 = [NLG2]' is written to the Output window

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[NLG2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18050.00        |






    # Populate the stub with NLG (02IPP) data a second time

    # Change the date 
    Given the override date is '07/07/2020'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-3_1            | 3_1            | NLG                         | AS-2021            | 25714.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017723-3_1   | 3_1                    | NLG-AS-2021-Contract-Provider-10017723-3_1            | 10017723      | Furth        | 02IPP           | 25714.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017723-3_1   | NLG-001         | 6231.00          | Payment         |
    | NLG-AS-2021-10017723-3_1   | NLG-002         | 19483.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017723-3_1   | NLG-001         | FY-2021              | August                 | 2020              | 2923.00                   |
    | NLG-AS-2021-10017723-3_1   | NLG-001         | FY-2021              | March                  | 2021              | 3308.00                   |
    #
    | NLG-AS-2021-10017723-3_1   | NLG-002         | FY-2021              | September              | 2020              | 2087.00                   |
    | NLG-AS-2021-10017723-3_1   | NLG-002         | FY-2021              | January                | 2021              | 5687.00                   |
    | NLG-AS-2021-10017723-3_1   | NLG-002         | FY-2021              | February               | 2021              | 3951.00                   |
    | NLG-AS-2021-10017723-3_1   | NLG-002         | FY-2021              | April                  | 2021              | 5158.00                   |
    | NLG-AS-2021-10017723-3_1   | NLG-002         | FY-2021              | June                   | 2021              | 2600.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '08/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG2                      |

    # Write the value of the ReleaseGroupParameter to the output window
    And   message 'ReleaseGroup NLG2 = [NLG2]' is written to the Output window

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-3_1              | 3_1            | AS-2021 | NLG                         | 25714.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | AS-2021 | NLG                         | 18050.00    | [NLG2]          | ?                 | ?                                 |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017723 | 10017723 Co Ltd  | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling        | Awaiting Release  | 18050.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG2]            |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18050.00        |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '09/07/2020'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG2]            |

    # Write the value of the ReleaseGroupParameter to the output window
    And   message 'ReleaseGroup NLG2 = [NLG2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 18050.00        |

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017723 | 10017723 Co Ltd  | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Released          | Released          | 18050.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG2]          |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-3_1              | 3_1            | AS-2021 | NLG                         | 25714.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | AS-2021 | NLG                         | 18050.00    | [NLG2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2021-Contract-Provider-10017723-1_1              | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017723 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017723 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Delete contract v2

    # Change the date 
    Given the override date is '10/07/2020'

    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017723 | [ContractNo]   | 2                     | 0                  |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017723 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017723 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Has the contract been deleted ?
    And   the following contracts are no longer present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017723 | [ContractNo]   | 2                     | 

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-3_1              | 3_1            | AS-2021 | NLG                         | 25714.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | AS-2021 | NLG                         | 18050.00    | ?               | ?                 | ?                                 |

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017723 | 10017723 Co Ltd  | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling        | Returned to Scheduling  | 18050.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               |





    # Withdraw FA1

    Given the override date is '11/07/2020'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Test A723'
    | FundingId                                               | 
    | NLG-AS-2021-Contract-Provider-10017723-1_1              | 

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG3                      |
    
    # Write the value of the ReleaseGroupParameter to the output window
    And   message 'ReleaseGroup NLG3 = [NLG3]' is written to the Output window    
    
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-3_1              | 3_1            | AS-2021 | NLG                         | 25714.00    | [NLG3]          | ?                 | ?                                 |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | AS-2021 | NLG                         | 18050.00    | ?               | Withdrawn         | Withdrawn                         |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 25714.00        |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '12/07/2020'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG3]            |

    # Write the value of the ReleaseGroupParameter to the output window
    And   message 'ReleaseGroup NLG3 = [NLG3]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 25714.00        |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG3]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-3_1              | 3_1            | AS-2021 | NLG                         | 25714.00    | [NLG3]          | ?                 | ?                                 |
    | 10017723 | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | AS-2021 | NLG                         | 18050.00    | ?               | Withdrawn         | Withdrawn                         |

    # Check the CRM Funding Allocations data (J125)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017723 | 10017723 Co Ltd  | NLG-AS-2021-Contract-Provider-10017723-3_1              | 3_1            | Non-learning Grants          | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Released           | Released                | 25714.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG3]          |
    | 10017723 | 10017723 Co Ltd  | NLG-AS-2021-Contract-Provider-10017723-1_1              | 1_1            | Non-learning Grants          | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Withdrawn          | Withdrawn               | 18050.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017723' for FundingType 'NLG' and period '2021'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017723' for FundingType 'NLG' and period '2021' and Delivery Organisation '?' 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017723 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017723 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017723 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017723 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 25714.00      | 2                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017723 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017723 | [MasterContractNo] | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017723 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017723 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 25714.00        | ?             | ?                | 01/08/2020 | 31/07/2021 | NLG           | NLG2021             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 6231.00   | 2923.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3308.00  | 0.00     | 0.00     | 0.00     | 0.00     | Isles of Scilly: Boarding and Accommodation Grant           |                          |
    | [ContractNo]   | [AllocRef_NLG]  | 101             | 19483.00  | 0.00     | 2087.00  | 0.00     | 0.00     | 0.00     | 5687.00  | 3951.00  | 0.00     | 5158.00  | 0.00     | 2600.00  | 0.00     | Principals Reference Group (PRG)                            |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


    # Tidy Up
    Then  the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A724 Import several FAs. Discard. Release RG. Approve contract. Import several FAs. Withdraw FA. NFA. Release RG. Check CRM and PaaS

    # 1. Import FA1 and FA2 in same pull. FA1 is discarded
    # 2. Import and park FA3
    # 3. Release RG1\FA2 to create contract
    # 4. Import FA4. FA3 is Discarded\Superseded
    # 5. Publish and Approve contract
    # 6. Import FA5 and FA6 in same pull. FA5 is discarded
    # 7. Withdraw FA4
    # 8. Non-Financial Amendment
    # 9. Release RG2\FA6

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017724'
    And   there is no Funding Allocation data in CRM for UKPRN '10017724'
    And   there is no Contract, Task or Workflow data for UKPRN '10017724'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017724'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017724'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017724' in the Sharepoint 'NLG-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017724' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017724 Co Ltd' with UKPRN '10017724' and OrgId 'ORG0017724' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017724' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017724 | 117724 | 10017724 Co Ltd | 0              | Provider Under Change | Yes           | AA017724      | ?             | 4 Buckingham Court     | Beaufort Park          | Woodlands              | Bristol                | ?                      | ?                      | BS32 4NF  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017724 |




    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     |
    | NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  |
    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      |
    | NMSS                        | AY-2021            | EDSK            | AY2021            | 16-19ED2021  |

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2021            | DEFAULT          | Contract for Services                     |
    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   |
    | EDSK            | AY2021            | HEI              | Conditions of Funding (Grant) (HEI)       |
    | EDSK            | AY2021            | SSF              | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      |
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)       |
    | EDSK            | AY2021            | ITP              | Contract for Services (ITP)               |
    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        |

    # Load FundingAllocation.ProviderTypeConfig (J143)
    And   the following data replaces that currently in FundingAllocation.ProviderTypeConfig
    | ProviderType    | ProviderSubType   | ProviderCategory | 
    | Furth           | 01GFE             | College          |
    | Furth           | 02IPP             | ITP              |
    | Furth           | 03SFC             | College          |
    | Furth           | 04AHC             | College          |
    | Furth           | 05ADC             | College          |
    | Furth           | 06SDC             | College          |
    | Furth           | 07HEP             | HEI              |
    | Furth           | 18ISP             | SPI              |
    | Local           | 10LAU             | LA               |
    | Schoo           | 08SSF             | SSF              |
    | Schoo           | 21NMS             | NMSS             |

    # Load FundingAllocation.AllocationLineConfig (J144)
    And   the following data replaces that currently in FundingAllocation.AllocationLineConfig
    | FundingStreamCode | PeriodId   | FundingLineCode | ProviderCategory | FSPCode     | DeliverableCode | 
    | 1619              | AS-2021    | 1619-001        | SSF              | 1619ED2021  | 2               |
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021  | 20              |
    | 1619              | AS-2021    | 1619-001        | SPI              | 1619ED2021  | 32              |
    | 1619              | AS-2021    | 1619-002        | SSF              | 1619ED2021  | 13              |
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021  | 19              |
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021  | 33              |
    | 1619              | AS-2021    | 1619-004        | DEFAULT          | 1619ED2021  | 85              |
    | 1619              | AS-2021    | 1619-005        | DEFAULT          | 1619ED2021  | 31              |
    | 1619              | AS-2021    | 1619-005        | SSF              | 1619ED2021  | 47              |
    | 1619              | AS-2021    | 1619-006        | SSF              | 1619ED2021  | 15              |
    | 1619              | AS-2021    | 1619-006        | DEFAULT          | 1619ED2021  | 22              |
    | 1619              | AS-2021    | 1619-007        | DEFAULT          | 1619ED2021  | 112             |
    | 1619              | AS-2021    | 1619-007        | SSF              | 1619ED2021  | 114             |
    | 1619              | AS-2021    | 1619-008        | SSF              | 1619ED2021  | 48              |
    | 1619              | AS-2021    | 1619-008        | DEFAULT          | 1619ED2021  | 914             |
    | 1619              | AS-2021    | 1619-009        | DEFAULT          | 1619ED2021  | 136             |
    | 1619              | AS-2021    | 1619-009        | SSF              | 1619ED2021  | 138             |
    | 1619              | AS-2021    | 1619-010        | DEFAULT          | 1619ED2021  | 125             |
    | 1619              | AS-2021    | 1619-011        | DEFAULT          | 1619ED2021  | 51              |
    | 1619              | AS-2021    | 1619-013        | DEFAULT          | 1619ED2021  | 18              |
    | 1619              | AS-2021    | 1619-020        | DEFAULT          | 1619ED2021  | 52              |
    | 1619              | AS-2021    | 1619-021        | DEFAULT          | 1619ED2021  | 53              |
    | 1619              | AS-2021    | 1619-024        | DEFAULT          | 1619ED2021  | 149             |
    | 1619              | AS-2021    | 1619-024        | SSF              | 1619ED2021  | 151             |
    | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               |
    | NFF               | AS-2021    | NFF-001         | DEFAULT          | 1619ED2021  | 931             |
    | NFF               | AS-2021    | NFF-002         | DEFAULT          | 1619ED2021  | 87              |
    | NFF               | AS-2021    | NFF-003         | DEFAULT          | 1619ED2021  | 89              |
    | NFF               | AS-2021    | NFF-004         | DEFAULT          | 1619ED2021  | 119             |
    | NFF               | AS-2021    | NFF-005         | DEFAULT          | 1619ED2021  | 126             |
    | NFF               | AS-2021    | NFF-005         | SSF              | 1619ED2021  | 129             |
    | NFF               | AS-2021    | NFF-006         | DEFAULT          | 1619ED2021  | 127             |
    | NFF               | AS-2021    | NFF-006         | SSF              | 1619ED2021  | 130             |
    | NFF               | AS-2021    | NFF-007         | DEFAULT          | 1619ED2021  | 124             |
    | NFF               | AS-2021    | NFF-008         | DEFAULT          | 1619ED2021  | 120             |
    | NFF               | AS-2021    | NFF-008         | SSF              | 1619ED2021  | 121             |
    | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             |
    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             |
    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             |
    | NMSS              | AY-2021    | NMSS-001        | DEFAULT          | 1619ED2021  | 39              |
    | NMSS              | AY-2021    | NMSS-002        | DEFAULT          | 1619ED2021  | 15              |
    | NMSS              | AY-2021    | NMSS-003        | DEFAULT          | 1619ED2021  | 13              |
    | NMSS              | AY-2021    | NMSS-004        | DEFAULT          | 1619ED2021  | 49              |
    | NMSS              | AY-2021    | NMSS-005        | DEFAULT          | 1619ED2021  | 43              |
    | NMSS              | AY-2021    | NMSS-006        | DEFAULT          | 1619ED2021  | 118             |
    | NMSS              | AY-2021    | NMSS-007        | DEFAULT          | 1619ED2021  | 135             |
    | NMSS              | AY-2021    | NMSS-008        | DEFAULT          | 1619ED2021  | 140             |





    # Populate the stub with NLG (02IPP) data. Import FA1 and FA2

    # Change the date 
    Given the override date is '01/07/2020'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-2_4            | 2_4            | NLG                         | AS-2021            | 43848.00          |
    | Contracting    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-3_1            | 3_1            | NLG                         | AS-2021            | 36022.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017724-2_4   | 2_4                    | NLG-AS-2021-Contract-Provider-10017724-2_4            | 10017724      | Furth        | 02IPP           | 43848.00                  |
    | NLG-AS-2021-10017724-3_1   | 3_1                    | NLG-AS-2021-Contract-Provider-10017724-3_1            | 10017724      | Furth        | 02IPP           | 36022.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017724-2_4   | NLG-002         | 22211.00         | Payment         |
    | NLG-AS-2021-10017724-2_4   | NLG-003         | 21637.00         | Payment         |
    #
    | NLG-AS-2021-10017724-3_1   | NLG-002         | 14436.00         | Payment         |
    | NLG-AS-2021-10017724-3_1   | NLG-003         | 21586.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017724-2_4   | NLG-002         | FY-2021              | September              | 2020              | 5820.00                   |
    | NLG-AS-2021-10017724-2_4   | NLG-002         | FY-2021              | January                | 2021              | 2615.00                   |
    | NLG-AS-2021-10017724-2_4   | NLG-002         | FY-2021              | March                  | 2021              | 4229.00                   |
    | NLG-AS-2021-10017724-2_4   | NLG-002         | FY-2021              | May                    | 2021              | 5265.00                   |
    | NLG-AS-2021-10017724-2_4   | NLG-002         | FY-2021              | June                   | 2021              | 4282.00                   |
    | NLG-AS-2021-10017724-2_4   | NLG-003         | FY-2021              | August                 | 2020              | 5138.00                   |
    | NLG-AS-2021-10017724-2_4   | NLG-003         | FY-2021              | November               | 2020              | 5352.00                   |
    | NLG-AS-2021-10017724-2_4   | NLG-003         | FY-2021              | March                  | 2021              | 4711.00                   |
    | NLG-AS-2021-10017724-2_4   | NLG-003         | FY-2021              | April                  | 2021              | 2633.00                   |
    | NLG-AS-2021-10017724-2_4   | NLG-003         | FY-2021              | July                   | 2021              | 3803.00                   |
    #
    | NLG-AS-2021-10017724-3_1   | NLG-002         | FY-2021              | October                | 2020              | 3254.00                   |
    | NLG-AS-2021-10017724-3_1   | NLG-002         | FY-2021              | December               | 2020              | 5519.00                   |
    | NLG-AS-2021-10017724-3_1   | NLG-002         | FY-2021              | April                  | 2021              | 5663.00                   |
    | NLG-AS-2021-10017724-3_1   | NLG-003         | FY-2021              | August                 | 2020              | 3251.00                   |
    | NLG-AS-2021-10017724-3_1   | NLG-003         | FY-2021              | November               | 2020              | 3021.00                   |
    | NLG-AS-2021-10017724-3_1   | NLG-003         | FY-2021              | January                | 2021              | 4774.00                   |
    | NLG-AS-2021-10017724-3_1   | NLG-003         | FY-2021              | February               | 2021              | 2456.00                   |
    | NLG-AS-2021-10017724-3_1   | NLG-003         | FY-2021              | May                    | 2021              | 4346.00                   |
    | NLG-AS-2021-10017724-3_1   | NLG-003         | FY-2021              | June                   | 2021              | 3738.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '02/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling        | Awaiting Release  | 36022.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2021-Contract-Provider-10017724-3_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 36022.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | AS-2021 | NLG                         | 36022.00    | [NLG]           | ?                 | ?                                 |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-2_4              | 2_4            | AS-2021 | NLG                         | 43848.00    | ?               | Discarded         | Superseded                        |





    # Populate the stub with NLG (02IPP) data. Import FA3

    # Change the date 
    Given the override date is '03/07/2020'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-5_1            | 5_1            | NLG                         | AS-2021            | 29776.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017724-5_1   | 5_1                    | NLG-AS-2021-Contract-Provider-10017724-5_1            | 10017724      | Furth        | 02IPP           | 29776.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017724-5_1   | NLG-001         | 5680.00          | Payment         |
    | NLG-AS-2021-10017724-5_1   | NLG-003         | 24096.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017724-5_1   | NLG-001         | FY-2021              | January                | 2021              | 2306.00                   |
    | NLG-AS-2021-10017724-5_1   | NLG-001         | FY-2021              | May                    | 2021              | 3374.00                   |
    #
    | NLG-AS-2021-10017724-5_1   | NLG-003         | FY-2021              | October                | 2020              | 3906.00                   |
    | NLG-AS-2021-10017724-5_1   | NLG-003         | FY-2021              | January                | 2021              | 6000.00                   |
    | NLG-AS-2021-10017724-5_1   | NLG-003         | FY-2021              | February               | 2021              | 3719.00                   |
    | NLG-AS-2021-10017724-5_1   | NLG-003         | FY-2021              | May                    | 2021              | 4685.00                   |
    | NLG-AS-2021-10017724-5_1   | NLG-003         | FY-2021              | July                   | 2021              | 5786.00                   |
 


    

    # Consume stub data
 
    # Change the date 
    Given the override date is '04/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling        | Awaiting Release  | 36022.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG]             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-5_1              | 5_1            | AS-2021 | NLG                         | 29776.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | AS-2021 | NLG                         | 36022.00    | [NLG]           | ?                 | ?                                 |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-2_4              | 2_4            | AS-2021 | NLG                         | 43848.00    | ?               | Discarded         | Superseded                        |
  




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2020'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG]             |

    # Write the value of the ReleaseGroupParameter to the output window
    And   message 'ReleaseGroup NLG = [NLG]' is written to the Output window

    # Check the state of a Release Group (J129) 
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 36022.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017724' for FundingType 'NLG' and period '2021'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017724' for FundingType 'NLG' and period '2021' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Released          | Released          | 36022.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | AS-2021 | NLG                         | 36022.00    | [NLG]           | ?                 | ?                                 |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-2_4              | 2_4            | AS-2021 | NLG                         | 43848.00    | ?               | Discarded         | Superseded                        |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2021-Contract-Provider-10017724-3_1              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017724 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017724 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017724 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 36022.00      | 1                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017724 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017724 | [MasterContractNo] | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017724 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017724 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 36022.00        | ?             | ?                | 01/08/2020 | 31/07/2021 | NLG           | NLG2021             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 101             | 14436.00  | 0.00     | 0.00     | 3254.00  | 0.00     | 5519.00  | 0.00     | 0.00     | 0.00     | 5663.00  | 0.00     | 0.00     | 0.00     | Principals Reference Group (PRG)                            |                          |
    | [ContractNo]   | [AllocRef_NLG]  | 102             | 21586.00  | 3251.00  | 0.00     | 0.00     | 3021.00  | 0.00     | 4774.00  | 2456.00  | 0.00     | 0.00     | 4346.00  | 3738.00  | 0.00     | National Leaders of Further Education (NLFE)                |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#   # Check the contents of the Appendices
#   And   the file named '10017724_[ContractNo]_v1.pdf' in Sharepoint location 'NLG-2021-Input-Appendices' contains the following lines in order
#   """
#   blah
#   """
#
#   # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017724_[ContractNo]_v1.pdf' in 'NLG-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A724.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2020-07-13 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017724'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017724 - 10017724 Co Ltd Awaiting documentation  | [AllocRef_NLG]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017724 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017724 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017724 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Populate the stub with NLG (02IPP) data. Import FA4

    # Change the date 
    Given the override date is '06/07/2020'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-6_2            | 6_2            | NLG                         | AS-2021            | 22418.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017724-6_2   | 6_2                    | NLG-AS-2021-Contract-Provider-10017724-6_2            | 10017724      | Furth        | 02IPP           | 22418.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017724-6_2   | NLG-001         | 9960.00          | Payment         |
    | NLG-AS-2021-10017724-6_2   | NLG-002         | 12458.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017724-6_2   | NLG-001         | FY-2021              | September              | 2020              | 4166.00                   |
    | NLG-AS-2021-10017724-6_2   | NLG-001         | FY-2021              | February               | 2021              | 3765.00                   |
    | NLG-AS-2021-10017724-6_2   | NLG-001         | FY-2021              | April                  | 2021              | 2029.00                   |
    #
    | NLG-AS-2021-10017724-6_2   | NLG-002         | FY-2021              | November               | 2020              | 4053.00                   |
    | NLG-AS-2021-10017724-6_2   | NLG-002         | FY-2021              | December               | 2020              | 3754.00                   |
    | NLG-AS-2021-10017724-6_2   | NLG-002         | FY-2021              | May                    | 2021              | 4651.00                   |
 

 


    # Consume stub data. FA3 is Discarded\Superseded
 
    # Change the date 
    Given the override date is '07/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-6_2              | 6_2            | AS-2021 | NLG                         | 22418.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-5_1              | 5_1            | AS-2021 | NLG                         | 29776.00    | ?               | Discarded         | Superseded                        |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | AS-2021 | NLG                         | 36022.00    | [NLG]           | ?                 | ?                                 |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-2_4              | 2_4            | AS-2021 | NLG                         | 43848.00    | ?               | Discarded         | Superseded                        |

    # Check the CRM Funding Allocations data (J125) 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Released          | Released          | 36022.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |





    # Publish and approve the contract

    # Change the date 
    Given the override date is '08/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber '[MasterContractNo]' and actual ContractNumber '[ContractNo]'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017724 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017724 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Populate the stub with NLG (02IPP) data. Import FA5 and FA6

    # Change the date 
    Given the override date is '09/07/2020'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-8_1            | 8_1            | NLG                         | AS-2021            | 17030.00          |
    | Contracting    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-9_4            | 9_4            | NLG                         | AS-2021            | 29157.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10017724-8_1   | 8_1                    | NLG-AS-2021-Contract-Provider-10017724-8_1            | 10017724      | Furth        | 02IPP           | 17030.00                  |
    | NLG-AS-2021-10017724-9_4   | 9_4                    | NLG-AS-2021-Contract-Provider-10017724-9_4            | 10017724      | Furth        | 02IPP           | 29157.00                  |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10017724-8_1   | NLG-001         | 11435.00         | Payment         |
    | NLG-AS-2021-10017724-8_1   | NLG-003         | 5595.00          | Payment         |
    #
    | NLG-AS-2021-10017724-9_4   | NLG-002         | 22390.00         | Payment         |
    | NLG-AS-2021-10017724-9_4   | NLG-003         | 6767.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10017724-8_1   | NLG-001         | FY-2021              | August                 | 2020              | 3484.00                   |
    | NLG-AS-2021-10017724-8_1   | NLG-001         | FY-2021              | January                | 2021              | 2501.00                   |
    | NLG-AS-2021-10017724-8_1   | NLG-001         | FY-2021              | June                   | 2021              | 5450.00                   |
    | NLG-AS-2021-10017724-8_1   | NLG-003         | FY-2021              | September              | 2020              | 5595.00                   |
    #
    | NLG-AS-2021-10017724-9_4   | NLG-002         | FY-2021              | August                 | 2020              | 4958.00                   |
    | NLG-AS-2021-10017724-9_4   | NLG-002         | FY-2021              | October                | 2020              | 2368.00                   |
    | NLG-AS-2021-10017724-9_4   | NLG-002         | FY-2021              | January                | 2021              | 2138.00                   |
    | NLG-AS-2021-10017724-9_4   | NLG-002         | FY-2021              | March                  | 2021              | 3890.00                   |
    | NLG-AS-2021-10017724-9_4   | NLG-002         | FY-2021              | April                  | 2021              | 5573.00                   |
    | NLG-AS-2021-10017724-9_4   | NLG-002         | FY-2021              | July                   | 2021              | 3463.00                   |
    | NLG-AS-2021-10017724-9_4   | NLG-003         | FY-2021              | January                | 2021              | 3584.00                   |
    | NLG-AS-2021-10017724-9_4   | NLG-003         | FY-2021              | February               | 2021              | 3183.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '10/07/2020'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG2                      |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-9_4              | 9_4            | AS-2021 | NLG                         | 29157.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-8_1              | 8_1            | AS-2021 | NLG                         | 17030.00    | ?               | Discarded         | Superseded                        |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-6_2              | 6_2            | AS-2021 | NLG                         | 22418.00    | [NLG2]          | ?                 | ?                                 |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-5_1              | 5_1            | AS-2021 | NLG                         | 29776.00    | ?               | Discarded         | Superseded                        |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | AS-2021 | NLG                         | 36022.00    | [NLG]           | ContractApproved  | ContractApproved                  |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-2_4              | 2_4            | AS-2021 | NLG                         | 43848.00    | ?               | Discarded         | Superseded                        |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-6_2              | 6_2            | Non-learning Grants          | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling         | Awaiting Release        | 22418.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG2]          |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | Non-learning Grants          | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Contract Approved  | Contract Approved       | 36022.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |





    # Withdraw FA4 (v6_2)
 
    # Change the date 
    Given the override date is '11/07/2020'
    
    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Test A724'
    | FundingId                                    | 
    | NLG-AS-2021-Contract-Provider-10017724-6_2   | 

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-9_4              | 9_4            | AS-2021 | NLG                         | 29157.00    | [NLG2]          | ?                 | ?                                 |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-8_1              | 8_1            | AS-2021 | NLG                         | 17030.00    | ?               | Discarded         | Superseded                        |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-6_2              | 6_2            | AS-2021 | NLG                         | 22418.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-5_1              | 5_1            | AS-2021 | NLG                         | 29776.00    | ?               | Discarded         | Superseded                        |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | AS-2021 | NLG                         | 36022.00    | [NLG]           | ContractApproved  | ContractApproved                  |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-2_4              | 2_4            | AS-2021 | NLG                         | 43848.00    | ?               | Discarded         | Superseded                        |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-9_4              | 9_4            | Non-learning Grants          | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling         | Awaiting Release        | 29157.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG2]          |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-6_2              | 6_2            | Non-learning Grants          | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Withdrawn          | Withdrawn               | 22418.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | Non-learning Grants          | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Contract Approved  | Contract Approved       | 36022.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |





    # Execute a NON-FINANCIAL amendment 

    # Change the date
    Given the override date is '12/07/2020'

    # Issue a non-financial VARIATION amendment on v1 to create v2.
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017724 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017724 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017724 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '13/07/2020'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG2]            |
 
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-9_4              | 9_4            | AS-2021 | NLG                         | 29157.00    | [NLG2]          | ?                 | ?                                 |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-8_1              | 8_1            | AS-2021 | NLG                         | 17030.00    | ?               | Discarded         | Superseded                        |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-6_2              | 6_2            | AS-2021 | NLG                         | 22418.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-5_1              | 5_1            | AS-2021 | NLG                         | 29776.00    | ?               | Discarded         | Superseded                        |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | AS-2021 | NLG                         | 36022.00    | [NLG]           | ContractApproved  | ContractApproved                  |
    | 10017724 | NLG-AS-2021-Contract-Provider-10017724-2_4              | 2_4            | AS-2021 | NLG                         | 43848.00    | ?               | Discarded         | Superseded                        |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-9_4              | 9_4            | Non-learning Grants          | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Released           | Released                | 29157.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG2]          |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-6_2              | 6_2            | Non-learning Grants          | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Withdrawn          | Withdrawn               | 22418.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               |
    | 10017724 | 10017724 Co Ltd  | NLG-AS-2021-Contract-Provider-10017724-3_1              | 3_1            | Non-learning Grants          | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Contract Approved  | Contract Approved       | 36022.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017724 | [ContractNo]       | 2                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017724 | [ContractNo]       | 2                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017724 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017724 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Tidy Up
    And the override date is reset   
       
