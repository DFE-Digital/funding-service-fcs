Feature: CreateEDSKContracts_1619ED_39177


@AcceptanceTest @Complete
@CFS
Scenario: S800 Import a 1619ED2425 FA for a nonsense ProviderType and ProviderSubType for override UKPRN 10001800. LA AA. Release and approve. Check docs, CRM, PaaS and Feed

    # 10001800 is an exception provider listed in the Provider Category Exceptions tab of the config spreadsheet
    # In 21/22, exception provider 10088193 was tested by A171. 
    # In 22/23, exception provider 10039859 was tested by A383. 
    # S800 is being added because 10001800 introduces a new Provider Category: LA AA 

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10001800'
    And   there is no Funding Allocation data in CRM for UKPRN '10001800'
    And   there is no Contract, Task or Workflow data for UKPRN '10001800'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10001800'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10001800'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10001800' in the Sharepoint 'EDSK-2425-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2425        | 16-19ED2425  | Accountability Agreement (LA)           |


    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10001800' 
    And   there is no caseload advisor for UKPRN '10001800' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10001800 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10001800' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001800 Co Ltd' with UKPRN '10001800' and OrgId 'ORG0001800' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10001800 | 131800 | 10001800 Co Ltd | 0              | Active                | Yes           | AA031800      | ?             | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10001800 |




    # Populate the stub with 1619 (Further education) data

    # Change the date 
    Given the override date is '01/07/2024'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10001800 | 1619-AS-2425-Contract-Provider-10001800-3_7           | 3_7            | 1619                        | AS-2425            | 63169.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType   | ProviderSubType     | ProviderFundingTotalValue |
    | 1619-AS-2425-10001800-3_7  | 3_7                    | 1619-AS-2425-Contract-Provider-10001800-3_7           | 10001800      | Nonsense       | Rubbish             | 63169.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2425-10001800-3_7  | 1619-002        | 6899.00          | Payment         |
    | 1619-AS-2425-10001800-3_7  | 1619-005        | 21458.00         | Payment         |
    | 1619-AS-2425-10001800-3_7  | 1619-006        | 11338.00         | Payment         |
    | 1619-AS-2425-10001800-3_7  | 1619-008        | 11441.00         | Payment         |
    | 1619-AS-2425-10001800-3_7  | 1619-010        | 3011.00          | Payment         |
    | 1619-AS-2425-10001800-3_7  | 1619-026        | 4011.00          | Payment         |
    | 1619-AS-2425-10001800-3_7  | 1619-027        | 5011.00          | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2425-10001800-3_7  | 1619-002        | FY-2425              | October                | 2024              | 2488.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-002        | FY-2425              | March                  | 2025              | 4411.00                   |
    #
    | 1619-AS-2425-10001800-3_7  | 1619-005        | FY-2425              | October                | 2024              | 5280.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-005        | FY-2425              | January                | 2025              | 3784.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-005        | FY-2425              | February               | 2025              | 4270.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-005        | FY-2425              | May                    | 2025              | 5750.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-005        | FY-2425              | July                   | 2025              | 2374.00                   |
    #
    | 1619-AS-2425-10001800-3_7  | 1619-006        | FY-2425              | October                | 2024              | 4319.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-006        | FY-2425              | February               | 2025              | 4874.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-006        | FY-2425              | April                  | 2025              | 2145.00                   |
    #
    | 1619-AS-2425-10001800-3_7  | 1619-008        | FY-2425              | September              | 2024              | 3007.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-008        | FY-2425              | December               | 2024              | 4588.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-008        | FY-2425              | April                  | 2025              | 3846.00                   |
    #
    | 1619-AS-2425-10001800-3_7  | 1619-010        | FY-2425              | July                   | 2025              | 3011.00                   |
    #
    | 1619-AS-2425-10001800-3_7  | 1619-026        | FY-2425              | October                | 2024              | 3011.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-026        | FY-2425              | December               | 2024              | 1000.00                   |
    #
    | 1619-AS-2425-10001800-3_7  | 1619-027        | FY-2425              | October                | 2024              | 3011.00                   |
    | 1619-AS-2425-10001800-3_7  | 1619-027        | FY-2425              | April                  | 2025              | 2000.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2024'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                          | ReleaseGroupParameterName |
    | EDSK            | AY2425        | 16-19ED2425  | Accountability Agreement (LA)         | AA_LA                     |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_LA = [AA_LA]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10001800 | 10001800 Co Ltd  | 1619-AS-2425-Contract-Provider-10001800-3_7             | 3_7            | Education & Skills Funding | AY2425  | Accountability Agreement (LA)            | 1619                        | 16-19ED2425     | Scheduling        | Awaiting Release  | 63169.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [AA_LA]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2425-Contract-Provider-10001800-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 63169.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10001800 | 1619-AS-2425-Contract-Provider-10001800-3_7             | 3_7            | AS-2425 | 1619                        | 63169.00    | [AA_LA]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'



    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '04/07/2024'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [AA_LA]           |

    Then wait '60' seconds

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_LA = [AA_LA]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[AA_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 63169.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10001800' for FundingType 'EDSK' and period '2425'
   #When  I retrieve the latest EFA contract details from CRM for provider '10001800' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

#    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                           | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10001800 | 10001800 Co Ltd  | 1619-AS-2425-Contract-Provider-10001800-3_7             | 3_7            | Education & Skills Funding | AY2425  | Accountability Agreement (LA)          | 1619                        | 16-19ED2425     | Released          | Released          | 63169.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_LA]         | ?          | ?                   |
#
#    # Check the CRM Funding Allocation Workflow History data
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | 1619-AS-2425-Contract-Provider-10001800-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#    | 1619-AS-2425-Contract-Provider-10001800-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10001800 | 1619-AS-2425-Contract-Provider-10001800-3_7             | 3_7            | AS-2425 | 1619                        | 63169.00    | [AA_LA]         | ?                 | ?                                 |
#
#    # Check PaaS FundingAllocation.Contract
#    And   the following Funding Allocations and Contracts are linked in PaaS
#    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
#    | 1619-AS-2425-Contract-Provider-10001800-3_7             | [ContractNo] | 1               | 0                  | Yes            |
#
#    # Check PaaS FundingAllocation.ReleaseGroup
#    And   Release Group '[AA_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'
#
#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10001800 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
#    | 10001800 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#
##
##    Given the override date is '06/07/2023'
##    And   a file with filename '10001800_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Input-Appendices'
##    And  the contract sub-status is updated to 'Awaiting Documentation' on the latest version of contract '[ContractNo]'
##    And the TaskOwner is updated to 'Document Management Team' on the latest version of contract '[ContractNo]'
#
#
#    # Check that the Contract and Master Contract have been created correctly in CRM
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10001800 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 63169.00      | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Accountability Agreement (LA)             | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2425 | ?               | 10001800 Co Ltd  | Active | Document Management Team  | ?                      |
#    | 10001800 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Accountability Agreement (LA)             | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10001800 Co Ltd  | Active | CRM Integration           | ?                      |
#
#    # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10001800 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 63169.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |
#
#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                                       | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_16ED] | 19              | 6899.00   | 0.00     | 0.00     | 2488.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Bursary Funds                                                   |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 31              | 21458.00  | 0.00     | 0.00     | 5280.00  | 0.00     | 0.00     | 3784.00  | 4270.00  | 0.00     | 0.00     | 5750.00  | 0.00     | 2374.00  | 16-19 Free Meals                                                      |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 22              | 11338.00  | 0.00     | 0.00     | 4319.00  | 0.00     | 0.00     | 0.00     | 4874.00  | 0.00     | 2145.00  | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                                            |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 914             | 11441.00  | 0.00     | 3007.00  | 0.00     | 0.00     | 4588.00  | 0.00     | 0.00     | 0.00     | 3846.00  | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                          |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 125             | 3011.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3011.00  | Teacher's Pension Scheme 1619                                         |                          |
#
#    # Contract is now at 'Draft\Awaiting Documentation'
#
#    # Check the deliverable count in CRM
#    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
##
##    # Check the contents of the Appendices
##    And   the file named '10001800_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
##    """
##    SUMMARY OF FUNDING 2023/24
##    Organisation Name: 10001800 Co Ltd UKPRN: 10001800
##    Master Contract Number: [MasterContractNo]
##    Allocation
##    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
##    16 to 19 Education [AllocRef_16ED] £37,021 £17,126 £54,147
##    Total Funding for this contract: £54,147
##    Summary of Funding – Page 1
##    
##    Agreement Type Accountability Agreement (Local Authorities)
##    st st
##    Funding Period 1 August 2023 to 31 July 2024
##    Between the Secretary of State for Education
##    And 10001800 Co Ltd
##    Funding for 16 to 19 Education
##    Master Agreement Number [MasterContractNo]
##    ACCEPTANCE BY THE PROVIDER
##    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
##    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
##    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
##    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
##    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
##    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
##    SIGNED FOR AND ON BEHALF OF
##    THE SECRETARY OF STATE FOR EDUCATION
##    by David Withey, Chief Executive of the Education and Skills Funding Agency
##    Accountability Agreement (LA) Version 1 (April 2023) Page 1
##    This Agreement is made on the date the Agreement is digitally signed by the
##    Provider on the Manage Your Education & Skills Funding Service between:
##    10001800 Co Ltd THE SECRETARY OF STATE FOR
##    96 West Yard EDUCATION
##    Camden Lock Place DEPARTMENT FOR EDUCATION
##    Chalk Farm Road 20 GREAT SMITH STREET
##    AND
##    London LONDON
##    NW1 8AF SW1P 3BT
##    Company No: AA031800
##    Hereinafter called Hereinafter called
##    the Provider the Department
##    Accountability Agreement (LA) Version 1 (April 2023) Page 2
##    Accountability Agreement (LA) Version 1 (April 2023) Page 73
##
##    EDSK2324_S2_1619ED_AA_LA_2023_08_01
##    EDSK2324_S3_1619ED_AA_LA_2023_08_01
##
##
##    SCHEDULE 2 – 16 TO 19 EDUCATION
##    Funding Agreement – 16 to 19 Education
##    Provider: 10001800 Co Ltd UKPRN: 10001800
##    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
##    Contract Ref: [AllocRef_16ED]
##    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
##    16-19 Bursary Funds £6,899 £0.00 £0.00 £2,488.00 £0.00 £0.00 £0.00 £0.00 £4,411.00 £0.00 £0.00 £0.00 £0.00
##    16-19 High Needs Element 2 £11,338 £0.00 £0.00 £4,319.00 £0.00 £0.00 £0.00 £4,874.00 £0.00 £2,145.00 £0.00 £0.00 £0.00
##    16-19 Free Meals £21,458 £0.00 £0.00 £5,280.00 £0.00 £0.00 £3,784.00 £4,270.00 £0.00 £0.00 £5,750.00 £0.00 £2,374.00
##    16-19 Advanced Maths Premium £11,441 £0.00 £3,007.00 £0.00 £0.00 £4,588.00 £0.00 £0.00 £0.00 £3,846.00 £0.00 £0.00 £0.00
##    Teacher's Pension Scheme 1619 £3,011 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,011.00
##    Total Funding £54,147 £0.00 £3,007.00 £12,087.00 £0.00 £4,588.00 £3,784.00 £9,144.00 £4,411.00 £5,991.00 £5,750.00 £0.00 £5,385.00
##    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
##    
##    Schedule 4 Version 1 (April 2023) – Page 2
##    Schedule 5 Version 1 (April 2023) – Page 8
##    Schedule 6 Version 1 (April 2023) – Page 5
##    Schedule 7 Version 1 (April 2023) – Page 1
##    Schedule 8 Version 1 (April 2023) – Page 5
##    Schedule 9 Version 1 (April 2023) – Page 1
##    """
#
#
#
##    
##    EDSK Version 2 (July 2023) Page 2
##    EDSK Version 2 (July 2023) Page 73
##
##    SCHEDULE 1: SPECIFICATION & MONITORING
##    16-19 EDUCATION SPECIFICATION
##    EDSK Schedule 1 – 16 to 19 Education Version 1 Trust (July 2023) – Page 1
##    EDSK Schedule 1 – 16 to 19 Education Version 1 Trust (July 2023) – Page 10
##
##    SCHEDULE 2: PAYMENT
##    16-19 EDUCATION PAYMENT
##    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2023) – Page 1
##
##    SCHEDULE 3: NOT USED
##    EDSK Schedule 3 Version 2 (July 2023) – Page 1
##    EDSK Schedule 9 Version 2 (July 2023) – Page 5
#
#
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#    And   Sharepoint file '10001800_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10001800_[ContractNo]_v1.pdf'
#
#    # Remove all details from ContractManagement.CreatedContract for a contract
# #  Given there are no created contracts for this number '[ContractNo]'
#    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'
#
#    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
#    #   Note: Documents are created using the system date. The following step 'corrects' this
#    And   the following document creation details exist in the ContractManagement.CreatedContract table
#    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
#    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |
#
#    # Check the current state of the Tasks for this contract
#    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10001800'
#    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
#    | Initiate Document Merge   | 10001800 - 10001800 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |
#
#    # Check the CRM Contract Workflow History data
#    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
#    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
#   #| 10001800 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#   #| 10001800 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#    | 10001800 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#
#
#
#
#
#    # Publish the contract
#
#    # Change the date 
#    Given the override date is '07/07/2024'
#
# #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
# #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
# #  or
#    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
#    And   a file with filename '10001800_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
#    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
#    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table
#
#    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10001800 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
#    | 10001800 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#
#
#
#
#
#    # Approve the contract
#
#    # Change the date 
#    Given the override date is '09/07/2024'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10001800 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
#    | 10001800 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#
#    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
#    And   the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10001800 | 10001800 Co Ltd  | 1619-AS-2425-Contract-Provider-10001800-3_7             | 3_7            | Education & Skills Funding | AY2425  | Accountability Agreement (LA)            | 1619                        | 16-19ED2425     | Contract Approved | Contract Approved | 63169.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [AA_LA]  | ?    | ?                   |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10001800 | 1619-AS-2425-Contract-Provider-10001800-3_7             | 3_7            | AS-2425 | 1619                        | 63169.00    | [AA_LA]         | ContractApproved  | ContractApproved                  |
#
#    # Check that the CRM Funding Allocation Workflow History includes an approval
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | 1619-AS-2425-Contract-Provider-10001800-3_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '5' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
#    | 10001800 | [ContractNo]   | 1               | [AllocRef_16ED]  | 19              | 0                     | 6899.00      | 0             | 0        | 16-19 Bursary Funds                                                   | ?                           |
#    | 10001800 | [ContractNo]   | 1               | [AllocRef_16ED]  | 31              | 0                     | 21458.00     | 0             | 0        | 16-19 Free Meals                                                      | ?                           |
#    | 10001800 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 11338.00     | 0             | 0        | 16-19 High Needs Element 2                                            | ?                           |
#    | 10001800 | [ContractNo]   | 1               | [AllocRef_16ED]  | 914             | 0                     | 11441.00     | 0             | 0        | 16-19 Advanced Maths Premium                                          | ?                           |
#    | 10001800 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 3011.00      | 0             | 0        | Teacher's Pension Scheme 1619                                         | ?                           |
#
#
#
#    
#    
#    # Payment Batch for 1619ED2425(PoP)
#
#    # Change the date
#    Given the override date is '03/10/2023 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod '1619ED2425' AccountingPaymentPeriod '202307' CensusEndDate '03/10/2023' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_16ED]          | 202310 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | 1619ED2425                 | 202310               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | 1619ED2425                 | 202310               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod '1619ED2425' PaymentPeriod '202307' CensusEndDate '03/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S800.xml'
#
##    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
##    And   the Payment feed xml for FundingStreamPeriod '1619ED2425' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' includes the following values
##    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
##    | NLG                    | 2023          | 05             | 02          | ?       | [AllocRef_16ED]           | 562.00          | PROFILE          | Principals Ref Group               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208100    |
##    | NLG                    | 2023          | 05             | 02          | ?       | [AllocRef_16ED]           | 448.00          | PROFILE          | NationalLeadrs of FE               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208200    |
##    | NLG                    | 2023          | 05             | 02          | ?       | [AllocRef_16ED]           | 25.00           | PROFILE          | Isles of Scilly                    | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2202070    |
##
#
#
#    
#   #  Create Consolidated Payment Summary rpt
#   
#   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#   Given there are no files prefixed '2023-10 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
#
#   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '04/10/2023'
#    # Check the above report manually
#
#    
#   

    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table




@AcceptanceTest @Complete
@CFS
Scenario: S729 Import a 1619ED2425 FA for a nonsense ProviderType and ProviderSubType for override UKPRN 10044729. LA AA. Release and approve. Check docs, CRM, PaaS and Feed

    # 10044729 is an exception provider listed in the Provider Category Exceptions tab of the config spreadsheet
    # In 21/22, exception provider 10088193 was tested by A171. 
    # In 22/23, exception provider 10039859 was tested by A383. 
    # S729 is being added because 10044729 introduces a new Provider Category: Employer 

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10044729'
    And   there is no Funding Allocation data in CRM for UKPRN '10044729'
    And   there is no Contract, Task or Workflow data for UKPRN '10044729'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10044729'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10044729'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10044729' in the Sharepoint 'EDSK-2526-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            			|
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (Employer)         |


    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10044729' 
    And   there is no caseload advisor for UKPRN '10044729' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10044729 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10044729' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10044729 Co Ltd' with UKPRN '10044729' and OrgId 'ORG0044729' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10044729 | 141729 | 10044729 Co Ltd | 0              | Active                | Yes           | AA031729      | ?             | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10044729 |




    # Populate the stub with 1619 (Further education) data

    # Change the date 
    Given the override date is '01/07/2025'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10044729 | 1619-AS-2526-Contract-Provider-10044729-3_7           | 3_7            | 1619                        | AS-2526            | 63169.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType   | ProviderSubType     | ProviderFundingTotalValue |
    | 1619-AS-2526-10044729-3_7  | 3_7                    | 1619-AS-2526-Contract-Provider-10044729-3_7           | 10044729      | Nonsense       | Rubbish             | 63169.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2526-10044729-3_7  | 1619-002        | 6899.00          | Payment         |
    | 1619-AS-2526-10044729-3_7  | 1619-005        | 21458.00         | Payment         |
    | 1619-AS-2526-10044729-3_7  | 1619-006        | 11338.00         | Payment         |
    | 1619-AS-2526-10044729-3_7  | 1619-008        | 11441.00         | Payment         |
    | 1619-AS-2526-10044729-3_7  | 1619-010        | 3011.00          | Payment         |
    | 1619-AS-2526-10044729-3_7  | 1619-026        | 4011.00          | Payment         |
    | 1619-AS-2526-10044729-3_7  | 1619-027        | 5011.00          | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2526-10044729-3_7  | 1619-002        | FY-2526              | October                | 2025              | 2488.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-002        | FY-2526              | March                  | 2026              | 4411.00                   |
    #
    | 1619-AS-2526-10044729-3_7  | 1619-005        | FY-2526              | October                | 2025              | 5280.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-005        | FY-2526              | January                | 2026              | 3784.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-005        | FY-2526              | February               | 2026              | 4270.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-005        | FY-2526              | May                    | 2026              | 5750.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-005        | FY-2526              | July                   | 2026              | 2374.00                   |
    #
    | 1619-AS-2526-10044729-3_7  | 1619-006        | FY-2526              | October                | 2025              | 4319.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-006        | FY-2526              | February               | 2026              | 4874.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-006        | FY-2526              | April                  | 2026              | 2145.00                   |
    #
    | 1619-AS-2526-10044729-3_7  | 1619-008        | FY-2526              | September              | 2025              | 3007.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-008        | FY-2526              | December               | 2025              | 4588.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-008        | FY-2526              | April                  | 2026              | 3846.00                   |
    #
    | 1619-AS-2526-10044729-3_7  | 1619-010        | FY-2526              | July                   | 2026              | 3011.00                   |
    #
    | 1619-AS-2526-10044729-3_7  | 1619-026        | FY-2526              | October                | 2025              | 3011.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-026        | FY-2526              | December               | 2025              | 1000.00                   |
    #
    | 1619-AS-2526-10044729-3_7  | 1619-027        | FY-2526              | October                | 2025              | 3011.00                   |
    | 1619-AS-2526-10044729-3_7  | 1619-027        | FY-2526              | April                  | 2026              | 2000.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                          			| ReleaseGroupParameterName |
    | EDSK            | AY2526        | 16-19ED2526  | Conditions of Funding (Grant) (Employer)         | CofG_Employer             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_Employer = [CofG_Employer]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10044729 | 10044729 Co Ltd  | 1619-AS-2526-Contract-Provider-10044729-3_7             | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (Employer)            | 1619                        | 16-19ED2526     | Scheduling        | Awaiting Release  | 63169.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_Employer]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2526-Contract-Provider-10044729-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_Employer]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 63169.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10044729 | 1619-AS-2526-Contract-Provider-10044729-3_7             | 3_7            | AS-2526 | 1619                        | 63169.00    | [CofG_Employer]    | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_Employer]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'



    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '04/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_Employer]           |

    Then wait '60' seconds

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_Employer = [CofG_Employer]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_Employer]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 63169.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10044729' for FundingType 'EDSK' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10044729' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

#    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                           | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10044729 | 10044729 Co Ltd  | 1619-AS-2526-Contract-Provider-10044729-3_7             | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (Employer)          | 1619                        | 16-19ED2526     | Released          | Released          | 63169.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_Employer]         | ?          | ?                   |
#
#    # Check the CRM Funding Allocation Workflow History data
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | 1619-AS-2526-Contract-Provider-10044729-3_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#    | 1619-AS-2526-Contract-Provider-10044729-3_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10044729 | 1619-AS-2526-Contract-Provider-10044729-3_7             | 3_7            | AS-2526 | 1619                        | 63169.00    | [CofG_Employer]         | ?                 | ?                                 |
#
#    # Check PaaS FundingAllocation.Contract
#    And   the following Funding Allocations and Contracts are linked in PaaS
#    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
#    | 1619-AS-2526-Contract-Provider-10044729-3_7             | [ContractNo] | 1               | 0                  | Yes            |
#
#    # Check PaaS FundingAllocation.ReleaseGroup
#    And   Release Group '[CofG_Employer]' in FundingAllocation.ReleaseGroup has a status of 'Released'
#
#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10044729 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
#    | 10044729 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#
##
##    Given the override date is '06/07/2023'
##    And   a file with filename '10001800_[ContractNo]_v1.pdf' is created in 'EDSK-2526-Input-Appendices'
##    And  the contract sub-status is updated to 'Awaiting Documentation' on the latest version of contract '[ContractNo]'
##    And the TaskOwner is updated to 'Document Management Team' on the latest version of contract '[ContractNo]'
#
#
#    # Check that the Contract and Master Contract have been created correctly in CRM
#    And   the following Contracts exist in CRM
#    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
#    | 10044729 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 63169.00      | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Conditions of Funding (Grant) (Employer)             | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2526 | ?               | 10044729 Co Ltd  | Active | Document Management Team  | ?                      |
#    | 10044729 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Conditions of Funding (Grant) (Employer)             | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10044729 Co Ltd  | Active | CRM Integration           | ?                      |
#
#    # Check that the Contract Allocations have been created correctly in CRM
#    And   the following Contract Allocations exist in CRM
#    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
#    | 10044729 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 63169.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | 1619ED        | 1619ED2425          | Contract Allocation   | ?                        |
#
#    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
#    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
#    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                                       | DeliverableDescription   |
#    | [ContractNo]   | [AllocRef_16ED] | 19              | 6899.00   | 0.00     | 0.00     | 2488.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Bursary Funds                                                   |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 31              | 21458.00  | 0.00     | 0.00     | 5280.00  | 0.00     | 0.00     | 3784.00  | 4270.00  | 0.00     | 0.00     | 5750.00  | 0.00     | 2374.00  | 16-19 Free Meals                                                      |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 22              | 11338.00  | 0.00     | 0.00     | 4319.00  | 0.00     | 0.00     | 0.00     | 4874.00  | 0.00     | 2145.00  | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                                            |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 914             | 11441.00  | 0.00     | 3007.00  | 0.00     | 0.00     | 4588.00  | 0.00     | 0.00     | 0.00     | 3846.00  | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                          |                          |
#    | [ContractNo]   | [AllocRef_16ED] | 125             | 3011.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3011.00  | Teacher's Pension Scheme 1619                                         |                          |
#
#    # Contract is now at 'Draft\Awaiting Documentation'
#
#    # Check the deliverable count in CRM
#    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
##
##    # Check the contents of the Appendices
##    And   the file named '10001800_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
##    """
##    SUMMARY OF FUNDING 2023/24
##    Organisation Name: 10044729 Co Ltd UKPRN: 10044729
##    Master Contract Number: [MasterContractNo]
##    Allocation
##    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
##    16 to 19 Education [AllocRef_16ED] £37,021 £17,126 £54,147
##    Total Funding for this contract: £54,147
##    Summary of Funding – Page 1
##    
##    Agreement Type Accountability Agreement (Local Authorities)
##    st st
##    Funding Period 1 August 2023 to 31 July 2024
##    Between the Secretary of State for Education
##    And 10044729 Co Ltd
##    Funding for 16 to 19 Education
##    Master Agreement Number [MasterContractNo]
##    ACCEPTANCE BY THE PROVIDER
##    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
##    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
##    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
##    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
##    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
##    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
##    SIGNED FOR AND ON BEHALF OF
##    THE SECRETARY OF STATE FOR EDUCATION
##    by David Withey, Chief Executive of the Education and Skills Funding Agency
##    Conditions of Funding (Grant) (Employer) Version 1 (April 2023) Page 1
##    This Agreement is made on the date the Agreement is digitally signed by the
##    Provider on the Manage Your Education & Skills Funding Service between:
##    10044729 Co Ltd THE SECRETARY OF STATE FOR
##    96 West Yard EDUCATION
##    Camden Lock Place DEPARTMENT FOR EDUCATION
##    Chalk Farm Road 20 GREAT SMITH STREET
##    AND
##    London LONDON
##    NW1 8AF SW1P 3BT
##    Company No: AA031729
##    Hereinafter called Hereinafter called
##    the Provider the Department
##    Conditions of Funding (Grant) (Employer) Version 1 (April 2023) Page 2
##    Conditions of Funding (Grant) (Employer) Version 1 (April 2023) Page 73
##
##    EDSK2324_S2_1619ED_AA_LA_2023_08_01
##    EDSK2324_S3_1619ED_AA_LA_2023_08_01
##
##
##    SCHEDULE 2 – 16 TO 19 EDUCATION
##    Funding Agreement – 16 to 19 Education
##    Provider: 10044729 Co Ltd UKPRN: 10044729
##    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
##    Contract Ref: [AllocRef_16ED]
##    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
##    16-19 Bursary Funds £6,899 £0.00 £0.00 £2,488.00 £0.00 £0.00 £0.00 £0.00 £4,411.00 £0.00 £0.00 £0.00 £0.00
##    16-19 High Needs Element 2 £11,338 £0.00 £0.00 £4,319.00 £0.00 £0.00 £0.00 £4,874.00 £0.00 £2,145.00 £0.00 £0.00 £0.00
##    16-19 Free Meals £21,458 £0.00 £0.00 £5,280.00 £0.00 £0.00 £3,784.00 £4,270.00 £0.00 £0.00 £5,750.00 £0.00 £2,374.00
##    16-19 Advanced Maths Premium £11,441 £0.00 £3,007.00 £0.00 £0.00 £4,588.00 £0.00 £0.00 £0.00 £3,846.00 £0.00 £0.00 £0.00
##    Teacher's Pension Scheme 1619 £3,011 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,011.00
##    Total Funding £54,147 £0.00 £3,007.00 £12,087.00 £0.00 £4,588.00 £3,784.00 £9,144.00 £4,411.00 £5,991.00 £5,750.00 £0.00 £5,385.00
##    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
##    
##    Schedule 4 Version 1 (April 2023) – Page 2
##    Schedule 5 Version 1 (April 2023) – Page 8
##    Schedule 6 Version 1 (April 2023) – Page 5
##    Schedule 7 Version 1 (April 2023) – Page 1
##    Schedule 8 Version 1 (April 2023) – Page 5
##    Schedule 9 Version 1 (April 2023) – Page 1
##    """
#
#
#
##    
##    EDSK Version 2 (July 2023) Page 2
##    EDSK Version 2 (July 2023) Page 73
##
##    SCHEDULE 1: SPECIFICATION & MONITORING
##    16-19 EDUCATION SPECIFICATION
##    EDSK Schedule 1 – 16 to 19 Education Version 1 Trust (July 2023) – Page 1
##    EDSK Schedule 1 – 16 to 19 Education Version 1 Trust (July 2023) – Page 10
##
##    SCHEDULE 2: PAYMENT
##    16-19 EDUCATION PAYMENT
##    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2023) – Page 1
##
##    SCHEDULE 3: NOT USED
##    EDSK Schedule 3 Version 2 (July 2023) – Page 1
##    EDSK Schedule 9 Version 2 (July 2023) – Page 5
#
#
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#    And   Sharepoint file '10001800_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10001800_[ContractNo]_v1.pdf'
#
#    # Remove all details from ContractManagement.CreatedContract for a contract
# #  Given there are no created contracts for this number '[ContractNo]'
#    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'
#
#    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
#    #   Note: Documents are created using the system date. The following step 'corrects' this
#    And   the following document creation details exist in the ContractManagement.CreatedContract table
#    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
#    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |
#
#    # Check the current state of the Tasks for this contract
#    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10044729'
#    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
#    | Initiate Document Merge   | 10044729 - 10044729 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |
#
#    # Check the CRM Contract Workflow History data
#    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
#    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
#   #| 10044729 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#   #| 10044729 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#    | 10044729 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#
#
#
#
#
#    # Publish the contract
#
#    # Change the date 
#    Given the override date is '07/07/2024'
#
# #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
# #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
# #  or
#    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
#    And   a file with filename '10001800_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
#    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
#    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table
#
#    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10044729 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
#    | 10044729 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#
#
#
#
#
#    # Approve the contract
#
#    # Change the date 
#    Given the override date is '09/07/2024'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10044729 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
#    | 10044729 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#
#    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
#    And   the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
#    | 10044729 | 10044729 Co Ltd  | 1619-AS-2526-Contract-Provider-10044729-3_7             | 3_7            | Education & Skills Funding | AY2526  | Conditions of Funding (Grant) (Employer)            | 1619                        | 16-19ED2526     | Contract Approved | Contract Approved | 63169.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_Employer]  | ?    | ?                   |
#
#    # Check PaaS FundingAllocation.FundingAllocation (J131)
#    And   the following Funding Allocations data is present in PaaS
#    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
#    | 10044729 | 1619-AS-2526-Contract-Provider-10044729-3_7             | 3_7            | AS-2526 | 1619                        | 63169.00    | [CofG_Employer]         | ContractApproved  | ContractApproved                  |
#
#    # Check that the CRM Funding Allocation Workflow History includes an approval
#    And   the following Funding Allocation Workflow History data is present in CRM
#    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
#    | 1619-AS-2526-Contract-Provider-10044729-3_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '5' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
#    | 10044729 | [ContractNo]   | 1               | [AllocRef_16ED]  | 19              | 0                     | 6899.00      | 0             | 0        | 16-19 Bursary Funds                                                   | ?                           |
#    | 10044729 | [ContractNo]   | 1               | [AllocRef_16ED]  | 31              | 0                     | 21458.00     | 0             | 0        | 16-19 Free Meals                                                      | ?                           |
#    | 10044729 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 11338.00     | 0             | 0        | 16-19 High Needs Element 2                                            | ?                           |
#    | 10044729 | [ContractNo]   | 1               | [AllocRef_16ED]  | 914             | 0                     | 11441.00     | 0             | 0        | 16-19 Advanced Maths Premium                                          | ?                           |
#    | 10044729 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 3011.00      | 0             | 0        | Teacher's Pension Scheme 1619                                         | ?                           |
#
#
#
#    
#    
#    # Payment Batch for 1619ED2425(PoP)
#
#    # Change the date
#    Given the override date is '03/10/2023 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod '1619ED2425' AccountingPaymentPeriod '202307' CensusEndDate '03/10/2023' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_16ED]          | 202310 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | 1619ED2425                 | 202310               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | 1619ED2425                 | 202310               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod '1619ED2425' PaymentPeriod '202307' CensusEndDate '03/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S729.xml'
#
##    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
##    And   the Payment feed xml for FundingStreamPeriod '1619ED2425' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' includes the following values
##    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
##    | NLG                    | 2023          | 05             | 02          | ?       | [AllocRef_16ED]           | 562.00          | PROFILE          | Principals Ref Group               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208100    |
##    | NLG                    | 2023          | 05             | 02          | ?       | [AllocRef_16ED]           | 448.00          | PROFILE          | NationalLeadrs of FE               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208200    |
##    | NLG                    | 2023          | 05             | 02          | ?       | [AllocRef_16ED]           | 25.00           | PROFILE          | Isles of Scilly                    | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2202070    |
##
#
#
#    
#   #  Create Consolidated Payment Summary rpt
#   
#   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#   Given there are no files prefixed '2023-10 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
#
#   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '04/10/2023'
#    # Check the above report manually
#
#    
#   

    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
