Feature: Create2122CCF 33842

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A580 Import and release a new CCF2122 contract. Publish and approve. Payment Batch. Check CDA, CRM, PaaS and Feed

    #  1. Import and release a CCF2122 Funding Allocation
    #  2. Check docs 
    #  3. Publish and approve
    #  4. Check financials and CM feed
    #  5. NFA
    #  6. Check docs
    #  7. Publish and approve
    #  8. Check financials
    #  9. CDA
    # 10. Payment batch 
    # 11. Check Payment feed

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017580'
    And   there is no Funding Allocation data in CRM for UKPRN '10017580'
    And   there is no Contract, Task or Workflow data for UKPRN '10017580'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017580'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017580'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017580' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | CCF             | FY2122        | CCF2122      | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017580' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017580 Co Ltd' with UKPRN '10017580' and OrgId 'ORG0017580' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017580' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017580 | 117580 | 10017580 Co Ltd | 0              | Active                | Yes           | AA017580      | ?             | 37a Star Street        | ?                      | ?                      | ?                      | Ware                   | Hertfordshire          | SG12 7AA  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017580 |




    # Populate the stub with CCF (07HEP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017580 | CCF-FY-2122-Contract-Provider-10017580-1_1            | 1_1            | CCF                         | FY-2122            | 11248.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | CCF-FY-2122-10017580-1_1   | 1_1                    | CCF-FY-2122-Contract-Provider-10017580-1_1            | 10017580      | Furth        | 07HEP           | 11248.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | CCF-FY-2122-10017580-1_1   | CCF-001         | 11248.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | CCF-FY-2122-10017580-1_1   | CCF-001         | FY-2122              | August                 | 2021              | 11248.00                  |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | CCF             | FY2122        | CCF2122      | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017580 | 10017580 Co Ltd  | CCF-FY-2122-Contract-Provider-10017580-1_1              | 1_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Scheduling        | Awaiting Release  | 11248.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017580-1_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 11248.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017580 | CCF-FY-2122-Contract-Provider-10017580-1_1              | 1_1            | FY-2122 | CCF                         | 11248.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 11248.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017580' for FundingType 'CCF' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017580' for FundingType 'CCF' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017580 | 10017580 Co Ltd  | CCF-FY-2122-Contract-Provider-10017580-1_1              | 1_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Released          | Released          | 11248.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017580-1_1              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | CCF-FY-2122-Contract-Provider-10017580-1_1              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | CCF-FY-2122-Contract-Provider-10017580-1_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017580 | CCF-FY-2122-Contract-Provider-10017580-1_1              | 1_1            | FY-2122 | CCF                         | 11248.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017580-1_1              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017580 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017580 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017580 | [ContractNo]       | College Collaboration Fund             | Contract      | Draft          | Awaiting Documentation  | 11248.00      | 1                     | 0                        | 01/04/2021        | 31/03/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | FY2122 | ?               | 10017580 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017580 | [MasterContractNo] | College Collaboration Fund             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/04/2021        | 31/03/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017580 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017580 | [ContractNo]       | [AllocRef_CCF]        | ?                             | 11248.00        | ?             | ?                | 01/04/2021 | 31/03/2022 | CCF           | CCF2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableName                      | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_CCF]  | 1               | 11248.00  | 0.00     | 0.00     | 0.00     | 0.00     | 11248.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | College Collaboration Fund (CCF)     |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017580_[ContractNo]_v1.pdf' in Sharepoint location 'CCF-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017580 Co Ltd UKPRN: 10017580
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: [AllocRef_CCF]
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    College Collaboration Fund (CCF) £11,248 £0 £0 £0 £0 £11,248 £0 £0 £0 £0 £0 £0 £0
    Total Funding £11,248 £0 £0 £0 £0 £11,248 £0 £0 £0 £0 £0 £0 £0
    College Collaboration Fund – [AllocRef_CCF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017580_[ContractNo]_v1.pdf' in 'CCF-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A580_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-08 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017580'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017580 - 10017580 Co Ltd Awaiting documentation  | [AllocRef_CCF]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017580 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017580 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017580 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





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
    | 10017580 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017580 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017580 | 10017580 Co Ltd  | CCF-FY-2122-Contract-Provider-10017580-1_1              | 1_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved | 11248.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017580 | CCF-FY-2122-Contract-Provider-10017580-1_1              | 1_1            | FY-2122 | CCF                         | 11248.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | CCF-FY-2122-Contract-Provider-10017580-1_1              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017580 | [ContractNo]   | 1               | [AllocRef_CCF]   | 1               | 0                     | 11248.00     | 0             | 0        | College Collaboration Fund (CCF)               | ?                           |

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_CCF]     | 1               | 11248.00  | 0.00     | 0.00     | 0.00     | 0.00     | 11248.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef   | ProfileSubnominal  | Aug-21    |
    | 10017580 | [ContractNo]   | [AllocRef_CCF]  | 2208300            | 11248.00  | 





    # Execute a NON-FINANCIAL amendment 

    # Change the date
    Given the override date is '16/07/2020'

    # Issue a non-financial VARIATION amendment on v1 to create v2.
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017580 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017580 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017580 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the contents of the Appendices
    And   the file named '10017580_[ContractNo]_v2.pdf' in Sharepoint location 'CCF-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017580 Co Ltd UKPRN: 10017580
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: [AllocRef_CCF]
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    College Collaboration Fund (CCF) £11,248 £0 £0 £0 £0 £11,248 £0 £0 £0 £0 £0 £0 £0
    Total Funding £11,248 £0 £0 £0 £0 £11,248 £0 £0 £0 £0 £0 £0 £0
    College Collaboration Fund – [AllocRef_CCF] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017580_[ContractNo]_v2.pdf' in 'CCF-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A580_v1.pdf'





    # Publish the contract

    # Change the date 
    Given the override date is '17/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'





    # Approve the contract

    # Change the date 
    Given the override date is '18/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017580 | [ContractNo]       | 2                     | 0                        | Approved         | Approved             | True          | True                | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017580 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved             | False         | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017580 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                    | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_CCF]     | 1               | 11248.00  | 0.00     | 0.00     | 0.00     | 0.00     | 11248.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef   | ProfileSubnominal  | Aug-21    |
    | 10017580 | [ContractNo]   | [AllocRef_CCF]  | 2208300            | 11248.00  | 





#    # CDA
#    
#    # Change the date
#    Given the override date is '19/07/2021'
#    
#    # Check the contents of the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version A580.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 2                     |
#
#   #When  the following CDA reports are run
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version               | Suffix |
#    | CCF2122              | Last Approved Version | A580   |
#
#    Then  a report named 'CDA Last Approved Version A580.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription    | Deliverable                         | DeliverableParent      | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | CCF2122                 | 10017580 | 10017580 Co Ltd             |               |                             | [AllocRef_CCF]           | [ContractNo]   | [MasterContractNo]      | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | College Collaboration Fund (CCF)    |                        | 8                 | 2021            | 2021/22       |              | 11248.00     |              |               |              | Yes                | 11248.00       | 0.00             | 0.00                  | 0.00           | 11248.00        |             | No            |                   |        | 2208300           |                          |                   | Aug              |





    # Payment Batch for CCF2122 (PoP) for Aug 2021

    # Change the date
    Given the override date is '03/08/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'CCF2122' AccountingPaymentPeriod '202105' CensusEndDate '03/08/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_CCF]           | 202108 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | CCF2122                    | 202108               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | CCF2122                    | 202108               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'CCF2122' PaymentPeriod '202105' CensusEndDate '03/08/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A580.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'CCF2122' PaymentPeriod '202105' CensusEndDate '03/08/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef   | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | CCF                    | 2021          | 05             | 03          | ?       | [AllocRef_CCF]  | 11248.00        | PROFILE          | CollegeCollabFund      | 2021-08-18 | 2021-04-01   | 2022-03-31 | ?              | 10017580 | 2208300    |


    # Tidy Up
    And   the override date is reset

