Feature: UnassignedCaseload 32896

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A162 Import and release a new CCF2122 FA where the Caseload is unassigned. Check CRM and PaaS. Assign Caseload Advisor. Publish and approve. Check CRM, PaaS and Feed

    #  1. Caseload exists with unassigned advisor
    #  2. Contract: State= Draft\Unassigned, CurrentTask= null, TaskOwner= Unassigned
    #  3. Task: Not created
    #  4. Contract Workflow History: Action= Record Imported Documentation Required, NewTaskOwner= Unassigned, NewSubStatus= Unassigned  
    
    #  5. Assign Caseload Advisor
    #  6. Contract: State= Draft\AwaitingDocumentation, CurrentTask= Initiate Document Merge, TaskOwner= Document Management Team
    #  7. Task: Created (Initiate Document Merge)
    #  8. Contract Workflow History: Action= Caseload Assigned, NewTaskOwner= FCS2 TEST, NewSubStatus= Awaiting Documentation

    #  9. Publish and approve
    # 10. Check CRM, PaaS and CM feed

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017162'
    And   there is no Funding Allocation data in CRM for UKPRN '10017162'
    And   there is no Contract, Task or Workflow data for UKPRN '10017162'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017162' in the Sharepoint 'NLG-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      |



    # Remove Organisation and Caseload 
    Given there is no Organisation data in CRM for UKPRN '10017162' 
    And   there is no caseload advisor for UKPRN '10017162' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017162 | 

    # At this point there isn't a caseload in CRM





    # Create a contract to add a Caseload and an 'Unassigned' advisor (J065)

    # Change the date
    Given the override date is '01/07/2021'

    # Bulk file
    Given there are no files prefixed '10017162' in the Sharepoint '16-18FU-2122-Input-Appendices' folder
    And   there are no files prefixed '16-18FU FY 2122 16072021085018 v3_A162' in the Sharepoint 'Input' folder
    And   there are no files prefixed '16-18FU FY 2122 16072021085018 v3_A162' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '16-18FU FY 2122 16072021085018 v3_A162' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '16-18FU FY 2122 16072021085018 v3_A162' in the Sharepoint 'Reports' folder
    And   spreadsheet '16-18FU FY 2122 16072021085018 v3_A162.xlsx' exists in the Datafiles folder and UKPRN '10017162' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # At this point an active caseload has been created for NACRO with the Contract Advisor set to 'Unassigned'




     # The following steps don't update the Legal name on the Caseload, so commented out
#
#    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
#    Given the following Organisations exist in the FCT Organisation Service 
#    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
#    | 10017162 | 117162 | NACRO           | 0              | Active                | Yes           | AA017162      | ?             | 29 Church Street       | Basingstoke            | ?                      | ?                      | ?                      | ?                      | RG21 7QQ  |
#
#    # Put the same Provider data in the CRM Organisation table 
#    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
#    | UKPRN    |
#    | 10017162 |





    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017162 | NLG-AS-2122-Contract-Provider-10017162-2_1            | 2_1            | NLG                         | AS-2122            | 21551.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017162-2_1   | 2_1                    | NLG-AS-2122-Contract-Provider-10017162-2_1            | 10017162      | Furth        | 02IPP           | 21551.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017162-2_1   | NLG-001         | 21551.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017162-2_1   | NLG-001         | FY-2122              | August                 | 2021              | 2709.00                   |
    | NLG-AS-2122-10017162-2_1   | NLG-001         | FY-2122              | October                | 2021              | 2650.00                   |
    | NLG-AS-2122-10017162-2_1   | NLG-001         | FY-2122              | January                | 2022              | 3889.00                   |
    | NLG-AS-2122-10017162-2_1   | NLG-001         | FY-2122              | February               | 2022              | 4172.00                   |
    | NLG-AS-2122-10017162-2_1   | NLG-001         | FY-2122              | May                    | 2022              | 4386.00                   |
    | NLG-AS-2122-10017162-2_1   | NLG-001         | FY-2122              | June                   | 2022              | 3745.00                   |
 
 
 
 
 
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
    | 10017162 | NACRO            | NLG-AS-2122-Contract-Provider-10017162-2_1              | 2_1            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 21551.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017162-2_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 21551.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017162 | NLG-AS-2122-Contract-Provider-10017162-2_1              | 2_1            | AS-2122 | NLG                         | 21551.00    | [NLG]           | ?                 | ?                                 |

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
    | Released          | 1               | 21551.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017162' for FundingType 'NLG' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017162' for FundingType 'NLG' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017162 | NACRO            | NLG-AS-2122-Contract-Provider-10017162-2_1              | 2_1            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Released          | Released          | 21551.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017162 | NLG-AS-2122-Contract-Provider-10017162-2_1              | 2_1            | AS-2122 | NLG                         | 21551.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017162-2_1              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017162 | [ContractNo]       | 1                     | 0                        | Draft            | Unassigned                               | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017162 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017162 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Unassigned              | 21551.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | Yes                   | [MasterContractNo] | AY2122 | ?               | NACRO            | Active | Unassigned                | ?                      |
    | 10017162 | [MasterContractNo] | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | NACRO            | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017162 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 21551.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | NLG           | NLG2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 21551.00  | 2709.00  | 0.00     | 2650.00  | 0.00     | 0.00     | 3889.00  | 4172.00  | 0.00     | 0.00     | 4386.00  | 3745.00  | 0.00     | Isles of Scilly: Boarding and Accommodation Grant           |                          |

    # Contract state is now Draft\Unassigned

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017162_[ContractNo]_v1.pdf' in Sharepoint location 'NLG-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: NACRO UKPRN: 10017162
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_NLG]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Isles of Scilly: Boarding and Accommodation Grant £21,551 £2,709 £0 £2,650 £0 £0 £3,889 £4,172 £0 £0 £4,386 £3,745 £0
    Total Funding £21,551 £2,709 £0 £2,650 £0 £0 £3,889 £4,172 £0 £0 £4,386 £3,745 £0
    21/22 Non-learning Grants – [AllocRef_NLG] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017162_[ContractNo]_v1.pdf' in 'NLG-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A162.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-08 09:12:35.000 |

     # Check the current state of the Tasks for this contract
#    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017162'
#    | Task                      | Description                              | Regarding       | Owner                     | Assigned Team    | State      | Status        |
#    | Initiate Document Merge   | 10017162 - NACRO Awaiting documentation  | [AllocRef_NLG]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    Then   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017162 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported Documentation Required  | CRM Integration | ?                | Unassigned                  | Draft         | Unassigned              | ?                     | ?                   | Draft          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017162-2_1              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NLG-AS-2122-Contract-Provider-10017162-2_1              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NLG-AS-2122-Contract-Provider-10017162-2_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |


 


    # Stage 2: Assign an advisor to the caseload
    
    # Change the date
    Given the override date is '10/07/2021'

    # Assign advisor to existing Caseload record
    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017162'

    # A Task is created
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017162'
    | Task                      | Description                              | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017162 - NACRO Awaiting documentation  | [AllocRef_NLG]  | Document Management Team  | ?                | Open       | Not Started   |

    # Check that the Contract has been updated after the Advisor was assigned to the caseload (CurrentTask, ContractSubStatus and TaskOwner)
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017162 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 21551.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | NACRO            | Active | Document Management Team  | ?                      |
    | 10017162 | [MasterContractNo] | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | NACRO            | Active | FCS2 TEST                 | ?                      |

    # Check that a new Workflow History row has appeared for Caseload Assigned
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017162 | [MasterContractNo] | [ContractNo]   | 1                     | Caseload Assigned                           | CRMDeploy CRMDeploy           | FCS2 TEST        | Document Management Team    | Draft             | Awaiting Documentation                       | ?                     | Unassigned                | Draft          | Unassigned                                   |
    | 10017162 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported Documentation Required      | CRM Integration               | ?                | Unassigned                  | Draft             | Unassigned                                   | ?                     | ?                         | Draft          | ?                                            |
    




    # Publish the contract

    # Change the date 
    Given the override date is '11/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'






    # Approve the contract

    # Change the date 
    Given the override date is '12/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017162 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017162 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017162 | NACRO            | NLG-AS-2122-Contract-Provider-10017162-2_1              | 2_1            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Contract Approved | Contract Approved | 21551.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [NLG]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017162 | NLG-AS-2122-Contract-Provider-10017162-2_1              | 2_1            | AS-2122 | NLG                         | 21551.00    | [NLG]           | ContractApproved  | ContractApproved      |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017162-2_1              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
    | NLG-AS-2122-Contract-Provider-10017162-2_1              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NLG-AS-2122-Contract-Provider-10017162-2_1              | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NLG-AS-2122-Contract-Provider-10017162-2_1              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription      |
    | 10017162 | [ContractNo]   | 1               | [AllocRef_NLG]   | 116             | 0                     | 21551.00     | 0             | 0        | Isles of Scilly: Boarding and Accommodation Grant  | ?                           |


    # Tidy Up
    And   the override date is reset

     