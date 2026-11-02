Feature: Adultfunding_ASFG2425


@AcceptanceTest @Withdrawn20260521
@CFS
Scenario: S057 Import and release a ASFC-ASCL2425, ASFC-FCFJ2425 allocation. Approve. Check docs, CRM and feed.
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018057'
    And   there is no Funding Allocation data in CRM for UKPRN '10018057'
    And   there is no Contract, Task or Workflow data for UKPRN '10018057'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018057'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018057'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018057' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK         	  | AY2425        | ASF2425      | Accountability Agreement (College)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    # Clear down ASFG subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASFC-ASCL2425     |
    | ASFC-FCFJ2425     |

	
    # Remove ASFG Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018057'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018057' 
    And   there is no caseload advisor for UKPRN '10018057' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018057 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018057' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018057 Co Ltd' with UKPRN '10018057' and OrgId 'ORG0018057' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018057 | 118057 | 10018057 Co Ltd | 0              | Active                | Yes           | AA018057      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018057 |







    # Populate the stub with ASF data

    # Change the date 
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018057 | ASFG-AY-2425-Contract-Provider-10018057-3_5           | 3_5            | ASFG                        | AY-2425            | 13500.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType             | ProviderFundingTotalValue |
    | ASFG-AY-2425-10018057-3_5  | 3_5                    | ASFG-AY-2425-Contract-Provider-10018057-3_5           | 10018057      | Colleges     | Further education           | 13500.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | ASFG-AY-2425-10018057-3_5   | ASFG-001         | 1000.00		  | Payment         |
    | ASFG-AY-2425-10018057-3_5   | ASFG-002         | 3680.00        | Payment         |
    | ASFG-AY-2425-10018057-3_5   | ASFG-003         | 6320.00        | Payment         |
    | ASFG-AY-2425-10018057-3_5   | ASFG-004         | 2500.00        | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | ASFG-AY-2425-10018057-3_5   | ASFG-001         | FY-2425              | September            | 2024              | 1000.00                    |
    | ASFG-AY-2425-10018057-3_5   | ASFG-002         | FY-2425              | April	               | 2025              | 3680.00                    |
    | ASFG-AY-2425-10018057-3_5   | ASFG-003         | FY-2425              | November             | 2024              | 6320.00                    |
    | ASFG-AY-2425-10018057-3_5   | ASFG-004         | FY-2425              | December	           | 2024              | 2500.00                    |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | ASF2425      | Accountability Agreement (College)      | AA_College                |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018057 | 10018057 Co Ltd  | ASFG-AY-2425-Contract-Provider-10018057-3_5             | 3_5            | Education & Skills Funding | AY2425  | Accountability Agreement (College) 	   | ASFG                        | ASF2425         | Scheduling        | Awaiting Release  | 13500.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_College]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2425-Contract-Provider-10018057-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 13500.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018057 | ASFG-AY-2425-Contract-Provider-10018057-3_5             | 3_5            | AY-2425 | ASFG                        | 13500.00    | [AA_College]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [AA_College]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window



    Then wait '30' seconds

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 13500.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018057' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018057' for FundingType 'ALLB' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018057 | 10018057 Co Ltd  | ASFG-AY-2425-Contract-Provider-10018057-3_5             | 3_5            | Education & Skills Funding | AY2425  | Accountability Agreement (College)	   | ASFG                        | ASF2425         | Released          | Released          | 12500.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2425-Contract-Provider-10018057-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | ASFG-AY-2425-Contract-Provider-10018057-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018057 | ASFG-AY-2425-Contract-Provider-10018057-3_5             | 3_5            | AY-2425 | ASFG                        | 13500.00    | [AA_College]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | ASFG-AY-2425-Contract-Provider-10018057-3_5              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018057 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10018057 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

#    # Check that the Contract and Master Contract have been created correctly in CRM
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10018057 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 5000.00       | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Accountability Agreement (College)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10018057 Co Ltd  | Active | Document Management Team  | ?                      |
#    | 10018057 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Accountability Agreement (College)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018057 Co Ltd  | Active | CRM Integration           | ?                      |
#
#    # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10018057 | [ContractNo]       | [AllocRef_ALL]       | ?                             | 5000.00         | ?             | ?                | 01/08/2024 | 31/07/2025 | ALLB          | ASFC-ASCL2425            | Contract Allocation   | ?                        |
#
#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                             | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_ALLB] | 1               | 5000.00   | 0.00     | 0.00     | 3632.00  | 0.00     | 0.00     | 0.00     | 0.00     | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | Total Advanced Learner Loans Bursary Funding            	   |                          |
#
#    # Contract is now at 'Draft\Awaiting Documentation'
#
    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
##
##     #Check the contents of the Appendices
##    And   the file named '10018042_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
##    """
##
##    SUMMARY OF FUNDING
##    Organisation Name: 10018057 Co Ltd UKPRN: 10018057
##    Master Contract Number: [MasterContractNo]
##    Allocation
##    1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
##    Education & Skills Funding (ALLB) [AllocRef_ALLB] £0 £4,632 £4,632
##    Total: £4,632
##    Total Funding for this contract: £4,632
##    Summary of Funding – Page 1
##    Agreement Type Accountability Agreement (College)
##    st st st
##    1 August 2023 to 31 July 2025 or 31 July 2026 if
##    Funding Period
##    extended by the Department pursuant to Clause 2.3
##    Between the Secretary of State for Education
##    And 10018057 Co Ltd
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
##    10018057 Co Ltd THE SECRETARY OF STATE FOR
##    9 Kneesworth Street EDUCATION
##    Royston DEPARTMENT FOR EDUCATION
##    Hertfordshire 20 GREAT SMITH STREET
##    AND
##    SG8 5AA LONDON
##    SW1P 3BT
##    Company No: AA018057
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
##    Provider: 10018057 Co Ltd UKPRN: 10018057
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
    And   Sharepoint file '10018057_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018057_[ContractNo]_v1.pdf'
#
    # Remove ASFG details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |
#
##    # Check the current state of the Tasks for this contract
##    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018057'
##    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
##    | Initiate Document Merge   | 10018057 - 10018057 Co Ltd Awaiting documentation  | [AllocRef_ALLB] | Document Management Team  | ?                | Open       | Not Started   |
##
##    # Check the CRM Contract Workflow History data
##    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
##    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
##   #| 10018057 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
##   #| 10018057 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
##    | 10018057 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
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
##    | 10018057 | [ContractNo]   | 1                     | 0                  |
##
###
###    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
###    Then  the following Funding Allocations data is present in CRM
###    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus                       | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
###    | 10018057 | 10018057 Co Ltd  | ALLB-AY-2425-Contract-Provider-10018057-3_5             | 3_5            | Education & Skills Funding | AY2425  | Accountability Agreement (College)       | ALLB                        | ASFC-ASCL2425        | Scheduling        | Returned to Scheduling          | 5000.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_College]           | ?          | ?                   |
###
##
##    # Check PaaS FundingAllocation.FundingAllocation (J131)
##    Then the following Funding Allocations data is present in PaaS
##    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
##    | 10018057 | ALLB-AY-2425-Contract-Provider-10018057-3_5             | 3_5            | AY-2425 | ALLB                        | 5000.00     | ?               | ?                 | ?                                 |
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
#    | 10018057 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018057 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |


#    Given the override date is '08/07/2023'
#        
#     # Withdraw v1 of the contract 
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'ALLB test withdrawal' by 'FCS1 Test'
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018057 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018057 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |


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
    | 10018057 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10018057 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#
##    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
##    And   the following Funding Allocations data is present in CRM
##    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
##    | 10018057 | 10018057 Co Ltd  | ALLB-AY-2425-Contract-Provider-10018057-3_5             | 3_5            | Education & Skills Funding | AY2425  | Accountability Agreement (College)       | ALLB                        | ASF2425       | Contract Approved | Contract Approved | 5000.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [AA_College]       | ?          | ?                   |
##
##    # Check PaaS FundingAllocation.FundingAllocation (J131)
##    And   the following Funding Allocations data is present in PaaS
##    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
##    | 10018057 | ALLB-AY-2425-Contract-Provider-10018057-3_5             | 3_5            | AY-2425 | ALLB                        | 5000.00     | [AA_College]       | ContractApproved  | ContractApproved                  |
##
##    # Check that the CRM Funding Allocation Workflow History includes an approval
##    And   the following Funding Allocation Workflow History data is present in CRM
##    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
##    | ALLB-AY-2425-Contract-Provider-10018057-3_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
##
##    # Test CRM details against same in ContractManagement feed (30447)
##    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
##
##    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
##    Then  the Legal Contract CM feed contains the following '1' deliverables
##    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
##    | 10018057 | [ContractNo]   | 1               | [AllocRef_ALLB]  | 1               | 0                     | 5000.00      | 0             | 0        | Total Advanced Learner Loans Bursary Funding   | ?                           |
##
##  
#


    # Tidy Up
    Given the override date is reset

     @AcceptanceTest @Withdrawn20260521
@Long2Run @Long2Run67
    Scenario: AK026 Import and release a ASFG2425 FA. Approve. Check docs, CRM and feed. Amend and repeat
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10010026'
    And   there is no Funding Allocation data in CRM for UKPRN '10010026'
    And   there is no Contract, Task or Workflow data for UKPRN '10010026'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10010026'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010026'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10010026' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the AA_College stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2425        | ASF2425     | Accountability Agreement (College)                    |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
	
	And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASFC-ASCL2425     |
    | ASFC-FCFJ2425     |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010026' 
    And   there is no caseload advisor for UKPRN '10010026' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010026 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010026' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010026 Co Ltd' with UKPRN '10010026' and OrgId 'ORG0010026' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010026 | 110026 | 10010026 Co Ltd | 0              | Active                | Yes           | AA010026      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010026 |







    # Populate the stub with ASF data

   # Change the date 
   Given the override date is '01/07/2024'

   # Clear down the AA_College stub
   And   there is no data in the CFS stub

   # Funding Allocation 
   And   the following Funding Allocation data is in the CFS stub
   | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
   | Contracting    | 10010026 | ASFG-AY-2425-Contract-Provider-10010026-3_5           | 3_5            | ASFG                        | AY-2425            | 13500.00          |

   # Provider Funding Allocation
   And   the following Provider Funding Agreement data is present in the CFS stub
   | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType             | ProviderFundingTotalValue |
   | ASFG-AY-2425-10010026-3_5  | 3_5                    | ASFG-AY-2425-Contract-Provider-10010026-3_5           | 10010026      | Colleges     | Further education           | 13500.00                  |

   # Funding Allocation Line (aka Deliverable)
   And   the following Funding Allocation Line data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
   | ASFG-AY-2425-10010026-3_5   | ASF-001         | 1000.00		  | Payment         |
   | ASFG-AY-2425-10010026-3_5   | ASF-002         | 3680.00        | Payment         |
   | ASFG-AY-2425-10010026-3_5   | ASF-003         | 6320.00        | Payment         |
   | ASFG-AY-2425-10010026-3_5   | ASF-004         | 2500.00        | Payment         |


   # Funding Allocation Profile Period
   And   the following Funding Allocation Profile Period data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
   | ASFG-AY-2425-10010026-3_5   | ASF-001         | FY-2425              | September            | 2024              | 1000.00                    |
   | ASFG-AY-2425-10010026-3_5   | ASF-002         | FY-2425              | April	               | 2025              | 3680.00                    |
   | ASFG-AY-2425-10010026-3_5   | ASF-003         | FY-2425              | November             | 2024              | 6320.00                    |
   | ASFG-AY-2425-10010026-3_5   | ASF-004         | FY-2425              | December	           | 2024              | 2500.00                    |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | ASF2425     | Accountability Agreement (College)      | AA_College                       |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10010026 | 10010026 Co Ltd  | ASFG-AY-2425-Contract-Provider-10010026-3_5             | 3_5            | Education & Skills Funding     | AY2425  | Accountability Agreement (College)                     | ASFG                        | ASF2425        | Scheduling        | Awaiting Release  | 13500.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_College]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2425-Contract-Provider-10010026-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 13500.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010026 | ASFG-AY-2425-Contract-Provider-10010026-3_5             | 3_5            | AY-2425 | ASFG                        | 13500.00     | [AA_College]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

        # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [AA_College]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 13500.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10010026' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10010026' for FundingType 'ASFG' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010026 | 10010026 Co Ltd  | ASFG-AY-2425-Contract-Provider-10010026-3_5             | 3_5            | Education & Skills Funding     | AY2425  | Accountability Agreement (College)                     | ASFG                        | ASF2425        | Released          | Released          | 13500.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_College]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2425-Contract-Provider-10010026-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | ASFG-AY-2425-Contract-Provider-10010026-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010026 | ASFG-AY-2425-Contract-Provider-10010026-3_5             | 3_5            | AY-2425 | ASFG                        | 13500.00     | [AA_College]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | ASFG-AY-2425-Contract-Provider-10010026-3_5             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010026 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10010026 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10010026 | [ContractNo]       | Education & Skills Funding                 | Contract      | Draft          | Awaiting Documentation  | 13500.00       | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Accountability Agreement (College)                      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10010026 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10010026 | [MasterContractNo] | Education & Skills Funding                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Accountability Agreement (College)                      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10010026 Co Ltd  | Active | CRM Integration           | ?                      |


     # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10010026 | [ContractNo]       | [AllocRef_ASCA]       | ?                             | 11000.00        | 10010026      | 10010026 Co Ltd  | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
#    | 10010026 | [ContractNo]       | [AllocRef_ASFC]       | ?                             | 2500.00         | 10010026      | 10010026 Co Ltd  | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
#
#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25  | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                             | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_ASCA] | 5               | 3680.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00    | 0.00     | 0.00     | 3680.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                                           |                          |
#    | [ContractNo]   | [AllocRef_ASCA] | 2               | 1000.00  | 0.00     | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Adult Skills Total Funding                                  |                          |
#    | [ContractNo]   | [AllocRef_ASCA] | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Adult Skills Programme Funding                              |                          |
#    | [ContractNo]   | [AllocRef_ASCA] | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Adult Skills Learning Support                               |                          |
#    | [ContractNo]   | [AllocRef_ASCA] | 12              | 6320.00  | 0.00     | 0.00     | 0.00     | 6320.00  | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Funding for Innovative Provision                            |                          |
#    | [ContractNo]   | [AllocRef_ASFC] | 2               | 2500.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2500.00  | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Funding for Innovative Provision                            |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '48' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

     #Check the contents of the Appendices
#    And   the file named '10010026_[ContractNo]_v1.pdf' in Sharepoint location 'ASFG-2425-Input-Appendices' contains the following lines in order
#    """
#
#    SUMMARY OF FUNDING
#    Organisation Name: 10010026 Co Ltd UKPRN: 10010026
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    1 August 2024 to 31 July 2025 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
#    Education & Skills Funding (ASFG) [AllocRef_ASFG] £0 £4,632 £4,632
#    Total: £4,632
#    Total Funding for this contract: £4,632
#    Summary of Funding – Page 1
#    Agreement Type Accountability Agreement (College) 
#    st st st
#    1 August 2024 to 31 July 2025 or 31 July 2026 if
#    Funding Period
#    extended by the Department pursuant to Clause 2.3
#    Between the Secretary of State for Education
#    And 10010026 Co Ltd
#    Funding for Education & Skills Funding (ASFG)
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
#    ASFG Version 2 (September 2024) Page 1
#    This Contract is made on the date the Contract is digitally signed by the
#    Contractor on the Manage Your Education & Skills Funding Service between:
#    10010026 Co Ltd THE SECRETARY OF STATE FOR
#    9 Kneesworth Street EDUCATION
#    Royston DEPARTMENT FOR EDUCATION
#    Hertfordshire 20 GREAT SMITH STREET
#    AND
#    SG8 5AA LONDON
#    SW1P 3BT
#    Company No: AA018026
#    Hereinafter called Hereinafter called
#    the Contractor the Department
#    ASFG Version 2 (September 2024) Page 2
#    SCHEDULE 1: SPECIFICATION & MONITORING
#    Education & Skills Funding (ASFG) SPECIFICATION
#    ASFG Schedule 1 – Annex 1 Version 1 (July 2024) – Page 2
#    SCHEDULE 2: PAYMENT
#    Education & Skills Funding (ASFG) PAYMENT
#    ASFG Schedule 2 Version 1 (July 2024) – Page 1
#    SCHEDULE 2
#    Funding Agreement
#    Provider: 10010026 Co Ltd UKPRN: 10010026
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
#    Contract Ref: [AllocRef_ASFG]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#    Education & Skills Funding (ASFG) £4,632 £0 £0 £0 £0 £0 £0 £0 £0 £0 £4,632 £0 £0
#    Total Funding £4,632 £0 £0 £0 £0 £0 £0 £0 £0 £0 £4,632 £0 £0
#    Schedule 2 – Funding Agreement [AllocRef_ASFG] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    SCHEDULE 3: CHANGE CONTROL PROCEDURE
#    ASFG Schedule 3 Version 1 (July 2024) – Page 1
#    SCHEDULE 9: CONTRACTOR’S RESPONSE/PROPOSALS
#    ASFG Schedule 9 Version 1 (July 2024) – Page 1
#    SCHEDULE 10: SUB-CONTRACTING
#    ASFG Schedule 10 Version 1 (July 2024) – Page 5
#    """
 



    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010026_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010026_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10010026'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10010026 - 10010026 Co Ltd Awaiting documentation  | [AllocRef_ASFG] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10010026 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10010026 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10010026 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10010026_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010026 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10010026 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |





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
    | 10010026 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10010026 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010026 | 10010026 Co Ltd  | ASFG-AY-2425-Contract-Provider-10010026-3_5             | 3_5            | Education & Skills Funding     | AY2425  | Accountability Agreement (College)                     | ASFG                        | ASF2425        | Contract Approved | Contract Approved | 13500.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [AA_College]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010026 | ASFG-AY-2425-Contract-Provider-10010026-3_5             | 3_5            | AY-2425 | ASFG                        | 13500.00     | [AA_College]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2425-Contract-Provider-10010026-3_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    #Then  the Legal Contract CM feed contains the following '4' deliverables
    #| UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    #| 10010026 | [ContractNo]   | 1               | [AllocRef_ASCA]  | 5               | 1                     | 3680.00       | 0             | 0        | Tailored Learning                                  | ?                           |
    #| 10010026 | [ContractNo]   | 1               |  [AllocRef_ASCA] | 2               | 1                     |  1000.00      | 0             | 0        |  Adult Skills Total Funding                        | ?                           |
    #| 10010026 | [ContractNo]   | 1               |  [AllocRef_ASCA] | 12              | 1                     |  6320.00      | 0             | 0        |  Funding for Innovative Provision                  | ?                           |
    #| 10010026 | [ContractNo]   | 1               |  [AllocRef_ASFC] | 2               | 1                     |  2500.00      | 0             | 0        |  Funding for Innovative Provision                  | ?                           |

   
     # Amend contract

    # Change the date
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10010026 | ASFG-AY-2425-Contract-Provider-10010026-4_7           | 4_7            | ASFG                        | AY-2425            | 16882.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | ASFG-AY-2425-10010026-4_7  | 4_7                    | ASFG-AY-2425-Contract-Provider-10010026-4_7           | 10010026      | Colleges     | Further education| 16882.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | ASFG-AY-2425-10010026-4_7   | ASF-001       | 3172.00		  | Payment         |
    | ASFG-AY-2425-10010026-4_7   | ASF-002       | 4892.00          | Payment         |
    | ASFG-AY-2425-10010026-4_7   | ASF-003       | 5859.00          | Payment         |
    | ASFG-AY-2425-10010026-4_7   | ASF-004       | 2959.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | ASFG-AY-2425-10010026-4_7  | ASF-001        | FY-2425              | September              | 2024               | 3172.00                   |
    | ASFG-AY-2425-10010026-4_7  | ASF-002        | FY-2425              | April	               | 2025              | 4892.00                   |
    | ASFG-AY-2425-10010026-4_7  | ASF-003        | FY-2425              | November               | 2024               | 5859.00                   |
    | ASFG-AY-2425-10010026-4_7  | ASF-004        | FY-2425              | December	           | 2024                  | 2959.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2425        | ASF2425     | Accountability Agreement (College)       | AA_College                |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window
	
	
	

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10010026 | 10010026 Co Ltd  | ASFG-AY-2425-Contract-Provider-10010026-4_7             | 4_7            |Education & Skills Funding  | AY2425  | Accountability Agreement (College)       | ASFG                        | ASF2425        | Scheduling        | Awaiting Release  | 16882.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_College]            | ?          | ?                   |

    
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2425-Contract-Provider-10010026-4_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 16882.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010026 | ASFG-AY-2425-Contract-Provider-10010026-4_7             | 4_7            | AY-2425 | ASFG                        | 16882.00    | [AA_College]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '19/07/2024'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [AA_College]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 16882.00        |


      # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10010026' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10010026' for FundingType 'ASFG' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010026 | 10010026 Co Ltd  | ASFG-AY-2425-Contract-Provider-10010026-4_7             | 4_7            | Education & Skills Funding | AY2425  | Accountability Agreement (College)    | ASFG                        | ASF2425        | Released          | Released          | 16882.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_College]          | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2425-Contract-Provider-10010026-4_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | ASFG-AY-2425-Contract-Provider-10010026-4_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010026 | ASFG-AY-2425-Contract-Provider-10010026-4_7             | 4_7            | AY-2425 | ASFG                        | 16882.00    | [AA_College]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | ASFG-AY-2425-Contract-Provider-10010026-4_7             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010026 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | Variation     |
    | 10010026 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10010026 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10010026 | [ContractNo]       | Education & Skills Funding                 | Contract      | Draft          | Awaiting Documentation  | 16882.00      | 2                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?         | Accountability Agreement (College)        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | [ContractNo]    | 10010026 Co Ltd  | Active | Document Management Team  | 3382.00               |
    | 10010026 | [MasterContractNo] | Education & Skills Funding                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?         | Accountability Agreement (College)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10010026 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    #And   the following Contract Allocations exist in CRM
    #| UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    #| 10010026 | [ContractNo]       | [AllocRef_ASCA]       | ?                             | 13923.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | 2923.00                 |
    #| 10010026 | [ContractNo]       | [AllocRef_ASFC]       | ?                             | 2959.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | 459.00                 |

# Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    #And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    #| ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                  | DeliverableDescription   |
    #| [ContractNo]   | [AllocRef_ASCA] | 5               | 4892.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |
    #| [ContractNo]   | [AllocRef_ASCA] | 2               | 3172.00   | 0.00     | 3172.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |
    #| [ContractNo]   | [AllocRef_ASCA] | 12              | 5859.00   | 0.00     | 0.00     | 0.00     | 5859.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |
    #| [ContractNo]   | [AllocRef_ASFC] | 2               | 2959.00   | 0.00     | 0.00     | 0.00     | 0.00     | 2959.00  | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |



    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    #Check the contents of the Appendices  (SoF and FA)
    #And   the file named '10010026_[ContractNo]_v2.pdf' in Sharepoint location 'ASFG-2425-Input-Appendices' contains the following lines in order
    #"""
    #SUMMARY OF FUNDING
    #Organisation Name: 10010026 Co Ltd UKPRN: 10010026
    #Master Contract Number: [MasterContractNo]
    #Allocation
    #1 August 2024 to 31 July 2025 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
    #Dance and Drama Awards (ASFG) [AllocRef_ASFG] £13,923 £8,492 £22,415
    #Total: £22,415
    #Total Funding for this contract: £22,415
    #Summary of Funding – Page 1
    #
    #SCHEDULE 2
    #Funding Agreement
    #Provider: 10010026 Co Ltd UKPRN: 10010026
    #Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    #Contract Ref: [AllocRef_ASFG]
    #Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    #Dance and Drama Awards (ASFG) £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Total Funding £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Schedule 2 – Funding Agreement [AllocRef_ASFG] – Page 1 Ref (for internal use only):  [ContractNo] v2
    #"""

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010026_[ContractNo]_v2.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010026_[ContractNo]_v2.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10010026'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10010026 - 10010026 Co Ltd Awaiting documentation  | [AllocRef_ASCA] | Document Management Team  | ?                | Open       | Not Started   |
    | Initiate Document Merge   | 10010026 - 10010026 Co Ltd Awaiting documentation  | [AllocRef_ASFC] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '2' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10010026 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10010026 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10010026 | [MasterContractNo] | [ContractNo]   | 2                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '20/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10010026_[ContractNo]_v2.pdf' is created in 'EDSK-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010026 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | Variation     |
    | 10010026 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | False         | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10010026 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '21/07/2024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010026 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | Variation     |
    | 10010026 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10010026 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010026 | 10010026 Co Ltd  | ASFG-AY-2425-Contract-Provider-10010026-4_7             | 4_7            | Education & Skills Funding | AY2425  |  Accountability Agreement (College)      | ASFG                        | ASF2425        | Contract Approved | Contract Approved | 16882.00    | [ContractNo]  | 2                 | CRM Integration       | CRM Integration           | ?                         | [AA_College]          | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010026 | ASFG-AY-2425-Contract-Provider-10010026-4_7             | 4_7            | AY-2425 | ASFG                        | 16882.00    | [AA_College]          | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2425-Contract-Provider-10010026-4_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
#    | 10010026 | [ContractNo]   | 2               | [AllocRef_ASFG]  | 1               | 0                     | 16882.00     | 0             | 0        | Dance and Drama Awards Scheme                  | ?                           |
#


    
    
    
   
   # Part 9: Payment Batch for AEBC-ASCL2324

    # Change the date
    Given the override date is '03/09/2024 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASFC-ASCL2425' AccountingPaymentPeriod '202406' CensusEndDate '03/09/2024' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_ASCA]          | 202409 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASFC-ASCL2425      		 | 202409               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
   # Then  there is an entry in the Payment Timetable
   # | Funding Stream Period Code | Calendar Year/Period | Status    |
   # | ASFC-ASCL2425           	 | 202409               | Completed |
   #
   # # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
   # And   the Payment feed xml for FundingStreamPeriod 'ASFC-ASCL2425' PaymentPeriod '202406' CensusEndDate '03/09/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S057a.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'ASFC-ASCL2425' AccountingPaymentPeriod '202406' and CensusEndDate '03/09/2024'
   Given there are no files prefixed '2024-09 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder

   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '04/09/2024'
   
      # Part 9: Payment Batch for AEBC-NSF2324

    # Change the date
    Given the override date is '03/12/2024 22:05' 

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASFC-FCFJ2425' AccountingPaymentPeriod '202412' CensusEndDate '03/12/2024' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_ASFC]          | 202412 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASFC-FCFJ2425      		 | 202412               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
   # Then  there is an entry in the Payment Timetable
   # | Funding Stream Period Code | Calendar Year/Period | Status    |
   # | ASFC-FCFJ2425           	 | 202412               | Completed |
   ##
   # # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
   # And   the Payment feed xml for FundingStreamPeriod 'ASFC-FCFJ2425' PaymentPeriod '202409' CensusEndDate '03/12/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S057b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'ASFC-FCFJ2425' AccountingPaymentPeriod '202409' and CensusEndDate '03/12/2024'

     Given there are no files prefixed '2024-12 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder

   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '03/12/2024'
   

    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
#
  
   