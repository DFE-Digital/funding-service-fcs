Feature: Alan1

@AcceptanceTest @Incomplete
Scenario: L001 Import and release a 1619ED CFS Funding Allocation for 1619-001. Check CFS code mapping (Manual)
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014001'
    And   there is no Funding Allocation data in CRM for UKPRN '10014001'
    And   there is no Contract, Task or Workflow data for UKPRN '10014001' 

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10014001' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014001 Co Ltd' with UKPRN '10014001' and OrgId 'ORG0014001' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status    | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014001 | 114001 | 10014001 Co Ltd | 0              | Active    | Yes           | AA014001      | ?             | 47 Stainlake Avenue    | Moortown               | Leeds                  | ?                      | ?                      | ?                      | LS14 6PG  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014001 |





    # Change the date 
    Given the override date is '16/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                   | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014001 | 1619-AS-2021-Contract-Provider-10014001-5_1 | 5_1            | 1619                        | AS-2021            | 15000.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId         | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue | 
    | 1619-AS-2021-10014001-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10014001-5_1 | 10014001      | Furth        | 01GFE           | 15000.00                  | 

    # Funding Allocation Line
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014001-5_1  | 1619-001        | 15000.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014001-5_1  | 1619-001        | FY-2122              | June                   | 2021              | 15000.00                  |





    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10014001 | 10014001 Co Ltd  | 1619-AS-2021-Contract-Provider-10014001-5_1       | 5_1            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                    | 16-19ED2021     | Scheduling        | Awaiting Release  | 15000.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check PaaS FundingAllocation.FundingAllocation and .Contract
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | FundingTypeCode            | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Value       | 
    | 10014001 | 1619-AS-2021-Contract-Provider-10014001-5_1       | 5_1            | EDSK                       | AS-2021 | Conditions of Funding (Grant) (College)  | 1619                    | 16-19ED2021     | 15000.00    |





    # Release the Funding Allocation (32333)

    # Change the date
    Given the override date is '22/06/2021'

    # Release from Contract Control\Scheduling
    When  a request is triggered to release the following Funding Allocations from Contract Control
    | FundingId                                         |
    | 1619-AS-2021-Contract-Provider-10014001-5_1       |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10014001' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period   | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10014001 | 10014001 Co Ltd  | 1619-AS-2021-Contract-Provider-10014001-5_1       | 5_1            | Education & Skills Funding | AY2021   | Conditions of Funding (Grant) (College)  | 1619                    | 16-19ED2021     | Released          | Released          | 15000.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | FundingTypeCode            | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Value       |
    | 10014001 | 1619-AS-2021-Contract-Provider-10014001-5_1       | 5_1            | EDSK                       | AS-2021 | Conditions of Funding (Grant) (College)  | 1619                    | 16-19ED2021     | 15000.00    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2021-Contract-Provider-10014001-5_1       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014001 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10014001 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
    | 10014001 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 15000.00      | Conditions of Funding (Grant) (College)   | 2021   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10014001 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2020          | 31/07/2021        | 15000.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName            | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 15000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 15000.00 | 0.00     | 16-19 Programme Funding    |                          |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Incomplete
Scenario: L002 Import and release a 1619ED CFS Funding Allocation for PSG-001. Check CFS code mapping (Manual)
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014002'
    And   there is no Funding Allocation data in CRM for UKPRN '10014002'
    And   there is no Contract, Task or Workflow data for UKPRN '10014002'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014002' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014002 Co Ltd' with UKPRN '10014002' and OrgId 'ORG0014002' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10014002' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014002 | 114002 | 10014002 Co Ltd | 0              | Locked Restructure    | Yes           | AA014002      | ?             | 15 Albert Road         | Middlesbrough          | North Yorkshire        | ?                      | ?                      | ?                      | TS1 1PQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014002 |




    # Change the date 
    Given the override date is '14/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014002 | PSG-AY-2021-Contract-Provider-10014002-4_2        | 4_2            | PSG                         | AY-2021            | 12499.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | PSG-AY-2021-10014002-4_2   | 4_2                    | PSG-AY-2021-Contract-Provider-10014002-4_2  | 10014002      | Furth        | 04AHC           | 12499.00                  |

    # Funding Allocation Line
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PSG-AY-2021-10014002-4_2   | PSG-001         | 12499.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PSG-AY-2021-10014002-4_2   | PSG-001         | FY-2021              | May                    | 2021              | 3194.00                   |
    | PSG-AY-2021-10014002-4_2   | PSG-001         | FY-2021              | January                | 2021              | 4519.00                   |
    | PSG-AY-2021-10014002-4_2   | PSG-001         | FY-2021              | September              | 2020              | 4786.00                   |

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10014002 | 10014002 Co Ltd  | PSG-AY-2021-Contract-Provider-10014002-4_2        | 4_2            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | PSG                     | 16-19ED2021     | Scheduling        | Awaiting Release  | 12499.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | PSG-AY-2021-Contract-Provider-10014002-4_2        | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | FundingTypeCode            | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Value       | 
    | 10014002 | PSG-AY-2021-Contract-Provider-10014002-4_2        | 4_2            | EDSK                       | AY-2021 | Conditions of Funding (Grant) (College)  | PSG                     | 16-19ED2021     | 12499.00    |


    # Check other PaaS tables - when we know what they are 
    # Where are status, substatus, contract and contractno now that they have gone from PaaS FA table ?




    # Release a Funding Allocation (32333)

    # Change the date
    Given the override date is '22/06/2021'

    # Release from Contract Control\Scheduling
    When  a request is triggered to release the following Funding Allocations from Contract Control
    | FundingId                                         |
    | PSG-AY-2021-Contract-Provider-10014002-4_2        |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10014002' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10014002 | 10014002 Co Ltd  | PSG-AY-2021-Contract-Provider-10014002-4_2        | 4_2            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | PSG                     | 16-19ED2021     | Released          | Released          | 12499.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | FundingTypeCode            | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Value       |
    | 10014002 | PSG-AY-2021-Contract-Provider-10014002-4_2        | 4_2            | EDSK                       | AY-2021 | Conditions of Funding (Grant) (College)  | PSG                     | 16-19ED2021     | 12499.00    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PSG-AY-2021-Contract-Provider-10014002-4_2        | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014002 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10014002 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
    | 10014002 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 12499.00      | Conditions of Funding (Grant) (College)   | 2021   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10014002 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2020          | 31/07/2021        | 12499.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName              | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 12499.00  | 0.00     | 4786.00  | 0.00     | 0.00     | 0.00     | 4519.00  | 0.00     | 0.00     | 0.00     | 3194.00  | 0.00     | 0.00     | Primary PE and Sport Premium |                          |

    # Contract status is now at 'Awaiting Documentation'

@AcceptanceTest @Incomplete
Scenario: L003 Import and release a 1619ED CFS Funding Allocation for NMSS-003. Check CFS code mapping (Manual)
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014003'
    And   there is no Funding Allocation data in CRM for UKPRN '10014003'
    And   there is no Contract, Task or Workflow data for UKPRN '10014003'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014003' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014003 Co Ltd' with UKPRN '10014003' and OrgId 'ORG0014003' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10014003' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014003 | 114003 | 10014003 Co Ltd | 0              | Active                | Yes           | AA014003      | ?             | 2 Buckingham Court     | Rectory Lane           | ?                      | ?                      | Loughton               | Essex                  | IG10 2QZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014003 |




    # Change the date 
    Given the override date is '14/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014003 | NMSS-AY-2021-Contract-Provider-10014003-1_6       | 1_6            | NMSS                        | AY-2021            | 6821.00           |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2021-10014003-1_6  | 1_6                    | NMSS-AY-2021-Contract-Provider-10014003-1_6 | 10014003      | Furth        | 01GFE           | 6821.00                   |

    # Funding Allocation Line
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2021-10014003-1_6  | NMSS-003        | 6821.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2021-10014003-1_6  | NMSS-003        | FY-2021              | February               | 2021              | 2406.00                   |
    | NMSS-AY-2021-10014003-1_6  | NMSS-003        | FY-2021              | December               | 2020              | 4415.00                   |

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10014003 | 10014003 Co Ltd  | NMSS-AY-2021-Contract-Provider-10014003-1_6       | 1_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | NMSS                    | 16-19ED2021     | Scheduling        | Awaiting Release  | 6821.00     | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | NMSS-AY-2021-Contract-Provider-10014003-1_6       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | FundingTypeCode            | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Value       | 
    | 10014003 | NMSS-AY-2021-Contract-Provider-10014003-1_6       | 1_6            | EDSK                       | AY-2021 | Conditions of Funding (Grant) (College)  | NMSS                    | 16-19ED2021     | 6821.00     |


    # Check other PaaS tables - when we know what they are 
    # Where are status, substatus, contract and contractno now that they have gone from PaaS FA table ?




    # Release a Funding Allocation (32333)

    # Change the date
    Given the override date is '22/06/2021'

    # Release from Contract Control\Scheduling
    When  a request is triggered to release the following Funding Allocations from Contract Control
    | FundingId                                         |
    | NMSS-AY-2021-Contract-Provider-10014003-1_6       |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10014003' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10014003 | 10014003 Co Ltd  | NMSS-AY-2021-Contract-Provider-10014003-1_6       | 1_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | NMSS                    | 16-19ED2021     | Released          | Released          | 6821.00     | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | FundingTypeCode            | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Value       |
    | 10014003 | NMSS-AY-2021-Contract-Provider-10014003-1_6       | 1_6            | EDSK                       | AY-2021 | Conditions of Funding (Grant) (College)  | NMSS                    | 16-19ED2021     | 6821.00     |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2021-Contract-Provider-10014003-1_6       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014003 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10014003 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
    | 10014003 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 6821.00       | Conditions of Funding (Grant) (College)   | 2021   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10014003 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2020          | 31/07/2021        | 6821.00         |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName            | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 6821.00   | 0.00     | 0.00     | 0.00     | 0.00     | 4415.00  | 0.00     | 2406.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Bursary Funds          |                          |

@AcceptanceTest @Incomplete
Scenario: L004 Import and release a 1619ED CFS Funding Allocation for 1619-021. Check CFS code mapping (Manual)
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014004'
    And   there is no Funding Allocation data in CRM for UKPRN '10014004'
    And   there is no Contract, Task or Workflow data for UKPRN '10014004'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014004' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014004 Co Ltd' with UKPRN '10014004' and OrgId 'ORG0014004' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10014004' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014004 | 114004 | 10014004 Co Ltd | 0              | Provider Under Change | Yes           | AA014004      | ?             | 14 Exchange Street     | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4AU   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014004 |




    # Change the date 
    Given the override date is '14/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014004 | 1619-AS-2021-Contract-Provider-10014004-1_6       | 1_6            | 1619                        | AS-2021            | 3674.00           |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014004-1_6  | 1_6                    | 1619-AS-2021-Contract-Provider-10014004-1_6 | 10014004      | Furth        | 06SDC           | 3674.00                   |

    # Funding Allocation Line
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014004-1_6  | 1619-021        | 3674.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014004-1_6  | 1619-021        | FY-2021              | September              | 2020              | 3674.00                   |

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10014004 | 10014004 Co Ltd  | 1619-AS-2021-Contract-Provider-10014004-1_6       | 1_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                    | 16-19ED2021     | Scheduling        | Awaiting Release  | 3674.00     | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2021-Contract-Provider-10014004-1_6       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | FundingTypeCode            | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Value       | 
    | 10014004 | 1619-AS-2021-Contract-Provider-10014004-1_6       | 1_6            | EDSK                       | AS-2021 | Conditions of Funding (Grant) (College)  | 1619                    | 16-19ED2021     | 3674.00     |


    # Check other PaaS tables - when we know what they are 
    # Where are status, substatus, contract and contractno now that they have gone from PaaS FA table ?




    # Release a Funding Allocation (32333)

    # Change the date
    Given the override date is '22/06/2021'

    # Release from Contract Control\Scheduling
    When  a request is triggered to release the following Funding Allocations from Contract Control
    | FundingId                                         |
    | 1619-AS-2021-Contract-Provider-10014004-1_6       |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10014004' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10014004 | 10014004 Co Ltd  | 1619-AS-2021-Contract-Provider-10014004-1_6       | 1_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                    | 16-19ED2021     | Released          | Released          | 3674.00     | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | FundingTypeCode            | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Value       |
    | 10014004 | 1619-AS-2021-Contract-Provider-10014004-1_6       | 1_6            | EDSK                       | AS-2021 | Conditions of Funding (Grant) (College)  | 1619                    | 16-19ED2021     | 3674.00     |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2021-Contract-Provider-10014004-1_6       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014004 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10014004 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
    | 10014004 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 3674.00       | Conditions of Funding (Grant) (College)   | 2021   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10014004 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2020          | 31/07/2021        | 3674.00         |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                           | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 3674.00   | 0.00     | 3674.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Creative Sector |                          |


    
@AcceptanceTest @Withdrawn20260521 @CFS
Scenario: L005 Import 1619 FAs (1619) and confirm initial RG is updated with subsequent import of 1619 FAs of the same type
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014005'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014995'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014885'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10015005'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10015995'
    And   there is no Funding Allocation data in CRM for UKPRN '10014005'
    And   there is no Funding Allocation data in CRM for UKPRN '10014995'
    And   there is no Funding Allocation data in CRM for UKPRN '10014885'
    And   there is no Funding Allocation data in CRM for UKPRN '10015005'
    And   there is no Funding Allocation data in CRM for UKPRN '10015995'
    And   there is no Contract, Task or Workflow data for UKPRN '10014005'
    And   there is no Contract, Task or Workflow data for UKPRN '10014995'
    And   there is no Contract, Task or Workflow data for UKPRN '10014885'
    And   there is no Contract, Task or Workflow data for UKPRN '10015005'
    And   there is no Contract, Task or Workflow data for UKPRN '10015995'
    
    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014005' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed '10014995' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed '10014885' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed '10015005' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed '10015995' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014005' 
    And there is no Organisation data for UKPRN '10014995'  
    And there is no Organisation data for UKPRN '10014885'  
    And there is no Organisation data for UKPRN '10015005'  
    And there is no Organisation data for UKPRN '10015995' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014005 Co Ltd' with UKPRN '10014005' and OrgId 'ORG0014005' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014995 Co Ltd' with UKPRN '10014995' and OrgId 'ORG0014995' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014885 Co Ltd' with UKPRN '10014885' and OrgId 'ORG0014885' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10015005 Co Ltd' with UKPRN '10015005' and OrgId 'ORG0015005' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10015995 Co Ltd' with UKPRN '10015995' and OrgId 'ORG0015995' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014005 | 114005 | 10014005 Co Ltd | 0              | Locked Restructure    | Yes           | AA014005      | ?             | 100 Harley Street      | London                 | ?                      | ?                      | ?                      | ?                      | W1N 1AF   |
    | 10014995 | 114995 | 10014995 Co Ltd | 0              | Locked Restructure    | Yes           | AA014995      | ?             | 10 High Street         | Grantham               | ?                      | ?                      | ?                      | Lincs                  | NG31 0FF  |
    | 10014885 | 114885 | 10014885 Co Ltd | 0              | Locked Restructure    | Yes           | AA014885      | ?             | Quinton Road           | Cheylesmore            | ?                      | ?                      | Coventry               | ?                      | CV1 2WT   |
    | 10015005 | 115005 | 10015005 Co Ltd | 0              | Locked Restructure    | Yes           | AA015005      | ?             | Flat 3a                | Broughton Court        | Bitteswell Road        | Leicestershire         | ?                      | ?                      | LE17 4SH  |
    | 10015995 | 115995 | 10015995 Co Ltd | 0              | Locked Restructure    | Yes           | AA015995      | ?             | 512 Brook Street       | ?                      | ?                      | ?                      | Welshpool              | Powys                  | NG31 0FF  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014005 |
    | 10014995 |
    | 10014885 |
    | 10015005 |
    | 10015995 |



    # Populate the stub (Set 1)

    # Change the date 
    Given the override date is '14/06/2122'

    # Funding Allocation (Set 1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014005 | 1619-AS-2122-Contract-Provider-10014005-4_6       | 4_6            | 1619                        | AS-2122            | 39697.00          |
    | Contracting    | 10014995 | 1619-AS-2122-Contract-Provider-10014995-2_0       | 2_0            | 1619                        | AS-2122            | 20515.00          |
    | Contracting    | 10014885 | 1619-AS-2122-Contract-Provider-10014885-4_2       | 4_2            | 1619                        | AS-2122            | 14243.00          |

    # Provider Funding Allocation (Set 1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10014005-4_6  | 4_6                    | 1619-AS-2122-Contract-Provider-10014005-4_6 | 10014005      | Furth        | 01GFE           | 39697.00                  |
    | 1619-AS-2122-10014995-2_0  | 2_0                    | 1619-AS-2122-Contract-Provider-10014995-2_0 | 10014995      | Furth        | 04AHC           | 20515.00                  |
    | 1619-AS-2122-10014885-4_2  | 4_2                    | 1619-AS-2122-Contract-Provider-10014885-4_2 | 10014885      | Furth        | 06SDC           | 14243.00                  |

    # Funding Allocation Line (aka Deliverable) (Set 1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10014005-4_6  | 1619-001        | 5735.00          | Payment         |
    | 1619-AS-2122-10014005-4_6  | 1619-002        | 8508.00          | Payment         |
    | 1619-AS-2122-10014005-4_6  | 1619-003        | 6272.00          | Payment         |
    | 1619-AS-2122-10014005-4_6  | 1619-004        | 19182.00         | Payment         |
    | 1619-AS-2122-10014995-2_0  | 1619-005        | 5735.00          | Payment         |
    | 1619-AS-2122-10014995-2_0  | 1619-006        | 8508.00          | Payment         |
    | 1619-AS-2122-10014995-2_0  | 1619-007        | 6272.00          | Payment         |
    | 1619-AS-2122-10014885-4_2  | 1619-008        | 5735.00          | Payment         |
    | 1619-AS-2122-10014885-4_2  | 1619-009        | 8508.00          | Payment         |

    # Funding Allocation Profile Period (Set 1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10014005-4_6  | 1619-001        | FY-2122              | October                | 2021              | 5735.00                   |
    | 1619-AS-2122-10014005-4_6  | 1619-002        | FY-2122              | April                  | 2022              | 5763.00                   |
    | 1619-AS-2122-10014005-4_6  | 1619-002        | FY-2122              | January                | 2022              | 2745.00                   |
    | 1619-AS-2122-10014005-4_6  | 1619-003        | FY-2122              | July                   | 2022              | 2423.00                   |
    | 1619-AS-2122-10014005-4_6  | 1619-003        | FY-2122              | October                | 2021              | 3849.00                   |
    | 1619-AS-2122-10014005-4_6  | 1619-004        | FY-2122              | June                   | 2022              | 4271.00                   |
    | 1619-AS-2122-10014005-4_6  | 1619-004        | FY-2122              | April                  | 2022              | 4501.00                   |
    | 1619-AS-2122-10014005-4_6  | 1619-004        | FY-2122              | February               | 2022              | 3091.00                   |
    | 1619-AS-2122-10014005-4_6  | 1619-004        | FY-2122              | December               | 2021              | 3561.00                   |
    | 1619-AS-2122-10014005-4_6  | 1619-004        | FY-2122              | October                | 2021              | 3758.00                   |
    | 1619-AS-2122-10014995-2_0  | 1619-005        | FY-2122              | September              | 2021              | 5735.00                   |
    | 1619-AS-2122-10014995-2_0  | 1619-006        | FY-2122              | March                  | 2022              | 5763.00                   |
    | 1619-AS-2122-10014995-2_0  | 1619-006        | FY-2122              | February               | 2022              | 2745.00                   |
    | 1619-AS-2122-10014995-2_0  | 1619-007        | FY-2122              | May                    | 2022              | 2423.00                   |
    | 1619-AS-2122-10014995-2_0  | 1619-007        | FY-2122              | October                | 2021              | 3849.00                   |
    | 1619-AS-2122-10014885-4_2  | 1619-008        | FY-2122              | September              | 2021              | 5735.00                   |
    | 1619-AS-2122-10014885-4_2  | 1619-009        | FY-2122              | March                  | 2022              | 5763.00                   |
    | 1619-AS-2122-10014885-4_2  | 1619-009        | FY-2122              | February               | 2022              | 2745.00                   |



    # Change the date 
    Given the override date is '17/06/2122'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10014005 | 10014005 Co Ltd  | 1619-AS-2122-Contract-Provider-10014005-4_6       | 4_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 39697.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10014995 | 10014995 Co Ltd  | 1619-AS-2122-Contract-Provider-10014995-2_0       | 2_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 20515.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10014885 | 10014885 Co Ltd  | 1619-AS-2122-Contract-Provider-10014885-4_2       | 4_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 14243.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2122-Contract-Provider-10014005-4_6       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | 1619-AS-2122-Contract-Provider-10014995-2_0       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | 1619-AS-2122-Contract-Provider-10014885-4_2       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | 
    | 10014005 | 1619-AS-2122-Contract-Provider-10014005-4_6       | 4_6            | AS-2122 | 1619                        | 39697.00    | 
    | 10014995 | 1619-AS-2122-Contract-Provider-10014995-2_0       | 2_0            | AS-2122 | 1619                        | 20515.00    | 
    | 10014885 | 1619-AS-2122-Contract-Provider-10014885-4_2       | 4_2            | AS-2122 | 1619                        | 14243.00    |


    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |
    
    
    # Check the state of a Release Group (J129)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 74455.00        |


    # Clear down the CFS stub
    Given   there is no data in the CFS stub

    # Populate the stub (Set 2)

    # Change the date 
    And the override date is '20/06/2122'

    # Funding Allocation (Set 2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10015005 | 1619-AS-2122-Contract-Provider-10015005-4_4       | 4_4            | 1619                        | AS-2122            | 20515.00          |
    | Contracting    | 10015995 | 1619-AS-2122-Contract-Provider-10015995-2_0       | 2_0            | 1619                        | AS-2122            | 14243.00          |

    # Provider Funding Allocation (Set 2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10015005-4_4  | 4_4                    | 1619-AS-2122-Contract-Provider-10015005-4_4 | 10015005      | Furth        | 03SFC           | 20515.00                  |
    | 1619-AS-2122-10015995-2_0  | 2_0                    | 1619-AS-2122-Contract-Provider-10015995-2_0 | 10015995      | Furth        | 05ADC           | 14243.00                  |

    # Funding Allocation Line (aka Deliverable) (Set 2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10015005-4_4  | 1619-003        | 5735.00          | Payment         |
    | 1619-AS-2122-10015005-4_4  | 1619-004        | 8508.00          | Payment         |
    | 1619-AS-2122-10015005-4_4  | 1619-005        | 6272.00          | Payment         |
    | 1619-AS-2122-10015995-2_0  | 1619-010        | 5735.00          | Payment         |
    | 1619-AS-2122-10015995-2_0  | 1619-011        | 8508.00          | Payment         |

    # Funding Allocation Profile Period (Set 2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10015005-4_4  | 1619-003        | FY-2122              | October                | 2021              | 5735.00                   |
    | 1619-AS-2122-10015005-4_4  | 1619-004        | FY-2122              | April                  | 2022              | 5763.00                   |
    | 1619-AS-2122-10015005-4_4  | 1619-004        | FY-2122              | January                | 2022              | 2745.00                   |
    | 1619-AS-2122-10015005-4_4  | 1619-005        | FY-2122              | July                   | 2022              | 2423.00                   |
    | 1619-AS-2122-10015005-4_4  | 1619-005        | FY-2122              | October                | 2021              | 3849.00                   |
    | 1619-AS-2122-10015995-2_0  | 1619-010        | FY-2122              | November               | 2021              | 5735.00                   |
    | 1619-AS-2122-10015995-2_0  | 1619-011        | FY-2122              | June                   | 2022              | 5763.00                   |
    | 1619-AS-2122-10015995-2_0  | 1619-011        | FY-2122              | August                 | 2021              | 2745.00                   |



    # Change the date 
    Given the override date is '23/06/2122'

    # Read stub and process into CRM

    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10015005 | 10015005 Co Ltd  | 1619-AS-2122-Contract-Provider-10015005-4_4       | 4_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 20515.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10015995 | 10015995 Co Ltd  | 1619-AS-2122-Contract-Provider-10015995-2_0       | 2_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 14243.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2122-Contract-Provider-10015005-4_4       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | 1619-AS-2122-Contract-Provider-10015995-2_0       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | 
    | 10015005 | 1619-AS-2122-Contract-Provider-10015005-4_4       | 4_4            | AS-2122 | 1619                        | 20515.00    | 
    | 10015995 | 1619-AS-2122-Contract-Provider-10015995-2_0       | 2_0            | AS-2122 | 1619                        | 14243.00    |

    # Check the state of a Release Group (J129)
    And  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 5               | 109213.00       |


    # Tidy Up
    And   the override date is reset


    


@AcceptanceTest @Manual
Scenario: L012 Import four CFS FA's (mix of 1619 & NFF) for a Local Authority (with Funding) to create an EDSK2021 contract with 2 Delivery Orgs (32824-6)
#  Contracting Org 10014012 - 1619, NFF 
#     Delivery Org 1 10014912 - 1619, NFF    
#     Delivery Org 2 10014812 - 1619, NFF
#   
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014012'
    And   there is no Funding Allocation data in CRM for UKPRN '10014012'
    And   there is no Contract, Task or Workflow data for UKPRN '10014012'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014012' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014012' 
    And   there is no Organisation data for UKPRN '10014912' 
    And   there is no Organisation data for UKPRN '10014812' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014012 Co Ltd' with UKPRN '10014012' and OrgId 'ORG0014012' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014012 | 114012 | 10014012 Co Ltd | 0              | Active                | Yes           | AA014012      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014912 | 114912 | 10014912 Co Ltd | 0              | Active                | Yes           | AA014912      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
    | 10014812 | 114812 | 10014812 Co Ltd | 0              | Active                | Yes           | AA014812      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014012 |
    | 10014912 |
    | 10014812 |




    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation ONE (CO_1619)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014012 | 1619-AS-2021-Contract-LocalAuthority-10014012-2_4     | 2_4            | 1619                        | AS-2021            | 28639.00          |

    # Provider Funding Allocation (CO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014012-2_4  | 2_4                    | 1619-AS-2021-Contract-LocalAuthority-10014012-2_4     | 10014012      | Local        | 10LAU           | 28639.00                  |

    # Funding Allocation Line (aka Deliverable) (CO_1619)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014012-2_4  | 1619-001        | 15755.00         | Payment         |
    | 1619-AS-2021-10014012-2_4  | 1619-024        | 12884.00         | Payment         |

    # Funding Allocation Profile Period (CO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014012-2_4  | 1619-001        | FY-2021              | September              | 2020              | 4739.00                   |
    | 1619-AS-2021-10014012-2_4  | 1619-001        | FY-2021              | January                | 2021              | 4968.00                   |
    | 1619-AS-2021-10014012-2_4  | 1619-001        | FY-2021              | February               | 2021              | 3558.00                   |
    | 1619-AS-2021-10014012-2_4  | 1619-001        | FY-2021              | June                   | 2021              | 2490.00                   |
    #
    | 1619-AS-2021-10014012-2_4  | 1619-024        | FY-2021              | September              | 2020              | 2302.00                   |
    | 1619-AS-2021-10014012-2_4  | 1619-024        | FY-2021              | January                | 2021              | 2943.00                   |
    | 1619-AS-2021-10014012-2_4  | 1619-024        | FY-2021              | February               | 2021              | 4370.00                   |
    | 1619-AS-2021-10014012-2_4  | 1619-024        | FY-2021              | March                  | 2021              | 3269.00                   |





    # Funding Allocation TWO (CO_NFF)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014012 | NFF-AS-2021-Contract-LocalAuthority-10014012-2_9      | 2_9            | NFF                         | AY-2021            | 28058.00          |

    # Provider Funding Allocation (CO_NFF)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2021-10014012-2_9   | 2_9                    | NFF-AS-2021-Contract-LocalAuthority-10014012-2_9      | 10014012      | Local        | 10LAU           | 28058.00                  |

    # Funding Allocation Line (aka Deliverable) (CO_NFF)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2021-10014012-2_9   | NFF-001         | 3550.00          | Payment         |
    | NFF-AS-2021-10014012-2_9   | NFF-002         | 3197.00          | Payment         |
    | NFF-AS-2021-10014012-2_9   | NFF-003         | 5003.00          | Payment         |
    | NFF-AS-2021-10014012-2_9   | NFF-005         | 4014.00          | Payment         |
    | NFF-AS-2021-10014012-2_9   | NFF-006         | 2807.00          | Payment         |
    | NFF-AS-2021-10014012-2_9   | NFF-007         | 4543.00          | Payment         |
    | NFF-AS-2021-10014012-2_9   | NFF-008         | 4944.00          | Payment         |

    # Funding Allocation Profile Period (CO_NFF)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2021-10014012-2_9  | NFF-001          | FY-2021              | August                 | 2020              | 3550.00                   |
    | NFF-AS-2021-10014012-2_9  | NFF-002          | FY-2021              | January                | 2021              | 3197.00                   |
    | NFF-AS-2021-10014012-2_9  | NFF-003          | FY-2021              | May                    | 2021              | 5003.00                   |
    | NFF-AS-2021-10014012-2_9  | NFF-005          | FY-2021              | September              | 2020              | 4014.00                   |
    | NFF-AS-2021-10014012-2_9  | NFF-006          | FY-2021              | October                | 2020              | 2807.00                   |
    | NFF-AS-2021-10014012-2_9  | NFF-007          | FY-2021              | November               | 2020              | 4543.00                   |
    | NFF-AS-2021-10014012-2_9  | NFF-008          | FY-2021              | March                  | 2021              | 4944.00                   |



    # Funding Allocation THREE (DO_1619))
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014012 | 1619-AS-2021-Contract-LocalAuthoritySsf-10014012-3_2  | 3_2            | 1619                        | AS-2021            | 57430.00          |

    # Provider Funding Allocation (DO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014912-3_2  | 3_2                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10014012-3_2  | 10014912      | Schoo        | 08SSF           | 23446.00                  |
    | 1619-AS-2021-10014812-3_2  | 3_2                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10014012-3_2  | 10014812      | Schoo        | 08SSF           | 33984.00                  |

    # Funding Allocation Line (aka Deliverable) (DO_1619)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014912-3_2  | 1619-001        | 17542.00         | Payment         |
    | 1619-AS-2021-10014912-3_2  | 1619-002        | 5904.00          | Payment         |
    #
    | 1619-AS-2021-10014812-3_2  | 1619-001        | 7086.00          | Payment         |
    | 1619-AS-2021-10014812-3_2  | 1619-002        | 22799.00         | Payment         |
    | 1619-AS-2021-10014812-3_2  | 1619-024        | 4099.00          | Payment         |

    # Funding Allocation Profile Period (DO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014912-3_2  | 1619-001        | FY-2021              | August                 | 2020              | 5801.00                   |
    | 1619-AS-2021-10014912-3_2  | 1619-001        | FY-2021              | September              | 2020              | 2030.00                   |
    | 1619-AS-2021-10014912-3_2  | 1619-001        | FY-2021              | November               | 2020              | 4620.00                   |
    | 1619-AS-2021-10014912-3_2  | 1619-001        | FY-2021              | January                | 2021              | 5091.00                   |
    | 1619-AS-2021-10014912-3_2  | 1619-002        | FY-2021              | April                  | 2021              | 2546.00                   |
    | 1619-AS-2021-10014912-3_2  | 1619-002        | FY-2021              | May                    | 2021              | 3358.00                   |
    #
    | 1619-AS-2021-10014812-3_2  | 1619-001        | FY-2021              | October                | 2020              | 2539.00                   |
    | 1619-AS-2021-10014812-3_2  | 1619-001        | FY-2021              | November               | 2020              | 4547.00                   |
    | 1619-AS-2021-10014812-3_2  | 1619-002        | FY-2021              | December               | 2020              | 5773.00                   |
    | 1619-AS-2021-10014812-3_2  | 1619-002        | FY-2021              | January                | 2021              | 4919.00                   |
    | 1619-AS-2021-10014812-3_2  | 1619-002        | FY-2021              | February               | 2021              | 3081.00                   |
    | 1619-AS-2021-10014812-3_2  | 1619-002        | FY-2021              | March                  | 2021              | 4219.00                   |
    | 1619-AS-2021-10014812-3_2  | 1619-002        | FY-2021              | April                  | 2021              | 4807.00                   |
    | 1619-AS-2021-10014812-3_2  | 1619-024        | FY-2021              | July                   | 2021              | 4099.00                   |





    # Funding Allocation FOUR (DO_NFF)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014012 | NFF-AS-2021-Contract-LocalAuthoritySsf-10014012-2_0   | 2_0            | NFF                         | AY-2021            | 43684.00          |

    # Provider Funding Allocation (DO_NFF)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2021-10014912-2_0   | 2_0                    | NFF-AS-2021-Contract-LocalAuthoritySsf-10014012-2_0   | 10014912      | Schoo        | 08SSF           | 21001.00                  |
    | NFF-AS-2021-10014812-2_0   | 2_0                    | NFF-AS-2021-Contract-LocalAuthoritySsf-10014012-2_0   | 10014812      | Schoo        | 08SSF           | 22683.00                  |

    # Funding Allocation Line (aka Deliverable) (DO_NFF)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2021-10014912-2_0   | NFF-005         | 2746.00          | Payment         |
    | NFF-AS-2021-10014912-2_0   | NFF-006         | 18265.00         | Payment         |
    | NFF-AS-2021-10014812-2_0   | NFF-005         | 3144.00          | Payment         |
    | NFF-AS-2021-10014812-2_0   | NFF-008         | 19539.00         | Payment         |

    # Funding Allocation Profile Period (DO_NFF)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2021-10014912-2_0   | NFF-005         | FY-2021              | April                  | 2021              | 1142.00                   |
    | NFF-AS-2021-10014912-2_0   | NFF-005         | FY-2021              | October                | 2020              | 1604.00                   |
    | NFF-AS-2021-10014912-2_0   | NFF-006         | FY-2021              | November               | 2020              | 2637.00                   |
    | NFF-AS-2021-10014912-2_0   | NFF-006         | FY-2021              | December               | 2020              | 3107.00                   |
    | NFF-AS-2021-10014912-2_0   | NFF-006         | FY-2021              | February               | 2021              | 3304.00                   |
    | NFF-AS-2021-10014912-2_0   | NFF-006         | FY-2021              | April                  | 2021              | 4218.00                   |
    | NFF-AS-2021-10014912-2_0   | NFF-006         | FY-2021              | June                   | 2021              | 4999.00                   |
    #
    | NFF-AS-2021-10014812-2_0   | NFF-005         | FY-2021              | April                  | 2021              | 3144.00                   |
    | NFF-AS-2021-10014812-2_0   | NFF-008         | FY-2021              | October                | 2020              | 4047.00                   |
    | NFF-AS-2021-10014812-2_0   | NFF-008         | FY-2021              | November               | 2020              | 2637.00                   |
    | NFF-AS-2021-10014812-2_0   | NFF-008         | FY-2021              | December               | 2020              | 3107.00                   |
    | NFF-AS-2021-10014812-2_0   | NFF-008         | FY-2021              | February               | 2021              | 3304.00                   |
    | NFF-AS-2021-10014812-2_0   | NFF-008         | FY-2021              | April                  | 2021              | 4218.00                   |
    | NFF-AS-2021-10014812-2_0   | NFF-008         | FY-2021              | June                   | 2021              | 2226.00                   |


    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Tidy Up
    Then   the override date is reset



    
@AcceptanceTest @Manual
Scenario: L013 Populate different versions of CFS FAs (1619/NMSS/PSG/DADA/NLG) for a single provider and import latest version only

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014013'
    And   there is no Funding Allocation data in CRM for UKPRN '10014013'
    And   there is no Contract, Task or Workflow data for UKPRN '10014013'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014013' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (NMSS)    |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014013' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014013 Co Ltd' with UKPRN '10014013' and OrgId 'ORG0014013' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014013 | 114013 | 10014013 Co Ltd | 0              | Active                | Yes           | AA014013      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014013 |


    # Populate the stub

    # Initial versions

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | 1619-AS-2021-Contract-Provider-10014013-1_6           | 1_6            | 1619                        | AS-2021            | 15755.00          |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014013-1_6  | 1_6                    | 1619-AS-2021-Contract-Provider-10014013-1_6           | 10014013      | Furth        | 04AHC           | 15755.00                  |

    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014013-1_6  | 1619-005        | 15755.00         | Payment         |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014013-1_6  | 1619-005        | FY-2021              | September              | 2020              | 4739.00                   |
    | 1619-AS-2021-10014013-1_6  | 1619-005        | FY-2021              | January                | 2021              | 4968.00                   |
    | 1619-AS-2021-10014013-1_6  | 1619-005        | FY-2021              | February               | 2021              | 3558.00                   |
    | 1619-AS-2021-10014013-1_6  | 1619-005        | FY-2021              | June                   | 2021              | 2490.00                   |
 

    # Funding Allocation (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | NMSS-AY-2021-Contract-Provider-10014013-2_0       | 2_0            | NMSS                        | AY-2021            | 4480.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2021-10014013-2_0  | 2_0                    | NMSS-AY-2021-Contract-Provider-10014013-2_0 | 10014013      | Furth        | 04AHC           | 4480.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2021-10014013-2_0  | NMSS-004        | 2076.00          | Payment         |
    | NMSS-AY-2021-10014013-2_0  | NMSS-008        | 2404.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2021-10014013-2_0  | NMSS-004        | FY-2021              | September              | 2020              | 2076.00                   |
    #
    | NMSS-AY-2021-10014013-2_0  | NMSS-008        | FY-2021              | December               | 2020              | 2404.00                   |

#
#    # Funding Allocation (FA3/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014013 | PSG-AY-2021-Contract-Provider-10014013-1_3        | 1_3            | PSG                         | AY-2021            | 8002.00           |
#
#    # Provider Funding Allocation (FA3/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | PSG-AY-2021-10014013-1_3   | 1_3                    | PSG-AY-2021-Contract-Provider-10014013-1_3  | 10014013      | Schoo        | 21NMS           | 8002.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA3/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | PSG-AY-2021-10014013-1_3   | PSG-001         | 8002.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA3/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | PSG-AY-2021-10014013-1_3   | PSG-001         | FY-2021              | February               | 2021              | 2091.00                   |
#    | PSG-AY-2021-10014013-1_3   | PSG-001         | FY-2021              | November               | 2020              | 5911.00                   |

 
    # Funding Allocation (FA4/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | DADA-AS-2021-Contract-Provider-10014013-1_7       | 1_7            | DADA                        | AY-2021            | 12000.00          |

    # Provider Funding Allocation (FA4/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014013-1_7  | 1_7                    | DADA-AS-2021-Contract-Provider-10014013-1_7 | 10014013      | Furth        | 02IPP           | 12000.00                  |

    # Funding Allocation Line (aka Deliverable) (FA4/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014013-1_7  | DADA-001        | 12000.00         | Payment         |

    # Funding Allocation Profile Period (FA4/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014013-1_7  | DADA-001        | AY-2021              | October                | 2020              | 12000.00                  |



    # Funding Allocation (FA5/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | NLG-AY-2021-Contract-Provider-10014013-1_4        | 1_4            | NLG                         | AY-2021            | 11678.00          |

    # Provider Funding Allocation  (FA5/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AY-2021-10014013-1_4   | 1_4                    | NLG-AY-2021-Contract-Provider-10014013-1_4  | 10014013      | Furth        | 06SDC           | 11678.00                  |

    # Funding Allocation Line (aka Deliverable)  (FA5/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AY-2021-10014013-1_4   | NLG-001         | 11687.00         | Payment         |

    # Funding Allocation Profile Period  (FA5/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AY-2021-10014013-1_4   | NLG-001         | FY-2021              | July                   | 2021              | 2935.00                   |
    | NLG-AY-2021-10014013-1_4   | NLG-001         | FY-2021              | March                  | 2021              | 3678.00                   |
    | NLG-AY-2021-10014013-1_4   | NLG-001         | FY-2021              | November               | 2020              | 2096.00                   |
    | NLG-AY-2021-10014013-1_4   | NLG-001         | FY-2021              | August                 | 2020              | 2978.00                   |


    # Later Versions

    # Change the date 
    Given the override date is '17/06/2021'


    # Funding Allocation ONE (FA1/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | 1619-AS-2021-Contract-Provider-10014013-1_9           | 1_9            | 1619                        | AS-2021            | 28639.00          |

    # Provider Funding Allocation (FA1/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014013-1_9  | 1_9                    | 1619-AS-2021-Contract-Provider-10014013-1_9           | 10014013      | Furth        | 04AHC           | 28639.00                  |

    # Funding Allocation Line (aka Deliverable) (FA1/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014013-1_9  | 1619-005        | 15755.00         | Payment         |
    | 1619-AS-2021-10014013-1_9  | 1619-010        | 12884.00         | Payment         |

    # Funding Allocation Profile Period (FA1/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014013-1_9  | 1619-005        | FY-2021              | September              | 2020              | 4739.00                   |
    | 1619-AS-2021-10014013-1_9  | 1619-005        | FY-2021              | January                | 2021              | 4968.00                   |
    | 1619-AS-2021-10014013-1_9  | 1619-005        | FY-2021              | February               | 2021              | 3558.00                   |
    | 1619-AS-2021-10014013-1_9  | 1619-005        | FY-2021              | June                   | 2021              | 2490.00                   |
    #
    | 1619-AS-2021-10014013-1_9  | 1619-010        | FY-2021              | September              | 2020              | 2302.00                   |
    | 1619-AS-2021-10014013-1_9  | 1619-010        | FY-2021              | January                | 2021              | 2943.00                   |
    | 1619-AS-2021-10014013-1_9  | 1619-010        | FY-2021              | February               | 2021              | 4370.00                   |
    | 1619-AS-2021-10014013-1_9  | 1619-010        | FY-2021              | March                  | 2021              | 3269.00                   |
 
 
    # Funding Allocation (FA2/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | NMSS-AY-2021-Contract-Provider-10014013-3_0       | 3_0            | NMSS                        | AY-2021            | 29863.00          |

    # Provider Funding Allocation (FA2/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2021-10014013-3_0  | 3_0                    | NMSS-AY-2021-Contract-Provider-10014013-3_0 | 10014013      | Furth        | 04AHC           | 29863.00                  |

    # Funding Allocation Line (aka Deliverable) (FA2/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2021-10014013-3_0  | NMSS-004        | 2076.00          | Payment         |
    | NMSS-AY-2021-10014013-3_0  | NMSS-007        | 25383.00         | Payment         |
    | NMSS-AY-2021-10014013-3_0  | NMSS-008        | 2404.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2021-10014013-3_0  | NMSS-004        | FY-2021              | September              | 2020              | 2076.00                   |
    #
    | NMSS-AY-2021-10014013-3_0  | NMSS-007        | FY-2021              | June                   | 2021              | 5330.00                   |
    | NMSS-AY-2021-10014013-3_0  | NMSS-007        | FY-2021              | April                  | 2021              | 3850.00                   |
    | NMSS-AY-2021-10014013-3_0  | NMSS-007        | FY-2021              | February               | 2021              | 2301.00                   |
    | NMSS-AY-2021-10014013-3_0  | NMSS-007        | FY-2021              | December               | 2020              | 4860.00                   |
    | NMSS-AY-2021-10014013-3_0  | NMSS-007        | FY-2021              | October                | 2020              | 3653.00                   |
    | NMSS-AY-2021-10014013-3_0  | NMSS-007        | FY-2021              | September              | 2020              | 5389.00                   |
    #
    | NMSS-AY-2021-10014013-3_0  | NMSS-008        | FY-2021              | December               | 2020              | 2404.00                   |

       
#
#    # Funding Allocation (FA3/V2)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014013 | PSG-AY-2021-Contract-Provider-10014013-1_4        | 1_4            | PSG                         | AY-2021            | 8002.00           |
#
#    # Provider Funding Allocation (FA3/V2)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | PSG-AY-2021-10014013-1_4   | 1_4                    | PSG-AY-2021-Contract-Provider-10014013-1_4  | 10014013      | Furth        | 04AHC           | 8002.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA3/V2)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | PSG-AY-2021-10014013-1_4   | PSG-001         | 8002.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA3/V2)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | PSG-AY-2021-10014013-1_4   | PSG-001         | FY-2021              | February               | 2021              | 2091.00                   |
#    | PSG-AY-2021-10014013-1_4   | PSG-001         | FY-2021              | November               | 2020              | 5911.00                   |
#
#

    # Funding Allocation (FA4/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | DADA-AS-2021-Contract-Provider-10014013-1_8       | 1_8            | DADA                        | AY-2021            | 12000.00          |

    # Provider Funding Allocation (FA4/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014013-1_8  | 1_8                    | DADA-AS-2021-Contract-Provider-10014013-1_8 | 10014013      | Furth        | 02IPP           | 12000.00                  |

    # Funding Allocation Line (aka Deliverable) (FA4/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014013-1_8  | DADA-001        | 12000.00         | Payment         |

    # Funding Allocation Profile Period (FA4/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014013-1_8  | DADA-001        | AY-2021              | October                | 2020              | 6000.00                   |
    | DADA-AS-2021-10014013-1_8  | DADA-001        | AY-2021              | April                  | 2021              | 6000.00                   |


    # Funding Allocation (FA5/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | NLG-AY-2021-Contract-Provider-10014013-2_0        | 2_0            | NLG                         | AY-2021            | 14265.00          |

    # Provider Funding Allocation (FA5/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AY-2021-10014013-2_0   | 2_0                    | NLG-AY-2021-Contract-Provider-10014013-2_0  | 10014013      | Furth        | 06SDC           | 14265.00                  |

    # Funding Allocation Line (aka Deliverable) (FA5/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AY-2021-10014013-2_0   | NLG-001         | 11687.00         | Payment         |
    | NLG-AY-2021-10014013-2_0   | NLG-002         | 2578.00          | Payment         |
    | NLG-AY-2021-10014013-2_0   | NLG-003         | 4376.00          | Payment         |

    # Funding Allocation Profile Period (FA5/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId        | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AY-2021-10014013-2_0 | NLG-001         | FY-2021              | July                   | 2021              | 2935.00                   |
    | NLG-AY-2021-10014013-2_0 | NLG-001         | FY-2021              | March                  | 2021              | 3678.00                   |
    | NLG-AY-2021-10014013-2_0 | NLG-001         | FY-2021              | November               | 2020              | 2096.00                   |
    | NLG-AY-2021-10014013-2_0 | NLG-001         | FY-2021              | August                 | 2020              | 2978.00                   |
    #
    | NLG-AY-2021-10014013-2_0 | NLG-002         | FY-2021              | April                  | 2021              | 2578.00                   |
    #
    | NLG-AY-2021-10014013-2_0 | NLG-003         | FY-2021              | June                   | 2021              | 4376.00                   |


    # Latest Versions

    # Change the date 
    Given the override date is '20/06/2021'

  
    # Funding Allocation (FA2/V3)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | NMSS-AY-2021-Contract-Provider-10014013-3_1       | 3_1            | NMSS                        | AY-2021            | 29863.00          |

    # Provider Funding Allocation (FA2/V3)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2021-10014013-3_1  | 3_1                    | NMSS-AY-2021-Contract-Provider-10014013-3_1 | 10014013      | Furth        | 04AHC           | 29863.00                  |

    # Funding Allocation Line (aka Deliverable) (FA2/V3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2021-10014013-3_1  | NMSS-004        | 2076.00          | Payment         |
    | NMSS-AY-2021-10014013-3_1  | NMSS-007        | 25383.00         | Payment         |
    | NMSS-AY-2021-10014013-3_1  | NMSS-008        | 2404.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V3)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2021-10014013-3_1  | NMSS-004        | FY-2021              | September              | 2020              | 2076.00                   |
    #
    | NMSS-AY-2021-10014013-3_1  | NMSS-007        | FY-2021              | June                   | 2021              | 5330.00                   |
    | NMSS-AY-2021-10014013-3_1  | NMSS-007        | FY-2021              | April                  | 2021              | 3850.00                   |
    | NMSS-AY-2021-10014013-3_1  | NMSS-007        | FY-2021              | February               | 2021              | 2301.00                   |
    | NMSS-AY-2021-10014013-3_1  | NMSS-007        | FY-2021              | December               | 2020              | 4860.00                   |
    | NMSS-AY-2021-10014013-3_1  | NMSS-007        | FY-2021              | October                | 2020              | 3653.00                   |
    | NMSS-AY-2021-10014013-3_1  | NMSS-007        | FY-2021              | September              | 2020              | 5389.00                   |
    #
    | NMSS-AY-2021-10014013-3_1  | NMSS-008        | FY-2021              | December               | 2020              | 1202.00                   |
    | NMSS-AY-2021-10014013-3_1  | NMSS-008        | FY-2021              | June                   | 2021              | 1202.00                   |


    # Funding Allocation (FA4/V3)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | DADA-AS-2021-Contract-Provider-10014013-2_0       | 2_0            | DADA                        | AY-2021            | 15000.00          |

    # Provider Funding Allocation (FA4/V3)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014013-2_0  | 2_0                    | DADA-AS-2021-Contract-Provider-10014013-2_0 | 10014013      | Furth        | 02IPP           | 15000.00                  |

    # Funding Allocation Line (aka Deliverable) (FA4/V3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014013-2_0  | DADA-001        | 15000.00         | Payment         |

    # Funding Allocation Profile Period (FA4/V3)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014013-2_0  | DADA-001        | AY-2021              | October                | 2020              | 6000.00                   |
    | DADA-AS-2021-10014013-2_0  | DADA-001        | AY-2021              | April                  | 2021              | 6000.00                   |
    | DADA-AS-2021-10014013-2_0  | DADA-001        | AY-2021              | July                   | 2021              | 3000.00                   |


    # Change the date 
    Given the override date is '22/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Tidy Up
    Then   the override date is reset

    
@AcceptanceTest @Incomplete
Scenario: L014 Populate different versions of CFS FAs (1619/PSG/NFF) for a single LA and import latest version only

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014014'
    And   there is no Funding Allocation data in CRM for UKPRN '10014014'
    And   there is no Contract, Task or Workflow data for UKPRN '10014014'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014014' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014014' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014014 Co Ltd' with UKPRN '10014014' and OrgId 'ORG0014014' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014014 | 114014 | 10014014 Co Ltd | 0              | Active                | Yes           | AA014014      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014014 |


    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'
 

    # Funding Allocation ONE (FA1/V3)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014014 | 1619-AS-2021-Contract-LocalAuthority-10014014-2_5     | 2_5            | 1619                        | AS-2021            | 28639.00          |

    # Provider Funding Allocation (FA1/V3)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014014-2_5  | 2_5                    | 1619-AS-2021-Contract-LocalAuthority-10014014-2_5     | 10014014      | Local        | 10LAU           | 28639.00                  |

    # Funding Allocation Line (aka Deliverable) (FA1/V3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014014-2_5  | 1619-001        | 15755.00         | Payment         |
    | 1619-AS-2021-10014014-2_5  | 1619-002        | 12884.00         | Payment         |

    # Funding Allocation Profile Period (FA1/V3)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014014-2_5  | 1619-001        | FY-2021              | September              | 2020              | 4739.00                   |
    | 1619-AS-2021-10014014-2_5  | 1619-001        | FY-2021              | January                | 2021              | 4968.00                   |
    | 1619-AS-2021-10014014-2_5  | 1619-001        | FY-2021              | February               | 2021              | 3558.00                   |
    | 1619-AS-2021-10014014-2_5  | 1619-001        | FY-2021              | June                   | 2021              | 2490.00                   |
    #
    | 1619-AS-2021-10014014-2_5  | 1619-002        | FY-2021              | September              | 2020              | 2302.00                   |
    | 1619-AS-2021-10014014-2_5  | 1619-002        | FY-2021              | January                | 2021              | 2943.00                   |
    | 1619-AS-2021-10014014-2_5  | 1619-002        | FY-2021              | February               | 2021              | 4370.00                   |
    | 1619-AS-2021-10014014-2_5  | 1619-002        | FY-2021              | June                   | 2021              | 3269.00                   |


 
    # Change the date 
    Given the override date is '17/06/2021'

    # Funding Allocation ONE (FA1/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014014 | 1619-AS-2021-Contract-LocalAuthority-10014014-2_4     | 2_4            | 1619                        | AS-2021            | 28639.00          |

    # Provider Funding Allocation (FA1/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014014-2_4  | 2_4                    | 1619-AS-2021-Contract-LocalAuthority-10014014-2_4     | 10014014      | Local        | 10LAU           | 28639.00                  |

    # Funding Allocation Line (aka Deliverable) (FA1/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014014-2_4  | 1619-001        | 15755.00         | Payment         |
    | 1619-AS-2021-10014014-2_4  | 1619-002        | 12884.00         | Payment         |

    # Funding Allocation Profile Period (FA1/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014014-2_4  | 1619-001        | FY-2021              | September              | 2020              | 4739.00                   |
    | 1619-AS-2021-10014014-2_4  | 1619-001        | FY-2021              | January                | 2021              | 4968.00                   |
    | 1619-AS-2021-10014014-2_4  | 1619-001        | FY-2021              | February               | 2021              | 3558.00                   |
    | 1619-AS-2021-10014014-2_4  | 1619-001        | FY-2021              | June                   | 2021              | 2490.00                   |
    #
    | 1619-AS-2021-10014014-2_4  | 1619-002        | FY-2021              | September              | 2020              | 2302.00                   |
    | 1619-AS-2021-10014014-2_4  | 1619-002        | FY-2021              | January                | 2021              | 2943.00                   |
    | 1619-AS-2021-10014014-2_4  | 1619-002        | FY-2021              | February               | 2021              | 4370.00                   |
    | 1619-AS-2021-10014014-2_4  | 1619-002        | FY-2021              | March                  | 2021              | 3269.00                   |


    # Funding Allocation TWO (FA2/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014014 | NFF-AS-2021-Contract-LocalAuthority-10014014-2_9      | 2_9            | NFF                         | AY-2021            | 28058.00          |

    # Provider Funding Allocation (FA2/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2021-10014014-2_9   | 2_9                    | NFF-AS-2021-Contract-LocalAuthority-10014014-2_9      | 10014014      | Local        | 10LAU           | 28058.00                  |

    # Funding Allocation Line (aka Deliverable) (FA2/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2021-10014014-2_9   | NFF-001        | 11750.00         | Payment         |
    | NFF-AS-2021-10014014-2_9   | NFF-002        | 16308.00         | Payment         |

    # Funding Allocation Profile Period (FA2/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2021-10014014-2_9   | NFF-001        | FY-2021              | August                 | 2020              | 3550.00                   |
    | NFF-AS-2021-10014014-2_9   | NFF-001        | FY-2021              | January                | 2021              | 3197.00                   |
    | NFF-AS-2021-10014014-2_9   | NFF-001        | FY-2021              | May                    | 2021              | 5003.00                   |
    #
    | NFF-AS-2021-10014014-2_9   | NFF-002        | FY-2021              | September              | 2020              | 4014.00                   |
    | NFF-AS-2021-10014014-2_9   | NFF-002        | FY-2021              | October                | 2020              | 2807.00                   |
    | NFF-AS-2021-10014014-2_9   | NFF-002        | FY-2021              | November               | 2020              | 4543.00                   |
    | NFF-AS-2021-10014014-2_9   | NFF-002        | FY-2021              | March                  | 2021              | 4944.00                   |


#    # Funding Allocation (3)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014014 | PSG-AY-2021-Contract-LocalAuthority-10014014-1_4  | 1_4            | PSG                         | AY-2021            | 8002.00           |
#
#    # LocalAuthority Funding Allocation (3)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                         | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | PSG-AY-2021-10014014-1_4   | 1_4                    | PSG-AY-2021-Contract-LocalAuthority-10014014-1_4  | 10014014      | Local        | 10LAU           | 8002.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (3)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | PSG-AY-2021-10014014-1_4   | PSG-001         | 8002.00          | Payment         |
#
#    # Funding Allocation Profile Period (3)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | PSG-AY-2021-10014014-1_4   | PSG-001         | FY-2021              | February               | 2021              | 2091.00                   |
#    | PSG-AY-2021-10014014-1_4   | PSG-001         | FY-2021              | November               | 2020              | 5911.00                   |


 
    # Change the date 
    Given the override date is '20/06/2021'

    # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014014 | 1619-AS-2021-Contract-LocalAuthority-10014014-2_1     | 2_1            | 1619                        | AS-2021            | 15755.00          |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014014-2_1  | 2_1                    | 1619-AS-2021-Contract-LocalAuthority-10014014-2_1     | 10014014      | Local        | 10LAU           | 15755.00                  |

    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014014-2_1  | 1619-001        | 15755.00         | Payment         |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014014-2_1  | 1619-001        | FY-2021              | September              | 2020              | 4739.00                   |
    | 1619-AS-2021-10014014-2_1  | 1619-001        | FY-2021              | January                | 2021              | 4968.00                   |
    | 1619-AS-2021-10014014-2_1  | 1619-001        | FY-2021              | February               | 2021              | 3558.00                   |
    | 1619-AS-2021-10014014-2_1  | 1619-001        | FY-2021              | June                   | 2021              | 2490.00                   |
 

    # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014014 | NFF-AS-2021-Contract-LocalAuthority-10014014-1_4      | 1_4            | NFF                         | AY-2021            | 16308.00          |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2021-10014014-1_4   | 1_4                    | NFF-AS-2021-Contract-LocalAuthority-10014014-1_4      | 10014014      | Local        | 10LAU           | 16308.00                  |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2021-10014014-1_4   | NFF-002         | 16308.00         | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2021-10014014-1_4   | NFF-002        | FY-2021              | September              | 2020              | 4014.00                   |
    | NFF-AS-2021-10014014-1_4   | NFF-002        | FY-2021              | October                | 2020              | 2807.00                   |
    | NFF-AS-2021-10014014-1_4   | NFF-002        | FY-2021              | November               | 2020              | 4543.00                   |
    | NFF-AS-2021-10014014-1_4   | NFF-002        | FY-2021              | March                  | 2021              | 4944.00                   |


#    # Funding Allocation (FA3/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014014 | PSG-AY-2021-Contract-LocalAuthority-10014014-1_2  | 1_2            | PSG                         | AY-2021            | 2091.00           |
#
#    # LocalAuthority Funding Allocation (FA3/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                         | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | PSG-AY-2021-10014014-1_2   | 1_2                    | PSG-AY-2021-Contract-LocalAuthority-10014014-1_2  | 10014014      | Local        | 10LAU           | 2091.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA3/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | PSG-AY-2021-10014014-1_2   | PSG-001         | 2091.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA3/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | PSG-AY-2021-10014014-1_2   | PSG-001         | FY-2021              | February               | 2021              | 2091.00                   |

    # Change the date 
    Given the override date is '22/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Tidy Up
    Then   the override date is reset

        
@AcceptanceTest @Manual
Scenario: L015 Import multiple versions 1619 FAs (1619) for several providers
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014015'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014915'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014815'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10015015'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10015915'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10015815'
    And   there is no Funding Allocation data in CRM for UKPRN '10014015'
    And   there is no Funding Allocation data in CRM for UKPRN '10014915'
    And   there is no Funding Allocation data in CRM for UKPRN '10014815'
    And   there is no Funding Allocation data in CRM for UKPRN '10015015'
    And   there is no Funding Allocation data in CRM for UKPRN '10015915'
    And   there is no Funding Allocation data in CRM for UKPRN '10015815'
    And   there is no Contract, Task or Workflow data for UKPRN '10014015'
    And   there is no Contract, Task or Workflow data for UKPRN '10014915'
    And   there is no Contract, Task or Workflow data for UKPRN '10014815'
    And   there is no Contract, Task or Workflow data for UKPRN '10015015'
    And   there is no Contract, Task or Workflow data for UKPRN '10015915'
    And   there is no Contract, Task or Workflow data for UKPRN '10015815'
    
    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014015' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014915' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014815' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10015015' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10015915' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10015815' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014015' 
    And there is no Organisation data for UKPRN '10014915'  
    And there is no Organisation data for UKPRN '10014815'  
    And there is no Organisation data for UKPRN '10015015'  
    And there is no Organisation data for UKPRN '10015915'  
    And there is no Organisation data for UKPRN '10015815' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014015 Co Ltd' with UKPRN '10014015' and OrgId 'ORG0014015' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014915 Co Ltd' with UKPRN '10014915' and OrgId 'ORG0014915' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014815 Co Ltd' with UKPRN '10014815' and OrgId 'ORG0014815' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10015015 Co Ltd' with UKPRN '10015015' and OrgId 'ORG0015015' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10015915 Co Ltd' with UKPRN '10015915' and OrgId 'ORG0015915' and has 'FCS1 Test' as a manager
    And   caseload advisor 'FCS2 Test' is assigned to provider '10015815 Co Ltd' with UKPRN '10015815' and OrgId 'ORG0015815' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014015 | 114015 | 10014015 Co Ltd | 0              | Locked Restructure    | Yes           | AA014015      | ?             | 100 Harley Street      | London                 | ?                      | ?                      | ?                      | ?                      | W1N 1AF   |
    | 10014915 | 114915 | 10014915 Co Ltd | 0              | Locked Restructure    | Yes           | AA014915      | ?             | 10 High Street         | Grantham               | ?                      | ?                      | ?                      | Lincs                  | NG31 0FF  |
    | 10014815 | 114815 | 10014815 Co Ltd | 0              | Locked Restructure    | Yes           | AA014815      | ?             | Quinton Road           | Cheylesmore            | ?                      | ?                      | Coventry               | ?                      | CV1 2WT   |
    | 10015015 | 115015 | 10015015 Co Ltd | 0              | Locked Restructure    | Yes           | AA015015      | ?             | Flat 3a                | Broughton Court        | Bitteswell Road        | Leicestershire         | ?                      | ?                      | LE17 4SH  |
    | 10015915 | 115915 | 10015915 Co Ltd | 0              | Locked Restructure    | Yes           | AA015915      | ?             | 512 Brook Street       | ?                      | ?                      | ?                      | Welshpool              | Powys                  | NG31 0FF  |
    | 10015815 | 115815 | 10015815 Co Ltd | 0              | Locked Restructure    | Yes           | AA015815      | ?             | 1 Avenue Rd            | Aston                  | Birmingham             | ?                      | ?                      | ?                      | B6 4DU    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014015 |
    | 10014915 |
    | 10014815 |
    | 10015015 |
    | 10015915 |
    | 10015815 |

 
     # Populate the stub (Set 1)

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation (Set 1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014015 | 1619-AS-2021-Contract-Provider-10014015-1_3       | 1_3            | 1619                        | AS-2021            | 39697.00          |
    | Contracting    | 10014915 | 1619-AS-2021-Contract-Provider-10014915-2_0       | 2_0            | 1619                        | AS-2021            | 20515.00          |
    | Contracting    | 10014815 | 1619-AS-2021-Contract-Provider-10014815-4_2       | 4_2            | 1619                        | AS-2021            | 14243.00          |
    | Contracting    | 10015015 | 1619-AS-2021-Contract-Provider-10015015-4_4       | 4_4            | 1619                        | AS-2021            | 20515.00          |
    | Contracting    | 10015915 | 1619-AS-2021-Contract-Provider-10015915-2_0       | 2_0            | 1619                        | AS-2021            | 14243.00          |



    # Provider Funding Allocation (Set 1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014015-1_3  | 1_3                    | 1619-AS-2021-Contract-Provider-10014015-1_3 | 10014015      | Furth        | 04AHC           | 39697.00                  |
    | 1619-AS-2021-10014915-2_0  | 2_0                    | 1619-AS-2021-Contract-Provider-10014915-2_0 | 10014915      | Furth        | 04AHC           | 20515.00                  |
    | 1619-AS-2021-10014815-4_2  | 4_2                    | 1619-AS-2021-Contract-Provider-10014815-4_2 | 10014815      | Furth        | 06SDC           | 14243.00                  |
    | 1619-AS-2021-10015015-4_4  | 4_4                    | 1619-AS-2021-Contract-Provider-10015015-4_4 | 10015015      | Furth        | 03SFC           | 20515.00                  |
    | 1619-AS-2021-10015915-2_0  | 2_0                    | 1619-AS-2021-Contract-Provider-10015915-2_0 | 10015915      | Furth        | 05ADC           | 14243.00                  |

    # Funding Allocation Line (aka Deliverable) (Set 1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014015-1_3  | 1619-021        | 5735.00          | Payment         |
    | 1619-AS-2021-10014015-1_3  | 1619-013        | 8508.00          | Payment         |
    | 1619-AS-2021-10014015-1_3  | 1619-003        | 6272.00          | Payment         |
    | 1619-AS-2021-10014015-1_3  | 1619-010        | 19182.00         | Payment         |
    | 1619-AS-2021-10014915-2_0  | 1619-005        | 5735.00          | Payment         |
    | 1619-AS-2021-10014915-2_0  | 1619-006        | 8508.00          | Payment         |
    | 1619-AS-2021-10014915-2_0  | 1619-007        | 6272.00          | Payment         |
    | 1619-AS-2021-10014815-4_2  | 1619-008        | 5735.00          | Payment         |
    | 1619-AS-2021-10014815-4_2  | 1619-009        | 8508.00          | Payment         |
    | 1619-AS-2021-10015015-4_4  | 1619-003        | 5735.00          | Payment         |
    | 1619-AS-2021-10015015-4_4  | 1619-004        | 8508.00          | Payment         |
    | 1619-AS-2021-10015015-4_4  | 1619-005        | 6272.00          | Payment         |
    | 1619-AS-2021-10015915-2_0  | 1619-010        | 5735.00          | Payment         |
    | 1619-AS-2021-10015915-2_0  | 1619-011        | 8508.00          | Payment         |

    # Funding Allocation Profile Period (Set 1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014015-1_3  | 1619-021        | FY-2021              | October                | 2020              | 5735.00                   |
    | 1619-AS-2021-10014015-1_3  | 1619-013        | FY-2021              | April                  | 2021              | 5763.00                   |
    | 1619-AS-2021-10014015-1_3  | 1619-013        | FY-2021              | January                | 2021              | 2745.00                   |
    | 1619-AS-2021-10014015-1_3  | 1619-003        | FY-2021              | July                   | 2021              | 2423.00                   |
    | 1619-AS-2021-10014015-1_3  | 1619-003        | FY-2021              | October                | 2020              | 3849.00                   |
    | 1619-AS-2021-10014015-1_3  | 1619-010        | FY-2021              | June                   | 2021              | 4271.00                   |
    | 1619-AS-2021-10014015-1_3  | 1619-010        | FY-2021              | April                  | 2021              | 4501.00                   |
    | 1619-AS-2021-10014015-1_3  | 1619-010        | FY-2021              | February               | 2021              | 3091.00                   |
    | 1619-AS-2021-10014015-1_3  | 1619-010        | FY-2021              | December               | 2020              | 3561.00                   |
    | 1619-AS-2021-10014015-1_3  | 1619-010        | FY-2021              | October                | 2020              | 3758.00                   |
    | 1619-AS-2021-10014915-2_0  | 1619-005        | FY-2021              | September              | 2020              | 5735.00                   |
    | 1619-AS-2021-10014915-2_0  | 1619-006        | FY-2021              | March                  | 2021              | 5763.00                   |
    | 1619-AS-2021-10014915-2_0  | 1619-006        | FY-2021              | February               | 2021              | 2745.00                   |
    | 1619-AS-2021-10014915-2_0  | 1619-007        | FY-2021              | May                    | 2021              | 2423.00                   |
    | 1619-AS-2021-10014915-2_0  | 1619-007        | FY-2021              | October                | 2020              | 3849.00                   |
    | 1619-AS-2021-10014815-4_2  | 1619-008        | FY-2021              | September              | 2020              | 5735.00                   |
    | 1619-AS-2021-10014815-4_2  | 1619-009        | FY-2021              | March                  | 2021              | 5763.00                   |
    | 1619-AS-2021-10014815-4_2  | 1619-009        | FY-2021              | February               | 2021              | 2745.00                   |
    | 1619-AS-2021-10015015-4_4  | 1619-003        | FY-2021              | October                | 2020              | 5735.00                   |
    | 1619-AS-2021-10015015-4_4  | 1619-004        | FY-2021              | April                  | 2021              | 5763.00                   |
    | 1619-AS-2021-10015015-4_4  | 1619-004        | FY-2021              | January                | 2021              | 2745.00                   |
    | 1619-AS-2021-10015015-4_4  | 1619-005        | FY-2021              | July                   | 2021              | 2423.00                   |
    | 1619-AS-2021-10015015-4_4  | 1619-005        | FY-2021              | October                | 2020              | 3849.00                   |
    | 1619-AS-2021-10015915-2_0  | 1619-010        | FY-2021              | November               | 2020              | 5735.00                   |
    | 1619-AS-2021-10015915-2_0  | 1619-011        | FY-2021              | June                   | 2021              | 5763.00                   |
    | 1619-AS-2021-10015915-2_0  | 1619-011        | FY-2021              | August                 | 2020              | 2745.00                   |


    # Populate the stub (Set 2)

    # Change the date 
    Given the override date is '17/06/2021'

    # Funding Allocation (Set 2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014015 | 1619-AS-2021-Contract-Provider-10014015-2_0       | 2_0            | 1619                        | AS-2021            | 39697.00          |
    | Contracting    | 10014915 | 1619-AS-2021-Contract-Provider-10014915-3_0       | 3_0            | 1619                        | AS-2021            | 20515.00          |
    | Contracting    | 10015015 | 1619-AS-2021-Contract-Provider-10015015-5_1       | 5_1            | 1619                        | AS-2021            | 20515.00          |
    | Contracting    | 10015915 | 1619-AS-2021-Contract-Provider-10015915-2_1       | 2_1            | 1619                        | AS-2021            | 14243.00          |



    # Provider Funding Allocation (Set 2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014015-2_0  | 2_0                    | 1619-AS-2021-Contract-Provider-10014015-2_0 | 10014015      | Furth        | 04AHC           | 39697.00                  |
    | 1619-AS-2021-10014915-3_0  | 3_0                    | 1619-AS-2021-Contract-Provider-10014915-3_0 | 10014915      | Furth        | 04AHC           | 20515.00                  |
    | 1619-AS-2021-10015015-5_1  | 5_1                    | 1619-AS-2021-Contract-Provider-10015015-5_1 | 10015015      | Furth        | 03SFC           | 20515.00                  |
    | 1619-AS-2021-10015915-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10015915-2_1 | 10015915      | Furth        | 05ADC           | 14243.00                  |

    # Funding Allocation Line (aka Deliverable) (Set 1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014015-2_0  | 1619-021        | 5735.00          | Payment         |
    | 1619-AS-2021-10014015-2_0  | 1619-013        | 8508.00          | Payment         |
    | 1619-AS-2021-10014015-2_0  | 1619-003        | 6272.00          | Payment         |
    | 1619-AS-2021-10014015-2_0  | 1619-010        | 19182.00         | Payment         |
    | 1619-AS-2021-10014915-3_0  | 1619-005        | 5735.00          | Payment         |
    | 1619-AS-2021-10014915-3_0  | 1619-006        | 8508.00          | Payment         |
    | 1619-AS-2021-10014915-3_0  | 1619-007        | 6272.00          | Payment         |
    | 1619-AS-2021-10015015-5_1  | 1619-003        | 5735.00          | Payment         |
    | 1619-AS-2021-10015015-5_1  | 1619-004        | 8508.00          | Payment         |
    | 1619-AS-2021-10015015-5_1  | 1619-005        | 6272.00          | Payment         |
    | 1619-AS-2021-10015915-2_1  | 1619-010        | 5735.00          | Payment         |
    | 1619-AS-2021-10015915-2_1  | 1619-011        | 8508.00          | Payment         |

    # Funding Allocation Profile Period (Set 1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014015-2_0  | 1619-021        | FY-2021              | October                | 2020              | 5735.00                   |
    | 1619-AS-2021-10014015-2_0  | 1619-013        | FY-2021              | April                  | 2021              | 5763.00                   |
    | 1619-AS-2021-10014015-2_0  | 1619-013        | FY-2021              | January                | 2021              | 2745.00                   |
    | 1619-AS-2021-10014015-2_0  | 1619-003        | FY-2021              | July                   | 2021              | 2423.00                   |
    | 1619-AS-2021-10014015-2_0  | 1619-003        | FY-2021              | October                | 2020              | 3849.00                   |
    | 1619-AS-2021-10014015-2_0  | 1619-010        | FY-2021              | June                   | 2021              | 4271.00                   |
    | 1619-AS-2021-10014015-2_0  | 1619-010        | FY-2021              | April                  | 2021              | 4501.00                   |
    | 1619-AS-2021-10014015-2_0  | 1619-010        | FY-2021              | February               | 2021              | 3091.00                   |
    | 1619-AS-2021-10014015-2_0  | 1619-010        | FY-2021              | December               | 2020              | 3561.00                   |
    | 1619-AS-2021-10014015-2_0  | 1619-010        | FY-2021              | October                | 2020              | 3758.00                   |
    | 1619-AS-2021-10014915-3_0  | 1619-005        | FY-2021              | September              | 2020              | 5735.00                   |
    | 1619-AS-2021-10014915-3_0  | 1619-006        | FY-2021              | March                  | 2021              | 5763.00                   |
    | 1619-AS-2021-10014915-3_0  | 1619-006        | FY-2021              | February               | 2021              | 2745.00                   |
    | 1619-AS-2021-10014915-3_0  | 1619-007        | FY-2021              | May                    | 2021              | 2423.00                   |
    | 1619-AS-2021-10014915-3_0  | 1619-007        | FY-2021              | October                | 2020              | 3849.00                   |
    | 1619-AS-2021-10015015-5_1  | 1619-003        | FY-2021              | October                | 2020              | 5735.00                   |
    | 1619-AS-2021-10015015-5_1  | 1619-004        | FY-2021              | April                  | 2021              | 5763.00                   |
    | 1619-AS-2021-10015015-5_1  | 1619-004        | FY-2021              | January                | 2021              | 2745.00                   |
    | 1619-AS-2021-10015015-5_1  | 1619-005        | FY-2021              | July                   | 2021              | 2423.00                   |
    | 1619-AS-2021-10015015-5_1  | 1619-005        | FY-2021              | October                | 2020              | 3849.00                   |
    | 1619-AS-2021-10015915-2_1  | 1619-010        | FY-2021              | November               | 2020              | 5735.00                   |
    | 1619-AS-2021-10015915-2_1  | 1619-011        | FY-2021              | June                   | 2021              | 5763.00                   |
    | 1619-AS-2021-10015915-2_1  | 1619-011        | FY-2021              | August                 | 2020              | 2745.00                   |



    # Populate the stub (Set 3)

    # Change the date 
    Given the override date is '20/06/2021'

    # Funding Allocation (Set 3)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014015 | 1619-AS-2021-Contract-Provider-10014015-2_1       | 2_1            | 1619                        | AS-2021            | 39697.00          |
    | Contracting    | 10014915 | 1619-AS-2021-Contract-Provider-10014915-3_8       | 3_8            | 1619                        | AS-2021            | 20515.00          |
    | Contracting    | 10015815 | 1619-AS-2021-Contract-Provider-10015815-2_1       | 2_1            | 1619                        | AS-2021            | 14243.00          |



    # Provider Funding Allocation (Set 3)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014015-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10014015-2_1 | 10014015      | Furth        | 04AHC           | 39697.00                  |
    | 1619-AS-2021-10014915-3_8  | 3_8                    | 1619-AS-2021-Contract-Provider-10014915-3_8 | 10014915      | Furth        | 04AHC           | 20515.00                  |
    | 1619-AS-2021-10015815-2_1  | 2_1                    | 1619-AS-2021-Contract-Provider-10015815-2_1 | 10015815      | Furth        | 05ADC           | 14243.00                  |

    # Funding Allocation Line (aka Deliverable) (Set 3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014015-2_1  | 1619-021        | 5735.00          | Payment         |
    | 1619-AS-2021-10014015-2_1  | 1619-013        | 8508.00          | Payment         |
    | 1619-AS-2021-10014015-2_1  | 1619-003        | 6272.00          | Payment         |
    | 1619-AS-2021-10014015-2_1  | 1619-010        | 19182.00         | Payment         |
    | 1619-AS-2021-10014915-3_8  | 1619-005        | 5735.00          | Payment         |
    | 1619-AS-2021-10014915-3_8  | 1619-006        | 8508.00          | Payment         |
    | 1619-AS-2021-10014915-3_8  | 1619-007        | 6272.00          | Payment         |
    | 1619-AS-2021-10015815-2_1  | 1619-010        | 5735.00          | Payment         |
    | 1619-AS-2021-10015815-2_1  | 1619-011        | 8508.00          | Payment         |

    # Funding Allocation Profile Period (Set 3)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014015-2_1  | 1619-021        | FY-2021              | October                | 2020              | 5735.00                   |
    | 1619-AS-2021-10014015-2_1  | 1619-013        | FY-2021              | April                  | 2021              | 5763.00                   |
    | 1619-AS-2021-10014015-2_1  | 1619-013        | FY-2021              | January                | 2021              | 2745.00                   |
    | 1619-AS-2021-10014015-2_1  | 1619-003        | FY-2021              | July                   | 2021              | 2423.00                   |
    | 1619-AS-2021-10014015-2_1  | 1619-003        | FY-2021              | October                | 2020              | 3849.00                   |
    | 1619-AS-2021-10014015-2_1  | 1619-010        | FY-2021              | June                   | 2021              | 4271.00                   |
    | 1619-AS-2021-10014015-2_1  | 1619-010        | FY-2021              | April                  | 2021              | 4501.00                   |
    | 1619-AS-2021-10014015-2_1  | 1619-010        | FY-2021              | February               | 2021              | 3091.00                   |
    | 1619-AS-2021-10014015-2_1  | 1619-010        | FY-2021              | December               | 2020              | 3561.00                   |
    | 1619-AS-2021-10014015-2_1  | 1619-010        | FY-2021              | October                | 2020              | 3758.00                   |
    | 1619-AS-2021-10014915-3_8  | 1619-005        | FY-2021              | September              | 2020              | 5735.00                   |
    | 1619-AS-2021-10014915-3_8  | 1619-006        | FY-2021              | March                  | 2021              | 5763.00                   |
    | 1619-AS-2021-10014915-3_8  | 1619-006        | FY-2021              | February               | 2021              | 2745.00                   |
    | 1619-AS-2021-10014915-3_8  | 1619-007        | FY-2021              | May                    | 2021              | 2423.00                   |
    | 1619-AS-2021-10014915-3_8  | 1619-007        | FY-2021              | October                | 2020              | 3849.00                   |
    | 1619-AS-2021-10015815-2_1  | 1619-010        | FY-2021              | November               | 2020              | 5735.00                   |
    | 1619-AS-2021-10015815-2_1  | 1619-011        | FY-2021              | June                   | 2021              | 5763.00                   |
    | 1619-AS-2021-10015815-2_1  | 1619-011        | FY-2021              | August                 | 2020              | 2745.00                   |


    # Change the date 
    Given the override date is '22/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Tidy Up
    Then   the override date is reset

 

@AcceptanceTest @Manual
Scenario: L016 Import latest of different versions of FAs (1619/NFF) - subsequent imported versions parked

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014016'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014916'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014816'
    And   there is no Funding Allocation data in CRM for UKPRN '10014016'
    And   there is no Funding Allocation data in CRM for UKPRN '10014916'
    And   there is no Funding Allocation data in CRM for UKPRN '10014816'
    And   there is no Contract, Task or Workflow data for UKPRN '10014016'
    And   there is no Contract, Task or Workflow data for UKPRN '10014916'
    And   there is no Contract, Task or Workflow data for UKPRN '10014816'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014016' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014916' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014816' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |
    | EDSK            | AY2021        | 16-19ED2021  | Contract for Services (ITP)             |
   #| EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)     |
   #| EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |
#   | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (NMSS)    |

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014016' 
    And there is no Organisation data for UKPRN '10014916' 
    And there is no Organisation data for UKPRN '10014816' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014016 Co Ltd' with UKPRN '10014016' and OrgId 'ORG0014016' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014916 Co Ltd' with UKPRN '10014916' and OrgId 'ORG0014916' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014816 Co Ltd' with UKPRN '10014816' and OrgId 'ORG0014816' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014016 | 114016 | 10014016 Co Ltd | 0              | Active                | Yes           | AA014016      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014916 | 114916 | 10014916 Co Ltd | 0              | Active                | Yes           | AA014916      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014816 | 114816 | 10014816 Co Ltd | 0              | Active                | Yes           | AA014816      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014016 |
    | 10014916 |
    | 10014816 |

    # Populate the stub

    # Initial versions

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014916 | 1619-AS-2021-Contract-LocalAuthority-10014916-1_1     | 1_1            | 1619                        | AS-2021            | 4729.00           |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014916-1_1  | 1_1                    | 1619-AS-2021-Contract-LocalAuthority-10014916-1_1     | 10014916      | Local        | 10LAU           | 4729.00                   |
     
    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014916-1_1  | 1619-001        | 4729.00          | Payment         |
    | 1619-AS-2021-10014916-1_1  | 1619-002        | 0.00          | Payment         |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014916-1_1  | 1619-001        | FY-2021              | September              | 2020              | 4729.00                   |
    | 1619-AS-2021-10014916-1_1  | 1619-002        | FY-2021              | September              | 2020              | 0.00                   |
 

    # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014916 | NFF-AS-2021-Contract-LocalAuthority-10014916-0_6      | 0_6            | NFF                         | AS-2021            | 35767.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2021-10014916-0_6   | 0_6                    | NFF-AS-2021-Contract-LocalAuthority-10014916-0_6      | 10014916      | Local        | 10LAU           | 35767.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2021-10014916-0_6   | NFF-001         | 15509.00         | Payment         |
    | NFF-AS-2021-10014916-0_6   | NFF-002         | 20258.00         | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2021-10014916-0_6   | NFF-001         | FY-2021              | August                 | 2020              | 1637.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-001         | FY-2021              | September              | 2020              | 4089.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-001         | FY-2021              | November               | 2020              | 914.00                    |
    | NFF-AS-2021-10014916-0_6   | NFF-001         | FY-2021              | December               | 2020              | 2849.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-001         | FY-2021              | February               | 2021              | 3194.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-001         | FY-2021              | March                  | 2021              | 2790.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-002         | FY-2021              | September              | 2020              | 1973.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-002         | FY-2021              | October                | 2020              | 3021.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-002         | FY-2021              | November               | 2020              | 2054.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-002         | FY-2021              | December               | 2020              | 846.00                    |
    | NFF-AS-2021-10014916-0_6   | NFF-002         | FY-2021              | January                | 2021              | 1748.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-002         | FY-2021              | February               | 2021              | 4308.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-002         | FY-2021              | March                  | 2021              | 3553.00                   |
    | NFF-AS-2021-10014916-0_6   | NFF-002         | FY-2021              | April                  | 2021              | 2755.00                   |


    # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014816 | 1619-AS-2021-Contract-Provider-10014816-1_4     | 1_4            | 1619                        | AS-2021            | 4739.00           |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014816-1_4  | 1_4                    | 1619-AS-2021-Contract-Provider-10014816-1_4     | 10014816      | Furth        | 02IPP           | 4739.00                   |

    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014816-1_4  | 1619-001        | 4739.00         | Payment          |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014816-1_4  | 1619-001        | FY-2021              | September              | 2020              | 4739.00                   |

    
   # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014816 | NLG-AS-2021-Contract-Provider-10014816-1_4      | 1_4            | NLG                         | AS-2021            | 5004.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10014816-1_4   | 1_4                    | NLG-AS-2021-Contract-Provider-10014816-1_4      | 10014816      | Furth        | 02IPP           | 5004.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10014816-1_4   | NLG-001         | 5004.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10014816-1_4   | NLG-001         | FY-2021              | September              | 2020              | 1004.00                   |
    | NLG-AS-2021-10014816-1_4   | NLG-001         | FY-2021              | March              | 2021              | 4000.00                   |

    
   # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014016 | DADA-AS-2021-Contract-Provider-10014016-1_1      | 1_1            | DADA                         | AS-2021            | 4000.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014016-1_1   | 1_1                    | DADA-AS-2021-Contract-Provider-10014016-1_1      | 10014016      | Furth        | 05ADC           | 4000.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014016-1_1   | DADA-001         | 4000.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014016-1_1   | DADA-001         | FY-2021              | March              | 2021              | 4000.00                   |

    
   # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014016 | DADA-AS-2021-Contract-Provider-10014016-2_0      | 2_0            | DADA                         | AS-2021            | 6004.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014016-2_0   | 2_0                    | DADA-AS-2021-Contract-Provider-10014016-2_0      | 10014016      | Furth        | 05ADC           | 6004.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014016-2_0   | DADA-001         | 6004.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014016-2_0   | DADA-001         | FY-2021              | September              | 2020              | 2004.00                   |
    | DADA-AS-2021-10014016-2_0   | DADA-001         | FY-2021              | March              | 2021              | 4000.00                   |

  
    Then wait '10' seconds


    # Change the date 
    Given the override date is '15/06/2021'
    
    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    Then wait '10' seconds

    #Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG            | AY2021        | NLG2021  | Non-learning Grant      | Non_LG                   |

     #Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [Non_LG]         |
    
    # #Check the state of a Release Group (J129)  (The count and value are unchanged)
    #Then  Release Group '[Non_LG]' has the following characteristics
    #| ReleaseStatus     | AllocationCount | AllocationValue |
    #| Released          | 1               | 5004.00         |


    #Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      | CoFG_LA                   |

     #Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CoFG_LA]         |
    
    # #Check the state of a Release Group (J129)  (The count and value are unchanged)
    #Then  Release Group '[CoFG_LA]' has the following characteristics
    #| ReleaseStatus     | AllocationCount | AllocationValue |
    #| Released          | 2               | 40496.00         |

    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2021        | DADA2021  | Contract for Services      | DaDA                   |

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [DaDA]         |
    
    ## Check the state of a Release Group (J129)  (The count and value are unchanged)
    #Then  Release Group '[DaDA]' has the following characteristics
    #| ReleaseStatus     | AllocationCount | AllocationValue |
    #| Released          | 1               | 6004.00         |

 
 
     # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Contract for Services (ITP)      | CoS_ITP                   |

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CoS_ITP]         |
    
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[CoS_ITP]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 4739.00         |
#
#    # Check PaaS FundingAllocation.ReleaseGroup (J132)
#    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'Released'
#
#
#    # Invoke HOLD process (J130)
#    When  User 'FCS8 TEST' opts to put the following Funding Allocations on hold
#    | FundingId                                               | HoldReason                     | Comments                    |
#    | NMSS-AS-2021-Contract-Provider-10014916-1_4             | Held by Allocations Team       | ?                           |
#
#    # Change the date 
#    Given the override date is '15/06/2020'
#
#
#    When  I retrieve the latest contract details from CRM for provider '10014016' for FundingType 'DADA' and period '2021'
#
#
#
#    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
#   #When  a request is initiated in CRM to delete the following contracts
#    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | 10014016 | [ContractNo]   | 1                     | 0                  |
#
#
#    Then wait '10' seconds
#
#    When  I retrieve the latest contract details from CRM for provider '10014916' for FundingType 'EDSK' and period '2021'
#
#
#      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#
#    # Contract Withdrawal
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS2 Test'
#
#
    Then wait '100' seconds


    When  I retrieve the latest contract details from CRM for provider '10014816' for FundingType 'NLG' and period '2021'


      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

#
#
#
#    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
#    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
#    | FundingId                                               | 
#    | NLG-AS-2021-Contract-Provider-10014816-1_4              | 
#    | 1619-AS-2021-Contract-Provider-10014916-1_4             | 
#    | DADA-AS-2021-Contract-Provider-10014016-1_1             | 
#
    Then wait '10' seconds

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    When  I retrieve the latest contract details from CRM for provider '10014816' for FundingType 'EDSK' and period '2021'


      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    Then wait '10' seconds

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

#    # Execute a NON-FINANCIAL amendment on '[ContractNo]'
#
#    # Change the date
#    Given the override date is '16/06/2020'
#
#    # Issue a non-financial VARIATION amendment on v1 to create v2.
#    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment



    Then wait '10' seconds


    When  I retrieve the latest contract details from CRM for provider '10014916' for FundingType 'EDSK' and period '2021'


      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'


    Then wait '10' seconds


    When  I retrieve the latest contract details from CRM for provider '10014016' for FundingType 'DADA' and period '2021'


      # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given  the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

#    # Change the date 
#    Given the override date is '16/06/2020'
#
#    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocations together
#    |  FundingId                                              |
#    |  NLG-AS-2021-Contract-Provider-10014016-1_3           |
#
#
    Then wait '10' seconds


    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    Given   there is no data in the CFS stub
    #And   there is no data in the Funding Allocation PaaS tables

#    # Populate the stub
#
#    # Initial versions
#
    # Change the date 
    And the override date is '17/06/2021'

   # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014016 | DADA-AS-2021-Contract-Provider-10014016-3_5      | 3_5            | DADA                         | AS-2021            | 6004.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014016-3_5   | 3_5                    | DADA-AS-2021-Contract-Provider-10014016-3_5      | 10014016      | Furth        | 05ADC           | 6004.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014016-3_5   | DADA-001         | 6004.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014016-3_5   | DADA-001         | FY-2021              | September              | 2020              | 2004.00                   |
    | DADA-AS-2021-10014016-3_5   | DADA-001         | FY-2021              | March              | 2021              | 4000.00                   |

   # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014016 | DADA-AS-2021-Contract-Provider-10014016-4_1      | 4_1            | DADA                         | AS-2021            | 6004.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | DADA-AS-2021-10014016-4_1   | 4_1                    | DADA-AS-2021-Contract-Provider-10014016-4_1      | 10014016      | Furth        | 05ADC           | 6004.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | DADA-AS-2021-10014016-4_1   | DADA-001         | 6004.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | DADA-AS-2021-10014016-4_1   | DADA-001         | FY-2021              | November              | 2020              | 2004.00                   |
    | DADA-AS-2021-10014016-4_1   | DADA-001         | FY-2021              | April              | 2021              | 4000.00                   |

#    
#   # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014816 | NLG-AS-2021-Contract-Provider-10014816-2_4      | 2_4            | NLG                         | AS-2021            | 5004.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NLG-AS-2021-10014816-2_4   | 2_4                    | NLG-AS-2021-Contract-Provider-10014816-2_4      | 10014816      | Furth        | 01GFE           | 5004.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NLG-AS-2021-10014816-2_4   | NLG-001         | 5004.00          | Payment         |
#    #| NLG-AS-2021-10014816-2_4   | NLG-002         | 1000.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NLG-AS-2021-10014816-2_4   | NLG-001         | FY-2021              | September              | 2020              | 1000.00                   |
#    | NLG-AS-2021-10014816-2_4   | NLG-001         | FY-2021              | March              | 2021              | 4004.00                   |
#    #| NLG-AS-2021-10014816-2_4   | NLG-002         | FY-2021              | September              | 2020              | 1000.00                   |
#
#  
#    
   # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014816 | NLG-AS-2021-Contract-Provider-10014816-2_1      | 2_1            | NLG                         | AS-2021            | 5004.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10014816-2_1   | 2_1                    | NLG-AS-2021-Contract-Provider-10014816-2_1      | 10014816      | Furth        | 01GFE           | 5004.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10014816-2_1   | NLG-001         | 5004.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10014816-2_1   | NLG-001         | FY-2021              | September              | 2020              | 1004.00                   |
    | NLG-AS-2021-10014816-2_1   | NLG-001         | FY-2021              | March              | 2021              | 4000.00                   |

          # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014816 | 1619-AS-2021-Contract-Provider-10014816-3_0     | 3_0            | 1619                        | AS-2021            | 5739.00           |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014816-3_0  | 3_0                    | 1619-AS-2021-Contract-Provider-10014816-3_0     | 10014816      | Furth        | 02IPP           | 5739.00                   |

    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014816-3_0  | 1619-001        | 4739.00         | Payment          |
    | 1619-AS-2021-10014816-3_0  | 1619-002        | 1000.00         | Other          |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014816-3_0  | 1619-001        | FY-2021              | September              | 2020              | 4739.00                   |
    | 1619-AS-2021-10014816-3_0  | 1619-002        | FY-2021              | December              | 2020              | 1000.00                   |

#    # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014916 | 1619-AS-2021-Contract-LocalAuthority-10014916-2_1     | 2_1            | 1619                        | AS-2021            | 5729.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014916-2_1  | 2_1                    | 1619-AS-2021-Contract-LocalAuthority-10014916-2_1     | 10014916      | Local        | 10LAU           | 5729.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014916-2_1  | 1619-001        | 5729.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014916-2_1  | 1619-001        | FY-2021              | September              | 2020              | 5729.00                   |
#
#
    # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014916 | 1619-AS-2021-Contract-LocalAuthority-10014916-2_3     | 2_3            | 1619                        | AS-2021            | 4729.00           |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014916-2_3  | 2_3                    | 1619-AS-2021-Contract-LocalAuthority-10014916-2_3     | 10014916      | Local        | 10LAU           | 4729.00                   |
     
    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014916-2_3  | 1619-001        | 4729.00          | Payment         |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014916-2_3  | 1619-001        | FY-2021              | September              | 2020              | 4729.00                   |
# 
#    # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014916 | 1619-AS-2021-Contract-Provider-10014916-2_2     | 2_2            | 1619                        | AS-2021            | 473.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014916-2_2  | 2_2                    | 1619-AS-2021-Contract-Provider-10014916-2_2     | 10014916      | Furth       | 02IPP           | 473.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014916-2_2  | 1619-001        | 473.00         | Payment          |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014916-2_2  | 1619-001        | FY-2021              | November              | 2020              | 473.00                   |
# 
#    # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014016 | 1619-AS-2021-Contract-LocalAuthoritySsf-10014016-2_1     | 2_1            | 1619                        | AS-2021            | 4738.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2021-10014816-2_1  | 2_1                    | 1619-AS-2021-Contract-LocalAuthoritySsf-10014016-2_1     | 10014816      | Schoo        | 08SSF           | 4738.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2021-10014816-2_1  | 1619-001        | 4738.00         | Payment          |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2021-10014816-2_1  | 1619-001        | FY-2021              | September              | 2020              | 4738.00                   |
# 
#   # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014016 | NFF-AS-2021-Contract-LocalAuthoritySsf-10014016-1_1      | 1_1            | NFF                         | AS-2021            | 4004.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NFF-AS-2021-10014816-1_1   | 1_1                    | NFF-AS-2021-Contract-LocalAuthoritySsf-10014016-1_1      | 10014816      | Schoo        | 08SSF           | 4004.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NFF-AS-2021-10014816-1_1   | NFF-002         | 4004.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NFF-AS-2021-10014816-1_1   | NFF-002         | FY-2021              | September              | 2020              | 4004.00                   |
#
#
#
#   # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014916 | NMSS-AS-2021-Contract-Provider-10014916-2_0      | 2_0            | NMSS                         | AY-2021            | 4004.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NMSS-AS-2021-10014916-2_0   | 2_0                    | NMSS-AS-2021-Contract-Provider-10014916-2_0      | 10014916      | Schoo        | 21NMS           | 4004.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NMSS-AS-2021-10014916-2_0   | NMSS-001         | 4004.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NMSS-AS-2021-10014916-2_0   | NMSS-001         | FY-2021              | September              | 2020              | 4004.00                   |
##
#
    # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014916 | NFF-AS-2021-Contract-LocalAuthority-10014916-1_3      | 1_3            | NFF                         | AS-2021            | 35768.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2021-10014916-1_3   | 1_3                    | NFF-AS-2021-Contract-LocalAuthority-10014916-1_3      | 10014916      | Local        | 10LAU           | 35768.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2021-10014916-1_3   | NFF-001         | 15509.00         | Payment         |
    | NFF-AS-2021-10014916-1_3   | NFF-002         | 20258.00         | Payment         |
    | NFF-AS-2021-10014916-1_3   | NFF-003         | 1.00             | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2021-10014916-1_3   | NFF-001         | FY-2021              | August                 | 2020              | 1637.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-001         | FY-2021              | September              | 2020              | 4089.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-001         | FY-2021              | November               | 2020              | 914.00                    |
    | NFF-AS-2021-10014916-1_3   | NFF-001         | FY-2021              | December               | 2020              | 2849.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-001         | FY-2021              | February               | 2021              | 3194.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-001         | FY-2021              | March                  | 2021              | 2790.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-002         | FY-2021              | September              | 2020              | 1973.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-002         | FY-2021              | October                | 2020              | 3021.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-002         | FY-2021              | November               | 2020              | 2054.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-002         | FY-2021              | December               | 2020              | 846.00                    |
    | NFF-AS-2021-10014916-1_3   | NFF-002         | FY-2021              | January                | 2021              | 1748.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-002         | FY-2021              | February               | 2021              | 4308.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-002         | FY-2021              | March                  | 2021              | 3553.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-002         | FY-2021              | April                  | 2021              | 2755.00                   |
    | NFF-AS-2021-10014916-1_3   | NFF-003         | FY-2021              | April                  | 2021              | 1.00                      |
#
#    Then wait '10' seconds
#
#
#    # Change the date 
#    And the override date is '18/06/2021'
    
    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM
    
    Then wait '10' seconds
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |
#
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CofG_LA]         |
#    
#    # Check the state of a Release Group (J129)  (The count and value are unchanged)
#    Then  Release Group '[CofG_LA]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 2               | 8742.00         |
#
#    # Check PaaS FundingAllocation.ReleaseGroup (J132)
#    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'
#
#    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
#    Given   there is no data in the CFS stub
#    #And   there is no data in the Funding Allocation PaaS tables
#
#    # Populate the stub
#
#    # Initial versions
#
#    # Change the date 
#    And the override date is '19/06/2021'
#
#   # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014016 | DADA-AS-2021-Contract-Provider-10014016-4_3      | 4_3            | DADA                         | AS-2021            | 6004.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2021-10014016-4_3   | 4_3                    | DADA-AS-2021-Contract-Provider-10014016-4_3      | 10014016      | Furth        | 05ADC           | 6004.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2021-10014016-4_3   | DADA-001         | 6004.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2021-10014016-4_3   | DADA-001         | FY-2021              | September              | 2020              | 2004.00                   |
#    | DADA-AS-2021-10014016-4_3   | DADA-001         | FY-2021              | March              | 2021              | 4000.00                   |
#
# 
#    # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014916 | NLG-AS-2021-Contract-Provider-10014916-3_0     | 3_0            | NLG                        | AS-2021            | 739.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NLG-AS-2021-10014916-3_0  | 3_0                    | NLG-AS-2021-Contract-Provider-10014916-3_0     | 10014916      | Furth        | 04AHC           | 739.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NLG-AS-2021-10014916-3_0  | NLG-001        | 739.00          | Payment         |
#     
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NLG-AS-2021-10014916-3_0  | NLG-001        | FY-2021              | September              | 2020              | 739.00                   |
#
# 
#    # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014816 | NFF-AS-2021-Contract-LocalAuthority-10014816-2_1      | 2_1            | NFF                         | AS-2021            | 4004.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NFF-AS-2021-10014816-2_1   | 2_1                    | NFF-AS-2021-Contract-LocalAuthority-10014816-2_1      | 10014816      | Local        | 10LAU           | 4004.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NFF-AS-2021-10014816-2_1   | NFF-002         | 4004.00         | Payment          |
#
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NFF-AS-2021-10014816-2_1   | NFF-002         | FY-2021              | September              | 2020              | 4004.00                   |
#
#
#    # Funding Allocation TWO (FA2/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014016 | NFF-AS-2021-Contract-LocalAuthority-10014016-1_1      | 1_1            | NFF                         | AS-2021            | 4014.00           |
#
#    # Provider Funding Allocation (FA2/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NFF-AS-2021-10014016-1_1   | 1_1                    | NFF-AS-2021-Contract-LocalAuthority-10014016-1_1      | 10014016      | Local        | 10LAU           | 4014.00                   |
#
#    # Funding Allocation Line (aka Deliverable) (FA2/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NFF-AS-2021-10014016-1_1   | NFF-002         | 4014.00         | Payment         |
#     
#    # Funding Allocation Profile Period (FA2/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NFF-AS-2021-10014016-1_1   | NFF-002         | FY-2021              | December              | 2020              | 4014.00                   |
#
#
#    # Change the date 
#    Given the override date is '20/06/2021'
#    
#    # Read stub and process into CRM
#    When  the feed-reading process is started and the CFS stub data is processed into CRM
#
#    # Capture the Release Group parameter value (J127)
#    Given the Release Groups for the following Contracting Profiles have been saved
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
#    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |
#
    # # Release Funding Allocations from Contract Control (J128)
    #When  a request is triggered to release the following Release Group
    #| ReleaseGroup      |
    #| [CofG_LA]         |
    #
    ## Check the state of a Release Group (J129)  (The count and value are unchanged)
    #Then  Release Group '[CofG_LA]' has the following characteristics
    #| ReleaseStatus     | AllocationCount | AllocationValue |
    #| Released          | 2               | 8753.00         |

#    # Check PaaS FundingAllocation.ReleaseGroup (J132)
#    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'
#

   # Tidy Up
    Then   the override date is reset



@AcceptanceTest @Manual
Scenario: L017 Amalgamation of FAs from L013-L016

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014016'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014015'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014915'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014815'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10015015'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10015915'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10015815'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014014'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014013'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014017'
    And   there is no Funding Allocation data in CRM for UKPRN '10014016'
    And   there is no Funding Allocation data in CRM for UKPRN '10014015'
    And   there is no Funding Allocation data in CRM for UKPRN '10014915'
    And   there is no Funding Allocation data in CRM for UKPRN '10014815'
    And   there is no Funding Allocation data in CRM for UKPRN '10015015'
    And   there is no Funding Allocation data in CRM for UKPRN '10015915'
    And   there is no Funding Allocation data in CRM for UKPRN '10015815'
    And   there is no Funding Allocation data in CRM for UKPRN '10014014'
    And   there is no Funding Allocation data in CRM for UKPRN '10014013'
    And   there is no Funding Allocation data in CRM for UKPRN '10014017'
    And   there is no Contract, Task or Workflow data for UKPRN '10014016'
    And   there is no Contract, Task or Workflow data for UKPRN '10014015'
    And   there is no Contract, Task or Workflow data for UKPRN '10014915'
    And   there is no Contract, Task or Workflow data for UKPRN '10014815'
    And   there is no Contract, Task or Workflow data for UKPRN '10015015'
    And   there is no Contract, Task or Workflow data for UKPRN '10015915'
    And   there is no Contract, Task or Workflow data for UKPRN '10015815'
    And   there is no Contract, Task or Workflow data for UKPRN '10014014'
    And   there is no Contract, Task or Workflow data for UKPRN '10014013'
    And   there is no Contract, Task or Workflow data for UKPRN '10014017'


    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014016' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014015' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014915' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014815' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10015015' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10015915' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10015815' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014014' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014013' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10014017' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (NMSS)    |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (HEI)     |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)     |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014016' 
    And there is no Organisation data for UKPRN '10014015' 
    And there is no Organisation data for UKPRN '10014915'  
    And there is no Organisation data for UKPRN '10014815'  
    And there is no Organisation data for UKPRN '10015015'  
    And there is no Organisation data for UKPRN '10015915'  
    And there is no Organisation data for UKPRN '10015815'
    And there is no Organisation data for UKPRN '10014014' 
    And there is no Organisation data for UKPRN '10014013' 
    And there is no Organisation data for UKPRN '10014017' 


    And   caseload advisor 'FCS2 Test' is assigned to provider '10014016 Co Ltd' with UKPRN '10014016' and OrgId 'ORG0014016' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014015 Co Ltd' with UKPRN '10014015' and OrgId 'ORG0014015' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014915 Co Ltd' with UKPRN '10014915' and OrgId 'ORG0014915' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014815 Co Ltd' with UKPRN '10014815' and OrgId 'ORG0014815' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10015015 Co Ltd' with UKPRN '10015015' and OrgId 'ORG0015015' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10015915 Co Ltd' with UKPRN '10015915' and OrgId 'ORG0015915' and has 'FCS1 Test' as a manager
    And   caseload advisor 'FCS2 Test' is assigned to provider '10015815 Co Ltd' with UKPRN '10015815' and OrgId 'ORG0015815' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014014 Co Ltd' with UKPRN '10014014' and OrgId 'ORG0014014' and has 'FCS1 Test' as a manager
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014013 Co Ltd' with UKPRN '10014013' and OrgId 'ORG0014013' and has 'FCS1 Test' as a manager
    And   caseload advisor 'FCS2 Test' is assigned to provider '10014017 Co Ltd' with UKPRN '10014017' and OrgId 'ORG0014017' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014016 | 114016 | 10014016 Co Ltd | 0              | Active                | Yes           | AA014016      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014015 | 114015 | 10014015 Co Ltd | 0              | Locked Restructure    | Yes           | AA014015      | ?             | 100 Harley Street      | London                 | ?                      | ?                      | ?                      | ?                      | W1N 1AF   |
    | 10014915 | 114915 | 10014915 Co Ltd | 0              | Locked Restructure    | Yes           | AA014915      | ?             | 10 High Street         | Grantham               | ?                      | ?                      | ?                      | Lincs                  | NG31 0FF  |
    | 10014815 | 114815 | 10014815 Co Ltd | 0              | Locked Restructure    | Yes           | AA014815      | ?             | Quinton Road           | Cheylesmore            | ?                      | ?                      | Coventry               | ?                      | CV1 2WT   |
    | 10015015 | 115015 | 10015015 Co Ltd | 0              | Locked Restructure    | Yes           | AA015015      | ?             | Flat 3a                | Broughton Court        | Bitteswell Road        | Leicestershire         | ?                      | ?                      | LE17 4SH  |
    | 10015915 | 115915 | 10015915 Co Ltd | 0              | Locked Restructure    | Yes           | AA015915      | ?             | 512 Brook Street       | ?                      | ?                      | ?                      | Welshpool              | Powys                  | NG31 0FF  |
    | 10015815 | 115815 | 10015815 Co Ltd | 0              | Locked Restructure    | Yes           | AA015815      | ?             | 1 Avenue Rd            | Aston                  | Birmingham             | ?                      | ?                      | ?                      | B6 4DU    |
    | 10014014 | 114014 | 10014014 Co Ltd | 0              | Active                | Yes           | AA014014      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014013 | 114013 | 10014013 Co Ltd | 0              | Active                | Yes           | AA014013      | ?             | 87 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014017 | 114017 | 10014017 Co Ltd | 0              | Active                | Yes           | AA014017      | ?             | 87 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014016 |
    | 10014015 |
    | 10014915 |
    | 10014815 |
    | 10015015 |
    | 10015915 |
    | 10015815 |
    | 10014014 |
    | 10014013 |
    | 10014017 |





    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation (Set 1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014015 | 1619-AS-2122-Contract-Provider-10014015-1_3       | 1_3            | 1619                        | AS-2122            | 39697.00          |
    | Contracting    | 10014915 | 1619-AS-2122-Contract-Provider-10014915-2_0       | 2_0            | 1619                        | AS-2122            | 20515.00          |
    | Contracting    | 10014815 | 1619-AS-2122-Contract-Provider-10014815-4_2       | 4_2            | 1619                        | AS-2122            | 14243.00          |
    | Contracting    | 10015015 | 1619-AS-2122-Contract-Provider-10015015-4_4       | 4_4            | 1619                        | AS-2122            | 20515.00          |
    | Contracting    | 10015915 | 1619-AS-2122-Contract-Provider-10015915-2_0       | 2_0            | 1619                        | AS-2122            | 14243.00          |



    # Provider Funding Allocation (Set 1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10014015-1_3  | 1_3                    | 1619-AS-2122-Contract-Provider-10014015-1_3 | 10014015      | Furth        | 07HEP           | 39697.00                  |
    | 1619-AS-2122-10014915-2_0  | 2_0                    | 1619-AS-2122-Contract-Provider-10014915-2_0 | 10014915      | Furth        | 18ISP           | 20515.00                  |
    | 1619-AS-2122-10014815-4_2  | 4_2                    | 1619-AS-2122-Contract-Provider-10014815-4_2 | 10014815      | Furth        | 06SDC           | 14243.00                  |
    | 1619-AS-2122-10015015-4_4  | 4_4                    | 1619-AS-2122-Contract-Provider-10015015-4_4 | 10015015      | Furth        | 03SFC           | 20515.00                  |
    | 1619-AS-2122-10015915-2_0  | 2_0                    | 1619-AS-2122-Contract-Provider-10015915-2_0 | 10015915      | Furth        | 05ADC           | 14243.00                  |

    # Funding Allocation Line (aka Deliverable) (Set 1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10014015-1_3  | 1619-021        | 5735.00          | Payment         |
    | 1619-AS-2122-10014015-1_3  | 1619-013        | 8508.00          | Payment         |
    | 1619-AS-2122-10014015-1_3  | 1619-003        | 6272.00          | Payment         |
    | 1619-AS-2122-10014015-1_3  | 1619-010        | 19182.00         | Payment         |
    | 1619-AS-2122-10014915-2_0  | 1619-001        | 5735.00          | Payment         |
    | 1619-AS-2122-10014915-2_0  | 1619-006        | 8508.00          | Payment         |
    | 1619-AS-2122-10014915-2_0  | 1619-007        | 6272.00          | Payment         |
    | 1619-AS-2122-10014815-4_2  | 1619-008        | 5735.00          | Payment         |
    | 1619-AS-2122-10014815-4_2  | 1619-009        | 8508.00          | Payment         |
    | 1619-AS-2122-10015015-4_4  | 1619-020        | 5735.00          | Payment         |
    | 1619-AS-2122-10015015-4_4  | 1619-004        | 8508.00          | Payment         |
    | 1619-AS-2122-10015015-4_4  | 1619-005        | 6272.00          | Payment         |
    | 1619-AS-2122-10015915-2_0  | 1619-010        | 5735.00          | Payment         |
    | 1619-AS-2122-10015915-2_0  | 1619-011        | 8508.00          | Payment         |

    # Funding Allocation Profile Period (Set 1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10014015-1_3  | 1619-021        | FY-2122              | October                | 2021              | 5735.00                   |
    | 1619-AS-2122-10014015-1_3  | 1619-013        | FY-2122              | April                  | 2022              | 5763.00                   |
    | 1619-AS-2122-10014015-1_3  | 1619-013        | FY-2122              | January                | 2022              | 2745.00                   |
    | 1619-AS-2122-10014015-1_3  | 1619-003        | FY-2122              | July                   | 2022              | 2423.00                   |
    | 1619-AS-2122-10014015-1_3  | 1619-003        | FY-2122              | October                | 2021              | 3849.00                   |
    | 1619-AS-2122-10014015-1_3  | 1619-010        | FY-2122              | June                   | 2022              | 4271.00                   |
    | 1619-AS-2122-10014015-1_3  | 1619-010        | FY-2122              | April                  | 2022              | 4501.00                   |
    | 1619-AS-2122-10014015-1_3  | 1619-010        | FY-2122              | February               | 2022              | 3091.00                   |
    | 1619-AS-2122-10014015-1_3  | 1619-010        | FY-2122              | December               | 2021              | 3561.00                   |
    | 1619-AS-2122-10014015-1_3  | 1619-010        | FY-2122              | October                | 2021              | 3758.00                   |
    | 1619-AS-2122-10014915-2_0  | 1619-001        | FY-2122              | September              | 2021              | 5735.00                   |
    | 1619-AS-2122-10014915-2_0  | 1619-006        | FY-2122              | March                  | 2022              | 5763.00                   |
    | 1619-AS-2122-10014915-2_0  | 1619-006        | FY-2122              | February               | 2022              | 2745.00                   |
    | 1619-AS-2122-10014915-2_0  | 1619-007        | FY-2122              | May                    | 2022              | 2423.00                   |
    | 1619-AS-2122-10014915-2_0  | 1619-007        | FY-2122              | October                | 2021              | 3849.00                   |
    | 1619-AS-2122-10014815-4_2  | 1619-008        | FY-2122              | September              | 2021              | 5735.00                   |
    | 1619-AS-2122-10014815-4_2  | 1619-009        | FY-2122              | March                  | 2022              | 5763.00                   |
    | 1619-AS-2122-10014815-4_2  | 1619-009        | FY-2122              | February               | 2022              | 2745.00                   |
    | 1619-AS-2122-10015015-4_4  | 1619-020        | FY-2122              | October                | 2021              | 5735.00                   |
    | 1619-AS-2122-10015015-4_4  | 1619-004        | FY-2122              | April                  | 2022              | 5763.00                   |
    | 1619-AS-2122-10015015-4_4  | 1619-004        | FY-2122              | January                | 2022              | 2745.00                   |
    | 1619-AS-2122-10015015-4_4  | 1619-005        | FY-2122              | July                   | 2022              | 2423.00                   |
    | 1619-AS-2122-10015015-4_4  | 1619-005        | FY-2122              | October                | 2021              | 3849.00                   |
    | 1619-AS-2122-10015915-2_0  | 1619-010        | FY-2122              | November               | 2021              | 5735.00                   |
    | 1619-AS-2122-10015915-2_0  | 1619-011        | FY-2122              | June                   | 2022              | 5763.00                   |
    | 1619-AS-2122-10015915-2_0  | 1619-011        | FY-2122              | August                 | 2021              | 2745.00                   |

    # Funding Allocation (Set 3)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10015815 | 1619-AS-2122-Contract-Provider-10015815-2_1       | 2_1            | 1619                        | AS-2122            | 14243.00          |



    # Provider Funding Allocation (Set 3)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10015815-2_1  | 2_1                    | 1619-AS-2122-Contract-Provider-10015815-2_1 | 10015815      | Furth        | 05ADC           | 14243.00                  |

    # Funding Allocation Line (aka Deliverable) (Set 3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10015815-2_1  | 1619-010        | 5735.00          | Payment         |
    | 1619-AS-2122-10015815-2_1  | 1619-011        | 8508.00          | Payment         |

    # Funding Allocation Profile Period (Set 3)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10015815-2_1  | 1619-010        | FY-2122              | November               | 2021              | 5735.00                   |
    | 1619-AS-2122-10015815-2_1  | 1619-011        | FY-2122              | June                   | 2022              | 5763.00                   |
    | 1619-AS-2122-10015815-2_1  | 1619-011        | FY-2122              | August                 | 2021              | 2745.00                   |

#    # Funding Allocation ONE (FA1/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014016 | 1619-AS-2122-Contract-LocalAuthority-10014016-1_1     | 1_1            | 1619                        | AS-2122            | 4739.00           |
#
#    # Provider Funding Allocation (FA1/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | 1619-AS-2122-10014016-1_1  | 1_1                    | 1619-AS-2122-Contract-LocalAuthority-10014016-1_1     | 10014016      | Local        | 10LAU           | 4739.00                   |
#     
#    # Funding Allocation Line (aka Deliverable) (FA1/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | 1619-AS-2122-10014016-1_1  | 1619-001        | 4739.00          | Payment         |
#
#    # Funding Allocation Profile Period (FA1/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | 1619-AS-2122-10014016-1_1  | 1619-001        | FY-2122              | September              | 2021              | 4739.00                   |
 

    # Funding Allocation TWO (FA2/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014016 | NFF-AS-2122-Contract-LocalAuthority-10014016-1_0      | 1_0            | NFF                         | AS-2122            | 4014.00           |

    # Provider Funding Allocation (FA2/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10014016-1_0   | 1_0                    | NFF-AS-2122-Contract-LocalAuthority-10014016-1_0      | 10014016      | Local        | 10LAU           | 4014.00                   |

    # Funding Allocation Line (aka Deliverable) (FA2/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10014016-1_0   | NFF-002         | 4014.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10014016-1_0   | NFF-002         | FY-2122              | September              | 2021              | 4014.00                   |

    # Funding Allocation ONE (FA1/V1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014016 | 1619-AS-2122-Contract-LocalAuthority-10014016-2_0     | 2_0            | 1619                        | AS-2122            | 4739.00           |

    # Provider Funding Allocation (FA1/V1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10014016-2_0  | 2_0                    | 1619-AS-2122-Contract-LocalAuthority-10014016-2_0     | 10014016      | Local        | 10LAU           | 4739.00                   |

    # Funding Allocation Line (aka Deliverable) (FA1/V1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10014016-2_0  | 1619-002        | 4739.00         | Payment          |

    # Funding Allocation Profile Period (FA1/V1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10014016-2_0  | 1619-002        | FY-2122              | September              | 2021              | 4739.00                   |

        # Funding Allocation ONE (FA1/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014016 | 1619-AS-2122-Contract-LocalAuthoritySsf-10014016-2_4     | 2_4            | 1619                        | AS-2122            | 38639.00          |

    # Provider Funding Allocation (FA1/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10014014-1_6  | 1_6                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014016-2_4     | 10014014      | Schoo       | 08SSF           | 38639.00                  |

    # Funding Allocation Line (aka Deliverable) (FA1/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10014014-1_6  | 1619-005        | 15755.00         | Payment         |
    | 1619-AS-2122-10014014-1_6  | 1619-002        | 12884.00         | Payment         |
    | 1619-AS-2122-10014014-1_6  | 1619-024        | 10000.00         | Payment         |

    # Funding Allocation Profile Period (FA1/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10014014-1_6  | 1619-005        | FY-2122              | September              | 2021              | 4739.00                   |
    | 1619-AS-2122-10014014-1_6  | 1619-005        | FY-2122              | January                | 2022              | 4968.00                   |
    | 1619-AS-2122-10014014-1_6  | 1619-005        | FY-2122              | February               | 2022              | 3558.00                   |
    | 1619-AS-2122-10014014-1_6  | 1619-005        | FY-2122              | June                   | 2022              | 2490.00                   |
    #
    | 1619-AS-2122-10014014-1_6  | 1619-002        | FY-2122              | September              | 2021              | 2302.00                   |
    | 1619-AS-2122-10014014-1_6  | 1619-002        | FY-2122              | January                | 2022              | 2943.00                   |
    | 1619-AS-2122-10014014-1_6  | 1619-002        | FY-2122              | February               | 2022              | 4370.00                   |
    | 1619-AS-2122-10014014-1_6  | 1619-002        | FY-2122              | March                  | 2022              | 3269.00                   |
    #
    | 1619-AS-2122-10014014-1_6  | 1619-024        | FY-2122              | September              | 2021              | 10000.00                   |


    # Funding Allocation TWO (FA2/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014016 | NFF-AS-2122-Contract-LocalAuthoritySsf-10014016-2_9      | 2_9            | NFF                         | AS-2122            | 10115.00          |

    # Provider Funding Allocation (FA2/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10014014-2_9   | 2_9                    | NFF-AS-2122-Contract-LocalAuthoritySsf-10014016-2_9      | 10014014      | Schoo        | 08SSF           | 10115.00                  |

    # Funding Allocation Line (aka Deliverable) (FA2/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10014014-2_9   | NFF-001        | 1000.00         | Payment         |
    | NFF-AS-2122-10014014-2_9   | NFF-002        | 2002.00         | Payment         |
    | NFF-AS-2122-10014014-2_9   | NFF-003        | 3013.00         | Payment         |
    | NFF-AS-2122-10014014-2_9   | NFF-004        | 4100.00         | Payment         |
    #| NFF-AS-2122-10014014-2_9   | NFF-006        | 2807.00         | Payment         |
    #| NFF-AS-2122-10014014-2_9   | NFF-007        | 4543.00         | Payment         |
    #| NFF-AS-2122-10014014-2_9   | NFF-008        | 4944.00         | Payment         |

    # Funding Allocation Profile Period (FA2/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10014014-2_9   | NFF-001        | FY-2122              | August                 | 2021              | 1000.00                   |
    | NFF-AS-2122-10014014-2_9   | NFF-001        | FY-2122              | January                | 2022              | 2002.00                   |
    | NFF-AS-2122-10014014-2_9   | NFF-003        | FY-2122              | May                    | 2022              | 3013.00                   |
    | NFF-AS-2122-10014014-2_9   | NFF-004        | FY-2122              | September              | 2021              | 4100.00                   |
    #| NFF-AS-2122-10014014-2_9   | NFF-006        | FY-2122              | October                | 2021              | 2807.00                   |
    #| NFF-AS-2122-10014014-2_9   | NFF-007        | FY-2122              | November               | 2021              | 4543.00                   |
    #| NFF-AS-2122-10014014-2_9   | NFF-008        | FY-2122              | March                  | 2022              | 4944.00                   |



 
#    # Funding Allocation (FA4/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014013 | DADA-AS-2122-Contract-Provider-10014013-1_7       | 1_7            | DADA                        | AY-2122            | 12000.00          |
#
#    # Provider Funding Allocation (FA4/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | DADA-AS-2122-10014013-1_7  | 1_7                    | DADA-AS-2122-Contract-Provider-10014013-1_7 | 10014013      | Furth        | 06SDC           | 12000.00                  |
#
#    # Funding Allocation Line (aka Deliverable) (FA4/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | DADA-AS-2122-10014013-1_7  | DADA-001        | 12000.00         | Payment         |
#
#    # Funding Allocation Profile Period (FA4/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | DADA-AS-2122-10014013-1_7  | DADA-001        | AY-2122              | October                | 2021              | 12000.00                  |
#
#
#
#    # Funding Allocation (FA5/V1)
#    And   the following Funding Allocation data is in the CFS stub
#    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
#    | Contracting    | 10014013 | NLG-AY-2122-Contract-Provider-10014013-1_4        | 1_4            | NLG                         | AS-2122            | 11678.00          |
#
#    # Provider Funding Allocation  (FA5/V1)
#    And   the following Provider Funding Agreement data is present in the CFS stub
#    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
#    | NLG-AY-2122-10014013-1_4   | 1_4                    | NLG-AY-2122-Contract-Provider-10014013-1_4  | 10014013      | Furth        | 06SDC           | 11678.00                  |
#
#    # Funding Allocation Line (aka Deliverable)  (FA5/V1)
#    And   the following Funding Allocation Line data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
#    | NLG-AY-2122-10014013-1_4   | NLG-001         | 11687.00         | Payment         |
#
#    # Funding Allocation Profile Period  (FA5/V1)
#    And   the following Funding Allocation Profile Period data is present in the CFS stub
#    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
#    | NLG-AY-2122-10014013-1_4   | NLG-001         | FY-2122              | July                   | 2022              | 2935.00                   |
#    | NLG-AY-2122-10014013-1_4   | NLG-001         | FY-2122              | March                  | 2022              | 3678.00                   |
#    | NLG-AY-2122-10014013-1_4   | NLG-001         | FY-2122              | November               | 2021              | 2096.00                   |
#    | NLG-AY-2122-10014013-1_4   | NLG-001         | FY-2122              | August                 | 2021              | 2978.00                   |

    # Funding Allocation ONE (FA1/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | 1619-AS-2122-Contract-Provider-10014013-1_9           | 1_9            | 1619                        | AS-2122            | 28639.00          |

    # Provider Funding Allocation (FA1/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10014013-1_9  | 1_9                    | 1619-AS-2122-Contract-Provider-10014013-1_9           | 10014013      | Furth        | 06SDC           | 28639.00                  |

    # Funding Allocation Line (aka Deliverable) (FA1/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10014013-1_9  | 1619-001        | 15755.00         | Payment         |
    | 1619-AS-2122-10014013-1_9  | 1619-024        | 12884.00         | Payment         |

    # Funding Allocation Profile Period (FA1/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10014013-1_9  | 1619-001        | FY-2122              | September              | 2021              | 4739.00                   |
    | 1619-AS-2122-10014013-1_9  | 1619-001        | FY-2122              | January                | 2022              | 4968.00                   |
    | 1619-AS-2122-10014013-1_9  | 1619-001        | FY-2122              | February               | 2022              | 3558.00                   |
    | 1619-AS-2122-10014013-1_9  | 1619-001        | FY-2122              | June                   | 2022              | 2490.00                   |
    #
    | 1619-AS-2122-10014013-1_9  | 1619-024        | FY-2122              | September              | 2021              | 2302.00                   |
    | 1619-AS-2122-10014013-1_9  | 1619-024        | FY-2122              | January                | 2022              | 2943.00                   |
    | 1619-AS-2122-10014013-1_9  | 1619-024        | FY-2122              | February               | 2022              | 4370.00                   |
    | 1619-AS-2122-10014013-1_9  | 1619-024        | FY-2122              | March                  | 2022              | 3269.00                   |
 
 
    # Funding Allocation (FA2/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014013 | NMSS-AY-2122-Contract-Provider-10014013-3_0       | 3_0            | NMSS                        | AY-2122            | 29863.00          |

    # Provider Funding Allocation (FA2/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10014013-3_0  | 3_0                    | NMSS-AY-2122-Contract-Provider-10014013-3_0 | 10014013      | Schoo        | 21NMS           | 29863.00                  |

    # Funding Allocation Line (aka Deliverable) (FA2/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10014013-3_0  | NMSS-004        | 2076.00          | Payment         |
    | NMSS-AY-2122-10014013-3_0  | NMSS-007        | 25383.00         | Payment         |
    | NMSS-AY-2122-10014013-3_0  | NMSS-008        | 2404.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10014013-3_0  | NMSS-004        | FY-2122              | September              | 2021              | 2076.00                   |
    #
    | NMSS-AY-2122-10014013-3_0  | NMSS-007        | FY-2122              | June                   | 2022              | 5330.00                   |
    | NMSS-AY-2122-10014013-3_0  | NMSS-007        | FY-2122              | April                  | 2022              | 3850.00                   |
    | NMSS-AY-2122-10014013-3_0  | NMSS-007        | FY-2122              | February               | 2022              | 2301.00                   |
    | NMSS-AY-2122-10014013-3_0  | NMSS-007        | FY-2122              | December               | 2021              | 4860.00                   |
    | NMSS-AY-2122-10014013-3_0  | NMSS-007        | FY-2122              | October                | 2021              | 3653.00                   |
    | NMSS-AY-2122-10014013-3_0  | NMSS-007        | FY-2122              | September              | 2021              | 5389.00                   |
    #
    | NMSS-AY-2122-10014013-3_0  | NMSS-008        | FY-2122              | December               | 2021              | 2404.00                   |

    # Funding Allocation (FA2/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014017 | NMSS-AY-2122-Contract-Provider-10014017-3_0       | 3_0            | NMSS                        | AY-2122            | 15863.00          |

    # Provider Funding Allocation (FA2/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10014017-3_0  | 3_0                    | NMSS-AY-2122-Contract-Provider-10014017-3_0 | 10014017      | Schoo        | 21NMS           | 15961.00                  |

    # Funding Allocation Line (aka Deliverable) (FA2/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10014017-3_0  | NMSS-001        | 2076.00          | Payment         |
    | NMSS-AY-2122-10014017-3_0  | NMSS-002        | 5330.00         | Payment         |
    | NMSS-AY-2122-10014017-3_0  | NMSS-003        | 3850.00          | Payment         |
    | NMSS-AY-2122-10014017-3_0  | NMSS-005        | 2301.00         | Payment         |
    | NMSS-AY-2122-10014017-3_0  | NMSS-006        | 2404.00          | Payment         |

    # Funding Allocation Profile Period (FA2/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10014017-3_0  | NMSS-001        | FY-2122              | September              | 2021              | 2076.00                   |
    #
    | NMSS-AY-2122-10014017-3_0  | NMSS-002        | FY-2122              | June                   | 2022              | 5330.00                   |
    #
    | NMSS-AY-2122-10014017-3_0  | NMSS-003        | FY-2122              | April                  | 2022              | 3850.00                   |
    #
    | NMSS-AY-2122-10014017-3_0  | NMSS-005        | FY-2122              | February               | 2022              | 2301.00                   |
    #
    | NMSS-AY-2122-10014017-3_0  | NMSS-006        | FY-2122              | December               | 2021              | 2404.00                   |


    
    # Change the date 
    Given the override date is '19/06/2021'
    
    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Tidy Up
    Then   the override date is reset


@AcceptanceTest @Manual
Scenario: L018 Populate CFS FAs (1619/NFF) for a single LA where contract already exists (manual task)

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014018'
    And   there is no Funding Allocation data in CRM for UKPRN '10014018'
    And   there is no Contract, Task or Workflow data for UKPRN '10014018'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014018' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    Given   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014018' 
    And there is no Organisation data for UKPRN '10014532' 
    And there is no Organisation data for UKPRN '10014632' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014018 Co Ltd' with UKPRN '10014018' and OrgId 'ORG0014018' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014018 | 114018 | 10014018 Co Ltd | 0              | Active                | Yes           | AA014018      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014018 |

 
    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'
 
     # Funding Allocation ONE (FA1/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014018 | 1619-AS-2021-Contract-LocalAuthority-10014018-3_1     | 3_1            | 1619                        | AS-2021            | 28639.00          |

    # Provider Funding Allocation (FA1/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10014018-3_1  | 3_1                    | 1619-AS-2021-Contract-LocalAuthority-10014018-3_1     | 10014018      | Local        | 10LAU           | 28639.00                  |

    # Funding Allocation Line (aka Deliverable) (FA1/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10014018-3_1  | 1619-001        | 15755.00         | Payment         |
    | 1619-AS-2021-10014018-3_1  | 1619-002        | 12884.00         | Payment         |

    # Funding Allocation Profile Period (FA1/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10014018-3_1  | 1619-001        | FY-2021              | September              | 2020              | 4739.00                   |
    | 1619-AS-2021-10014018-3_1  | 1619-001        | FY-2021              | January                | 2021              | 4968.00                   |
    | 1619-AS-2021-10014018-3_1  | 1619-001        | FY-2021              | February               | 2021              | 3558.00                   |
    | 1619-AS-2021-10014018-3_1  | 1619-001        | FY-2021              | June                   | 2021              | 2490.00                   |
    #
    | 1619-AS-2021-10014018-3_1  | 1619-002        | FY-2021              | September              | 2020              | 2302.00                   |
    | 1619-AS-2021-10014018-3_1  | 1619-002        | FY-2021              | January                | 2021              | 2943.00                   |
    | 1619-AS-2021-10014018-3_1  | 1619-002        | FY-2021              | February               | 2021              | 4370.00                   |
    | 1619-AS-2021-10014018-3_1  | 1619-002        | FY-2021              | March                  | 2021              | 3269.00                   |




    # Funding Allocation TWO (FA2/V2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014018 | NFF-AS-2021-Contract-LocalAuthority-10014018-4_2      | 4_2            | NFF                         | AY-2021            | 28058.00          |

    # Provider Funding Allocation (FA2/V2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2021-10014018-4_2   | 4_2                    | NFF-AS-2021-Contract-LocalAuthority-10014018-4_2      | 10014018      | Local        | 10LAU           | 28058.00                  |

    # Funding Allocation Line (aka Deliverable) (FA2/V2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2021-10014018-4_2   | NFF-005        | 11750.00         | Payment         |
    | NFF-AS-2021-10014018-4_2   | NFF-006        | 16308.00         | Payment         |

    # Funding Allocation Profile Period (FA2/V2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2021-10014018-4_2   | NFF-005        | FY-2021              | August                 | 2020              | 3550.00                   |
    | NFF-AS-2021-10014018-4_2   | NFF-005        | FY-2021              | January                | 2021              | 3197.00                   |
    | NFF-AS-2021-10014018-4_2   | NFF-005        | FY-2021              | May                    | 2021              | 5003.00                   |
    #
    | NFF-AS-2021-10014018-4_2   | NFF-006        | FY-2021              | September              | 2020              | 4018.00                   |
    | NFF-AS-2021-10014018-4_2   | NFF-006        | FY-2021              | October                | 2020              | 2807.00                   |
    | NFF-AS-2021-10014018-4_2   | NFF-006        | FY-2021              | November               | 2020              | 4543.00                   |
    | NFF-AS-2021-10014018-4_2   | NFF-006        | FY-2021              | March                  | 2021              | 4944.00                   |

    
    
    # Change the date 
    Given the override date is '19/06/2021'
    
    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Tidy Up
    Then   the override date is reset



@AcceptanceTest @Withdrawn20231002 
@CFS 
@Long2Run @Long2Run890
Scenario: L019 Create ALLF Contract, Import FAs (1619/NFF) for a LA and approve, NFA (v2), add FAs (1619/NFF) for 3 Del Orgs

#     Contracting Org 10014019 - 1619, NFF, ALLF 
#     Delivery Org 1 10014919 - 1619, NFF    
#     Delivery Org 2 10014819 - 1619, NFF    
#     Delivery Org 3 10014719 - 1619
   
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014019'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014719'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014819'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014919'
    And   there is no Funding Allocation data in CRM for UKPRN '10014019'
    And   there is no Funding Allocation data in CRM for UKPRN '10014719'
    And   there is no Funding Allocation data in CRM for UKPRN '10014819'
    And   there is no Funding Allocation data in CRM for UKPRN '10014919'
    And   there is no Contract, Task or Workflow data for UKPRN '10014019'
    And   there is no Contract, Task or Workflow data for UKPRN '10014719'
    And   there is no Contract, Task or Workflow data for UKPRN '10014819'
    And   there is no Contract, Task or Workflow data for UKPRN '10014919'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014019' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-4019     |

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-4019     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLF2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-4019      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10014019'

    # Set the 'base' timestamp for each of the 39 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2122_TAC_CFS_ITP_2021-08-01.docx            | 2021-05-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_COLLEGE_2021-08-01.docx       | 2021-05-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_EMPLOYER_2021-08-01.docx      | 2021-05-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_HEI_2021-08-01.docx           | 2021-05-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_LA_2021-08-01.docx            | 2021-05-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_NMSS_2021-08-01.docx          | 2021-05-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_SPI_2021-08-01.docx           | 2021-05-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_TRUST_2021-08-01.docx         | 2021-05-18 12:00:00.000 | 
    # 
    | EDSK2122_S1_1618TRN_CFS_2021-08-01.docx         | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_1618TRN_COFG_2021-08-01.docx        | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_COLLEGE_2021-08-01.docx      | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_HEI_2021-08-01.docx          | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_ITP_2021-08-01.docx          | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_LA_2021-08-01.docx           | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_NMSS_2021-08-01.docx         | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_SPI_2021-08-01.docx          | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_AEB_COFG_2021-08-01.docx            | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_APPS_COLLEGE_2021-08-01.docx        | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_APPS_OTHER_2021-08-01.docx          | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_LOANS_CFS_2021-08-01.docx           | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S1_LOANS_COFG_2021-08-01.docx          | 2021-05-18 12:00:00.000 | 
    # 
    | EDSK2122_S2_1618TRN_CFS_2021-08-01.docx         | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S2_1618TRN_COFG_2021-08-01.docx        | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S2_1619ED_CFS_2021-08-01.docx          | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S2_1619ED_COFG_2021-08-01.docx         | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S2_AEB_COFG_2021-08-01.docx            | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S2_APPS_COLLEGE_2021-08-01.docx        | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S2_APPS_OTHER_2021-08-01.docx          | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S2_LOANS_CFS_2021-08-01.docx           | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S2_LOANS_COFG_2021-08-01.docx          | 2021-05-18 12:00:00.000 | 
    # 
    | EDSK2122_S3ON_CFS_ITP_2021-08-01.docx           | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_COLLEGE_2021-08-01.docx      | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_EMPLOYER_2021-08-01.docx     | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_LA_TRUST_HEI_2021-08-01.docx | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_NMSS_2021-08-01.docx         | 2021-05-18 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_SPI_2021-08-01.docx          | 2021-05-18 12:00:00.000 | 
    # 
    | FA_EDSK2122_2021-08-01.docx                     | 2021-05-18 12:00:00.000 | 


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014019' 
    And   there is no Organisation data for UKPRN '10014919' 
    And   there is no Organisation data for UKPRN '10014819' 
    And   there is no Organisation data for UKPRN '10014719'  

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014019 Co Ltd' with UKPRN '10014019' and OrgId 'ORG0014019' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014019 | 114019 | 10014019 Co Ltd | 0              | Active                | Yes           | AA014019      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014919 | 114919 | 10014919 Co Ltd | 0              | Active                | Yes           | AA014919      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
    | 10014819 | 114819 | 10014819 Co Ltd | 0              | Active                | Yes           | AA014819      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |
    | 10014719 | 114719 | 10014719 Co Ltd | 0              | Active                | Yes           | AA014719      | ?             | 121 Secondary Street   | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD17 0DA  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014019 |
    | 10014919 |
    | 10014819 |
    | 10014719 |

    # Change the date 
    Given the override date is '01/06/2021'


    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId       |
    | 10014019 | 10014019 Co Ltd      | ESFA-4019            | EDSK-4019      | 1                     | 01/08/2021        | 31/07/2022      | 17618.00      |                                       | Conditions of Funding (Grant) (LA)         | 2122   | New          | ORG0014019  |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10014019 | EDSK-4019      | ALLF-4019     | ALLF              | ALLF2122                | AY                      | 01/08/2021          | 31/07/2022        | 17618.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10014019 | EDSK-4019      | ALLF-4019     | 5               | 0                     | 17618.00  | 10723.00  | 6895.00   | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | Advanced Learner Loans Facility                                 | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-4019      | 1                     | 0                        | 2021-06-01 09:12:35.000 |




    # 1st FAs (New)

    # Populate the stub

    # Change the date 
    Given the override date is '05/06/2021'

    # Funding Allocation ONE (CO_1619)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014019 | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4     | 2_4            | 1619                        | AS-2122            | 28639.00          |

    # Provider Funding Allocation (CO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10014019-2_4  | 2_4                    | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4     | 10014019      | Local        | 10LAU           | 28639.00                  |

    # Funding Allocation Line (aka Deliverable) (CO_1619)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10014019-2_4  | 1619-001        | 15755.00         | Payment         |
    | 1619-AS-2122-10014019-2_4  | 1619-024        | 12884.00         | Payment         |

    # Funding Allocation Profile Period (CO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10014019-2_4  | 1619-001        | FY-2122              | September              | 2021              | 4739.00                   |
    | 1619-AS-2122-10014019-2_4  | 1619-001        | FY-2122              | December               | 2021              | 4968.00                   |
    | 1619-AS-2122-10014019-2_4  | 1619-001        | FY-2122              | March                  | 2022              | 3558.00                   |
    | 1619-AS-2122-10014019-2_4  | 1619-001        | FY-2122              | June                   | 2022              | 2490.00                   |
    #
    | 1619-AS-2122-10014019-2_4  | 1619-024        | FY-2122              | October                | 2021              | 2302.00                   |
    | 1619-AS-2122-10014019-2_4  | 1619-024        | FY-2122              | January                | 2022              | 2943.00                   |
    | 1619-AS-2122-10014019-2_4  | 1619-024        | FY-2122              | April                  | 2022              | 4370.00                   |
    | 1619-AS-2122-10014019-2_4  | 1619-024        | FY-2122              | July                   | 2022              | 3269.00                   |




    # Funding Allocation TWO (CO_NFF)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014019 | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9      | 2_9            | NFF                         | AS-2122            | 28058.00          |

    # Provider Funding Allocation (CO_NFF)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10014019-2_9   | 2_9                    | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9      | 10014019      | Local        | 10LAU           | 28058.00                  |

    # Funding Allocation Line (aka Deliverable) (CO_NFF)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10014019-2_9   | NFF-001         | 11750.00         | Payment         |
    | NFF-AS-2122-10014019-2_9   | NFF-002         | 6821.00          | Payment         |
    | NFF-AS-2122-10014019-2_9   | NFF-003         | 4543.00          | Payment         |
    | NFF-AS-2122-10014019-2_9   | NFF-004         | 4944.00          | Payment         |

    # Funding Allocation Profile Period (CO_NFF)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10014019-2_9  | NFF-001          | FY-2122              | August                 | 2021              | 3550.00                   |
    | NFF-AS-2122-10014019-2_9  | NFF-001          | FY-2122              | January                | 2022              | 3197.00                   |
    | NFF-AS-2122-10014019-2_9  | NFF-001          | FY-2122              | May                    | 2022              | 5003.00                   |
    | NFF-AS-2122-10014019-2_9  | NFF-002          | FY-2122              | September              | 2021              | 4014.00                   |
    | NFF-AS-2122-10014019-2_9  | NFF-002          | FY-2122              | February               | 2022              | 2807.00                   |
    | NFF-AS-2122-10014019-2_9  | NFF-003          | FY-2122              | November               | 2021              | 4543.00                   |
    | NFF-AS-2122-10014019-2_9  | NFF-004          | FY-2122              | March                  | 2022              | 4944.00                   |





    # Change the date 
    Given the override date is '08/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM
        
    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10014019 | 10014019 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4       | 2_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 28639.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
    | 10014019 | 10014019 Co Ltd  | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9        | 2_9            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 28058.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
     
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4       | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |
    | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9        | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 56697.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10014019 | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4       | 2_4            | AS-2122 | 1619                        | 28639.00    | [CofG_LA]    |
    | 10014019 | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9        | 2_9            | AS-2122 | NFF                         | 28058.00    | [CofG_LA]    |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

    # Release a Funding Allocation (32333)

    # Change the date 
    Given the override date is '11/06/2021'

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |
    
    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 56697.00        |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Retrieve parameters from CRM 
    Given   I retrieve the latest contract details from CRM for provider '10014019' for FundingType 'EDSK' and period '2122'

    # Check the CRM Funding Allocations data 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                            | FundingVersion | FundingType                | Period  | ContractType                            | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                |
    | 10014019 | 10014019 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4    | 2_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)      | 1619                        | 16-19ED2122     | Released          | Released          | 28639.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  | ?                         |
    | 10014019 | 10014019 Co Ltd  | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9     | 2_9            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)      | NFF                         | 16-19ED2122     | Released          | Released          | 28058.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                            | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4    | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4    | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9     | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9     | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9     | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10014019 | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4       | 2_4            | AS-2122 | 1619                        | 28639.00    | [CofG_LA]    |
    | 10014019 | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9        | 2_9            | AS-2122 | NFF                         | 28058.00    | [CofG_LA]    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                            | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4    | EDSK-4019    | 1               | 1                  | Yes            |
    | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9     | EDSK-4019    | 1               | 1                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014019 | EDSK-4019          | 1                     | 1                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10014019 | EDSK-4019          | 1                     | 0                        | Superseded Draft | ?                                        | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10014019 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation | 
    | 10014019 | EDSK-4019          | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 74315.00      | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-4019          | AY2122 | ?               | 10014019 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10014019 | ESFA-4019          | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10014019 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10014019 | EDSK-4019          | ALLF-4019             | ?                             | 17618.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | ALLF          | ALLF2122            | Contract Allocation   | ?                        |
    | 10014019 | EDSK-4019          | [AllocRef_16ED]       | ?                             | 56697.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | DeliverableName                                            | DeliverableDescription   |
    | EDSK-4019      | ALLF-4019       | 5               | 17618.00  | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | Advanced Learner Loans Facility                            |                          |
    | EDSK-4019      | [AllocRef_16ED] | 20              | 15755.00  | 0.00     | 4739.00  | 0.00     | 0.00     | 4968.00  | 0.00     | 0.00     | 3558.00  | 0.00     | 0.00     | 2490.00  | 0.00     | 16-19 Programme Funding                                    |                          |
    | EDSK-4019      | [AllocRef_16ED] | 149             | 12884.00  | 0.00     | 0.00     | 2302.00  | 0.00     | 0.00     | 2943.00  | 0.00     | 0.00     | 4370.00  | 0.00     | 0.00     | 3269.00  | 16-19 High Value Courses School and College Leavers Uplift |                          |
    | EDSK-4019      | [AllocRef_16ED] | 931             | 11750.00  | 3550.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3197.00  | 0.00     | 0.00     | 0.00     | 5003.00  | 0.00     | 0.00     | Cadets Vocational Programme                                |                          |
    | EDSK-4019      | [AllocRef_16ED] | 87              | 6821.00   | 0.00     | 4014.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2807.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Area Review Transition Grant                              |                          |
    | EDSK-4019      | [AllocRef_16ED] | 89              | 4543.00   | 0.00     | 0.00     | 0.00     | 4543.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16+ Factor Removal (DSG) SSF                               |                          |
    | EDSK-4019      | [AllocRef_16ED] | 119             | 4944.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4944.00  | 0.00     | 0.00     | 0.00     | 0.00     | Maths Centre for Excellence 1619                           |                          |



    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '84' deliverable period rows in CRM linked to the latest version of contract 'EDSK-4019'

    # Check the contents of the Appendices
    And   the file named '10014019_EDSK-4019_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22  
    Organisation Name: 10014019 Co Ltd UKPRN: 10014019
    Master Contract Number: ESFA-4019
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Facility ALLF-4019 £10,723 £6,895 £17,618
    16 to 19 Education [AllocRef_16ED] £41,565 £15,132 £56,697
    Total Funding for this contract: £74,315
    Summary of Funding – Page 1
    
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10014019 Co Ltd
    Advanced Learner Loans
    Funding for
    16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10014019 Co Ltd THE SECRETARY OF STATE FOR
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
    Company No: AA014019
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75

    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 8
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 12
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10014019 Co Ltd UKPRN: 10014019
    Master Contract Number: ESFA-4019 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: ALLF-4019
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Advanced Learner Loans Facility £17,618 £321 £1,561 £558 £849 £2,692 £1,847 £1,665 £1,230 £2,534 £2,322 £241 £1,798
    Total Funding £17,618 £321 £1,561 £558 £849 £2,692 £1,847 £1,665 £1,230 £2,534 £2,322 £241 £1,798
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-4019 – Page 1 Ref (for internal use only):  EDSK-4019 v1

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10014019 Co Ltd UKPRN: 10014019
    Master Contract Number: ESFA-4019 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £15,755 £0.00 £4,739.00 £0.00 £0.00 £4,968.00 £0.00 £0.00 £3,558.00 £0.00 £0.00 £2,490.00 £0.00
    Cadets Vocational Programme £11,750 £3,550.00 £0.00 £0.00 £0.00 £0.00 £3,197.00 £0.00 £0.00 £0.00 £5,003.00 £0.00 £0.00
    Area Review Transition Grant £6,821 £0.00 £4,014.00 £0.00 £0.00 £0.00 £0.00 £2,807.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16+ Factor Removal (DSG) SSF £4,543 £0.00 £0.00 £0.00 £4,543.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Maths Centre for Excellence 1619 £4,944 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £4,944.00 £0.00 £0.00 £0.00 £0.00
    16-19 High Value Courses School and College £12,884 £0.00 £0.00 £2,302.00 £0.00 £0.00 £2,943.00 £0.00 £0.00 £4,370.00 £0.00 £0.00 £3,269.00
    Leavers Uplift
    Total Funding £56,697 £3,550.00 £8,753.00 £2,302.00 £4,543.00 £4,968.00 £6,140.00 £2,807.00 £8,502.00 £4,370.00 £5,003.00 £2,490.00 £3,269.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-4019 v1

    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (July 2021) – Page 1
    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (July 2021) – Page 1
    SCHEDULE 6: UK GDPR AND DATA PROTECTION
    EDSK Schedule 6 Version 2 (July 2021) – Page 1
    EDSK Schedule 6 Version 2 (July 2021) – Page 2
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 2 (July 2021) – Page 1
    EDSK Schedule 7 Version 2 (July 2021) – Page 7
    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 2 (July 2021) – Page 1
    EDSK Schedule 8 Version 2 (July 2021) – Page 5
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10014019_EDSK-4019_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'L019_1.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-4019      | 1                     | 0                        | 2021-06-11 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'EDSK-4019' for provider '10014019'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10014019 - 10014019 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract 'EDSK-4019' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10014019 | ESFA-4019          | EDSK-4019      | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10014019 | ESFA-4019          | EDSK-4019      | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |


    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '14/06/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-4019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-4019' and ContractNumber 'EDSK-4019' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-4019' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014019 | EDSK-4019          | 1                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10014019 | ESFA-4019          | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                |
    | 10014019 | 10014019 Co Ltd  | 1619-AS-2122-Contract-LocalAuthority-10014019-2_4       | 2_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 28639.00    | EDSK-4019     | 1                 | CRM Integration       | CRM Integration           | ?                         |
    | 10014019 | 10014019 Co Ltd  | NFF-AS-2122-Contract-LocalAuthority-10014019-2_9        | 2_9            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Contract Approved | Contract Approved | 28058.00    | EDSK-4019     | 1                 | CRM Integration       | CRM Integration           | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    And  the details in CRM for version '1' of contract 'EDSK-4019' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    And  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                            | DeliverableDescription      |
    | 10014019 | EDSK-4019      | 1               | ALLF-4019        | 5               | 0                     | 17618.00     | 0             | 0        | Advanced Learner Loans Facility                            |                             | 
    | 10014019 | EDSK-4019      | 1               | [AllocRef_16ED]  | 20              | 0                     | 15755.00     | 0             | 0        | 16-19 Programme Funding                                    | ?                           |
    | 10014019 | EDSK-4019      | 1               | [AllocRef_16ED]  | 149             | 0                     | 12884.00     | 0             | 0        | 16-19 High Value Courses School and College Leavers Uplift | ?                           |
    | 10014019 | EDSK-4019      | 1               | [AllocRef_16ED]  | 931             | 0                     | 11750.00     | 0             | 0        | Cadets Vocational Programme              | ?                           |
    | 10014019 | EDSK-4019      | 1               | [AllocRef_16ED]  | 87              | 0                     | 6821.00      | 0             | 0        | Area Review Transition Grant | ?                           |
    | 10014019 | EDSK-4019      | 1               | [AllocRef_16ED]  | 89              | 0                     | 4543.00      | 0             | 0        | 16+ Factor Removal (DSG) SSF                | ?                           |
    | 10014019 | EDSK-4019      | 1               | [AllocRef_16ED]  | 119             | 0                     | 4944.00      | 0             | 0        | Maths Centre for Excellence 1619                                    | ?                           |



    # Execute a NON-FINANCIAL amendment on EDSK-4019

    # Change the date
    Given the override date is '17/06/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2.
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'EDSK-4019' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014019 | EDSK-4019          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10014019 | EDSK-4019          | 1                     | 1                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10014019 | EDSK-4019          | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10014019 | ESFA-4019          | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # 2nd FAs (UDA)

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    Given there is no data in the CFS stub
    #And   there is no data in the Funding Allocation PaaS tables





    # Populate the stub

    # Change the date 
    And the override date is '19/06/2021'

    # Funding Allocation THREE (DO_1619))
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014019 | 1619-AS-2122-Contract-LocalAuthoritySsf-10014019-3_2  | 3_2            | 1619                        | AS-2122            | 88515.00          |

    # Provider Funding Allocation (DO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10014919-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014019-3_2  | 10014919      | Schoo        | 08SSF           | 23446.00                  |
    | 1619-AS-2122-10014819-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014019-3_2  | 10014819      | Schoo        | 08SSF           | 33984.00                  |
    | 1619-AS-2122-10014719-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014019-3_2  | 10014719      | Schoo        | 08SSF           | 31085.00                  |

    # Funding Allocation Line (aka Deliverable) (DO_1619)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10014919-3_2  | 1619-001        | 17542.00         | Payment         |
    | 1619-AS-2122-10014919-3_2  | 1619-002        | 5904.00          | Payment         |
    #
    | 1619-AS-2122-10014819-3_2  | 1619-001        | 7086.00          | Payment         |
    | 1619-AS-2122-10014819-3_2  | 1619-002        | 22799.00         | Payment         |
    | 1619-AS-2122-10014819-3_2  | 1619-024        | 4099.00          | Payment         |
    #
    | 1619-AS-2122-10014719-3_2  | 1619-001        | 7287.00          | Payment         |
    | 1619-AS-2122-10014719-3_2  | 1619-005        | 23798.00         | Payment         |

    # Funding Allocation Profile Period (DO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10014919-3_2  | 1619-001        | FY-2122              | August                 | 2021              | 5801.00                   |
    | 1619-AS-2122-10014919-3_2  | 1619-001        | FY-2122              | September              | 2021              | 2030.00                   |
    | 1619-AS-2122-10014919-3_2  | 1619-001        | FY-2122              | November               | 2021              | 4620.00                   |
    | 1619-AS-2122-10014919-3_2  | 1619-001        | FY-2122              | January                | 2022              | 5091.00                   |
    | 1619-AS-2122-10014919-3_2  | 1619-002        | FY-2122              | April                  | 2022              | 2546.00                   |
    | 1619-AS-2122-10014919-3_2  | 1619-002        | FY-2122              | May                    | 2022              | 3358.00                   |
    #
    | 1619-AS-2122-10014819-3_2  | 1619-001        | FY-2122              | October                | 2021              | 2539.00                   |
    | 1619-AS-2122-10014819-3_2  | 1619-001        | FY-2122              | November               | 2021              | 4547.00                   |
    | 1619-AS-2122-10014819-3_2  | 1619-002        | FY-2122              | December               | 2021              | 5773.00                   |
    | 1619-AS-2122-10014819-3_2  | 1619-002        | FY-2122              | January                | 2022              | 4919.00                   |
    | 1619-AS-2122-10014819-3_2  | 1619-002        | FY-2122              | February               | 2022              | 3081.00                   |
    | 1619-AS-2122-10014819-3_2  | 1619-002        | FY-2122              | March                  | 2022              | 4219.00                   |
    | 1619-AS-2122-10014819-3_2  | 1619-002        | FY-2122              | April                  | 2022              | 4807.00                   |
    | 1619-AS-2122-10014819-3_2  | 1619-024        | FY-2122              | July                   | 2022              | 4099.00                   |
    #
    | 1619-AS-2122-10014719-3_2  | 1619-001        | FY-2122              | August                 | 2021              | 2639.00                   |
    | 1619-AS-2122-10014719-3_2  | 1619-001        | FY-2122              | October                | 2021              | 4648.00                   |
    | 1619-AS-2122-10014719-3_2  | 1619-005        | FY-2122              | September              | 2021              | 5773.00                   |
    | 1619-AS-2122-10014719-3_2  | 1619-005        | FY-2122              | November               | 2021              | 4919.00                   |
    | 1619-AS-2122-10014719-3_2  | 1619-005        | FY-2122              | January                | 2022              | 3081.00                   |
    | 1619-AS-2122-10014719-3_2  | 1619-005        | FY-2122              | March                  | 2022              | 4218.00                   |
    | 1619-AS-2122-10014719-3_2  | 1619-005        | FY-2122              | May                    | 2022              | 3345.00                   |
    | 1619-AS-2122-10014719-3_2  | 1619-005        | FY-2122              | July                   | 2022              | 2462.00                   |


    # Funding Allocation FOUR (DO_NFF)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014019 | NFF-AS-2122-Contract-LocalAuthoritySsf-10014019-3_0   | 3_0            | NFF                         | AS-2122            | 43694.00          |

    # Provider Funding Allocation (DO_NFF)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NFF-AS-2122-10014919-3_0   | 3_0                    | NFF-AS-2122-Contract-LocalAuthoritySsf-10014019-3_0   | 10014919      | Schoo        | 08SSF           | 21011.00                  |
    | NFF-AS-2122-10014819-3_0   | 3_0                    | NFF-AS-2122-Contract-LocalAuthoritySsf-10014019-3_0   | 10014819      | Schoo        | 08SSF           | 22683.00                  |

    # Funding Allocation Line (aka Deliverable) (DO_NFF)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NFF-AS-2122-10014919-3_0   | NFF-001         | 2746.00          | Payment         |
    | NFF-AS-2122-10014919-3_0   | NFF-002         | 18265.00         | Payment         |
    | NFF-AS-2122-10014819-3_0   | NFF-001         | 3144.00          | Payment         |
    | NFF-AS-2122-10014819-3_0   | NFF-004         | 19539.00         | Payment         |

    # Funding Allocation Profile Period (DO_NFF)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NFF-AS-2122-10014919-3_0   | NFF-001         | FY-2122              | April                  | 2022              | 1142.00                   |
    | NFF-AS-2122-10014919-3_0   | NFF-001         | FY-2122              | October                | 2021              | 1604.00                   |
    | NFF-AS-2122-10014919-3_0   | NFF-002         | FY-2122              | November               | 2021              | 2637.00                   |
    | NFF-AS-2122-10014919-3_0   | NFF-002         | FY-2122              | December               | 2021              | 3107.00                   |
    | NFF-AS-2122-10014919-3_0   | NFF-002         | FY-2122              | February               | 2022              | 3304.00                   |
    | NFF-AS-2122-10014919-3_0   | NFF-002         | FY-2122              | April                  | 2022              | 4218.00                   |
    | NFF-AS-2122-10014919-3_0   | NFF-002         | FY-2122              | June                   | 2022              | 4999.00                   |
    #
    | NFF-AS-2122-10014819-3_0   | NFF-001         | FY-2122              | April                  | 2022              | 3144.00                   |
    | NFF-AS-2122-10014819-3_0   | NFF-004         | FY-2122              | October                | 2021              | 4047.00                   |
    | NFF-AS-2122-10014819-3_0   | NFF-004         | FY-2122              | November               | 2021              | 2637.00                   |
    | NFF-AS-2122-10014819-3_0   | NFF-004         | FY-2122              | December               | 2021              | 3107.00                   |
    | NFF-AS-2122-10014819-3_0   | NFF-004         | FY-2122              | February               | 2022              | 3304.00                   |
    | NFF-AS-2122-10014819-3_0   | NFF-004         | FY-2122              | April                  | 2022              | 4218.00                   |
    | NFF-AS-2122-10014819-3_0   | NFF-004         | FY-2122              | June                   | 2022              | 2226.00                   |


    # Change the date 
    Given the override date is '22/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM


    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10014019 | 10014019 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10014019-3_2    | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 88515.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
    | 10014019 | 10014019 Co Ltd  | NFF-AS-2122-Contract-LocalAuthoritySsf-10014019-3_0     | 3_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2122     | Scheduling        | Awaiting Release  | 43694.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
     
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014019-3_2    | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |
    | NFF-AS-2122-Contract-LocalAuthoritySsf-10014019-3_0     | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 132209.00       |


    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10014019 | 1619-AS-2122-Contract-LocalAuthoritySsf-10014019-3_2    | 3_2            | AS-2122 | 1619                        | 88515.00    | [CofG_LA]   |
    | 10014019 | NFF-AS-2122-Contract-LocalAuthoritySsf-10014019-3_0     | 3_0            | AS-2122 | NFF                         | 43694.00    | [CofG_LA]   |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'


    # Release a Funding Allocation (32333)

    # Change the date 
    Given the override date is '24/06/2021'

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |
    
    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 132209.00       |


    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    Then   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Retrieve parameters from CRM 
    Given   I retrieve the latest EFA contract details from CRM for provider '10014019' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014019'

    # Check the CRM Funding Allocations data 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                            | FundingVersion | FundingType                | Period  | ContractType                            | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                |
    | 10014019 | 10014019 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10014019-3_2 | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)      | 1619                        | 16-19ED2122     | Released          | Released          | 88515.00    | EDSK-4019  | 1                 | CRM Integration  | CRM Integration  | ?                         |
    | 10014019 | 10014019 Co Ltd  | NFF-AS-2122-Contract-LocalAuthoritySsf-10014019-3_0  | 3_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)      | NFF                         | 16-19ED2122     | Released          | Released          | 43694.00    | EDSK-4019  | 1                 | CRM Integration  | CRM Integration  | ?                         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10014019 | 1619-AS-2122-Contract-LocalAuthoritySsf-10014019-3_2    | 3_2            | AS-2122 | 1619                        | 88515.00    | [CofG_LA]   |
    | 10014019 | NFF-AS-2122-Contract-LocalAuthoritySsf-10014019-3_0     | 3_0            | AS-2122 | NFF                         | 43694.00    | [CofG_LA]   |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014019-3_2    | EDSK-4019  | 2               | 1                  | Yes            |
    | NFF-AS-2122-Contract-LocalAuthoritySsf-10014019-3_0     | EDSK-4019  | 2               | 1                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014019 | EDSK-4019          | 2                     | 1                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10014019 | ESFA-4019          | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM for the contract 
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber | FundingType                | HierarchyType | ContractStatus | ContractSubStatus      | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                       | ContractDescription | AmendmentType | CurrentTask             | DocumentationRequired | ParentContract | Period | PreviousVersion | ProviderName    | State  | TaskOwner                | ContractValueVariation |
    | 10014019 | EDSK-4019      | Education & Skills Funding | Contract      | Draft          | Awaiting Documentation | 206524.00     | 2                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA) | ?                   | Variation     | Initiate Document Merge | Yes                   | ESFA-4019      | AY2122 | ?               | 10014019 Co Ltd | Active | Document Management Team | 132209.00              |
    | 10014019 | ESFA-4019      | Education & Skills Funding | Master        | Draft          | ?                      | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA) | ?                   | ?             | ?                       | ?                     | ?              | ?      | ?               | 10014019 Co Ltd | Active | CRM Integration          | ?                      |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10014019 | EDSK-4019      | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2021          | 31/07/2022        | 56697.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | DeliverableName                                            | DeliverableDescription   |
    | EDSK-4019      | ALLF-4019       | 5               | 17618.00  | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | Advanced Learner Loans Facility                            |                          |
    | EDSK-4019      | [AllocRef_16ED] | 20              | 15755.00  | 0.00     | 4739.00  | 0.00     | 0.00     | 4968.00  | 0.00     | 0.00     | 3558.00  | 0.00     | 0.00     | 2490.00  | 0.00     | 16-19 Programme Funding                                    |                          |
    | EDSK-4019      | [AllocRef_16ED] | 149             | 12884.00  | 0.00     | 0.00     | 2302.00  | 0.00     | 0.00     | 2943.00  | 0.00     | 0.00     | 4370.00  | 0.00     | 0.00     | 3269.00  | 16-19 High Value Courses School and College Leavers Uplift |                          |
    | EDSK-4019      | [AllocRef_16ED] | 931             | 11750.00  | 3550.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3197.00  | 0.00     | 0.00     | 0.00     | 5003.00  | 0.00     | 0.00     | Cadets Vocational Programme                                |                          |
    | EDSK-4019      | [AllocRef_16ED] | 87              | 6821.00   | 0.00     | 4014.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2807.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Area Review Transition Grant                              |                          |
    | EDSK-4019      | [AllocRef_16ED] | 89              | 4543.00   | 0.00     | 0.00     | 0.00     | 4543.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16+ Factor Removal (DSG) SSF                               |                          |
    | EDSK-4019      | [AllocRef_16ED] | 119             | 4944.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4944.00  | 0.00     | 0.00     | 0.00     | 0.00     | Maths Centre for Excellence 1619                           |                          |

    # Check the contents of the Appendices
    And   the file named '10014019_EDSK-4019_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22  
    Organisation Name: 10014019 Co Ltd UKPRN: 10014019
    Master Contract Number: ESFA-4019
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Facility ALLF-4019 £10,723 £6,895 £17,618
    16 to 19 Education 
    10014019 Co Ltd [AllocRef_16ED] £41,565 £15,132 £56,697
    Total Funding for this contract: £206,524
    Summary of Funding – Page 1
    """

    # There shouldn't be a T&C doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    """

    # There shouldn't be a Sch3ON doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10014019_EDSK-4019_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'L019_2.pdf'


    # Retrieve parameters from CRM 
    Given   I retrieve the latest EFA contract details from CRM for provider '10014019' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014719'

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10014719
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10014019 | EDSK-4019          | [AllocRef_16ED]       | ?                             | 31085.00        | 10014719      | 10014719 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10014719
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | DeliverableName                                             | DeliverableDescription   | 
    | 10014719 | EDSK-4019      | [AllocRef_16ED]    | 2               | 0                     | 7287.00   | 2639.00  | 0.00     | 4648.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Programme Funding                                       |                          | 
    | 10014719 | EDSK-4019      | [AllocRef_16ED]    | 47              | 0                     | 23798.00  | 0.00     | 5773.00  | 0.00     | 4919.00  | 0.00     | 3081.00  | 0.00     | 4218.00  | 0.00     | 3345.00  | 0.00     | 2462.00  | SSF Free Meals                                              |                          |

    
    # Check the contents of the Appendices for the Contracting Org 10014019
    Then  the file named '10014019_EDSK-4019_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22  
    Organisation Name: 10014019 Co Ltd UKPRN: 10014019
    Master Contract Number: ESFA-4019
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10014719 Co Ltd [AllocRef_16ED] £25,278 £5,807 £31,085
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10014719 Co Ltd UKPRN: 10014719
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Programme Funding £7,287 £2,639.00 £0.00 £4,648.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF Free Meals £23,798 £0.00 £5,773.00 £0.00 £4,919.00 £0.00 £3,081.00 £0.00 £4,218.00 £0.00 £3,345.00 £0.00 £2,462.00
    Total Funding £31,085 £2,639.00 £5,773.00 £4,648.00 £4,919.00 £0.00 £3,081.00 £0.00 £4,218.00 £0.00 £3,345.00 £0.00 £2,462.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-4019 v2
    """    

    # Retrieve parameters from CRM 
    Given   I retrieve the latest EFA contract details from CRM for provider '10014019' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014819'

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10014819
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10014019 | EDSK-4019          | [AllocRef_16ED]       | ?                             | 56667.00        | 10014819      | 10014819 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10014819
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | DeliverableName                                             | DeliverableDescription   | 
    | 10014819 | EDSK-4019   | [AllocRef_16ED]       | 2               | 0                     | 7086.00   | 0.00     | 0.00     | 2539.00  | 4547.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Programme Funding                                       |                          |
    | 10014819 | EDSK-4019   | [AllocRef_16ED]       | 13              | 0                     | 22799.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5773.00  | 4919.00  | 3081.00  | 4219.00  | 4807.00  | 0.00     | 0.00     | 0.00     | SSF Bursary Funds                                           |                          |
    | 10014819 | EDSK-4019   | [AllocRef_16ED]       | 119             | 0                     | 19539.00  | 0.00     | 0.00     | 4047.00  | 2637.00  | 3107.00  | 0.00     | 3304.00  | 0.00     | 4218.00  | 0.00     | 2226.00  | 0.00     | Maths Centre for Excellence 1619                                      |                          |
    | 10014819 | EDSK-4019   | [AllocRef_16ED]       | 931             | 0                     | 3144.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3144.00  | 0.00     | 0.00     | 0.00     | Cadets Vocational Programme                |                          |
    | 10014819 | EDSK-4019   | [AllocRef_16ED]       | 151             | 0                     | 4099.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4099.00  | SSF High Value Courses School and College Leavers Uplift    |                          |

    
    # Check the contents of the Appendices for the Contracting Org 10014019
    Then  the file named '10014019_EDSK-4019_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22  
    Organisation Name: 10014019 Co Ltd UKPRN: 10014019
    Master Contract Number: ESFA-4019
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10014819 Co Ltd [AllocRef_16ED] £38,173 £18,494 £56,667
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10014819 Co Ltd UKPRN: 10014819
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Programme Funding £7,086 £0.00 £0.00 £2,539.00 £4,547.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF Bursary Funds £22,799 £0.00 £0.00 £0.00 £0.00 £5,773.00 £4,919.00 £3,081.00 £4,219.00 £4,807.00 £0.00 £0.00 £0.00
    Cadets Vocational Programme £3,144 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,144.00 £0.00 £0.00 £0.00
    Maths Centre for Excellence 1619 £19,539 £0.00 £0.00 £4,047.00 £2,637.00 £3,107.00 £0.00 £3,304.00 £0.00 £4,218.00 £0.00 £2,226.00 £0.00
    SSF High Value Courses School and College £4,099 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £4,099.00
    Leavers Uplift
    Total Funding £56,667 £0.00 £0.00 £6,586.00 £7,184.00 £8,880.00 £4,919.00 £6,385.00 £4,219.00 £12,169.00 £0.00 £2,226.00 £4,099.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-4019 v2
    """    

    # Retrieve parameters from CRM 
    Given   I retrieve the latest EFA contract details from CRM for provider '10014019' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014919'

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10014919
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10014019 | EDSK-4019          | [AllocRef_16ED]       | ?                             | 44457.00        | 10014919      | 10014919 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10014919
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | DeliverableName                                             | DeliverableDescription   | 
    | 10014919 | EDSK-4019   | [AllocRef_16ED]       | 2               | 0                     | 17542.00  | 5801.00  | 2030.00  | 0.00     | 4620.00  | 0.00     | 5091.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Programme Funding                                       |                          |
    | 10014919 | EDSK-4019   | [AllocRef_16ED]       | 13              | 0                     | 5904.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2546.00  | 3358.00  | 0.00     | 0.00     | SSF Bursary Funds                                           |                          |
    | 10014919 | EDSK-4019   | [AllocRef_16ED]       | 931             | 0                     | 2746.00   | 0.00     | 0.00     | 1604.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1142.00  | 0.00     | 0.00     | 0.00     | Cadets Vocational Programme                |                          |
    | 10014919 | EDSK-4019   | [AllocRef_16ED]       | 87              | 0                     | 18265.00  | 0.00     | 0.00     | 0.00     | 2637.00  | 3107.00  | 0.00     | 3304.00  | 0.00     | 4218.00  | 0.00     | 4999.00  | 0.00     | Area Review Transition Grant   |                          |


    # Check the contents of the Appendices for the Contracting Org 10014019
    Then  the file named '10014019_EDSK-4019_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22  
    Organisation Name: 10014019 Co Ltd UKPRN: 10014019
    Master Contract Number: ESFA-4019
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10014919 Co Ltd [AllocRef_16ED] £28,194 £16,263 £44,457
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10014919 Co Ltd UKPRN: 10014919
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Programme Funding £17,542 £5,801.00 £2,030.00 £0.00 £4,620.00 £0.00 £5,091.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF Bursary Funds £5,904 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,546.00 £3,358.00 £0.00 £0.00
    Cadets Vocational Programme £2,746 £0.00 £0.00 £1,604.00 £0.00 £0.00 £0.00 £0.00 £0.00 £1,142.00 £0.00 £0.00 £0.00
    Area Review Transition Grant £18,265 £0.00 £0.00 £0.00 £2,637.00 £3,107.00 £0.00 £3,304.00 £0.00 £4,218.00 £0.00 £4,999.00 £0.00
    Total Funding £44,457 £5,801.00 £2,030.00 £1,604.00 £7,257.00 £3,107.00 £5,091.00 £3,304.00 £0.00 £7,906.00 £3,358.00 £4,999.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-4019 v2
    """    

    # Check the deliverable count in CRM
    Then  there are '216' deliverable period rows in CRM linked to the latest version of contract 'EDSK-4019'


    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-4019      | 2                     | 1                        | 2021-06-24 14:31:47.000 |



    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '27/06/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-4019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-4019' and ContractNumber 'EDSK-4019' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-4019' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014019 | EDSK-4019          | 2                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10014019 | ESFA-4019          | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Tidy Up
    And   the override date is reset


@AcceptanceTest @Withdrawn20231002 @CFS @Long2Run @Long2Run890
Scenario: L020 Create ALLB Contract, Import FA (1619SSF) for a LA (2 DO) and approve, NFA (v2), add FA (1619SSF) to Update/Add Deliverables

    #  Contracting Org 10014020 - ALLF 
    #     Delivery Org 1 10014920 - 1619    
    #     Delivery Org 2 10014820 - 1619
   
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10014020'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014820'
    And there is no Funding Allocation Workflow History data in CRM for UKPRN '10014920'
    And   there is no Funding Allocation data in CRM for UKPRN '10014020'
    And   there is no Funding Allocation data in CRM for UKPRN '10014820'
    And   there is no Funding Allocation data in CRM for UKPRN '10014920'
    And   there is no Contract, Task or Workflow data for UKPRN '10014020'
    And   there is no Contract, Task or Workflow data for UKPRN '10014820'
    And   there is no Contract, Task or Workflow data for UKPRN '10014920'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10014020' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-4020     |

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-4020     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-4020      | 1                     | 0                        |
    | EDSK-4020      | 1                     | 1                        |
    | EDSK-4020      | 2                     | 0                        |
    | EDSK-4020      | 2                     | 1                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10014020'

    # Set the 'base' timestamp for each of the 39 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2122_TAC_CFS_ITP_2021-08-01.docx            | 2021-06-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_COLLEGE_2021-08-01.docx       | 2021-06-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_EMPLOYER_2021-08-01.docx      | 2021-06-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_HEI_2021-08-01.docx           | 2021-06-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_LA_2021-08-01.docx            | 2021-06-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_NMSS_2021-08-01.docx          | 2021-06-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_SPI_2021-08-01.docx           | 2021-06-18 12:00:00.000 | 
    | EDSK2122_TAC_COFG_TRUST_2021-08-01.docx         | 2021-06-18 12:00:00.000 | 
    # 
    | EDSK2122_S1_1618TRN_CFS_2021-08-01.docx         | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_1618TRN_COFG_2021-08-01.docx        | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_COLLEGE_2021-08-01.docx      | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_HEI_2021-08-01.docx          | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_ITP_2021-08-01.docx          | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_LA_2021-08-01.docx           | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_NMSS_2021-08-01.docx         | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_1619ED_SPI_2021-08-01.docx          | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_AEB_COFG_2021-08-01.docx            | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_APPS_COLLEGE_2021-08-01.docx        | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_APPS_OTHER_2021-08-01.docx          | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_LOANS_CFS_2021-08-01.docx           | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S1_LOANS_COFG_2021-08-01.docx          | 2021-06-18 12:00:00.000 | 
    # 
    | EDSK2122_S2_1618TRN_CFS_2021-08-01.docx         | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S2_1618TRN_COFG_2021-08-01.docx        | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S2_1619ED_CFS_2021-08-01.docx          | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S2_1619ED_COFG_2021-08-01.docx         | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S2_AEB_COFG_2021-08-01.docx            | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S2_APPS_COLLEGE_2021-08-01.docx        | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S2_APPS_OTHER_2021-08-01.docx          | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S2_LOANS_CFS_2021-08-01.docx           | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S2_LOANS_COFG_2021-08-01.docx          | 2021-06-18 12:00:00.000 | 
    # 
    | EDSK2122_S3ON_CFS_ITP_2021-08-01.docx           | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_COLLEGE_2021-08-01.docx      | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_EMPLOYER_2021-08-01.docx     | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_LA_TRUST_HEI_2021-08-01.docx | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_NMSS_2021-08-01.docx         | 2021-06-18 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_SPI_2021-08-01.docx          | 2021-06-18 12:00:00.000 | 
    # 
    | FA_EDSK2122_2021-08-01.docx                     | 2021-06-18 12:00:00.000 | 


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10014020' 
    And   there is no Organisation data for UKPRN '10014920' 
    And   there is no Organisation data for UKPRN '10014820' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10014020 Co Ltd' with UKPRN '10014020' and OrgId 'ORG0014020' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10014020 | 114020 | 10014020 Co Ltd | 0              | Active                | Yes           | AA014020      | ?             | 89 Council Road        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY   |
    | 10014920 | 114920 | 10014920 Co Ltd | 0              | Active                | Yes           | AA014920      | ?             | 14 School Lane         | ?                      | ?                      | ?                      | Kings Langley          | Hertfordshire          | HP15 2BH  |
    | 10014820 | 114820 | 10014820 Co Ltd | 0              | Active                | Yes           | AA014820      | ?             | 15 Academy Avenue      | ?                      | ?                      | ?                      | Chesham                | Hertfordshire          | HP9 5RS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10014020 |
    | 10014920 |
    | 10014820 |

    # Change the date 
    Given the override date is '01/06/2022'


    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId       |
    | 10014020 | 10014020 Co Ltd      | ESFA-4020            | EDSK-4020      | 1                     | 01/08/2021        | 31/07/2022      | 17618.00      |                                       | Conditions of Funding (Grant) (LA)         | 2122    | New          | ORG0014020  |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10014020 | EDSK-4020      | ALLB-4020     | ALLB              | ALLB2122                | AY                      | 01/08/2021          | 31/07/2022        | 17618.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10014020 | EDSK-4020      | ALLB-4020     | 1               | 0                     | 17618.00  | 10723.00  | 6895.00   | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | Advanced Learner Loans Bursary                                  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-4020      | 1                     | 0                        | 2021-06-01 09:12:35.000 |




    # 1st FAs (New)

    # Populate the stub

    # Change the date 
    Given the override date is '05/06/2022'


 
    # Funding Allocation THREE (DO_1619))
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014020 | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1  | 2_1            | 1619                        | AS-2122            | 53331.00          |

    # Provider Funding Allocation (DO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10014920-2_1  | 2_1                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1  | 10014920      | Schoo        | 08SSF           | 23446.00                  |
    | 1619-AS-2122-10014820-2_1  | 2_1                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1  | 10014820      | Schoo        | 08SSF           | 29885.00                  |

    # Funding Allocation Line (aka Deliverable) (DO_1619)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10014920-2_1  | 1619-001        | 17542.00         | Payment         |
    | 1619-AS-2122-10014920-2_1  | 1619-002        | 5904.00          | Payment         |
    #
    | 1619-AS-2122-10014820-2_1  | 1619-001        | 7086.00          | Payment         |
    | 1619-AS-2122-10014820-2_1  | 1619-002        | 22799.00         | Payment         |

    # Funding Allocation Profile Period (DO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10014920-2_1  | 1619-001        | FY-2122              | August                 | 2021               | 5801.00                   |
    | 1619-AS-2122-10014920-2_1  | 1619-001        | FY-2122              | September              | 2021               | 2030.00                   |
    | 1619-AS-2122-10014920-2_1  | 1619-001        | FY-2122              | November               | 2021               | 4620.00                   |
    | 1619-AS-2122-10014920-2_1  | 1619-001        | FY-2122              | January                | 2022               | 5091.00                   |
    | 1619-AS-2122-10014920-2_1  | 1619-002        | FY-2122              | April                  | 2022               | 2546.00                   |
    | 1619-AS-2122-10014920-2_1  | 1619-002        | FY-2122              | May                    | 2022               | 3358.00                   |
    #
    | 1619-AS-2122-10014820-2_1  | 1619-001        | FY-2122              | October                | 2021               | 2539.00                   |
    | 1619-AS-2122-10014820-2_1  | 1619-001        | FY-2122              | November               | 2021               | 4547.00                   |
    | 1619-AS-2122-10014820-2_1  | 1619-002        | FY-2122              | December               | 2021               | 5773.00                   |
    | 1619-AS-2122-10014820-2_1  | 1619-002        | FY-2122              | January                | 2022               | 4919.00                   |
    | 1619-AS-2122-10014820-2_1  | 1619-002        | FY-2122              | February               | 2022               | 3081.00                   |
    | 1619-AS-2122-10014820-2_1  | 1619-002        | FY-2122              | March                  | 2022               | 4219.00                   |
    | 1619-AS-2122-10014820-2_1  | 1619-002        | FY-2122              | April                  | 2022               | 4807.00                   |




    # Change the date 
    Given the override date is '08/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM
        

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10014020 | 10014020 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1    | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 53331.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
     
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1    | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 53331.00        |


    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10014020 | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1    | 2_1            | AS-2122 | 1619                        | 53331.00    | [CofG_LA]    |


    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

    # Release a Funding Allocation (32333)

    # Change the date 
    Given the override date is '11/06/2021'

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |
    
    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 53331.00        |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Retrieve parameters from CRM 
    Given   I retrieve the latest EFA contract details from CRM for provider '10014020' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014020'

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10014020 | 10014020 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1    | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Released          | Released          | 53331.00    | EDSK-4020     | 1                 | CRM Integration       | CRM Integration       | ?                         |
     
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1    | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1    | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |


    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10014020 | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1    | 2_1            | AS-2122 | 1619                        | 53331.00    | [CofG_LA]    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                            | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1 | EDSK-4020    | 1               | 1                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014020 | EDSK-4020          | 1                     | 1                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10014020 | EDSK-4020          | 1                     | 0                        | Superseded Draft | ?                                        | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10014020 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation | 
    | 10014020 | EDSK-4020          | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 70949.00      | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-4020          | AY2122 | ?               | 10014020 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10014020 | ESFA-4020          | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10014020 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10014020 | EDSK-4020          | ALLB-4020             | ?                             | 17618.00        | 10014020      | 10014020 Co Ltd  | 01/08/2021 | 31/07/2022 | ALLB          | ALLB2122            | Contract Allocation   | ?                        |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                            | DeliverableDescription   |
    | EDSK-4020      | ALLB-4020       | 1               | 17618.00  | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | Total Advanced Learner Loans Bursary Funding               |                          |

 
   # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract 'EDSK-4020'

    # Check the contents of the Appendices
    And   the file named '10014020_EDSK-4020_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10014020 Co Ltd UKPRN: 10014020
    Master Contract Number: ESFA-4020
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Bursary ALLB-4020 £10,723 £6,895 £17,618
    Total Funding for this contract: £70,949
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10014020 Co Ltd
    Advanced Learner Loans
    Funding for
    16 to 19 Education
    Master Agreement Number ESFA-4020
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10014020 Co Ltd THE SECRETARY OF STATE FOR
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
    Company No: AA014020
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 8
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 12
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10014020 Co Ltd UKPRN: 10014020
    Master Contract Number: ESFA-4020 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: ALLB-4020
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Advanced Learner Loans Bursary Funding £17,618 £321 £1,561 £558 £849 £2,692 £1,847 £1,665 £1,230 £2,534 £2,322 £241 £1,798
    Total Funding £17,618 £321 £1,561 £558 £849 £2,692 £1,847 £1,665 £1,230 £2,534 £2,322 £241 £1,798
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLB-4020 – Page 1 Ref (for internal use only):  EDSK-4020 v1

    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (July 2021) – Page 1
    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (July 2021) – Page 1
    SCHEDULE 6: UK GDPR AND DATA PROTECTION
    EDSK Schedule 6 Version 2 (July 2021) – Page 1
    EDSK Schedule 6 Version 2 (July 2021) – Page 2
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 2 (July 2021) – Page 1
    EDSK Schedule 7 Version 2 (July 2021) – Page 7
    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 2 (July 2021) – Page 1
    EDSK Schedule 8 Version 2 (July 2021) – Page 5
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10014020_EDSK-4020_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'L020_1.pdf'


    # Retrieve parameters from CRM 
    Given   I retrieve the latest EFA contract details from CRM for provider '10014020' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014820'

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10014820
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10014020 | EDSK-4020          | [AllocRef_16ED]       | ?                             | 29885.00        | 10014820      | 10014820 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10014820
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | 10014820 | EDSK-4020      | [AllocRef_16ED]    | 2               | 0                     | 7086.00   | 0.00     | 0.00     | 2539.00  | 4547.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Programme Funding                                       |                          |
    | 10014820 | EDSK-4020      | [AllocRef_16ED]    | 13              | 0                     | 22799.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5773.00  | 4919.00  | 3081.00  | 4219.00  | 4807.00  | 0.00     | 0.00     | 0.00     | SSF Bursary Funds                                           |                          |

    # Check the contents of the Appendices for the Contracting Org 10014020
    Then  the file named '10014020_EDSK-4020_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10014020 Co Ltd UKPRN: 10014020
    Master Contract Number: ESFA-4020
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10014820 Co Ltd [AllocRef_16ED] £25,078 £4,807 £29,885
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10014820 Co Ltd UKPRN: 10014820
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Programme Funding £7,086 £0.00 £0.00 £2,539.00 £4,547.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF Bursary Funds £22,799 £0.00 £0.00 £0.00 £0.00 £5,773.00 £4,919.00 £3,081.00 £4,219.00 £4,807.00 £0.00 £0.00 £0.00
    Total Funding £29,885 £0.00 £0.00 £2,539.00 £4,547.00 £5,773.00 £4,919.00 £3,081.00 £4,219.00 £4,807.00 £0.00 £0.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-4020 v1
    """    

    # Retrieve parameters from CRM 
    Given   I retrieve the latest EFA contract details from CRM for provider '10014020' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014920'

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10014920
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10014020 | EDSK-4020          | [AllocRef_16ED]       | ?                             | 23446.00        | 10014920      | 10014920 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10014920
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | 10014920 | EDSK-4020      | [AllocRef_16ED]    | 2               | 0                     | 17542.00  | 5801.00  | 2030.00  | 0.00     | 4620.00  | 0.00     | 5091.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Programme Funding                                       |                          |
    | 10014920 | EDSK-4020      | [AllocRef_16ED]    | 13              | 0                     | 5904.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2546.00  | 3358.00  | 0.00     | 0.00     | SSF Bursary Funds                                           |                          |

    # Check the contents of the Appendices for the Contracting Org 10014020
    Then  the file named '10014020_EDSK-4020_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10014020 Co Ltd UKPRN: 10014020
    Master Contract Number: ESFA-4020
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10014920 Co Ltd [AllocRef_16ED] £17,542 £5,904 £23,446
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10014920 Co Ltd UKPRN: 10014920
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Programme Funding £17,542 £5,801.00 £2,030.00 £0.00 £4,620.00 £0.00 £5,091.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF Bursary Funds £5,904 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,546.00 £3,358.00 £0.00 £0.00
    Total Funding £23,446 £5,801.00 £2,030.00 £0.00 £4,620.00 £0.00 £5,091.00 £0.00 £0.00 £2,546.00 £3,358.00 £0.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-4020 v1
    """    


    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-4020      | 1                     | 1                        | 2021-06-11 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'EDSK-4020' for provider '10014020'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10014020 - 10014020 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract 'EDSK-4020' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10014020 | ESFA-4020          | EDSK-4020      | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10014020 | ESFA-4020          | EDSK-4020      | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |


    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '14/06/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-4020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-4020' and ContractNumber 'EDSK-4020' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-4020' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014020 | EDSK-4020          | 1                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10014020 | ESFA-4020          | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                |
    | 10014020 | 10014020 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-2_1    | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 53331.00    | EDSK-4020     | 1                 | CRM Integration       | CRM Integration           | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-4020' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                            | DeliverableDescription      |
    | 10014020 | EDSK-4020      | 1               | ALLB-4020        | 1               | 0                     | 17618.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding               |                             | 



    # Execute a NON-FINANCIAL amendment on EDSK-4020

    # Change the date
    Given the override date is '17/06/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2.
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'EDSK-4020' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014020 | EDSK-4020          | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10014020 | EDSK-4020          | 1                     | 1                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10014020 | EDSK-4020          | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10014020 | ESFA-4020          | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # 2nd FAs (UDA)

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    Given there is no data in the CFS stub
    #And   there is no data in the Funding Allocation PaaS tables

    # Populate the stub

    # Change the date 
    And the override date is '19/06/2021'

 
    # Funding Allocation THREE (DO_1619))
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10014020 | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-3_2  | 3_2            | 1619                        | AS-2122            | 58430.00          |

    # Provider Funding Allocation (DO_1619)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10014920-2_1  | 2_1                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-3_2  | 10014920      | Schoo        | 08SSF           | 23446.00                  |
    | 1619-AS-2122-10014820-3_2  | 3_2                    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-3_2  | 10014820      | Schoo        | 08SSF           | 34984.00                  |

    # Funding Allocation Line (aka Deliverable) (DO_1619)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10014920-2_1  | 1619-001        | 17542.00         | Payment         |
    | 1619-AS-2122-10014920-2_1  | 1619-002        | 5904.00          | Payment         |
    #
    | 1619-AS-2122-10014820-3_2  | 1619-001        | 7086.00          | Payment         |
    | 1619-AS-2122-10014820-3_2  | 1619-002        | 23799.00         | Payment         |
    | 1619-AS-2122-10014820-3_2  | 1619-024        | 4099.00          | Payment         |

    # Funding Allocation Profile Period (DO_1619)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10014920-2_1  | 1619-001        | FY-2122              | August                 | 2021               | 5801.00                   |
    | 1619-AS-2122-10014920-2_1  | 1619-001        | FY-2122              | September              | 2021               | 2030.00                   |
    | 1619-AS-2122-10014920-2_1  | 1619-001        | FY-2122              | November               | 2021               | 4620.00                   |
    | 1619-AS-2122-10014920-2_1  | 1619-001        | FY-2122              | January                | 2022               | 5091.00                   |
    | 1619-AS-2122-10014920-2_1  | 1619-002        | FY-2122              | April                  | 2022               | 2546.00                   |
    | 1619-AS-2122-10014920-2_1  | 1619-002        | FY-2122              | May                    | 2022               | 3358.00                   |
    #
    | 1619-AS-2122-10014820-3_2  | 1619-001        | FY-2122              | October                | 2021               | 2539.00                   |
    | 1619-AS-2122-10014820-3_2  | 1619-001        | FY-2122              | November               | 2021               | 4547.00                   |
    | 1619-AS-2122-10014820-3_2  | 1619-002        | FY-2122              | December               | 2021               | 5773.00                   |
    | 1619-AS-2122-10014820-3_2  | 1619-002        | FY-2122              | January                | 2022               | 4919.00                   |
    | 1619-AS-2122-10014820-3_2  | 1619-002        | FY-2122              | February               | 2022               | 3081.00                   |
    | 1619-AS-2122-10014820-3_2  | 1619-002        | FY-2122              | March                  | 2022               | 4219.00                   |
    | 1619-AS-2122-10014820-3_2  | 1619-002        | FY-2122              | April                  | 2022               | 5807.00                   |
    | 1619-AS-2122-10014820-3_2  | 1619-024        | FY-2122              | July                   | 2022               | 4099.00                   |



    # Change the date 
    Given the override date is '22/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM


    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10014020 | 10014020 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-3_2    | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 58430.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
     
    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-3_2    | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Check the state of a Release Group (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 58430.00        |


    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10014020 | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-3_2    | 3_2            | AS-2122 | 1619                        | 58430.00    | [CofG_LA]   |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'


    # Release a Funding Allocation (32333)

    # Change the date 
    Given the override date is '24/06/2021'

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |
    
    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 58430.00        |


    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    Then   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Retrieve parameters from CRM 
    Given   I retrieve the latest EFA contract details from CRM for provider '10014020' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014020'

    # Check the CRM Funding Allocations data 
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                            | FundingVersion | FundingType                | Period  | ContractType                            | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       | HoldReason                |
    | 10014020 | 10014020 Co Ltd  | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-3_2 | 3_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)      | 1619                        | 16-19ED2122     | Released          | Released          | 58430.00    | EDSK-4020     | 2                 | CRM Integration  | CRM Integration  | ?                         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10014020 | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-3_2    | 3_2            | AS-2122 | 1619                        | 58430.00    | [CofG_LA]   |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthoritySsf-10014020-3_2    | EDSK-4020  | 2               | 1                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014020 | EDSK-4020          | 2                     | 1                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10014020 | ESFA-4020          | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation | 
    | 10014020 | EDSK-4020          | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 76048.00      | 2                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | Variation     | Initiate Document Merge  | Yes                   | ESFA-4020          | AY2122 | ?               | 10014020 Co Ltd  | Active | Document Management Team  | 5099.00                |
    | 10014020 | ESFA-4020          | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10014020 Co Ltd  | Active | CRM Integration           | ?                      |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                            | DeliverableDescription   |
    | EDSK-4020      | ALLB-4020       | 1               | 17618.00  | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | Total Advanced Learner Loans Bursary Funding               |                          |

 
    # Check the contents of the Appendices
    And   the file named '10014020_EDSK-4020_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10014020 Co Ltd UKPRN: 10014020
    Master Contract Number: ESFA-4020
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Bursary ALLB-4020 £10,723 £6,895 £17,618
    Total Funding for this contract: £76,048
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10014020 Co Ltd
    Advanced Learner Loans
    Funding for
    16 to 19 Education
    Master Agreement Number ESFA-4020
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10014020 Co Ltd THE SECRETARY OF STATE FOR
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
    Company No: AA014020
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 8
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2021) – Page 12
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (July 2021) – Page 1
    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (July 2021) – Page 1
    SCHEDULE 6: UK GDPR AND DATA PROTECTION
    EDSK Schedule 6 Version 2 (July 2021) – Page 1
    EDSK Schedule 6 Version 2 (July 2021) – Page 2
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 2 (July 2021) – Page 1
    EDSK Schedule 7 Version 2 (July 2021) – Page 7
    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 2 (July 2021) – Page 1
    EDSK Schedule 8 Version 2 (July 2021) – Page 5
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10014020_EDSK-4020_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'L020_2.pdf'

    # Retrieve parameters from CRM 
    Given   I retrieve the latest EFA contract details from CRM for provider '10014020' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014820'

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10014820
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10014020 | EDSK-4020          | [AllocRef_16ED]       | ?                             | 34984.00        | 10014820      | 10014820 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 5099.00                  |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10014820
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | 10014820 | EDSK-4020      | [AllocRef_16ED]    | 2               | 0                     | 7086.00   | 0.00     | 0.00     | 2539.00  | 4547.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Programme Funding                                       |                          |
    | 10014820 | EDSK-4020      | [AllocRef_16ED]    | 13              | 0                     | 23799.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5773.00  | 4919.00  | 3081.00  | 4219.00  | 5807.00  | 0.00     | 0.00     | 0.00     | SSF Bursary Funds                                           |                          |
    | 10014820 | EDSK-4020      | [AllocRef_16ED]    | 151             | 0                     | 4099.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4099.00  | SSF High Value Courses School and College Leavers Uplift    |                          |

    
    # Check the contents of the Appendices for the Contracting Org 10014020
    Then  the file named '10014020_EDSK-4020_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10014020 Co Ltd UKPRN: 10014020
    Master Contract Number: ESFA-4020
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10014820 Co Ltd [AllocRef_16ED] £25,078 £9,906 £34,984
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10014820 Co Ltd UKPRN: 10014820
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    SSF Programme Funding £7,086 £0.00 £0.00 £2,539.00 £4,547.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF Bursary Funds £23,799 £0.00 £0.00 £0.00 £0.00 £5,773.00 £4,919.00 £3,081.00 £4,219.00 £5,807.00 £0.00 £0.00 £0.00
    SSF High Value Courses School and College £4,099 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £4,099.00
    Leavers Uplift
    Total Funding £34,984 £0.00 £0.00 £2,539.00 £4,547.00 £5,773.00 £4,919.00 £3,081.00 £4,219.00 £5,807.00 £0.00 £0.00 £4,099.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-4020 v2
    """    


    # Retrieve parameters from CRM 
    Given   I retrieve the latest EFA contract details from CRM for provider '10014020' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10014920'

    # Check that the Contract Allocations have been created correctly in CRM for Delivery Org 10014920
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType       | AllocationValueVariation |
    | 10014020 | EDSK-4020      | [AllocRef_16ED]       | ?                             | 23446.00        | 10014920      | 10014920 Co Ltd  | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation | 0.00                  |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM for Delivery Org 10014920
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef      | DeliverableCode | ParentDeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | 10014920 | EDSK-4020      | [AllocRef_16ED]    | 2               | 0                     | 17542.00  | 5801.00  | 2030.00  | 0.00     | 4620.00  | 0.00     | 5091.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Programme Funding                                       |                          |
    | 10014920 | EDSK-4020      | [AllocRef_16ED]    | 13              | 0                     | 5904.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2546.00  | 3358.00  | 0.00     | 0.00     | SSF Bursary Funds                                           |                          |
 
    # Check the contents of the Appendices for the Contracting Org 10014020
    Then  the file named '10014020_EDSK-4020_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10014020 Co Ltd UKPRN: 10014020
    Master Contract Number: ESFA-4020
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education
    10014920 Co Ltd [AllocRef_16ED] £17,542 £5,904 £23,446
    Summary of Funding – Page 1
    """    


    # Check the deliverable count in CRM
    Then  there are '72' deliverable period rows in CRM linked to the latest version of contract 'EDSK-4020'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-4020      | 2                     | 1                        | 2021-06-24 14:31:47.000 |


    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '27/06/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-4020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-4020' and ContractNumber 'EDSK-4020' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-4020' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10014020 | EDSK-4020          | 2                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10014020 | ESFA-4020          | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Tidy Up
    And   the override date is reset

