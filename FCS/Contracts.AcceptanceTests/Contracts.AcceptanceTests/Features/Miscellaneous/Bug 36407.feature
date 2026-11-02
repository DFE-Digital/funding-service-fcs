Feature: Bug 36407

@AcceptanceTest @Withdrawn_14052024
@CFS
Scenario: A864 Import and release 21/22 FAs for a Local Authority and 3 DelOrg with all duff ProviderTypes and ProviderSubTypes. Check P&D report

    # 1. Import and release FA for the Local Authority and 3 Del Orgs > draft contract v1
    # 2. Fail to process. Park\AwaitingContractTypeConfig
    # 3. Check Parked and Discarded report

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017864'
    And   there is no Funding Allocation data in CRM for UKPRN '10017864'
    And   there is no Contract, Task or Workflow data for UKPRN '10017864'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017864' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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



    # Organisation and Advisors (Local Authority)
    Given there is no Organisation data in CRM for UKPRN '10017864' 
    And   there is no caseload advisor for UKPRN '10017864' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017864 | 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017864 Co Ltd' with UKPRN '10017864' and OrgId 'ORG0017864' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017864 | 117864 | Gawlish County Council | 0              | Active                | Yes           | AA017864      | ?             | 16 Chaucer Grove       | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017864 |





    # Organisation and Advisors (DeliveryOrg 1)
    Given there is no Organisation data in CRM for UKPRN '10000350' 
    And   there is no caseload advisor for UKPRN '10000350' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000350 | 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000350 | 100350 | Arden College          | 0              | Active                | Yes           | AA000350      | ?             | 22 Albert Ave          | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000350 |





    # Organisation and Advisors (DeliveryOrg 2)
    Given there is no Organisation data in CRM for UKPRN '10000670' 
    And   there is no caseload advisor for UKPRN '10000670' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000670 | 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000670 | 100670 | Bexhill College        | 0              | Active                | Yes           | AA000670      | ?             | 9 Platters Road        | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000670 |





    # Organisation and Advisors (DeliveryOrg 3)
    Given there is no Organisation data in CRM for UKPRN '10000812' 
    And   there is no caseload advisor for UKPRN '10000812' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000812 | 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000812 | 100812 | Boston College         | 0              | Active                | Yes           | AA000812      | ?             | 101 Bayleaf Road       | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000812 |





    # Part 1: Import and release FA for the Local Authority and 3 Del Orgs > draft contract v1

    # Populate the stub with 1619 (10LAU) data (Local Authority 10017864)

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017864 | 1619-AS-2122-Contract-LocalAuthority-10017864-1_0     | 1_0            | 1619                        | AS-2122            | 5373.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType    | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017864-1_0  | 1_0                    | 1619-AS-2122-Contract-LocalAuthority-10017864-1_0     | 10017864      | Military        | Royal Marines   | 5373.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017864-1_0  | 1619-001        | 5373.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017864-1_0  | 1619-001        | FY-2122              | September              | 2021              | 5373.00                   |






    # Populate the stub with 1619 (08SSF) data (Delivery Orgs 10000350, 10000670 and 10000812)

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017864 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017864-1_2  | 1_2            | 1619                        | AS-2122            | 14765.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10000350-1_2  | 1_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017864-1_2  | 10000350      | Military     | Royal Marines   | 4246.00                   |
    | 1619-AS-2122-10000670-1_2  | 1_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017864-1_2  | 10000670      | Military     | Royal Marines   | 5050.00                   |
    | 1619-AS-2122-10000812-1_2  | 1_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017864-1_2  | 10000812      | Military     | Royal Marines   | 5469.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10000350-1_2  | 1619-004        | 4246.00          | Payment         |
    | 1619-AS-2122-10000670-1_2  | 1619-006        | 5050.00          | Payment         |
    | 1619-AS-2122-10000812-1_2  | 1619-024        | 5469.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10000350-1_2  | 1619-004        | FY-2122              | February               | 2022              | 4246.00                   |
    | 1619-AS-2122-10000670-1_2  | 1619-006        | FY-2122              | March                  | 2022              | 5050.00                   |
    | 1619-AS-2122-10000812-1_2  | 1619-024        | FY-2122              | December               | 2021              | 5469.00                   |





    # Part 2: Fail to process. Park\AwaitingContractTypeConfig
    
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017864 | 1619-AS-2122-Contract-LocalAuthority-10017864-1_0       | 1_0            | AS-2122 | 1619                        | 5373.00     | ?               | Parked            | AwaitingContractTypeConfig        |
    | 10017864 | 1619-AS-2122-Contract-LocalAuthoritySsf-10017864-1_2    | 1_2            | AS-2122 | 1619                        | 14765.00    | ?               | Parked            | AwaitingContractTypeConfig        |





    # Part 3: Check Parked and Discarded report

    # Change the date 
    Given the override date is '04/07/2021'

    # Delete then recreate the Parked and Discarded spreadsheet (J155)
    When the Parked and Discarded spreadsheet is recreated

    # Check the named tab of the Parked and Discarded spreadsheet in the 'Funding Allocation Extracts' folder for particular row(s) (J155)
    Then  the Parked and Discarded spreadsheet includes the following
    | TabName   | CFSFundingId                                         | CFSValue    | FCSStatus | FCSSubStatus                     | CFSProviderType    | CFSProviderSubType   |
    | Parked    | 1619-AS-2122-Contract-LocalAuthority-10017864-1_0    | 5373.00     | Parked    | AwaitingContractTypeConfig       | Military           | Royal Marines        |
    | Parked    | 1619-AS-2122-Contract-LocalAuthoritySsf-10017864-1_2 | 14765.00    | Parked    | AwaitingContractTypeConfig       | Military           | Royal Marines        |

    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn_21052026
@CFS
Scenario: A865 Import and release 22/23 FAs for a Local Authority and 3 DelOrg with all duff ProviderTypes and ProviderSubTypes. Check P&D Report

    # 1. Import and release FA for the Local Authority and 3 Del Orgs > draft contract v1
    # 2. Fail to process. Park\AwaitingFundingAllocationConfig
    # 3. Check Parked and Discarded report

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017865'
    And   there is no Funding Allocation data in CRM for UKPRN '10017865'
    And   there is no Contract, Task or Workflow data for UKPRN '10017865'

    # Cleardown Sharepoint appendix docs
 #  And   there are no files prefixed '10017865' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (LA)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors (Local Authority)
    Given there is no Organisation data in CRM for UKPRN '10017865' 
    And   there is no caseload advisor for UKPRN '10017865' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017865 | 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017865 Co Ltd' with UKPRN '10017865' and OrgId 'ORG0017865' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017865 | 117865 | Gawlish County Council | 0              | Active                | Yes           | AA017865      | ?             | 16 Chaucer Grove       | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017865 |





    # Organisation and Advisors (DeliveryOrg 1)
    Given there is no Organisation data in CRM for UKPRN '10000350' 
    And   there is no caseload advisor for UKPRN '10000350' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000350 | 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000350 | 100350 | Arden College          | 0              | Active                | Yes           | AA000350      | ?             | 22 Albert Ave          | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000350 |





    # Organisation and Advisors (DeliveryOrg 2)
    Given there is no Organisation data in CRM for UKPRN '10000670' 
    And   there is no caseload advisor for UKPRN '10000670' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000670 | 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000670 | 100670 | Bexhill College        | 0              | Active                | Yes           | AA000670      | ?             | 9 Platters Road        | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000670 |





    # Organisation and Advisors (DeliveryOrg 3)
    Given there is no Organisation data in CRM for UKPRN '10000812' 
    And   there is no caseload advisor for UKPRN '10000812' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000812 | 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000812 | 100812 | Boston College         | 0              | Active                | Yes           | AA000812      | ?             | 101 Bayleaf Road       | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000812 |





    # Part 1: Import and release FA for the Local Authority and 3 Del Orgs > draft contract v1

    # Populate the stub with 1619 (10LAU) data (Local Authority 10017865)

    # Change the date 
    Given the override date is '01/07/2022'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017865 | 1619-AS-2223-Contract-LocalAuthority-10017865-1_0     | 1_0            | 1619                        | AS-2223            | 5373.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType            | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2223-10017865-1_0  | 1_0                    | 1619-AS-2223-Contract-LocalAuthority-10017865-1_0     | 10017865      | Farming and Agriculture | Pigs and Sows   | 5373.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2223-10017865-1_0  | 1619-001        | 5373.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2223-10017865-1_0  | 1619-001        | FY-2223              | September              | 2022              | 5373.00                   |






    # Populate the stub with 1619 (08SSF) data (Delivery Orgs 10000350, 10000670 and 10000812)

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017865 | 1619-AS-2223-Contract-LocalAuthoritySsf-10017865-1_2  | 1_2            | 1619                        | AS-2223            | 14765.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType            | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2223-10000350-1_2  | 1_2                    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017865-1_2  | 10000350      | Farming & Husbandry     | Dairy           | 4246.00                   |
    | 1619-AS-2223-10000670-1_2  | 1_2                    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017865-1_2  | 10000670      | Husbandry               | Pigs and Sows   | 5050.00                   |
    | 1619-AS-2223-10000812-1_2  | 1_2                    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017865-1_2  | 10000812      | Agriculture             | Wheat & Barley  | 5469.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2223-10000350-1_2  | 1619-004        | 4246.00          | Payment         |
    | 1619-AS-2223-10000670-1_2  | 1619-006        | 5050.00          | Payment         |
    | 1619-AS-2223-10000812-1_2  | 1619-024        | 5469.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2223-10000350-1_2  | 1619-004        | FY-2223              | February               | 2023              | 4246.00                   |
    | 1619-AS-2223-10000670-1_2  | 1619-006        | FY-2223              | March                  | 2023              | 5050.00                   |
    | 1619-AS-2223-10000812-1_2  | 1619-024        | FY-2223              | December               | 2022              | 5469.00                   |





    # Part 2: Fail to process. Park\AwaitingFundingAllocationConfig
    
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

 #   # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
 #   Then  the following Funding Allocations data is present in PaaS
 #   | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
 #   | 10017865 | 1619-AS-2223-Contract-LocalAuthoritySsf-10017865-1_2    | 1_2            | AS-2223 | 1619                        | 14765.00    | ?               | Parked            | AwaitingFundingAllocationConfig   |
 #   | 10017865 | 1619-AS-2223-Contract-LocalAuthority-10017865-1_0       | 1_0            | AS-2223 | 1619                        | 5373.00     | ?               | Parked            | AwaitingFundingAllocationConfig   |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017865 | 1619-AS-2223-Contract-LocalAuthoritySsf-10017865-1_2    | 1_2            | AS-2223 | 1619                        | 14765.00    | ?               | Parked            | AwaitingContractTypeConfig        |
    | 10017865 | 1619-AS-2223-Contract-LocalAuthority-10017865-1_0       | 1_0            | AS-2223 | 1619                        | 5373.00     | ?               | Parked            | AwaitingContractTypeConfig        |




    # Part 3: Check Parked and Discarded report

    # Change the date 
    Given the override date is '04/07/2022'

    # Delete then recreate the Parked and Discarded spreadsheet (J155)
    When the Parked and Discarded spreadsheet is recreated

 #  # Check the named tab of the Parked and Discarded spreadsheet in the 'Funding Allocation Extracts' folder for particular row(s) (J155)
 #  Then  the Parked and Discarded spreadsheet includes the following
 #  | TabName   | CFSFundingId                                         | CFSValue    | FCSStatus | FCSSubStatus                     | CFSProviderType          | CFSProviderSubType   |
 #  | Parked    | 1619-AS-2223-Contract-LocalAuthority-10017865-1_0    | 5373.00     | Parked    | AwaitingFundingAllocationConfig  | Farming and Agriculture  | Pigs and Sows        | = 1st
 #  | Parked    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017865-1_2 | 14765.00    | Parked    | AwaitingFundingAllocationConfig  | Farming & Husbandry      | Dairy                | = 1st

 #   # Check the named tab of the Parked and Discarded spreadsheet in the 'Funding Allocation Extracts' folder for particular row(s) (J155)
 #   Then  the Parked and Discarded spreadsheet includes these entries
 #   | TabName   | CFSFundingId                                         | CFSValue    | FCSStatus | FCSSubStatus                     | 
 #   | Parked    | 1619-AS-2223-Contract-LocalAuthority-10017865-1_0    | 5373.00     | Parked    | AwaitingFundingAllocationConfig  |
 #   | Parked    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017865-1_2 | 14765.00    | Parked    | AwaitingFundingAllocationConfig  | 

    # Check the named tab of the Parked and Discarded spreadsheet in the 'Funding Allocation Extracts' folder for particular row(s) (J155)
    Then  the Parked and Discarded spreadsheet includes these entries
    | TabName   | CFSFundingId                                         | CFSValue    | FCSStatus | FCSSubStatus                     | 
    | Parked    | 1619-AS-2223-Contract-LocalAuthority-10017865-1_0    | 5373.00     | Parked    | AwaitingContractTypeConfig       |
    | Parked    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017865-1_2 | 14765.00    | Parked    | AwaitingContractTypeConfig       | 

    # Tidy Up
    Given the override date is reset

   