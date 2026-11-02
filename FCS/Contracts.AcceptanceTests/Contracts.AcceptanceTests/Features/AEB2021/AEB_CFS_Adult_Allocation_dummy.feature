Feature: AEB_CFS_Adult_Allocation_dummy


@AcceptanceTest @Withdrawn20260521
@CFS
Scenario: S047 Create an AEB-AS2324 contract with 2 bulk deliverables. Inject AEB-AS2324 deliverable 116 from CFS. Release, publish and approve. NFA. CDA. PoP payment batch. Check docs, financials, Feed and reports
  Given there are no allocations marked as Under Termination for UKPRN '10018047' 
    And   there are no terminated or closed allocations for UKPRN '10018047' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018047'
    And   there is no Funding Allocation data in CRM for UKPRN '10018047'
    And   there is no Contract, Task or Workflow data for UKPRN '10018047' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018047' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018047' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    ## Clear down subnominal data from CRM and PaaS for an allocation
    #And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    #| AllocationRef |
    #| [AllocRef_AEBA]		|

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018047' in the Sharepoint 'AEB2021-2324-Input-Appendices' folder

    ## Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    #And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    #| AllocationRef |
    #| [AllocRef_AEBA]   	|

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | AEB-AS2324    |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | [ContractNo]     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018047'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | AEB2021         | AY2324        | AEB2021_2324 | Contract for Services                   |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10018047' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018047 Co Ltd' with UKPRN '10018047' and OrgId 'ORG0018047' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10018047' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018047 | 018047 | 10018047 Co Ltd | 0              | Active                | Yes           | AA018047      | ?             | Church Gates           | The Wilds         	 | ?                      | ?                      | Berkhamsted            | Hertfordshire          | HP4 2UF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018047 |




#
#    # Change the date
#    Given the override date is '01/07/2023'
#
#    # Remove all contract details from ContractManagement.CreatedContract
# #  And   there are no created contracts for this number '[ContractNo] '
#    And   there are no details in ContractManagement.CreatedContract for '[ContractNo] '
#
#    # Create contract 
#    And   the draft contract header details for the latest version of the contract are as follows 
#    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
#    | 10018047 | 10018047 Co Ltd      | [MasterContractNo]            | [ContractNo]     | 1                     | 01/08/2023        | 31/07/2024      | 48607.00      |                                       | Contract for Services                      | 2324   | New          | ORG0018047 |
#
#    And   the draft contract allocations details for the latest version of the contract are as follows
#    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
#    | 10018047 | [ContractNo]     | [AllocRef_AEBA]   	| AEB-AS            | AEB-AS2324              | AY                      | 01/08/2023          | 31/07/2024        | 48607.00        |                                         |            |                                                             | New          |             |
#
#    And   the draft contract deliverables details for the latest version of the contract are as follows
#    | UKPRN    | ContractNumber   | AllocationRef 	| DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableDescription                      | CRMIntent    | DeliveryOrg |
#    | 10018047 | [ContractNo]       | [AllocRef_AEBA]       | 4               | 0                     | 24942.00  | 16636.00  | 8306.00   | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | Adult Skills                                | New          |             | 
#    | 10018047 | [ContractNo]       | [AllocRef_AEBA]       | 5               | 0                     | 23665.00  | 18253.00  | 5412.00   | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | Adult Skills Learner Support                | New          |             | 
#
#    And   the contract exists in CRM
#    # Contract status is now at 'Awaiting Documentation'
#
#    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
#    #   Note: Documents are created using the system date. The following step 'corrects' this
#    And   the following document creation details exist in the ContractManagement.CreatedContract table
#    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
#    | [ContractNo]     | 1                     | 0                        | 2023-07-01 09:12:35.000 |





    # Populate the stub with AEB-AS (02IPP) data

    # Change the date 
    Given the override date is '02/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018047 | AEB-AS-AY-2324-Contract-Provider-10018047-2_4         | 2_4            | AEB-AS                      | AY-2324            | 37320.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | AEB-AS-AY-2324-10018047-2_4  | 2_4                    | AEB-AS-AY-2324-Contract-Provider-10018047-2_4       | 10018047      | Furth        | 07HEP           | 37320.00                  |

    ## Provider Funding Allocation
    #And   the following Provider Funding Agreement data is present in the CFS stub
    #| ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    #| AEB-AS-AY-2324-10018047-2_4  | 2_4                    | AEB-AS-AY-2324-Contract-Provider-10018047-2_4       | 10018047      | Local        | 10LAU           | 37320.00                  |
    #
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | AEB-AS-AY-2324-10018047-2_4| AEB-001         | 18665.00         | Payment         |
    | AEB-AS-AY-2324-10018047-2_4| AEB-002         | 18655.00         | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-001         | FY-2324              | August                 | 2023              | 25.00                     |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-001         | FY-2324              | September              | 2023              | 3447.00                   |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-001         | FY-2324              | January                | 2024              | 5271.00                   |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-001         | FY-2324              | March                  | 2024              | 2648.00                   |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-001         | FY-2324              | April                  | 2024              | 4610.00                   |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-001         | FY-2324              | July                   | 2024              | 2664.00                   |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-002         | FY-2324              | August                 | 2023              | 25.00                     |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-002         | FY-2324              | September              | 2023              | 3417.00                   |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-002         | FY-2324              | January                | 2024              | 5271.00                   |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-002         | FY-2324              | March                  | 2024              | 2608.00                   |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-002         | FY-2324              | April                  | 2024              | 4640.00                   |
    | AEB-AS-AY-2324-10018047-2_4   | AEB-002         | FY-2324              | July                   | 2024              | 2694.00                   |

 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | AEB2021         | AY2324        | AEB2021_2324 | Contract for Services                   | CfS                    |


    #Given the Release Group for the following Contracting Profile has been saved
    #| FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    #| AEB2021         | AY2324        | AEB2021_2324 | Conditions of Funding (Grant) (LA)      | Cofg(LA)                  |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                                                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10018047 | 10018047 Co Ltd  | AEB-AS-AY-2324-Contract-Provider-10018047-2_4           | 2_4            | Adult Education Budget - 2021 Procurement                    | AY2324  | Contract for Services                    | AEB-AS                      | AEB2021_2324    | Scheduling        | Awaiting Release  | 37320.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB-AS-AY-2324-Contract-Provider-10018047-2_4           | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 37320.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018047 | AEB-AS-AY-2324-Contract-Provider-10018047-2_4           | 2_4            | AY-2324 | AEB-AS                      | 37320.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2023'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS = [CfS]' is written to the Output window


    Then wait '20' seconds
#
    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 37320.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018047' for FundingType 'AEB2021' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018047' for FundingType 'Adult Education Budget - 2021 Procurement' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                                                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10018047 | 10018047 Co Ltd  | AEB-AS-AY-2324-Contract-Provider-10018047-2_4           | 2_4            | Adult Education Budget - 2021 Procurement                    | AY2324  | Contract for Services                    | AEB-AS                      | AEB2021_2324    | Released          | Released          | 37320.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB-AS-AY-2324-Contract-Provider-10018047-2_4              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | AEB-AS-AY-2324-Contract-Provider-10018047-2_4              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | AEB-AS-AY-2324-Contract-Provider-10018047-2_4              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018047 | AEB-AS-AY-2324-Contract-Provider-10018047-2_4           | 2_4            | AY-2324 | AEB-AS                      | 18665.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | AEB-AS-AY-2324-Contract-Provider-10018047-2_4           | [ContractNo] | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018047 | [ContractNo]       | 1                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018047 | [ContractNo]       | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018047 | [ContractNo]       | Adult Education Budget - 2021 Procurement                    | Contract      | Draft          | Awaiting Documentation  | 67272.00      | 1                     | 1                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Contract for Services                        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo]           | AY2324 | ?               | 10018047 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018047 | [MasterContractNo] | Adult Education Budget - 2021 Procurement                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Contract for Services                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018047 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018047 | [ContractNo]       | [AllocRef_AEBA]       | ?                             | 18665.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | AEB-AS        | AEB-AS2324          | Contract Allocation   | ?                        |

#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                             | DeliverableDescription   |
#    | [ContractNo]     | [AllocRef_AEBA]       | 101             | 24942.00  | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | Principals Reference Group (PRG)                            |                          | 
#    | [ContractNo]     | [AllocRef_AEBA]       | 102             | 23665.00  | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | National Leaders of Further Education (NLFE)                |                          | 
#    | [ContractNo]     | [AllocRef_AEBA]       | 116             | 18665.00  | 25.00    | 3417.00  | 0.00     | 0.00     | 0.00     | 5271.00  | 0.00     | 2648.00  | 4640.00  | 0.00     | 0.00     | 2664.00  | Isles of Scilly: Boarding and Accommodation Grant           |                          |
#



#
#    # Contract status is now at 'Awaiting Documentation'
#
#    ## Check the deliverable count in CRM
#    #Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo] '
#
#    # Check the contents of the Appendices
#    And   the file named '10018034_NONLG-8034_v1.pdf' in Sharepoint location 'AEB2021-2324-Input-Appendices' contains the following lines in order
#    """
#    Annex H – Grant payment schedule
#    Provider: 10018047 Co Ltd UKPRN: 10018047
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
#    Contract Ref: [AllocRef_AEBA]
#    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
#    Principals Reference Group (PRG) £24,942 £562 £2,657 £2,791 £1,407 £2,840 £3,225 £102 £3,052 £1,605 £2,247 £2,286 £2,168
#    National Leaders of Further Education (NLFE) £23,665 £448 £2,098 £2,582 £3,096 £1,555 £2,479 £2,424 £3,571 £131 £329 £3,437 £1,515
#    Isles of Scilly: Boarding and Accommodation Grant £18,665 £25 £3,417 £0 £0 £0 £5,271 £0 £2,648 £4,640 £0 £0 £2,664
#    Total Funding £67,272 £1,035 £8,172 £5,373 £4,503 £4,395 £10,975 £2,526 £9,271 £6,376 £2,576 £5,723 £6,347
#    23/24 AEB2021 – [AllocRef_AEBA] – Page 1 Ref (for internal use only):  [ContractNo]  v1
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018047_[ContractNo]_v1.pdf' in 'AEB2021-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S047.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-08 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018047'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018047 - 10018047 Co Ltd Awaiting documentation  | [AllocRef_AEBA] | Document Management Team  | ?                | Open       | Not Started   |

#    # Check the CRM Contract Workflow History data
#    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
#    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
#    | 10018047 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#    | 10018047 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#    | 10018047 | [MasterContractNo]          | [ContractNo]      | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#
#



    # Publish the contract

    # Change the date 
    Given the override date is '11/07/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'




    # Approve the contract

    # Change the date 
    Given the override date is '14/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo] ' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018047 | [ContractNo]       | 1                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                                      | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10018047 | 10018047 Co Ltd  | AEB-AS-AY-2324-Contract-Provider-10018047-2_4           | 2_4            | Adult Education Budget - 2021 Procurement        | AY2324  | Contract for Services                    | AEB-AS                         | AEB2021_2324         | Contract Approved | Contract Approved | 18665.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018047 | AEB-AS-AY-2324-Contract-Provider-10018047-2_4           | 2_4            | AY-2324 | AEB-AS                      | 18665.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB-AS-AY-2324-Contract-Provider-10018047-2_4           | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo] ' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription      |
    | 10018047 | [ContractNo]       | 1               | [AllocRef_AEBA]          | 101             | 0                     | 24942.00     | 0             | 0        | Principals Reference Group (PRG)                   | ?                           |
    | 10018047 | [ContractNo]       | 1               | [AllocRef_AEBA]          | 102             | 0                     | 23665.00     | 0             | 0        | National Leaders of Further Education (NLFE)       | ?                           |
    | 10018047 | [ContractNo]       | 1               | [AllocRef_AEBA]          | 116             | 0                     | 18665.00     | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant  | ?                           |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo] '    
    
    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | [AllocRef_AEBA]       | 2208100         | Jul-24 | Profile        |





    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]       | [AllocRef_AEBA]            | 101             | 24942.00  | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | 
    | [ContractNo]       | [AllocRef_AEBA]            | 102             | 23665.00  | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | 
    | [ContractNo]       | [AllocRef_AEBA]            | 116             | 18665.00  | 25.00    | 3417.00  | 0.00     | 0.00     | 0.00     | 5271.00  | 0.00     | 2648.00  | 4640.00  | 0.00     | 0.00     | 2664.00  | 
    #                                                       £ 67272.00

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]       | [AllocRef_AEBA]            | 101             | 24942.00  | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | 
    | [ContractNo]       | [AllocRef_AEBA]            | 102             | 23665.00  | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | 
    | [ContractNo]       | [AllocRef_AEBA]            | 116             | 18665.00  | 25.00    | 3417.00  | 0.00     | 0.00     | 0.00     | 5271.00  | 0.00     | 2648.00  | 4640.00  | 0.00     | 0.00     | 2664.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]       | [AllocRef_AEBA]            | 101             | 24942.00  | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | 
    | [ContractNo]       | [AllocRef_AEBA]            | 102             | 23665.00  | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | 
    | [ContractNo]       | [AllocRef_AEBA]            | 116             | 18665.00  | 25.00    | 3417.00  | 0.00     | 0.00     | 0.00     | 5271.00  | 0.00     | 2648.00  | 4640.00  | 0.00     | 0.00     | 2664.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef  | ProfileSubnominal | Aug-23    | Sep-23    | Oct-23    | Nov-23    | Dec-23    | Jan-24    | Feb-24    | Mar-24    | Apr-24    | May-24    | Jun-24    | Jul-24    |
    | 10018047 | [ContractNo]       | [AllocRef_AEBA]        | 2208100           | 562.00    | 2657.00   | 2791.00   | 1407.00   | 2840.00   | 3225.00   | 102.00    | 3052.00   | 1605.00   | 2247.00   | 2286.00   | 2168.00   | 
    | 10018047 | [ContractNo]       | [AllocRef_AEBA]        | 2208200           | 448.00    | 2098.00   | 2582.00   | 3096.00   | 1555.00   | 2479.00   | 2424.00   | 3571.00   | 131.00    | 329.00    | 3437.00   | 1515.00   | 
    | 10018047 | [ContractNo]       | [AllocRef_AEBA]        | 2202070           | 25.00     | 3417.00   | 0.00      | 0.00      | 0.00      | 5271.00   | 0.00      | 2648.00   | 4640.00   | 0.00      | 0.00      | 2664.00   | 



    


    # CDA
    
    # Change the date
    Given the override date is '22/07/2023'
#
#    # Run the CDA report
    Given there is no CDA report named 'CDA Last Approved Version S047.csv'

    #And   the following contracts are in the replicated CRM database
    #| ContractNumber | ContractVersionNumber |
    #| [ContractNo]       | 1                    |

    When  the following CDA report is run
    | FundingStreamPeriod   | Version               | Suffix |
    | AEB-AS2324            | Last Approved Version | S047   |

    Then  a report named 'CDA Last Approved Version S047.csv' is created

    # Check the contents of the CDA Report manually 

    

    
    
    # Payment Batch for AEB-AS2324(PoP)

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-AS2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_AEBA]                | 202308 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-AS2324                 | 202308               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-AS2324                 | 202308               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-AS2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S047.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-AS2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEB-AS                    | 2023          | 05             | 02          | ?       | [AllocRef_AEBA]           | 562.00          | PROFILE          | Principals Ref Group               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018047 | 2208100    |
    | AEB-AS                    | 2023          | 05             | 02          | ?       | [AllocRef_AEBA]           | 448.00          | PROFILE          | NationalLeadrs of FE               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018047 | 2208200    |
    | AEB-AS                    | 2023          | 05             | 02          | ?       | [AllocRef_AEBA]           | 25.00           | PROFILE          | Isles of Scilly                    | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018047 | 2202070    |



#
#    # Consolidated Payment Summary Report
#
#    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#    When a Consolidated Payment Summary Report is created in Sharepoint for '02/08/2023'
#
#    # Check the contents of the Consolidated Payment Summary Report manually

    
   #  Part 10: Create Consolidated Payment Summary rpt
   
   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
   Given there are no files prefixed '2023-08 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder

   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '03/08/2023'
    # Check the above report manually

    
   



    # NFA amendment

    # Change the date
    Given the override date is '18/08/2023'

    # Issue a non-financial amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract '[ContractNo] ' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018047 | [ContractNo]           | 2                     | 0                        | Draft            | Awaiting Documentation  | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10018047 | [ContractNo]           | 1                     | 1                        | Approved         | Approved                | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018047 | [MasterContractNo]     | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the contents of the Appendices
    And   the file named '10018034_EDSK-8034_v2.pdf' in Sharepoint location 'AEB-AY-2324-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10018047 Co Ltd UKPRN: 10018047
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Principals Reference Group (PRG) £24,942 £562 £2,657 £2,791 £1,407 £2,840 £3,225 £102 £3,052 £1,605 £2,247 £2,286 £2,168
    National Leaders of Further Education (NLFE) £23,665 £448 £2,098 £2,582 £3,096 £1,555 £2,479 £2,424 £3,571 £131 £329 £3,437 £1,515
    Isles of Scilly: Boarding and Accommodation Grant £18,665 £25 £3,417 £0 £0 £0 £5,271 £0 £2,648 £4,640 £0 £0 £2,664
    Total Funding £67,272 £1,035 £8,172 £5,373 £4,503 £4,395 £10,975 £2,526 £9,271 £6,376 £2,576 £5,723 £6,347
    23/24 AEB2021 – [AllocRef_AEBA] – Page 1 Ref (for internal use only):  [ContractNo]  v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018034_EDSK-8034_v2.pdf' in 'AEB-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S034v2.pdf'




    # Tidy Up
    Given the override date is reset

