Feature: CreateNLGcontract 39384

@AcceptanceTest @Withdrawn20251024
@CFS
Scenario: S034 Create an NLG2324 contract with 2 bulk deliverables. Inject NLG2324 deliverable 116 from CFS. Release, publish and approve. NFA. CDA. PoP payment batch. Check docs, financials, Feed and reports
  Given there are no allocations marked as Under Termination for UKPRN '10018034' 
    And   there are no terminated or closed allocations for UKPRN '10018034' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018034'
    And   there is no Funding Allocation data in CRM for UKPRN '10018034'
    And   there is no Contract, Task or Workflow data for UKPRN '10018034' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018034' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018034' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NLG-8034       |

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018034' in the Sharepoint 'NLG-2324-Input-Appendices' folder

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NLG-8034       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NLG2324           |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NONLG-8034      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018034'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2324        | NLG2324      | Non-learning Grant                      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10018034' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018034 Co Ltd' with UKPRN '10018034' and OrgId 'ORG0018034' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10018034' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018034 | 118034 | 10018034 Co Ltd | 0              | Active                | Yes           | AA018034      | ?             | Church Gates           | The Wilderness         | ?                      | ?                      | Berkhamsted            | Hertfordshire          | HP4 2UB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018034 |





    # Change the date
    Given the override date is '01/07/2023'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'NONLG-8034'
    And   there are no details in ContractManagement.CreatedContract for 'NONLG-8034'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018034 | 10018034 Co Ltd      | ESFA-8034             | NONLG-8034      | 1                     | 01/08/2023        | 31/07/2024      | 48607.00      |                                       | Non-learning Grant                         | 2324   | New          | ORG0018034 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018034 | NONLG-8034      | NLG-8034       | NLG               | NLG2324                 | AY                      | 01/08/2023          | 31/07/2024        | 48607.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018034 | NONLG-8034      | NLG-8034       | 101             | 0                     | 24942.00  | 16636.00  | 8306.00   | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | Principals Reference Group (PRG)                                | New          |             | 
    | 10018034 | NONLG-8034      | NLG-8034       | 102             | 0                     | 23665.00  | 18253.00  | 5412.00   | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | National Leaders of Further Education (NLFE)                    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NONLG-8034      | 1                     | 0                        | 2023-07-01 09:12:35.000 |





    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '02/07/2023'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018034 | NLG-AS-2324-Contract-Provider-10018034-2_4            | 2_4            | NLG                         | AS-2324            | 18665.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2324-10018034-2_4   | 2_4                    | NLG-AS-2324-Contract-Provider-10018034-2_4            | 10018034      | Furth        | 02IPP           | 18665.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2324-10018034-2_4   | NLG-001         | 18665.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2324-10018034-2_4   | NLG-001         | FY-2324              | August                 | 2023              | 25.00                     |
    | NLG-AS-2324-10018034-2_4   | NLG-001         | FY-2324              | September              | 2023              | 3417.00                   |
    | NLG-AS-2324-10018034-2_4   | NLG-001         | FY-2324              | January                | 2024              | 5271.00                   |
    | NLG-AS-2324-10018034-2_4   | NLG-001         | FY-2324              | March                  | 2024              | 2648.00                   |
    | NLG-AS-2324-10018034-2_4   | NLG-001         | FY-2324              | April                  | 2024              | 4640.00                   |
    | NLG-AS-2324-10018034-2_4   | NLG-001         | FY-2324              | July                   | 2024              | 2664.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2324        | NLG2324      | Non-learning Grant                      | NLG                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10018034 | 10018034 Co Ltd  | NLG-AS-2324-Contract-Provider-10018034-2_4              | 2_4            | Non-learning Grants        | AY2324  | Non-learning Grant                       | NLG                         | NLG2324         | Scheduling        | Awaiting Release  | 18665.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2324-Contract-Provider-10018034-2_4              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18665.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018034 | NLG-AS-2324-Contract-Provider-10018034-2_4              | 2_4            | AS-2324 | NLG                         | 18665.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2023'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup NLG = [NLG]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 18665.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018034' for FundingType 'NLG' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018034' for FundingType 'NLG' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10018034 | 10018034 Co Ltd  | NLG-AS-2324-Contract-Provider-10018034-2_4              | 2_4            | Non-learning Grants        | AY2324  | Non-learning Grant                       | NLG                         | NLG2324         | Released          | Released          | 18665.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2324-Contract-Provider-10018034-2_4              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NLG-AS-2324-Contract-Provider-10018034-2_4              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NLG-AS-2324-Contract-Provider-10018034-2_4              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018034 | NLG-AS-2324-Contract-Provider-10018034-2_4              | 2_4            | AS-2324 | NLG                         | 18665.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2324-Contract-Provider-10018034-2_4              | NONLG-8034    | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018034 | NONLG-8034         | 1                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018034 | NONLG-8034         | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018034 | ESFA-8034          | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018034 | NONLG-8034          | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 67272.00      | 1                     | 1                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-8034           | AY2324 | ?               | 10018034 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018034 | ESFA-8034           | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018034 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018034 | NONLG-8034         | NLG-8034               | ?                             | 67272.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | NLG           | NLG2324             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                             | DeliverableDescription   |
    | NONLG-8034     | NLG-8034         | 101             | 24942.00  | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | Principals Reference Group (PRG)                            |                          | 
    | NONLG-8034     | NLG-8034         | 102             | 23665.00  | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | National Leaders of Further Education (NLFE)                |                          | 
    | NONLG-8034     | NLG-8034         | 116             | 18665.00  | 25.00    | 3417.00  | 0.00     | 0.00     | 0.00     | 5271.00  | 0.00     | 2648.00  | 4640.00  | 0.00     | 0.00     | 2664.00  | Isles of Scilly: Boarding and Accommodation Grant           |                          |





    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract 'NONLG-8034'

    # Check the contents of the Appendices
    And   the file named '10018034_NONLG-8034_v1.pdf' in Sharepoint location 'NLG-2324-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10018034 Co Ltd UKPRN: 10018034
    Master Contract Number: ESFA-8034 Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: NLG-8034
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Principals Reference Group (PRG) £24,942 £562 £2,657 £2,791 £1,407 £2,840 £3,225 £102 £3,052 £1,605 £2,247 £2,286 £2,168
    National Leaders of Further Education (NLFE) £23,665 £448 £2,098 £2,582 £3,096 £1,555 £2,479 £2,424 £3,571 £131 £329 £3,437 £1,515
    Isles of Scilly: Boarding and Accommodation Grant £18,665 £25 £3,417 £0 £0 £0 £5,271 £0 £2,648 £4,640 £0 £0 £2,664
    Total Funding £67,272 £1,035 £8,172 £5,373 £4,503 £4,395 £10,975 £2,526 £9,271 £6,376 £2,576 £5,723 £6,347
    23/24 Non-learning Grants – NLG-8034 – Page 1 Ref (for internal use only):  NONLG-8034 v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018034_NONLG-8034_v1.pdf' in 'NLG-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S034.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NONLG-8034      | 1                     | 0                        | 2023-07-08 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'NONLG-8034' for provider '10018034'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018034 - 10018034 Co Ltd Awaiting documentation  | NLG-8034         | Document Management Team  | ?                | Open       | Not Started   |

#    # Check the CRM Contract Workflow History data
#    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
#    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
#    | 10018034 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#    | 10018034 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#    | 10018034 | ESFA-8034          | NONLG-8034     | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#
#



    # Publish the contract

    # Change the date 
    Given the override date is '11/07/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NONLG-8034'




    # Approve the contract

    # Change the date 
    Given the override date is '14/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-8034' and ContractNumber 'NONLG-8034' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018034 | NONLG-8034          | 1                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018034 | ESFA-8034           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10018034 | 10018034 Co Ltd  | NLG-AS-2324-Contract-Provider-10018034-2_4              | 2_4            | Non-learning Grants        | AY2324  | Non-learning Grant                       | NLG                         | NLG2324         | Contract Approved | Contract Approved | 18665.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [NLG]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018034 | NLG-AS-2324-Contract-Provider-10018034-2_4              | 2_4            | AS-2324 | NLG                         | 18665.00    | [NLG]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2324-Contract-Provider-10018034-2_4              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'NONLG-8034' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription      |
    | 10018034 | NONLG-8034      | 1               | NLG-8034          | 101             | 0                     | 24942.00     | 0             | 0        | Principals Reference Group (PRG)                   | ?                           |
    | 10018034 | NONLG-8034      | 1               | NLG-8034          | 102             | 0                     | 23665.00     | 0             | 0        | National Leaders of Further Education (NLFE)       | ?                           |
    | 10018034 | NONLG-8034      | 1               | NLG-8034          | 116             | 0                     | 18665.00     | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant  | ?                           |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'NONLG-8034'    
    
    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | NLG-8034       | 2208100         | Jul-24 | Profile        |





    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | NONLG-8034      | NLG-8034            | 101             | 24942.00  | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | 
    | NONLG-8034      | NLG-8034            | 102             | 23665.00  | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | 
    | NONLG-8034      | NLG-8034            | 116             | 18665.00  | 25.00    | 3417.00  | 0.00     | 0.00     | 0.00     | 5271.00  | 0.00     | 2648.00  | 4640.00  | 0.00     | 0.00     | 2664.00  | 
    #                                                       £ 67272.00

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | NONLG-8034      | NLG-8034            | 101             | 24942.00  | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | 
    | NONLG-8034      | NLG-8034            | 102             | 23665.00  | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | 
    | NONLG-8034      | NLG-8034            | 116             | 18665.00  | 25.00    | 3417.00  | 0.00     | 0.00     | 0.00     | 5271.00  | 0.00     | 2648.00  | 4640.00  | 0.00     | 0.00     | 2664.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | NONLG-8034      | NLG-8034            | 101             | 24942.00  | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | 
    | NONLG-8034      | NLG-8034            | 102             | 23665.00  | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | 
    | NONLG-8034      | NLG-8034            | 116             | 18665.00  | 25.00    | 3417.00  | 0.00     | 0.00     | 0.00     | 5271.00  | 0.00     | 2648.00  | 4640.00  | 0.00     | 0.00     | 2664.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef  | ProfileSubnominal | Aug-23    | Sep-23    | Oct-23    | Nov-23    | Dec-23    | Jan-24    | Feb-24    | Mar-24    | Apr-24    | May-24    | Jun-24    | Jul-24    |
    | 10018034 | NONLG-8034      | NLG-8034        | 2208100           | 562.00    | 2657.00   | 2791.00   | 1407.00   | 2840.00   | 3225.00   | 102.00    | 3052.00   | 1605.00   | 2247.00   | 2286.00   | 2168.00   | 
    | 10018034 | NONLG-8034      | NLG-8034        | 2208200           | 448.00    | 2098.00   | 2582.00   | 3096.00   | 1555.00   | 2479.00   | 2424.00   | 3571.00   | 131.00    | 329.00    | 3437.00   | 1515.00   | 
    | 10018034 | NONLG-8034      | NLG-8034        | 2202070           | 25.00     | 3417.00   | 0.00      | 0.00      | 0.00      | 5271.00   | 0.00      | 2648.00   | 4640.00   | 0.00      | 0.00      | 2664.00   | 



    

#
#    # CDA
#    
#    # Change the date
#    Given the override date is '22/07/2023'
##
##    # Run the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version S034.csv'
#
#    #And   the following contracts are in the replicated CRM database
#    #| ContractNumber | ContractVersionNumber |
#    #| NONLG-8034      | 1                    |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | NLG2324               | Last Approved Version | S034   |
#
#    Then  a report named 'CDA Last Approved Version S034.csv' is created
#
#    # Check the contents of the CDA Report manually 
#
#    

    
    
#    # Payment Batch for NLG2324(PoP)
#
#    # Change the date
#    Given the override date is '02/08/2023 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'NLG2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | NLG-8034                  | 202308 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | NLG2324                    | 202308               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | NLG2324                    | 202308               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'NLG2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S034.xml'
#
#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'NLG2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | NLG                    | 2023          | 05             | 02          | ?       | NLG-8034           | 562.00          | PROFILE          | Principals Ref Group               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208100    |
#    | NLG                    | 2023          | 05             | 02          | ?       | NLG-8034           | 448.00          | PROFILE          | NationalLeadrs of FE               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208200    |
#    | NLG                    | 2023          | 05             | 02          | ?       | NLG-8034           | 25.00           | PROFILE          | Isles of Scilly                    | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2202070    |
#
#
#
##
##    # Consolidated Payment Summary Report
##
##    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
##    When a Consolidated Payment Summary Report is created in Sharepoint for '02/08/2023'
##
##    # Check the contents of the Consolidated Payment Summary Report manually
#
#    
#   #  Part 10: Create Consolidated Payment Summary rpt
#   
#   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#   Given there are no files prefixed '2023-08 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
#
#   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '03/08/2023'
#    # Check the above report manually
#
#    
#   



    # NFA amendment

    # Change the date
    Given the override date is '18/08/2023'

    # Issue a non-financial amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'NONLG-8034' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018034 | NONLG-8034          | 2                     | 0                        | Draft            | Awaiting Documentation  | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10018034 | NONLG-8034          | 1                     | 1                        | Approved         | Approved                | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018034 | ESFA-8034           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the contents of the Appendices
    And   the file named '10018034_NONLG-8034_v2.pdf' in Sharepoint location 'NLG-2324-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10018034 Co Ltd UKPRN: 10018034
    Master Contract Number: ESFA-8034 Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: NLG-8034
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Principals Reference Group (PRG) £24,942 £562 £2,657 £2,791 £1,407 £2,840 £3,225 £102 £3,052 £1,605 £2,247 £2,286 £2,168
    National Leaders of Further Education (NLFE) £23,665 £448 £2,098 £2,582 £3,096 £1,555 £2,479 £2,424 £3,571 £131 £329 £3,437 £1,515
    Isles of Scilly: Boarding and Accommodation Grant £18,665 £25 £3,417 £0 £0 £0 £5,271 £0 £2,648 £4,640 £0 £0 £2,664
    Total Funding £67,272 £1,035 £8,172 £5,373 £4,503 £4,395 £10,975 £2,526 £9,271 £6,376 £2,576 £5,723 £6,347
    23/24 Non-learning Grants – NLG-8034 – Page 1 Ref (for internal use only):  NONLG-8034 v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018034_NONLG-8034_v2.pdf' in 'NLG-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S034v2.pdf'




    # Tidy Up
    Given the override date is reset

