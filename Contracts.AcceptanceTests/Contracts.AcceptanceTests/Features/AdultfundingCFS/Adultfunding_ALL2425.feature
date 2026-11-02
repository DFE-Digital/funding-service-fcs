Feature: Adultfunding_ALL2425

@AcceptanceTest @Withdrawn20260521
@CFS
Scenario: S056 Import and release a ALLB2425, ALLF2425 allocation. Approve. Check docs, CRM and feed. Add 1619ED2425 allocation. Amend and repeat
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018056'
    And   there is no Funding Allocation data in CRM for UKPRN '10018056'
    And   there is no Contract, Task or Workflow data for UKPRN '10018056'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018056'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018056'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018056' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                           |
    | EDSK            | AY2425        | LOANS2425    | Contract for Services (ITP)      	  |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2425          |
    | ALLBC2425         |
    | ALLF2425          |

	
    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018056'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018056' 
    And   there is no caseload advisor for UKPRN '10018056' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018056 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018056' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018056 Co Ltd' with UKPRN '10018056' and OrgId 'ORG0018056' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018056 | 118056 | 10018056 Co Ltd | 0              | Active                | Yes           | AA018056      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018056 |







    # Populate the stub with ALLB (06SDC) data

    # Change the date 
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018056 | LOANS-AY-2425-Contract-Provider-10018056-3_5          | 3_5            | LOANS                       | AY-2425            | 10000.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | LOANS-AY-2425-10018056-3_5 | 3_5                    | LOANS-AY-2425-Contract-Provider-10018056-3_5          | 10018056      | Furth        | 02IPP           | 10000.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | LOANS-AY-2425-10018056-3_5   | LOANS-001         | 3680.00      | Payment         |
    | LOANS-AY-2425-10018056-3_5   | LOANS-002         | null         | Payment         |
    | LOANS-AY-2425-10018056-3_5   | LOANS-003         | 6320.00      | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | LOANS-AY-2425-10018056-3_5   | LOANS-001         | FY-2425              | April	               | 2025              | 3680.00                    |
    | LOANS-AY-2425-10018056-3_5   | LOANS-003         | FY-2425              | December	           | 2024              | 6320.00                    |

 
 

 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | LOANS2425    | Contract for Services (ITP)      	   | CfS_ITP                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018056 | 10018056 Co Ltd  | LOANS-AY-2425-Contract-Provider-10018056-3_5            | 3_5            | Education & Skills Funding | AY2425  | Contract for Services (ITP) 		       | LOANS                       | LOANS2425       | Scheduling        | Awaiting Release  | 10000.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | LOANS-AY-2425-Contract-Provider-10018056-3_5              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 10000.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018056 | LOANS-AY-2425-Contract-Provider-10018056-3_5              | 3_5            | AY-2425 | LOANS                       | 10000.00      | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS_ITP]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 10000.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018056' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018056' for FundingType 'ALLB' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018056 | 10018056 Co Ltd  | LOANS-AY-2425-Contract-Provider-10018056-3_5              | 3_5            | Education & Skills Funding | AY2425  | Contract for Services (ITP)		       | LOANS                       | LOANS2425       | Released          | Released          | 10000.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | LOANS-AY-2425-Contract-Provider-10018056-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | LOANS-AY-2425-Contract-Provider-10018056-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018056 | LOANS-AY-2425-Contract-Provider-10018056-3_5            | 3_5            | AY-2425 | LOANS                       | 10000.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | LOANS-AY-2425-Contract-Provider-10018056-3_5            | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018056 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

#    # Check that the Contract and Master Contract have been created correctly in CRM
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10018056 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 5000.00       | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10018056 Co Ltd  | Active | Document Management Team  | ?                      |
#    | 10018056 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018056 Co Ltd  | Active | CRM Integration           | ?                      |
#
#    # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10018056 | [ContractNo]       | [AllocRef_ALL]       | ?                             | 5000.00         | ?             | ?                | 01/08/2024 | 31/07/2025 | ALLB          | ALLB2425            | Contract Allocation   | ?                        |
#
#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                             | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_ALLB] | 1               | 5000.00   | 0.00     | 0.00     | 3632.00  | 0.00     | 0.00     | 0.00     | 0.00     | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | Total Advanced Learner Loans Bursary Funding            	   |                          |
#
#    # Contract is now at 'Draft\Awaiting Documentation'
#
    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
##
##     #Check the contents of the Appendices
##    And   the file named '10018042_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
##    """
##
##    SUMMARY OF FUNDING
##    Organisation Name: 10018056 Co Ltd UKPRN: 10018056
##    Master Contract Number: [MasterContractNo]
##    Allocation
##    1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
##    Education & Skills Funding (ALLB) [AllocRef_ALLB] £0 £4,632 £4,632
##    Total: £4,632
##    Total Funding for this contract: £4,632
##    Summary of Funding – Page 1
##    Agreement Type Contract for Services (ITP)
##    st st st
##    1 August 2023 to 31 July 2025 or 31 July 2026 if
##    Funding Period
##    extended by the Department pursuant to Clause 2.3
##    Between the Secretary of State for Education
##    And 10018056 Co Ltd
##    Funding for Education & Skills Funding (ALLB)
##    Master Contract Number [MasterContractNo]
##    ACCEPTANCE BY THE CONTRACTOR
##    BY ACCEPTING THIS CONTRACT VIA THE MANAGE YOUR EDUCATION &
##    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF
##    OF THE CONTRACTOR REPRESENTS AND WARRANTS THAT THE
##    CONTRACTOR HAS READ AND UNDERSTOOD THIS CONTRACT, THE
##    CONTRACTOR AGREES TO BE BOUND BY THIS CONTRACT AND THAT
##    HE/SHE IS DULY AUTHORISED TO ACCEPT THIS CONTRACT AND LEGALLY
##    BIND THE CONTRACTOR.
##    SIGNED FOR AND ON BEHALF OF
##    THE SECRETARY OF STATE FOR EDUCATION
##    by David Withey, Chief Executive of the Education and Skills Funding Agency
##    ALLB Version 2 (September 2023) Page 1
##    This Contract is made on the date the Contract is digitally signed by the
##    Contractor on the Manage Your Education & Skills Funding Service between:
##    10018056 Co Ltd THE SECRETARY OF STATE FOR
##    9 Kneesworth Street EDUCATION
##    Royston DEPARTMENT FOR EDUCATION
##    Hertfordshire 20 GREAT SMITH STREET
##    AND
##    SG8 5AA LONDON
##    SW1P 3BT
##    Company No: AA018056
##    Hereinafter called Hereinafter called
##    the Contractor the Department
##    ALLB Version 2 (September 2023) Page 2
##    SCHEDULE 1: SPECIFICATION & MONITORING
##    Education & Skills Funding (ALLB) SPECIFICATION
##    ALLB Schedule 1 – Annex 1 Version 1 (July 2023) – Page 2
##    SCHEDULE 2: PAYMENT
##    Education & Skills Funding (ALLB) PAYMENT
##    ALLB Schedule 2 Version 1 (July 2023) – Page 1
##    SCHEDULE 2
##    Funding Agreement
##    Provider: 10018056 Co Ltd UKPRN: 10018056
##    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
##    Contract Ref: [AllocRef_ALLB]
##    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
##    Education & Skills Funding (ALLB) £4,632 £0 £0 £0 £0 £0 £0 £0 £0 £0 £4,632 £0 £0
##    Total Funding £4,632 £0 £0 £0 £0 £0 £0 £0 £0 £0 £4,632 £0 £0
##    Schedule 2 – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
##    SCHEDULE 3: CHANGE CONTROL PROCEDURE
##    ALLB Schedule 3 Version 1 (July 2023) – Page 1
##    SCHEDULE 9: CONTRACTOR’S RESPONSE/PROPOSALS
##    ALLB Schedule 9 Version 1 (July 2023) – Page 1
##    SCHEDULE 10: SUB-CONTRACTING
##    ALLB Schedule 10 Version 1 (July 2023) – Page 5
##    """
## 
#
#
#
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018056_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018056_[ContractNo]_v1.pdf'
#
    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |
#
##    # Check the current state of the Tasks for this contract
##    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018056'
##    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
##    | Initiate Document Merge   | 10018056 - 10018056 Co Ltd Awaiting documentation  | [AllocRef_ALLB] | Document Management Team  | ?                | Open       | Not Started   |
##
##    # Check the CRM Contract Workflow History data
##    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
##    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
##   #| 10018056 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
##   #| 10018056 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
##    | 10018056 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
##
#
#
##        # 2. Delete the draft contract. FA1 -> Return to Scheduling
##
##    # Change to date
##    Given the override date is '07/07/2023'
##
##    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
##    When  a request is initiated in CRM to delete the following contracts
##   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
##    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
##    | 10018056 | [ContractNo]   | 1                     | 0                  |
##
###
###    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
###    Then  the following Funding Allocations data is present in CRM
###    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus                       | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
###    | 10018056 | 10018056 Co Ltd  | ALLB-AY-2425-Contract-Provider-10018056-3_5             | 3_5            | Education & Skills Funding | AY2425  | Contract for Services (ITP)       | ALLB                        | ALLB2425        | Scheduling        | Returned to Scheduling          | 5000.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]           | ?          | ?                   |
###
##
##    # Check PaaS FundingAllocation.FundingAllocation (J131)
##    Then the following Funding Allocations data is present in PaaS
##    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
##    | 10018056 | ALLB-AY-2425-Contract-Provider-10018056-3_5             | 3_5            | AY-2425 | ALLB                        | 5000.00     | ?               | ?                 | ?                                 |
##
#

    # Publish the contract

    # Change the date 
    Given the override date is '08/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
#    And   a file with filename '10018042_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
#    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
#    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table
#
#    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018056 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |


#    Given the override date is '08/07/2023'
#        
#     # Withdraw v1 of the contract 
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'ALLB test withdrawal' by 'FCS1 Test'
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018056 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |


   # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'


    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018056 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#
##    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
##    And   the following Funding Allocations data is present in CRM
##    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
##    | 10018056 | 10018056 Co Ltd  | ALLB-AY-2425-Contract-Provider-10018056-3_5             | 3_5            | Education & Skills Funding | AY2425  | Contract for Services (ITP)              | ALLB                        | LOANS2425       | Contract Approved | Contract Approved | 5000.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS_ITP]       | ?          | ?                   |
##
##    # Check PaaS FundingAllocation.FundingAllocation (J131)
##    And   the following Funding Allocations data is present in PaaS
##    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
##    | 10018056 | ALLB-AY-2425-Contract-Provider-10018056-3_5             | 3_5            | AY-2425 | ALLB                        | 5000.00     | [CfS_ITP]       | ContractApproved  | ContractApproved                  |
##
##    # Check that the CRM Funding Allocation Workflow History includes an approval
##    And   the following Funding Allocation Workflow History data is present in CRM
##    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
##    | ALLB-AY-2425-Contract-Provider-10018056-3_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
##
##    # Test CRM details against same in ContractManagement feed (30447)
##    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
##
##    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
##    Then  the Legal Contract CM feed contains the following '1' deliverables
##    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
##    | 10018056 | [ContractNo]   | 1               | [AllocRef_ALLB]  | 1               | 0                     | 5000.00      | 0             | 0        | Total Advanced Learner Loans Bursary Funding   | ?                           |
##
##  
#
    # Populate the stub with 1619 (Further education) data

    # Change the date 
    Given the override date is '11/07/2024'

    # Clear down the CfS_ITP stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018056 | 1619-AS-2425-Contract-Provider-10018056-3_7           | 3_7            | 1619                        | AS-2425            | 54147.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType   | ProviderSubType     | ProviderFundingTotalValue |
    | 1619-AS-2425-10018056-3_7  | 3_7                    | 1619-AS-2425-Contract-Provider-10018056-3_7           | 10018056      | Furth	       | 02IPP	             | 54147.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2425-10018056-3_7  | 1619-002        | 6899.00          | Payment         |
    | 1619-AS-2425-10018056-3_7  | 1619-005        | 21458.00         | Payment         |
    | 1619-AS-2425-10018056-3_7  | 1619-006        | 11338.00         | Payment         |
    | 1619-AS-2425-10018056-3_7  | 1619-008        | 11441.00         | Payment         |
    | 1619-AS-2425-10018056-3_7  | 1619-010        | 3011.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2425-10018056-3_7  | 1619-002        | FY-2425              | October                | 2024              | 2488.00                   |
    | 1619-AS-2425-10018056-3_7  | 1619-002        | FY-2425              | March                  | 2025              | 4411.00                   |
    #
    | 1619-AS-2425-10018056-3_7  | 1619-005        | FY-2425              | October                | 2024              | 5280.00                   |
    | 1619-AS-2425-10018056-3_7  | 1619-005        | FY-2425              | January                | 2025              | 3784.00                   |
    | 1619-AS-2425-10018056-3_7  | 1619-005        | FY-2425              | February               | 2025              | 4270.00                   |
    | 1619-AS-2425-10018056-3_7  | 1619-005        | FY-2425              | May                    | 2025              | 5750.00                   |
    | 1619-AS-2425-10018056-3_7  | 1619-005        | FY-2425              | July                   | 2025              | 2374.00                   |
    #
    | 1619-AS-2425-10018056-3_7  | 1619-006        | FY-2425              | October                | 2024              | 4319.00                   |
    | 1619-AS-2425-10018056-3_7  | 1619-006        | FY-2425              | February               | 2025              | 4874.00                   |
    | 1619-AS-2425-10018056-3_7  | 1619-006        | FY-2425              | April                  | 2025              | 2145.00                   |
    #
    | 1619-AS-2425-10018056-3_7  | 1619-008        | FY-2425              | September              | 2024              | 3007.00                   |
    | 1619-AS-2425-10018056-3_7  | 1619-008        | FY-2425              | December               | 2024              | 4588.00                   |
    | 1619-AS-2425-10018056-3_7  | 1619-008        | FY-2425              | April                  | 2025              | 3846.00                   |
    #
    | 1619-AS-2425-10018056-3_7  | 1619-010        | FY-2425              | July                   | 2025              | 3011.00                   |
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '12/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                          | ReleaseGroupParameterName |
    | EDSK            | AY2425        | 16-19ED2425  | Contract for Services (ITP)           | CfS_ITP                |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018056 | 10018056 Co Ltd  | 1619-AS-2425-Contract-Provider-10018056-3_7             | 3_7            | Education & Skills Funding | AY2425  | Contract for Services (ITP)              | 1619                        | 16-19ED2425     | Scheduling        | Awaiting Release  | 54147.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2425-Contract-Provider-10018056-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 54147.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018056 | 1619-AS-2425-Contract-Provider-10018056-3_7             | 3_7            | AS-2425 | 1619                        | 54147.00    | [CfS_ITP]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'



    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '13/07/2024'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS_ITP]      |

    Then wait '30' seconds

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 54147.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018056' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018056' for FundingType 'EDSK' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                           | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018056 | 10018056 Co Ltd  | 1619-AS-2425-Contract-Provider-10018056-3_7             | 3_7            | Education & Skills Funding | AY2425  | Contract for Services (ITP)            | 1619                        | 16-19ED2425     | Released          | Released          | 54147.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]         | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2425-Contract-Provider-10018056-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2425-Contract-Provider-10018056-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018056 | 1619-AS-2425-Contract-Provider-10018056-3_7             | 3_7            | AS-2425 | 1619                        | 54147.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2425-Contract-Provider-10018056-3_7             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018056 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#

    And   Sharepoint file '10018056_[ContractNo]_v2.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018056_[ContractNo]_v2.pdf'



    # Publish the contract

    # Change the date 
    Given the override date is '14/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
#    And   a file with filename '10018042_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
#    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
#    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table
#
#    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018056 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |


#    Given the override date is '08/07/2023'
#        
#     # Withdraw v1 of the contract 
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'ALLB test withdrawal' by 'FCS1 Test'
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018056 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |


   # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'


    # Approve the contract

    # Change the date 
    Given the override date is '15/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
##    # Check the CONTRACT version, status and dates in CRM
##    And   the following contract values are present in CRM
##    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
##    | 10018056 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
##    | 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
###



#
#    # Change the date 
#    Given the override date is '17/07/2024'
#
#    # Clear down the CFS stub
#    And   there is no data in the CFS stub
#
#    # Funding Allocation 
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10018056 | ALL-AY-2425-Contract-Provider-10018056-3_9           	| 3_9            | ALL                         | AY-2425            | 1000.00           |
# 
#    # Provider Funding Allocation
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | ALL-AY-2425-10018056-3_9   | 3_9                    | ALL-AY-2425-Contract-Provider-10018056-3_9            | 10018056      | Furth        | 02IPP           | 1000.00                   |
# 
#    # Funding Allocation Line (aka Deliverable)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | ALL-AY-2425-10018056-3_9   | ALL-002         | null          | Payment         |
#    | ALL-AY-2425-10018056-3_9   | ALL-003         | 632.00        | Payment         |
#    | ALL-AY-2425-10018056-3_9   | ALL-001         | 368.00        | Payment         |
#
# 
#    # Funding Allocation Profile Period
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | ALL-AY-2425-10018056-3_9   | ALL-001         | FY-2425              | April	               | 2025              | 368.00                    |
#    | ALL-AY-2425-10018056-3_9   | ALL-003         | FY-2425              | December	           | 2024              | 632.00                    |
#
# 
 



    # Amend contract

    # Change the date
    Given the override date is '17/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018056 | LOANS-AY-2425-Contract-Provider-10018056-3_9          | 3_9            | LOANS                       | AY-2425            | 22415.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | LOANS-AY-2425-10018056-3_9 | 3_9                    | LOANS-AY-2425-Contract-Provider-10018056-3_9          | 10018056      | Furth        | 02IPP           | 22415.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | LOANS-AY-2425-10018056-3_9 | LOANS-001       | 22415.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | LOANS-AY-2425-10018056-3_9  | LOANS-001        | FY-2425              | August                 | 2024              | 3172.00                   |
    | LOANS-AY-2425-10018056-3_9  | LOANS-001        | FY-2425              | December               | 2024              | 4892.00                   |
    | LOANS-AY-2425-10018056-3_9  | LOANS-001        | FY-2425              | March                  | 2025              | 5859.00                   |
    | LOANS-AY-2425-10018056-3_9  | LOANS-001        | FY-2425              | May                    | 2025              | 2959.00                   |
    | LOANS-AY-2425-10018056-3_9  | LOANS-001        | FY-2425              | June                   | 2025              | 5533.00                   |
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '18/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

 
    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | LOANS2425    | Contract for Services (ITP)             | CFS2                      |

    # Write the following values to the output window
    And   message 'ReleaseGroup CFS2 = [CFS2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018056 | 10018056 Co Ltd  | LOANS-AY-2425-Contract-Provider-10018056-3_9            | 3_9            | Education & Skills Funding | AY2425  | Contract for Services (ITP)              | LOANS                       | LOANS2425       | Scheduling        | Awaiting Release  | 22415.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CFS2]            | ?          | ?                   |

#    # Check the CRM Funding Allocation Workflow History data
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | ALLB-AY-2425-Contract-Provider-10018056-4_9             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
#
#    # Check the state of a Release Group in CRM (J129)
#    And   Release Group '[CFS2]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Awaiting Release  | 1               | 22415.00        |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10018056 | ALLB-AY-2425-Contract-Provider-10018056-4_8             | 4_8            | AY-2425 | ALLB                        | 22415.00    | [CFS2]          | ?                 | ?                                 |
#
#    # Check PaaS FundingAllocation.ReleaseGroup (J132)
#    And   Release Group '[CFS2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'
#
#
#        # Check the CRM Funding Allocations data (J125)
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                  | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status             | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
#    | 10017721 | 10017721 Co Ltd  | 1619-AS-2021-Contract-Provider-10017721-3_2             | 3_2            | Education & Skills Funding   | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling         | Returned to Scheduling  | 20008.00    | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               |

    ## Check PaaS FundingAllocation.FundingAllocation (J131)
    #Then  the following Funding Allocations data is present in PaaS
    #| UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    #| 10017721 | 1619-AS-2021-Contract-Provider-10017721-4_1             | 4_1            | AS-2021 | 1619                        | 23719.00    | ?               | Parked            | AwaitingOutcome                   |
    #| 10017721 | 1619-AS-2021-Contract-Provider-10017721-3_2             | 3_2            | AS-2021 | 1619                        | 20008.00    | ?               | ?                 | ?                                 |




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '19/07/2024'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CFS2]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CFS2 = [CFS2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CFS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 22415.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018056' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018056' for FundingType 'ALLB' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018056 | 10018056 Co Ltd  | LOANS-AY-2425-Contract-Provider-10018056-3_9            | 3_9            | Education & Skills Funding | AY2425  | Contract for Services (ITP)              | LOANS                       | LOANS2425       | Released          | Released          | 22415.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CFS2]          | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | LOANS-AY-2425-Contract-Provider-10018056-3_9            | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | LOANS-AY-2425-Contract-Provider-10018056-3_9            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018056 | LOANS-AY-2425-Contract-Provider-10018056-3_9            | 3_9            | AY-2425 | LOANS                       | 22415.00    | [CFS2]          | ?                 | ?                                 |

    ## Check PaaS FundingAllocation.Contract
    #And   the following Funding Allocations and Contracts are linked in PaaS
    #| FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    #| ALL-AY-2425-Contract-Provider-10018056-3_9              | [ContractNo] | 3               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CFS2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018056 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | Variation     |
#    | 10018056 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#
#    # Check that the Contract and Master Contract have been created correctly in CRM
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10018056 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 22415.00      | 2                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Contract for Services (ITP)                     | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | [ContractNo]    | 10018056 Co Ltd  | Active | Document Management Team  | 17783.00               |
#    | 10018056 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Contract for Services (ITP)                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018056 Co Ltd  | Active | CRM Integration           | ?                      |
#
#    # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10018056 | [ContractNo]       | [AllocRef_ALLB]       | ?                             | 22415.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | ALLB          | ALLB2425            | Contract Allocation   | 17783.00                 |
#
#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                  | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_ALLB] | 1               | 22415.00  | 3172.00  | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 5859.00  | 0.00     | 2959.00  | 5533.00  | 0.00     | Total Advanced Learner Loans Bursary Funding     |                          |
#
#    # Contract is now at 'Draft\Awaiting Documentation'
#
#    # Check the deliverable count in CRM
#    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    ##Check the contents of the Appendices  (SoF and FA)
    #And   the file named '10018042_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    #"""
    #SUMMARY OF FUNDING
    #Organisation Name: 10018056 Co Ltd UKPRN: 10018056
    #Master Contract Number: [MasterContractNo]
    #Allocation
    #1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
    #Education & Skills Funding (ALLB) [AllocRef_ALLB] £13,923 £8,492 £22,415
    #Total: £22,415
    #Total Funding for this contract: £22,415
    #Summary of Funding – Page 1
    #
    #SCHEDULE 2
    #Funding Agreement
    #Provider: 10018056 Co Ltd UKPRN: 10018056
    #Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    #Contract Ref: [AllocRef_ALLB]
    #Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    #Education & Skills Funding (ALLB) £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Total Funding £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Schedule 2 – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v2
    #"""

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018056_[ContractNo]_v3.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018056_[ContractNo]_v3.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    #And   the following document creation details exist in the ContractManagement.CreatedContract table
    #| ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    #| [ContractNo]   | 3                     | 0                        | 2024-07-19 09:12:35.000 |

    ## Check the current state of the Tasks for this contract
    #Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10018056'
    #| Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    #| Initiate Document Merge   | 10018056 - 10018056 Co Ltd Awaiting documentation  | [AllocRef_ALLB] | Document Management Team  | ?                | Open       | Not Started   |

   # # Check the CRM Contract Workflow History data
   # And   the Workflow History for version '2' of contract '[ContractNo]' includes the following
   # | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   ##| 10018056 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   ##| 10018056 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   # | 10018056 | [MasterContractNo] | [ContractNo]   | 2                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |




    # Publish the contract

    # Change the date 
    Given the override date is '20/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    #And   a file with filename '10018055_[ContractNo]_v3.pdf' is created in 'EDSK-2425-Output-Merged Document'
    #And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    #And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    ## Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    #And   the following contract values are present in CRM
    #| UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    #| 10018056 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | Variation     |
    #| 10018056 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | False         | True                | 01/08/2024        | 31/07/2025      | ?             |
    #| 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |




    # Approve the contract

    # Change the date 
    Given the override date is '21/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'



#    
#
#    # Amend contract
#
#    # Change the date
#    Given the override date is '23/07/2023'
#
#    # Clear down the CFS stub
#    And   there is no data in the CFS stub
#
#    # Funding Allocation 
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10018056 | ALLB-AY-2425-Contract-Provider-10018056-4_9           | 4_9            | ALLB                        | AY-2425            | 20415.00          |
# 
#    # Provider Funding Allocation
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | ALLB-AY-2425-10018056-4_9  | 4_9                    | ALLB-AY-2425-Contract-Provider-10018056-4_9           | 10018056      | Furth        | 06SDC           | 20415.00                  |
# 
#    # Funding Allocation Line (aka Deliverable)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | ALLB-AY-2425-10018056-4_9  | ALLB            | 20415.00         | Payment         |
# 
#    # Funding Allocation Profile Period
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | ALLB-AY-2425-10018056-4_9  | ALLB            | FY-2425              | August                 | 2023              | 3172.00                   |
#    | ALLB-AY-2425-10018056-4_9  | ALLB            | FY-2425              | December               | 2023              | 2892.00                   |
#    | ALLB-AY-2425-10018056-4_9  | ALLB            | FY-2425              | March                  | 2024              | 5859.00                   |
#    | ALLB-AY-2425-10018056-4_9  | ALLB            | FY-2425              | May                    | 2024              | 2959.00                   |
#    | ALLB-AY-2425-10018056-4_9  | ALLB            | FY-2425              | June                   | 2024              | 5533.00                   |
# 
# 
# 
# 
#    # Consume stub data
# 
#    # Change the date 
#    Given the override date is '18/07/2023'
#
#    # Read stub and process into CRM
#    When  the feed-reading process is started and the CFS stub data is processed into CRM
#
#    # Capture the Release Group parameter value (J127)
#   #Given the Release Groups for the following Contracting Profiles have been saved
#    Given the Release Group for the following Contracting Profile has been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK            | AY2425        | ALLB2425     | Contract for Services (ITP)      | CFS2                       |
#
#    # Write the following values to the output window
#    And   message 'ReleaseGroup CFS2 = [CFS2]' is written to the Output window
#
#    # Check the CRM Funding Allocations data (J125)
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
#    | 10018056 | 10018056 Co Ltd  | ALLB-AY-2425-Contract-Provider-10018056-4_9             | 4_9            | Education & Skills Funding | AY2425  | Contract for Services (ITP)       | ALLB                        | ALLB2425        | Scheduling        | Awaiting Release  | 20415.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CFS2]             | ?          | ?                   |
#
#    # Check the CRM Funding Allocation Workflow History data
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | ALLB-AY-2425-Contract-Provider-10018056-4_9             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
#
#    # Check the state of a Release Group in CRM (J129)
#    And   Release Group '[CFS2]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Awaiting Release  | 1               | 20415.00        |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10018056 | ALLB-AY-2425-Contract-Provider-10018056-4_9             | 4_9            | AY-2425 | ALLB                        | 20415.00    | [CFS2]          | ?                 | ?                                 |
#
#    # Check PaaS FundingAllocation.ReleaseGroup (J132)
#    And   Release Group '[CFS2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'
#
#
#
#
#    # Release a Release Group (32953)
#
#    # Change the date 
#    Given the override date is '19/07/2023'
#
#    # Release Funding Allocations from Contract Control (J128)
#   #When  a request is triggered to release the following Release Groups together
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CFS2]             |
#
#    # Write the following values to the output window
#    And   message 'ReleaseGroup CFS2 = [CFS2]' is written to the Output window
#
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[CFS2]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 20415.00        |
#
#    # Retrieve parameters from CRM 
#    When  I retrieve the latest contract details from CRM for provider '10018056' for FundingType 'EDSK' and period '2425'
#   #When  I retrieve the latest EFA contract details from CRM for provider '10018056' for FundingType 'ALLB' and period '2425' and Delivery Organisation '?' 
#
#    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10018056 | 10018056 Co Ltd  | ALLB-AY-2425-Contract-Provider-10018056-4_9             | 4_9            | Education & Skills Funding | AY2425  | Contract for Services (ITP)       | ALLB                        | ALLB2425        | Released          | Released          | 20415.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CFS2]          | ?          | ?                   |
#

#
#
#    # Approve the contract
#
#    # Change the date 
#    Given the override date is '21/07/2023'
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
#    | 10018056 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | Variation     |
#    | 10018056 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018056 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#
#    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
#    And   the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10018056 | 10018056 Co Ltd  | ALLB-AY-2425-Contract-Provider-10018056-4_8             | 4_8            | Education & Skills Funding | AY2425  | Contract for Services (ITP)       | ALLB                        | ALLB2425        | Contract Approved | Contract Approved | 22415.00    | [ContractNo]  | 2                 | CRM Integration       | CRM Integration           | ?                         | [CfS]          | ?          | ?                   |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10018056 | ALLB-AY-2425-Contract-Provider-10018056-4_8             | 4_8            | AY-2425 | ALLB                        | 22415.00    | [CfS]          | ContractApproved  | ContractApproved                  |
#
#    # Check that the CRM Funding Allocation Workflow History includes an approval
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | ALLB-AY-2425-Contract-Provider-10018056-4_8             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
#    | 10018056 | [ContractNo]   | 2               | [AllocRef_ALLB]  | 1               | 0                     | 22415.00     | 0             | 0        | T-Levels for Adults Pilot                      | ?                           |
#
#
#
#    



    # Part 5: Add Actuals for 24/25 then check CRM

    # Add actuals to the contract for ALLB2425

    # Change the date
    Given the override date is '04/10/2024'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018056'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2024
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |  
    | ILR2425        | R02                  | ORG0018056     | CM             | 202408 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 156.38      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202408 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 114.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202408 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 114.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202409 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 2352.37     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202409 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 465.26      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202409 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202410 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 2029.73     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202410 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 1578.92     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202410 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202411 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 2456.58     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202411 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 647.63      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202411 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202412 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 1427.78     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202412 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 1516.24     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202412 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202501 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 903.61      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202501 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 1218.05     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202501 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202502 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 701.10      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202502 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 533.70      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202502 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202503 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 2227.66     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202503 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 829.39      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202503 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202504 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 1417.38     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202504 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 1918.11     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202504 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202505 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 1589.44     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202505 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 1711.23     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202505 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202506 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 1989.29     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202506 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 702.52      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202506 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202507 | ALLB2425         | [AllocRef_ALLB]          | ?          | 2               | 0            | 750.74      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202507 | ALLB2425         | [AllocRef_ALLB]          | ?          | 3               | 0            | 596.14      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202507 | ALLB2425         | [AllocRef_ALLB]          | ?          | 4               | 0            | 514.81      |
    #
    | ILR2425        | R02                  | ORG0018056     | CM             | 202408 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 656.38      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202408 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 614.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202408 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 614.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202409 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 2352.37     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202409 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 465.26      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202409 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202410 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 2029.73     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202410 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 1578.92     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202410 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202411 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 2456.58     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202411 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 647.63      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202411 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202412 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 1427.78     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202412 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 1516.24     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202412 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202501 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 903.61      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202501 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 1218.05     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202501 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202502 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 701.10      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202502 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 533.70      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202502 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202503 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 2227.66     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202503 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 829.39      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202503 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202504 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 1417.38     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202504 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 1918.11     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202504 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202505 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 1589.44     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202505 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 1711.23     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202505 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202506 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 1989.29     |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202506 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 702.52      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202506 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202507 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 750.74      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202507 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 596.14      |
    | ILR2425        | R02                  | ORG0018056     | CM             | 202507 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |



    Then wait '20' seconds


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    ##    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    #Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS2324' OrgId 'ORG0018056' and Collection 'R02' marked as unprocessed
    #And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS2324' OrgId 'ORG0018056' and Collection 'APPS77' marked as unprocessed
#
#    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered
#
    # Check financials

#    # Check the PLANNED VALUES in CRM on the latest approved contract
#    Then  the Planned Values are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
#    | [ContractNo]   | NSF23-0024     | 1               | 89738.00  | 7235.00  | 8287.00  | 3021.00  | 10867.00 | 9072.00  | 4890.00  | 7374.00  | 4146.00  | 3765.00  | 12363.00 | 12533.00 | 6185.00  | 
#    | [ContractNo]   | NSF23-0024     | 2               | 41067.00  | 5587.00  | 5130.00  | 661.00   | 4006.00  | 7763.00  | 714.00   | 120.00   | 1903.00  | 2392.00  | 4653.00  | 7933.00  | 205.00   | 
#    | [ContractNo]   | NSF23-0024     | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 5               | 48671.00  | 1648.00  | 3157.00  | 2360.00  | 6861.00  | 1309.00  | 4176.00  | 7254.00  | 2243.00  | 1373.00  | 7710.00  | 4600.00  | 5980.00  | 
#    | [ContractNo]   | NSF23-0024     | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_16TR]    | 1               | 106975.00 | 11441.00 | 6250.00  | 6419.00  | 11750.00 | 7439.00  | 8692.00  | 8660.00  | 10868.00 | 12195.00 | 10326.00 | 7980.00  | 4955.00  | 
#    | [ContractNo]   | [AllocRef_16TR]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 4               | 60557.00  | 6230.00  | 5572.00  | 3820.00  | 6963.00  | 5487.00  | 4075.00  | 6198.00  | 7780.00  | 5147.00  | 5094.00  | 3141.00  | 1050.00  | 
#    | [ContractNo]   | [AllocRef_16TR]    | 5               | 46418.00  | 5211.00  | 678.00   | 2599.00  | 4787.00  | 1952.00  | 4617.00  | 2462.00  | 3088.00  | 7048.00  | 5232.00  | 4839.00  | 3905.00  | 
#    | [ContractNo]   | [AllocRef_16TR]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#	#
#    | [ContractNo]   | STFI23-0024    | 1               | 48191.00  | 225.00   | 7921.00  | 735.00   | 6393.00  | 5321.00  | 6425.00  | 3113.00  | 5098.00  | 4981.00  | 7444.00  | 55.00    | 480.00   | 
#    | [ContractNo]   | STFI23-0024    | 2               | 57906.00  | 7157.00  | 3028.00  | 5353.00  | 4217.00  | 1786.00  | 6967.00  | 7327.00  | 2518.00  | 6882.00  | 7582.00  | 1754.00  | 3335.00  | 
#    | [ContractNo]   | STFI23-0024    | 3               | 45879.00  | 6542.00  | 650.00   | 6648.00  | 4557.00  | 767.00   | 4185.00  | 3994.00  | 342.00   | 5459.00  | 172.00   | 5968.00  | 6595.00  | 
#    | [ContractNo]   | STFI23-0024    | 4               | 41802.00  | 2603.00  | 6627.00  | 395.00   | 7412.00  | 2264.00  | 1807.00  | 5289.00  | 682.00   | 4439.00  | 3230.00  | 2635.00  | 4419.00  | 
#    | [ContractNo]   | STFI23-0024    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef 	  | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 2508.75   | 156.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 580.07    | 114.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 629.62    | 114.81   | 514.81   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	#
   #| [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
   #| [ContractNo]   | [AllocRef_ALLF]    | 2               | 3008.75   | 656.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
   #| [ContractNo]   | [AllocRef_ALLF]    | 6               | 1080.07   | 614.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
   #| [ContractNo]   | [AllocRef_ALLF]    | 7               | 1129.62   | 614.81   | 514.81   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 




##    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
##    And   the Reconciliation Data is calculated as follows 
##    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
##    | [ContractNo]   | NSF23-0024     | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 3               | 2755.17   | 0.00     | 2755.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 4               | 1482.48   | 0.00     | 1482.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 6               | 1905.17   | 0.00     | 1905.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 7               | 2729.42   | 0.00     | 2729.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 8               | 1610.99   | 0.00     | 1610.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 9               | 3909.62   | 0.00     | 3909.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 10              | 4114.97   | 0.00     | 4114.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    #
##    | [ContractNo]   | [AllocRef_16TR]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 2               | 3008.75   | 0.00     | 3008.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 3               | 980.07    | 0.00     | 980.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 6               | 2567.98   | 0.00     | 2567.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 7               | 2111.17   | 0.00     | 2111.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 8               | 1323.40   | 0.00     | 1323.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 9               | 3073.78   | 0.00     | 3073.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 10              | 2023.94   | 0.00     | 2023.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    #
#    | [ContractNo]   | STFI23-0024    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 5               | 5351.13   | 0.00     | 5351.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 6               | 4974.78   | 0.00     | 4974.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 7               | 6374.14   | 0.00     | 6374.14  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 8               | 4252.65   | 0.00     | 4252.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 9               | 5624.78   | 0.00     | 5624.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 10              | 6172.80   | 0.00     | 6172.80  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 11              | 4973.08   | 0.00     | 4973.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 12              | 6826.77   | 0.00     | 6826.77  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
##


    
    
    # Payment Batch for ALLB2425(PoP)

    # Change the date
    Given the override date is '08/10/2024 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLB2425' AccountingPaymentPeriod '202406' CensusEndDate '08/10/2024' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ALLB]          | 202409 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLB2425                   | 202409               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLB2425                   | 202409               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLB2425' PaymentPeriod '202406' CensusEndDate '08/10/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S056.xml'
#
#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ALLB2425' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | ALLB                   | 2023          | 05             | 02          | ?       | [AllocRef_ALLB]   | 562.00          | PROFILE          | Principals Ref Group               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208100    |
#    | ALLB                   | 2023          | 05             | 02          | ?       | [AllocRef_ALLB]   | 448.00          | PROFILE          | NationalLeadrs of FE               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208200    |
#    | ALLB                   | 2023          | 05             | 02          | ?       | [AllocRef_ALLB]   | 25.00           | PROFILE          | Isles of Scilly                    | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2202070    |
#
#

#
#    # Consolidated Payment Summary Report
#
#    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#    When a Consolidated Payment Summary Report is created in Sharepoint for '02/08/2023'
#
#    # Check the contents of the Consolidated Payment Summary Report manually



    # Change the date
    Given the override date is '09/10/2024 09:05'
    
   #  Part 10: Create Consolidated Payment Summary rpt
   
   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
   Given there are no files prefixed '2024-10 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder

   When  a Consolidated Payment Summary Report is created in Sharepoint for '09/10/2024'

    # Check the above report manually





    # Part 6: Create and check the contents of the CDA report
   
    # Change the date
    Given the override date is '11/10/2024'
    
    # Check the contents of the CDA report
    And   there is no CDA report named 'CDA Last Approved Version S056.csv'

    And   the following ADF Pipeline run

    #And   the following contracts are in the replicated CRM database
    #| ContractNumber  | ContractVersionNumber |
    #| [ContractNo]    | 3                     |

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod	| Version               | Suffix |
    | ALLB2425              | Last Approved         | S056   |

    Then  a report named 'CDA Last Approved Version S056.csv' is created




    # Tidy Up
    Given the override date is reset

