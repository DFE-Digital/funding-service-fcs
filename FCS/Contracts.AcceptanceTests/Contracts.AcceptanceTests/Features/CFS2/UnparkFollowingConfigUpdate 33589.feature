Feature: UnparkFollowingConfigUpdate 33589

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A174 Import and park an NLG FA. Adjust config and attempt an un-park 3x failing each time. Reset config. Unpark successfully. Release RG. Publish and approve contract. Check PaaS, CRM and Feed. 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017174'
    And   there is no Funding Allocation data in CRM for UKPRN '10017174'
    And   there is no Contract, Task or Workflow data for UKPRN '10017174'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017174'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017174'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017174' in the Sharepoint 'NLG-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017174' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017174 Co Ltd' with UKPRN '10017174' and OrgId 'ORG0017174' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017174' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017174 | 117174 | 10017174 Co Ltd | 0              | Locked Restructure    | Yes           | AA017174      | ?             | 12-50 Kingsgate Road   | Kingston upon Thames   | Surrey                 | ?                      | ?                      | ?                      | KT2 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017174 |





    # 1. Remove NLG from config

    # Change the date 
    Given the override date is '01/06/2021'

    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | DADA                        | AS-2122            | DADA            | AY2122            | DADA2122     | 
 #  | NLG                         | AS-2122            | NLG             | AY2122            | NLG2122      | 

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2122            | DEFAULT          | Contract for Services                     | 
 #  | NLG             | AY2122            | DEFAULT          | Non-learning Grant                        | 

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
    | DADA              | AS-2122    | DADA-001        | DEFAULT          | DADA2122    | 1               | 
 #  | NLG               | AS-2122    | NLG-001         | DEFAULT          | NLG2122     | 116             | 





    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '02/06/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017174 | NLG-AS-2122-Contract-Provider-10017174-2_2            | 2_2            | NLG                         | AS-2122            | 5716.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017174-2_2   | 2_2                    | NLG-AS-2122-Contract-Provider-10017174-2_2            | 10017174      | Furth        | 02IPP           | 5716.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017174-2_2   | NLG-001         | 5716.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017174-2_2   | NLG-001         | FY-2122              | October                | 2021              | 2324.00                   |
    | NLG-AS-2122-10017174-2_2   | NLG-001         | FY-2122              | February               | 2022              | 3392.00                   |

  
    # Consume the stub data and park FA: AwaitingFundingAllocationConfig

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                       |
    | 10017174 | NLG-AS-2122-Contract-Provider-10017174-2_2              | 2_2            | AS-2122 | NLG                         | 5716.00     | ?               | Parked            | AwaitingFundingAllocationConfig |





    # 2. Include NLG in config but remove ProviderSubType 02IPP

    # Change the date
    Given the override date is '03/06/2021'

    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | DADA                        | AS-2122            | DADA            | AY2122            | DADA2122     | 
    | NLG                         | AS-2122            | NLG             | AY2122            | NLG2122      | 

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2122            | DEFAULT          | Contract for Services                     | 
    | NLG             | AY2122            | DEFAULT          | Non-learning Grant                        | 

    # Load FundingAllocation.ProviderTypeConfig (J143)
    And   the following data replaces that currently in FundingAllocation.ProviderTypeConfig
    | ProviderType    | ProviderSubType   | ProviderCategory | 
    | Furth           | 01GFE             | College          | 
 #  | Furth           | 02IPP             | ITP              | 
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
    | DADA              | AS-2122    | DADA-001        | DEFAULT          | DADA2021    | 1               | 
    | NLG               | AS-2122    | NLG-001         | DEFAULT          | NLG2122     | 116             | 


    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
    When  the job to review parked Funding Allocations against the latest version of config is run 

    # Check PaaS FundingAllocation.FundingAllocation (J131)   Substatus should change from 'AwaitingFundingAllocationConfig' to 'AwaitingContractTypeConfig'
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                       |
    | 10017174 | NLG-AS-2122-Contract-Provider-10017174-2_2              | 2_2            | AS-2122 | NLG                         | 5716.00     | ?               | Parked            | AwaitingContractTypeConfig      |





    # 3. Include 02IPP in config but remove FundingLineCode NLG-001

    # Change the date
    Given the override date is '04/06/2021'

    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | DADA                        | AS-2122            | DADA            | AY2122            | DADA2122     | 
    | NLG                         | AS-2122            | NLG             | AY2122            | NLG2122      | 

    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    And   the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              | 
    | DADA            | AY2122            | DEFAULT          | Contract for Services                     | 
    | NLG             | AY2122            | DEFAULT          | Non-learning Grant                        | 

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
    | DADA              | AS-2122    | DADA-001        | DEFAULT          | DADA2122    | 1               | 
 #  | NLG               | AS-2122    | NLG-001         | DEFAULT          | NLG2122     | 116             | 


    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
    When  the job to review parked Funding Allocations against the latest version of config is run 

    # Check PaaS FundingAllocation.FundingAllocation (J131)   Substatus should change from 'AwaitingContractTypeConfig' to 'AwaitingFundingLineConfig'
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                       |
    | 10017174 | NLG-AS-2122-Contract-Provider-10017174-2_2              | 2_2            | AS-2122 | NLG                         | 5716.00     | ?               | Parked            | AwaitingFundingLineConfig       |





    # 4. Attempt a further 'unpark' without changing config.  Substatus should be unchanged

    # Change the date
    Given the override date is '05/06/2021'

    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
    When  the job to review parked Funding Allocations against the latest version of config is run 

    # Check PaaS FundingAllocation.FundingAllocation (J131)   Substatus should saty at 'AwaitingFundingLineConfig'
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                       |
    | 10017174 | NLG-AS-2122-Contract-Provider-10017174-2_2              | 2_2            | AS-2122 | NLG                         | 5716.00     | ?               | Parked            | AwaitingFundingLineConfig       |





    # 5. Reset config to its true 'base' state then attempt a further 'unpark' - which should succeed

    # Change the date
    Given the override date is '06/06/2021'

    # Refresh the CFS config tables back to that defined in the config spreadsheet (J137)
    And   the current base CFS config has been loaded

    # Run the job which reviews parked Funding Allocations after config is deployed (J138)
    When  the job to review parked Funding Allocations against the latest version of config is run 


   
    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      | NLG                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017174 | 10017174 Co Ltd  | NLG-AS-2122-Contract-Provider-10017174-2_2              | 2_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 5716.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017174-2_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 5716.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017174 | NLG-AS-2122-Contract-Provider-10017174-2_2              | 2_2            | AS-2122 | NLG                         | 5716.00     | [NLG]           | ?                 | ?                     |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '07/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG]             |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 5716.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017174' for FundingType 'NLG' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017174' for FundingType 'NLG' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017174 | 10017174 Co Ltd  | NLG-AS-2122-Contract-Provider-10017174-2_2              | 2_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Released          | Released          | 5716.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017174-2_2              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NLG-AS-2122-Contract-Provider-10017174-2_2              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NLG-AS-2122-Contract-Provider-10017174-2_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017174 | NLG-AS-2122-Contract-Provider-10017174-2_2              | 2_2            | AS-2122 | NLG                         | 5716.00     | [NLG]           | ?                 | ?                     |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017174-2_2              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017174 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017174 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017174 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 5716.00       | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017174 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017174 | [MasterContractNo] | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017174 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017174 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 5716.00         | ?             | ?                | 01/08/2021 | 31/07/2022 | NLG           | NLG2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                    | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 5716.00   | 0.00     | 0.00     | 2324.00  | 0.00     | 0.00     | 0.00     | 3392.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Isles of Scilly: Boarding and Accommodation Grant  |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#   # Check the contents of the Appendices
#   And   the file named '10017174_[ContractNo]_v1.pdf' in Sharepoint location 'NLG-2122-Input-Appendices' contains the following lines in order
#   """
#   blah
#   """
#
#   # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017174_[ContractNo]_v1.pdf' in 'NLG-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A174.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-06-07 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017174'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017174 - 10017174 Co Ltd Awaiting documentation  | [AllocRef_NLG]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017174 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017174 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017174 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '08/06/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Approve the contract

    # Change the date 
    Given the override date is '09/06/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017174 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017174 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017174 | 10017174 Co Ltd  | NLG-AS-2122-Contract-Provider-10017174-2_2              | 2_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Contract Approved | Contract Approved | 5716.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [NLG]           |
    
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017174 | NLG-AS-2122-Contract-Provider-10017174-2_2              | 2_2            | AS-2122 | NLG                         | 5716.00     | [NLG]           | ContractApproved  | ContractApproved      |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017174-2_2              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription      |
    | 10017174 | [ContractNo]   | 1               | [AllocRef_NLG]   | 116             | 0                     | 5716.00      | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant  | ?                           |


    # Tidy Up
    And   the override date is reset

 