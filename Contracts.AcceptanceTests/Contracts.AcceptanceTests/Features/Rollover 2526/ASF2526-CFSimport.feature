Feature: ASF2526-CFSimport

@AcceptanceTest @InProgress
@CFS
Scenario: S059 Import and release a ASFC-ASCL2526, ASFC-FCFJ2526 allocation. Approve. Check docs, CRM and feed.
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018059'
    And   there is no Funding Allocation data in CRM for UKPRN '10018059'
    And   there is no Contract, Task or Workflow data for UKPRN '10018059'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018059'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018059'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018059' in the Sharepoint 'EDSK-2526-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2526        | ASF2526      | Conditions of Funding (Grant) (SPI)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    # Clear down ASFG subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASFC-ASCL2526     |
    | ASFC-FCFJ2526     |

	
    # Remove ASFG Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018059'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018059' 
    And   there is no caseload advisor for UKPRN '10018059' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018059 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018059' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018059 Co Ltd' with UKPRN '10018059' and OrgId 'ORG0018059' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018059 | 118059 | 10018059 Co Ltd | 0              | Active                | Yes           | AA018059      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018059 |







    # Populate the stub with ASF data

    # Change the date 
    Given the override date is '01/07/2025'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018059 | ASFG-AY-2526-Contract-Provider-10018059-3_5           | 3_5            | ASFG                        | AY-2526            | 7180.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                               | ProviderSubType                          | ProviderFundingTotalValue |
    | ASFG-AY-2526-10018059-3_5  | 3_5                    | ASFG-AY-2526-Contract-Provider-10018059-3_5           | 10018059      | Furth                                      | 18ISP                                    | 7180.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | ASFG-AY-2526-10018059-3_5   | ASFG-001         | 1000.00		  | Payment         |
    | ASFG-AY-2526-10018059-3_5   | ASFG-002         | 3680.00        | Payment         |
    | ASFG-AY-2526-10018059-3_5   | ASFG-004         | 2500.00        | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | ASFG-AY-2526-10018059-3_5   | ASFG-001         | FY-2526              | August               | 2025              | 1000.00                    |
    | ASFG-AY-2526-10018059-3_5   | ASFG-002         | FY-2526              | April	               | 2026              | 3680.00                    |
    | ASFG-AY-2526-10018059-3_5   | ASFG-004         | FY-2526              | August	           | 2025              | 2500.00                    |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '02/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                                  | ReleaseGroupParameterName |
    | EDSK            | AY2526        | ASF2526      | Conditions of Funding (Grant) (SPI)           | CofG(SPI)                |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG(SPI) = [CofG(SPI)]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018059 | 10018059 Co Ltd  | ASFG-AY-2526-Contract-Provider-10018059-3_5             | 3_5            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (SPI)       | ASFG                        | ASF2526         | Scheduling        | Awaiting Release  | 7180.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG(SPI)]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2526-Contract-Provider-10018059-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG(SPI)]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 7180.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018059 | ASFG-AY-2526-Contract-Provider-10018059-3_5             | 3_5            | AY-2526 | ASFG                        | 7180.00     | [CofG(SPI)]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG(SPI)]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '03/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG(SPI)]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG(SPI) = [CofG(SPI)]' is written to the Output window



    Then wait '30' seconds

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG(SPI)]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 7180.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018059' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018059' for FundingType 'ALLB' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    #Then  the following Funding Allocations data is present in CRM
    #| UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    #| 10018059 | 10018059 Co Ltd  | ASFG-AY-2526-Contract-Provider-10018059-3_5             | 3_5            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (SPI)	   | ASFG                        | ASF2526         | Released          | Released          | 12500.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG(SPI)]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    Then   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2526-Contract-Provider-10018059-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | ASFG-AY-2526-Contract-Provider-10018059-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018059 | ASFG-AY-2526-Contract-Provider-10018059-3_5             | 3_5            | AY-2526 | ASFG                        | 7180.00    | [CofG(SPI)]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | ASFG-AY-2526-Contract-Provider-10018059-3_5             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG(SPI)]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018059 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018059 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |



#    # Check that the Contract and Master Contract have been created correctly in CRM
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10018059 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 5000.00       | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Conditions of Funding (Grant) (SPI)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10018059 Co Ltd  | Active | Document Management Team  | ?                      |
#    | 10018059 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Conditions of Funding (Grant) (SPI)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018059 Co Ltd  | Active | CRM Integration           | ?                      |
#
#    # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10018059 | [ContractNo]       | [AllocRef_ALL]       | ?                             | 5000.00         | ?             | ?                | 01/08/2024 | 31/07/2025 | ALLB          | ASFC-ASCL2526            | Contract Allocation   | ?                        |
#
#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                                             | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_ALLB] | 1               | 5000.00   | 0.00     | 0.00     | 3632.00  | 0.00     | 0.00     | 0.00     | 0.00     | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | Total Advanced Learner Loans Bursary Funding            	   |                          |
#
#    # Contract is now at 'Draft\Awaiting Documentation'
#
    ## Check the deliverable count in CRM
    #Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
##
#     #Check the contents of the Appendices
#    And   the file named '10018042_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
##    """
##
##    SUMMARY OF FUNDING
##    Organisation Name: 10018059 Co Ltd UKPRN: 10018059
##    Master Contract Number: [MasterContractNo]
##    Allocation
##    1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
##    Education & Skills Funding (ALLB) [AllocRef_ALLB] £0 £4,632 £4,632
##    Total: £4,632
##    Total Funding for this contract: £4,632
##    Summary of Funding – Page 1
##    Agreement Type Conditions of Funding (Grant) (SPI)
##    st st st
##    1 August 2023 to 31 July 2025 or 31 July 2026 if
##    Funding Period
##    extended by the Department pursuant to Clause 2.3
##    Between the Secretary of State for Education
##    And 10018059 Co Ltd
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
##    10018059 Co Ltd THE SECRETARY OF STATE FOR
##    9 Kneesworth Street EDUCATION
##    Royston DEPARTMENT FOR EDUCATION
##    Hertfordshire 20 GREAT SMITH STREET
##    AND
##    SG8 5AA LONDON
##    SW1P 3BT
##    Company No: AA018059
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
##    Provider: 10018059 Co Ltd UKPRN: 10018059
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
    And   Sharepoint file '10018059_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018059_[ContractNo]_v1.pdf'
##
#    # Remove ASFG details from ContractManagement.CreatedContract for a contract
# #  Given there are no created contracts for this number '[ContractNo]'
#    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'
#
#    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
#    #   Note: Documents are created using the system date. The following step 'corrects' this
#    And   the following document creation details exist in the ContractManagement.CreatedContract table
#    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
#    | [ContractNo]   | 1                     | 0                        | 2025-07-04 09:12:35.000 |
#
##    # Check the current state of the Tasks for this contract
##    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018059'
##    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
##    | Initiate Document Merge   | 10018059 - 10018059 Co Ltd Awaiting documentation  | [AllocRef_ALLB] | Document Management Team  | ?                | Open       | Not Started   |
##
##    # Check the CRM Contract Workflow History data
##    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
##    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
##   #| 10018059 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
##   #| 10018059 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
##    | 10018059 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
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
##    | 10018059 | [ContractNo]   | 1                     | 0                  |
##
###
###    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
###    Then  the following Funding Allocations data is present in CRM
###    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus                       | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
###    | 10018059 | 10018059 Co Ltd  | ALLB-AY-2526-Contract-Provider-10018059-3_5             | 3_5            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (SPI)       | ALLB                        | ASFC-ASCL2526        | Scheduling        | Returned to Scheduling          | 5000.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG(SPI)]           | ?          | ?                   |
###
##
##    # Check PaaS FundingAllocation.FundingAllocation (J131)
##    Then the following Funding Allocations data is present in PaaS
##    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
##    | 10018059 | ALLB-AY-2526-Contract-Provider-10018059-3_5             | 3_5            | AY-2526 | ALLB                        | 5000.00     | ?               | ?                 | ?                                 |
##
#


    # Publish the contract

    # Change the date 
    Given the override date is '04/07/2025'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018059_[ContractNo]_v1.pdf' is created in 'EDSK-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018059 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018059 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |





#    Given the override date is '08/07/2023'
#        
#     # Withdraw v1 of the contract 
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'ALLB test withdrawal' by 'FCS1 Test'
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018059 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018059 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

#
   ## Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   # And  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'


    # Approve the contract

    # Change the date 
    Given the override date is '05/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018059 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018059 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |
#
##    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
##    And   the following Funding Allocations data is present in CRM
##    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
##    | 10018059 | 10018059 Co Ltd  | ALLB-AY-2526-Contract-Provider-10018059-3_5             | 3_5            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (SPI)       | ALLB                        | ASF2526       | Contract Approved | Contract Approved | 5000.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG(SPI)]       | ?          | ?                   |
##
##    # Check PaaS FundingAllocation.FundingAllocation (J131)
##    And   the following Funding Allocations data is present in PaaS
##    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
##    | 10018059 | ALLB-AY-2526-Contract-Provider-10018059-3_5             | 3_5            | AY-2526 | ALLB                        | 5000.00     | [CofG(SPI)]       | ContractApproved  | ContractApproved                  |
##
##    # Check that the CRM Funding Allocation Workflow History includes an approval
##    And   the following Funding Allocation Workflow History data is present in CRM
##    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
##    | ALLB-AY-2526-Contract-Provider-10018059-3_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
##
##    # Test CRM details against same in ContractManagement feed (30447)
##    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
##
##    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
##    Then  the Legal Contract CM feed contains the following '1' deliverables
##    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
##    | 10018059 | [ContractNo]   | 1               | [AllocRef_ALLB]  | 1               | 0                     | 5000.00      | 0             | 0        | Total Advanced Learner Loans Bursary Funding   | ?                           |
##
##  
#


#
#
#    # Change the date
#    Given the override date is '01/10/2025'
#
#    # Bulk file
#    And   there are no files prefixed '10018059' in the Sharepoint 'EDSK-2526-Input-Appendices' folder
#    And   there are no files prefixed 'EDSK AY 2526 09092025105948 v2_S059' in the Sharepoint 'Input' folder
#    And   there are no files prefixed 'EDSK AY 2526 09092025105948 v2_S059' in the Sharepoint 'Processing' folder
#    And   there are no files prefixed 'EDSK AY 2526 09092025105948 v2_S059' in the Sharepoint 'Processed' folder
#    And   there are no files prefixed 'EDSK AY 2526 09092025105948 v2_S059' in the Sharepoint 'Reports' folder
#    And   spreadsheet 'EDSK AY 2526 09092025105948 v2_S059.xlsx' exists in the Datafiles folder and UKPRN '10018059' is present in cell 'A2' of the Contract tab
#    When  the file is copied to the Sharepoint 'Input' folder 
#   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
#    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
#    And   the syntax report includes the phrase 'Success'
#    And   a results report should exist in the Sharepoint Reports folder
#   # And   'Success' is displayed in field 'X2' on the 'Contract' tab of the result report
#
#
#    # Retrieve parameters
#    When  I retrieve the latest contract details from CRM for provider '10018059' for FundingType 'EDSK' and period '2526'

 #place code here
    
#   Then  the file named '10018059_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2025/26
#    Organisation Name: 10018059 Co Ltd UKPRN: 10018059
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
#    ESFA Adult Skills Fund (Grant) [AllocRef_ASCA] £443,905 £277,176 £721,081    
#    of which Funding for Innovative Provision £156,935 £90,090 £247,025
#	of which Tailored Learning £156,935 £90,090 £247,025
#    ESFA ASF - Free Courses for Jobs [AllocRef_ASFC] £156,935 £90,090 £247,025
#    ESFA ASF - Short Term Funding Initiatives [AllocRef_STFG] £600,840 £367,266 £968,106
#    of which Short Term Funding Initiative 1 £130,035 £96,996 £227,031
#    of which Short Term Funding Initiative 2 £156,935 £90,090 £247,025
#    of which Short Term Funding Initiative 3 £156,935 £90,090 £247,025
#    of which Short Term Funding Initiative 4 £156,935 £90,090 £247,025
#    Total Funding for this contract: £1,936,212
#    Summary of Funding – Page 1
#   
#    Agreement Type Conditions of Funding (Grant) (Trusts)
#    Funding Period 1 August 2024 to 31 July 2025
#    Between the Secretary of State for Education
#    And 10018059 Co Ltd
#    Funding for ESFA-Adult Skills Fund    
#    ACCEPTANCE BY THE PROVIDER
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Conditions of Funding (Grant) (Trusts)
#    Version 2 – July 2024 – Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    Provider on the Manage Your Education & Skills Funding Service between:
#    10018059 Co Ltd THE SECRETARY OF STATE FOR
#    46 The Avenue EDUCATION
#    Bournemouth DEPARTMENT FOR EDUCATION
#    Dorset 20 GREAT SMITH STREET
#    BH9 2UW LONDON    
#    SW1P 3BT
#    Company No: AA010024
#    Hereinafter called Hereinafter called
#    the Provider the Department
#    EDSK Conditions of Funding (Grant) (Trusts)
#    Version 2 – July 2024 – Page 2
#    EDSK Conditions of Funding (Grant) (Trusts)
#    Version 2 – July 2024 – Page 58
#
#    
#    SCHEDULE 1: DEFINITIONS
#    Schedule 1
#    Version 2 – July 2024 – Page 1
#    Schedule 1
#    Version 2 – July 2024 – Page 14
#	
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    Schedule 2: ESFA Adult Skills Fund 
#    Version 1 – July 2024 – Page 1
#    Schedule 2: ESFA Adult Skills Fund 
#    Version 1 – July 2024 – Page 8
#
#    SCHEDULE 3: PAYMENT
#    Schedule 3: ESFA Adult Skills Fund
#    Version 1 – July 2024 – Page 1
#
#   
#         
#    ESFA-ADULT SKILLS FUND
#    Funding Agreement – ESFA Adult Skills Fund (Grant)
#    Provider: 10018059 Co Ltd UKPRN: 10018059
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_ASCA]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#	ESFA Adult Skills Fund (Grant) £721,081 £59,224 £19,074 £61,344 £62,404 £45,107 £64,524 £65,584 £66,644 £67,704 £68,764 £69,824 £70,884
#	of which Tailored Learning £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
#    of which Funding for Innovative Provision £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
#	Total Funding £721,081 £59,224 £19,074 £61,344 £62,404 £45,107 £64,524 £65,584 £66,644 £67,704 £68,764 £69,824 £70,884    
#	ESFA-Adult Skills Fund – Funding Agreement [AllocRef_ASCA] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    ESFA-ADULT SKILLS FUND
#	Funding Agreement – ESFA ASF - Free Courses for Jobs
#    Provider: 10018059 Co Ltd UKPRN: 10018059
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
#    Contract Ref: [AllocRef_ASFC]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#	Total Funding £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605    
#	ESFA-Adult Skills Fund – Funding Agreement [AllocRef_ASFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    ESFA-ADULT SKILLS FUND
#    Funding Agreement – ESFA ASF - Short Term Funding Initiatives
#    Provider: 10018059 Co Ltd UKPRN: 10018059
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
#    Contract Ref: [AllocRef_STFG]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#    ESFA ASF - Short Term Funding Initiative 1 £227,031 £15,224 £16,174 £17,124 £18,074 £667 £19,974 £20,924 £21,874 £22,824 £23,774 £24,724 £25,674
#    ESFA ASF - Short Term Funding Initiative 2 £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
#    ESFA ASF - Short Term Funding Initiative 3 £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
#    ESFA ASF - Short Term Funding Initiative 4 £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
#    Total Funding £968,106 £81,224 £20,524 £83,454 £84,569 £67,327 £86,799 £87,914 £89,029 £90,144 £91,259 £92,374 £93,489    
#	ESFA-Adult Skills Fund – Funding Agreement [AllocRef_STFG] – Page 1 Ref (for internal use only):  [ContractNo] v1
#
#
#    SCHEDULE 4: UK GDPR/DATA PROTECTION
#    Schedule 4
#    Version 2 – July 2024 – Page 1
#    Schedule 4
#    Version 2 – July 2024 – Page 2
#
#    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
#    Schedule 5
#    Version 2 – July 2024 – Page 1
#    Schedule 5
#    Version 2 – July 2024 – Page 9
#
#
#    SCHEDULE 6: EXIT ARRANGEMENTS
#    Schedule 6
#    Version 2 – July 2024 – Page 1
#    Schedule 6
#    Version 2 – July 2024 – Page 5
#    
#        
#    SCHEDULE 7: SUBCONTRACTING
#    Schedule 7
#    Version 2 – July 2024 – Page 1
#    Schedule 7
#    Version 2 – July 2024 – Page 5
#     """
#     
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#    Then   Sharepoint file '10018059_[ContractNo]_v2.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S059_v2.pdf'
#



#    # Part 7c: Payment Batch for ASF2526
#
#    # Change the date
#    Given the override date is '04/08/2025 22:00'
#
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'ASFC-ASCL2526' AccountingPaymentPeriod '202505' CensusEndDate '04/08/2025' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_ASCA]          | 202508 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | ASFC-ASCL2526	             | 202508               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | ASFC-ASCL2526	         	 | 202508               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ASFC-ASCL2526' PaymentPeriod '202505' CensusEndDate '04/08/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S059_ASCA.xml'
#
#    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    #And   the Payment feed xml for FundingStreamPeriod 'ALLBC2425' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
#    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
#    ##                                                                                                    £15089.09
#
#    
#    Then wait '20' seconds
#
#
#
#    # Part 7c: Payment Batch for ASF2526
#
#    # Change the date
#    Given the override date is '04/08/2025 22:05'
#
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'ASFC-FCFJ2526' AccountingPaymentPeriod '202505' CensusEndDate '04/08/2025' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_ASFC]          | 202508 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | ASFC-FCFJ2526	             | 202508               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | ASFC-FCFJ2526	         	 | 202508               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ASFC-FCFJ2526' PaymentPeriod '202505' CensusEndDate '04/08/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S059_ASFC.xml'
#
#    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    #And   the Payment feed xml for FundingStreamPeriod 'ALLBC2425' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
#    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
#    ##                                                                                                    £15089.09
#
#

        




#
#
#    # Part 7d: Payment Batch for APPS2324
#
#    # Change the date
#    Given the override date is '09/10/2024 22:05'
#
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'APPS2324' AccountingPaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_APPS]          | 202309 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | APPS2324		             | 202309               |                      | A              | NotStarted |
#
 #    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | APPS2324		         	 | 202309               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'APPS2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S025_APPS.xml'

    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    #And   the Payment feed xml for FundingStreamPeriod 'APPS2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
    ##                                                                                                    £15089.09



    # Part 10: Create Consolidated Payment Summary rpt
   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    #Given the override date is '03/01/2023 10:00'

#   Given there are no files prefixed '2025-08 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
#   
#   When  a Consolidated Payment Summary Report is created in Sharepoint for '04/08/2025'
#    # Check the above report manually
#
#   Then wait '10' seconds
#
#   



    # Amend the stub with ASF data

    # Change the date 
    Given the override date is '01/11/2025'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018059 | ASFG-AY-2526-Contract-Provider-10018059-3_6           | 3_6            | ASFG                        | AY-2526            | 15500.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType             | ProviderFundingTotalValue |
    | ASFG-AY-2526-10018059-3_6  | 3_6                    | ASFG-AY-2526-Contract-Provider-10018059-3_6           | 10018059      | Furth        | 18ISP                       | 15500.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | ASFG-AY-2526-10018059-3_6   | ASFG-001         | 1000.00		  | Payment         |
    | ASFG-AY-2526-10018059-3_6   | ASFG-002         | 9000.00        | Payment         |
    | ASFG-AY-2526-10018059-3_6   | ASFG-004         | 3500.00        | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | ASFG-AY-2526-10018059-3_6   | ASFG-001         | FY-2526              | September            | 2025              | 1000.00                    |
    | ASFG-AY-2526-10018059-3_6   | ASFG-002         | FY-2526              | April	               | 2026              | 9000.00                    |
    | ASFG-AY-2526-10018059-3_6   | ASFG-004         | FY-2526              | December	           | 2025              | 3500.00                    |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/11/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2526        | ASF2526      | Conditions of Funding (Grant) (SPI)     | CofG(SPI)                |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG(SPI) = [CofG(SPI)]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018059 | 10018059 Co Ltd  | ASFG-AY-2526-Contract-Provider-10018059-3_6             | 3_6            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (SPI) 	   | ASFG                        | ASF2526         | Scheduling        | Awaiting Release  | 15500.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG(SPI)]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2526-Contract-Provider-10018059-3_6             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG(SPI)]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 15500.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018059 | ASFG-AY-2526-Contract-Provider-10018059-3_6             | 3_6            | AY-2526 | ASFG                        | 15500.00    | [CofG(SPI)]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG(SPI)]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/11/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG(SPI)]       |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG(SPI) = [CofG(SPI)]' is written to the Output window



    Then wait '30' seconds

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG(SPI)]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 15500.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018059' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018059' for FundingType 'ALLB' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018059 | 10018059 Co Ltd  | ASFG-AY-2526-Contract-Provider-10018059-3_6             | 3_6            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (SPI)	   | ASFG                        | ASF2526         | Released          | Released          | 15500.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG(SPI)]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | ASFG-AY-2526-Contract-Provider-10018059-3_6             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | ASFG-AY-2526-Contract-Provider-10018059-3_6             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018059 | ASFG-AY-2526-Contract-Provider-10018059-3_6             | 3_6            | AY-2526 | ASFG                        | 15500.00    | [CofG(SPI)]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | ASFG-AY-2526-Contract-Provider-10018059-3_6             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG(SPI)]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    ## Check the CONTRACT version, status and dates in CRM
    #And   the following contract values are present in CRM
    #| UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    #| 10018059 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    #| 10018059 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |


    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018059_[ContractNo]_v2.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018059_[ContractNo]_v2.pdf'


#    # Run the CDA report for the four 2021 AEBP FSPs
#    Given the override date is '06/11/2025'
#    Given there is no CDA report named 'CDA Latest Version S046.csv'
#    And   the following ADF Pipeline run
#    And   the following CDA report is run
#    | FundingStreamPeriod   | Version         | Suffix |
#    | ASFC-ASCL2526         | Latest Version  | S059   |
#    | ASFC-FCFJ2526         | Latest Version  | S059   |
#
#    Then  a report named 'CDA Latest Version S059.csv' is created

    
    
    # Publish the contract

#    # Change the date 
#    Given the override date is '06/11/2025'
#
# #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
# #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
# #  or
#    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
#    And   a file with filename '10018059_[ContractNo]_v2.pdf' is created in 'EDSK-2526-Output-Merged Document'
#    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
#    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table
#
#    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
##    And   the following contract values are present in CRM
##    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
##    | 10018059 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
##    | 10018059 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |
##
#
#
#
#    # Approve the contract
#
#    # Change the date 
#    Given the override date is '07/11/2025'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    #And   the following contract values are present in CRM
    #| UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    #| 10018059 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    #| 10018059 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |
#




 # Bulk amend the ASF2023 alloc 25/26 contract and check v3 docs

 Given the override date is '20/11/2025'

 # Bulk file 'Amend Vary' 
 And   there are no files prefixed '10018059' in the Sharepoint 'EDSK-2526-Input-Appendices' folder
 And   there are no files prefixed 'EDSK AY 2526 23042025105948 v1_S059' in the Sharepoint 'Input' folder
 And   there are no files prefixed 'EDSK AY 2526 23042025105948 v1_S059' in the Sharepoint 'Processing' folder
 And   there are no files prefixed 'EDSK AY 2526 23042025105948 v1_S059' in the Sharepoint 'Processed' folder
 And   there are no files prefixed 'EDSK AY 2526 23042025105948 v1_S059' in the Sharepoint 'Reports' folder
 And   spreadsheet 'EDSK AY 2526 23042025105948 v1_S059.xlsx' exists in the Datafiles folder and UKPRN '10018059' is present in cell 'A2' of the Contract tab
#When  the file is copied to the Sharepoint 'Input' folder 
 When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
 Then  a syntax report showing file success should exist in the Sharepoint Reports folder
 And   the syntax report includes the phrase 'Success'
 And   a results report should exist in the Sharepoint Reports folder
 And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


 # Retrieve parameters
 When  I retrieve the latest contract details from CRM for provider '10018059' for FundingType 'EDSK' and period '2526'

 
 # Insert/Update details into the ContractManagement.CreatedContract table (J104)
 #   Note: Documents are created using the system date. The following step 'corrects' this
 Given the following document creation details exist in the ContractManagement.CreatedContract table
 | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
 | [ContractNo]   | 2                     | 0                         | 2025-11-20 12:06:22.000 |

 # Copy\Save a named Sharepoint file to a named folder\filename
 And   Sharepoint file '10018059_[ContractNo]_v2.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018059_[ContractNo]_v2_superseded.pdf'


 #Approve the contract
  
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

#    # Check the CONTRACT version, status and dates in CRM.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018059 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | Variation     |
#	| 10018059 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2025        | 31/07/2026      | Variation     |
#    | 10018059 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2025        | 31/07/2026      | ?             |
#    | 10018059 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |
#


    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

  
   

    # Tidy Up
    Given the override date is reset


@AcceptanceTest @Complete
@Long2Run @Long2Run67
Scenario: S060 Import and release a ASF2023-AS2526 and ASF2023-FCFJ2526 FA. Approve. Check docs, CRM and feed. Amend and repeat
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018060'
    #And   there is no Funding Allocation data in CRM for UKPRN '10018060'
    And   there is no Contract, Task or Workflow data for UKPRN '10018060'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018060'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018060'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018060' in the Sharepoint 'AEB2023-2526-Input-Appendices' folder

    # Clear down the Cfs stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | AEB2023         | AY2526        | ASF2023_2526 | Contract for Services                   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
	
	And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASF2023-AS2526    |
    | ASF2023-FCFJ2526  |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018060' 
    And   there is no caseload advisor for UKPRN '10018060' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018060 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018060' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018060 Co Ltd' with UKPRN '10018060' and OrgId 'ORG0018060' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018060 | 118060 | 10018060 Co Ltd | 0              | Active                | Yes           | AA018060      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018060 |







    # Populate the stub with ASF data

   # Change the date 
   Given the override date is '01/07/2025'

   # Clear down the Cfs stub
   And   there is no data in the CFS stub

   # Funding Allocation 
   And   the following Funding Allocation data is in the CFS stub
   | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
   | Contracting    | 10018060 | AEB2023-AY-2526-Contract-Provider-10018060-3_5        | 3_5            | ASFC                        | AY-2526            | 8180.00          |

   # Provider Funding Allocation
   And   the following Provider Funding Agreement data is present in the CFS stub

   | ProviderFundingId             | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                                 | ProviderSubType                                   | ProviderFundingTotalValue |
   | AEB2023-AY-2526-10018060-3_5  | 3_5                 	| AEB2023-AY-2526-Contract-Provider-10018060-3_5        | 10018060      | Limited Liability Partnership                | Direct Funded Organisation              	               | 8180.00                  |


   # Funding Allocation Line (aka Deliverable)
   And   the following Funding Allocation Line data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
   | AEB2023-AY-2526-10018060-3_5   | ASFC-001         | 1000.00		| Payment         |
   | AEB2023-AY-2526-10018060-3_5   | ASFC-002         | 3680.00        | Payment         |
   | AEB2023-AY-2526-10018060-3_5   | ASFC-003         | 6320.00        | Payment         |
   | AEB2023-AY-2526-10018060-3_5   | ASFC-004         | 2500.00        | Payment         |


   # Funding Allocation Profile Period
   And   the following Funding Allocation Profile Period data is present in the CFS stub
   | ProviderFundingId          	| FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
   | AEB2023-AY-2526-10018060-3_5   | ASFC-001         | FY-2526              | September            | 2025              | 1000.00                    |
   | AEB2023-AY-2526-10018060-3_5   | ASFC-002         | FY-2526              | April	             | 2026              | 3680.00                    |
   | AEB2023-AY-2526-10018060-3_5   | ASFC-003         | FY-2526              | November             | 2025              | 6320.00                    |
   | AEB2023-AY-2526-10018060-3_5   | ASFC-004         | FY-2526              | December	         | 2025              | 2500.00                    |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode 	 | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2526        | ASF2023_2526     | Contract for Services    			   | Cfs    	               |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                                  | FundingVersion | FundingType                				| Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018060 | 10018060 Co Ltd  | AEB2023-AY-2526-Contract-Provider-10018060-3_5             | 3_5         	| Adult Education Budget - 2023 Procurement | AY2526  | Contract for Services       			 | ASFC                        | ASF2023_2526    | Scheduling        | Awaiting Release  | 8180.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2526-Contract-Provider-10018060-3_5          | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 8180.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018060 | AEB2023-AY-2526-Contract-Provider-10018060-3_5          | 3_5            | AY-2526 | ASFC                        | 8180.00    | [Cfs]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [Cfs]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 8180.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018060' for FundingType 'AEB2023' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018060' for FundingType 'AEB2023' and period '2526' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                					 | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018060 | 10018060 Co Ltd  | AEB2023-AY-2526-Contract-Provider-10018060-3_5          | 3_5            | Adult Education Budget - 2023 Procurement     | AY2526  | Contract for Services                     | ASFC                        | ASF2023_2526        | Released          | Released          | 8180.00     | [ContractNo]  | 1            | CRM Integration   | CRMDeploy CRMDeploy   | ?                         | [Cfs]           | ?          | ?                   |




    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2526-Contract-Provider-10018060-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | AEB2023-AY-2526-Contract-Provider-10018060-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup     | Status            | SubStatus                         |
    | 10018060 | AEB2023-AY-2526-Contract-Provider-10018060-3_5          | 3_5            | AY-2526 | ASFC                        | 8180.00     | [Cfs]            | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | AEB2023-AY-2526-Contract-Provider-10018060-3_5          | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018060 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
#    | 10018060 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |
#
#    # Check that the Contract and Master Contract have been created correctly in CRM
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            					| HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10018060 | [ContractNo]       | Adult Education Budget - 2023 Procurement                 | Contract      | Draft          | Awaiting Documentation  | 8180.00       | 1                     | 0                        | 01/08/2025        | 31/07/2026      | True          | False               | ?             | Contract for Services                      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10018060 Co Ltd  | Active | Document Management Team  | ?                      |
#    | 10018060 | [MasterContractNo] | Adult Education Budget - 2023 Procurement                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                         | 01/08/2025        | 31/07/2026      | False         | False               | ?             | Contract for Services                      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018060 Co Ltd  | Active | CRM Integration           | ?                      |


     # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10018060 | [ContractNo]       | [AllocRef_ASCA]       | ?                             | 11000.00        | 10018060      | 10018060 Co Ltd  | 01/08/2025 | 31/07/2026 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
#    | 10018060 | [ContractNo]       | [AllocRef_ASFC]       | ?                             | 2500.00         | 10018060      | 10018060 Co Ltd  | 01/08/2025 | 31/07/2026 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
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

    ## Check the deliverable count in CRM
    #Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

     #Check the contents of the Appendices
#    And   the file named '10010026_[ContractNo]_v1.pdf' in Sharepoint location 'ASFG-2526-Input-Appendices' contains the following lines in order
#    """
#
#    SUMMARY OF FUNDING
#    Organisation Name: 10018060 Co Ltd UKPRN: 10018060
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    1 August 2024 to 31 July 2025 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
#    Adult Education Budget - 2023 Procurement (ASFG) [AllocRef_ASFG] £0 £4,632 £4,632
#    Total: £4,632
#    Total Funding for this contract: £4,632
#    Summary of Funding – Page 1
#    Agreement Type Contract for Services 
#    st st st
#    1 August 2024 to 31 July 2025 or 31 July 2026 if
#    Funding Period
#    extended by the Department pursuant to Clause 2.3
#    Between the Secretary of State for Education
#    And 10018060 Co Ltd
#    Funding for Adult Education Budget - 2023 Procurement (ASFG)
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
#    Contractor on the Manage Your Adult Education Budget - 2023 Procurement Service between:
#    10018060 Co Ltd THE SECRETARY OF STATE FOR
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
#    Adult Education Budget - 2023 Procurement (ASFG) SPECIFICATION
#    ASFG Schedule 1 – Annex 1 Version 1 (July 2024) – Page 2
#    SCHEDULE 2: PAYMENT
#    Adult Education Budget - 2023 Procurement (ASFG) PAYMENT
#    ASFG Schedule 2 Version 1 (July 2024) – Page 1
#    SCHEDULE 2
#    Funding Agreement
#    Provider: 10018060 Co Ltd UKPRN: 10018060
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_ASFG]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
#    Adult Education Budget - 2023 Procurement (ASFG) £4,632 £0 £0 £0 £0 £0 £0 £0 £0 £0 £4,632 £0 £0
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
    And   Sharepoint file '10018060_[ContractNo]_v1.pdf' in 'AEB2023-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018060_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2025-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018060'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018060 - 10018060 Co Ltd Awaiting documentation  | [AllocRef_ASFC] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018060 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018060 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018060 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |



    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2025'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018060_[ContractNo]_v1.pdf' is created in 'AEB2023-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018060 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018060 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018060 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018060 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                					 | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018060 | 10018060 Co Ltd  | AEB2023-AY-2526-Contract-Provider-10018060-3_5          | 3_5            | Adult Education Budget - 2023 Procurement     | AY2526  | Contract for Services                     | ASFC                        | ASF2023_2526        | Contract Approved | Contract Approved | 8180.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [Cfs]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               	| FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018060 | AEB2023-AY-2526-Contract-Provider-10018060-3_5             | 3_5            | AY-2526 | ASFC                        | 8180.00     | [Cfs]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2526-Contract-Provider-10018060-3_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    #Then  the Legal Contract CM feed contains the following '4' deliverables
    #| UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    #| 10018060 | [ContractNo]   | 1               | [AllocRef_ASCA]  | 5               | 1                     | 3680.00       | 0             | 0        | Tailored Learning                                  | ?                           |
    #| 10018060 | [ContractNo]   | 1               |  [AllocRef_ASCA] | 2               | 1                     |  1000.00      | 0             | 0        |  Adult Skills Total Funding                        | ?                           |
    #| 10018060 | [ContractNo]   | 1               |  [AllocRef_ASCA] | 12              | 1                     |  6320.00      | 0             | 0        |  Funding for Innovative Provision                  | ?                           |
    #| 10018060 | [ContractNo]   | 1               |  [AllocRef_ASFC] | 2               | 1                     |  2500.00      | 0             | 0        |  Funding for Innovative Provision                  | ?                           |

   
     # Amend contract

    # Change the date
    Given the override date is '01/07/2026'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018060 | AEB2023-AY-2526-Contract-Provider-10018060-4_7        | 4_7            | ASFC                        | AY-2526            | 16882.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId             | ProviderFundingVersion | FundingId                                                | DeliveryUKPRN | ProviderType                | ProviderSubType          | ProviderFundingTotalValue |
    | AEB2023-AY-2526-10018060-4_7  | 4_7                    | AEB2023-AY-2526-Contract-Provider-10018060-4_7           | 10018060      | PRI/LTD BY GUAR/NSC         | Private Sector           | 16882.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue    | FundingLineType |
    | AEB2023-AY-2526-10018060-4_7   | ASFC-001       | 3172.00		     | Payment         |
    | AEB2023-AY-2526-10018060-4_7   | ASFC-002       | 4892.00          | Payment         |
    | AEB2023-AY-2526-10018060-4_7   | ASFC-003       | 5859.00          | Payment         |
    | AEB2023-AY-2526-10018060-4_7   | ASFC-004       | 2959.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | AEB2023-AY-2526-10018060-4_7  | ASFC-001        | FY-2526              | September            | 2025              | 3172.00                   |
    | AEB2023-AY-2526-10018060-4_7  | ASFC-002        | FY-2526              | April	            | 2026              | 4892.00                   |
    | AEB2023-AY-2526-10018060-4_7  | ASFC-003        | FY-2526              | November             | 2025              | 5859.00                   |
    | AEB2023-AY-2526-10018060-4_7  | ASFC-004        | FY-2526              | December	            | 2025              | 2959.00                   |
 
     # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode      | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2526        | ASF2023_2526      | Contract for Services                   | Cfs                       |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window
	
	
    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                               | Period  | ContractType                | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018060 | 10018060 Co Ltd  | AEB2023-AY-2526-Contract-Provider-10018060-4_7          | 4_7            |Adult Education Budget - 2023 Procurement  | AY2526  | Contract for Services       | ASFC                        | ASF2023_2526    | Scheduling        | Awaiting Release  | 16882.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs]            | ?          | ?                   |

    
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2526-Contract-Provider-10018060-4_7          | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 16882.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                                  | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status            | SubStatus                         |
    | 10018060 | AEB2023-AY-2526-Contract-Provider-10018060-4_7             | 4_7            | AY-2526 | ASFC                        | 16882.00    | [Cfs]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '19/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [Cfs]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 16882.00        |


      # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018060' for FundingType 'AEB2023' and period '2526'

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                                  | FundingVersion | FundingType                				| Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018060 | 10018060 Co Ltd  | AEB2023-AY-2526-Contract-Provider-10018060-4_7             | 4_7            | Adult Education Budget - 2023 Procurement | AY2526  | Contract for Services                    | ASFC                        | ASF2023_2526        | Released          | Released          | 16882.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [Cfs]          | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2526-Contract-Provider-10018060-4_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | AEB2023-AY-2526-Contract-Provider-10018060-4_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                                  | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018060 | AEB2023-AY-2526-Contract-Provider-10018060-4_7             | 4_7            | AY-2526 | ASFC                        | 16882.00    | [Cfs]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | AEB2023-AY-2526-Contract-Provider-10018060-4_7          | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018060 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2025        | 31/07/2026      | Variation     |
    | 10018060 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018060 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10018060 | [ContractNo]       | Adult Education Budget - 2023 Procurement                 | Contract      | Draft          | Awaiting Documentation  | 16882.00      | 2                     | 0                        | 01/08/2025        | 31/07/2026      | True          | False               | ?         | Contract for Services        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | [ContractNo]    | 10018060 Co Ltd  | Active | Document Management Team  | 3382.00               |
    | 10018060 | [MasterContractNo] | Adult Education Budget - 2023 Procurement                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2025        | 31/07/2026      | False         | False               | ?         | Contract for Services        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10018060 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    #And   the following Contract Allocations exist in CRM
    #| UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    #| 10018060 | [ContractNo]       | [AllocRef_ASCA]       | ?                             | 13923.00        | ?             | ?                | 01/08/2025 | 31/07/2026 | ASFG          | ASFG2425            | Contract Allocation   | 2923.00                 |
    #| 10018060 | [ContractNo]       | [AllocRef_ASFC]       | ?                             | 2959.00        | ?             | ?                | 01/08/2025 | 31/07/2026 | ASFG          | ASFG2425            | Contract Allocation   | 459.00                 |

## Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    #And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    #| ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                  | DeliverableDescription   |
#    #| [ContractNo]   | [AllocRef_ASCA] | 5               | 4892.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |
#    #| [ContractNo]   | [AllocRef_ASCA] | 2               | 3172.00   | 0.00     | 3172.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |
#    #| [ContractNo]   | [AllocRef_ASCA] | 12              | 5859.00   | 0.00     | 0.00     | 0.00     | 5859.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |
#    #| [ContractNo]   | [AllocRef_ASFC] | 2               | 2959.00   | 0.00     | 0.00     | 0.00     | 0.00     | 2959.00  | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |



    # Contract is now at 'Draft\Awaiting Documentation'

    ## Check the deliverable count in CRM
    #Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


 
    #Check the contents of the Appendices  (SoF and FA)
    #And   the file named '10010026_[ContractNo]_v2.pdf' in Sharepoint location 'ASFG-2526-Input-Appendices' contains the following lines in order
    #"""
    #SUMMARY OF FUNDING
    #Organisation Name: 10018060 Co Ltd UKPRN: 10018060
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
    #Provider: 10018060 Co Ltd UKPRN: 10018060
    #Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
    #Contract Ref: [AllocRef_ASFG]
    #Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    #Dance and Drama Awards (ASFG) £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Total Funding £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Schedule 2 – Funding Agreement [AllocRef_ASFG] – Page 1 Ref (for internal use only):  [ContractNo] v2
    #"""

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018060_[ContractNo]_v2.pdf' in 'AEB2023-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018060_[ContractNo]_v2.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2025-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10018060'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018060 - 10018060 Co Ltd Awaiting documentation  | [AllocRef_ASFA23] | Document Management Team  | ?                | Open       | Not Started   |
    | Initiate Document Merge   | 10018060 - 10018060 Co Ltd Awaiting documentation  | [AllocRef_ASFJ23] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '2' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10018060 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10018060 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10018060 | [MasterContractNo] | [ContractNo]   | 2                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |


   # Publish the contract

    # Change the date 
    Given the override date is '20/07/2025'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018060_[ContractNo]_v2.pdf' is created in 'AEB2023-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018060 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | Variation     |
    | 10018060 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | False         | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018060 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |


  # Approve the contract

    # Change the date 
    Given the override date is '21/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018060 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | Variation     |
    | 10018060 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018060 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                               | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018060 | 10018060 Co Ltd  | AEB2023-AY-2526-Contract-Provider-10018060-4_7          | 4_7            | Adult Education Budget - 2023 Procurement | AY2526  |  Contract for Services                   | ASFC                        | ASF2023_2526        | Contract Approved | Contract Approved | 16882.00    | [ContractNo]  | 2           | CRM Integration       | CRM Integration           | ?                         | [Cfs]          | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018060 | AEB2023-AY-2526-Contract-Provider-10018060-4_7          | 4_7            | AY-2526 | ASFC                        | 16882.00    | [Cfs]          | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2526-Contract-Provider-10018060-4_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    #Bulk import to add STFI

 # Bulk amend the ASF2023 alloc 25/26 contract and check v3 docs

 Given the override date is '20/07/2025'

 # Bulk file 'Amend Vary' 
 And   there are no files prefixed '10018060' in the Sharepoint 'AEB2023-2526-Input-Appendices' folder
 And   there are no files prefixed 'AEB2023 AY 2526 01082024112659 v3_S060' in the Sharepoint 'Input' folder
 And   there are no files prefixed 'AEB2023 AY 2526 01082024112659 v3_S060' in the Sharepoint 'Processing' folder
 And   there are no files prefixed 'AEB2023 AY 2526 01082024112659 v3_S060' in the Sharepoint 'Processed' folder
 And   there are no files prefixed 'AEB2023 AY 2526 01082024112659 v3_S060' in the Sharepoint 'Reports' folder
 And   spreadsheet 'AEB2023 AY 2526 01082024112659 v3_S060.xlsx' exists in the Datafiles folder and UKPRN '10018060' is present in cell 'A2' of the Contract tab
#When  the file is copied to the Sharepoint 'Input' folder 
 When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
 Then  a syntax report showing file success should exist in the Sharepoint Reports folder
 And   the syntax report includes the phrase 'Success'
 And   a results report should exist in the Sharepoint Reports folder
 And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


 # Retrieve parameters
 When  I retrieve the latest contract details from CRM for provider '10018060' for FundingType 'AEB2023' and period '2526'

 
 # Insert/Update details into the ContractManagement.CreatedContract table (J104)
 #   Note: Documents are created using the system date. The following step 'corrects' this
 Given the following document creation details exist in the ContractManagement.CreatedContract table
 | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
 | [ContractNo]   | 2                    | 0                        | 2022-09-15 12:06:22.000 |

 # Copy\Save a named Sharepoint file to a named folder\filename
 And   Sharepoint file '10018060_[ContractNo]_v3.pdf' in 'AEB2023-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S060_v3.pdf'

 #Approve the contract
  
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018060 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | Variation     |
	| 10018060 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2025        | 31/07/2026      | Variation     |
    | 10018060 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018060 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 3                     | 0                        | 2025-07-20 09:12:35.000 |






        # Part 5: Add Actuals for 24/25 then check CRM

    # Add actuals to the contract for ASF2023-AS2526, ASF2023-FCFJ2526 

    # Change the date
    Given the override date is '04/10/2025'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018060'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber   | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 656.38      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 514.81      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 564.11      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1411.24     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 478.56      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1469.21     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1163.17     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 2352.37     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 465.26      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 2003.87     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 699.93      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 844.84      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1604.57     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 860.77      |
 #
 #   #                                                                                                            
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1951.00     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 627.27      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1274.11     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1790.98     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 615.15      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1977.70     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1956.70     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 804.17      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 855.21      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 631.06      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 938.44      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 995.84      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1931.92     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 2158.27     |


    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-STFI2526         | [AllocRef_STFI23]           | ?          | 1               | 0            | 1951.00     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-STFI2526         | [AllocRef_STFI23]           | ?          | 5               | 0            | 627.27      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202508 | ASF2023-STFI2526         | [AllocRef_STFI23]           | ?          | 6               | 0            | 1274.11     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-STFI2526         | [AllocRef_STFI23]           | ?          | 1              | 0            | 1790.98     |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-STFI2526         | [AllocRef_STFI23]           | ?          | 5              | 0            | 615.15      |
    | ILR2526        | R02                  | ORG0018060     | CM             | 202509 | ASF2023-STFI2526         | [AllocRef_STFI23]           | ?          | 6              | 0            | 1977.70     |

    Then wait '30' seconds


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then wait '30' seconds


 #
 #   # Check the ACTUAL VALUES in CRM on the latest approved contract
 #   Then  the Actuals Value Data is as follows
 #   | ContractNumber | AllocationRef | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 1             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 2             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 3             | 2755.17   | 1951.00  | 804.17   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 4             | 1482.48   | 627.27   | 855.21   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 5             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 6             | 1905.17   | 1274.11  | 631.06   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 7             | 2729.42   | 1790.98  | 938.44   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 8             | 1610.99   | 615.15   | 995.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 9             | 3909.62   | 1977.70  | 1931.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 10            | 4114.97   | 1956.70  | 2158.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   #
 #   | [ContractNo]   | [AllocRef_ASFA23]| 1             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 2             | 3008.75   | 656.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 3             | 980.07    | 514.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 4             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 5             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 6             | 2567.98   | 564.11   | 2003.87  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 7             | 2111.17   | 1411.24  | 699.93   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 8             | 1323.40   | 478.56   | 844.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 9             | 3073.78   | 1469.21  | 1604.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 10            | 2023.94   | 1163.17  | 860.77   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	#

#
#
#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 3               | 2755.17   | 0.00     | 2755.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 4               | 1482.48   | 0.00     | 1482.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 6               | 1905.17   | 0.00     | 1905.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 7               | 2729.42   | 0.00     | 2729.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 8               | 1610.99   | 0.00     | 1610.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 9               | 3909.62   | 0.00     | 3909.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 10              | 4114.97   | 0.00     | 4114.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_ASFA23]  | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 2               | 3008.75   | 0.00     | 3008.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 3               | 980.07    | 0.00     | 980.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 6               | 2567.98   | 0.00     | 2567.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 7               | 2111.17   | 0.00     | 2111.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 8               | 1323.40   | 0.00     | 1323.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 9               | 3073.78   | 0.00     | 3073.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 10              | 2023.94   | 0.00     | 2023.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#






    
    # Payment Batch for ASFC-ASCL2526(PoA)

    # Change the date
    Given the override date is '08/10/2025 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASF2023-AS2526' AccountingPaymentPeriod '202506' CensusEndDate '08/10/2025' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ASFA23]          | 202509 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASF2023-AS2526             | 202509               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ASF2023-AS2526             | 202509               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ASF2023-AS2526' PaymentPeriod '202506' CensusEndDate '08/10/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S060_ASFA.xml'
#
#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ALLB2526' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' includes the following values
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


    
    # Payment Batch for ASFC-ASFJ(PoA)

    # Change the date
    Given the override date is '08/10/2025 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASF2023-FCFJ2526' AccountingPaymentPeriod '202506' CensusEndDate '08/10/2025' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ASFJ23]          | 202509 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASF2023-FCFJ2526           | 202509               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ASF2023-FCFJ2526           | 202509               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ASF2023-FCFJ2526' PaymentPeriod '202506' CensusEndDate '08/10/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S060_ASFJ.xml'
#



 # Payment Batch for ASFC-STFI(PoA)

    # Change the date
    Given the override date is '08/10/2025 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASF2023-STFI2526' AccountingPaymentPeriod '202506' CensusEndDate '08/10/2025' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ASFS23]          | 202509 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASF2023-STFI2526           | 202509               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ASF2023-STFI2526           | 202509               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ASF2023-STFI2526' PaymentPeriod '202506' CensusEndDate '08/10/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S060_STFI.xml'
#


    # Change the date
    Given the override date is '09/10/2025 09:05'
    
   #  Part 10: Create Consolidated Payment Summary rpt
   
   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
   Given there are no files prefixed '2024-10 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder

   When  a Consolidated Payment Summary Report is created in Sharepoint for '09/10/2025'

    # Check the above report manually





    # Part 6: Create and check the contents of the CDA report
   
    # Change the date
    Given the override date is '11/10/2025'
    
    # Check the contents of the CDA report
    And   there is no CDA report named 'CDA Last Approved Version S058.csv'

    And   the following ADF Pipeline run

    #And   the following contracts are in the replicated CRM database
    #| ContractNumber  | ContractVersionNumber |
    #| [ContractNo]    | 3                     |

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod	| Version               | Suffix |
    | ASF2023-AS2526              | Last Approved         | S058   |
    | ASF2023-FCFJ2526              | Last Approved         | S058   |

    Then  a report named 'CDA Last Approved Version S058.csv' is created

    # Check the contents of the CDA Report manually



    # Tidy Up
    Given the override date is reset



@AcceptanceTest @Inprogress
@Long2Run @Long2Run67
Scenario: S061 Create and Update amend v1 AEB2026 contract. Publish and Approve. Bulk amend variation v2 and verify docs. Run payment batch and generate reports.
    Given there are no allocations marked as Under Termination for UKPRN '100180' 
    And   there are no terminated or closed allocations for UKPRN '10018061' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018061' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018061' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ASFA23-8061     |
	| ASFJ23-8061     |
	


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ASFA23-8061     |
	| ASFJ23-8061     |


    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASF2026-AS2526    |
    | ASF2026-FCFJ2526  |

	

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | ASFP23-8061     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018061'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10018061' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018061 Co Ltd' with UKPRN '10018061' and OrgId 'ORG0018061' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10018061' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018061 | 118061 | 10018061 Co Ltd | 0              | In Administration     | Yes           | AA018061      | ?             | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018061 |



    # Change the date
      Given the override date is '01/07/2025'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                              | Period | CRMIntent    | OrgId      |
    | 10018061 | 10018061 Co Ltd      |DFE-18061           | ASFP23-8061     | 1                     | 01/04/2025        | 31/03/2026      | 19607.00     |                                       | Contract for Services				        | 2526   | New          | ORG0018061 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode  | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018061 | ASFP23-8061	    | ASFA23-8061   	| ASF23-AS     	    | ASF23-AS2526        	  | FY                      | 01/04/2025          | 31/03/2026        | 19607.00        |            |        	|                                                             | New          |             |
    | 10018061 | ASFP23-8061	    | ASFA23-8061   	| ASF23-FCFJ     	| ASF23-FCFJ2526      	  | FY                      | 01/04/2025          | 31/03/2026        | 19607.00        |            |        	|                                                             | New          |             |


    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | ASFP23-8061     | 1                     | 0                        | 2025-07-22 15:43:08.000 |


    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018061 | ASFP23-8061         | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2025        | 31/03/2026      | ?             |
    | 10018061 | DFE-18061         | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2025        | 31/03/2026      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'ASFP23-8061'



