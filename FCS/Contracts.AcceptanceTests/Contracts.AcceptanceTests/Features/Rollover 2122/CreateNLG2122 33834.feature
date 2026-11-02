Feature: CreateNLG2122 33834

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A170 Create an NLG2122 contract with 2 bulk deliverables. Inject NLG2122 deliverable 116 from CFS. Release, publish and approve. Payment Batch. Check CDA, CRM, PaaS and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017170' 
    And   there are no terminated or closed allocations for UKPRN '10017170' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017170'
    And   there is no Funding Allocation data in CRM for UKPRN '10017170'
    And   there is no Contract, Task or Workflow data for UKPRN '10017170' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017170' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017170' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NLG-170       |

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017170' in the Sharepoint 'NLG-2122-Input-Appendices' folder

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NLG-170       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NLG2122           |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NONLG-170      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017170'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017170' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017170 Co Ltd' with UKPRN '10017170' and OrgId 'ORG0017170' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017170' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017170 | 117170 | 10017170 Co Ltd | 0              | Active                | Yes           | AA017170      | ?             | 2 Church Gates         | The Wilderness         | ?                      | ?                      | Berkhamsted            | Hertfordshire          | HP4 2UB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017170 |





    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'NONLG-170'
    And   there are no details in ContractManagement.CreatedContract for 'NONLG-170'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017170 | 10017170 Co Ltd      | ESFA-170             | NONLG-170      | 1                     | 01/08/2021        | 31/07/2022      | 48607.00      |                                       | Non-learning Grant                         | 2122   | New          | ORG0017170 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017170 | NONLG-170      | NLG-170       | NLG               | NLG2122                 | AY                      | 01/08/2021          | 31/07/2022        | 48607.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017170 | NONLG-170      | NLG-170       | 101             | 0                     | 24942.00  | 16636.00  | 8306.00   | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | Principals Reference Group (PRG)                                | New          |             | 
    | 10017170 | NONLG-170      | NLG-170       | 102             | 0                     | 23665.00  | 18253.00  | 5412.00   | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | National Leaders of Further Education (NLFE)                    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NONLG-170      | 1                     | 0                        | 2021-07-01 09:12:35.000 |





    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017170 | NLG-AS-2122-Contract-Provider-10017170-2_4            | 2_4            | NLG                         | AS-2122            | 18640.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017170-2_4   | 2_4                    | NLG-AS-2122-Contract-Provider-10017170-2_4            | 10017170      | Furth        | 02IPP           | 18640.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017170-2_4   | NLG-001         | 18640.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017170-2_4   | NLG-001         | FY-2122              | September              | 2021              | 3417.00                   |
    | NLG-AS-2122-10017170-2_4   | NLG-001         | FY-2122              | January                | 2022              | 5271.00                   |
    | NLG-AS-2122-10017170-2_4   | NLG-001         | FY-2122              | March                  | 2022              | 2648.00                   |
    | NLG-AS-2122-10017170-2_4   | NLG-001         | FY-2122              | April                  | 2022              | 4640.00                   |
    | NLG-AS-2122-10017170-2_4   | NLG-001         | FY-2122              | July                   | 2022              | 2664.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      | NLG                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017170 | 10017170 Co Ltd  | NLG-AS-2122-Contract-Provider-10017170-2_4              | 2_4            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 18640.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017170-2_4              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18640.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017170 | NLG-AS-2122-Contract-Provider-10017170-2_4              | 2_4            | AS-2122 | NLG                         | 18640.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2021'

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
    | Released          | 1               | 18640.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017170' for FundingType 'NLG' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017170' for FundingType 'NLG' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017170 | 10017170 Co Ltd  | NLG-AS-2122-Contract-Provider-10017170-2_4              | 2_4            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Released          | Released          | 18640.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017170-2_4              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NLG-AS-2122-Contract-Provider-10017170-2_4              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NLG-AS-2122-Contract-Provider-10017170-2_4              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017170 | NLG-AS-2122-Contract-Provider-10017170-2_4              | 2_4            | AS-2122 | NLG                         | 18640.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017170-2_4              | NONLG-170    | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017170 | NONLG-170          | 1                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017170 | NONLG-170          | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017170 | ESFA-170           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017170 | NONLG-170          | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 67247.00      | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-170           | AY2122 | ?               | 10017170 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017170 | ESFA-170           | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017170 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017170 | NONLG-170          | NLG-170               | ?                             | 67247.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | NLG           | NLG2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | NONLG-170      | NLG-170         | 101             | 24942.00  | 562.00   | 2657.00  | 2791.00  | 1407.00  | 2840.00  | 3225.00  | 102.00   | 3052.00  | 1605.00  | 2247.00  | 2286.00  | 2168.00  | Principals Reference Group (PRG)                            |                          | 
    | NONLG-170      | NLG-170         | 102             | 23665.00  | 448.00   | 2098.00  | 2582.00  | 3096.00  | 1555.00  | 2479.00  | 2424.00  | 3571.00  | 131.00   | 329.00   | 3437.00  | 1515.00  | National Leaders of Further Education (NLFE)                |                          | 
    | NONLG-170      | NLG-170         | 116             | 18640.00  | 0.00     | 3417.00  | 0.00     | 0.00     | 0.00     | 5271.00  | 0.00     | 2648.00  | 4640.00  | 0.00     | 0.00     | 2664.00  | Isles of Scilly: Boarding and Accommodation Grant           |                          |





    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract 'NONLG-170'

    # Check the contents of the Appendices
    And   the file named '10017170_NONLG-170_v1.pdf' in Sharepoint location 'NLG-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017170 Co Ltd UKPRN: 10017170
    Master Contract Number: ESFA-170 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: NLG-170
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Principals Reference Group (PRG) £24,942 £562 £2,657 £2,791 £1,407 £2,840 £3,225 £102 £3,052 £1,605 £2,247 £2,286 £2,168
    National Leaders of Further Education (NLFE) £23,665 £448 £2,098 £2,582 £3,096 £1,555 £2,479 £2,424 £3,571 £131 £329 £3,437 £1,515
    Isles of Scilly: Boarding and Accommodation Grant £18,640 £0 £3,417 £0 £0 £0 £5,271 £0 £2,648 £4,640 £0 £0 £2,664
    Total Funding £67,247 £1,010 £8,172 £5,373 £4,503 £4,395 £10,975 £2,526 £9,271 £6,376 £2,576 £5,723 £6,347
    21/22 Non-learning Grants – NLG-170 – Page 1 Ref (for internal use only):  NONLG-170 v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017170_NONLG-170_v1.pdf' in 'NLG-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A170.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NONLG-170      | 1                     | 0                        | 2021-07-08 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'NONLG-170' for provider '10017170'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017170 - 10017170 Co Ltd Awaiting documentation  | NLG-170         | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017170 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017170 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017170 | ESFA-170           | NONLG-170      | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '11/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NONLG-170'






    # Approve the contract

    # Change the date 
    Given the override date is '14/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-170' and ContractNumber 'NONLG-170' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017170 | NONLG-170          | 1                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017170 | ESFA-170           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017170 | 10017170 Co Ltd  | NLG-AS-2122-Contract-Provider-10017170-2_4              | 2_4            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Contract Approved | Contract Approved | 18640.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [NLG]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017170 | NLG-AS-2122-Contract-Provider-10017170-2_4              | 2_4            | AS-2122 | NLG                         | 18640.00    | [NLG]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017170-2_4              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'NONLG-170' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription      |
    | 10017170 | NONLG-170      | 1               | NLG-170          | 101             | 0                     | 24942.00     | 0             | 0        | Principals Reference Group (PRG)                   | ?                           |
    | 10017170 | NONLG-170      | 1               | NLG-170          | 102             | 0                     | 23665.00     | 0             | 0        | National Leaders of Further Education (NLFE)       | ?                           |
    | 10017170 | NONLG-170      | 1               | NLG-170          | 116             | 0                     | 18640.00     | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant  | ?                           |


    # Tidy Up
    And   the override date is reset