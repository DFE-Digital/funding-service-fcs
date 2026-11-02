Feature: ZeroValueFundingAllocs 34861

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A861 Import and release a zero-value 1619 FA to create an EDSK2122 contract with zero value.
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017861'
    And   there is no Funding Allocation data in CRM for UKPRN '10017861'
    And   there is no Contract, Task or Workflow data for UKPRN '10017861'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017861'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017861'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017861' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017861' 
    And   there is no caseload advisor for UKPRN '10017861' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017861 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017861' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017861 Co Ltd' with UKPRN '10017861' and OrgId 'ORG0017861' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017861 | 117861 | 10017861 Co Ltd | 0              | Locked Restructure    | Yes           | AA017861      | ?             | 26 London Road         | ?                      | ?                      | ?                      | St. Albans.            | Hertfordshire          | AL1 1NG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017861 |







    # Populate the stub with 1619 (01GFE) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017861 | 1619-AS-2122-Contract-Provider-10017861-1_6           | 1_6            | 1619                        | AS-2122            | 0.00              |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017861-1_6  | 1_6                    | 1619-AS-2122-Contract-Provider-10017861-1_6           | 10017861      | Furth        | 01GFE           | 0.00                      |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017861-1_6  | 1619-004        | 0.00             | Payment         |
    | 1619-AS-2122-10017861-1_6  | 1619-010        | 0.00             | Payment         |
    | 1619-AS-2122-10017861-1_6  | 1619-020        | 0.00             | Payment         |
    | 1619-AS-2122-10017861-1_6  | 1619-024        | 0.00             | Payment         |
    | 1619-AS-2122-10017861-1_6  | 1619-025        | 0.00             | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017861-1_6  | 1619-004        | FY-2122              | August                 | 2021              | 0.00                      |
    | 1619-AS-2122-10017861-1_6  | 1619-010        | FY-2122              | January                | 2022              | 0.00                      |
    | 1619-AS-2122-10017861-1_6  | 1619-020        | FY-2122              | March                  | 2022              | 0.00                      |
    | 1619-AS-2122-10017861-1_6  | 1619-024        | FY-2122              | June                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017861-1_6  | 1619-025        | FY-2122              | February               | 2022              | 0.00                      |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017861 | 10017861 Co Ltd  | 1619-AS-2122-Contract-Provider-10017861-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 0.00        | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017861-1_6             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 0.00            |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017861 | 1619-AS-2122-Contract-Provider-10017861-1_6             | 1_6            | AS-2122 | 1619                        | 0.00        | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

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
    | Released          | 1               | 0.00            |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017861' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017861' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017861 | 10017861 Co Ltd  | 1619-AS-2122-Contract-Provider-10017861-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 0.00        | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017861-1_6             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017861-1_6             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017861 | 1619-AS-2122-Contract-Provider-10017861-1_6             | 1_6            | AS-2122 | 1619                        | 0.00        | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017861-1_6             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017861 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017861 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017861 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017861 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017861 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017861 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation | 
    | 10017861 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 0.00            | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 85              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Residential Support Scheme                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 52              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 149             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses School and College Leavers Uplift  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 143             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Tuition Fund                                          |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017861_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017861 Co Ltd UKPRN: 10017861
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £0 £0 £0
    Total Funding for this contract: £0
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017861 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE COLLEGE
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE COLLEGE REPRESENTS AND WARRANTS THAT THE COLLEGE HAS READ
    AND UNDERSTOOD THIS AGREEMENT, THE COLLEGE AGREES TO BE BOUND
    BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO ACCEPT
    THIS AGREEMENT AND LEGALLY BIND THE COLLEGE.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    acting through the Education and Skills Funding Agency
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 2 (July 2021) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017861 Co Ltd THE SECRETARY OF STATE FOR
    26 London Road EDUCATION ACTING THROUGH
    St. Albans. THE EDUCATION AND SKILLS
    Hertfordshire FUNDING AGENCY, AN
    AL1 1NG EXECUTIVE AGENCY OF THE
    AND
    DEPARTMENT OF EDUCATION
    CHEYLESMORE HOUSE
    Company No: AA017861 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 2 (July 2021) Page 2
    EDSK Version 2 (July 2021) Page 78
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 11
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017861 Co Ltd UKPRN: 10017861
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Residential Support Scheme £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Alternative Completions - Sea Fishing £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Teacher's Pension Scheme 1619 £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16-19 High Value Courses School and College £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Leavers Uplift
    16-19 Tuition Fund £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017861_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A861.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |

    # Tidy Up
    Given the override date is reset
       
@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A211 Import and discard 1619 FAs of no interest. Check PaaS and the P&D report

    # 1. Import 1619 FA v1.1 with £value Funding Lines > Discarded\Superseded, and v1.2 with £0 Funding Lines > Discarded\NonMaterial
    # 2. Import 1619 FA v2_2 with £value Funding Lines > Release Group 
    # 3. Check Parked and Discarded report

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017211'
    And   there is no Funding Allocation data in CRM for UKPRN '10017211'
    And   there is no Contract, Task or Workflow data for UKPRN '10017211'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017211'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017211'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017211' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017211' 
    And   there is no caseload advisor for UKPRN '10017211' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017211 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017211' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017211 Co Ltd' with UKPRN '10017211' and OrgId 'ORG0017211' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017211 | 117211 | 10017211 Co Ltd | 0              | Active                | Yes           | AA017211      | ?             | 10 Wilshire House      | Woolmead               | Farnham                | ?                      | ?                      | Surrey                 | GU9 7TT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017211 |





    # Part 1: Import 1619 FA v1.1 with £value Funding Lines > Discarded\Superseded, and v1.2 with £0 Funding Lines > Discarded\NonMaterial

    # Populate the stub with 1619 (02IPP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017211 | 1619-AS-2122-Contract-Provider-10017211-1_1           | 1_1            | 1619                        | AS-2122            | 21869.00          |
    | Contracting    | 10017211 | 1619-AS-2122-Contract-Provider-10017211-1_2           | 1_2            | 1619                        | AS-2122            | 0.00              |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017211-1_1  | 1_1                    | 1619-AS-2122-Contract-Provider-10017211-1_1           | 10017211      | Furth        | 02IPP           | 21869.00                  |
    | 1619-AS-2122-10017211-1_2  | 1_2                    | 1619-AS-2122-Contract-Provider-10017211-1_2           | 10017211      | Furth        | 02IPP           | 0.00                      |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017211-1_1  | 1619-005        | 11665.00         | Payment         |
    | 1619-AS-2122-10017211-1_1  | 1619-007        | 16277.00         | Payment         |
    #
    | 1619-AS-2122-10017211-1_2  | 1619-005        | 0.00             | Payment         |
    | 1619-AS-2122-10017211-1_2  | 1619-007        | 0.00             | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017211-1_1  | 1619-005        | FY-2122              | November               | 2021              | 3025.00                   |
    | 1619-AS-2122-10017211-1_1  | 1619-005        | FY-2122              | January                | 2022              | 4435.00                   |
    | 1619-AS-2122-10017211-1_1  | 1619-005        | FY-2122              | July                   | 2022              | 4205.00                   |
    | 1619-AS-2122-10017211-1_1  | 1619-007        | FY-2122              | August                 | 2021              | 4682.00                   |
    | 1619-AS-2122-10017211-1_1  | 1619-007        | FY-2122              | November               | 2021              | 3458.00                   |
    | 1619-AS-2122-10017211-1_1  | 1619-007        | FY-2122              | February               | 2022              | 2064.00                   |
    #
    | 1619-AS-2122-10017211-1_2  | 1619-005        | FY-2122              | October                | 2021              | 0.00                      |
    | 1619-AS-2122-10017211-1_2  | 1619-005        | FY-2122              | February               | 2022              | 0.00                      |
    | 1619-AS-2122-10017211-1_2  | 1619-005        | FY-2122              | March                  | 2022              | 0.00                      |
    | 1619-AS-2122-10017211-1_2  | 1619-007        | FY-2122              | September              | 2021              | 0.00                      |
    | 1619-AS-2122-10017211-1_2  | 1619-007        | FY-2122              | December               | 2021              | 0.00                      |
    | 1619-AS-2122-10017211-1_2  | 1619-007        | FY-2122              | June                   | 2022              | 0.00                      |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017211 | 1619-AS-2122-Contract-Provider-10017211-1_2             | 1_2            | AS-2122 | 1619                        | 0.00        | ?               | Discarded         | NonMaterial                       |
    | 10017211 | 1619-AS-2122-Contract-Provider-10017211-1_1             | 1_1            | AS-2122 | 1619                        | 21869.00    | ?               | Discarded         | Superseded                        |





    # Part 2: Import 1619 FA v2_2 with £value Funding Lines > Release Group 

    # Populate the stub with 1619 (02IPP) data

    # Change the date 
    Given the override date is '01/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017211 | 1619-AS-2122-Contract-Provider-10017211-2_2           | 2_2            | 1619                        | AS-2122            | 37819.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017211-2_2  | 2_2                    | 1619-AS-2122-Contract-Provider-10017211-2_2           | 10017211      | Furth        | 02IPP           | 37819.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017211-2_2  | 1619-001        | 25465.00         | Payment         |
    | 1619-AS-2122-10017211-2_2  | 1619-003        | 12354.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017211-2_2  | 1619-001        | FY-2122              | August                 | 2021              | 4918.00                   |
    | 1619-AS-2122-10017211-2_2  | 1619-001        | FY-2122              | November               | 2021              | 3011.00                   |
    | 1619-AS-2122-10017211-2_2  | 1619-001        | FY-2122              | December               | 2021              | 4731.00                   |
    | 1619-AS-2122-10017211-2_2  | 1619-001        | FY-2122              | March                  | 2022              | 4635.00                   |
    | 1619-AS-2122-10017211-2_2  | 1619-001        | FY-2122              | May                    | 2022              | 2798.00                   |
    | 1619-AS-2122-10017211-2_2  | 1619-001        | FY-2122              | July                   | 2022              | 5372.00                   |
    #
    | 1619-AS-2122-10017211-2_2  | 1619-003        | FY-2122              | October                | 2021              | 5204.00                   |
    | 1619-AS-2122-10017211-2_2  | 1619-003        | FY-2122              | March                  | 2022              | 3399.00                   |
    | 1619-AS-2122-10017211-2_2  | 1619-003        | FY-2122              | July                   | 2022              | 3751.00                   |

 
 
 

    # Consume stub data
 
    # Change the date 
    Given the override date is '02/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP2                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP2 = [CfS_ITP2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017211 | 10017211 Co Ltd  | 1619-AS-2122-Contract-Provider-10017211-2_2             | 2_2            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 37819.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP2]        | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 37819.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017211 | 1619-AS-2122-Contract-Provider-10017211-2_2             | 2_2            | AS-2122 | 1619                        | 37819.00    | [CfS_ITP2]      | ?                 | ?                                 |
    | 10017211 | 1619-AS-2122-Contract-Provider-10017211-1_2             | 1_2            | AS-2122 | 1619                        | 0.00        | ?               | Discarded         | NonMaterial                       |
    | 10017211 | 1619-AS-2122-Contract-Provider-10017211-1_1             | 1_1            | AS-2122 | 1619                        | 21869.00    | ?               | Discarded         | Superseded                        |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'


    


    # Part 3: Check Parked and Discarded report

    # Both v1_1 and v1_2 should appear in the "Discarded" sheet of the Parked and Discarded extract

    # Delete then recreate the Parked and Discarded spreadsheet (J155)
    When the Parked and Discarded spreadsheet is recreated
    
    # Check the named tab of the Parked and Discarded extract in the 'Funding Allocation Extracts' folder for particular rows (J155)
    Then  the Parked and Discarded spreadsheet includes the following 
    | TabName   | CFSFundingId                                         | CFSValue | FCSStatus | FCSSubStatus     | CFSProviderType                      | CFSProviderSubType   |
    | Discarded | 1619-AS-2122-Contract-Provider-10017211-1_2          | 0.00     | Discarded | NonMaterial      | Furth                                | 02IPP                |
    | Discarded | 1619-AS-2122-Contract-Provider-10017211-1_1          | 21869.00 | Discarded | Superseded       | Furth                                | 02IPP                |


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A212 Import and release 1619 FA > contract. Delete contract. Withdraw FA. Import FA with £zero lines and discard as NonMaterial. Check PaaS and the P&D report

    # 1. Import and release a 1619 FA v1_1 > contract v1
    # 2. Delete contract v1 and set the FA to 'Return to Scheduling'
    # 3. Withdraw Funding Allocation v1_1 from Contract Control 
    # 4. Import 1619 FA v2_1 with all £value lines now set to £0 > Discarded\NonMaterial
    # 5. Check Parked and Discarded report

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017212'
    And   there is no Funding Allocation data in CRM for UKPRN '10017212'
    And   there is no Contract, Task or Workflow data for UKPRN '10017212'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017212'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017212'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017212' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017212' 
    And   there is no caseload advisor for UKPRN '10017212' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017212 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017212' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017212 Co Ltd' with UKPRN '10017212' and OrgId 'ORG0017212' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017212 | 117212 | 10017212 Co Ltd | 0              | Provider Under Change | Yes           | AA017212      | ?             | 17 Wood Street         | ?                      | ?                      | ?                      | Barnet                 | Hertfordshire          | EN5 4AT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017212 |





    # Part 1: Import and release a 1619 FA v1_1 > contract v1
    
    # Populate the stub with 1619 (02IPP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017212 | 1619-AS-2122-Contract-Provider-10017212-1_1           | 1_1            | 1619                        | AS-2122            | 76320.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017212-1_1  | 1_1                    | 1619-AS-2122-Contract-Provider-10017212-1_1           | 10017212      | Furth        | 02IPP           | 76320.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017212-1_1  | 1619-001        | ?                | Payment         |
    | 1619-AS-2122-10017212-1_1  | 1619-002        | 12064.00         | Payment         |
    | 1619-AS-2122-10017212-1_1  | 1619-003        | 20823.00         | Payment         |
    | 1619-AS-2122-10017212-1_1  | 1619-004        | 15008.00         | Payment         |
    | 1619-AS-2122-10017212-1_1  | 1619-007        | 6698.00          | Payment         |
    | 1619-AS-2122-10017212-1_1  | 1619-011        | 21727.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017212-1_1  | 1619-002        | FY-2122              | September              | 2021              | 3044.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-002        | FY-2122              | January                | 2022              | 4112.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-002        | FY-2122              | April                  | 2022              | 4908.00                   |
    #
    | 1619-AS-2122-10017212-1_1  | 1619-003        | FY-2122              | August                 | 2021              | 4920.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-003        | FY-2122              | November               | 2021              | 4621.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-003        | FY-2122              | February               | 2022              | 5518.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-003        | FY-2122              | June                   | 2022              | 5764.00                   |
    #
    | 1619-AS-2122-10017212-1_1  | 1619-004        | FY-2122              | September              | 2021              | 5834.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-004        | FY-2122              | November               | 2021              | 2800.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-004        | FY-2122              | March                  | 2022              | 3900.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-004        | FY-2122              | May                    | 2022              | 2474.00                   |
    #
    | 1619-AS-2122-10017212-1_1  | 1619-007        | FY-2122              | October                | 2021              | 2644.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-007        | FY-2122              | July                   | 2022              | 4054.00                   |
    #
    | 1619-AS-2122-10017212-1_1  | 1619-011        | FY-2122              | September              | 2021              | 3199.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-011        | FY-2122              | December               | 2021              | 4406.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-011        | FY-2122              | March                  | 2022              | 5849.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-011        | FY-2122              | May                    | 2022              | 3397.00                   |
    | 1619-AS-2122-10017212-1_1  | 1619-011        | FY-2122              | June                   | 2022              | 4876.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017212 | 10017212 Co Ltd  | 1619-AS-2122-Contract-Provider-10017212-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 76320.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 76320.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017212 | 1619-AS-2122-Contract-Provider-10017212-1_1             | 1_1            | AS-2122 | 1619                        | 76320.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

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
    | Released          | 1               | 76320.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017212' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017212' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017212 | 10017212 Co Ltd  | 1619-AS-2122-Contract-Provider-10017212-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Released          | Released          | 76320.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017212 | 1619-AS-2122-Contract-Provider-10017212-1_1             | 1_1            | AS-2122 | 1619                        | 76320.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017212-1_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017212 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017212 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 2: Delete contract v1 and set the FA to 'Return to Scheduling'

    # Change the date 
    Given the override date is '12/07/2021'

    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
   #When  a request is initiated in CRM to delete the following contracts
    When User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017212 | [ContractNo]   | 1                     | 0                  |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017212 | 10017212 Co Ltd  | 1619-AS-2122-Contract-Provider-10017212-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 76320.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |





    # Part 3: Withdraw Funding Allocation v1_1 from Contract Control 
    
    # Change the date 
    Given the override date is '13/07/2021'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Contracting query'
    | FundingId                                       |
    | 1619-AS-2122-Contract-Provider-10017212-1_1     | 

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017212 | 1619-AS-2122-Contract-Provider-10017212-1_1             | 1_1            | AS-2122 | 1619                        | 76320.00    | ?               | Withdrawn         | Withdrawn                         |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017212 | 10017212 Co Ltd  | 1619-AS-2122-Contract-Provider-10017212-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 76320.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |





    # Part 4: Import 1619 FA v2_1 with all £value lines now set to £0 > Discarded\NonMaterial

    # Populate the stub with 1619 (02IPP) data

    # Change the date 
    Given the override date is '21/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017212 | 1619-AS-2122-Contract-Provider-10017212-2_1           | 2_1            | 1619                        | AS-2122            | 0.00              |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017212-2_1  | 2_1                    | 1619-AS-2122-Contract-Provider-10017212-2_1           | 10017212      | Furth        | 02IPP           | 0.00                      |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017212-1_1  | 1619-001        | ?                | Payment         |
    | 1619-AS-2122-10017212-2_1  | 1619-002        | 0.00             | Payment         |
    | 1619-AS-2122-10017212-2_1  | 1619-003        | 0.00             | Payment         |
    | 1619-AS-2122-10017212-2_1  | 1619-004        | 0.00             | Payment         |
    | 1619-AS-2122-10017212-2_1  | 1619-007        | 0.00             | Payment         |
    | 1619-AS-2122-10017212-2_1  | 1619-011        | 0.00             | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017212-2_1  | 1619-002        | FY-2122              | September              | 2021              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-002        | FY-2122              | January                | 2022              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-002        | FY-2122              | April                  | 2022              | 0.00                      |
    #
    | 1619-AS-2122-10017212-2_1  | 1619-003        | FY-2122              | August                 | 2021              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-003        | FY-2122              | November               | 2021              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-003        | FY-2122              | February               | 2022              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-003        | FY-2122              | June                   | 2022              | 0.00                      |
    #
    | 1619-AS-2122-10017212-2_1  | 1619-004        | FY-2122              | September              | 2021              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-004        | FY-2122              | November               | 2021              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-004        | FY-2122              | March                  | 2022              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-004        | FY-2122              | May                    | 2022              | 0.00                      |
    #
    | 1619-AS-2122-10017212-2_1  | 1619-007        | FY-2122              | October                | 2021              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-007        | FY-2122              | July                   | 2022              | 0.00                      |
    #
    | 1619-AS-2122-10017212-2_1  | 1619-011        | FY-2122              | September              | 2021              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-011        | FY-2122              | December               | 2021              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-011        | FY-2122              | March                  | 2022              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-011        | FY-2122              | May                    | 2022              | 0.00                      |
    | 1619-AS-2122-10017212-2_1  | 1619-011        | FY-2122              | June                   | 2022              | 0.00                      |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '23/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017212 | 1619-AS-2122-Contract-Provider-10017212-2_1             | 2_1            | AS-2122 | 1619                        | 0.00        | ?               | Discarded         | NonMaterial                       |
    | 10017212 | 1619-AS-2122-Contract-Provider-10017212-1_1             | 1_1            | AS-2122 | 1619                        | 76320.00    | ?               | Withdrawn         | Withdrawn                         |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017212 | 10017212 Co Ltd  | 1619-AS-2122-Contract-Provider-10017212-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 76320.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |





    # Part 5: Check Parked and Discarded report

    # v2_1 should appear in the "Discarded" sheet of the Parked and Discarded extract.

    # Delete then recreate the Parked and Discarded spreadsheet (J155)
    When the Parked and Discarded spreadsheet is recreated
    
    # Check the named tab of the Parked and Discarded extract in the 'Funding Allocation Extracts' folder for particular rows (J155)
    Then  the Parked and Discarded spreadsheet includes the following 
    | TabName   | CFSFundingId                                         | CFSValue | FCSStatus | FCSSubStatus     | CFSProviderType                      | CFSProviderSubType   |
    | Discarded | 1619-AS-2122-Contract-Provider-10017212-2_1          | 0.00     | Discarded | NonMaterial      | Furth                                | 02IPP                |


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A213 Import 2x 1416 FAs. Park FA 2_2. Release FA1_2 > contract v1. Delete contract. Withdraw FA 1_2. Check CRM, PaaS and the P&D report 

    # 1. Import but don't release 1416 FA v1_2
    # 2. Import 1416 FA v2_2 and Park\Awaiting Outcome
    # 3. Release 1416 FA 1_2 > contract v1
    # 4. Delete contract v1 
    # 5. Withdraw 1416 FA v1_2
    # 6. Check Parked and Discarded report

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017213'
    And   there is no Funding Allocation data in CRM for UKPRN '10017213'
    And   there is no Contract, Task or Workflow data for UKPRN '10017213'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017213'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017213'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017213' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017213' 
    And   there is no caseload advisor for UKPRN '10017213' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017213 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017213' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017213 Co Ltd' with UKPRN '10017213' and OrgId 'ORG0017213' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017213 | 117213 | 10017213 Co Ltd | 0              | Active                | Yes           | AA017213      | ?             | 123 Hollybush Road     | ?                      | ?                      | ?                      | Luton                  | Bedfordshire           | LU2 9HQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017213 |





    # Part 1: Import but don't release 1416 FA v1_2

    # Populate the stub with 1416 (02IPP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-1_2           | 1_2            | 1416                        | AY-2122            | 18021.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1416-AY-2122-10017213-1_2  | 1_2                    | 1416-AY-2122-Contract-Provider-10017213-1_2           | 10017213      | Furth        | 02IPP           | 18021.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2122-10017213-1_2  | 1416-001        | 6838.00          | Payment         |
    | 1416-AY-2122-10017213-1_2  | 1416-002        | 5993.00          | Payment         |
    | 1416-AY-2122-10017213-1_2  | 1416-003        | 5190.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2122-10017213-1_2  | 1416-001        | FY-2122              | November               | 2021              | 4132.00                   |
    | 1416-AY-2122-10017213-1_2  | 1416-001        | FY-2122              | May                    | 2022              | 2706.00                   |
    #
    | 1416-AY-2122-10017213-1_2  | 1416-002        | FY-2122              | November               | 2021              | 2462.00                   |
    | 1416-AY-2122-10017213-1_2  | 1416-002        | FY-2122              | March                  | 2022              | 3531.00                   |
    #
    | 1416-AY-2122-10017213-1_2  | 1416-003        | FY-2122              | November               | 2021              | 5190.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017213 | 10017213 Co Ltd  | 1416-AY-2122-Contract-Provider-10017213-1_2             | 1_2            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 18021.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18021.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-1_2             | 1_2            | AY-2122 | 1416                        | 18021.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Part 2: Import 1416 FA v2_2 and Park, Awaiting Outcome

    # Populate the stub with 1416 (02IPP) data

    # Change the date 
    Given the override date is '01/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-2_2           | 2_2            | 1416                        | AY-2122            | 0.00              |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1416-AY-2122-10017213-2_2  | 2_2                    | 1416-AY-2122-Contract-Provider-10017213-2_2           | 10017213      | Furth        | 02IPP           | 0.00                      |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2122-10017213-2_2  | 1416-001        | 0.00             | Payment         |
    | 1416-AY-2122-10017213-2_2  | 1416-002        | 0.00             | Payment         |
    | 1416-AY-2122-10017213-2_2  | 1416-003        | 0.00             | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2122-10017213-2_2  | 1416-001        | FY-2122              | November               | 2021              | 0.00                      |
    | 1416-AY-2122-10017213-2_2  | 1416-001        | FY-2122              | May                    | 2022              | 0.00                      |
    #
    | 1416-AY-2122-10017213-2_2  | 1416-002        | FY-2122              | November               | 2021              | 0.00                      |
    | 1416-AY-2122-10017213-2_2  | 1416-002        | FY-2122              | March                  | 2022              | 0.00                      |
    #
    | 1416-AY-2122-10017213-2_2  | 1416-003        | FY-2122              | November               | 2021              | 0.00                      |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP2                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP2 = [CfS_ITP2]' is written to the Output window

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-2_2             | 2_2            | AY-2122 | 1416                        | 0.00        | ?               | Parked            | AwaitingOutcome                   |
    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-1_2             | 1_2            | AY-2122 | 1416                        | 18021.00    | [CfS_ITP]       | ?                 | ?                                 |





    # Part 3: Release 1416 FA 1_2 > contract v1
    
    # Change the date 
    Given the override date is '05/08/2021'

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
    | Released          | 1               | 18021.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017213' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017213' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017213 | 10017213 Co Ltd  | 1416-AY-2122-Contract-Provider-10017213-1_2             | 1_2            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Released          | Released          | 18021.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-2_2             | 2_2            | AY-2122 | 1416                        | 0.00        | ?               | Parked            | AwaitingOutcome                   |
    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-1_2             | 1_2            | AY-2122 | 1416                        | 18021.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2122-Contract-Provider-10017213-1_2             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017213 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017213 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    

    
    # Part 4: Delete contract v1

    Given the override date is '07/08/2021'

    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
   #When  a request is initiated in CRM to delete the following contracts
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017213 | [ContractNo]   | 1                     | 0                  |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}    FA v1_2 is disassociated from RG [CfS_ITP]
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-2_2             | 2_2            | AY-2122 | 1416                        | 0.00        | ?               | Parked            | AwaitingOutcome                   |
    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-1_2             | 1_2            | AY-2122 | 1416                        | 18021.00    | ?               | ?                 | ?                                 |

    # Check the CRM Funding Allocations data (J125) FA v1_2 is returned to scheduluing and disassociated from RG [CfS_ITP]
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017213 | 10017213 Co Ltd  | 1416-AY-2122-Contract-Provider-10017213-1_2             | 1_2            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 18021.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | ?               | ?          | ?                   |





    # Part 5: Withdraw 1416 FA v1_2

    Given the override date is '07/08/2021'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS?'
    | FundingId                                               | 
    | 1416-AY-2122-Contract-Provider-10017213-1_2             | 

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}   FA 1_2 marked as withdrawn and FA2_2 marked as Discarded, NonMaterial
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-2_2             | 2_2            | AY-2122 | 1416                        | 0.00        | ?               | Discarded         | NonMaterial                       |
    | 10017213 | 1416-AY-2122-Contract-Provider-10017213-1_2             | 1_2            | AY-2122 | 1416                        | 18021.00    | ?               | Withdrawn         | Withdrawn                         |





    # Part 6: Check Parked and Discarded report

    # FA v2_2 should appear in the "Discarded" sheet of the Parked and Discarded extract

    # Delete then recreate the Parked and Discarded spreadsheet (J155)
    When the Parked and Discarded spreadsheet is recreated
    
    # Check the named tab of the Parked and Discarded extract in the 'Funding Allocation Extracts' folder for particular rows (J155)
    Then  the Parked and Discarded spreadsheet includes the following 
    | TabName   | CFSFundingId                                         | CFSValue | FCSStatus | FCSSubStatus     | CFSProviderType                      | CFSProviderSubType   |
    | Discarded | 1416-AY-2122-Contract-Provider-10017213-2_2          | 0.00     | Discarded | NonMaterial      | Furth                                | 02IPP                |


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A214 Import 2x 1416 FAs. Park FA 2_1. Release FA1_1 > contract v1. Publish then withdraw contract v1. Withdraw FA 1_1. Release FA 2_1. Check CRM, docs and PaaS 

    # 1. Import but don't release 1416 FA v1_1
    # 2. Import 1416 FA v2_1 and Park\Awaiting Outcome
    # 3. Release 1416 FA 1_1 > contract v1
    # 4. Publish contract v1 
    # 5. Withdraw published contract v1
    # 6. Withdraw 1416 FA v1_1
    # 7. Release 1416 FA 2_1 > contract v2

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017214'
    And   there is no Funding Allocation data in CRM for UKPRN '10017214'
    And   there is no Contract, Task or Workflow data for UKPRN '10017214'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017214'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017214'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017214' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017214' 
    And   there is no caseload advisor for UKPRN '10017214' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017214 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017214' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017214 Co Ltd' with UKPRN '10017214' and OrgId 'ORG0017214' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017214 | 117214 | 10017214 Co Ltd | 0              | Active                | Yes           | AA017214      | ?             | 123 Hollybush Road     | ?                      | ?                      | ?                      | Luton                  | Bedfordshire           | LU2 9HQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017214 |





    # Part 1: Import but don't release 1416 FA v1_1

    # Populate the stub with 1416 (02IPP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-1_1           | 1_1            | 1416                        | AY-2122            | 18021.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1416-AY-2122-10017214-1_1  | 1_1                    | 1416-AY-2122-Contract-Provider-10017214-1_1           | 10017214      | Furth        | 02IPP           | 18021.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2122-10017214-1_1  | 1416-001        | 6838.00          | Payment         |
    | 1416-AY-2122-10017214-1_1  | 1416-002        | 5993.00          | Payment         |
    | 1416-AY-2122-10017214-1_1  | 1416-003        | 5190.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2122-10017214-1_1  | 1416-001        | FY-2122              | November               | 2021              | 4132.00                   |
    | 1416-AY-2122-10017214-1_1  | 1416-001        | FY-2122              | May                    | 2022              | 2706.00                   |
    #
    | 1416-AY-2122-10017214-1_1  | 1416-002        | FY-2122              | November               | 2021              | 2462.00                   |
    | 1416-AY-2122-10017214-1_1  | 1416-002        | FY-2122              | March                  | 2022              | 3531.00                   |
    #
    | 1416-AY-2122-10017214-1_1  | 1416-003        | FY-2122              | November               | 2021              | 5190.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017214 | 10017214 Co Ltd  | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 18021.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18021.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | AY-2122 | 1416                        | 18021.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Part 2: Import 1416 FA v2_1 and Park, Awaiting Outcome

    # Populate the stub with 1416 (02IPP) data

    # Change the date 
    Given the override date is '01/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-2_1           | 2_1            | 1416                        | AY-2122            | 0.00              |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1416-AY-2122-10017214-2_1  | 2_1                    | 1416-AY-2122-Contract-Provider-10017214-2_1           | 10017214      | Furth        | 02IPP           | 0.00                      |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2122-10017214-2_1  | 1416-001        | 0.00             | Payment         |
    | 1416-AY-2122-10017214-2_1  | 1416-002        | 0.00             | Payment         |
    | 1416-AY-2122-10017214-2_1  | 1416-003        | 0.00             | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2122-10017214-2_1  | 1416-001        | FY-2122              | November               | 2021              | 0.00                      |
    | 1416-AY-2122-10017214-2_1  | 1416-001        | FY-2122              | May                    | 2022              | 0.00                      |
    #
    | 1416-AY-2122-10017214-2_1  | 1416-002        | FY-2122              | November               | 2021              | 0.00                      |
    | 1416-AY-2122-10017214-2_1  | 1416-002        | FY-2122              | March                  | 2022              | 0.00                      |
    #
    | 1416-AY-2122-10017214-2_1  | 1416-003        | FY-2122              | November               | 2021              | 0.00                      |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP2                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP2 = [CfS_ITP2]' is written to the Output window

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-2_1             | 2_1            | AY-2122 | 1416                        | 0.00        | ?               | Parked            | AwaitingOutcome                   |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | AY-2122 | 1416                        | 18021.00    | [CfS_ITP]       | ?                 | ?                                 |





    # Part 3: Release 1416 FA 1_1 > contract v1
    
    # Change the date 
    Given the override date is '05/08/2021'

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
    | Released          | 1               | 18021.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017214' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017214' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017214 | 10017214 Co Ltd  | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Released          | Released          | 18021.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-2_1             | 2_1            | AY-2122 | 1416                        | 0.00        | ?               | Parked            | AwaitingOutcome                   |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | AY-2122 | 1416                        | 18021.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2122-Contract-Provider-10017214-1_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017214 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017214 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    

    
    # Part 4: Publish contract v1

    Given the override date is '07/08/2021'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017214_[ContractNo]_v1.pdf' is created in 'EDSK-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017214 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017214 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    
     # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-2_1             | 2_1            | AY-2122 | 1416                        | 0.00        | ?               | Parked            | AwaitingOutcome                   |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | AY-2122 | 1416                        | 18021.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2122-Contract-Provider-10017214-1_1             | [ContractNo] | 1               | 0                  | Yes            |
   
    
    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017214 | 10017214 Co Ltd  | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Released          | Released                | 18021.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CfS_ITP]       | ?          | ?                   |
    




    # Part 5: Withdraw published contract v1

    Given the override date is '09/08/2021'

    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'Test 10017214' by 'FCS2 Test'

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}   FA 2_1 is parked awaiting outcome of FA 1_1
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-2_1             | 2_1            | AY-2122 | 1416                        | 0.00        | ?               | Parked            | AwaitingOutcome                   |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | AY-2122 | 1416                        | 18021.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check the CRM Funding Allocations data (J125) {F7}   FA 1_1 is returned to scheduling and disassociated from [ContractNo] and RG [CfS_ITP]
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017214 | 10017214 Co Ltd  | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 18021.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |





    # Part 6: Withdraw 1416 FA v1_1

    Given the override date is '11/08/2021'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS?'
    | FundingId                                               | 
    | 1416-AY-2122-Contract-Provider-10017214-1_1             | 

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP2                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP2 = [CfS_ITP2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 0.00            |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}   FA 1_1 is marked as withdrawn and FA2_1 is added to a new RG [CfS_ITP3]
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-2_1             | 2_1            | AY-2122 | 1416                        | 0.00        | [CfS_ITP2]      | ?                 | ?                                 |
    | 10017214 | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | AY-2122 | 1416                        | 18021.00    | ?               | Withdrawn         | Withdrawn                         |

    # Check the CRM Funding Allocations data (J125) {F7}   FA 2_1 is added to RG [CfS_ITP2] ready for release
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017214 | 10017214 Co Ltd  | 1416-AY-2122-Contract-Provider-10017214-2_1             | 2_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 0.00        | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CfS_ITP2]      | ?          | ?                   |
    | 10017214 | 10017214 Co Ltd  | 1416-AY-2122-Contract-Provider-10017214-1_1             | 1_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1416                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 18021.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |





    # Part 7: Release 1416 FA 2_1 > contract v2
    
    # Change the date 
    Given the override date is '13/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS_ITP2]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP2 = [CfS_ITP2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 0.00            |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017214' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017214' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017214 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017214 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017214 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM  This is correct but is rather queer
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017214 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 0.00          | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017214 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017214 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017214 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017211 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 0.00            | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                 | DeliverableDescription   | 
    | [ContractNo]   | [AllocRef_16ED]    | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14-16 Programme Funding         |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 25              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14-16 Pupil Premium             |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 111             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14-16 Service Child Premium     |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017214_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017214 Co Ltd UKPRN: 10017214
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £0 £0 £0
    Total Funding for this contract: £0
    Summary of Funding – Page 1
     
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017214 Co Ltd
    Funding for 16 to 19 Education
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017214 Co Ltd THE SECRETARY OF STATE FOR
    123 Hollybush Road EDUCATION
    Luton DEPARTMENT FOR EDUCATION
    Bedfordshire 20 GREAT SMITH STREET
    AND
    LU2 9HQ LONDON
    SW1P 3BT
    Company No: AA017214
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75
     
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2021) – Page 12
     
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
     
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017214 Co Ltd UKPRN: 10017214
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    14-16 Programme Funding £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    14-16 Pupil Premium £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    14-16 Service Child Premium £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v2
     
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    EDSK Schedule 9 Version 2 (July 2021) – Page 5
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017214_[ContractNo]_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A214.pdf'


    # Tidy Up
    Given the override date is reset
 
