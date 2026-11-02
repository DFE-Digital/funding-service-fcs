Feature: AdultFundingContract
 @AcceptanceTest @Complete
@Long2Run @Long2Run67
    Scenario: AK031 Import and release a ASF2023-AS2425 and ASF2023-FCFJ2425 FA. Approve. Check docs, CRM and feed. Amend and repeat
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10010031'
    And   there is no Funding Allocation data in CRM for UKPRN '10010031'
    And   there is no Contract, Task or Workflow data for UKPRN '10010031'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10010031'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010031'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10010031' in the Sharepoint 'AEB2023-2425-Input-Appendices' folder

    # Clear down the Cfs stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | AEB2023         | AY2425        | ASF2023_2425 | Contract for Services                    |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
	
	And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASF2023-AS2425     |
    | ASF2023-FCFJ2425     |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010031' 
    And   there is no caseload advisor for UKPRN '10010031' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010031 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010031' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010031 Co Ltd' with UKPRN '10010031' and OrgId 'ORG0010031' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010031 | 110031 | 10010031 Co Ltd | 0              | Active                | Yes           | AA010031      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010031 |







    # Populate the stub with ASF data

   # Change the date 
   Given the override date is '01/07/2024'

   # Clear down the Cfs stub
   And   there is no data in the CFS stub

   # Funding Allocation 
   And   the following Funding Allocation data is in the CFS stub
   | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
   | Contracting    | 10010031 | AEB2023-AY-2425-Contract-Provider-10010031-3_5        | 3_5            | ASFC                        | AY-2425            | 13500.00          |

   # Provider Funding Allocation
   And   the following Provider Funding Agreement data is present in the CFS stub
   | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType             | ProviderFundingTotalValue |
   | AEB2023-AY-2425-10010031-3_5  | 3_5                 | AEB2023-AY-2425-Contract-Provider-10010031-3_5        | 10010031      | Furth     | 07HEP           | 13500.00                  |

   # Funding Allocation Line (aka Deliverable)
   And   the following Funding Allocation Line data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
   | AEB2023-AY-2425-10010031-3_5   | ASF-005         | 1000.00		  | Payment         |
   | AEB2023-AY-2425-10010031-3_5   | ASF-006         | 3680.00        | Payment         |
   | AEB2023-AY-2425-10010031-3_5   | ASF-007         | 6320.00        | Payment         |
   | AEB2023-AY-2425-10010031-3_5   | ASF-008         | 2500.00        | Payment         |


   # Funding Allocation Profile Period
   And   the following Funding Allocation Profile Period data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
   | AEB2023-AY-2425-10010031-3_5   | ASF-005         | FY-2425              | September            | 2024              | 1000.00                    |
   | AEB2023-AY-2425-10010031-3_5   | ASF-006         | FY-2425              | April	               | 2025              | 3680.00                    |
   | AEB2023-AY-2425-10010031-3_5   | ASF-007         | FY-2425              | November             | 2024              | 6320.00                    |
   | AEB2023-AY-2425-10010031-3_5   | ASF-008         | FY-2425              | December	           | 2024              | 2500.00                    |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2425        | ASF2023_2425     | Contract for Services      | Cfs                       |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10010031 | 10010031 Co Ltd  | AEB2023-AY-2425-Contract-Provider-10010031-3_5             | 3_5         | Adult Education Budget - 2023 Procurement | AY2425  | Contract for Services       | ASFC                        | ASF2023_2425        | Scheduling        | Awaiting Release  | 13500.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2425-Contract-Provider-10010031-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 13500.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010031 | AEB2023-AY-2425-Contract-Provider-10010031-3_5          | 3_5            | AY-2425 | ASFC                        | 13500.00     | [Cfs]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

        # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

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
    | Released          | 1               | 13500.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10010031' for FundingType 'AEB2023' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10010031' for FundingType 'AEB2023' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010031 | 10010031 Co Ltd  | AEB2023-AY-2425-Contract-Provider-10010031-3_5             | 3_5            | Adult Education Budget - 2023 Procurement     | AY2425  | Contract for Services                     | ASFC                        | ASF2023_2425        | Released          | Released          | 13500.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [Cfs]           | ?          | ?                   |




    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2425-Contract-Provider-10010031-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | AEB2023-AY-2425-Contract-Provider-10010031-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010031 | AEB2023-AY-2425-Contract-Provider-10010031-3_5             | 3_5            | AY-2425 | ASFC                        | 13500.00     | [Cfs]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | AEB2023-AY-2425-Contract-Provider-10010031-3_5             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010031 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10010031 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10010031 | [ContractNo]       | Adult Education Budget - 2023 Procurement                 | Contract      | Draft          | Awaiting Documentation  | 13500.00       | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Contract for Services                      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10010031 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10010031 | [MasterContractNo] | Adult Education Budget - 2023 Procurement                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Contract for Services                      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10010031 Co Ltd  | Active | CRM Integration           | ?                      |


     # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10010031 | [ContractNo]       | [AllocRef_ASCA]       | ?                             | 11000.00        | 10010031      | 10010031 Co Ltd  | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
#    | 10010031 | [ContractNo]       | [AllocRef_ASFC]       | ?                             | 2500.00         | 10010031      | 10010031 Co Ltd  | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
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
    Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

     #Check the contents of the Appendices
#    And   the file named '10010026_[ContractNo]_v1.pdf' in Sharepoint location 'ASFG-2425-Input-Appendices' contains the following lines in order
#    """
#
#    SUMMARY OF FUNDING
#    Organisation Name: 10010031 Co Ltd UKPRN: 10010031
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
#    And 10010031 Co Ltd
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
#    10010031 Co Ltd THE SECRETARY OF STATE FOR
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
#    Provider: 10010031 Co Ltd UKPRN: 10010031
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
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
    And   Sharepoint file '10010031_[ContractNo]_v1.pdf' in 'AEB2023-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010031_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10010031'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10010031 - 10010031 Co Ltd Awaiting documentation  | [AllocRef_ASFC] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10010031 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10010031 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10010031 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10010031_[ContractNo]_v1.pdf' is created in 'AEB2023-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010031 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10010031 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |





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
    | 10010031 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10010031 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010031 | 10010031 Co Ltd  | AEB2023-AY-2425-Contract-Provider-10010031-3_5          | 3_5            | Adult Education Budget - 2023 Procurement     | AY2425  | Contract for Services                     | ASFC                        | ASF2023_2425        | Contract Approved | Contract Approved | 13500.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [Cfs]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010031 | AEB2023-AY-2425-Contract-Provider-10010031-3_5             | 3_5            | AY-2425 | ASFC                        | 13500.00     | [Cfs]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2425-Contract-Provider-10010031-3_5             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    #Then  the Legal Contract CM feed contains the following '4' deliverables
    #| UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    #| 10010031 | [ContractNo]   | 1               | [AllocRef_ASCA]  | 5               | 1                     | 3680.00       | 0             | 0        | Tailored Learning                                  | ?                           |
    #| 10010031 | [ContractNo]   | 1               |  [AllocRef_ASCA] | 2               | 1                     |  1000.00      | 0             | 0        |  Adult Skills Total Funding                        | ?                           |
    #| 10010031 | [ContractNo]   | 1               |  [AllocRef_ASCA] | 12              | 1                     |  6320.00      | 0             | 0        |  Funding for Innovative Provision                  | ?                           |
    #| 10010031 | [ContractNo]   | 1               |  [AllocRef_ASFC] | 2               | 1                     |  2500.00      | 0             | 0        |  Funding for Innovative Provision                  | ?                           |

   
     # Amend contract

    # Change the date
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10010031 | AEB2023-AY-2425-Contract-Provider-10010031-4_7           | 4_7            | ASFC                        | AY-2425            | 16882.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | AEB2023-AY-2425-10010031-4_7  | 4_7                    | AEB2023-AY-2425-Contract-Provider-10010031-4_7           | 10010031      | Furth     | 07HEP| 16882.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | AEB2023-AY-2425-10010031-4_7   | ASF-005       | 3172.00		  | Payment         |
    | AEB2023-AY-2425-10010031-4_7   | ASF-006       | 4892.00          | Payment         |
    | AEB2023-AY-2425-10010031-4_7   | ASF-007       | 5859.00          | Payment         |
    | AEB2023-AY-2425-10010031-4_7   | ASF-008       | 2959.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | AEB2023-AY-2425-10010031-4_7  | ASF-005        | FY-2425              | September            | 2024              | 3172.00                   |
    | AEB2023-AY-2425-10010031-4_7  | ASF-006        | FY-2425              | April	               | 2025              | 4892.00                   |
    | AEB2023-AY-2425-10010031-4_7  | ASF-007        | FY-2425              | November             | 2024              | 5859.00                   |
    | AEB2023-AY-2425-10010031-4_7  | ASF-008        | FY-2425              | December	           | 2024              | 2959.00                   |
 
     # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2425        | ASF2023_2425      | Contract for Services                   | Cfs                       |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window
	
	
	

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10010031 | 10010031 Co Ltd  | AEB2023-AY-2425-Contract-Provider-10010031-4_7          | 4_7            |Adult Education Budget - 2023 Procurement  | AY2425  | Contract for Services       | ASFC                        | ASF2023_2425        | Scheduling        | Awaiting Release  | 16882.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs]            | ?          | ?                   |

    
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2425-Contract-Provider-10010031-4_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 16882.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010031 | AEB2023-AY-2425-Contract-Provider-10010031-4_7             | 4_7            | AY-2425 | ASFC                        | 16882.00    | [Cfs]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '19/07/2024'

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
    When  I retrieve the latest contract details from CRM for provider '10010031' for FundingType 'AEB2023' and period '2425'

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010031 | 10010031 Co Ltd  | AEB2023-AY-2425-Contract-Provider-10010031-4_7             | 4_7            | Adult Education Budget - 2023 Procurement | AY2425  | Contract for Services    | ASFC                        | ASF2023_2425        | Released          | Released          | 16882.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [Cfs]          | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2425-Contract-Provider-10010031-4_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | AEB2023-AY-2425-Contract-Provider-10010031-4_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010031 | AEB2023-AY-2425-Contract-Provider-10010031-4_7             | 4_7            | AY-2425 | ASFC                        | 16882.00    | [Cfs]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | AEB2023-AY-2425-Contract-Provider-10010031-4_7             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010031 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | Variation     |
    | 10010031 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10010031 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10010031 | [ContractNo]       | Adult Education Budget - 2023 Procurement                 | Contract      | Draft          | Awaiting Documentation  | 16882.00      | 2                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?         | Contract for Services        | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | [ContractNo]    | 10010031 Co Ltd  | Active | Document Management Team  | 3382.00               |
    | 10010031 | [MasterContractNo] | Adult Education Budget - 2023 Procurement                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?         | Contract for Services        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10010031 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    #And   the following Contract Allocations exist in CRM
    #| UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    #| 10010031 | [ContractNo]       | [AllocRef_ASCA]       | ?                             | 13923.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | 2923.00                 |
    #| 10010031 | [ContractNo]       | [AllocRef_ASFC]       | ?                             | 2959.00        | ?             | ?                | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | 459.00                 |

## Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    #And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    #| ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableName                  | DeliverableDescription   |
#    #| [ContractNo]   | [AllocRef_ASCA] | 5               | 4892.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |
#    #| [ContractNo]   | [AllocRef_ASCA] | 2               | 3172.00   | 0.00     | 3172.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |
#    #| [ContractNo]   | [AllocRef_ASCA] | 12              | 5859.00   | 0.00     | 0.00     | 0.00     | 5859.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |
#    #| [ContractNo]   | [AllocRef_ASFC] | 2               | 2959.00   | 0.00     | 0.00     | 0.00     | 0.00     | 2959.00  | 0.00     | 0.00     | 0.00     | 4892.00  | 0.00     | 0.00     | 0.00     | Tailored Learning                |                          |



    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


 
    #Check the contents of the Appendices  (SoF and FA)
    #And   the file named '10010026_[ContractNo]_v2.pdf' in Sharepoint location 'ASFG-2425-Input-Appendices' contains the following lines in order
    #"""
    #SUMMARY OF FUNDING
    #Organisation Name: 10010031 Co Ltd UKPRN: 10010031
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
    #Provider: 10010031 Co Ltd UKPRN: 10010031
    #Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    #Contract Ref: [AllocRef_ASFG]
    #Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    #Dance and Drama Awards (ASFG) £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Total Funding £22,415 £3,172 £0 £0 £0 £4,892 £0 £0 £5,859 £0 £2,959 £5,533 £0
    #Schedule 2 – Funding Agreement [AllocRef_ASFG] – Page 1 Ref (for internal use only):  [ContractNo] v2
    #"""

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010031_[ContractNo]_v2.pdf' in 'AEB2023-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010031_[ContractNo]_v2.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2024-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10010031'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10010031 - 10010031 Co Ltd Awaiting documentation  | [AllocRef_ASFA23] | Document Management Team  | ?                | Open       | Not Started   |
    | Initiate Document Merge   | 10010031 - 10010031 Co Ltd Awaiting documentation  | [AllocRef_ASFJ23] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '2' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10010031 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10010031 | [MasterContractNo] | [ContractNo]   | 2                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10010031 | [MasterContractNo] | [ContractNo]   | 2                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |


   # Publish the contract

    # Change the date 
    Given the override date is '20/07/2024'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10010031_[ContractNo]_v2.pdf' is created in 'AEB2023-2425-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010031 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | Variation     |
    | 10010031 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | False         | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10010031 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |


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
    | 10010031 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | Variation     |
    | 10010031 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10010031 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010031 | 10010031 Co Ltd  | AEB2023-AY-2425-Contract-Provider-10010031-4_7             | 4_7            | Adult Education Budget - 2023 Procurement | AY2425  |  Contract for Services      | ASFC                        | ASF2023_2425        | Contract Approved | Contract Approved | 16882.00    | [ContractNo]  | 2                 | CRM Integration       | CRM Integration           | ?                         | [Cfs]          | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010031 | AEB2023-AY-2425-Contract-Provider-10010031-4_7             | 4_7            | AY-2425 | ASFC                        | 16882.00    | [Cfs]          | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2425-Contract-Provider-10010031-4_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed




        # Part 5: Add Actuals for 24/25 then check CRM

    # Add actuals to the contract for ASF2023-AS2425, ASF2023-FCFJ2425 

    # Change the date
    Given the override date is '04/10/2024'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0010031'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber   | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 656.38      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 564.11      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1411.24     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 478.56      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1469.21     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1163.17     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 2352.37     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 465.26      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 2003.87     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 699.93      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 844.84      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1604.57     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 860.77      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 2029.73     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 1578.92     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 456.94      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1664.81     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 1759.15     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 691.06      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 2444.27     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 2456.58     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 647.63      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 759.23      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 2063.91     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 450.22      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1934.00     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1123.20     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 1427.78     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 1516.24     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 1788.03     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1329.88     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 2026.43     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 789.27      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1287.03     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 903.61      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 1218.05     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 1600.94     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 2117.38     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 1741.50     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1842.61     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1337.66     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 701.10      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 533.70      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 1360.83     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 923.42      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 1747.44     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 608.77      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 418.35      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 2227.66     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 829.39      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 1203.95     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1434.69     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 1798.00     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1085.30     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1960.48     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 1417.38     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 1918.11     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 1045.39     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1643.91     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 2101.00     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1190.52     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1883.35     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 1589.44     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 1711.23     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 2444.42     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 492.88      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 1272.18     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1953.95     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 2268.45     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 1989.29     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 702.52      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 829.25      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 2068.54     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 1235.99     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1246.41     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 670.54      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 750.74      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 596.14      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 670.68      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 2008.59     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 529.00      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 909.14      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-AS2425          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1313.35     |
    #                                                                                                            
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1951.00     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 627.27      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1274.11     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1790.98     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 615.15      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1977.70     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202408 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1956.70     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 804.17      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 855.21      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 631.06      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 938.44      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 995.84      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1931.92     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202409 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 2158.27     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1047.32     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 1860.24     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1778.15     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1313.84     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 560.35      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1744.40     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202410 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1768.41     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1027.36     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 979.42      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 420.79      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 850.88      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 407.36      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 469.54      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202411 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 2122.51     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1242.00     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 1707.76     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 709.66      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 540.85      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 1633.41     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1106.69     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202412 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1255.89     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1285.57     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 1961.54     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 2148.01     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1767.36     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 407.44      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1239.62     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202501 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1895.13     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 994.41      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 2233.51     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1402.23     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1597.45     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 1779.48     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 664.64      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202502 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 512.30      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1169.29     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 1720.29     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1635.78     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1230.69     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 1531.22     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 945.68      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202503 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1638.53     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1248.17     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 1864.06     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1103.86     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1856.37     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 829.96      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1025.21     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202504 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1113.23     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 562.25      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 1572.82     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1277.62     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 775.62      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 778.81      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1924.50     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202505 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1381.12     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1152.10     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 1750.97     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 565.78      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1246.40     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 1701.23     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1981.15     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202506 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 2105.12     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1501.39     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 1579.87     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 876.86      |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1035.48     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 1670.15     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1406.46     |
    | ILR2425        | R02                  | ORG0010031     | CM             | 202507 | ASF2023-FCFJ2425         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 860.95      |


    Then wait '30' seconds


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then wait '30' seconds


 
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
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
	



    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
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
     | [ContractNo]  | [AllocRef_ASFA23]  | 3               | 980.07    | 0.00     | 980.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 6               | 2567.98   | 0.00     | 2567.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 7               | 2111.17   | 0.00     | 2111.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 8               | 1323.40   | 0.00     | 1323.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 9               | 3073.78   | 0.00     | 3073.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ASFA23]  | 10              | 2023.94   | 0.00     | 2023.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #



 # Part 8: CDA
    
     

    # Run the CDA report
    Given there is no CDA report named 'CDA Last Approved Version AK031.csv'
    And   the following ADF Pipeline run


    And   the following contracts are in the replicated CRM database
    | ContractNumber | ContractVersionNumber |
    | [ContractNo]   | 2                     |

    When  the following CDA report is run
    | FundingStreamPeriod   | Version              | Suffix  |
    | ASF2023-AS2425         | Last Approved Version | AK031   |
    | ASF2023-FCFJ2425         | Last Approved Version | AK031   |


    Then  a report named 'CDA Last Approved Version AK031.csv' is created

    # Check the contents of the CDA Report manually
 
  
   
 
 @AcceptanceTest @Complete
@Long2Run @Long2Run67
    Scenario: AK032 Import and release a ASF2023-AS2425 and ASF2023-FCFJ2425 FA. Approve. Check docs, CRM and feed. Amend and repeat
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10010032'
    And   there is no Funding Allocation data in CRM for UKPRN '10010032'
    And   there is no Contract, Task or Workflow data for UKPRN '10010032'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10010032'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010032'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10010032' in the Sharepoint 'AEB2023-2425-Input-Appendices' folder

    # Clear down the Cfs stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | AEB2023         | AY2425        | ASF2023_2425 | Contract for Services                    |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
	
	And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASF2023-AS2425     |
    | ASF2023-FCFJ2425     |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010032' 
    And   there is no caseload advisor for UKPRN '10010032' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010032 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010032' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010032 Co Ltd' with UKPRN '10010032' and OrgId 'ORG0010032' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010032 | 110032 | 10010032 Co Ltd | 0              | Active                | Yes           | AA010032      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010032 |







    # Populate the stub with ASF data

   # Change the date 
   Given the override date is '01/07/2024'

   # Clear down the Cfs stub
   And   there is no data in the CFS stub

   # Funding Allocation 
   And   the following Funding Allocation data is in the CFS stub
   | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
   | Contracting    | 10010032 | AEB2023-AY-2425-Contract-Provider-10010032-3_5        | 3_5            | ASFC                        | AY-2425            | 2000.00          |

   # Provider Funding Allocation
   And   the following Provider Funding Agreement data is present in the CFS stub
   | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType             | ProviderFundingTotalValue |
   | AEB2023-AY-2425-10010032-3_5  | 3_5                 | AEB2023-AY-2425-Contract-Provider-10010032-3_5        | 10010032      | Furth     | 07HEP           | 2000.00                  |

   # Funding Allocation Line (aka Deliverable)
   And   the following Funding Allocation Line data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
   | AEB2023-AY-2425-10010032-3_5   | ASF-005         | 1000.00		 | Payment         |
   | AEB2023-AY-2425-10010032-3_5   | ASF-006         | 1000.00      | Payment         |
   | AEB2023-AY-2425-10010032-3_5   | ASF-007         |   null        | Payment         |
   | AEB2023-AY-2425-10010032-3_5   | ASF-008         |    null         | Payment         |


   # Funding Allocation Profile Period
   And   the following Funding Allocation Profile Period data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
   | AEB2023-AY-2425-10010032-3_5   | ASF-005         | FY-2425              | September            | 2024              | 1000.00                    |
   | AEB2023-AY-2425-10010032-3_5   | ASF-006         | FY-2425              | April	            | 2025              |1000.00                    |
   | AEB2023-AY-2425-10010032-3_5   | ASF-007         | FY-2425              | November             | 2024              | null                      |
   | AEB2023-AY-2425-10010032-3_5   | ASF-008         | FY-2425              | December	            | 2024              |  null                     |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2425        | ASF2023_2425     | Contract for Services      | Cfs                       |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10010032 | 10010032 Co Ltd  | AEB2023-AY-2425-Contract-Provider-10010032-3_5             | 3_5         | Adult Education Budget - 2023 Procurement | AY2425  | Contract for Services       | ASFC                        | ASF2023_2425        | Scheduling        | Awaiting Release  | 2000.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2425-Contract-Provider-10010032-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 2000.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010032 | AEB2023-AY-2425-Contract-Provider-10010032-3_5          | 3_5            | AY-2425 | ASFC                        | 2000.00     | [Cfs]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'



     # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

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
    | Released          | 1               | 2000.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10010032' for FundingType 'AEB2023' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10010032' for FundingType 'AEB2023' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010032 | 10010032 Co Ltd  | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | 4_7            | Adult Education Budget - 2023 Procurement     | AY2425  | Contract for Services                     | ASFC                        | ASF2023_2425        | Released          | Released          | 2000.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [Cfs]           | ?          | ?                   |




    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010032 | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | 4_7            | AY-2425 | ASFC                        | 2000.00     | [Cfs]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010032 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10010032 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10010032 | [ContractNo]       | Adult Education Budget - 2023 Procurement                 | Contract      | Draft          | Awaiting Documentation  | 2000.00       | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Contract for Services                      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10010032 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10010032 | [MasterContractNo] | Adult Education Budget - 2023 Procurement                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Contract for Services                      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10010032 Co Ltd  | Active | CRM Integration           | ?                      |


     # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10010032 | [ContractNo]       | [AllocRef_ASCA]       | ?                             | 11000.00        | 10010032      | 10010032 Co Ltd  | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
#    | 10010032 | [ContractNo]       | [AllocRef_ASFC]       | ?                             | 2500.00         | 10010032      | 10010032 Co Ltd  | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
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



           
        # Populate the stub with ASF data

   # Change the date 
   Given the override date is '01/07/2024'

   # Clear down the Cfs stub
   And   there is no data in the CFS stub

   # Funding Allocation 
   And   the following Funding Allocation data is in the CFS stub
   | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
   | Contracting    | 10010032 | AEB2023-AY-2425-Contract-Provider-10010032-4_7        | 4_7            | ASFC                        | AY-2425            | 2000.00          |

   # Provider Funding Allocation
   And   the following Provider Funding Agreement data is present in the CFS stub
   | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType             | ProviderFundingTotalValue |
   | AEB2023-AY-2425-10010032-4_7  | 4_7                 | AEB2023-AY-2425-Contract-Provider-10010032-4_7       | 10010032      | Furth     | 07HEP           | 2000.00                  |

   # Funding Allocation Line (aka Deliverable)
   And   the following Funding Allocation Line data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
   | AEB2023-AY-2425-10010032-4_7   | ASF-005         | 1000.00		 | Payment         |
   | AEB2023-AY-2425-10010032-4_7   | ASF-006         | 1000.00      | Payment         |
   | AEB2023-AY-2425-10010032-4_7   | ASF-007         |    0.00          | Payment         |
   | AEB2023-AY-2425-10010032-4_7   | ASF-008         |    0.00         | Payment         |


   # Funding Allocation Profile Period
   And   the following Funding Allocation Profile Period data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
   | AEB2023-AY-2425-10010032-4_7   | ASF-005         | FY-2425              | September            | 2024              | 1000.00                    |
   | AEB2023-AY-2425-10010032-4_7   | ASF-006         | FY-2425              | April	            | 2025              | 1000.00                    |
   | AEB2023-AY-2425-10010032-4_7   | ASF-007         | FY-2425              | November             | 2024              | 0.00                      |
   | AEB2023-AY-2425-10010032-4_7   | ASF-008         | FY-2425              | December	            | 2024              |  0.00                     |

# Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2425        | ASF2023_2425     | Contract for Services      | Cfs                       |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10010032 | 10010032 Co Ltd  | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | 4_7         | Adult Education Budget - 2023 Procurement | AY2425  | Contract for Services       | ASFC                        | ASF2023_2425        | Scheduling        | Awaiting Release  | 2000.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 2000.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010032 | AEB2023-AY-2425-Contract-Provider-10010032-4_7          | 4_7            | AY-2425 | ASFC                        | 2000.00     | [Cfs]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'










            # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2024'

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
    | Released          | 1               | 2000.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10010032' for FundingType 'AEB2023' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10010032' for FundingType 'AEB2023' and period '2425' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010032 | 10010032 Co Ltd  | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | 4_7            | Adult Education Budget - 2023 Procurement     | AY2425  | Contract for Services                     | ASFC                        | ASF2023_2425        | Released          | Released          | 2000.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [Cfs]           | ?          | ?                   |




    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010032 | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | 4_7            | AY-2425 | ASFC                        | 2000.00     | [Cfs]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | AEB2023-AY-2425-Contract-Provider-10010032-4_7             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010032 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10010032 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10010032 | [ContractNo]       | Adult Education Budget - 2023 Procurement                 | Contract      | Draft          | Awaiting Documentation  | 2000.00       | 1                     | 0                        | 01/08/2024        | 31/07/2025      | True          | False               | ?             | Contract for Services                      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10010032 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10010032 | [MasterContractNo] | Adult Education Budget - 2023 Procurement                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2024        | 31/07/2025      | False         | False               | ?             | Contract for Services                      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10010032 Co Ltd  | Active | CRM Integration           | ?                      |


     # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10010032 | [ContractNo]       | [AllocRef_ASCA]       | ?                             | 11000.00        | 10010032      | 10010032 Co Ltd  | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
#    | 10010032 | [ContractNo]       | [AllocRef_ASFC]       | ?                             | 2500.00         | 10010032      | 10010032 Co Ltd  | 01/08/2024 | 31/07/2025 | ASFG          | ASFG2425            | Contract Allocation   | ?                        |
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
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
    
   
  