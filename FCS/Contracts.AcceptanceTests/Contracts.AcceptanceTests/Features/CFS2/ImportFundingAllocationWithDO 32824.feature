Feature: ImportFundingAllocationWithDO 32824

@AcceptanceTest @Withdrawn20230123
@CFS
Scenario: A622 Import and release two CFS FA's (mix of 1619 and NFF) for a Local Authority (without Funding) to create an EDSK2021 contract with 2 Delivery Orgs and full CFS code mapping. Check CRM, docs, contract details and feed

    #  Contracting Org 10017622 - no funding 
    #   Delivery Org 1 10018021 - 1619    
    #   Delivery Org 2 10019145 - NFF    

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017622'
    And   there is no Funding Allocation data in CRM for UKPRN '10017622'
    And   there is no Contract, Task or Workflow data for UKPRN '10017622'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017622'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017622'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017622' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017622' 
    And   there is no Organisation data for UKPRN '10018021' 
    And   there is no Organisation data for UKPRN '10019145' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10017622 Co Ltd' with UKPRN '10017622' and OrgId 'ORG0017622' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status    | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017622 | 117622 | 10017622 Co Ltd | 0              | Active    | Yes           | AA017622      | ?             | 16 Council Street      | Bristol                | Avon                   | ?                      | ?                      | ?                      | BS1 6JJ   |
    | 10018021 | 118021 | 10018021 Co Ltd | 0              | Active    | Yes           | AA018021      | ?             | 34 College Gardens     | Bristol                | Avon                   | ?                      | ?                      | ?                      | BS6 9TY   |
    | 10019145 | 119145 | 10019145 Co Ltd | 0              | Active    | Yes           | AA019145      | ?             | 1 School Lane          | Bristol                | Avon                   | ?                      | ?                      | ?                      | BS11 4WE  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017622 |
    | 10018021 |
    | 10019145 |





    # Populate the stub

    # Change the date 
    Given the override date is '12/06/2021'

    # Funding Allocation (1) 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017622 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3  | 2_3            | 1619                        | AS-2122            | 42864.00          |

    # Provider Funding Allocation (1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10018021-2_3  | 2_3                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3  | 10018021      | Schoo        | 08SSF           | 42864.00                  |

    # Funding Allocation Line (aka Deliverable) (1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10018021-2_3  | 1619-001        | 2455.00          | Payment         |
    | 1619-AS-2122-10018021-2_3  | 1619-010        | 17173.00         | Payment         |
    | 1619-AS-2122-10018021-2_3  | 1619-020        | 23236.00         | Payment         |
    # non-Payment item (ignore)
    | 1619-AS-2122-10018021-2_3  | 1619-007        | 9816.00          | Adustment       |
    # zero-value item
    | 1619-AS-2122-10018021-2_3  | 1619-008        | 0.00             | Payment         |
    # null-value item (ignore)
    | 1619-AS-2122-10018021-2_3  | 1619-013        | ?                | Payment         |

    # Funding Allocation Profile Period (1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10018021-2_3  | 1619-001        | FY-2122              | May                    | 2022              | 2455.00                   |
    #
    | 1619-AS-2122-10018021-2_3  | 1619-010        | FY-2122              | September              | 2021              | 5467.00                   |
    | 1619-AS-2122-10018021-2_3  | 1619-010        | FY-2122              | January                | 2022              | 3528.00                   |
    | 1619-AS-2122-10018021-2_3  | 1619-010        | FY-2122              | March                  | 2022              | 3469.00                   |
    | 1619-AS-2122-10018021-2_3  | 1619-010        | FY-2122              | June                   | 2022              | 4709.00                   |
    #
    | 1619-AS-2122-10018021-2_3  | 1619-020        | FY-2122              | September              | 2021              | 4521.00                   |
    | 1619-AS-2122-10018021-2_3  | 1619-020        | FY-2122              | December               | 2021              | 3811.00                   |
    | 1619-AS-2122-10018021-2_3  | 1619-020        | FY-2122              | March                  | 2022              | 4879.00                   |
    | 1619-AS-2122-10018021-2_3  | 1619-020        | FY-2122              | April                  | 2022              | 5675.00                   |
    | 1619-AS-2122-10018021-2_3  | 1619-020        | FY-2122              | July                   | 2022              | 4350.00                   |
    # non-Payment item
    | 1619-AS-2122-10018021-2_3  | 1619-007        | FY-2122              | July                   | 2022              | 9816.00                   |
    # zero-value item
    | 1619-AS-2122-10018021-2_3  | 1619-008        | FY-2122              | March                  | 2022              | 0.00                      |
    # null-value item does not have Profile Period(s)





    # Funding Allocation (2) 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017622 | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2   | 4_2            | NFF                         | AS-2122            | 21430.00          |

    # Provider Funding Allocation (2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10019145-4_2   | 4_2                    | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2   | 10019145      | Schoo        | 08SSF           | 21430.00                  |

    # Funding Allocation Line (aka Deliverable) (2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10019145-4_2   | NFF-002         | 21430.00         | Payment         |
    | NFF-AS-2122-10019145-4_2   | NFF-004         | 9485.00          | Information     |

    # Funding Allocation Profile Period (2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10019145-4_2   | NFF-002         | FY-2122              | September              | 2021              | 3638.00                   |
    | NFF-AS-2122-10019145-4_2   | NFF-002         | FY-2122              | January                | 2022              | 3441.00                   |
    | NFF-AS-2122-10019145-4_2   | NFF-002         | FY-2122              | February               | 2022              | 9970.00                   |
    | NFF-AS-2122-10019145-4_2   | NFF-002         | FY-2122              | June                   | 2022              | 4381.00                   |
    #
    | NFF-AS-2122-10019145-4_2   | NFF-003         | FY-2122              | August                 | 2021              | 4088.00                   |
    | NFF-AS-2122-10019145-4_2   | NFF-003         | FY-2122              | May                    | 2022              | 5397.00                   |





    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017622 | 10017622 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3    | 2_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 42864.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017622 | 10017622 Co Ltd  | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2     | 4_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 21430.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3    | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2     | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |
    
    # Check PaaS FundingAllocation.FundingAllocation 
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017622 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3    | 2_3            | AS-2122 | 1619                        | 42864.00    | [CofG_LA]      |
    | 10017622 | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2     | 4_2            | AS-2122 | NFF                         | 21430.00    | [CofG_LA]      |





    # Release a Release Group (32333)

    # Change the date 
    Given the override date is '20/06/2021'

    # Display parameter value
    Then   message '[CofG_LA]' is written to the Output window

    # Check the state of a Release Group (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 64294.00        |

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |
    
    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 64294.00        |




    # Retrieve parameters from CRM for Delivery Org 10018021 
   #And   I retrieve the latest contract details from CRM for provider '10017622' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017622' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10018021' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017622 | 10017622 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3    | 2_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 42864.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |
    | 10017622 | 10017622 Co Ltd  | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2     | 4_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Released          | Released          | 21430.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3    | Release Successful   | CRM Integration   | Released       | Released             | Scheduling     | Awaiting Release     |
#   | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3    | Initiate Release     | CRM Integration   | In Release     | Release in Progress  | Scheduling     | Awaiting Release     |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3    | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    #
    | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2     | Release Successful   | CRM Integration   | Released       | Released             | Scheduling     | Awaiting Release     |
#   | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2     | Initiate Release     | CRM Integration   | In Release     | Release in Progress  | Scheduling     | Awaiting Release     |
    | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2     | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017622 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3    | 2_3            | AS-2122 | 1619                        | 42864.00    | [CofG_LA]      |
    | 10017622 | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2     | 4_2            | AS-2122 | NFF                         | 21430.00    | [CofG_LA]      |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3    | [ContractNo] | 1               | 0                  | Yes            |
    | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2     | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017622 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017622 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |




    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017622 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 64294.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017622 Co Ltd  | Active | Document Management Team  |
    | 10017622 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017622 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10018021
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017622 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 42864.00        | 10018021      | 10018021 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10018021
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 2               | 2455.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2455.00  | 0.00     | 0.00     | SSF Programme Funding                          |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 17173.00  | 0.00     | 5467.00  | 0.00     | 0.00     | 0.00     | 3528.00  | 0.00     | 3469.00  | 0.00     | 0.00     | 4709.00  | 0.00     | Teacher's Pension Scheme 1619                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 52              | 23236.00  | 0.00     | 4521.00  | 0.00     | 0.00     | 3811.00  | 0.00     | 0.00     | 4879.00  | 5675.00  | 0.00     | 0.00     | 4350.00  | Alternative Completions - Sea Fishing          |                          |
    # zero value item
 #  | [ContractNo]   | [AllocRef_16ED] | 48              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Advanced Maths Premium                     |                          |
      



    # Retrieve parameters from CRM for Delivery Org 10019145
   #And   I retrieve the latest contract details from CRM for provider '10017622' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017622' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10019145' 

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10019145
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017622 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 21430.00        | 10019145      | 10019145 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10019145
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 87              | 21430.00  | 0.00     | 3638.00  | 0.00     | 0.00     | 0.00     | 3441.00  | 9970.00  | 0.00     | 0.00     | 0.00     | 4381.00  | 0.00     | Area Review Transition Grant   |                          |





    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


    # Check the contents of the Appendices
    Then  the file named '10017622_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """  
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017622 Co Ltd UKPRN: 10017622
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    Total Funding for this contract: £64,294
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017622 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017622 Co Ltd THE SECRETARY OF STATE FOR
    16 Council Street
    EDUCATION
    Bristol
    DEPARTMENT FOR EDUCATION
    Avon
    20 GREAT SMITH STREET
    AND
    BS1 6JJ
    LONDON
    SW1P 3BT
    Company No: AA017622
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 12

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10018021 Co Ltd UKPRN: 10018021
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Programme Funding £2,455 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,455.00 £0.00 £0.00
    Alternative Completions - Sea Fishing £23,236 £0.00 £4,521.00 £0.00 £0.00 £3,811.00 £0.00 £0.00 £4,879.00 £5,675.00 £0.00 £0.00 £4,350.00
    Teacher's Pension Scheme 1619 £17,173 £0.00 £5,467.00 £0.00 £0.00 £0.00 £3,528.00 £0.00 £3,469.00 £0.00 £0.00 £4,709.00 £0.00
    Total Funding £42,864 £0.00 £9,988.00 £0.00 £0.00 £3,811.00 £3,528.00 £0.00 £8,348.00 £5,675.00 £2,455.00 £4,709.00 £4,350.00
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10019145 Co Ltd UKPRN: 10019145
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Area Review Transition Grant £21,430 £0.00 £3,638.00 £0.00 £0.00 £0.00 £3,441.00 £9,970.00 £0.00 £0.00 £0.00 £4,381.00 £0.00
    Total Funding £21,430 £0.00 £3,638.00 £0.00 £0.00 £0.00 £3,441.00 £9,970.00 £0.00 £0.00 £0.00 £4,381.00 £0.00
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017622_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A622.pdf'


    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017622 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '23/06/2021'

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
    | 10017622 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017622 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017622 | 10017622 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017622-2_3    | 2_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 42864.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |
    | 10017622 | 10017622 Co Ltd  | NFF-AS-2122-Contract-LocalAuthoritySsf-10017622-4_2     | 4_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Contract Approved | Contract Approved | 21430.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed




    # Retrieve parameters from CRM for Delivery Org 10018021
   #And   I retrieve the latest contract details from CRM for provider '10017622' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017622' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10018021' 

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017622 | [ContractNo]   | 1               | [AllocRef_16ED]  | 2               | 0                     | 2455.00      | 0             | 0        | SSF Programme Funding                          | ?                           |
    | 10017622 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 17173.00     | 0             | 0        | Teacher's Pension Scheme 1619                  | ?                           |
    | 10017622 | [ContractNo]   | 1               | [AllocRef_16ED]  | 52              | 0                     | 23236.00     | 0             | 0        | Alternative Completions - Sea Fishing          | ?                           |
 #  | 10017622 | [ContractNo]   | 1               | [AllocRef_16ED]  | 48              | 0                     | 0.00         | 0             | 0        | SSF Advanced Maths Premium                     | ?                           |



    # Retrieve parameters from CRM for Delivery Org 1009145
   #And   I retrieve the latest contract details from CRM for provider '10017622' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017622' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10019145' 

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017622 | [ContractNo]   | 1               | [AllocRef_16ED]  | 87              | 0                     | 21430.00     | 0             | 0        | Area Review Transition Grant                   | ?                           |





#    # Attempt to release the Release Group a second time. Check CRM Notification
#
#    # Release EDSK Funding Allocations from Contract Control (J128) 
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup     |
#    | [CofG_LA]        |
#
#    # Check that a NOTIFICATION has been created explaining why the release failed
#   #And   there are notifications of type 'Contract Closure Failed' owned by the 'Lead Manager Team' as follows
#   #And   there are notifications of type 'Contract Closure Failed' owned by the user 'FCS1 Test' as follows
#    Then  there is '1' notification of type 'Release Rejected' owned by user 'CRM Integration' which matches the following
#    | Status | NotificationName                   | NotificationText                                                                                                                    |
#    | New    | Release Rejected - [CofG_LA]       | Release of [CofG_LA] has been rejected because it has either been released before or has no Funding Allocations associated with it  |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@CFS
Scenario: A623 Import and release four CFS FA's (mix of 1619, NMSS and NFF) for a Local Authority (with Funding) to create an EDSK2122 contract with 3 Delivery Orgs and full CFS code mapping. Check CRM, docs, contract details and feed

    #  Contracting Org 10017623 - 1619, NMSS 
    #   Delivery Org 1 10014824 - 1619    
    #   Delivery Org 2 10015135 - 1619, NFF
    #   Delivery Org 3 10016542 - 1619
   
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017623'
    And   there is no Funding Allocation data in CRM for UKPRN '10017623'
    And   there is no Contract, Task or Workflow data for UKPRN '10017623'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017623' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
    
    
    
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017623' 
    And   there is no Organisation data for UKPRN '10014824' 
    And   there is no Organisation data for UKPRN '10015135' 
    And   there is no Organisation data for UKPRN '10016542' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10017623 Co Ltd' with UKPRN '10017623' and OrgId 'ORG0017623' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017623 | 117623 | 10017623 Co Ltd | 0              | Active                | Yes           | AA017623      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014824 | 114824 | 10014824 Co Ltd | 0              | Active                | Yes           | AA014824      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
    | 10015135 | 115135 | 10015135 Co Ltd | 0              | Active                | Yes           | AA015135      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
    | 10016542 | 116542 | 10016542 Co Ltd | 0              | Active                | Yes           | AA016542      | ?             | 16 College Drive       | ?                      | ?                      | ?                      | Trowley Bottom         | Hertfordshire          | HP11 8YY  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017623 |
    | 10014824 |
    | 10015135 |
    | 10016542 |




    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation ONE (CO_1619)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017623 | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4     | 2_4            | 1619                        | AS-2122            | 79935.00          |

    # Provider Funding Allocation (CO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017623-2_4  | 2_4                    | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4     | 10017623      | Local        | 10LAU           | 79935.00                  |

    # Funding Allocation Line (aka Deliverable) (CO_1619)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017623-2_4  | 1619-004        | 15755.00         | Payment         |
    | 1619-AS-2122-10017623-2_4  | 1619-006        | 12884.00         | Payment         |
    | 1619-AS-2122-10017623-2_4  | 1619-010        | 2013.00          | Payment         |
    | 1619-AS-2122-10017623-2_4  | 1619-011        | 18530.00         | Payment         |
 #  | 1619-AS-2122-10017623-2_4  | 1619-012        | 10775.00         | Payment         |
    | 1619-AS-2122-10017623-2_4  | 1619-013        | 23970.00         | Payment         |
    | 1619-AS-2122-10017623-2_4  | 1619-020        | 6783.00          | Payment         |

    # Funding Allocation Profile Period (CO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017623-2_4  | 1619-004        | FY-2122              | September              | 2021              | 4739.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-004        | FY-2122              | January                | 2022              | 4968.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-004        | FY-2122              | February               | 2022              | 3558.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-004        | FY-2122              | June                   | 2022              | 2490.00                   |
    #
    | 1619-AS-2122-10017623-2_4  | 1619-006        | FY-2122              | September              | 2021              | 2302.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-006        | FY-2122              | January                | 2022              | 2943.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-006        | FY-2122              | February               | 2022              | 4370.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-006        | FY-2122              | March                  | 2022              | 3269.00                   |
    #
    | 1619-AS-2122-10017623-2_4  | 1619-010        | FY-2122              | May                    | 2022              | 2013.00                   |
    #
    | 1619-AS-2122-10017623-2_4  | 1619-011        | FY-2122              | August                 | 2021              | 4463.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-011        | FY-2122              | October                | 2021              | 2684.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-011        | FY-2122              | November               | 2021              | 2967.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-011        | FY-2122              | February               | 2022              | 2540.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-011        | FY-2122              | June                   | 2022              | 2695.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-011        | FY-2122              | July                   | 2022              | 3181.00                   |
    #
#   | 1619-AS-2122-10017623-2_4  | 1619-012        | FY-2122              | March                  | 2022              | 5118.00                   |
#   | 1619-AS-2122-10017623-2_4  | 1619-012        | FY-2122              | June                   | 2022              | 5657.00                   |
    #
    | 1619-AS-2122-10017623-2_4  | 1619-013        | FY-2122              | September              | 2021              | 4853.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-013        | FY-2122              | January                | 2022              | 4201.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-013        | FY-2122              | March                  | 2022              | 5937.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-013        | FY-2122              | May                    | 2022              | 3400.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-013        | FY-2122              | July                   | 2022              | 5579.00                   |
    #
    | 1619-AS-2122-10017623-2_4  | 1619-020        | FY-2122              | September              | 2021              | 4054.00                   |
    | 1619-AS-2122-10017623-2_4  | 1619-020        | FY-2122              | July                   | 2022              | 2729.00                   |





    # Funding Allocation TWO (CO_NMSS)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017623 | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9     | 2_9            | NMSS                        | AY-2122            | 61205.00          |

    # Provider Funding Allocation (CO_NMSS)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017623-2_9  | 2_9                    | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9     | 10017623      | Local        | 10LAU           | 61205.00                  |

    # Funding Allocation Line (aka Deliverable) (CO_NMSS)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017623-2_9  | NMSS-004        | 11750.00         | Payment         |
    | NMSS-AY-2122-10017623-2_9  | NMSS-005        | 16308.00         | Payment         |
    | NMSS-AY-2122-10017623-2_9  | NMSS-006        | 25385.00         | Payment         |
    | NMSS-AY-2122-10017623-2_9  | NMSS-008        | 7762.00          | Payment         |

    # Funding Allocation Profile Period (CO_NMSS)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017623-2_9  | NMSS-004        | FY-2122              | August                 | 2021              | 3550.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-004        | FY-2122              | January                | 2022              | 3197.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-004        | FY-2122              | May                    | 2022              | 5003.00                   |
    #
    | NMSS-AY-2122-10017623-2_9  | NMSS-005        | FY-2122              | September              | 2021              | 4014.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-005        | FY-2122              | October                | 2021              | 2807.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-005        | FY-2122              | November               | 2021              | 4543.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-005        | FY-2122              | March                  | 2022              | 4944.00                   |
    #
    | NMSS-AY-2122-10017623-2_9  | NMSS-006        | FY-2122              | September              | 2021              | 3318.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-006        | FY-2122              | November               | 2021              | 3035.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-006        | FY-2122              | December               | 2021              | 5797.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-006        | FY-2122              | January                | 2022              | 5856.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-006        | FY-2122              | February               | 2022              | 4857.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-006        | FY-2122              | March                  | 2022              | 2522.00                   |
    #
    | NMSS-AY-2122-10017623-2_9  | NMSS-008        | FY-2122              | September              | 2021              | 3902.00                   |
    | NMSS-AY-2122-10017623-2_9  | NMSS-008        | FY-2122              | October                | 2021              | 3860.00                   |





    # Funding Allocation THREE (DO_1619))
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017623 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2  | 3_2            | 1619                        | AS-2122            | 81270.00          |

    # Provider Funding Allocation (DO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10014824-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2  | 10014824      | Schoo        | 08SSF           | 23446.00                  |
    | 1619-AS-2122-10015135-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2  | 10015135      | Schoo        | 08SSF           | 29885.00                  |
    | 1619-AS-2122-10016542-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2  | 10016542      | Schoo        | 08SSF           | 27939.00                  |

    # Funding Allocation Line (aka Deliverable) (DO_1619)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10014824-3_2  | 1619-001        | 17542.00         | Payment         |
    | 1619-AS-2122-10014824-3_2  | 1619-002        | 5904.00          | Payment         |
    #
    | 1619-AS-2122-10015135-3_2  | 1619-007        | 7086.00          | Payment         |
    | 1619-AS-2122-10015135-3_2  | 1619-010        | 22799.00         | Payment         |
    #
    | 1619-AS-2122-10016542-3_2  | 1619-001        | 16708.00         | Payment         |
    | 1619-AS-2122-10016542-3_2  | 1619-002        | 3322.00          | Payment         |
    | 1619-AS-2122-10016542-3_2  | 1619-003        | 3964.00          | Payment         |
    | 1619-AS-2122-10016542-3_2  | 1619-006        | 3945.00          | Payment         |

    # Funding Allocation Profile Period (DO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10014824-3_2  | 1619-001        | FY-2122              | August                 | 2021              | 5801.00                   |
    | 1619-AS-2122-10014824-3_2  | 1619-001        | FY-2122              | September              | 2021              | 2030.00                   |
    | 1619-AS-2122-10014824-3_2  | 1619-001        | FY-2122              | November               | 2021              | 4620.00                   |
    | 1619-AS-2122-10014824-3_2  | 1619-001        | FY-2122              | January                | 2022              | 5091.00                   |
    | 1619-AS-2122-10014824-3_2  | 1619-002        | FY-2122              | April                  | 2022              | 2546.00                   |
    | 1619-AS-2122-10014824-3_2  | 1619-002        | FY-2122              | May                    | 2022              | 3358.00                   |
    #
    | 1619-AS-2122-10015135-3_2  | 1619-007        | FY-2122              | October                | 2021              | 2539.00                   |
    | 1619-AS-2122-10015135-3_2  | 1619-007        | FY-2122              | November               | 2021              | 4547.00                   |
    | 1619-AS-2122-10015135-3_2  | 1619-010        | FY-2122              | December               | 2021              | 5773.00                   |
    | 1619-AS-2122-10015135-3_2  | 1619-010        | FY-2122              | January                | 2022              | 4919.00                   |
    | 1619-AS-2122-10015135-3_2  | 1619-010        | FY-2122              | February               | 2022              | 3081.00                   |
    | 1619-AS-2122-10015135-3_2  | 1619-010        | FY-2122              | March                  | 2022              | 4219.00                   |
    | 1619-AS-2122-10015135-3_2  | 1619-010        | FY-2122              | April                  | 2022              | 4807.00                   |
    #
    | 1619-AS-2122-10016542-3_2  | 1619-001        | FY-2122              | September              | 2021              | 3472.00                   |
    | 1619-AS-2122-10016542-3_2  | 1619-001        | FY-2122              | November               | 2021              | 4626.00                   |
    | 1619-AS-2122-10016542-3_2  | 1619-001        | FY-2122              | January                | 2022              | 4241.00                   |
    | 1619-AS-2122-10016542-3_2  | 1619-001        | FY-2122              | March                  | 2022              | 4369.00                   |
    | 1619-AS-2122-10016542-3_2  | 1619-002        | FY-2122              | April                  | 2022              | 3322.00                   |
    | 1619-AS-2122-10016542-3_2  | 1619-003        | FY-2122              | May                    | 2022              | 3964.00                   |
    | 1619-AS-2122-10016542-3_2  | 1619-006        | FY-2122              | July                   | 2022              | 3945.00                   |





    # Funding Allocation FOUR (DO_NFF)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017623 | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1   | 4_1            | NFF                         | AS-2122            | 22683.00          |

    # Provider Funding Allocation (DO_NFF)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10015135-4_1   | 4_1                    | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1   | 10015135      | Schoo        | 08SSF           | 22683.00                  |

    # Funding Allocation Line (aka Deliverable) (DO_NFF)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10015135-4_1   | NFF-001         | 3144.00          | Payment         |
    | NFF-AS-2122-10015135-4_1   | NFF-002         | 19539.00         | Payment         |

    # Funding Allocation Profile Period (DO_NFF)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10015135-4_1   | NFF-001         | FY-2122              | April                  | 2022              | 3144.00                   |
    #
    | NFF-AS-2122-10015135-4_1   | NFF-002         | FY-2122              | October                | 2021              | 4047.00                   |
    | NFF-AS-2122-10015135-4_1   | NFF-002         | FY-2122              | November               | 2021              | 2637.00                   |
    | NFF-AS-2122-10015135-4_1   | NFF-002         | FY-2122              | December               | 2021              | 3107.00                   |
    | NFF-AS-2122-10015135-4_1   | NFF-002         | FY-2122              | February               | 2022              | 3304.00                   |
    | NFF-AS-2122-10015135-4_1   | NFF-002         | FY-2122              | April                  | 2022              | 4218.00                   |
    | NFF-AS-2122-10015135-4_1   | NFF-002         | FY-2122              | June                   | 2022              | 2226.00                   |





    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                             | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017623 | 10017623 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4     | 2_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 79935.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017623 | 10017623 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9     | 2_9            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 61205.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017623 | 10017623 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2  | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 81270.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017623 | 10017623 Co Ltd  | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1   | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 22683.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2    | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1     | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check PaaS FundingAllocation.FundingAllocation 
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017623 | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4       | 2_4            | AS-2122 | 1619                        | 79935.00    | [CofG_LA]      |
    | 10017623 | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9       | 2_9            | AY-2122 | NMSS                        | 61205.00    | [CofG_LA]      |
    | 10017623 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2    | 3_2            | AS-2122 | 1619                        | 81270.00    | [CofG_LA]      |
    | 10017623 | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1     | 4_1            | AS-2122 | NFF                         | 22683.00    | [CofG_LA]      |


 


    # Release a Release Group (32333)

    # Change the date 
    Given the override date is '19/06/2021'

    # Check the state of a Release Group (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 4               | 245093.00       |

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Check the state of a Release Group (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 4               | 245093.00       |


    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017623' for FundingType 'EDSK' and period '2122'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                             | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017623 | 10017623 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4     | 2_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 79935.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy|
    | 10017623 | 10017623 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9     | 2_9            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Released          | Released          | 61205.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy|
    | 10017623 | 10017623 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2  | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 81270.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy|
    | 10017623 | 10017623 Co Ltd  | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1   | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Released          | Released          | 22683.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy|

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                            | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4    | Release Successful   | CRM Integration   | Released       | Released             | Scheduling     | Awaiting Release     |
#   | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4    | Initiate Release     | CRM Integration   | In Release     | Release in Progress  | Scheduling     | Awaiting Release     |
    | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4    | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    #
    | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9    | Release Successful   | CRM Integration   | Released       | Released             | Scheduling     | Awaiting Release     |
#   | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9    | Initiate Release     | CRM Integration   | In Release     | Release in Progress  | Scheduling     | Awaiting Release     |
    | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9    | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    #
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2 | Release Successful   | CRM Integration   | Released       | Released             | Scheduling     | Awaiting Release     |
#   | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2 | Initiate Release     | CRM Integration   | In Release     | Release in Progress  | Scheduling     | Awaiting Release     |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2 | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    #
    | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1  | Release Successful   | CRM Integration   | Released       | Released             | Scheduling     | Awaiting Release     |
#   | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1  | Initiate Release     | CRM Integration   | In Release     | Release in Progress  | Scheduling     | Awaiting Release     |
    | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1  | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017623 | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4       | 2_4            | AS-2122 | 1619                        | 79935.00    | [CofG_LA]      |
    | 10017623 | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9       | 2_9            | AY-2122 | NMSS                        | 61205.00    | [CofG_LA]      |
    | 10017623 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2    | 3_2            | AS-2122 | 1619                        | 81270.00    | [CofG_LA]      |
    | 10017623 | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1     | 4_1            | AS-2122 | NFF                         | 22683.00    | [CofG_LA]      |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4       | [ContractNo] | 1               | 0                  | Yes            |
    | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9       | [ContractNo] | 1               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2    | [ContractNo] | 1               | 0                  | Yes            |
    | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1     | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017623 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017623 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017623 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 245093.00     | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017623 Co Ltd  | Active | Document Management Team  |
    | 10017623 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017623 Co Ltd  | Active | CRM Integration           |

    

    # Retrieve parameters from CRM for the Contracting Org 10017623
    When  I retrieve the latest EFA contract details from CRM for provider '10017623' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017623' 
   #When  I retrieve the latest contract details from CRM for provider '10017623' for FundingType 'EDSK' and period '2122'
    Then   message '[AllocRef_16ED]' is written to the Output window

    # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017623 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 141140.00       | 10017623      | 10017623 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check the PLANNED VALUES in CRM 
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_16ED]    | 18              | 23970.00  | 0.00     | 4853.00  | 0.00     | 0.00     | 0.00     | 4201.00  | 0.00     | 5937.00  | 0.00     | 3400.00  | 0.00     | 5579.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 22              | 12884.00  | 0.00     | 2302.00  | 0.00     | 0.00     | 0.00     | 2943.00  | 4370.00  | 3269.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 43              | 16308.00  | 0.00     | 4014.00  | 2807.00  | 4543.00  | 0.00     | 0.00     | 0.00     | 4944.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 49              | 11750.00  | 3550.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3197.00  | 0.00     | 0.00     | 0.00     | 5003.00  | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 51              | 18530.00  | 4463.00  | 0.00     | 2684.00  | 2967.00  | 0.00     | 0.00     | 2540.00  | 0.00     | 0.00     | 0.00     | 2695.00  | 3181.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 52              | 6783.00   | 0.00     | 4054.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2729.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 85              | 15755.00  | 0.00     | 4739.00  | 0.00     | 0.00     | 0.00     | 4968.00  | 3558.00  | 0.00     | 0.00     | 0.00     | 2490.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 118             | 25385.00  | 0.00     | 3318.00  | 0.00     | 3035.00  | 5797.00  | 5856.00  | 4857.00  | 2522.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
#   | [ContractNo]   | [AllocRef_16ED]    | 119             | 10775.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5118.00  | 0.00     | 0.00     | 5657.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 125             | 2013.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2013.00  | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 140             | 7762.00   | 0.00     | 3902.00  | 3860.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 


    # Retrieve parameters from CRM for FIRST Delivery Org 10014824
    When  I retrieve the latest EFA contract details from CRM for provider '10017623' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014824' 
    Then   message '[AllocRef_16ED]' is written to the Output window

    # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017623 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 23446.00        | 10014824      | 10014824 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check the PLANNED VALUES in CRM 
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_16ED]    | 2               | 17542.00  | 5801.00  | 2030.00  | 0.00     | 4620.00  | 0.00     | 5091.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 13              | 5904.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2546.00  | 3358.00  | 0.00     | 0.00     | 
    


    # Retrieve parameters from CRM for SECOND Delivery Org 10015135
    When  I retrieve the latest EFA contract details from CRM for provider '10017623' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10015135' 
    Then   message '[AllocRef_16ED]' is written to the Output window

    # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017623 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 52568.00        | 10015135      | 10015135 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check the PLANNED VALUES in CRM 
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_16ED]    | 87              | 19539.00  | 0.00     | 0.00     | 4047.00  | 2637.00  | 3107.00  | 0.00     | 3304.00  | 0.00     | 4218.00  | 0.00     | 2226.00  | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 114             | 7086.00   | 0.00     | 0.00     | 2539.00  | 4547.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 125             | 22799.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5773.00  | 4919.00  | 3081.00  | 4219.00  | 4807.00  | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 931             | 3144.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3144.00  | 0.00     | 0.00     | 0.00     | 



    # Retrieve parameters from CRM for THIRD Delivery Org 10016542
    When  I retrieve the latest EFA contract details from CRM for provider '10017623' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10016542' 
    Then   message '[AllocRef_16ED]' is written to the Output window

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017623 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 27939.00        | 10016542      | 10016542 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check the PLANNED VALUES in CRM 
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_16ED]    | 2               | 16708.00  | 0.00     | 3472.00  | 0.00     | 4626.00  | 0.00     | 4241.00  | 0.00     | 4369.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 13              | 3322.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3322.00  | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_16ED]    | 22              | 3945.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3945.00  | 
    | [ContractNo]   | [AllocRef_16ED]    | 33              | 3964.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3964.00  | 0.00     | 0.00     | 


    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '240' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'




    # Check the contents of the Appendices
    Then  the file named '10017623_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017623 Co Ltd UKPRN: 10017623
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    Total Funding for this contract: £245,093
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017623 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017623 Co Ltd THE SECRETARY OF STATE FOR
    89 Council Road
    EDUCATION
    Hemel Hempstead
    DEPARTMENT FOR EDUCATION
    Hertfordshire
    20 GREAT SMITH STREET
    AND
    HP1 1XY
    LONDON
    SW1P 3BT
    Company No: AA017623
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 12

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017623 Co Ltd UKPRN: 10017623
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 High Needs Element 2 £12,884 £0.00 £2,302.00 £0.00 £0.00 £0.00 £2,943.00 £4,370.00 £3,269.00 £0.00 £0.00 £0.00 £0.00
    Maintained Special SSF Bursary Support £23,970 £0.00 £4,853.00 £0.00 £0.00 £0.00 £4,201.00 £0.00 £5,937.00 £0.00 £3,400.00 £0.00 £5,579.00
    Pre-16 Universal Infant Free School Meals £11,750 £3,550.00 £0.00 £0.00 £0.00 £0.00 £3,197.00 £0.00 £0.00 £0.00 £5,003.00 £0.00 £0.00
    Primary PE and Sport Premium £16,308 £0.00 £4,014.00 £2,807.00 £4,543.00 £0.00 £0.00 £0.00 £4,944.00 £0.00 £0.00 £0.00 £0.00
    Residential Support Scheme £15,755 £0.00 £4,739.00 £0.00 £0.00 £0.00 £4,968.00 £3,558.00 £0.00 £0.00 £0.00 £2,490.00 £0.00
    Alternative Completions - Sporting Excellence £18,530 £4,463.00 £0.00 £2,684.00 £2,967.00 £0.00 £0.00 £2,540.00 £0.00 £0.00 £0.00 £2,695.00 £3,181.00
    Alternative Completions - Sea Fishing £6,783 £0.00 £4,054.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,729.00
    Teachers Pay Grant (NMSS) £25,385 £0.00 £3,318.00 £0.00 £3,035.00 £5,797.00 £5,856.00 £4,857.00 £2,522.00 £0.00 £0.00 £0.00 £0.00
    Teacher's Pension Scheme 1619 £2,013 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,013.00 £0.00 £0.00
    Pupil Premium (NMSS) £7,762 £0.00 £3,902.00 £3,860.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £141,140 £8,013.00 £27,182.00 £9,351.00 £10,545.00 £5,797.00 £21,165.00 £15,325.00 £16,672.00 £0.00 £10,416.00 £5,185.00 £11,489.00
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10014824 Co Ltd UKPRN: 10014824
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Programme Funding £17,542 £5,801.00 £2,030.00 £0.00 £4,620.00 £0.00 £5,091.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF Bursary Funds £5,904 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,546.00 £3,358.00 £0.00 £0.00
    Total Funding £23,446 £5,801.00 £2,030.00 £0.00 £4,620.00 £0.00 £5,091.00 £0.00 £0.00 £2,546.00 £3,358.00 £0.00 £0.00

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10015135 Co Ltd UKPRN: 10015135
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Capacity and Delivery £7,086 £0.00 £0.00 £2,539.00 £4,547.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Cadets Vocational Programme £3,144 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,144.00 £0.00 £0.00 £0.00
    Area Review Transition Grant £19,539 £0.00 £0.00 £4,047.00 £2,637.00 £3,107.00 £0.00 £3,304.00 £0.00 £4,218.00 £0.00 £2,226.00 £0.00
    Teacher's Pension Scheme 1619 £22,799 £0.00 £0.00 £0.00 £0.00 £5,773.00 £4,919.00 £3,081.00 £4,219.00 £4,807.00 £0.00 £0.00 £0.00
    Total Funding £52,568 £0.00 £0.00 £6,586.00 £7,184.00 £8,880.00 £4,919.00 £6,385.00 £4,219.00 £12,169.00 £0.00 £2,226.00 £0.00
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10016542 Co Ltd UKPRN: 10016542
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 High Needs Element 2 £3,945 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,945.00
    SSF Programme Funding £16,708 £0.00 £3,472.00 £0.00 £4,626.00 £0.00 £4,241.00 £0.00 £4,369.00 £0.00 £0.00 £0.00 £0.00
    SSF Bursary Funds £3,322 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,322.00 £0.00 £0.00 £0.00
    Residential Bursary Fund £3,964 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,964.00 £0.00 £0.00
    Total Funding £27,939 £0.00 £3,472.00 £0.00 £4,626.00 £0.00 £4,241.00 £0.00 £4,369.00 £3,322.00 £3,964.00 £0.00 £3,945.00

    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017623_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A623.pdf'





    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '23/06/2021'

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
    | 10017623 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017623 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                             | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017623 | 10017623 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10017623-2_4     | 2_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 79935.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |
    | 10017623 | 10017623 Co Ltd  | NMSS-AY-2122-Contract-LocalAuthority-10017623-2_9     | 2_9            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Contract Approved | Contract Approved | 61205.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |
    | 10017623 | 10017623 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10017623-3_2  | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 81270.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |
    | 10017623 | 10017623 Co Ltd  | NFF-AS-2122-Contract-LocalAuthoritySsf-10017623-4_1   | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Contract Approved | Contract Approved | 22683.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Check Feed entries

    # Retrieve parameters from CRM for the Contracting Org 10017623
    When  I retrieve the latest EFA contract details from CRM for provider '10017623' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017623' 

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '10' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 18              | 0                     | 23970.00     | 0             | 0        | Maintained Special SSF Bursary Support         | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 12884.00     | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 16308.00     | 0             | 0        | Primary PE and Sport Premium                   | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 49              | 0                     | 11750.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals      | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 51              | 0                     | 18530.00     | 0             | 0        | Alternative Completions - Sporting Excellence  | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 52              | 0                     | 6783.00      | 0             | 0        | Alternative Completions - Sea Fishing          | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 85              | 0                     | 15755.00     | 0             | 0        | Residential Support Scheme                     | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 118             | 0                     | 25385.00     | 0             | 0        | Teachers Pay Grant (NMSS)                      | ?                           |
 #  | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 119             | 0                     | 10775.00     | 0             | 0        | Maths Centre for Excellence 1619               | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 2013.00      | 0             | 0        | Teacher's Pension Scheme 1619                  | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 140             | 0                     | 7762.00      | 0             | 0        | Pupil Premium (NMSS)                           | ?                           |


    # Retrieve parameters from CRM for FIRST Delivery Org 10014824
    When  I retrieve the latest EFA contract details from CRM for provider '10017623' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014824' 

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName          | DeliverableDescription      |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 2               | 0                     | 17542.00     | 0             | 0        | SSF Programme Funding    | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 5904.00      | 0             | 0        | SSF Bursary Funds        | ?                           |


    # Retrieve parameters from CRM for SECOND Delivery Org 10015135
    When  I retrieve the latest EFA contract details from CRM for provider '10017623' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10015135' 

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '4' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                           | DeliverableDescription      |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 87              | 0                     | 19539.00     | 0             | 0        | Area Review Transition Grant                              | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 114             | 0                     | 7086.00      | 0             | 0        | SSF Capacity and Delivery                                 | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 22799.00     | 0             | 0        | Teacher's Pension Scheme 1619                             | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 931             | 0                     | 3144.00      | 0             | 0        | Cadets Vocational Programme                               | ?                           |


    # Retrieve parameters from CRM for THIRD Delivery Org 10016542
    When  I retrieve the latest EFA contract details from CRM for provider '10017623' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10016542' 

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '4' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                 | DeliverableDescription      |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 2               | 0                     | 16708.00     | 0             | 0        | SSF Programme Funding           | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 3322.00      | 0             | 0        | SSF Bursary Funds               | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 3945.00      | 0             | 0        | 16-19 High Needs Element 2      | ?                           |
    | 10017623 | [ContractNo]   | 1               | [AllocRef_16ED]  | 33              | 0                     | 3964.00      | 0             | 0        | Residential Bursary Fund        | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210512
Scenario: A624 Import and release one CFS FA (1619) for a Local Authority (without Funding) to create an EDSK2021 contract with 1 Delivery Org and full CFS code mapping. Check CRM, docs, contract details and feed
    #  Contracting Org 10017624 - no funding 
    #     Delivery Org 1 10018624 - PSG

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017624'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018624'
    And   there is no Funding Allocation data in CRM for UKPRN '10017624'
    And   there is no Funding Allocation data in CRM for UKPRN '10018624'
    And   there is no Contract, Task or Workflow data for UKPRN '10017624'
    And   there is no Contract, Task or Workflow data for UKPRN '10018624'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017624' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017624' 
    And   there is no Organisation data for UKPRN '10018624' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017624 Co Ltd' with UKPRN '10017624' and OrgId 'ORG0017624' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017624' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017624 | 117624 | 10017624 Co Ltd | 0              | Active                | Yes           | AA017624      | ?             | 201 London Road East   | Batheaston             | Bath                   | ?                      | ?                      | ?                      | BA1 7NB   |
    | 10018624 | 118624 | 10018624 Co Ltd | 0              | Active                | Yes           | AA018624      | ?             | 7 Claymore             | Tame Valley            | ?                      | ?                      | Tamworth               | Staffordshire          | B77 5DQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017624 |
    | 10018624 |




    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017624 | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3   | 2_3            | PSG                         | AY-2122            | 11280.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | PSG-AY-2122-10018624-2_3   | 2_3                    | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3   | 10018624      | Schoo        | 08SSF           | 11280.00                  |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PSG-AY-2122-10018624-2_3   | PSG-001         | 11280.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PSG-AY-2122-10018624-2_3   | PSG-001         | FY-2122              | October                | 2020              | 3785.00                   |
    | PSG-AY-2122-10018624-2_3   | PSG-001         | FY-2122              | March                  | 2021              | 4923.00                   |
    | PSG-AY-2122-10018624-2_3   | PSG-001         | FY-2122              | July                   | 2021              | 2572.00                   |





    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017624 | 10017624 Co Ltd  | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3     | 2_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | PSG                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 11280.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3     | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | 
    | 10017624 | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3     | 2_3            | AY-2122 | PSG                         | 11280.00    |





    # Release a Funding Allocation (32333)

    # Change the date 
    Given the override date is '20/06/2021'


    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 11280.00        |

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |
    

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 11280.00        |



    # Retrieve parameters from CRM 
   #When  I retrieve the latest contract details from CRM for provider '10017624' for FundingType 'EDSK' and period '2122'
    When  I retrieve the latest EFA contract details from CRM for provider '10017624' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10018624' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017624 | 10017624 Co Ltd  | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3     | 2_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | PSG                         | 16-19ED2122     | Released          | Released          | 11280.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3     | Release Successful   | CRM Integration   | Released       | Released             | In Release     | Release in Progress  |
    | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3     | Initiate Release     | CRM Integration   | In Release     | Release in Progress  | Scheduling     | Awaiting Release     |
    | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3     | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       |
    | 10017624 | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3     | 2_3            | AY-2122 | PSG                         | 11280.00    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3     | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017624 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017624 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017624 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 11280.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017624 Co Ltd  | Active | Document Management Team  |
    | 10017624 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017624 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017624 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 11280.00        | 10018624      | 10018624 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 11280.00  | 0.00     | 0.00     | 3785.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4923.00  | 0.00     | 0.00     | 0.00     | 2572.00  | Primary PE and Sport Premium                   |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

   # Check the contents of the Appendices
   And   the file named '10017624_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
   """
   SUMMARY OF FUNDING 2020/21
   Organisation Name: 10017624 Co Ltd UKPRN: 10017624
   Master Contract Number: [MasterContractNo]
   Allocation
   Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
   16 to 19 Education
   10018624 Co Ltd [AllocRef_16ED] £8,708 £2,572 £11,280
   Total Funding for this contract: £11,280
   Summary of Funding – Page 1
   
   Agreement Type Conditions of Funding (Grant) (Local Authorities)
   Funding Period 1 August 2020 to 31 July 2021
   the Secretary of State for Education (acting through
   Between
   the Education and Skills Funding Agency)
   And 10017624 Co Ltd
   Funding for 16 to 19 Education
   Master Agreement Number [MasterContractNo]
   EDSK Version 3 (September 2020) Page 1

   This Agreement is made on the date the Agreement is digitally signed by the
   Provider on the Manage Your Education & Skills Funding Service between:
   10017624 Co Ltd THE SECRETARY OF STATE FOR
   201 London Road East EDUCATION ACTING THROUGH
   Batheaston THE EDUCATION AND SKILLS
   Bath FUNDING AGENCY, AN
   BA1 7NB EXECUTIVE AGENCY OF THE
   DEPARTMENT OF EDUCATION
   AND CHEYLESMORE HOUSE
   Company No: AA017624 QUINTON ROAD
   COVENTRY
   CV1 2WT
   Hereinafter called Hereinafter called
   the Provider the Department
   EDSK Version 3 (September 2020) Page 2
   EDSK Version 3 (September 2020) Page 73
   
   SCHEDULE 1: SPECIFICATION & MONITORING
   16-19 EDUCATION SPECIFICATION
   EDSK Schedule 1 – 16 to 19 Education Version 2 LA (September 2020) – Page 1
   EDSK Schedule 1 – 16 to 19 Education Version 2 LA (September 2020) – Page 12

   SCHEDULE 2: PAYMENT
   16-19 EDUCATION PAYMENT
   EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2020) – Page 1
   SCHEDULE 2 – 16 TO 19 EDUCATION
   Funding Agreement – 16 to 19 Education
   Provider: 10018624 Co Ltd UKPRN: 10018624
   Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
   Contract Ref: [AllocRef_16ED]
   Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
   Primary PE and Sport Premium £11,280 £0.00 £0.00 £3,785.00 £0.00 £0.00 £0.00 £0.00 £4,923.00 £0.00 £0.00 £0.00 £2,572.00
   Total Funding £11,280 £0.00 £0.00 £3,785.00 £0.00 £0.00 £0.00 £0.00 £4,923.00 £0.00 £0.00 £0.00 £2,572.00
   Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
   
   SCHEDULE 3: NOT USED
   EDSK Schedule 3 Version 2 (July 2020) – Page 1
   SCHEDULE 4: NOT USED
   EDSK Schedule 4 Version 2 (July 2020) – Page 1
   SCHEDULE 5: NOT USED
   EDSK Schedule 5 Version 2 (July 2020) – Page 1
   SCHEDULE 6: GDPR
   EDSK Schedule 6 Version 2 (July 2020) – Page 1
   EDSK Schedule 6 Version 2 (July 2020) – Page 2
   SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
   EDSK Schedule 7 Version 2 (July 2020) – Page 1
   EDSK Schedule 7 Version 2 (July 2020) – Page 7
   SCHEDULE 8: EXIT ARRANGEMENTS
   EDSK Schedule 8 Version 2 (July 2020) – Page 1
   EDSK Schedule 8 Version 2 (July 2020) – Page 5
   """

   # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017624_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A624.pdf'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017624 - 10017624 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017624 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '23/06/2021'

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
    | 10017624 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017624 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017624 | 10017624 Co Ltd  | PSG-AY-2122-Contract-LocalAuthoritySsf-10017624-2_3     | 2_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | PSG                         | 16-19ED2122     | Contract Approved | Contract Approved | 11280.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017624 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 11280.00     | 0             | 0        | Primary PE and Sport Premium                   | ?                           |


    # Tidy Up
    And   the override date is reset

