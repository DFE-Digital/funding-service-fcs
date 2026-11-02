Feature: ASFContract


@AcceptanceTest @Complete
@Long2Run @Long2Run67
Scenario Outline: S202 Import and release ASF allocations; approve, amend and repeat 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '<UKPRN>'
    And   there is no Contract, Task or Workflow data for UKPRN '<UKPRN>'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '<UKPRN>'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '<UKPRN>'

    And   there are no files prefixed '<UKPRN>' in the Sharepoint 'AEB2023-2627-Input-Appendices' folder

    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | AEB2023         | AY2627        | ASF2023_2627 | Contract for Services                   |

    And   there is no data in the ContractRequest.FundingAllocationRelease table
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASF2023-AS2627    |
    | ASF2023-FCFJ2627  |

    Given there is no Organisation data in CRM for UKPRN '<UKPRN>'
    And   there is no caseload advisor for UKPRN '<UKPRN>'
    And   there is no Organisation data in PaaS for the following UKPRNs
    | UKPRN    |
    | <UKPRN> |
    And   caseload advisor 'FCS2 Test' is assigned to provider '<LegalName>' with UKPRN '<UKPRN>' and OrgId '<OrgId>' and has 'FCS1 Test' as a manager

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status  | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | Town     | Postcode  |
    | <UKPRN>  | <UPIN> | <LegalName>     | 0              | Active  | Yes           | <CompanyNumber> | ?           | <AddressLine1>         | <Town>   | <Postcode> |

    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | <UKPRN> |

    # Populate the stub with ASF data (initial)
    Given the override date is '<InitialOverrideDate>'
    And   there is no data in the CFS stub

    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion    | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | <UKPRN>  | <FundingId1>                                          | <FundingVersion1> | ASFC                        | AY-2627            | <Total1>          |

    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId             | ProviderFundingVersion    | FundingId     | DeliveryUKPRN | ProviderType                                 | ProviderSubType                                   | ProviderFundingTotalValue |
    | <ProviderFundingId1>          | <ProviderFundingVersion1> | <FundingId1>  | <UKPRN>       | <ProviderType1>                              | <ProviderSubType1>                                | <Total1>                  |

    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode | FundingLineValue | FundingLineType |
    | <ProviderFundingId1>      | ASFC-001        | <Line1_1>        | Payment         |
    | <ProviderFundingId1>      | ASFC-002        | <Line1_2>        | Payment         |
    | <ProviderFundingId1>      | ASFC-003        | <Line1_3>        | Payment         |
    | <ProviderFundingId1>      | ASFC-004        | <Line1_4>        | Payment         |

    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | <ProviderFundingId1>      | ASFC-001        | FY-2627              | <Profile1_1>           | <ProfileYear1_1>  | <ProfileValue1_1>         |
    | <ProviderFundingId1>      | ASFC-002        | FY-2627              | <Profile1_2>           | <ProfileYear1_2>  | <ProfileValue1_2>         |
    | <ProviderFundingId1>      | ASFC-003        | FY-2627              | <Profile1_3>           | <ProfileYear1_3>  | <ProfileValue1_3>         |
    | <ProviderFundingId1>      | ASFC-004        | FY-2627              | <Profile1_4>           | <ProfileYear1_4>  | <ProfileValue1_4>         |

    # Consume stub data (initial)
    Given the override date is '<ProcessDate1>'
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Then wait '20' seconds

    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode      | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2627        | ASF2023_2627      | Contract for Services                   | <ReleaseParamName>        |

    And   message 'ReleaseGroup <ReleaseParamName> = [<ReleaseParamName>]' is written to the Output window

    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                | FundingVersion    | FundingType                               | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup         | QueuedOn   | QueuedDueToContract |
    | <UKPRN>  | <LegalName>      | <FundingId1>             | <FundingVersion1> | Adult Education Budget - 2023 Procurement | AY2627  | Contract for Services                    | ASFC                        | ASF2023_2627    | Scheduling        | Awaiting Release  | <Total1>    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [<ReleaseParamName>] | ?          | ?                   |

    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                            | Action          | CompletedBy     | NewStatus  | NewSubStatus         | PreviousStatus | PreviousSubStatus | Comment |
    | <FundingId1>                         | Record Imported | CRM Integration | Scheduling | Awaiting Release     | ?              | ?                 | ?       |

    And   Release Group '[<ReleaseParamName>]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | <Total1>        |

    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                | FundingVersion    | Period  | AllocationFundingStreamCode | Value   | ReleaseGroup   | Status | SubStatus |
    | <UKPRN>  | <FundingId1>             | <FundingVersion1> | AY-2627 | ASFC                        | <Total1> | [<ReleaseParamName>] | ?      | ?         |

    And   Release Group '[<ReleaseParamName>]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'


    # Release the Release Group
    Given the override date is '<ReleaseDate1>'
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [<ReleaseParamName>] |
    And   message 'ReleaseGroup <ReleaseParamName> = [<ReleaseParamName>]' is written to the Output window
    Then wait '30' seconds

    Then  Release Group '[<ReleaseParamName>]' has the following characteristics
    | ReleaseStatus | AllocationCount | AllocationValue |
    | Released      | 1               | <Total1>        |

    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType 'AEB2023' and period '2627'

    Then the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | <FundingId1>             | [ContractNo] | 1               | 0                  | Yes            |

    And   Release Group '[<ReleaseParamName>]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus             | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
    | <UKPRN>  | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation        | True          | False               | <ContractStartDate> | <ContractEndDate> |
    | <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                             | False         | False               | <ContractStartDate> | <ContractEndDate> |

    # Publish contract and create merged document
    Given the override date is '<PublishDate>'
    And   a file with filename '<UKPRN>_[ContractNo]_v1.pdf' is created in 'AEB2023-2627-Output-Merged Document'
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
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | <UKPRN>  | <FundingId2>                                          | <FundingVersion2> | ASFC                      | AY-2627            | <Total2>          |

    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId             | ProviderFundingVersion | FundingId     | DeliveryUKPRN | ProviderType                | ProviderSubType         | ProviderFundingTotalValue |
    | <ProviderFundingId2>          | <ProviderFundingVersion2> | <FundingId2> | <UKPRN>       | <ProviderType2>             | <ProviderSubType2>      | <Total2>                  |

    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode | FundingLineValue | FundingLineType |
    | <ProviderFundingId2>      | ASFC-001        | <Line2_1>        | Payment         |
    | <ProviderFundingId2>      | ASFC-002        | <Line2_2>        | Payment         |
    | <ProviderFundingId2>      | ASFC-003        | <Line2_3>        | Payment         |
    | <ProviderFundingId2>      | ASFC-004        | <Line2_4>        | Payment         |

    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId         | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | <ProviderFundingId2>      | ASFC-001        | FY-2627              | <Profile2_1>           | <ProfileYear2_1>  | <ProfileValue2_1>         |
    | <ProviderFundingId2>      | ASFC-002        | FY-2627              | <Profile2_2>           | <ProfileYear2_2>  | <ProfileValue2_2>         |
    | <ProviderFundingId2>      | ASFC-003        | FY-2627              | <Profile2_3>           | <ProfileYear2_3>  | <ProfileValue2_3>         |
    | <ProviderFundingId2>      | ASFC-004        | FY-2627              | <Profile2_4>           | <ProfileYear2_4>  | <ProfileValue2_4>         |


    Then wait '20' seconds

    Given the override date is '<ProcessDate2>'
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode      | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2627        | ASF2023_2627      | Contract for Services                   | <ReleaseParamName>        |

    And   message 'ReleaseGroup <ReleaseParamName> = [<ReleaseParamName>]' is written to the Output window

    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                | FundingVersion    | FundingType                               | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | <UKPRN>  | <LegalName>      | <FundingId2>             | <FundingVersion2> | Adult Education Budget - 2023 Procurement | AY2627  | Contract for Services                   | ASFC                        | ASF2023_2627    | Scheduling        | Awaiting Release  | <Total2>    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [<ReleaseParamName>] | ?          | ?                   |

    # Release the amended Release Group
    Given the override date is '<ReleaseDate2>'
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [<ReleaseParamName>] |
    And   message 'ReleaseGroup <ReleaseParamName> = [<ReleaseParamName>]' is written to the Output window
    Then wait '30' seconds

    Then  Release Group '[<ReleaseParamName>]' has the following characteristics
    | ReleaseStatus | AllocationCount | AllocationValue |
    | Released      | 1               | <Total2>        |

    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType 'AEB2023' and period '2627'

    Then  the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | <FundingId2>             | [ContractNo] | 2               | 0                  | Yes            |

    And   Release Group '[<ReleaseParamName>]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    #And the following contract values are present in CRM (post-amend)
    #| UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus             | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate |
    #| <UKPRN>  | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation        | True          | False               | <ContractStartDate> | <ContractEndDate> |
    #| <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                             | False         | False               | <ContractStartDate> | <ContractEndDate> |

    And   Sharepoint file '<UKPRN>_[ContractNo]_v2.pdf' in 'AEB2023-2627-Input-Appendices' is copied to 'Datafiles/Downloads' as '<UKPRN>_[ContractNo]_v2.pdf'

    # Payment and actuals steps follow unchanged but use the placeholders above for IDs, dates and totals


    


    # Part 5: Add Actuals for 26/27 then check CRM

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
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 656.38      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 514.81      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 564.11      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1411.24     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 478.56      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1469.21     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1163.17     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 2352.37     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 465.26      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 2003.87     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 699.93      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 844.84      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1604.57     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_ASCL>          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 860.77      |
 #
 #   #                                                                                                            
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1951.00     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 627.27      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1274.11     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1790.98     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 615.15      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1977.70     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202608 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1956.70     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 804.17      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 855.21      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 631.06      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 938.44      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 995.84      |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1931.92     |
    | ILR2627        | R02                  | ORG0010062     | CM             | 202609 | <FSP_FCFJ>         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 2158.27     |



    Then wait '30' seconds


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then wait '30' seconds


 #
#    # Check the ACTUAL VALUES in CRM on the latest approved contract
#    Then  the Actuals Value Data is as follows
#    | ContractNumber | AllocationRef | DeliverableCode | Total     | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
#    | [ContractNo]   | [AllocRef_ASFJ23]| 1             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFJ23]| 2             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFJ23]| 3             | 2755.17   | 1951.00  | 804.17   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFJ23]| 4             | 1482.48   | 627.27   | 855.21   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFJ23]| 5             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFJ23]| 6             | 1905.17   | 1274.11  | 631.06   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFJ23]| 7             | 2729.42   | 1790.98  | 938.44   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFJ23]| 8             | 1610.99   | 615.15   | 995.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFJ23]| 9             | 3909.62   | 1977.70  | 1931.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFJ23]| 10            | 4114.97   | 1956.70  | 2158.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    #
#    | [ContractNo]   | [AllocRef_ASFA23]| 1             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFA23]| 2             | 3008.75   | 656.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFA23]| 3             | 980.07    | 514.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFA23]| 4             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFA23]| 5             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFA23]| 6             | 2567.98   | 564.11   | 2003.87  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFA23]| 7             | 2111.17   | 1411.24  | 699.93   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFA23]| 8             | 1323.40   | 478.56   | 844.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFA23]| 9             | 3073.78   | 1469.21  | 1604.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_ASFA23]| 10            | 2023.94   | 1163.17  | 860.77   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#
#
#
#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
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
#
#


    

    # Part 7c: Payment Batch for ASF2526

    # Change the date
    Given the override date is '08/10/2026 22:00'


    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '<FSP_ASCL>' AccountingPaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period          |
    | [AllocRef_ASFA23]          | <PaymentPeriod> |

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
    And   the Payment feed xml for FundingStreamPeriod '<FSP_ASCL>' PaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S202_AS.xml'

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
    Given the override date is '08/10/2026 22:00'


    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '<FSP_FCFJ>' AccountingPaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber   | Period          |
    | [AllocRef_ASFJ23]          | <PaymentPeriod> |

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
    And   the Payment feed xml for FundingStreamPeriod '<FSP_FCFJ>' PaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S202_FCFJ.xml'

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
    Given the override date is '09/12/2026'
    
    # Check the contents of the CDA report
    And   there is no CDA report named 'CDA Last Approved Version S202.csv'

    And   the following ADF Pipeline run

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod	  | Version               | Suffix |
    | <FSP_ASCL>              | Last Approved         | S202   |
    | <FSP_FCFJ>              | Last Approved         | S202   |

    Then  a report named 'CDA Last Approved Version S202.csv' is created

    # Check the contents of the CDA Report manually


    Given the override date is reset

Examples:
    | UKPRN   | LegalName           | UPIN  | OrgId      | CompanyNumber | AddressLine1        | Town   | Postcode | InitialOverrideDate | FundingId1                                                       | FundingVersion1 | ProviderFundingId1                     | ProviderFundingVersion1 | ProviderType1                         | ProviderSubType1                          | Total1  | Line1_1 | Line1_2 | Line1_3 | Line1_4 | Profile1_1 | ProfileYear1_1 | ProfileValue1_1 | Profile1_2 | ProfileYear1_2 | ProfileValue1_2 | Profile1_3 | ProfileYear1_3 | ProfileValue1_3 | Profile1_4 | ProfileYear1_4 | ProfileValue1_4 | ProcessDate1 | ReleaseDate1 | PublishDate | ApproveDate | ReleaseParamName | AmendOverrideDate | FundingId2                                                       | FundingVersion2 | ProviderFundingId2                     | ProviderFundingVersion2 | ProviderType2 | ProviderSubType2 | Total2  | Line2_1 | Line2_2 | Line2_3 | Line2_4 | Profile2_1 | ProfileYear2_1 | ProfileValue2_1 | Profile2_2 | ProfileYear2_2 | ProfileValue2_2 | Profile2_3 | ProfileYear2_3 | ProfileValue2_3 | Profile2_4 | ProfileYear2_4 | ProfileValue2_4 | ProcessDate2 | ReleaseDate2 | ContractStartDate | ContractEndDate                                            |  FSP_ASCL         | FSP_FCFJ          |  PaymentPeriod | FinancialPeriod | CensusEndDate |
    | 10010062| 10010062 Co Ltd     | 110062| ORG0010062 | AA010062      | 9 Kneesworth Street | Royston| SG8 5AA  | 01/07/2026          | AEB2023-AY-2627-Contract-Provider-10010062-3_5                   | 3_5             | AEB2023-AY-2627-10010062-3_5           | 3_5                    | Limited Liability Partnership           | Direct Funded Organisation              | 8180.00 | 1000.00 | 3680.00 | 6320.00 | 2500.00 | September  | 2026           | 1000.00         | April      | 2027           | 3680.00         | November   | 2026           | 6320.00         | August     | 2026           | 2500.00         | 03/07/2026   | 05/07/2026   | 07/07/2026  | 09/07/2026 | Cfs              | 01/09/2026        | AEB2023-AY-2627-Contract-Provider-10010062-4_7                    | 4_7             | AEB2023-AY-2627-10010062-4_7           | 4_7                    | PRI/LTD BY GUAR/NSC                   | Private Sector                          | 16882.00 | 3172.00 | 4892.00 | 5859.00 | 2959.00 | September  | 2026           | 3172.00         | April      | 2027           | 4892.00         | November   | 2026           | 5859.00         | December   | 2026           | 2959.00         | 05/07/2026   | 19/07/2026   | 01/08/2026        | 31/07/2027  | ASF2023-AS2627    | ASF2023-FCFJ2627  |  202609        | 202606          | 08/10/2026   |