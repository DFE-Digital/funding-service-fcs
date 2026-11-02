Feature: AdultfundingCFSonboarding


@AcceptanceTest @Withdrawn20251024
@CFS
Scenario: S042 Import and release a ATLP2324 FA. Approve. Check docs, CRM and feed. Amend and repeat
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018042'
    And   there is no Funding Allocation data in CRM for UKPRN '10018042'
    And   there is no Contract, Task or Workflow data for UKPRN '10018042'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018042'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018042'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018042' in the Sharepoint 'EDSK-2324-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2324        | ATLP2324     | Accountability Agreement (College)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ATLP2324          |

	
    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018042'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018042' 
    And   there is no caseload advisor for UKPRN '10018042' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018042 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018042' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018042 Co Ltd' with UKPRN '10018042' and OrgId 'ORG0018042' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018042 | 118042 | 10018042 Co Ltd | 0              | Active                | Yes           | AA018042      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018042 |







    # Populate the stub with ATLP (06SDC) data

    # Change the date 
    Given the override date is '01/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-3_5           | 3_5            | ATLP                        | AY-2324            | 4632.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | ATLP-AY-2324-10018042-3_5  | 3_5                    | ATLP-AY-2324-Contract-Provider-10018042-3_5           | 10018042      | Furth        | 05ADC           | 4632.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | ATLP-AY-2324-10018042-3_5  | ATLP            | 4632.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | ATLP-AY-2324-10018042-3_5  | ATLP            | FY-2324              | May                    | 2024              | 4632.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2324        | ATLP2324     | Accountability Agreement (College)      | CfS                       |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS = [CfS]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018042 | 10018042 Co Ltd  | ATLP-AY-2324-Contract-Provider-10018042-3_5             | 3_5            | Education & Skills Funding | AY2324  | Accountability Agreement (College)       | ATLP                        | ATLP2324        | Scheduling        | Awaiting Release  | 4632.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ATLP-AY-2324-Contract-Provider-10018042-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 4632.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-3_5             | 3_5            | AY-2324 | ATLP                        | 4632.00     | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2023'

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
    | Released          | 1               | 4632.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018042' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018042' for FundingType 'ATLP' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018042 | 10018042 Co Ltd  | ATLP-AY-2324-Contract-Provider-10018042-3_5             | 3_5            | Education & Skills Funding | AY2324  | Accountability Agreement (College)       | ATLP                        | ATLP2324        | Released          | Released          | 4632.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ATLP-AY-2324-Contract-Provider-10018042-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | ATLP-AY-2324-Contract-Provider-10018042-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-3_5             | 3_5            | AY-2324 | ATLP                        | 4632.00     | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | ATLP-AY-2324-Contract-Provider-10018042-3_5             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018042 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018042 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018042 | [ContractNo]       | Education & Skills Funding                 | Contract      | Draft          | Awaiting Documentation  | 4632.00       | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Accountability Agreement (College)                     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2324 | ?               | 10018042 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10018042 | [MasterContractNo] | Education & Skills Funding                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Accountability Agreement (College)                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018042 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018042 | [ContractNo]       | [AllocRef_ATLP]       | ?                             | 4632.00         | ?             | ?                | 01/08/2023 | 31/07/2024 | ATLP          | ATLP2324            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_ATLP] | 1               | 4632.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4632.00  | 0.00     | 0.00     | T-Levels for Adults Pilot                               |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
#
#     #Check the contents of the Appendices
#    And   the file named '10018042_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
#    """
#
#    SUMMARY OF FUNDING
#    Organisation Name: 10018042 Co Ltd UKPRN: 10018042
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
#    Education & Skills Funding (ATLP) [AllocRef_ATLP] £0 £4,632 £4,632
#    Total: £4,632
#    Total Funding for this contract: £4,632
#    Summary of Funding – Page 1
#    Agreement Type Accountability Agreement (College)
#    st st st
#    1 August 2023 to 31 July 2025 or 31 July 2026 if
#    Funding Period
#    extended by the Department pursuant to Clause 2.3
#    Between the Secretary of State for Education
#    And 10018042 Co Ltd
#    Funding for Education & Skills Funding (ATLP)
#    Master Contract Number [MasterContractNo]
#    ACCEPTANCE BY THE CONTRACTOR
#    BY ACCEPTING THIS CONTRACT VIA THE MANAGE YOUR EDUCATION &
#    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF
#    OF THE CONTRACTOR REPRESENTS AND WARRANTS THAT THE
#    CONTRACTOR HAS READ AND UNDERSTOOD THIS CONTRACT, THE
#    CONTRACTOR AGREES TO BE BOUND BY THIS CONTRACT AND THAT
#    HE/SHE IS DULY AUTHORISED TO ACCEPT THIS CONTRACT AND LEGALLY
#    BIND THE CONTRACTOR.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    ATLP Version 2 (September 2023) Page 1
#    This Contract is made on the date the Contract is digitally signed by the
#    Contractor on the Manage Your Education & Skills Funding Service between:
#    10018042 Co Ltd THE SECRETARY OF STATE FOR
#    9 Kneesworth Street EDUCATION
#    Royston DEPARTMENT FOR EDUCATION
#    Hertfordshire 20 GREAT SMITH STREET
#    AND
#    SG8 5AA LONDON
#    SW1P 3BT
#    Company No: AA018042
#    Hereinafter called Hereinafter called
#    the Contractor the Department
#    ATLP Version 2 (September 2023) Page 2
#    SCHEDULE 1: SPECIFICATION & MONITORING
#    Education & Skills Funding (ATLP) SPECIFICATION
#    ATLP Schedule 1 – Annex 1 Version 1 (July 2023) – Page 2
#    SCHEDULE 2: PAYMENT
#    Education & Skills Funding (ATLP) PAYMENT
#    ATLP Schedule 2 Version 1 (July 2023) – Page 1
#    SCHEDULE 2
#    Funding Agreement
#    Provider: 10018042 Co Ltd UKPRN: 10018042
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
#    Contract Ref: [AllocRef_ATLP]
#    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
#    Education & Skills Funding (ATLP) £4,632 £0 £0 £0 £0 £0 £0 £0 £0 £0 £4,632 £0 £0
#    Total Funding £4,632 £0 £0 £0 £0 £0 £0 £0 £0 £0 £4,632 £0 £0
#    Schedule 2 – Funding Agreement [AllocRef_ATLP] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    SCHEDULE 3: CHANGE CONTROL PROCEDURE
#    ATLP Schedule 3 Version 1 (July 2023) – Page 1
#    SCHEDULE 9: CONTRACTOR’S RESPONSE/PROPOSALS
#    ATLP Schedule 9 Version 1 (July 2023) – Page 1
#    SCHEDULE 10: SUB-CONTRACTING
#    ATLP Schedule 10 Version 1 (July 2023) – Page 5
#    """
# 



    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018042_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018042_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018042'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018042 - 10018042 Co Ltd Awaiting documentation  | [AllocRef_ATLP] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018042 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018042 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018042 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |



#        # 2. Delete the draft contract. FA1 -> Return to Scheduling
#
#    # Change to date
#    Given the override date is '07/07/2023'
#
#    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
#    When  a request is initiated in CRM to delete the following contracts
#   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10018042 | [ContractNo]   | 1                     | 0                  |
#
##
##    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
##    Then  the following Funding Allocations data is present in CRM
##    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus                       | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
##    | 10018042 | 10018042 Co Ltd  | ATLP-AY-2324-Contract-Provider-10018042-3_5             | 3_5            | Education & Skills Funding | AY2324  | Accountability Agreement (College)       | ATLP                        | ATLP2324        | Scheduling        | Returned to Scheduling          | 4632.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           | ?          | ?                   |
##
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    Then the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-3_5             | 3_5            | AY-2324 | ATLP                        | 4632.00     | ?               | ?                 | ?                                 |
#


    # Publish the contract

    # Change the date 
    Given the override date is '08/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018042_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018042 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018042 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |


#    Given the override date is '08/07/2023'
#        
#     # Withdraw v1 of the contract 
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'ATLP test withdrawal' by 'FCS1 Test'
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018042 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#    | 10018042 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |




    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018042 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018042 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018042 | 10018042 Co Ltd  | ATLP-AY-2324-Contract-Provider-10018042-3_5             | 3_5            | Education & Skills Funding | AY2324  | Accountability Agreement (College)       | ATLP                        | ATLP2324        | Contract Approved | Contract Approved | 4632.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-3_5             | 3_5            | AY-2324 | ATLP                        | 4632.00     | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ATLP-AY-2324-Contract-Provider-10018042-3_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10018042 | [ContractNo]   | 1               | [AllocRef_ATLP]  | 1               | 0                     | 4632.00      | 0             | 0        | T-Levels for Adults Pilot                      | ?                           |


    # Populate the stub with 1619 (Further education) data

    # Change the date 
    Given the override date is '11/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018042 | 1619-AS-2324-Contract-Provider-10018042-3_7           | 3_7            | 1619                        | AS-2324            | 54147.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType   | ProviderSubType     | ProviderFundingTotalValue |
    | 1619-AS-2324-10018042-3_7  | 3_7                    | 1619-AS-2324-Contract-Provider-10018042-3_7           | 10018042      | Furth	       | 05ADC	             | 54147.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2324-10018042-3_7  | 1619-002        | 6899.00          | Payment         |
    | 1619-AS-2324-10018042-3_7  | 1619-005        | 21458.00         | Payment         |
    | 1619-AS-2324-10018042-3_7  | 1619-006        | 11338.00         | Payment         |
    | 1619-AS-2324-10018042-3_7  | 1619-008        | 11441.00         | Payment         |
    | 1619-AS-2324-10018042-3_7  | 1619-010        | 3011.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2324-10018042-3_7  | 1619-002        | FY-2324              | October                | 2023              | 2488.00                   |
    | 1619-AS-2324-10018042-3_7  | 1619-002        | FY-2324              | March                  | 2024              | 4411.00                   |
    #
    | 1619-AS-2324-10018042-3_7  | 1619-005        | FY-2324              | October                | 2023              | 5280.00                   |
    | 1619-AS-2324-10018042-3_7  | 1619-005        | FY-2324              | January                | 2024              | 3784.00                   |
    | 1619-AS-2324-10018042-3_7  | 1619-005        | FY-2324              | February               | 2024              | 4270.00                   |
    | 1619-AS-2324-10018042-3_7  | 1619-005        | FY-2324              | May                    | 2024              | 5750.00                   |
    | 1619-AS-2324-10018042-3_7  | 1619-005        | FY-2324              | July                   | 2024              | 2374.00                   |
    #
    | 1619-AS-2324-10018042-3_7  | 1619-006        | FY-2324              | October                | 2023              | 4319.00                   |
    | 1619-AS-2324-10018042-3_7  | 1619-006        | FY-2324              | February               | 2024              | 4874.00                   |
    | 1619-AS-2324-10018042-3_7  | 1619-006        | FY-2324              | April                  | 2024              | 2145.00                   |
    #
    | 1619-AS-2324-10018042-3_7  | 1619-008        | FY-2324              | September              | 2023              | 3007.00                   |
    | 1619-AS-2324-10018042-3_7  | 1619-008        | FY-2324              | December               | 2023              | 4588.00                   |
    | 1619-AS-2324-10018042-3_7  | 1619-008        | FY-2324              | April                  | 2024              | 3846.00                   |
    #
    | 1619-AS-2324-10018042-3_7  | 1619-010        | FY-2324              | July                   | 2024              | 3011.00                   |
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '12/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                          | ReleaseGroupParameterName |
    | EDSK            | AY2324        | 16-19ED2324  | Accountability Agreement (College)    | AA_College                |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018042 | 10018042 Co Ltd  | 1619-AS-2324-Contract-Provider-10018042-3_7             | 3_7            | Education & Skills Funding | AY2324  | Accountability Agreement (College)       | 1619                        | 16-19ED2324     | Scheduling        | Awaiting Release  | 54147.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_College]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2324-Contract-Provider-10018042-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 54147.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018042 | 1619-AS-2324-Contract-Provider-10018042-3_7             | 3_7            | AS-2324 | 1619                        | 54147.00    | [AA_College]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'



    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '13/07/2023'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [AA_College]      |

    Then wait '60' seconds

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 54147.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018042' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018042' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                           | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018042 | 10018042 Co Ltd  | 1619-AS-2324-Contract-Provider-10018042-3_7             | 3_7            | Education & Skills Funding | AY2324  | Accountability Agreement (College)     | 1619                        | 16-19ED2324     | Released          | Released          | 54147.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_College]         | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2324-Contract-Provider-10018042-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2324-Contract-Provider-10018042-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018042 | 1619-AS-2324-Contract-Provider-10018042-3_7             | 3_7            | AS-2324 | 1619                        | 54147.00    | [AA_College]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2324-Contract-Provider-10018042-3_7             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018042 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
#    | 10018042 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#


    # Amend contract

    # Change the date
    Given the override date is '17/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-3_9           | 3_9            | ATLP                        | AY-2324            | 22415.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | ATLP-AY-2324-10018042-3_9  | 3_9                    | ATLP-AY-2324-Contract-Provider-10018042-3_9           | 10018042      | Furth        | 06SDC           | 22415.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | ATLP-AY-2324-10018042-3_9  | ATLP            | 22415.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | ATLP-AY-2324-10018042-3_9  | ATLP            | FY-2324              | August                 | 2023              | 3172.00                   |
    | ATLP-AY-2324-10018042-3_9  | ATLP            | FY-2324              | December               | 2023              | 4892.00                   |
    | ATLP-AY-2324-10018042-3_9  | ATLP            | FY-2324              | March                  | 2024              | 5859.00                   |
    | ATLP-AY-2324-10018042-3_9  | ATLP            | FY-2324              | May                    | 2024              | 2959.00                   |
    | ATLP-AY-2324-10018042-3_9  | ATLP            | FY-2324              | June                   | 2024              | 5533.00                   |
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '18/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

 
    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2324        | ATLP2324     | Accountability Agreement (College)      | CFS2                      |

    # Write the following values to the output window
    And   message 'ReleaseGroup CFS2 = [CFS2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018042 | 10018042 Co Ltd  | ATLP-AY-2324-Contract-Provider-10018042-3_9             | 3_9            | Education & Skills Funding | AY2324  | Accountability Agreement (College)       | ATLP                        | ATLP2324        | Scheduling        | Awaiting Release  | 22415.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CFS2]             | ?          | ?                   |

#    # Check the CRM Funding Allocation Workflow History data
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | ATLP-AY-2324-Contract-Provider-10018042-4_9             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
#
#    # Check the state of a Release Group in CRM (J129)
#    And   Release Group '[CFS2]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Awaiting Release  | 1               | 22415.00        |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-4_8             | 4_8            | AY-2324 | ATLP                        | 22415.00    | [CFS2]          | ?                 | ?                                 |
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
    Given the override date is '19/07/2023'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CFS2]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CFS2 = [CFS2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CFS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 22415.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018042' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018042' for FundingType 'ATLP' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018042 | 10018042 Co Ltd  | ATLP-AY-2324-Contract-Provider-10018042-3_9             | 3_9            | Education & Skills Funding | AY2324  | Accountability Agreement (College)       | ATLP                        | ATLP2324        | Released          | Released          | 22415.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CFS2]          | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ATLP-AY-2324-Contract-Provider-10018042-3_9             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | ATLP-AY-2324-Contract-Provider-10018042-3_9             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-3_9             | 3_9            | AY-2324 | ATLP                        | 22415.00    | [CFS2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | ATLP-AY-2324-Contract-Provider-10018042-3_9             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CFS2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018042 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10018042 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018042 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018042 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 22415.00      | 2                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Accountability Agreement (College)                     | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2324 | [ContractNo]    | 10018042 Co Ltd  | Active | Document Management Team  | 17783.00               |
    | 10018042 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Accountability Agreement (College)                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018042 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10018042 | [ContractNo]       | [AllocRef_ATLP]       | ?                             | 22415.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | ATLP          | ATLP2324            | Contract Allocation   | 17783.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                  | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_ATLP] | 1               | 22415.00  | 3172.00  | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 5859.00  | 0.00     | 2959.00  | 5533.00  | 0.00     | T-Levels for Adults Pilot    |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    ##Check the contents of the Appendices  (SoF and FA)
    #And   the file named '10018042_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    #"""
    #SUMMARY OF FUNDING
    #Organisation Name: 10018042 Co Ltd UKPRN: 10018042
    #Master Contract Number: [MasterContractNo]
    #Allocation
    #1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
    #Education & Skills Funding (ATLP) [AllocRef_ATLP] £13,923 £8,492 £22,415
    #Total: £22,415
    #Total Funding for this contract: £22,415
    #Summary of Funding – Page 1
    #
    #SCHEDULE 2
    #Funding Agreement
    #Provider: 10018042 Co Ltd UKPRN: 10018042
    #Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    #Contract Ref: [AllocRef_ATLP]
    #Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    #Education & Skills Funding (ATLP) £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Total Funding £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Schedule 2 – Funding Agreement [AllocRef_ATLP] – Page 1 Ref (for internal use only):  [ContractNo] v2
    #"""

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018042_[ContractNo]_v2.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018042_[ContractNo]_v2.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2023-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10018042'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018042 - 10018042 Co Ltd Awaiting documentation  | [AllocRef_ATLP] | Document Management Team  | ?                | Open       | Not Started   |

   # # Check the CRM Contract Workflow History data
   # And   the Workflow History for version '2' of contract '[ContractNo]' includes the following
   # | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   ##| 10018042 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   ##| 10018042 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   # | 10018042 | [MasterContractNo] | [ContractNo]   | 2                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |




    # Publish the contract

    # Change the date 
    Given the override date is '20/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018042_[ContractNo]_v2.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    ## Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    #And   the following contract values are present in CRM
    #| UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    #| 10018042 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    #| 10018042 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    #| 10018042 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |




    # Approve the contract

    # Change the date 
    Given the override date is '21/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

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
#    | Contracting    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-4_9           | 4_9            | ATLP                        | AY-2324            | 20415.00          |
# 
#    # Provider Funding Allocation
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | ATLP-AY-2324-10018042-4_9  | 4_9                    | ATLP-AY-2324-Contract-Provider-10018042-4_9           | 10018042      | Furth        | 06SDC           | 20415.00                  |
# 
#    # Funding Allocation Line (aka Deliverable)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | ATLP-AY-2324-10018042-4_9  | ATLP            | 20415.00         | Payment         |
# 
#    # Funding Allocation Profile Period
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | ATLP-AY-2324-10018042-4_9  | ATLP            | FY-2324              | August                 | 2023              | 3172.00                   |
#    | ATLP-AY-2324-10018042-4_9  | ATLP            | FY-2324              | December               | 2023              | 2892.00                   |
#    | ATLP-AY-2324-10018042-4_9  | ATLP            | FY-2324              | March                  | 2024              | 5859.00                   |
#    | ATLP-AY-2324-10018042-4_9  | ATLP            | FY-2324              | May                    | 2024              | 2959.00                   |
#    | ATLP-AY-2324-10018042-4_9  | ATLP            | FY-2324              | June                   | 2024              | 5533.00                   |
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
#    | EDSK            | AY2324        | ATLP2324     | Accountability Agreement (College)      | CFS2                       |
#
#    # Write the following values to the output window
#    And   message 'ReleaseGroup CFS2 = [CFS2]' is written to the Output window
#
#    # Check the CRM Funding Allocations data (J125)
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
#    | 10018042 | 10018042 Co Ltd  | ATLP-AY-2324-Contract-Provider-10018042-4_9             | 4_9            | Education & Skills Funding | AY2324  | Accountability Agreement (College)       | ATLP                        | ATLP2324        | Scheduling        | Awaiting Release  | 20415.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CFS2]             | ?          | ?                   |
#
#    # Check the CRM Funding Allocation Workflow History data
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | ATLP-AY-2324-Contract-Provider-10018042-4_9             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
#
#    # Check the state of a Release Group in CRM (J129)
#    And   Release Group '[CFS2]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Awaiting Release  | 1               | 20415.00        |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-4_9             | 4_9            | AY-2324 | ATLP                        | 20415.00    | [CFS2]          | ?                 | ?                                 |
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
#    When  I retrieve the latest contract details from CRM for provider '10018042' for FundingType 'EDSK' and period '2324'
#   #When  I retrieve the latest EFA contract details from CRM for provider '10018042' for FundingType 'ATLP' and period '2324' and Delivery Organisation '?' 
#
#    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10018042 | 10018042 Co Ltd  | ATLP-AY-2324-Contract-Provider-10018042-4_9             | 4_9            | Education & Skills Funding | AY2324  | Accountability Agreement (College)       | ATLP                        | ATLP2324        | Released          | Released          | 20415.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CFS2]          | ?          | ?                   |
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
#    | 10018042 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | Variation     |
#    | 10018042 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#    | 10018042 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#
#    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
#    And   the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10018042 | 10018042 Co Ltd  | ATLP-AY-2324-Contract-Provider-10018042-4_8             | 4_8            | Education & Skills Funding | AY2324  | Accountability Agreement (College)       | ATLP                        | ATLP2324        | Contract Approved | Contract Approved | 22415.00    | [ContractNo]  | 2                 | CRM Integration       | CRM Integration           | ?                         | [CfS]          | ?          | ?                   |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10018042 | ATLP-AY-2324-Contract-Provider-10018042-4_8             | 4_8            | AY-2324 | ATLP                        | 22415.00    | [CfS]          | ContractApproved  | ContractApproved                  |
#
#    # Check that the CRM Funding Allocation Workflow History includes an approval
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | ATLP-AY-2324-Contract-Provider-10018042-4_8             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
#    | 10018042 | [ContractNo]   | 2               | [AllocRef_ATLP]  | 1               | 0                     | 22415.00     | 0             | 0        | T-Levels for Adults Pilot                      | ?                           |
#
#
#
#    
    
#    
#    # Payment Batch for ATLP2324(PoP)
#
#    # Change the date
#    Given the override date is '02/08/2023 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'ATLP2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_ATLP]          | 202308 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | ATLP2324                   | 202308               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | ATLP2324                   | 202308               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ATLP2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S042.xml'
##
##    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
##    And   the Payment feed xml for FundingStreamPeriod 'ATLP2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' includes the following values
##    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
##    | ATLP                   | 2023          | 05             | 02          | ?       | [AllocRef_ATLP]   | 562.00          | PROFILE          | Principals Ref Group               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208100    |
##    | ATLP                   | 2023          | 05             | 02          | ?       | [AllocRef_ATLP]   | 448.00          | PROFILE          | NationalLeadrs of FE               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208200    |
##    | ATLP                   | 2023          | 05             | 02          | ?       | [AllocRef_ATLP]   | 25.00           | PROFILE          | Isles of Scilly                    | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2202070    |
##
##
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
#    # Change the date
#    Given the override date is '03/08/2023 09:05'
#    
#   #  Part 10: Create Consolidated Payment Summary rpt
#   
#   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#   Given there are no files prefixed '2023-08 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
#
#   When  a Consolidated Payment Summary Report is created in Sharepoint for '03/08/2023'
#
#    # Check the above report manually
#
#
#
#    # Change the date
#    Given the override date is '04/08/2023 09:05'
#
#    # CDA
#    
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version S042.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 2                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | ATLP2324              | Latest Version        | S042   |
#
#    Then  a report named 'CDA Latest Version S042.csv' is created
#	# Check the above report manually



    # Tidy Up
    Given the override date is reset


