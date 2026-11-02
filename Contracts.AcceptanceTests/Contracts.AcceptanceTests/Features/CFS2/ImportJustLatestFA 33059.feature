Feature: ImportJustLatestFA 33059

@AcceptanceTest @Withdrawn20230123
@CFS
Scenario: A625 Populate stub with several versions of the same EDSK2122 Funding Allocation. Import, release and create contract from the latest version only
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017625'
    And   there is no Funding Allocation data in CRM for UKPRN '10017625'
    And   there is no Contract, Task or Workflow data for UKPRN '10017625'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017625' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (HEI)     |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017625' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017625 Co Ltd' with UKPRN '10017625' and OrgId 'ORG0017625' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017625' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017625 | 117625 | 10017625 Co Ltd | 0              | Active                | Yes           | AA017625      | ?             | 20 The Grove           | ?                      | ?                      | ?                      | Ikley                  | West Yorkshire         | L829 9EG  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017625 |





    # Populate the stub

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation (1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-1_3           | 1_3            | 1619                        | AS-2122            | 30041.00          |

    # Provider Funding Allocation (1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017625-1_3  | 1_3                    | 1619-AS-2122-Contract-Provider-10017625-1_3           | 10017625      | Furth        | 07HEP           | 30041.00                  |

    # Funding Allocation Line (aka Deliverable) (1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017625-1_3  | 1619-008        | 9687.00          | Payment         |
    | 1619-AS-2122-10017625-1_3  | 1619-009        | 5247.00          | Payment         |
    | 1619-AS-2122-10017625-1_3  | 1619-012        | 15107.00         | Payment         |

    # Funding Allocation Profile Period (1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017625-1_3  | 1619-008        | FY-2021              | January                | 2022              | 4189.00                   |
    | 1619-AS-2122-10017625-1_3  | 1619-008        | FY-2021              | May                    | 2022              | 5498.00                   |
    #
    | 1619-AS-2122-10017625-1_3  | 1619-009        | FY-2021              | August                 | 2021              | 5247.00                   |
    #
    | 1619-AS-2122-10017625-1_3  | 1619-012        | FY-2021              | October                | 2021              | 4720.00                   |
    | 1619-AS-2122-10017625-1_3  | 1619-012        | FY-2021              | February               | 2022              | 5650.00                   |
    | 1619-AS-2122-10017625-1_3  | 1619-012        | FY-2021              | July                   | 2022              | 4737.00                   |





    # Funding Allocation (2) 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-2_2           | 2_2            | 1619                        | AS-2122            | 46148.00          |

    # Provider Funding Allocation (2) 
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017625-2_2  | 2_2                    | 1619-AS-2122-Contract-Provider-10017625-2_2           | 10017625      | Furth        | 07HEP           | 46148.00                  |

    # Funding Allocation Line (aka Deliverable) (2) 
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017625-2_2  | 1619-002        | 3621.00          | Payment         |
    | 1619-AS-2122-10017625-2_2  | 1619-004        | 14220.00         | Payment         |
    | 1619-AS-2122-10017625-2_2  | 1619-008        | 28307.00         | Payment         |

    # Funding Allocation Profile Period (2) 
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017625-2_2  | 1619-002        | FY-2021              | February               | 2022              | 3621.00                   |
    #
    | 1619-AS-2122-10017625-2_2  | 1619-004        | FY-2021              | October                | 2021              | 2003.00                   |
    | 1619-AS-2122-10017625-2_2  | 1619-004        | FY-2021              | January                | 2022              | 4236.00                   |
    | 1619-AS-2122-10017625-2_2  | 1619-004        | FY-2021              | February               | 2022              | 2602.00                   |
    | 1619-AS-2122-10017625-2_2  | 1619-004        | FY-2021              | June                   | 2022              | 5379.00                   |
    #
    | 1619-AS-2122-10017625-2_2  | 1619-008        | FY-2021              | September              | 2021              | 5050.00                   |
    | 1619-AS-2122-10017625-2_2  | 1619-008        | FY-2021              | October                | 2021              | 5093.00                   |
    | 1619-AS-2122-10017625-2_2  | 1619-008        | FY-2021              | January                | 2022              | 4964.00                   |
    | 1619-AS-2122-10017625-2_2  | 1619-008        | FY-2021              | February               | 2022              | 5349.00                   |
    | 1619-AS-2122-10017625-2_2  | 1619-008        | FY-2021              | May                    | 2022              | 4195.00                   |
    | 1619-AS-2122-10017625-2_2  | 1619-008        | FY-2021              | July                   | 2022              | 3656.00                   |





    # Funding Allocation (3)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-3_5           | 3_5            | 1619                        | AS-2122            | 64900.00          |

    # Provider Funding Allocation (3)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017625-3_5  | 3_5                    | 1619-AS-2122-Contract-Provider-10017625-3_5           | 10017625      | Furth        | 07HEP           | 64900.00                  |

    # Funding Allocation Line (aka Deliverable) (3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017625-3_5  | 1619-003        | 10394.00         | Payment         |
    | 1619-AS-2122-10017625-3_5  | 1619-008        | 11903.00         | Payment         |
    | 1619-AS-2122-10017625-3_5  | 1619-009        | 3290.00          | Payment         |
    | 1619-AS-2122-10017625-3_5  | 1619-010        | 14780.00         | Payment         |
    | 1619-AS-2122-10017625-3_5  | 1619-011        | 3179.00          | Payment         |
    | 1619-AS-2122-10017625-3_5  | 1619-012        | 21354.00         | Payment         |

    # Funding Allocation Profile Period (3)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017625-3_5  | 1619-003        | FY-2021              | August                 | 2021              | 5121.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-003        | FY-2021              | January                | 2022              | 2086.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-003        | FY-2021              | April                  | 2022              | 3187.00                   |
    #
    | 1619-AS-2122-10017625-3_5  | 1619-008        | FY-2021              | August                 | 2021              | 3792.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-008        | FY-2021              | December               | 2021              | 2227.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-008        | FY-2021              | March                  | 2022              | 2921.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-008        | FY-2021              | May                    | 2022              | 2963.00                   |
    #
    | 1619-AS-2122-10017625-3_5  | 1619-009        | FY-2021              | November               | 2021              | 3290.00                   |
    #
    | 1619-AS-2122-10017625-3_5  | 1619-010        | FY-2021              | September              | 2021              | 3726.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-010        | FY-2021              | January                | 2022              | 3528.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-010        | FY-2021              | April                  | 2022              | 3058.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-010        | FY-2021              | May                    | 2022              | 4468.00                   |
    #
    | 1619-AS-2122-10017625-3_5  | 1619-011        | FY-2021              | December               | 2021              | 3179.00                   |
    #
    | 1619-AS-2122-10017625-3_5  | 1619-012        | FY-2021              | September              | 2021              | 4514.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-012        | FY-2021              | November               | 2021              | 5241.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-012        | FY-2021              | March                  | 2022              | 6000.00                   |
    | 1619-AS-2122-10017625-3_5  | 1619-012        | FY-2021              | July                   | 2022              | 5599.00                   |





    # Funding Allocation (4)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-4_1           | 4_1            | 1619                        | AS-2122            | 57255.00          |

    # Provider Funding Allocation (4)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017625-4_1  | 4_1                    | 1619-AS-2122-Contract-Provider-10017625-4_1           | 10017625      | Furth        | 07HEP           | 57255.00                  |

    # Funding Allocation Line (aka Deliverable) (4)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017625-4_1  | 1619-001        | 18946.00         | Payment         |
    | 1619-AS-2122-10017625-4_1  | 1619-002        | 16919.00         | Payment         |
    | 1619-AS-2122-10017625-4_1  | 1619-003        | 21390.00         | Payment         |

    # Funding Allocation Profile Period (4)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017625-4_1  | 1619-001        | FY-2021              | August                 | 2021              | 3717.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-001        | FY-2021              | December               | 2021              | 4240.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-001        | FY-2021              | February               | 2022              | 4795.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-001        | FY-2021              | April                  | 2022              | 2066.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-001        | FY-2021              | June                   | 2022              | 4128.00                   |
    #
    | 1619-AS-2122-10017625-4_1  | 1619-002        | FY-2021              | October                | 2021              | 2969.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-002        | FY-2021              | December               | 2021              | 3455.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-002        | FY-2021              | March                  | 2022              | 4935.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-002        | FY-2021              | May                    | 2022              | 5560.00                   |
    #
    | 1619-AS-2122-10017625-4_1  | 1619-003        | FY-2021              | September              | 2021              | 3999.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-003        | FY-2021              | November               | 2021              | 3838.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-003        | FY-2021              | January                | 2022              | 2444.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-003        | FY-2021              | March                  | 2022              | 5564.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-003        | FY-2021              | May                    | 2022              | 3144.00                   |
    | 1619-AS-2122-10017625-4_1  | 1619-003        | FY-2021              | July                   | 2022              | 2401.00                   |





    # Change the date 
    Given the override date is '18/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (HEI)     | CofG_HEI                  |

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017625 | 10017625 Co Ltd  | 1619-AS-2122-Contract-Provider-10017625-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 57255.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2122-Contract-Provider-10017625-4_1             | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-4_1             | 4_1            | AS-2122 | 1619                        | 57255.00    | [CofG_HEI]      | ?                 | ?                     |
    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-3_5             | 3_5            | AS-2122 | 1619                        | 64900.00    | ?               | Discarded         | Superseded            |
    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-2_2             | 2_2            | AS-2122 | 1619                        | 46148.00    | ?               | Discarded         | Superseded            |
    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-1_3             | 1_3            | AS-2122 | 1619                        | 30041.00    | ?               | Discarded         | Superseded            |

    # Check the state of a Release Group (J129)
    And   Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 57255.00        |


   


    # Release a Release Group (32333)

    # Change the date 
    Given the override date is '19/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_HEI]        |
    
    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 57255.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017625' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017625' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017625 | 10017625 Co Ltd  | 1619-AS-2122-Contract-Provider-10017625-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Released          | Released          | 57255.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2122-Contract-Provider-10017625-4_1             | Release Successful   | CRM Integration   | Released       | Released             | Scheduling     | Awaiting Release     |
#   | 1619-AS-2122-Contract-Provider-10017625-4_1             | Initiate Release     | CRM Integration   | In Release     | Release in Progress  | Scheduling     | Awaiting Release     |
    | 1619-AS-2122-Contract-Provider-10017625-4_1             | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus             |
    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-4_1             | 4_1            | AS-2122 | 1619                        | 57255.00    | [CofG_HEI]      | ?                 | ?                     |
    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-3_5             | 3_5            | AS-2122 | 1619                        | 64900.00    | ?               | Discarded         | Superseded            |
    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-2_2             | 2_2            | AS-2122 | 1619                        | 46148.00    | ?               | Discarded         | Superseded            |
    | 10017625 | 1619-AS-2122-Contract-Provider-10017625-1_3             | 1_3            | AS-2122 | 1619                        | 30041.00    | ?               | Discarded         | Superseded            |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017625-4_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017625 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017625 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017625 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 57255.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017625 Co Ltd  | Active | Document Management Team  |
    | 10017625 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017625 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017625 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 57255.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 18946.00  | 3717.00  | 0.00     | 0.00     | 0.00     | 4240.00  | 0.00     | 4795.00  | 0.00     | 2066.00  | 0.00     | 4128.00  | 0.00     | 16-19 Programme Funding                        |                          |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 16919.00  | 0.00     | 0.00     | 2969.00  | 0.00     | 3455.00  | 0.00     | 0.00     | 4935.00  | 0.00     | 5560.00  | 0.00     | 0.00     | 16-19 Bursary Funds                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 21390.00  | 0.00     | 3999.00  | 0.00     | 3838.00  | 0.00     | 2444.00  | 0.00     | 5564.00  | 0.00     | 3144.00  | 0.00     | 2401.00  | Residential Bursary Fund                       |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#   # Check the contents of the Appendices
#   And   the file named '10017625_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
#   """
#   blah
#   """
#
#   # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017625_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A625.pdf'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017625 - 10017625 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017625 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





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
    | 10017625 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017625 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           |
    | 10017625 | 10017625 Co Ltd  | 1619-AS-2122-Contract-Provider-10017625-4_1             | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 57255.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017625 | [ContractNo]   | 1               | [AllocRef_16ED]  | 20              | 0                     | 18946.00     | 0             | 0        | 16-19 Programme Funding                        | ?                           |
    | 10017625 | [ContractNo]   | 1               | [AllocRef_16ED]  | 19              | 0                     | 16919.00     | 0             | 0        | 16-19 Bursary Funds                            | ?                           |
    | 10017625 | [ContractNo]   | 1               | [AllocRef_16ED]  | 33              | 0                     | 21390.00     | 0             | 0        | Residential Bursary Fund                       | ?                           |


    # Tidy Up
    And   the override date is reset

