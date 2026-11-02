Feature: AmendmentType2 34055

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A164 Inject and release DADA2122 FA. Approve. Various amendments to financials. NFA. Amendment Type both Variation and Notification

    #  1. Import FA v1_1 to create draft contract v1 (a)
    #  2. Publish and approve contract v1
    #  3. NFA variation amendment to create contract v2 (b)
    #  4. Import FA v2_2 with reduced funding in both envelopes and create contract v2.1 (c)
    #  5. Delete draft contract v2 (d)
    #  6. Re-release FA v2_2 and create draft amendment v2.2 (e)
    #  7. Delete draft amendment v2.0 and withdraw FA v2_2 (f)
    #  8. Simulate a new version of the TAC template (g)
    #  9. Import FA v3_3 with funding > v2_2 but < v1_1 (h)
    # 10. Publish and approve contract v2 (i)
    # 11. Import FA v4_4 with funding up and down by same amount in different funding envelopes (j)
    # 12. Publish and approve contract v3 (k)
    # 13. Import FA 5_5 with increased funding (l)

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017164'
    And   there is no Funding Allocation data in CRM for UKPRN '10017164'
    And   there is no Contract, Task or Workflow data for UKPRN '10017164'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications of type 'Draft Contract Updated' 
    And   there are no notifications of type 'Contract Withdrawn'
    And   there are no notifications of type 'Approval Received'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017164' in the Sharepoint 'DADA-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   |


    # Set the base timestamp for each of the 21\22 DADA document templates (DocumentsDomain.UploadedDocumentTemplate) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_DADA_2020-08-01.docx                        | 2020-05-20 07:00:00.000 | 
    | DADA2020_2122_TAC_2021-08-01.docx               | 2021-06-03 07:00:00.000 | 
    | DADA2020_2122_S1_2021-08-01.docx                | 2021-06-03 07:00:00.000 | 
    | DADA2020_2122_S2_2021-08-01.docx                | 2021-06-03 07:00:00.000 | 
    | FA_DADA2122_2021-08-01.docx                     | 2021-06-03 07:00:00.000 | 
    | DADA2020_2122_S3ON_2021-08-01.docx              | 2021-06-03 07:00:00.000 | 



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017164' 
    And   there is no caseload advisor for UKPRN '10017164' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017164 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017164' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017164 Co Ltd' with UKPRN '10017164' and OrgId 'ORG0017164' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017164 | 117164 | 10017164 Co Ltd | 0              | In Administration     | Yes           | AA017164      | ?             | 27 Sandyford Place     | Glasgow                | ?                      | ?                      | ?                      | ?                      | G3 7NG    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017164 |







    # Populate the stub with DADA (07HEP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-1_1           | 1_1            | DADA                        | AY-2122            | 19228.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017164-1_1  | 1_1                    | DADA-AY-2122-Contract-Provider-10017164-1_1           | 10017164      | Furth        | 07HEP           | 19228.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017164-1_1  | DADA-001        | 19228.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017164-1_1  | DADA-001        | FY-2122              | August                 | 2021              | 2152.00                   |
    | DADA-AY-2122-10017164-1_1  | DADA-001        | FY-2122              | November               | 2021              | 4727.00                   |
    | DADA-AY-2122-10017164-1_1  | DADA-001        | FY-2122              | February               | 2022              | 2067.00                   |
    | DADA-AY-2122-10017164-1_1  | DADA-001        | FY-2122              | April                  | 2022              | 4983.00                   |
    | DADA-AY-2122-10017164-1_1  | DADA-001        | FY-2122              | July                   | 2022              | 5299.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS                       |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-1_1             | 1_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 19228.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS]             |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-1_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 19228.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-1_1             | 1_1            | AY-2122 | DADA                        | 19228.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

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
    | Released          | 1               | 19228.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017164' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017164' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-1_1             | 1_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 19228.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS]           |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-1_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release            | ?                             |
#   | DADA-AY-2122-Contract-Provider-10017164-1_1             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017164-1_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-1_1             | 1_1            | AY-2122 | DADA                        | 19228.00    | [CfS]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017164-1_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017164 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 19228.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services                     | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017164 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017164 | [MasterContractNo] | Dance and Drama Awards                 | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services                     | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017164 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017164 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 19228.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 19228.00  | 2152.00  | 0.00     | 0.00     | 4727.00  | 0.00     | 0.00     | 2067.00  | 0.00     | 4983.00  | 0.00     | 0.00     | 5299.00  | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the document parts (All six present)
    And   the file named '10017164_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £8,946 £10,282 £19,228
    Total: £19,228
    Total Funding for this contract: £19,228
    
    Agreement Type Contract for Services
    Funding Period 1 August 2020 to 31 July 2023
    Between the Secretary of State for Education
    And 10017164 Co Ltd
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    DaDA Version 2 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017164 Co Ltd THE SECRETARY OF STATE FOR
    27 Sandyford Place EDUCATION
    Glasgow DEPARTMENT FOR EDUCATION
    G3 7NG 20 GREAT SMITH STREET
    AND
    LONDON
    SW1P 3BT
    Company No: AA017164
    Hereinafter called Hereinafter called
    the Contractor the Department
    DaDA Version 2 (April 2022) Page 2
    DaDA Version 2 (April 2022) Page 77
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    DANCE AND DRAMA AWARDS (DaDA) SPECIFICATION
    DaDA Schedule 1 Version 1 (July 2021) – Page 1
    
    SCHEDULE 2: PAYMENT
    DANCE AND DRAMA AWARDS (DaDA) PAYMENT
    DaDA Schedule 2 Version 1 (July 2021) – Page 1
    
    SCHEDULE 2
    Funding Agreement
    Provider: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    DaDA Schedule 3 Version 1 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017164_[ContractNo]_v1.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A164_v1.0.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |





    # Step 2: Publish and approve contract v1

    # Change the date 
    Given the override date is '06/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-1_1             | 1_1            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Contract Approved | Contract Approved | 19228.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CfS]           |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-1_1             | 1_1            | AY-2122 | DADA                        | 19228.00    | [CfS]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-1_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017164 | [ContractNo]   | 1               | [AllocRef_DADA]  | 1               | 0                     | 19228.00     | 0             | 0        | Dance and Drama Awards Scheme                  | ?                           |





    # Step 3: NFA variation amendment to create contract v2 (b)

    # Change the date 
    Given the override date is '07/07/2021'

    # Issue a non-financial amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the document parts (SoF)
    And   the file named '10017164_[ContractNo]_v2.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £8,946 £10,282 £19,228
    Total: £19,228
    Total Funding for this contract: £19,228
    """
    
    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017164_[ContractNo]_v2.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A164_v2.0a.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-07-08 09:12:35.000 |





    # Step 4: Import FA v2_2 with reduced funding in both envelopes (c)

    # Change the date 
    Given the override date is '08/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with DADA (07HEP) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-2_2           | 2_2            | DADA                        | AY-2122            | 17228.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017164-2_2  | 2_2                    | DADA-AY-2122-Contract-Provider-10017164-2_2           | 10017164      | Furth        | 07HEP           | 17228.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017164-2_2  | DADA-001        | 17228.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017164-2_2  | DADA-001        | FY-2122              | August                 | 2021              | 1152.00                   |
    | DADA-AY-2122-10017164-2_2  | DADA-001        | FY-2122              | November               | 2021              | 4727.00                   |
    | DADA-AY-2122-10017164-2_2  | DADA-001        | FY-2122              | February               | 2022              | 2067.00                   |
    | DADA-AY-2122-10017164-2_2  | DADA-001        | FY-2122              | April                  | 2022              | 4983.00                   |
    | DADA-AY-2122-10017164-2_2  | DADA-001        | FY-2122              | July                   | 2022              | 4299.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '09/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS2                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-2_2             | 2_2            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 17228.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS2]            |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-2_2             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 17228.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-2_2             | 2_2            | AY-2122 | DADA                        | 17228.00    | [CfS2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '10/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS2]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS2 = [CfS2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 17228.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017164' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017164' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-2_2             | 2_2            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 17228.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS2]          |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-2_2             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | DADA-AY-2122-Contract-Provider-10017164-2_2             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017164-2_2             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-2_2             | 2_2            | AY-2122 | DADA                        | 17228.00    | [CfS2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017164-2_2             | [ContractNo] | 2               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 2                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017164 | [ContractNo]       | 2                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017164 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 17228.00      | 2                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2 TEST     | Contract for Services                     | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017164 Co Ltd  | Active | Document Management Team  | -2000.00               |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017164 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 17228.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | -2000.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 17228.00  | 1152.00  | 0.00     | 0.00     | 4727.00  | 0.00     | 0.00     | 2067.00  | 0.00     | 4983.00  | 0.00     | 0.00     | 4299.00  | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the document parts
    And   the file named '10017164_[ContractNo]_v2.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £7,946 £9,282 £17,228
    Total: £17,228
    Total Funding for this contract: £17,228

    SCHEDULE 2
    Funding Agreement
    Provider: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017164_[ContractNo]_v2.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A164_v2.1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 1                        | 2021-07-11 09:12:35.000 |





    # Step 5: Delete all versions and subversions of draft contract v2 (d)

    # Change the date
    Given the override date is '11/07/2021'
    
    # Trigger WF28 in CRM to issue a delete request against v2 of the contract (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017164 | [ContractNo]   | 2                     | 1                  |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125) This is a 'wait' to ensure CRM is ready before issuing the reinstatement
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                             | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-2_2           | 2_2            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Returned to Scheduling  | 17228.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         |

    # Check that the RG has been dis-associated from the FA in PaaS.   This is a 'wait' too.
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-2_2             | 2_2            | AY-2122 | DADA                        | 17228.00    | ?               |  ?                | ?                                 |





    # Step 6: Re-instate and re-release FA v2_2 (e)

    # Change the date 
    Given the override date is '12/07/2021'

    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocation                
    |  FundingId                                    |
    |  DADA-AY-2122-Contract-Provider-10017164-2_2  |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services   | CfS3                      |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS3 = [CfS3]' is written to the Output window

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CfS3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 17228.00        |

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS3]            |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 17228.00        |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Notification  |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Step 7: Delete draft amendment v2.0 and withdraw FA v2_2 (f)

    # Change the date 
    Given the override date is '13/07/2021'

    # Trigger WF28 in CRM to issue a delete request against v2 of the contract (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017164 | [ContractNo]   | 2                     | 0                  |

    # Check the CONTRACT version, status and dates in CRM  (v1.0 is now the latest)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  (This is a 'wait' to ensure CRM is ready before withdrawing the FA)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                             | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-2_2           | 2_2            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Returned to Scheduling  | 17228.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         |

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
    | FundingId                                     | 
    | DADA-AY-2122-Contract-Provider-10017164-2_2   | 

    # Check that the FA in PaaS is withdrawn

    # Check PaaS FundingAllocation.FundingAllocation (J131)   (Disassociate FA from RG and mark FA as withdrawn)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-2_2             | 2_2            | AY-2122 | DADA                        | 17228.00    | ?               | Withdrawn         | Withdrawn                         |





    # Step 8: Simulate a new version of the TaC template (g)

    # Change the date 
    Given the override date is '14/07/2021'

    # Update the timestamp on the TaC template to a date after contract v1 was created on 05/07/2021 (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | DADA2020_2122_TAC_2021-08-01.docx               | 2021-07-06 09:45:15.000 | 

    
    

    
    # Step 9: Import FA v3_3 with funding > v2_2 but < v1_1 (h)   

    # Change the date 
    Given the override date is '15/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with DADA (07HEP) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-3_3           | 3_3            | DADA                        | AY-2122            | 18228.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017164-3_3  | 3_3                    | DADA-AY-2122-Contract-Provider-10017164-3_3           | 10017164      | Furth        | 07HEP           | 18228.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017164-3_3  | DADA-001        | 18228.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017164-3_3  | DADA-001        | FY-2122              | August                 | 2021              | 1652.00                   |
    | DADA-AY-2122-10017164-3_3  | DADA-001        | FY-2122              | November               | 2021              | 4727.00                   |
    | DADA-AY-2122-10017164-3_3  | DADA-001        | FY-2122              | February               | 2022              | 2067.00                   |
    | DADA-AY-2122-10017164-3_3  | DADA-001        | FY-2122              | April                  | 2022              | 4983.00                   |
    | DADA-AY-2122-10017164-3_3  | DADA-001        | FY-2122              | July                   | 2022              | 4799.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '16/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS4                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-3_3             | 3_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 18228.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS4]            |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS4]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18228.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-3_3             | 3_3            | AY-2122 | DADA                        | 18228.00    | [CfS4]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS4]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '17/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS4]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS4 = [CfS4]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS4]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 18228.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017164' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017164' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-3_3             | 3_3            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 18228.00    | [ContractNo]  | 3                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS4]          |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-3_3             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | DADA-AY-2122-Contract-Provider-10017164-3_3             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017164-3_3             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-3_3             | 3_3            | AY-2122 | DADA                        | 18228.00    | [CfS4]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017164-3_3             | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS4]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Notification  |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017164 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 18228.00      | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2 TEST     | Contract for Services                     | ?                        | Notification  | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017164 Co Ltd  | Active | Document Management Team  | -1000.00               |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017164 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 18228.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | -1000.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 18228.00  | 1652.00  | 0.00     | 0.00     | 4727.00  | 0.00     | 0.00     | 2067.00  | 0.00     | 4983.00  | 0.00     | 0.00     | 4799.00  | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the document parts
    And   the file named '10017164_[ContractNo]_v2.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £8,446 £9,782 £18,228
    Total: £18,228
    Total Funding for this contract: £18,228

    SCHEDULE 2
    Funding Agreement
    Provider: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    """

    # There shouldn't be a TAC document - even though a new version has of it has been added
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """


    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017164_[ContractNo]_v2.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A164_v2.0b.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-07-17 09:12:35.000 |





    # Step 10: Publish and approve contract v2 (i)

    # Change the date 
    Given the override date is '18/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Notification  |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Step 11: Import FA v4_4 with funding up and down by same amount in different funding envelopes (j)

    # Change the date 
    Given the override date is '19/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with DADA (07HEP) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-4_4           | 4_4            | DADA                        | AY-2122            | 18228.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017164-4_4  | 4_4                    | DADA-AY-2122-Contract-Provider-10017164-4_4           | 10017164      | Furth        | 07HEP           | 18228.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017164-4_4  | DADA-001        | 18228.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017164-4_4  | DADA-001        | FY-2122              | August                 | 2021              | 1727.00                   |
    | DADA-AY-2122-10017164-4_4  | DADA-001        | FY-2122              | November               | 2021              | 4727.00                   |
    | DADA-AY-2122-10017164-4_4  | DADA-001        | FY-2122              | February               | 2022              | 2067.00                   |
    | DADA-AY-2122-10017164-4_4  | DADA-001        | FY-2122              | April                  | 2022              | 4983.00                   |
    | DADA-AY-2122-10017164-4_4  | DADA-001        | FY-2122              | July                   | 2022              | 4724.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '20/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS5                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-4_4             | 4_4            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 18228.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS5]            |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-4_4             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS5]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18228.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-4_4             | 4_4            | AY-2122 | DADA                        | 18228.00    | [CfS5]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS5]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '21/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS5]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS5 = [CfS5]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS5]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 18228.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017164' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017164' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-4_4             | 4_4            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 18228.00    | [ContractNo]  | 3                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS5]          |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-4_4             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | DADA-AY-2122-Contract-Provider-10017164-4_4             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017164-4_4             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-4_4             | 4_4            | AY-2122 | DADA                        | 18228.00    | [CfS5]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017164-4_4             | [ContractNo] | 3               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS5]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017164 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | Notification  |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017164 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 18228.00      | 3                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2 TEST     | Contract for Services                     | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017164 Co Ltd  | Active | Document Management Team  | 0.00                   |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017164 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 18228.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | 0.00                     |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 18228.00  | 1727.00  | 0.00     | 0.00     | 4727.00  | 0.00     | 0.00     | 2067.00  | 0.00     | 4983.00  | 0.00     | 0.00     | 4724.00  | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the document parts (SoF, TaC (new version) and FA)
    And   the file named '10017164_[ContractNo]_v3.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £8,521 £9,707 £18,228
    Total: £18,228
    Total Funding for this contract: £18,228

    Agreement Type Contract for Services
    Funding Period 1 August 2020 to 31 July 2023
    Between the Secretary of State for Education
    And 10017164 Co Ltd
    Master Contract Number [MasterContractNo]
    DaDA Version 2 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017164 Co Ltd THE SECRETARY OF STATE FOR
    27 Sandyford Place EDUCATION
    Glasgow DEPARTMENT FOR EDUCATION
    G3 7NG 20 GREAT SMITH STREET
    AND
    LONDON
    SW1P 3BT
    Company No: AA017164
    Hereinafter called Hereinafter called
    the Contractor the Department
    DaDA Version 2 (April 2022) Page 2
    DaDA Version 2 (April 2022) Page 77

    SCHEDULE 2
    Funding Agreement
    Provider: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017164_[ContractNo]_v3.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A164_v3.0.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 3                     | 0                        | 2021-07-21 09:12:35.000 |





    # Step 12: Publish and approve contract v2 (k)

    # Change the date 
    Given the override date is '22/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017164 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | Notification  |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Step 13: Import FA 5_5 with increased funding (l)

    # Change the date 
    Given the override date is '23/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with DADA (07HEP) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-5_5           | 5_5            | DADA                        | AY-2122            | 28228.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AY-2122-10017164-5_5  | 5_5                    | DADA-AY-2122-Contract-Provider-10017164-5_5           | 10017164      | Furth        | 07HEP           | 28228.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AY-2122-10017164-5_5  | DADA-001        | 28228.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AY-2122-10017164-5_5  | DADA-001        | FY-2122              | August                 | 2021              | 1727.00                   |
    | DADA-AY-2122-10017164-5_5  | DADA-001        | FY-2122              | November               | 2021              | 4727.00                   |
    | DADA-AY-2122-10017164-5_5  | DADA-001        | FY-2122              | February               | 2022              | 12067.00                  |
    | DADA-AY-2122-10017164-5_5  | DADA-001        | FY-2122              | April                  | 2022              | 4983.00                   |
    | DADA-AY-2122-10017164-5_5  | DADA-001        | FY-2122              | July                   | 2022              | 4724.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '24/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2122        | DADA2122     | Contract for Services                   | CfS6                      |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-5_5             | 5_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Scheduling        | Awaiting Release  | 28228.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS6]            |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-5_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS6]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 28228.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-5_5             | 5_5            | AY-2122 | DADA                        | 28228.00    | [CfS6]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS6]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '25/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS6]            |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS6 = [CfS6]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS6]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 28228.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017164' for FundingType 'DADA' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017164' for FundingType 'DADA' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017164 | 10017164 Co Ltd  | DADA-AY-2122-Contract-Provider-10017164-5_5             | 5_5            | Dance and Drama Awards     | AY2122  | Contract for Services                    | DADA                        | DADA2122        | Released          | Released          | 28228.00    | [ContractNo]  | 4                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS6]          |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | DADA-AY-2122-Contract-Provider-10017164-5_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | DADA-AY-2122-Contract-Provider-10017164-5_5             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | DADA-AY-2122-Contract-Provider-10017164-5_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017164 | DADA-AY-2122-Contract-Provider-10017164-5_5             | 5_5            | AY-2122 | DADA                        | 28228.00    | [CfS6]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | DADA-AY-2122-Contract-Provider-10017164-5_5             | [ContractNo] | 4               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS6]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017164 | [ContractNo]       | 4                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017164 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017164 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | Notification  |
    | 10017164 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017164 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract has been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017164 | [ContractNo]       | Dance and Drama Awards                 | Contract      | Draft          | Awaiting Documentation  | 28228.00      | 4                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2 TEST     | Contract for Services                     | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | [ContractNo]    | 10017164 Co Ltd  | Active | Document Management Team  | 10000.00               |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017164 | [ContractNo]       | [AllocRef_DADA]       | ?                             | 28228.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | DADA          | DADA2122            | Contract Allocation   | 10000.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_DADA] | 1               | 28228.00  | 1727.00  | 0.00     | 0.00     | 4727.00  | 0.00     | 0.00     | 12067.00 | 0.00     | 4983.00  | 0.00     | 0.00     | 4724.00  | Dance and Drama Awards Scheme                               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the document parts (SoF, FA)
    And   the file named '10017164_[ContractNo]_v4.pdf' in Sharepoint location 'DADA-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £18,521 £9,707 £28,228
    Total: £28,228
    Total Funding for this contract: £28,228

    SCHEDULE 2
    Funding Agreement
    Provider: 10017164 Co Ltd UKPRN: 10017164
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017164_[ContractNo]_v4.pdf' in 'DADA-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A164_v4.0.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 4                     | 0                        | 2021-07-25 09:12:35.000 |


    # Tidy Up
    Given the override date is reset
     
