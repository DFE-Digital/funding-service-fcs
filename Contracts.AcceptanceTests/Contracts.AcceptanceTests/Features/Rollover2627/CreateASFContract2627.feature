Feature: Create ASFContract2627


@AcceptanceTest @Complete
@Long2Run @Long2Run67
Scenario: AK062 Import and release a ASF2023-AS2627 and ASF2023-FCFJ2627 FA. Approve. Check docs, CRM and feed. Amend and repeat
       Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10010062'
    #And   there is no Funding Allocation data in CRM for UKPRN '10010062'
    And   there is no Contract, Task or Workflow data for UKPRN '10010062'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10010062'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010062'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10010062' in the Sharepoint 'AEB2023-2627-Input-Appendices' folder

    # Clear down the Cfs stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | AEB2023         | AY2627        | ASF2023_2627 | Contract for Services                   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
	
	And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASF2023-AS2627    |
    | ASF2023-FCFJ2627  |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010062' 
    And   there is no caseload advisor for UKPRN '10010062' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010062 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010062' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010062 Co Ltd' with UKPRN '10010062' and OrgId 'ORG0010062' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010062 | 110062 | 10010062 Co Ltd | 0              | Active                | Yes           | AA010062      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010062 |







    # Populate the stub with ASF data

   # Change the date 
   Given the override date is '01/07/2026'

   # Clear down the Cfs stub
   And   there is no data in the CFS stub

   # Funding Allocation 
   And   the following Funding Allocation data is in the CFS stub
   | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
   | Contracting    | 10010062 | AEB2023-AY-2627-Contract-Provider-10010062-3_5        | 3_5            | ASFC                        | AY-2627            | 8180.00          |

   # Provider Funding Allocation
   And   the following Provider Funding Agreement data is present in the CFS stub

   | ProviderFundingId             | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                                 | ProviderSubType                                   | ProviderFundingTotalValue |
   | AEB2023-AY-2627-10010062-3_5  | 3_5                 	| AEB2023-AY-2627-Contract-Provider-10010062-3_5        | 10010062      | Limited Liability Partnership                | Direct Funded Organisation              	               | 8180.00                  |


   # Funding Allocation Line (aka Deliverable)
   And   the following Funding Allocation Line data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
   | AEB2023-AY-2627-10010062-3_5   | ASFC-001         | 1000.00		| Payment         |
   | AEB2023-AY-2627-10010062-3_5   | ASFC-002         | 3680.00        | Payment         |
   | AEB2023-AY-2627-10010062-3_5   | ASFC-003         | 6320.00        | Payment         |
   | AEB2023-AY-2627-10010062-3_5   | ASFC-004         | 2500.00        | Payment         |


   # Funding Allocation Profile Period
   And   the following Funding Allocation Profile Period data is present in the CFS stub
   | ProviderFundingId          	| FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
   | AEB2023-AY-2627-10010062-3_5   | ASFC-001         | FY-2627              | September            | 2026              | 1000.00                    |
   | AEB2023-AY-2627-10010062-3_5   | ASFC-002         | FY-2627              | April	             | 2027              | 3680.00                    |
   | AEB2023-AY-2627-10010062-3_5   | ASFC-003         | FY-2627              | November             | 2026              | 6320.00                    |
   | AEB2023-AY-2627-10010062-3_5   | ASFC-004         | FY-2627              | December	         | 2026              | 2500.00                    |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2026'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode 	 | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2627       | ASF2023_2627     | Contract for Services    			   | Cfs    	               |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                                  | FundingVersion | FundingType                				| Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10010062 | 10010062 Co Ltd  | AEB2023-AY-2627-Contract-Provider-10010062-3_5             | 3_5         	| Adult Education Budget - 2023 Procurement | AY2627  | Contract for Services       			 | ASFC                        | ASF2023_2627    | Scheduling        | Awaiting Release  | 8180.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2627-Contract-Provider-10010062-3_5          | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 8180.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010062 | AEB2023-AY-2627-Contract-Provider-10010062-3_5          | 3_5            | AY-2627 | ASFC                        | 8180.00    | [Cfs]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'
 # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2026'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [Cfs]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    #Then  Release Group '[Cfs]' has the following characteristics
    #| ReleaseStatus     | AllocationCount | AllocationValue |
    #| Released          | 1               | 8180.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10010062' for FundingType 'AEB2023' and period '2627'
   #When  I retrieve the latest EFA contract details from CRM for provider '10010062' for FundingType 'AEB2023' and period '2627' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                					 | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010062 | 10010062 Co Ltd  | AEB2023-AY-2627-Contract-Provider-10010062-3_5          | 3_5            | Adult Education Budget - 2023 Procurement     | AY2627  | Contract for Services                     | ASFC                        | ASF2023_2627        | Released          | Released          | 8180.00     | [ContractNo]  | 1            | CRM Integration   | CRMDeploy CRMDeploy   | ?                         | [Cfs]           | ?          | ?                   |




    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2627-Contract-Provider-10010062-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | AEB2023-AY-2627-Contract-Provider-10010062-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup     | Status            | SubStatus                         |
    | 10010062 | AEB2023-AY-2627-Contract-Provider-10010062-3_5          | 3_5            | AY-2627 | ASFC                        | 8180.00     | [Cfs]            | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | AEB2023-AY-2627-Contract-Provider-10010062-3_5          | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010062 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2026        | 31/07/2027      | ?             |
    | 10010062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2026        | 31/07/2027      | ?             |

#    # Check that the Contract and Master Contract have been created correctly in CRM
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            					| HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10010062 | [ContractNo]       | Adult Education Budget - 2023 Procurement                 | Contract      | Draft          | Awaiting Documentation  | 8180.00       | 1                     | 0                        | 01/08/2026        | 31/07/2027      | True          | False               | ?             | Contract for Services                      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2627 | ?               | 10010062 Co Ltd  | Active | Document Management Team  | ?                      |
#    | 10010062 | [MasterContractNo] | Adult Education Budget - 2023 Procurement                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                         | 01/08/2026        | 31/07/2027      | False         | False               | ?             | Contract for Services                      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10010062 Co Ltd  | Active | CRM Integration           | ?                      |
#
#
#     # Check that the Contract Allocations have been created correctly in CRM
##    And   the following Contract Allocations exist in CRM
##    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
##    | 10010062 | [ContractNo]       | [AllocRef_ASCA]       | ?                             | 11000.00        | 10010062      | 10010062 Co Ltd  | 01/08/2026 | 31/07/2027 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
##    | 10010062 | [ContractNo]       | [AllocRef_ASFC]       | ?                             | 2500.00         | 10010062      | 10010062 Co Ltd  | 01/08/2026 | 31/07/2027 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
##
##    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27  | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   | DeliverableName                                             | DeliverableDescription   |
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
#    And   the file named '10010026_[ContractNo]_v1.pdf' in Sharepoint location 'ASFG-2627-Input-Appendices' contains the following lines in order
#    """
#
#    SUMMARY OF FUNDING
#    Organisation Name: 10010062 Co Ltd UKPRN: 10010062
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    1 August 2024 to 31 July 2026 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
#    Adult Education Budget - 2023 Procurement (ASFG) [AllocRef_ASFG] £0 £4,632 £4,632
#    Total: £4,632
#    Total Funding for this contract: £4,632
#    Summary of Funding – Page 1
#    Agreement Type Contract for Services 
#    st st st
#    1 August 2024 to 31 July 2026 or 31 July 2027 if
#    Funding Period
#    extended by the Department pursuant to Clause 2.3
#    Between the Secretary of State for Education
#    And 10010062 Co Ltd
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
#    10010062 Co Ltd THE SECRETARY OF STATE FOR
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
#    Provider: 10010062 Co Ltd UKPRN: 10010062
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2026 End Date: 31/07/2027
#    Contract Ref: [AllocRef_ASFG]
#    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2026 Feb 2026 Mar 2026 Apr 2026 May 2026 Jun 2026 Jul 2026
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
    And   Sharepoint file '10010062_[ContractNo]_v1.pdf' in 'AEB2023-2627-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010062_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2026-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10010062'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10010062 - 10010062 Co Ltd Awaiting documentation  | [AllocRef_ASFC] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10010062 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10010062 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10010062 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |



    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2026'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10010062_[ContractNo]_v1.pdf' is created in 'AEB2023-2627-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010062 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2026        | 31/07/2027      | ?             |
    | 10010062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2026        | 31/07/2027      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2026'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010062 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2026        | 31/07/2027      | ?             |
    | 10010062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2026        | 31/07/2027      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                					 | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010062 | 10010062 Co Ltd  | AEB2023-AY-2627-Contract-Provider-10010062-3_5          | 3_5            | Adult Education Budget - 2023 Procurement     | AY2627  | Contract for Services                     | ASFC                        | ASF2023_2627        | Contract Approved | Contract Approved | 8180.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [Cfs]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               	| FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010062 | AEB2023-AY-2627-Contract-Provider-10010062-3_5             | 3_5            | AY-2627 | ASFC                        | 8180.00     | [Cfs]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2627-Contract-Provider-10010062-3_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    #Then  the Legal Contract CM feed contains the following '4' deliverables
    #| UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    #| 10010062 | [ContractNo]   | 1               | [AllocRef_ASCA]  | 5               | 1                     | 3680.00       | 0             | 0        | Tailored Learning                                  | ?                           |
    #| 10010062 | [ContractNo]   | 1               |  [AllocRef_ASCA] | 2               | 1                     |  1000.00      | 0             | 0        |  Adult Skills Total Funding                        | ?                           |
    #| 10010062 | [ContractNo]   | 1               |  [AllocRef_ASCA] | 12              | 1                     |  6320.00      | 0             | 0        |  Funding for Innovative Provision                  | ?                           |
    #| 10010062 | [ContractNo]   | 1               |  [AllocRef_ASFC] | 2               | 1                     |  2500.00      | 0             | 0        |  Funding for Innovative Provision                  | ?                           |

   
   
     # Amend contract

    # Change the date
    Given the override date is '01/07/2027'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10010062 | AEB2023-AY-2627-Contract-Provider-10010062-4_7        | 4_7            | ASFC                        | AY-2627            | 16882.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId             | ProviderFundingVersion | FundingId                                                | DeliveryUKPRN | ProviderType                | ProviderSubType          | ProviderFundingTotalValue |
    | AEB2023-AY-2627-10010062-4_7  | 4_7                    | AEB2023-AY-2627-Contract-Provider-10010062-4_7           | 10010062      | PRI/LTD BY GUAR/NSC         | Private Sector           | 16882.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue    | FundingLineType |
    | AEB2023-AY-2627-10010062-4_7   | ASFC-001       | 3172.00		     | Payment         |
    | AEB2023-AY-2627-10010062-4_7   | ASFC-002       | 4892.00          | Payment         |
    | AEB2023-AY-2627-10010062-4_7   | ASFC-003       | 5859.00          | Payment         |
    | AEB2023-AY-2627-10010062-4_7   | ASFC-004       | 2959.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
   | AEB2023-AY-2627-10010062-4_7  | ASFC-001        | FY-2627              | September            | 2026              | 3172.00                   |
    | AEB2023-AY-2627-10010062-4_7  | ASFC-002        | FY-2627              | April	            | 2027              | 4892.00                   |
    | AEB2023-AY-2627-10010062-4_7  | ASFC-003        | FY-2627              | November             | 2026              | 5859.00                   |
    | AEB2023-AY-2627-10010062-4_7  | ASFC-004        | FY-2627              | December	            | 2026              | 2959.00                   |
 
     # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2026'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode      | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2627        | ASF2023_2627      | Contract for Services                   | Cfs                       |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window
	
	
    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                               | Period  | ContractType                | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10010062 | 10010062 Co Ltd  | AEB2023-AY-2627-Contract-Provider-10010062-4_7          | 4_7            |Adult Education Budget - 2023 Procurement  | AY2627  | Contract for Services       | ASFC                        | ASF2023_2627    | Scheduling        | Awaiting Release  | 16882.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs]            | ?          | ?                   |

    
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2627-Contract-Provider-10010062-4_7          | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 16882.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                                  | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status            | SubStatus                         |
    | 10010062 | AEB2023-AY-2627-Contract-Provider-10010062-4_7             | 4_7            | AY-2627 | ASFC                        | 16882.00    | [Cfs]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '19/07/2026'

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
    When  I retrieve the latest contract details from CRM for provider '10010062' for FundingType 'AEB2023' and period '2627'

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                                  | FundingVersion | FundingType                				| Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010062 | 10010062 Co Ltd  | AEB2023-AY-2627-Contract-Provider-10010062-4_7             | 4_7            | Adult Education Budget - 2023 Procurement | AY2627  | Contract for Services                    | ASFC                        | ASF2023_2627        | Released          | Released          | 16882.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [Cfs]          | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2627-Contract-Provider-10010062-4_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | AEB2023-AY-2627-Contract-Provider-10010062-4_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                                  | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010062 | AEB2023-AY-2627-Contract-Provider-10010062-4_7             | 4_7            | AY-2627 | ASFC                        | 16882.00    | [Cfs]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | AEB2023-AY-2627-Contract-Provider-10010062-4_7          | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010062 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2026        | 31/07/2027      | Variation     |
    | 10010062 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2026        | 31/07/2027      | ?             |
    | 10010062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2026        | 31/07/2027      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10010062 | [ContractNo]       | Adult Education Budget - 2023 Procurement                 | Contract      | Draft          | Awaiting Documentation  | 16882.00      | 2                     | 0                        | 01/08/2026        | 31/07/2027      | True          | False               | ?         | Contract for Services        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2627 | [ContractNo]    | 10010062 Co Ltd  | Active | Document Management Team  | 3382.00               |
    | 10010062 | [MasterContractNo] | Adult Education Budget - 2023 Procurement                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2026        | 31/07/2027      | False         | False               | ?         | Contract for Services        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10010062 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    #And   the following Contract Allocations exist in CRM
    #| UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    #| 10010062 | [ContractNo]       | [AllocRef_ASCA]       | ?                             | 13923.00        | ?             | ?                | 01/08/2026 | 31/07/2027 | ASFG          | ASFG2425            | Contract Allocation   | 2923.00                 |
    #| 10010062 | [ContractNo]       | [AllocRef_ASFC]       | ?                             | 2959.00        | ?             | ?                | 01/08/2026 | 31/07/2027 | ASFG          | ASFG2425            | Contract Allocation   | 459.00                 |

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
    #And   the file named '10010026_[ContractNo]_v2.pdf' in Sharepoint location 'ASFG-2627-Input-Appendices' contains the following lines in order
    #"""
    #SUMMARY OF FUNDING
    #Organisation Name: 10010062 Co Ltd UKPRN: 10010062
    #Master Contract Number: [MasterContractNo]
    #Allocation
    #1 August 2024 to 31 July 2026 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
    #Dance and Drama Awards (ASFG) [AllocRef_ASFG] £13,923 £8,492 £22,415
    #Total: £22,415
    #Total Funding for this contract: £22,415
    #Summary of Funding – Page 1
    #
    #SCHEDULE 2
    #Funding Agreement
    #Provider: 10010062 Co Ltd UKPRN: 10010062
    #Master Contract Number: [MasterContractNo] Start Date: 01/08/2026 End Date: 31/07/2027
    #Contract Ref: [AllocRef_ASFG]
    #Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2026 Feb 2026 Mar 2026 Apr 2026 May 2026 Jun 2026 Jul 2026
    #Dance and Drama Awards (ASFG) £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Total Funding £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Schedule 2 – Funding Agreement [AllocRef_ASFG] – Page 1 Ref (for internal use only):  [ContractNo] v2
    #"""

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010062_[ContractNo]_v2.pdf' in 'AEB2023-2627-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010062_[ContractNo]_v2.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2026-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10010062'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10010062 - 10010062 Co Ltd Awaiting documentation  | [AllocRef_ASFA23] | Document Management Team  | ?                | Open       | Not Started   |
    | Initiate Document Merge   | 10010062 - 10010062 Co Ltd Awaiting documentation  | [AllocRef_ASFJ23] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '2' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10010062 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10010062 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10010062 | [MasterContractNo] | [ContractNo]   | 2                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |


   # Publish the contract

    # Change the date 
    Given the override date is '20/07/2026'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10010062_[ContractNo]_v2.pdf' is created in 'AEB2023-2627-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010062 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2026        | 31/07/2027      | Variation     |
    | 10010062 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | False         | True                | 01/08/2026        | 31/07/2027      | ?             |
    | 10010062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2026        | 31/07/2027      | ?             |


  # Approve the contract

    # Change the date 
    Given the override date is '21/07/2026'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010062 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2026        | 31/07/2027      | Variation     |
    | 10010062 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2026        | 31/07/2027      | ?             |
    | 10010062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2026        | 31/07/2027      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                               | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010062 | 10010062 Co Ltd  | AEB2023-AY-2627-Contract-Provider-10010062-4_7          | 4_7            | Adult Education Budget - 2023 Procurement | AY2627  |  Contract for Services                   | ASFC                        | ASF2023_2627        | Contract Approved | Contract Approved | 16882.00    | [ContractNo]  | 2           | CRM Integration       | CRM Integration           | ?                         | [Cfs]          | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010062 | AEB2023-AY-2627-Contract-Provider-10010062-4_7          | 4_7            | AY-2627 | ASFC                        | 16882.00    | [Cfs]          | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2627-Contract-Provider-10010062-4_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


     #Bulk import to add STFI

 # Bulk amend the ASF2023 alloc 25/26 contract and check v3 docs

 Given the override date is '20/07/2026'

 # Bulk file 'Amend Vary' 
 And   there are no files prefixed '10010062' in the Sharepoint 'AEB2023-2627-Input-Appendices' folder
 And   there are no files prefixed 'AEB2023 AY 2627 03082024112659 v3_Ak062' in the Sharepoint 'Input' folder
 And   there are no files prefixed 'AEB2023 AY 2627 03082024112659 v3_Ak062' in the Sharepoint 'Processing' folder
 And   there are no files prefixed 'AEB2023 AY 2627 03082024112659 v3_Ak062' in the Sharepoint 'Processed' folder
 And   there are no files prefixed 'AEB2023 AY 2627 03082024112659 v3_Ak062' in the Sharepoint 'Reports' folder
 And   spreadsheet 'AEB2023 AY 2627 03082024112659 v3_Ak062.xlsx' exists in the Datafiles folder and UKPRN '10010062' is present in cell 'A2' of the Contract tab
#When  the file is copied to the Sharepoint 'Input' folder 
 When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
 Then  a syntax report showing file success should exist in the Sharepoint Reports folder
 And   the syntax report includes the phrase 'Success'
 And   a results report should exist in the Sharepoint Reports folder
 And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


 # Retrieve parameters
 When  I retrieve the latest contract details from CRM for provider '10010062' for FundingType 'AEB2023' and period '2627'

 
 # Insert/Update details into the ContractManagement.CreatedContract table (J104)
 #   Note: Documents are created using the system date. The following step 'corrects' this
 Given the following document creation details exist in the ContractManagement.CreatedContract table
 | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
 | [ContractNo]   | 2                    | 0                        | 2022-09-15 12:06:22.000 |

 # Copy\Save a named Sharepoint file to a named folder\filename
 And   Sharepoint file '10010062_[ContractNo]_v3.pdf' in 'AEB2023-2627-Input-Appendices' is copied to 'Datafiles/Downloads' as 'Ak062_v3.pdf'

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
    | 10010062 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2026        | 31/07/2027      | Variation     |
	| 10010062 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2026        | 31/07/2027      | Variation     |
    | 10010062 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2026        | 31/07/2027      | ?             |
    | 10010062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2026        | 31/07/2027      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 3                     | 0                        | 2026-07-20 09:12:35.000 |






        # Part 5: Add Actuals for 24/25 then check CRM

    # Add actuals to the contract for ASF2023-AS2627, ASF2023-FCFJ2627 

    # Change the date
    Given the override date is '04/10/2026'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0010062'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber   | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 656.38      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 514.81      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 564.11      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1411.24     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 478.56      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1469.21     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1163.17     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 2352.37     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 465.26      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 2003.87     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 699.93      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 844.84      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1604.57     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-AS2627          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 860.77      |
 #
 #   #                                                                                                            
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1951.00     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 627.27      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1274.11     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1790.98     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 615.15      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1977.70     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1956.70     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 804.17      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 855.21      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 631.06      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 938.44      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 995.84      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1931.92     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-FCFJ2627         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 2158.27     |


    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-STFI2627         | [AllocRef_STFI23]           | ?          | 1               | 0            | 1951.00     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-STFI2627         | [AllocRef_STFI23]           | ?          | 5               | 0            | 627.27      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | ASF2023-STFI2627         | [AllocRef_STFI23]           | ?          | 6               | 0            | 1274.11     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-STFI2627         | [AllocRef_STFI23]           | ?          | 1              | 0            | 1790.98     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-STFI2627         | [AllocRef_STFI23]           | ?          | 5              | 0            | 615.15      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | ASF2023-STFI2627         | [AllocRef_STFI23]           | ?          | 6              | 0            | 1977.70     |

    Then wait '30' seconds


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then wait '30' seconds


 #
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef | DeliverableCode | Total     | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
    | [ContractNo]   | [AllocRef_ASFJ23]| 1             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFJ23]| 2             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFJ23]| 3             | 2755.17   | 1951.00  | 804.17   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFJ23]| 4             | 1482.48   | 627.27   | 855.21   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFJ23]| 5             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFJ23]| 6             | 1905.17   | 1274.11  | 631.06   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFJ23]| 7             | 2729.42   | 1790.98  | 938.44   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFJ23]| 8             | 1610.99   | 615.15   | 995.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFJ23]| 9             | 3909.62   | 1977.70  | 1931.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFJ23]| 10            | 4114.97   | 1956.70  | 2158.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | [ContractNo]   | [AllocRef_ASFA23]| 1             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFA23]| 2             | 3008.75   | 656.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFA23]| 3             | 980.07    | 514.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFA23]| 4             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFA23]| 5             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFA23]| 6             | 2567.98   | 564.11   | 2003.87  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFA23]| 7             | 2111.17   | 1411.24  | 699.93   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFA23]| 8             | 1323.40   | 478.56   | 844.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFA23]| 9             | 3073.78   | 1469.21  | 1604.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ASFA23]| 10            | 2023.94   | 1163.17  | 860.77   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	#
 #   | [ContractNo]   | [ASF2023-STFI2627]| 1             | 3741.98   | 1951.00  |  1790.98   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [ASF2023-STFI2627]| 5             | 1242.42   | 627.27   |  615.15    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [ASF2023-STFI2627]| 6             | 3251.81   | 1274.11  |  1977.70   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #



    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
    | [ContractNo]   | [AllocRef_ASFJ23]  | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFJ23]  | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFJ23]  | 3               | 2755.17   | 0.00     | 2755.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFJ23]  | 4               | 1482.48   | 0.00     | 1482.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFJ23]  | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFJ23]  | 6               | 1905.17   | 0.00     | 1905.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFJ23]  | 7               | 2729.42   | 0.00     | 2729.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFJ23]  | 8               | 1610.99   | 0.00     | 1610.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFJ23]  | 9               | 3909.62   | 0.00     | 3909.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFJ23]  | 10              | 4114.97   | 0.00     | 4114.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_ASFA23]  | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 2               | 3008.75   | 0.00     | 3008.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 3               | 980.07    | 0.00     | 980.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 6               | 2567.98   | 0.00     | 2567.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 7               | 2111.17   | 0.00     | 2111.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 8               | 1323.40   | 0.00     | 1323.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 9               | 3073.78   | 0.00     | 3073.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 10              | 2023.94   | 0.00     | 2023.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
#    | [ContractNo]   | [ASF2023-STFI2627]| 3             | 2755.17   | 1951.00  | 804.17   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [ASF2023-STFI2627]| 4             | 1482.48   | 627.27   | 855.21   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [ASF2023-STFI2627]| 6             | 1905.17   | 1274.11  | 631.06   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
# 
#





    
    # Payment Batch for ASFC-ASCL2526(PoA)

    # Change the date
    Given the override date is '08/10/2026 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASF2023-AS2627' AccountingPaymentPeriod '202606' CensusEndDate '08/10/2026' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ASFA23]          | 202609 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASF2023-AS2627             | 202609               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ASF2023-AS2627             | 202609               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ASF2023-AS2627' PaymentPeriod '202606' CensusEndDate '08/10/2026' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK062_ASFA.xml'
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
    Given the override date is '08/10/2026 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASF2023-FCFJ2627' AccountingPaymentPeriod '202606' CensusEndDate '08/10/2026' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ASFJ23]          | 202609 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASF2023-FCFJ2627           | 202609               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ASF2023-FCFJ2627           | 202609               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ASF2023-FCFJ2627' PaymentPeriod '202606' CensusEndDate '08/10/2026' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK062_ASFJ.xml'
#



 # Payment Batch for ASFC-STFI(PoA)

    # Change the date
    Given the override date is '08/10/2026 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASF2023-STFI2627' AccountingPaymentPeriod '202606' CensusEndDate '08/10/2026' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ASFS23]          | 202609 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASF2023-STFI2627           | 202609               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ASF2023-STFI2627           | 202609               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ASF2023-STFI2627' PaymentPeriod '202606' CensusEndDate '08/10/2026' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK062_STFI.xml'
#


    # Change the date
    Given the override date is '09/10/2026 09:05'
    
   #  Part 10: Create Consolidated Payment Summary rpt
   
   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
   Given there are no files prefixed '2026-10 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder

   When  a Consolidated Payment Summary Report is created in Sharepoint for '09/10/2026'

    # Check the above report manually





    # Part 6: Create and check the contents of the CDA report
   
    # Change the date
    Given the override date is '11/10/2026'
    
    # Check the contents of the CDA report
    And   there is no CDA report named 'CDA Last Approved Version S058.csv'

    And   the following ADF Pipeline run

    #And   the following contracts are in the replicated CRM database
    #| ContractNumber  | ContractVersionNumber |
    #| [ContractNo]    | 3                     |

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod	| Version               | Suffix |
    | ASF2023-AS2627              | Last Approved         | AK062   |
    | ASF2023-FCFJ2627              | Last Approved         | Ak062   |

    Then  a report named 'CDA Last Approved Version AK062.csv' is created

    # Check the contents of the CDA Report manually



    # Tidy Up
    Given the override date is reset


