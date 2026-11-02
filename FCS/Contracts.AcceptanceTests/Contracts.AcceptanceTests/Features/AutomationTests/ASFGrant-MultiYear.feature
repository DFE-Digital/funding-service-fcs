Feature: ASFGrant-MultiYear

@AcceptanceTest @Complete
@CFS @PoP
Scenario Outline: S203 Import, release and approve ASF grant allocations; check docs, CRM and feeds
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '<UKPRN>'
    And   there is no Funding Allocation data in CRM for UKPRN '<UKPRN>'
    And   there is no Contract, Task or Workflow data for UKPRN '<UKPRN>'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '<UKPRN>'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '<UKPRN>'

    And   there are no files prefixed '<UKPRN>' in the Sharepoint '<FundingType>-<Period>-Input-Appendices' folder

    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode          | FundingPeriod          | FSPGroupCode    | ContractType        |
    | <FundingType>            | <FundingPeriod>        | <FSPGroup>      | <ContractType>      |

    And   there is no data in the ContractRequest.FundingAllocationRelease table
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP        |
    | <FSP1>     |
    | <FSP2>     |

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
    | <UKPRN>  |

    # Populate the CFS stub with ASF data (initial)
    Given the override date is '<InitialOverrideDate>'
    And   there is no data in the CFS stub

    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                      | FundingVersion    | AllocationFundingStreamCode                          | AllocationPeriodId    | TotalFundingValue |
    | Contracting    | <UKPRN>  | <FundingId1>                                   | <FundingVersion1> | <AllocationFundingStreamCode>                        | <PeriodID>            | <Total1>          |

    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId         | ProviderFundingVersion    | FundingId    | DeliveryUKPRN | ProviderType          | ProviderSubType             | ProviderFundingTotalValue |
    | <ProviderFundingId1>      | <ProviderFundingVersion1> | <FundingId1> | <UKPRN>       | <ProviderType>        | <ProviderSubType>           | <Total1>                  |

    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode           | FundingLineValue | FundingLineType |
    | <ProviderFundingId1>      | <FundingLineCode1>        | <Line1_1>        | Payment         |
   #| <ProviderFundingId1>      | <FundingLineCode2>        | <Line1_2>        | Payment         |
   #| <ProviderFundingId1>      | <FundingLineCode3>        | <Line1_3>        | Payment         |

    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode           | DistributionPeriodId                | ProfilePeriodTypeValue             | ProfilePeriodYear              | ProfilePeriodProfileValue |
    | <ProviderFundingId1>      | <FundingLineCode1>        | <DistributionPeriodId>              | <Deliverablemonth>                 | <DeliverableYear>              | <Profile1_1>              |
   #| <ProviderFundingId1>      | <FundingLineCode2>        | <DistributionPeriodId>              | <Deliverablemonth>                 | <DeliverableYear>              | <Profile1_2>              |
   #| <ProviderFundingId1>      | <FundingLineCode3>        | <DistributionPeriodId>              | <Deliverablemonth>                 | <DeliverableYear>              | <Profile1_3>              |


    And wait '15' seconds

    # Consume stub data (initial)
    Given the override date is '<ProcessDate1>'
    When  the feed-reading process is started and the CFS stub data is processed into CRM



    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode          | FundingPeriod          | FSPGroupCode    | ContractType                            | ReleaseGroupParameterName |
    | <FundingType>            | <FundingPeriod>        | <FSPGroup>      | <ContractType>                          | <ReleaseGroup>            |

    And   message 'ReleaseGroup <ReleaseGroup> = [<ReleaseGroup>]' is written to the Output window

    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                | FundingVersion    | FundingType                | Period           | ContractType                              | AllocationFundingStreamCode                          | FSPGroup    | Status     | SubStatus         | Value    | ContractNo | ContractVersionNo | CreatedBy         | ModifiedBy         | HoldReason | ReleaseGroup       | QueuedOn | QueuedDueToContract |
    | <UKPRN>  | <LegalName>      | <FundingId1>             | <FundingVersion1> | <FundingTypeDesc>          | <FundingPeriod>  | <ContractType>                            | <AllocationFundingStreamCode>                        | <FSPGroup>  | Scheduling | Awaiting Release  | <Total1> | ?          | ?                 | CRM Integration   | CRM Integration    | ?          | [<ReleaseGroup>]   | ?        | ?                   |

    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                            | Action          | CompletedBy     | NewStatus  | NewSubStatus         | PreviousStatus | PreviousSubStatus | Comment |
    | <FundingId1>                         | Record Imported | CRM Integration | Scheduling | Awaiting Release     | ?              | ?                 | ?       |

    And   Release Group '[<ReleaseGroup>]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | <Total1>        |

    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                | FundingVersion    | Period     | AllocationFundingStreamCode                          | Value    | ReleaseGroup          | Status | SubStatus |
    | <UKPRN>  | <FundingId1>             | <FundingVersion1> | <PeriodID> | <AllocationFundingStreamCode>                        | <Total1> | [<ReleaseGroup>]      | ?      | ?         |

    And   Release Group '[<ReleaseGroup>]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

    # Release the Release Group
    Given the override date is '<ReleaseDate1>'
    When  a request is triggered to release the following Release Group
    | ReleaseGroup         |
    | [<ReleaseGroup>]     |

    And   message 'ReleaseGroup <ReleaseGroup> = [<ReleaseGroup>]' is written to the Output window
    Then wait '30' seconds

    Then  Release Group '[<ReleaseGroup>]' has the following characteristics
    | ReleaseStatus | AllocationCount | AllocationValue |
    | Released      | 1               | <Total1>        |

    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType '<FundingType>' and period '<Period>'

    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                | FundingVersion    | Period     | AllocationFundingStreamCode                          | Value    | ReleaseGroup          | Status | SubStatus |
    | <UKPRN>  | <FundingId1>             | <FundingVersion1> | <PeriodID> | <AllocationFundingStreamCode>                        | <Total1> | [<ReleaseGroup>]      | ?      | ?         |

    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | <FundingId1>             | [ContractNo] | 1               | 0                  | Yes            |

    And   Release Group '[<ReleaseGroup>]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus             | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
    | <UKPRN>  | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation        | True          | False               | <ContractStartDate> | <ContractEndDate> |
    | <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                             | False         | False               | <ContractStartDate> | <ContractEndDate> |

    # Publish contract and create merged document
    Given the override date is '<PublishDate>'
    And   a file with filename '<UKPRN>_[ContractNo]_v1.pdf' is created in '<FundingType>-<Period>-Output-Merged Document'
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
    | groupingReason | UKPRN    | FundingId                                      | FundingVersion    | AllocationFundingStreamCode                          | AllocationPeriodId | TotalFundingValue |
    | Contracting    | <UKPRN>  | <FundingId2>                                   | <FundingVersion2> | <AllocationFundingStreamCode>                        | <PeriodID>            | <Total2>          |

    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId         | ProviderFundingVersion    | FundingId    | DeliveryUKPRN | ProviderType          | ProviderSubType             | ProviderFundingTotalValue |
    | <ProviderFundingId2>      | <ProviderFundingVersion2> | <FundingId2> | <UKPRN>       | <ProviderType>        | <ProviderSubType>           | <Total2>                  |

    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode            | FundingLineValue | FundingLineType |
    | <ProviderFundingId2>      | <FundingLineCode1>         | <Line2_1>        | Payment         |
  # | <ProviderFundingId2>      | <FundingLineCode2>         | <Line2_2>        | Payment         |
  # | <ProviderFundingId2>      | <FundingLineCode3>         | <Line2_3>        | Payment         |

    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode             | DistributionPeriodId                | ProfilePeriodTypeValue           | ProfilePeriodYear              | ProfilePeriodProfileValue |
    | <ProviderFundingId2>      | <FundingLineCode1>          | <DistributionPeriodId>              | <Deliverablemonth>               | <DeliverableYear>              | <Profile2_1>              |
  # | <ProviderFundingId2>      | <FundingLineCode2>          | <DistributionPeriodId>              | <Deliverablemonth>               | <DeliverableYear>              | <Profile2_2>              |
  # | <ProviderFundingId2>      | <FundingLineCode3>          | <DistributionPeriodId>              | <Deliverablemonth>               | <DeliverableYear>              | <Profile2_3>              |

    Given the override date is '<ProcessDate2>'
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode          | FundingPeriod          | FSPGroupCode    | ContractType                            | ReleaseGroupParameterName |
    | <FundingType>            | <FundingPeriod>        | <FSPGroup>      | <ContractType>                          | <ReleaseGroup2>            |

    And   message 'ReleaseGroup <ReleaseGroup2> = [<ReleaseGroup2>]' is written to the Output window

    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                | FundingVersion    | FundingType                | Period           | ContractType                              | AllocationFundingStreamCode                            | FSPGroup            | Status      | SubStatus         | Value             | ContractNo        | ContractVersionNo | CreatedBy         | ModifiedBy         | HoldReason | ReleaseGroup        | QueuedOn | QueuedDueToContract |
    | <UKPRN>  | <LegalName>      | <FundingId2>             | <FundingVersion2> | <FundingTypeDesc>          | <FundingPeriod>  | <ContractType>                            | <AllocationFundingStreamCode>                          | <FSPGroup>          | Scheduling  | Awaiting Release  | <Total2>          | ?                 | ?                 | CRM Integration   | CRM Integration    | ?          | [<ReleaseGroup2>]   | ?        | ?                   |

    # Release the amended Release Group
    Given the override date is '<ReleaseDate2>'
    When  a request is triggered to release the following Release Group
    | ReleaseGroup    |
    | [<ReleaseGroup2>]|

    And   message 'ReleaseGroup <ReleaseGroup2> = [<ReleaseGroup2>]' is written to the Output window
    Then wait '30' seconds

    Then  Release Group '[<ReleaseGroup2>]' has the following characteristics
    | ReleaseStatus | AllocationCount | AllocationValue |
    | Released      | 1               | <Total2>        |

    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType '<FundingType>' and period '<Period>'

    Then  the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | <FundingId2>             | [ContractNo] | 2               | 0                  | Yes            |

    And   Release Group '[<ReleaseGroup2>]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    #Then  the following contract values are present in CRM
    #| UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus             | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
    #| <UKPRN>  | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation        | True          | False               | <ContractStartDate> | <ContractEndDate> |
    #| <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                             | False         | False               | <ContractStartDate> | <ContractEndDate> |



    And   Sharepoint file '<UKPRN>_[ContractNo]_v2.pdf' in '<FundingType>-<Period>-Input-Appendices' is copied to 'Datafiles/Downloads' as '<UKPRN>_[ContractNo]_v2.pdf'


    
#        # Publish contract and create merged document
#    Given the override date is '<PublishDate>'
#    And   a file with filename '<UKPRN>_[ContractNo]_v2.pdf' is created in '<FundingType>-2627-Output-Merged Document'
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
    Given the override date is '<CensusEndDate> 22:00'


    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '<FSP1>' AccountingPaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber               | Period          |
    | [<ContractAllocationNumber1>]          | <PaymentPeriod> |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Census End Date/Time | LinkCodeSuffix | Status     |
    | <FSP1>	                 | <PaymentPeriod>               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Status    |
    | <FSP1>	         	     | <PaymentPeriod>               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '<FSP1>' PaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S203.xml'

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

#
#
#    # Part 7c: Payment Batch for ASF2526
#
#    # Change the date
#    Given the override date is '<CensusEndDate> 22:05'
#
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod '<FSP2>' AccountingPaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber             | Period          |
#   | [ContractAllocationNumber2]          | <PaymentPeriod> |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period          | Census End Date/Time | LinkCodeSuffix | Status     |
#    | <FSP2>	                 | <PaymentPeriod>               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period          | Status    |
#    | <FSP2>	         	     | <PaymentPeriod>               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod '<FSP2>' PaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S203_ASFC.xml'

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
    And   there is no CDA report named 'CDA Last Approved Version S203.csv'

    And   the following ADF Pipeline run

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod	  | Version               | Suffix |
    | <FSP1>                  | Last Approved         | S203   |
   #| <FSP2>                  | Last Approved         | S203   |

    Then  a report named 'CDA Last Approved Version S203.csv' is created

    # Check the contents of the CDA Report manually


Examples:
    | UKPRN   | LegalName           | UPIN  | OrgId      | CompanyNumber |  InitialOverrideDate | FundingType       | FundingTypeDesc            | FundingId1                                                      | FundingVersion1 | ProviderFundingId1                            | ProviderFundingVersion1 | ProviderType | ProviderSubType  | FundingLineCode1 | FundingLineCode2  | FundingLineCode3  | Total1 | Line1_1 | Line1_2 | Line1_3 | Profile1_1 | Profile1_2 | Profile1_3 | ProcessDate1 | ReleaseDate1 | PublishDate | ApproveDate | AmendOverrideDate | FundingId2                                                      | FundingVersion2 | ProviderFundingId2                      | ProviderFundingVersion2 | Total2  | Line2_1 | Line2_2 | Line2_3 | Profile2_1 | Profile2_2 | Profile2_3 | ProcessDate2 | ReleaseDate2 | ContractStartDate | ContractEndDate | FSP1             | FSP2           |  PaymentPeriod | FinancialPeriod | CensusEndDate | PeriodID | FSPGroup     | FundingPeriod | DistributionPeriodId | Period | Deliverablemonth | DeliverableYear | ContractType                        |  ReleaseGroup | ReleaseGroup2                | AllocationFundingStreamCode  | ContractAllocationNumber1 | ContractAllocationNumber2 | 
   # ASFG 2526
   #| 10019203| 10019203 Co Ltd     | 119203| ORG0019203 | AA019203      |  01/07/2025          | EDSK              | Education & Skills Funding | ASFG-AY-2526-Contract-Provider-10019203-3_5                     | 3_5             | ASFG-AY-2526-10019203-3_5                     | 3_5                     | Furth        | 18ISP            | ASFG-001         | ASFG-002          | ASFG-004          | 7180.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2025   | 03/07/2025   | 04/07/2025  | 05/07/2025  | 01/11/2025        | ASFG-AY-2526-Contract-Provider-10019203-3_6                     | 3_6             | ASFG-AY-2526-10019203-3_6               | 3_6                     | 15500.00| 1000.00 | 9000.00 | 3500.00 | 1000.00    | 9000.00    | 3500.00    | 03/11/2025   | 05/11/2025   | 01/08/2025        | 31/07/2026      | ASFC-ASCL2526    | ASFC-FCFJ2526  |  202512        | 202509          | 02/12/2025    | AY-2526  | ASF2526      | AY2526        | FY-2526              | 2526   | December         | 2025            | Conditions of Funding (Grant) (SPI) |  CofG(SPI)    | CofG(SPI)                    | ASFG                         |  AllocRef_ASCA            | AllocRef_ASFC             | 
   # ASFG 2627
   #| 10019203| 10019203 Co Ltd     | 119203| ORG0019203 | AA019203      |  01/07/2026          | EDSK              | Education & Skills Funding | ASFG-AY-2627-Contract-Provider-10019203-3_5                     | 3_5             | ASFG-AY-2627-10019203-3_5                     | 3_5                     | Furth        | 18ISP            | ASFG-001         | ASFG-002          | ASFG-004          | 7180.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | ASFG-AY-2627-Contract-Provider-10019203-3_6                     | 3_6             | ASFG-AY-2627-10019203-3_6               | 3_6                     | 15500.00| 1000.00 | 9000.00 | 3500.00 | 1000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | ASFC-ASCL2627    | ASFC-FCFJ2627  |  202612        | 202609          | 02/12/2026    | AY-2627  | ASF2627      | AY2627        | FY-2627              | 2627   | December         | 2026            | Conditions of Funding (Grant) (SPI) |  CofG(SPI)    | CofG(SPI)                    | ASFG                         |  AllocRef_ASCA            | AllocRef_ASFC             | 

   # DADA
   #| 10019203| 10019203 Co Ltd     | 119203| ORG0019203 | AA019203      |  01/07/2026          | DADA              | Dance and Drama Awards     | DADA-AY-2627-Contract-Provider-10019203-3_5                     | 3_5             | DADA-AY-2627-10019203-3_5                     | 3_5                     | Furth        | 07HEP            | DADA-001         | DADA-001          | DADA-001          | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | DADA-AY-2627-Contract-Provider-10019203-3_6                     | 3_6             | DADA-AY-2627-10019203-3_6               | 3_6                     | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | DADA2627         | DADA2627       |  202612        | 202609          | 02/12/2026    | AY-2627  | DADA2627     | AY2627        | FY-2627              | 2627   | December         | 2026            | Contract for Services               |  CfS          | CFS2                         | DADA                         |  AllocRef_DADA            | AllocRef_DADA             |    
   # NLG
   #| 10019203| 10019203 Co Ltd     | 119203| ORG0019203 | AA019203      |  01/07/2026          | NLG               | Non-learning Grants        | NLG-AS-2627-Contract-Provider-10019203-3_5                      | 3_5             | NLG-AS-2627-10019203-3_5                      | 3_5                     | Furth        | 02IPP            | NLG-001          | NLG-001           | NLG-001           | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | NLG-AS-2627-Contract-Provider-10019203-3_6                      | 3_6             | NLG-AS-2627-10019203-3_6                | 3_6                     | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | NLG2627          | NLG2627        |  202612        | 202609          | 02/12/2026    | AS-2627  | NLG2627      | AY2627        | FY-2627              | 2627   | December         | 2026            | Non-learning Grant                  |  NLG          | NLG                          | NLG                          |  AllocRef_NLG             | AllocRef_NLG              | 

   # 1619 College
   #| 10019203| 10019203 Co Ltd     | 119203| ORG0019203 | AA019203      |  01/07/2026          | EDSK              | Education & Skills Funding | 1619-AS-2627-Contract-Provider-10019203-3_7                     | 3_7             | 1619-AS-2627-10019203-3_7                     | 3_7                     | Colleges     | Further education| 1619-001         | 1619-002          | 1619-002          | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | 1619-AS-2627-Contract-Provider-10019203-3_8                     | 3_8             | 1619-AS-2627-10019203-3_8               | 3_8                     | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | 1619ED2627       | 1619ED2627     |  202612        | 202609          | 02/12/2026    | AS-2627  | 16-19ED2627  | AY2627        | FY-2627              | 2627   | December         | 2026            | Accountability Agreement (College)  |  AA_College    | AA_College                   | 1619                         |  AllocRef_16ED            | AllocRef_16ED              | 
   # 1619 SSF
   #| 10019203| 10019203 Co Ltd     | 119203| ORG0019203 | AA019203      |  01/07/2026          | EDSK              | Education & Skills Funding | 1619-AS-2627-Contract-Provider-10019203-3_7                     | 3_7             | 1619-AS-2627-10019203-3_7                     | 3_7                     | Schoo        | 08SSF           | 1619-001          | 1619-002          | 1619-002          | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | 1619-AS-2627-Contract-Provider-10019203-3_8                     | 3_8             | 1619-AS-2627-10019203-3_8               | 3_8                     | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | 1619ED2627       | 1619ED2627     |  202612        | 202609          | 02/12/2026    | AS-2627  | 16-19ED2627  | AY2627        | FY-2627              | 2627   | December         | 2026            | Conditions of Funding (Grant) (LA)  |  CofG(LA)      | CofG(LA)                     | 1619                         |  AllocRef_16ED            | AllocRef_16ED              | 
   # 1619 NFF
   #| 10019203| 10019203 Co Ltd     | 119203| ORG0019203 | AA019203      |  01/07/2026          | EDSK              | Education & Skills Funding | NFF-AS-2627-Contract-Provider-10019203-1_0                      | 1_0             | NFF-AS-2627-10019203-1_0                      | 1_0                     | PRI/LTD BY GUAR/NSC   | Direct Funded Organisation | NFF-001           |                   |        | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | NFF-AS-2627-Contract-Provider-10019203-1_1             | 1_1             | NFF-AS-2627-10019203-1_1                | 1_1                     | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | 1619ED2627       | 1619ED2627     |  202612        | 202609          | 02/12/2026    | AS-2627  | 16-19ED2627  | AY2627        | FY-2627              | 2627   | December         | 2026            | Contract for Services (ITP)         | Cfs_ITP        | Cfs_ITP                     | NFF                           |  AllocRef_16ED            | AllocRef_16ED              | 
   # 1619 1416
   #| 10019204| 10019204 Co Ltd     | 119204| ORG0019204 | AA019204      |  01/07/2026          | EDSK              | Education & Skills Funding | 1416-AY-2627-Contract-Provider-10019204-1_0                     | 1_0             | 1416-AY-2627-10019204-1_0                     | 1_0                     | Colleges              | Further education          | 1416-001          | 1416-002          | 1416-003              | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | 1416-AY-2627-Contract-Provider-10019203-1_1                      | 1_1             | 1416-AY-2627-10019203-1_1                | 1_1                     | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | 1619ED2627       | 1619ED2627     |  202612        | 202609          | 02/12/2026    | AY-2627  | 16-19ED2627  | AY2627        | FY-2627              | 2627   | December         | 2026            | Accountability Agreement (College)  |  AA_College    | AA_College                        | 1416                      |  AllocRef_16ED            | AllocRef_16ED              | 
   # 1619 PP
   #| 10019204| 10019204 Co Ltd     | 119204| ORG0019204 | AA019204      |  01/07/2026          | EDSK              | Education & Skills Funding | PP-FY-2627-Contract-Provider-10019204-1_0                       | 1_0             | PP-FY-2627-10019204-1_0                       | 1_0                     | Colleges              | Further education          | PP-001            | PP-001            | PP-001                | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | PP-FY-2627-Contract-Provider-10019203-1_1                        | 1_1             | PP-FY-2627-10019203-1_1                  | 1_1                     | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | 1619ED2627       | 1619ED2627     |  202612        | 202609          | 02/12/2026    | FY-2627  | 16-19ED2627  | AY2627        | FY-2627              | 2627   | December         | 2026            | Accountability Agreement (College)  |  AA_College    | AA_College                        | PP                        |  AllocRef_16ED            | AllocRef_16ED              | 
   # 1619 PSG
   #| 10019204| 10019204 Co Ltd     | 119204| ORG0019204 | AA019204      |  01/07/2026          | EDSK              | Education & Skills Funding | PSG-AY-2627-Contract-Provider-10019204-1_0                      | 1_0             | PSG-AY-2627-10019204-1_0                      | 1_0                     | Other types           | Special post 16 institution    | PSG-001       | PSG-002           |                       | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | PSG-AY-2627-Contract-Provider-10019204-1_1                       | 1_1             | PSG-AY-2627-10019204-1_1                 | 1_1                     | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | 1619ED2627       | 1619ED2627     |  202612        | 202609          | 02/12/2026    | AY-2627  | 16-19ED2627  | AY2627        | AY-2627              | 2627   | December         | 2026            | Conditions of Funding (Grant) (SPI)     |  CofG_SPI      | CofG_SPI                          | PSG                       |  AllocRef_16ED            | AllocRef_16ED              | 
   # 1619 UIFSM
   #| 10019204| 10019204 Co Ltd     | 119204| ORG0019204 | AA019204      |  01/07/2026          | EDSK              | Education & Skills Funding | UIFSM-AY-2627-Contract-Provider-10019204-1_0                    | 1_0             | UIFSM-AY-2627-10019204-1_0                    | 1_0                     | Universities          | Higher education institutions  | UIFSM-001     | UIFSM-002         |                       | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | UIFSM-AY-2627-Contract-Provider-10019204-1_1                     | 1_1           | UIFSM-AY-2627-10019204-1_1                 | 1_1                     | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | 1619ED2627       | 1619ED2627     |  202612        | 202609          | 02/12/2026    | AY-2627  | 16-19ED2627  | AY2627        | AY-2627              | 2627   | December         | 2026            | Conditions of Funding (Grant) (HEI) |  CofG_HEI      | CofG_HEI                          | UIFSM                     |  AllocRef_16ED            | AllocRef_16ED              | 
   # 1619 NMSS
   #| 10019204 | 10019204 Co Ltd    | 119204| ORG0019204 | AA019204      |  01/07/2026          | EDSK              | Education & Skills Funding | NMSS-AY-2627-Contract-Provider-10019204-1_0                     | 1_0             | NMSS-AY-2627-10019204-1_0                     | 1_0                     | Special schools       | Non-maintained special school  | NMSS-001      | NMSS-002          | NMSS-003              | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | NMSS-AY-2627-Contract-Provider-10019204-1_1                     | 1_1            | NMSS-AY-2627-10019204-1_1                 | 1_1                      | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026        | 31/07/2027      | 1619ED2627       | 1619ED2627     |  202612        | 202609          | 02/12/2026    | AY-2627  | 16-19ED2627  | AY2627        | AY-2627              | 2627   | December         | 2026            |  Conditions of Funding (Grant) (NMSS)  | CofG_NMSS    | CofG_NMSS                         | NMSS                     |  AllocRef_16ED            | AllocRef_16ED              | 

   # LOANS ALLBC
    | 10019204 |  10019204 Co Ltd    | 119204| ORG0019204 | AA019204      |  01/07/2026          | EDSK              | Education & Skills Funding | LOANS-AY-2627-Contract-Provider-10019204-1_0                    | 1_0             | LOANS-AY-2627-10019204-1_0                    | 1_0                     | Furth         | 05ADC          | LOANS-002          | LOANS-002        | LOANS-002         | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 01/11/2026        | LOANS-AY-2627-Contract-Provider-10019204-1_1                     | 1_1            | LOANS-AY-2627-10019204-1_1                 | 1_1                      | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 03/11/2026   | 05/11/2026   | 01/08/2026    | 31/07/2027      | ALLBC2627       | ALLBC2627     |  202612        | 202609          | 02/12/2026    | AY-2627  | LOANS2627      | AY2627        | AY-2627              | 2627   | December         | 2026            | Accountability Agreement (College)  | AA_College    | AA_College                     | LOANS                      |  AllocRef_ALLC            | AllocRef_ALLC              | 




@AcceptanceTest @Complete
@CFS @PoA
Scenario Outline: S206 Import, release and approve LOANS grant allocations; check docs, CRM and feeds
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '<UKPRN>'
    And   there is no Funding Allocation data in CRM for UKPRN '<UKPRN>'
    And   there is no Contract, Task or Workflow data for UKPRN '<UKPRN>'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '<UKPRN>'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '<UKPRN>'

    And   there are no files prefixed '<UKPRN>' in the Sharepoint '<FundingType>-<Period>-Input-Appendices' folder

    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode          | FundingPeriod          | FSPGroupCode    | ContractType        |
    | <FundingType>            | <FundingPeriod>        | <FSPGroup>      | <ContractType>      |

    And   there is no data in the ContractRequest.FundingAllocationRelease table
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP        |
    | <FSP>      |

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
    | <UKPRN>  |

    # Populate the CFS stub with ASF data (initial)
    Given the override date is '<InitialOverrideDate>'
    And   there is no data in the CFS stub

    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                      | FundingVersion    | AllocationFundingStreamCode                          | AllocationPeriodId    | TotalFundingValue |
    | Contracting    | <UKPRN>  | <FundingId1>                                   | <FundingVersion1> | <AllocationFundingStreamCode>                        | <PeriodID>            | <Total1>          |

    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId         | ProviderFundingVersion    | FundingId    | DeliveryUKPRN | ProviderType          | ProviderSubType             | ProviderFundingTotalValue |
    | <ProviderFundingId1>      | <ProviderFundingVersion1> | <FundingId1> | <UKPRN>       | <ProviderType>        | <ProviderSubType>           | <Total1>                  |

    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode           | FundingLineValue | FundingLineType |
    | <ProviderFundingId1>      | <FundingLineCode>         | <Line1_1>        | Payment         |
   #| <ProviderFundingId1>      | <FundingLineCode3>        | <Line1_3>        | Payment         |

    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode           | DistributionPeriodId                | ProfilePeriodTypeValue             | ProfilePeriodYear              | ProfilePeriodProfileValue |
    | <ProviderFundingId1>      | <FundingLineCode>         | <DistributionPeriodId>              | <Deliverablemonth>                 | <DeliverableYear>              | <Profile1_1>              |
   #| <ProviderFundingId1>      | <FundingLineCode3>        | <DistributionPeriodId>              | <Deliverablemonth>                 | <DeliverableYear>              | <Profile1_3>              |

    # Consume stub data (initial)
    Given the override date is '<ProcessDate1>'
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode          | FundingPeriod          | FSPGroupCode    | ContractType                            | ReleaseGroupParameterName |
    | <FundingType>            | <FundingPeriod>        | <FSPGroup>      | <ContractType>                          | <ReleaseGroup>            |

    And   message 'ReleaseGroup <ReleaseGroup> = [<ReleaseGroup>]' is written to the Output window

    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                | FundingVersion    | FundingType                | Period           | ContractType                              | AllocationFundingStreamCode                          | FSPGroup    | Status     | SubStatus         | Value    | ContractNo | ContractVersionNo | CreatedBy         | ModifiedBy         | HoldReason | ReleaseGroup       | QueuedOn | QueuedDueToContract |
    | <UKPRN>  | <LegalName>      | <FundingId1>             | <FundingVersion1> | <FundingTypeDesc>          | <FundingPeriod>  | <ContractType>                            | <AllocationFundingStreamCode>                        | <FSPGroup>  | Scheduling | Awaiting Release  | <Total1> | ?          | ?                 | CRM Integration   | CRM Integration    | ?          | [<ReleaseGroup>]   | ?        | ?                   |

    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                            | Action          | CompletedBy     | NewStatus  | NewSubStatus         | PreviousStatus | PreviousSubStatus | Comment |
    | <FundingId1>                         | Record Imported | CRM Integration | Scheduling | Awaiting Release     | ?              | ?                 | ?       |

    And   Release Group '[<ReleaseGroup>]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | <Total1>        |

    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                | FundingVersion    | Period     | AllocationFundingStreamCode                          | Value    | ReleaseGroup          | Status | SubStatus |
    | <UKPRN>  | <FundingId1>             | <FundingVersion1> | <PeriodID> | <AllocationFundingStreamCode>                        | <Total1> | [<ReleaseGroup>]      | ?      | ?         |

    And   Release Group '[<ReleaseGroup>]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

    # Release the Release Group
    Given the override date is '<ReleaseDate1>'
    When  a request is triggered to release the following Release Group
    | ReleaseGroup         |
    | [<ReleaseGroup>]     |

    And   message 'ReleaseGroup <ReleaseGroup> = [<ReleaseGroup>]' is written to the Output window
    Then wait '30' seconds

    Then  Release Group '[<ReleaseGroup>]' has the following characteristics
    | ReleaseStatus | AllocationCount | AllocationValue |
    | Released      | 1               | <Total1>        |

    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType '<FundingType>' and period '<Period>'

    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                | FundingVersion    | Period     | AllocationFundingStreamCode                          | Value    | ReleaseGroup          | Status | SubStatus |
    | <UKPRN>  | <FundingId1>             | <FundingVersion1> | <PeriodID> | <AllocationFundingStreamCode>                        | <Total1> | [<ReleaseGroup>]      | ?      | ?         |

    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | <FundingId1>             | [ContractNo] | 1               | 0                  | Yes            |

    And   Release Group '[<ReleaseGroup>]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus             | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
    | <UKPRN>  | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation        | True          | False               | <ContractStartDate> | <ContractEndDate> |
    | <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                             | False         | False               | <ContractStartDate> | <ContractEndDate> |

    # Publish contract and create merged document
    Given the override date is '<PublishDate>'
    And   a file with filename '<UKPRN>_[ContractNo]_v1.pdf' is created in '<FundingType>-<Period>-Output-Merged Document'
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
    
    


    # Add actuals to the contract for ALLB2627

    # Change the date
    Given the override date is '04/12/2026'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId '<OrgId>'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2026
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2627        | R01                  | <OrgId>        | CM             | 202608 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2498.70     |
    | ILR2627        | R01                  | <OrgId>        | CM             | 202608 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1347.24     |
    | ILR2627        | R01                  | <OrgId>        | CM             | 202608 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2090.31     |
    #
    | ILR2627        | R01                  | <OrgId>     | CM             | 202609 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 679.53      |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202609 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1330.31     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202609 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2364.35     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202610 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1764.18     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202610 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1048.84     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202610 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2091.38     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202611 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 194.56      |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202611 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1727.00     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202611 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 748.89      |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202612 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2368.13     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202612 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 2322.55     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202612 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2213.62     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202701 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1475.22     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202701 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 614.34      |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202701 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 1898.97     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202702 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 936.70      |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202702 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 2089.85     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202702 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 892.58      |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202703 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2441.41     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202703 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 632.58      |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202703 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 1493.84     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202704 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1783.60     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202704 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 609.71      |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202704 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 951.32      |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202705 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2100.55     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202705 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1159.46     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202705 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 200.33      |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202706 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1309.97     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202706 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 278.64      |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202706 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 1200.39     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202707 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1747.56     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202707 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1910.20     |
   #| ILR2627        | R01                  | <OrgId>     | CM             | 202707 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2472.73     |


    | ILR2627        | R01                  | <OrgId>     | CM             | 202608 | ALLF2627                | [AllocRef_ALLF]          | ?          | 2               | 0            | 7498.70     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202608 | ALLF2627                | [AllocRef_ALLF]          | ?          | 3               | 0            | 2347.24     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202608 | ALLF2627                | [AllocRef_ALLF]          | ?          | 4               | 0            | 5090.31     |
    #
    | ILR2627        | R01                  | <OrgId>     | CM             | 202609 | ALLF2627                | [AllocRef_ALLF]          | ?          | 2               | 0            | 679.53      |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202609 | ALLF2627                | [AllocRef_ALLF]          | ?          | 3               | 0            | 1330.31     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202609 | ALLF2627                | [AllocRef_ALLF]          | ?          | 4               | 0            | 2364.35     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202610 | ALLF2627                | [AllocRef_ALLF]          | ?          | 2               | 0            | 1764.18     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202610 | ALLF2627                | [AllocRef_ALLF]          | ?          | 3               | 0            | 1048.84     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202610 | ALLF2627                | [AllocRef_ALLF]          | ?          | 4               | 0            | 2091.38     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202611 | ALLF2627                | [AllocRef_ALLF]          | ?          | 2               | 0            | 194.56      |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202611 | ALLF2627                | [AllocRef_ALLF]          | ?          | 3               | 0            | 1727.00     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202611 | ALLF2627                | [AllocRef_ALLF]          | ?          | 4               | 0            | 748.89      |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202612 | ALLF2627                | [AllocRef_ALLF]          | ?          | 2               | 0            | 2368.13     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202612 | ALLF2627                | [AllocRef_ALLF]          | ?          | 3               | 0            | 2322.55     |
    | ILR2627        | R01                  | <OrgId>     | CM             | 202612 | ALLF2627                | [AllocRef_ALLF]          | ?          | 4               | 0            | 2213.62     |


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check actuals in CRM
#
#    # Check the ACTUAL VALUES in CRM on the latest approved contract
#    Then  the Actuals Value Data is as follows
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
#    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 4942.41   | 2498.70  | 679.53   | 1764.18  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 3726.39   | 1347.24  | 1330.31  | 1048.84  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 6546.04   | 2090.31  | 2364.35  | 2091.38  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    #
#    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
#    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 4942.41   | 2498.70  | 679.53   | 1764.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 3726.39   | 1347.24  | 1330.31  | 1048.84  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 6546.04   | 2090.31  | 2364.35  | 2091.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
#    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 4942.41   | 2498.70  | 679.53   | 1764.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 3726.39   | 1347.24  | 1330.31  | 1048.84  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 6546.04   | 2090.31  | 2364.35  | 2091.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#

    # --- Amend stub data ---
    Given the override date is '<AmendOverrideDate>'
    And   there is no data in the CFS stub

    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                      | FundingVersion    | AllocationFundingStreamCode                          | AllocationPeriodId | TotalFundingValue |
    | Contracting    | <UKPRN>  | <FundingId2>                                   | <FundingVersion2> | <AllocationFundingStreamCode>                        | <PeriodID>         | <Total2>          |

    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId         | ProviderFundingVersion    | FundingId    | DeliveryUKPRN | ProviderType          | ProviderSubType             | ProviderFundingTotalValue |
    | <ProviderFundingId2>      | <ProviderFundingVersion2> | <FundingId2> | <UKPRN>       | <ProviderType>        | <ProviderSubType>           | <Total2>                  |

    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode            | FundingLineValue | FundingLineType |
    | <ProviderFundingId2>      | <FundingLineCode>          | <Line2_1>        | Payment         |
  # | <ProviderFundingId2>      | <FundingLineCode2>         | <Line2_2>        | Payment         |
  # | <ProviderFundingId2>      | <FundingLineCode3>         | <Line2_3>        | Payment         |

    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode             | DistributionPeriodId                | ProfilePeriodTypeValue           | ProfilePeriodYear              | ProfilePeriodProfileValue |
    | <ProviderFundingId2>      | <FundingLineCode>           | <DistributionPeriodId>              | <Deliverablemonth>               | <DeliverableYear>              | <Profile2_1>              |
  # | <ProviderFundingId2>      | <FundingLineCode2>          | <DistributionPeriodId>              | <Deliverablemonth>               | <DeliverableYear>              | <Profile2_2>              |
  # | <ProviderFundingId2>      | <FundingLineCode3>          | <DistributionPeriodId>              | <Deliverablemonth>               | <DeliverableYear>              | <Profile2_3>              |

    Given the override date is '<ProcessDate2>'
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode          | FundingPeriod          | FSPGroupCode    | ContractType                            | ReleaseGroupParameterName |
    | <FundingType>            | <FundingPeriod>        | <FSPGroup>      | <ContractType>                          | <ReleaseGroup2>           |

    And   message 'ReleaseGroup <ReleaseGroup2> = [<ReleaseGroup2>]' is written to the Output window

    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                | FundingVersion    | FundingType                | Period           | ContractType                              | AllocationFundingStreamCode                            | FSPGroup            | Status      | SubStatus         | Value             | ContractNo        | ContractVersionNo | CreatedBy         | ModifiedBy         | HoldReason | ReleaseGroup        | QueuedOn | QueuedDueToContract |
    | <UKPRN>  | <LegalName>      | <FundingId2>             | <FundingVersion2> | <FundingTypeDesc>          | <FundingPeriod>  | <ContractType>                            | <AllocationFundingStreamCode>                          | <FSPGroup>          | Scheduling  | Awaiting Release  | <Total2>          | ?                 | ?                 | CRM Integration   | CRM Integration    | ?          | [<ReleaseGroup2>]   | ?        | ?                   |

    # Release the amended Release Group
    Given the override date is '<ReleaseDate2>'
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [<ReleaseGroup2>] |

    And   message 'ReleaseGroup <ReleaseGroup2> = [<ReleaseGroup2>]' is written to the Output window
    Then wait '30' seconds

    Then  Release Group '[<ReleaseGroup2>]' has the following characteristics
    | ReleaseStatus | AllocationCount | AllocationValue |
    | Released      | 1               | <Total2>        |

    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType '<FundingType>' and period '<Period>'

    Then  the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | <FundingId2>             | [ContractNo] | 2               | 0                  | Yes            |

    And   Release Group '[<ReleaseGroup2>]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    #Then  the following contract values are present in CRM
    #| UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus             | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
    #| <UKPRN>  | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation        | True          | False               | <ContractStartDate> | <ContractEndDate> |
    #| <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                             | False         | False               | <ContractStartDate> | <ContractEndDate> |


    And   Sharepoint file '<UKPRN>_[ContractNo]_v2.pdf' in '<FundingType>-<Period>-Input-Appendices' is copied to 'Datafiles/Downloads' as '<UKPRN>_[ContractNo]_v2.pdf'


    
#        # Publish contract and create merged document
#    Given the override date is '<PublishDate>'
#    And   a file with filename '<UKPRN>_[ContractNo]_v2.pdf' is created in '<FundingType>-2627-Output-Merged Document'
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


    # Part 7c: Payment Batch for ALLB2627
    # Payment run is not applicable for ALLF. It needs to be disabled before running ALLF


    # Change the date
    Given the override date is '<CensusEndDate> 22:00'


    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '<FSP>' AccountingPaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A'


    And wait '15' seconds

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber               | Period          |
    | [<ContractAllocationNumber>]           | <PaymentPeriod> |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Census End Date/Time | LinkCodeSuffix | Status     |
    | <FSP>	                     | <PaymentPeriod>               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Status    |
    | <FSP>	         	         | <PaymentPeriod>               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '<FSP>' PaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S206.xml'

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
    Given the override date is '12/12/2026'
    
    # Check the contents of the CDA report
    And   there is no CDA report named 'CDA Last Approved Version S206.csv'

    And   the following ADF Pipeline run

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod	  | Version               | Suffix |
    | <FSP>                   | Last Approved         | S206   |

    Then  a report named 'CDA Last Approved Version S206.csv' is created

    # Check the contents of the CDA Report manually


Examples:
     | UKPRN    | LegalName           | UPIN  | OrgId      | CompanyNumber |  InitialOverrideDate | FundingType       | FundingTypeDesc            | FundingId1                                                      | FundingVersion1 | ProviderFundingId1                            | ProviderFundingVersion1 | ProviderType | ProviderSubType  | FundingLineCode  | Total1 | Line1_1 | Line1_2 | Line1_3 | Profile1_1 | Profile1_2 | Profile1_3 | ProcessDate1 | ReleaseDate1 | PublishDate | ApproveDate | AmendOverrideDate | FundingId2                                                      | FundingVersion2 | ProviderFundingId2                      | ProviderFundingVersion2 | Total2  | Line2_1 | Line2_2 | Line2_3 | Profile2_1 | Profile2_2 | Profile2_3 | ProcessDate2 | ReleaseDate2 | ContractStartDate | ContractEndDate | FSP      |         PaymentPeriod | FinancialPeriod | CensusEndDate | PeriodID | FSPGroup     | FundingPeriod | DistributionPeriodId | Period | Deliverablemonth | DeliverableYear | ContractType                        |  ReleaseGroup | ReleaseGroup2                | AllocationFundingStreamCode  | ContractAllocationNumber | 

   # LOANS ALLB
     | 10019204 |  10019204 Co Ltd    | 119204| ORG0019204 | AA019204      |  01/07/2026          | EDSK              | Education & Skills Funding | LOANS-AY-2627-Contract-Provider-10019204-1_0                    | 1_0             | LOANS-AY-2627-10019204-1_0                    | 1_0                     | Furth         | 02IPP          | LOANS-003          | 1000.00| 1000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 11/11/2026        | LOANS-AY-2627-Contract-Provider-10019204-1_1                     | 1_1            | LOANS-AY-2627-10019204-1_1                 | 1_1                      | 2000.00 | 2000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 13/11/2026   | 15/11/2026   | 01/08/2026    | 31/07/2027      | ALLB2627   |       202611        | 202608          | 08/12/2026    | AY-2627  | LOANS2627    | AY2627        | AY-2627              | 2627   | December         | 2026            | Contract for Services (ITP)        |  CFS_ITP      | CFS_ITP                      | LOANS                        |  AllocRef_ALLB      |         
   # LOANS ALLF
   # | 10019204 |  10019204 Co Ltd    | 119204| ORG0019204 | AA019204      |  01/07/2026          | EDSK              | Education & Skills Funding | LOANS-AY-2627-Contract-Provider-10019204-2_0                    | 2_0             | LOANS-AY-2627-10019204-2_0                    | 2_0                     | Furth         | 02IPP          | LOANS-001          | 2000.00| 2000.00 | 3680.00 | 2500.00 | 1000.00    | 3680.00    | 2500.00    | 02/07/2026   | 03/07/2026   | 04/07/2026  | 05/07/2026  | 11/11/2026        | LOANS-AY-2627-Contract-Provider-10019204-2_1                     | 2_1            | LOANS-AY-2627-10019204-2_1                 | 2_1                      | 3000.00 | 3000.00 | 9000.00 | 3500.00 | 2000.00    | 9000.00    | 3500.00    | 13/11/2026   | 15/11/2026   | 01/08/2026    | 31/07/2027      | ALLF2627   |       202611        | 202608          | 17/12/2026    | AY-2627  | LOANS2627    | AY2627        | AY-2627              | 2627   | December         | 2026            | Contract for Services (ITP)        |  CFS_ITP      | CFS_ITP                      | LOANS                        |  AllocRef_ALLF      |        




   
   