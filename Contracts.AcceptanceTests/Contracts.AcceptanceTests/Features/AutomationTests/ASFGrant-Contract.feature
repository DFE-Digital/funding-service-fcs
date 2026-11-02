Feature: ASFGrant-Contract

@AcceptanceTest @Withdrawn_06082026
@CFS
Scenario Outline: S201 Import, release and approve ASF grant allocations; check docs, CRM and feeds
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '<UKPRN>'
    And   there is no Funding Allocation data in CRM for UKPRN '<UKPRN>'
    And   there is no Contract, Task or Workflow data for UKPRN '<UKPRN>'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '<UKPRN>'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '<UKPRN>'

    And   there are no files prefixed '<UKPRN>' in the Sharepoint 'EDSK-2627-Input-Appendices' folder

    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                             |
    | EDSK            | AY2627        | ASF2627      | Conditions of Funding (Grant) (SPI)      |

    And   there is no data in the ContractRequest.FundingAllocationRelease table
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | <FSP_ASCL>     |
    | <FSP_FCFJ>     |

    And   there are no Sector-based Work Academies profile values in config for UKPRN '<UKPRN>'

    Given there is no Organisation data in CRM for UKPRN '<UKPRN>'
    And   there is no caseload advisor for UKPRN '<UKPRN>'
    And   there is no Organisation data in PaaS for the following UKPRNs
    | UKPRN    |
    | <UKPRN>  |
    And   caseload advisor 'FCS2 Test' is assigned to provider '<LegalName>' with UKPRN '<UKPRN>' and OrgId '<OrgId>' and has 'FCS1 Test' as a manager

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status  | UKRLPCalledOk | CompanyNumber   | CharityNumber | AddressLine1              | Town      | Postcode |
    | <UKPRN>  | <UPIN> | <LegalName>     | 0              | Active  | Yes           | <CompanyNumber> | ?             | 9 Kneesworth Street       | Royston   | SG8 5AA |

    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | <UKPRN> |

    # Populate the CFS stub with ASF data (initial)
    Given the override date is '<InitialOverrideDate>'
    And   there is no data in the CFS stub

    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                      | FundingVersion    | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | <UKPRN>  | <FundingId1>                                   | <FundingVersion1> | ASFG                        | AY-2627            | <Total1>          |

    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId         | ProviderFundingVersion    | FundingId    | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | <ProviderFundingId1>      | <ProviderFundingVersion1> | <FundingId1> | <UKPRN>       | Furth        | 18ISP           | <Total1>                  |

    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode | FundingLineValue | FundingLineType |
    | <ProviderFundingId1>      | ASFG-001        | <Line1_1>        | Payment         |
    | <ProviderFundingId1>      | ASFG-002        | <Line1_2>        | Payment         |
    | <ProviderFundingId1>      | ASFG-004        | <Line1_3>        | Payment         |

    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | <ProviderFundingId1>      | ASFG-001        | FY-2627              | December                 | 2026              | <Profile1_1>              |
    | <ProviderFundingId1>      | ASFG-002        | FY-2627              | December                 | 2026              | <Profile1_2>              |
    | <ProviderFundingId1>      | ASFG-004        | FY-2627              | December                 | 2026              | <Profile1_3>              |

    # Consume stub data (initial)
    Given the override date is '<ProcessDate1>'
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2627        | ASF2627      | Conditions of Funding (Grant) (SPI)     | CofG(SPI)                |

    And   message 'ReleaseGroup CofG(SPI) = [CofG(SPI)]' is written to the Output window

    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                | FundingVersion    | FundingType                | Period  | ContractType                              | AllocationFundingStreamCode | FSPGroup | Status     | SubStatus         | Value   | ContractNo | ContractVersionNo | CreatedBy         | ModifiedBy         | HoldReason | ReleaseGroup  | QueuedOn | QueuedDueToContract |
    | <UKPRN>  | <LegalName>      | <FundingId1>             | <FundingVersion1> | Education & Skills Funding | AY2627  | Conditions of Funding (Grant) (SPI)       | ASFG                        | ASF2627  | Scheduling | Awaiting Release  | <Total1> | ?          | ?                 | CRM Integration   | CRM Integration    | ?          | [CofG(SPI)]   | ?        | ?                   |

    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                            | Action          | CompletedBy     | NewStatus  | NewSubStatus         | PreviousStatus | PreviousSubStatus | Comment |
    | <FundingId1>                         | Record Imported | CRM Integration | Scheduling | Awaiting Release     | ?              | ?                 | ?       |

    And   Release Group '[CofG(SPI)]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | <Total1>        |

    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                | FundingVersion    | Period  | AllocationFundingStreamCode | Value   | ReleaseGroup   | Status | SubStatus |
    | <UKPRN>  | <FundingId1>             | <FundingVersion1> | AY-2627 | ASFG                        | <Total1> | [CofG(SPI)]   | ?      | ?         |

    And   Release Group '[CofG(SPI)]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

    # Release the Release Group
    Given the override date is '<ReleaseDate1>'
    When  a request is triggered to release the following Release Group
    | ReleaseGroup    |
    | [CofG(SPI)]     |
    And   message 'ReleaseGroup CofG(SPI) = [CofG(SPI)]' is written to the Output window
    Then wait '30' seconds

    Then  Release Group '[CofG(SPI)]' has the following characteristics
    | ReleaseStatus | AllocationCount | AllocationValue |
    | Released      | 1               | <Total1>        |

    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType 'EDSK' and period '2627'

    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                | FundingVersion    | Period  | AllocationFundingStreamCode | Value   | ReleaseGroup   | Status | SubStatus |
    | <UKPRN>  | <FundingId1>             | <FundingVersion1> | AY-2627 | ASFG                        | <Total1> | [CofG(SPI)]   | ?      | ?         |

    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | <FundingId1>             | [ContractNo] | 1               | 0                  | Yes            |

    And   Release Group '[CofG(SPI)]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus             | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
    | <UKPRN>  | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation        | True          | False               | <ContractStartDate> | <ContractEndDate> |
    | <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                             | False         | False               | <ContractStartDate> | <ContractEndDate> |

    # Publish contract and create merged document
    Given the override date is '<PublishDate>'
    And   a file with filename '<UKPRN>_[ContractNo]_v1.pdf' is created in 'EDSK-2627-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
    | <UKPRN>  | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | <ContractStartDate> | <ContractEndDate> |
    | <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | <ContractStartDate> | <ContractEndDate> |

    # Approve the contract
    Given the override date is '<ApproveDate>'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
    | <UKPRN>  | [ContractNo]       | 1                     | 0                        | Approved         | Approved          | True          | True                | <ContractStartDate> | <ContractEndDate> |
    | <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                 | False         | False               | <ContractStartDate> | <ContractEndDate> |

    # --- Amend stub with updated ASF data (second pass) ---
    Given the override date is '<AmendOverrideDate>'
    And   there is no data in the CFS stub

    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                      | FundingVersion    | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | <UKPRN>  | <FundingId2>                                   | <FundingVersion2> | ASFG                        | AY-2627            | <Total2>          |

    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId         | ProviderFundingVersion    | FundingId    | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | <ProviderFundingId2>      | <ProviderFundingVersion2> | <FundingId2> | <UKPRN>       | Furth        | 18ISP           | <Total2>                  |

    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode | FundingLineValue | FundingLineType |
    | <ProviderFundingId2>      | ASFG-001        | <Line2_1>        | Payment         |
    | <ProviderFundingId2>      | ASFG-002        | <Line2_2>        | Payment         |
    | <ProviderFundingId2>      | ASFG-004        | <Line2_3>        | Payment         |

    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | <ProviderFundingId2>      | ASFG-001        | FY-2627              | September              | 2026              | <Profile2_1>              |
    | <ProviderFundingId2>      | ASFG-002        | FY-2627              | April                  | 2027              | <Profile2_2>              |
    | <ProviderFundingId2>      | ASFG-004        | FY-2627              | December               | 2026              | <Profile2_3>              |

    Given the override date is '<ProcessDate2>'
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2627        | ASF2627      | Conditions of Funding (Grant) (SPI)     | CofG(SPI)                |

    And   message 'ReleaseGroup CofG(SPI) = [CofG(SPI)]' is written to the Output window

    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                | FundingVersion    | FundingType                | Period  | ContractType                              | AllocationFundingStreamCode | FSPGroup | Status     | SubStatus         | Value    | ContractNo | ContractVersionNo | CreatedBy         | ModifiedBy         | HoldReason | ReleaseGroup  | QueuedOn | QueuedDueToContract |
    | <UKPRN>  | <LegalName>      | <FundingId2>             | <FundingVersion2> | Education & Skills Funding | AY2627  | Conditions of Funding (Grant) (SPI)       | ASFG                        | ASF2627  | Scheduling | Awaiting Release  | <Total2> | ?          | ?                 | CRM Integration   | CRM Integration    | ?          | [CofG(SPI)]   | ?        | ?                   |

    # Release the amended Release Group
    Given the override date is '<ReleaseDate2>'
    When  a request is triggered to release the following Release Group
    | ReleaseGroup    |
    | [CofG(SPI)]     |

    And   message 'ReleaseGroup CofG(SPI) = [CofG(SPI)]' is written to the Output window
    Then wait '30' seconds

    Then  Release Group '[CofG(SPI)]' has the following characteristics
    | ReleaseStatus | AllocationCount | AllocationValue |
    | Released      | 1               | <Total2>        |

    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType 'EDSK' and period '2627'

    Then  the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | <FundingId2>             | [ContractNo] | 2               | 0                  | Yes            |

    And   Release Group '[CofG(SPI)]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    #Then  the following contract values are present in CRM
    #| UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus             | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
    #| <UKPRN>  | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation        | True          | False               | <ContractStartDate> | <ContractEndDate> |
    #| <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                             | False         | False                | <ContractStartDate> | <ContractEndDate> |



    And   Sharepoint file '<UKPRN>_[ContractNo]_v2.pdf' in 'EDSK-2627-Input-Appendices' is copied to 'Datafiles/Downloads' as '<UKPRN>_[ContractNo]_v2.pdf'


    
#        # Publish contract and create merged document
#    Given the override date is '<PublishDate>'
#    And   a file with filename '<UKPRN>_[ContractNo]_v2.pdf' is created in 'EDSK-2627-Output-Merged Document'
#    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
#    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table
#
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
#    | <UKPRN>  | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider   | True          | False               | <ContractStartDate> | <ContractEndDate> |
#    | <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Approved         | Approved                | False         | True                | <ContractStartDate> | <ContractEndDate> |
#    | <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | <ContractStartDate> | <ContractEndDate> |
#
#    # Approve the contract
#    Given the override date is '<ApproveDate>'
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    #And   the following contract values are present in CRM
#    #| UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
#    #| <UKPRN>  | [ContractNo]       | 1                     | 0                        | Approved         | Approved          | True          | True                | <ContractStartDate> | <ContractEndDate> |
#    #| <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                 | False         | False               | <ContractStartDate> | <ContractEndDate> |
#        


    And wait '15' seconds

    # Part 7c: Payment Batch for ASF2526

    # Change the date
    Given the override date is '02/12/2026 22:00'


    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '<FSP_ASCL>' AccountingPaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period          |
    | [AllocRef_ASCA]          | <PaymentPeriod> |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Census End Date/Time | LinkCodeSuffix | Status     |
    | <FSP_ASCL>	             | <PaymentPeriod>               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Status    |
    | <FSP_ASCL>	         	 | <PaymentPeriod>               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '<FSP_ASCL>' PaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S201_ASCA.xml'

    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    #And   the Payment feed xml for FundingStreamPeriod 'ALLBC2425' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
    ##                                                                                                    £15089.09

    
    Then wait '20' seconds



    # Part 7c: Payment Batch for ASF2526

    # Change the date
    Given the override date is '02/12/2026 22:05'


    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '<FSP_FCFJ>' AccountingPaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period          |
    | [AllocRef_ASFC]          | <PaymentPeriod> |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Census End Date/Time | LinkCodeSuffix | Status     |
    | <FSP_FCFJ>	             | <PaymentPeriod>               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Status    |
    | <FSP_FCFJ>	         	 | <PaymentPeriod>               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '<FSP_FCFJ>' PaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S201_ASFC.xml'

    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    #And   the Payment feed xml for FundingStreamPeriod 'ALLBC2425' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
    ##                                                                                                    £15089.09


    
    # Part 6: Create and check the contents of the CDA report
   
    # Change the date
    Given the override date is '03/12/2026'
    
    # Check the contents of the CDA report
    And   there is no CDA report named 'CDA Last Approved Version S201.csv'

    And   the following ADF Pipeline run

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod	  | Version               | Suffix |
    | <FSP_ASCL>              | Last Approved         | S201   |
    | <FSP_FCFJ>              | Last Approved         | S201   |

    Then  a report named 'CDA Last Approved Version S201.csv' is created

    # Check the contents of the CDA Report manually


Examples:
    | UKPRN   | LegalName           | UPIN  | OrgId      | CompanyNumber |  InitialOverrideDate | FundingId1                                                      | FundingVersion1 | ProviderFundingId1                      | ProviderFundingVersion1 | Total1 | Line1_1 | Line1_2 | Line1_3 | Profile1_1 | Profile1_2 | Profile1_3 | ProcessDate1 | ReleaseDate1 | PublishDate | ApproveDate | AmendOverrideDate | FundingId2                                                      | FundingVersion2 | ProviderFundingId2                      | ProviderFundingVersion2 | Total2  | Line2_1 | Line2_2 | Line2_3 | Profile2_1 | Profile2_2 | Profile2_3 | ProcessDate2 | ReleaseDate2 | ContractStartDate | ContractEndDate | FSP_ASCL         | FSP_FCFJ       |  PaymentPeriod | FinancialPeriod | CensusEndDate |
    | 10010049| 10010049 Co Ltd     | 110049| ORG0010049 | AA010049      |  01/07/2026          | ASFG-AY-2627-Contract-Provider-10010048-3_5                     | 3_5             | ASFG-AY-2627-10010048-3_5               | 3_5                     | 7180.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | ASFG-AY-2627-Contract-Provider-10010048-3_6                     | 3_6             | ASFG-AY-2627-10010048-3_6               | 3_6                     | 15500.00| 1000.00 | 9000.00 | 3500.00 | 1000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | ASFC-ASCL2627    | ASFC-FCFJ2627  |  202612        | 202609          | 02/12/2026   |