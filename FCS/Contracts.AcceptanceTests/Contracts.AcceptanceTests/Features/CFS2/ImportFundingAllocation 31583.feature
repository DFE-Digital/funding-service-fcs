Feature: ImportFundingAllocation 31583

@AcceptanceTest @Withdrawn20210512
Scenario: A055 Import a 1619ED CFS Funding Allocation. Check FA and FA Workflow History
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018057'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019057'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017055'
    And   there is no Funding Allocation data in CRM for UKPRN '10018057'
    And   there is no Funding Allocation data in CRM for UKPRN '10019057'
    And   there is no Funding Allocation data in CRM for UKPRN '10017055'
    And   there is no Contract, Task or Workflow data for UKPRN '10018057' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019057' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017055' 

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables


    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10018057' 
    And   there is no Organisation data for UKPRN '10019057' 
    And   there is no Organisation data for UKPRN '10017055' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10018057 Co Ltd' with UKPRN '10018057' and OrgId 'ORG0018057' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10019057 Co Ltd' with UKPRN '10019057' and OrgId 'ORG0019057' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017055 Co Ltd' with UKPRN '10017055' and OrgId 'ORG0017055' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018057 | 118057 | 10018057 Co Ltd | 0              | Active                | Yes           | AA018057      | ?             | 17 High Street         | Cobham                 | Surrey                 | ?                      | ?                      | ?                      | KT11 3DH  |
    | 10019057 | 119057 | 10019057 Co Ltd | 0              | Active                | Yes           | AA019057      | ?             | 61a High Street        | Cobham                 | Surrey                 | ?                      | ?                      | ?                      | KT11 3DH  |
    | 10017055 | 117055 | 10017055 Co Ltd | 0              | Active                | Yes           | AA017055      | ?             | 25 High Street         | Cobham                 | Surrey                 | ?                      | ?                      | ?                      | KT11 3DH  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018057 |
    | 10019057 |
    | 10017055 |




    # Change the date 
    Given the override date is '16/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | FundingStreamCode | TotalFundingValue |
    | Contracting    | 10018057 | 1619-AY-2021-Contract-Provider-10018057-1_1       | 1_1            | 1619              | 11005.00          |
    | Contracting    | 10019057 | PSG-AY-2021-Contract-Provider-10019057-1_0        | 1_0            | PSG               | 19882.00          |
    | Contracting    | 10017055 | BlahBlahBlahBlah                                  | 2_4            | xyz               | 12612.00          |

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status      | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10018057 | 10018057 Co Ltd  | 1619-AY-2021-Contract-Provider-10018057-1_1       | 1_1            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling  | Awaiting Release  | 11005.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10019057 | 10019057 Co Ltd  | PSG-AY-2021-Contract-Provider-10019057-1_0        | 1_0            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | PSG                         | 16-19ED2021     | Scheduling  | Awaiting Release  | 19882.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017055 | 10017055 Co Ltd  | BlahBlahBlahBlah                                  | 2_4            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | xyz                         | 16-19ED2021     | Scheduling  | Awaiting Release  | 12612.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | 1619-AY-2021-Contract-Provider-10018057-1_1       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |
    | PSG-AY-2021-Contract-Provider-10019057-1_0        | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |
    | BlahBlahBlahBlah                                  | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |

    # Check PaaS table FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | 
    | 10018057 | 1619-AY-2021-Contract-Provider-10018057-1_1       | 1_1            | AY-2021 | 1619                        | 11005.00    | [CofG_College] | 
    | 10019057 | PSG-AY-2021-Contract-Provider-10019057-1_0        | 1_0            | AY-2021 | PSG                         | 19882.00    | [CofG_College] | 
    | 10017055 | BlahBlahBlahBlah                                  | 2_4            | AY-2021 | xyz                         | 12612.00    | [CofG_College] | 


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210115
Scenario: A056 Import 3x 1619ED CFS Funding Allocations then release one. Check docs, CRM, PaaS, FA and FA Workflow History
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018057'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019057'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017056'
    And   there is no Funding Allocation data in CRM for UKPRN '10018057'
    And   there is no Funding Allocation data in CRM for UKPRN '10019057'
    And   there is no Funding Allocation data in CRM for UKPRN '10017056'
    And   there is no Contract, Task or Workflow data for UKPRN '10018057' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019057' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017056' 

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10018057' 
    And   there is no Organisation data for UKPRN '10019057' 
    And   there is no Organisation data for UKPRN '10017056' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10018057 Co Ltd' with UKPRN '10018057' and OrgId 'ORG0018057' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10019057 Co Ltd' with UKPRN '10019057' and OrgId 'ORG0019057' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017056 Co Ltd' with UKPRN '10017056' and OrgId 'ORG0017056' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018057 | 118057 | 10018057 Co Ltd | 0              | Active                | Yes           | AA018057      | ?             | 17 High Street         | Cobham                 | Surrey                 | ?                      | ?                      | ?                      | KT11 3DH  |
    | 10019057 | 119057 | 10019057 Co Ltd | 0              | Active                | Yes           | AA019057      | ?             | 61a High Street        | Cobham                 | Surrey                 | ?                      | ?                      | ?                      | KT11 3DH  |
    | 10017056 | 117056 | 10017056 Co Ltd | 0              | Active                | Yes           | AA017056      | ?             | 1 Bennell court        | West Street            | Camberton              | Cambridge              | ?                      | ?                      | CB3 7DS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018057 |
    | 10019057 |
    | 10017056 |




    # Change the date 
    Given the override date is '16/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                   | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018057 | 1619-AY-2021-Contract-Provider-10018057-1_2 | 1_2            | 1619                        | AY-2021            | 14558.00          |
    | Contracting    | 10019057 | 1619-AY-2021-Contract-Provider-10019057-3_6 | 3_6            | 1619                        | AY-2021            | 14240.00          |
    | Contracting    | 10017056 | 1619-AY-2021-Contract-Provider-10017056-2_2 | 2_2            | 1619                        | AY-2021            | 16408.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId         | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AY-2021-10018057-1_2 | 1_2                    | 1619-AY-2021-Contract-Provider-10018057-1_2 | 10018057      | Furth        | 01GFE           | 14558.00                  |
    | 1619-AY-2021-10019057-3_6 | 3_6                    | 1619-AY-2021-Contract-Provider-10019057-3_6 | 10019057      | Furth        | 01GFE           | 14240.00                  |
    | 1619-AY-2021-10017056-2_2 | 2_2                    | 1619-AY-2021-Contract-Provider-10017056-2_2 | 10017056      | Furth        | 01GFE           | 16408.00                  |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AY-2021-10018057-1_2  | 1619-001        | 14558.00         | Payment         |
    | 1619-AY-2021-10019057-3_6  | 1619-001        | 14240.00         | Payment         |
    | 1619-AY-2021-10017056-2_2  | 1619-001        | 16408.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AY-2021-10018057-1_2  | 1619-001        | FY-2021              | October                | 2020              | 5610.00                   |
    | 1619-AY-2021-10018057-1_2  | 1619-001        | FY-2021              | January                | 2021              | 2609.00                   |
    | 1619-AY-2021-10018057-1_2  | 1619-001        | FY-2021              | April                  | 2021              | 2550.00                   |
    | 1619-AY-2021-10018057-1_2  | 1619-001        | FY-2021              | May                    | 2021              | 3789.00                   |
    #
    | 1619-AY-2021-10019057-3_6  | 1619-001        | FY-2021              | September              | 2020              | 2657.00                   |
    | 1619-AY-2021-10019057-3_6  | 1619-001        | FY-2021              | November               | 2020              | 2770.00                   |
    | 1619-AY-2021-10019057-3_6  | 1619-001        | FY-2021              | March                  | 2021              | 3496.00                   |
    | 1619-AY-2021-10019057-3_6  | 1619-001        | FY-2021              | May                    | 2021              | 5317.00                   |
    #
    | 1619-AY-2021-10017056-2_2  | 1619-001        | FY-2021              | September              | 2020              | 5705.00                   |
    | 1619-AY-2021-10017056-2_2  | 1619-001        | FY-2021              | December               | 2020              | 6821.00                   |
    | 1619-AY-2021-10017056-2_2  | 1619-001        | FY-2021              | February               | 2021              | 3882.00                   |
    | 1619-AY-2021-10017056-2_2  | 1619-001        | FY-2021              | March                  | 2021              | 0.00                      |



    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10018057 | 10018057 Co Ltd  | 1619-AY-2021-Contract-Provider-10018057-1_2       | 1_2            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 14558.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10019057 | 10019057 Co Ltd  | 1619-AY-2021-Contract-Provider-10019057-3_6       | 3_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 14240.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10017056 | 10017056 Co Ltd  | 1619-AY-2021-Contract-Provider-10017056-2_2       | 2_2            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 16408.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AY-2021-Contract-Provider-10018057-1_2       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | 1619-AY-2021-Contract-Provider-10019057-3_6       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | 1619-AY-2021-Contract-Provider-10017056-2_2       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10018057 | 1619-AY-2021-Contract-Provider-10018057-1_2       | 1_2            | AY-2021 | 1619                        | 14558.00    | [CofG_College] |
    | 10019057 | 1619-AY-2021-Contract-Provider-10019057-3_6       | 3_6            | AY-2021 | 1619                        | 14240.00    | [CofG_College] |
    | 10017056 | 1619-AY-2021-Contract-Provider-10017056-2_2       | 2_2            | AY-2021 | 1619                        | 16408.00    | [CofG_College] |





    # Release a Release Group (32953)

    # Change the date
    Given the override date is '22/06/2021'

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017056' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status      | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017056 | 10017056 Co Ltd  | 1619-AY-2021-Contract-Provider-10017056-2_2       | 2_2            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2021     | Released    | Released          | 16408.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | 1619-AY-2021-Contract-Provider-10018057-1_2       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |
    | 1619-AY-2021-Contract-Provider-10019057-3_6       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |
    #
    | 1619-AY-2021-Contract-Provider-10017056-2_2       | Release Successful   | CRM Integration   | Released       | Released              | Scheduling     | Release in Progress   |
 #  | 1619-AY-2021-Contract-Provider-10017056-2_2       | Initiate Release     | FCS8 Test         | Released       | Released              | In Release     | Release in Progress   |
 #  | 1619-AY-2021-Contract-Provider-10017056-2_2       | Initiate Release     | FCS8 Test         | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | 1619-AY-2021-Contract-Provider-10017056-2_2       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017056 | 1619-AY-2021-Contract-Provider-10017056-2_2       | 2_2            | AY-2021 | 1619                        | 16408.00    | [CofG_College] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AY-2021-Contract-Provider-10017056-2_2       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM (Wait for the contract to be created)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017056 | [ContractNo]       | 1                     | 0                        | Draft          | Awaiting Documentation | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017056 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                      | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check contract has been created correctly
    And   the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                            | Period |
    | 10017056 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 16408.00      | Conditions of Funding (Grant) (College) | 2021   |
                                                                              
    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10017056 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2020          | 31/07/2021        | 16408.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName            | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 16408.00  | 0.00     | 5705.00  | 0.00     | 0.00     | 6821.00  | 0.00     | 3882.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Programme Funding    |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the contents of the Appendices
    Then  the file named '10017056_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017056 Co Ltd UKPRN: 10017056
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    16 to 19 Education [AllocRef_16ED] £16,408 £0 £16,408
    Total Funding for this contract: £16,408
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017056 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    EDSK Version 1 (April 2021) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017056 Co Ltd THE SECRETARY OF STATE FOR
    1 Bennell court EDUCATION ACTING THROUGH
    West Street THE EDUCATION AND SKILLS
    Camberton FUNDING AGENCY, AN
    Cambridge EXECUTIVE AGENCY OF THE
    AND
    CB3 7DS DEPARTMENT OF EDUCATION
    CHEYLESMORE HOUSE
    QUINTON ROAD
    Company No: AA017056 COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 1 (April 2021) Page 2
    EDSK Version 1 (April 2021) Page 79

    EDSK2122_S1_1619ED_COLLEGE_2021-08-01.docx

    EDSK2122_S2_1619ED_COFG_2021-08-01.docx
       
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017056 Co Ltd UKPRN: 10017056
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    16-19 Programme Funding £16,408 £0.00 £5,705.00 £0.00 £0.00 £6,821.00 £0.00 £3,882.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £16,408 £0.00 £5,705.00 £0.00 £0.00 £6,821.00 £0.00 £3,882.00 £0.00 £0.00 £0.00 £0.00 £0.00
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
    SCHEDULE 9: COLLEGE GOVERNANCE
    EDSK Schedule 9 Version 2 (July 2020) – Page 1
    EDSK Schedule 9 Version 2 (July 2020) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017056_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A056.pdf'

    # Check the deliverable count in CRM
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017056 - 10017056 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017056 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    


#    # CDA 
#
#    # Check the contents of the CDA report
#    Given there is no CDA report named 'CDA Latest Version A056.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version               | Suffix |
#    | 1619ED2021           | Latest Version        | A056   |
#
#    Then  a report named 'CDA Latest Version A056.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 8                 | 2020            | 2020/21       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Aug              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 9                 | 2020            | 2020/21       |              | 5705         |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Sep              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 10                | 2020            | 2020/21       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Oct              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 11                | 2020            | 2020/21       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Nov              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 12                | 2020            | 2020/21       |              | 6821         |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Dec              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 1                 | 2021            | 2020/21       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Jan              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 2                 | 2021            | 2020/21       |              | 3882         |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Feb              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 3                 | 2021            | 2020/21       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Mar              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 4                 | 2021            | 2021/22       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Apr              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 5                 | 2021            | 2021/22       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | May              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 6                 | 2021            | 2021/22       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Jun              |
#    | 1619ED2021              | 10017056 | 10017056 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/07/2021                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 7                 | 2021            | 2021/22       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Jul              |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A057 Import 3x 1619ED CFS Funding Allocations then release one. Approve contract. Bulk amend to add ALLB. Approve. Check docs, CRM, PaaS, FA and FA Workflow History and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017057'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018057'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019057'
    And   there is no Funding Allocation data in CRM for UKPRN '10017057'
    And   there is no Funding Allocation data in CRM for UKPRN '10018057'
    And   there is no Funding Allocation data in CRM for UKPRN '10019057'
    And   there is no Contract, Task or Workflow data for UKPRN '10017057' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018057' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019057' 

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |
    
    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Sharepoint 
    And   there are no files prefixed '10017057' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017057' 
    And   there is no Organisation data for UKPRN '10018057' 
    And   there is no Organisation data for UKPRN '10019057' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10017057 Co Ltd' with UKPRN '10017057' and OrgId 'ORG0017057' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018057 Co Ltd' with UKPRN '10018057' and OrgId 'ORG0018057' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10019057 Co Ltd' with UKPRN '10019057' and OrgId 'ORG0019057' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017057 | 117057 | 10017057 Co Ltd | 0              | Active                | Yes           | AA017057      | ?             | 28 Stainburn Avenue    | Moortown               | Leeds                  | ?                      | ?                      | ?                      | LS17 6PG  |
    | 10018057 | 118057 | 10018057 Co Ltd | 0              | Active                | Yes           | AA018057      | ?             | 17 High Street         | Cobham                 | Surrey                 | ?                      | ?                      | ?                      | KT11 3DH  |
    | 10019057 | 119057 | 10019057 Co Ltd | 0              | Active                | Yes           | AA019057      | ?             | 61a High Street        | Cobham                 | Surrey                 | ?                      | ?                      | ?                      | KT11 3DH  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017057 |
    | 10018057 |
    | 10019057 |





    # Change the date 
    Given the override date is '16/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                   | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017057 | 1619-AS-2122-Contract-Provider-10017057-5_1 | 5_1            | 1619                        | AS-2122            | 16929.00          |
    | Contracting    | 10018057 | 1619-AS-2122-Contract-Provider-10018057-1_2 | 1_2            | 1619                        | AS-2122            | 14558.00          |
    | Contracting    | 10019057 | 1619-AS-2122-Contract-Provider-10019057-3_6 | 3_6            | 1619                        | AS-2122            | 14240.00          |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId         | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue | 
    | 1619-AS-2122-10017057-5_1 | 5_1                    | 1619-AS-2122-Contract-Provider-10017057-5_1 | 10017057      | Furth        | 01GFE           | 16929.00                  | 
    | 1619-AS-2122-10018057-1_2 | 1_2                    | 1619-AS-2122-Contract-Provider-10018057-1_2 | 10018057      | Furth        | 01GFE           | 14558.00                  | 
    | 1619-AS-2122-10019057-3_6 | 3_6                    | 1619-AS-2122-Contract-Provider-10019057-3_6 | 10019057      | Furth        | 01GFE           | 14240.00                  | 

    # Funding Allocation Line  (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017057-5_1  | 1619-001        | 16929.00         | Payment         |
    | 1619-AS-2122-10018057-1_2  | 1619-001        | 14558.00         | Payment         |
    | 1619-AS-2122-10019057-3_6  | 1619-001        | 14240.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017057-5_1  | 1619-001        | FY-2122              | October                | 2021              | 3810.00                   |
    | 1619-AS-2122-10017057-5_1  | 1619-001        | FY-2122              | December               | 2021              | 4227.00                   |
    | 1619-AS-2122-10017057-5_1  | 1619-001        | FY-2122              | March                  | 2022              | 4852.00                   |
    | 1619-AS-2122-10017057-5_1  | 1619-001        | FY-2122              | June                   | 2022              | 4040.00                   |
    #
    | 1619-AS-2122-10018057-1_2  | 1619-001        | FY-2122              | October                | 2021              | 5710.00                   |
    | 1619-AS-2122-10018057-1_2  | 1619-001        | FY-2122              | January                | 2022              | 2609.00                   |
    | 1619-AS-2122-10018057-1_2  | 1619-001        | FY-2122              | April                  | 2022              | 2550.00                   |
    | 1619-AS-2122-10018057-1_2  | 1619-001        | FY-2122              | May                    | 2022              | 3789.00                   |
    #
    | 1619-AS-2122-10019057-3_6  | 1619-001        | FY-2122              | September              | 2021              | 2657.00                   |
    | 1619-AS-2122-10019057-3_6  | 1619-001        | FY-2122              | November               | 2021              | 2770.00                   |
    | 1619-AS-2122-10019057-3_6  | 1619-001        | FY-2122              | March                  | 2022              | 3496.00                   |
    | 1619-AS-2122-10019057-3_6  | 1619-001        | FY-2122              | May                    | 2022              | 5317.00                   |

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017057 | 10017057 Co Ltd  | 1619-AS-2122-Contract-Provider-10017057-5_1       | 5_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 16929.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10018057 | 10018057 Co Ltd  | 1619-AS-2122-Contract-Provider-10018057-1_2       | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 14558.00    | ?             | ?                 | CRM Integration  | CRM Integration  |
    | 10019057 | 10019057 Co Ltd  | 1619-AS-2122-Contract-Provider-10019057-3_6       | 3_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 14240.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2122-Contract-Provider-10017057-5_1       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | 1619-AS-2122-Contract-Provider-10018057-1_2       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |
    | 1619-AS-2122-Contract-Provider-10019057-3_6       | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Capture the [ReleaseGroup] parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |
    
    # Check PaaS FundingAllocation.FundingAllocation and .Contract
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | 
    | 10017057 | 1619-AS-2122-Contract-Provider-10017057-5_1       | 5_1            | AS-2122 | 1619                        | 16929.00    | [CofG_College] |
    | 10018057 | 1619-AS-2122-Contract-Provider-10018057-1_2       | 1_2            | AS-2122 | 1619                        | 14558.00    | [CofG_College] |
    | 10019057 | 1619-AS-2122-Contract-Provider-10019057-3_6       | 3_6            | AS-2122 | 1619                        | 14240.00    | [CofG_College] |





    # Release the Release Group

    # Change the date
    Given the override date is '22/06/2021'

    # Capture the Release Group value (J127)
    And   the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Release Funding Allocations from Contract Control
    When  a request is triggered to release the following Release Group
    | ReleaseGroup     |
    | [CofG_College]   |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017057' for FundingType 'EDSK' and period '2122'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period   | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017057 | 10017057 Co Ltd  | 1619-AS-2122-Contract-Provider-10017057-5_1       | 5_1            | Education & Skills Funding | AY2122   | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 16929.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | 1619-AS-2122-Contract-Provider-10017057-5_1       | Release Successful   | CRM Integration   | Released       | Released              | Scheduling     | Awaiting Release      |
#   | 1619-AS-2122-Contract-Provider-10017057-5_1       | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | 1619-AS-2122-Contract-Provider-10017057-5_1       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |
    #
    | 1619-AS-2122-Contract-Provider-10018057-1_2       | Release Successful   | CRM Integration   | Released       | Released              | Scheduling     | Awaiting Release      |
#   | 1619-AS-2122-Contract-Provider-10018057-1_2       | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | 1619-AS-2122-Contract-Provider-10018057-1_2       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |
    #
    | 1619-AS-2122-Contract-Provider-10019057-3_6       | Release Successful   | CRM Integration   | Released       | Released              | Scheduling     | Awaiting Release      |
#   | 1619-AS-2122-Contract-Provider-10019057-3_6       | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | 1619-AS-2122-Contract-Provider-10019057-3_6       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017057 | 1619-AS-2122-Contract-Provider-10017057-5_1       | 5_1            | AS-2122 | 1619                        | 16929.00    | [CofG_College] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017057-5_1       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017057 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017057 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
    | 10017057 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2021        | 31/07/2022      | 16929.00      | Conditions of Funding (Grant) (College)   | 2122   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10017057 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2021          | 31/07/2022        | 16929.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName            | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 20              | 16929.00  | 0.00     | 0.00     | 3810.00  | 0.00     | 4227.00  | 0.00     | 0.00     | 4852.00  | 0.00     | 0.00     | 4040.00  | 0.00     | 16-19 Programme Funding    |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the contents of the Appendices
    And   the file named '10017057_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017057 Co Ltd UKPRN: 10017057
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £12,889 £4,040 £16,929
    Total Funding for this contract: £16,929
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017057 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017057 Co Ltd THE SECRETARY OF STATE FOR
    28 Stainburn Avenue EDUCATION
    Moortown DEPARTMENT FOR EDUCATION
    Leeds AND 20 GREAT SMITH STREET
    LS17 6PG LONDON
    SW1P 3BT
    Company No: AA017057
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 79

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 11
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017057 Co Ltd UKPRN: 10017057
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £16,929 £0.00 £0.00 £3,810.00 £0.00 £4,227.00 £0.00 £0.00 £4,852.00 £0.00 £0.00 £4,040.00 £0.00
    Total Funding £16,929 £0.00 £0.00 £3,810.00 £0.00 £4,227.00 £0.00 £0.00 £4,852.00 £0.00 £0.00 £4,040.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017057_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A057v1.pdf'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017057'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017057 - 10017057 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                           | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017057 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated) | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





#    # CDA 
#
#    # Check the contents of the CDA report
#    Given there is no CDA report named 'CDA Latest Version A057.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version               | Suffix |
#    | 1619ED2122           | Latest Version        | A057   |
#
#    Then  a report named 'CDA Latest Version A057.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 8                 | 2021            | 2021/22       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Aug              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 9                 | 2021            | 2021/22       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Sep              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 10                | 2021            | 2021/22       |              | 3810         |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Oct              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 11                | 2021            | 2021/22       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Nov              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 12                | 2021            | 2021/22       |              | 4227         |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Dec              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 1                 | 2022            | 2021/22       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Jan              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 2                 | 2022            | 2021/22       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Feb              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 3                 | 2022            | 2021/22       |              | 4852         |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Mar              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 4                 | 2022            | 2022/23       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Apr              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 5                 | 2022            | 2022/23       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | May              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 6                 | 2022            | 2022/23       |              | 4040         |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Jun              |
#    | 1619ED2122              | 10017057 | 10017057 Co Ltd             |               |                             | [AllocRef_16ED]          | [ContractNo]   | [MasterContractNo]      | 01/08/2021                  | 31/07/2022                | 1                     | Draft          | Awaiting Documentation  |                                                      | 16-19 Programme Funding                                         |                                                                 | 7                 | 2022            | 2022/23       |              | 0            |              |               |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Jul              |





    # Publish and approve v1 (32385)

    # Change the date
    Given the override date is '26/06/2021'

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
    | 10017057 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017057 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017057 | 10017057 Co Ltd  | 1619-AS-2122-Contract-Provider-10017057-5_1       | 5_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 16929.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus         | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | 1619-AS-2122-Contract-Provider-10017057-5_1       | Contract Approved    | CRM Integration   | Contract Approved | Contract Approved     | Released       | Released              |
    | 1619-AS-2122-Contract-Provider-10017057-5_1       | Release Successful   | CRM Integration   | Released          | Released              | Scheduling     | Awaiting Release      |
#   | 1619-AS-2122-Contract-Provider-10017057-5_1       | Initiate Release     | CRM Integration   | In Release        | Release in Progress   | Scheduling     | Awaiting Release      |
    | 1619-AS-2122-Contract-Provider-10017057-5_1       | Record Imported      | CRM Integration   | Scheduling        | Awaiting Release      | ?              | ?                     |





    # Bulk amendment to add ALLB alloc (32385)

    # Change the date
    Given the override date is '03/07/2021'

    # Bulk file
    And   there are no files prefixed '10017057' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 16062021141516 v3_A057' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 16062021141516 v3_A057' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 16062021141516 v3_A057' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 16062021141516 v3_A057' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 16062021141516 v3_A057.xlsx' exists in the Datafiles folder and UKPRN '10017057' is present in cell 'A2' of the Contract tab
 #  When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017057' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices (Four doc parts: SoF, S1 Loans, S2 Loans, FA Loans)
    Then  the file named '10017057_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017057 Co Ltd UKPRN: 10017057
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Bursary [AllocRef_ALLB] £18,282 £16,718 £35,000
    16 to 19 Education [AllocRef_16ED] £12,889 £4,040 £16,929
    Total Funding for this contract: £51,929
    Summary of Funding – Page 1
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 9
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 2
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017057 Co Ltd UKPRN: 10017057
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Advanced Learner Loans Bursary Funding £35,000 £2,151 £1,002 £3,542 £2,067 £655 £2,778 £4,360 £1,727 £1,674 £7,672 £5,581 £1,791
    Total Funding £35,000 £2,151 £1,002 £3,542 £2,067 £655 £2,778 £4,360 £1,727 £1,674 £7,672 £5,581 £1,791
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017057_[ContractNo]_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A057v2.pdf'

    # Contract status is now at 'Awaiting Documentation





    # Publish and approve v2 (32385)

    # Change the date
    Given the override date is '05/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017057 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017057 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017057 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (12 + 48)
    And   there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the CRM Funding Allocations data (Unchanged)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017057 | 10017057 Co Ltd  | 1619-AS-2122-Contract-Provider-10017057-5_1       | 5_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 16929.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Write the value of the ReleaseGroupParameter to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017057 | 1619-AS-2122-Contract-Provider-10017057-5_1             | 5_1            | AS-2122 | 1619                        | 16929.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract (Unchanged)
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017057-5_1       | [ContractNo] | 1               | 0                  | Yes            |




    # Check the CM and ADP feeds for approval events

    # Check contents of the ContractManagement.AtomFeedItem (CM) feed for a Type 0 (Approval) event messages for v1 and v2
   #And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version 'n' of actual contract number 'APPLEVY-125'
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '1' of contract number '[ContractNo]'
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '2' of contract number '[ContractNo]'

    # Contract Schema check
   #And   the ItemType '0' event for version 'n' of actual contract number 'APPLEVY-125' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
    And   the ItemType '0' event for version '1' of contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
    And   the ItemType '0' event for version '2' of contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
  
    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for type 0 (New Approval) event
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | NewContractAllocationApproved     | 0      | [ContractNo]   | [AllocRef_16ED]  | 1                     |
    | AmendedContractAllocationApproved | 1      | [ContractNo]   | [AllocRef_16ED]  | 2                     |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Manual
Scenario: A066 Create a 3-alloc 2021 AEBP contract then bulk update draft with parameters in the bulk file (To help with manual checking)
    Given there are no allocations marked as Under Termination for UKPRN '10017066' 
    And   there are no terminated or closed allocations for UKPRN '10017066' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017066' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017066' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017066' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-066      |
    | AEBR-066      |
    | AETL-066      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-066      |
    | AEBR-066      |
    | AETL-066      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRLS2021    |
    | AEB-19TRN2021     |
    | AEB-AS2021        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-066       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017066'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017066' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017066 Co Ltd' with UKPRN '10017066' and OrgId 'ORG0017066' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017066' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017066 | 117066 | 10017066 Co Ltd | 0              | Active                | Yes           | AA017066      | ?             | 6 Eghams Court         | Boston Drive           | ?                      | ?                      | Bourne End             | Buckinghamshire        | SL8 5YS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017066 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription    | ContractType      | Period | CRMIntent    | OrgId      |
    | 10017066 | 10017066 Co Ltd      | ESFA-066             | AEBP-066       | 1                     | 01/08/2020        | 31/07/2021      | 69316.00      |                        | Procured          | 2021   | New          | ORG0017066 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017066 | AEBP-066       | AEBA-066      | AEB-AS            | AEB-AS2021              | AY                      | 01/08/2020          | 31/07/2021        | 27754.00        |             |            |                         | New          |             |
    | 10017066 | AEBP-066       | AEBR-066      | AEB-19TRN         | AEB-19TRN2021           | AY                      | 01/08/2020          | 31/07/2021        | 19087.00        |             |            |                         | New          |             |
    | 10017066 | AEBP-066       | AETL-066      | AEB-19TRLS        | AEB-19TRLS2021          | AY                      | 01/08/2020          | 31/07/2021        | 22475.00        |             |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017066 | AEBP-066       | AEBA-066      | 1               | 0                     | 27754.00  | 17933.00  | 9821.00   | 2838.00  | 3669.00  | 1178.00  | 2230.00  | 56.00    | 2878.00  | 3550.00  | 1534.00  | 1163.00  | 3258.00  | 3392.00  | 2008.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017066 | AEBP-066       | AEBR-066      | 1               | 0                     | 19087.00  | 11248.00  | 7839.00   | 667.00   | 1053.00  | 1631.00  | 880.00   | 3133.00  | 74.00    | 114.00   | 3696.00  | 351.00   | 2002.00  | 2486.00  | 3000.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017066 | AEBP-066       | AETL-066      | 1               | 0                     | 22475.00  | 14163.00  | 8312.00   | 2320.00  | 3244.00  | 3190.00  | 635.00   | 897.00   | 1095.00  | 502.00   | 2280.00  | 3363.00  | 2834.00  | 1702.00  | 413.00   | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017066 | AEBP-066           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017066 | ESFA-066           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017066' for FundingType 'AEB' and period '2021'





    # Change the date
    Given the override date is '03/07/2020'

    # Bulk file - Update Draft to change financials on three allocs and add a new AEB-PRS2021 alloc
    And   there are no files prefixed '10017066' in the Sharepoint 'AEB-2021-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 30122020162142 v3_A066' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 30122020162142 v3_A066' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 30122020162142 v3_A066' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 30122020162142 v3_A066' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 30122020162142 v3_A066.xlsx' exists in the Datafiles folder and UKPRN '10017066' is present in cell 'A2' of the Contract tab
 #  When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017066' for FundingType 'AEB' and period '2021'



    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType   | Period |
    | 10017066 | ESFA-066             | AEBP-066       | 1                     | 01/08/2020        | 31/07/2021      | 115898.00     | Procured       | 2021   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10017066 | AEBP-066       | AEBA-066        | AEB-AS            | AY                      | 01/08/2020          | 31/07/2021        | 44569.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |
    | 10017066 | AEBP-066       | AEBR-066        | AEB-19TRN         | AY                      | 01/08/2020          | 31/07/2021        | 33050.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |
    | 10017066 | AEBP-066       | [AllocRef_AERS] | AEB-PRS           | AY                      | 01/08/2020          | 31/07/2021        | 6025.00         |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |
    | 10017066 | AEBP-066       | AETL-066        | AEB-19TRLS        | AY                      | 01/08/2020          | 31/07/2021        | 32254.00        |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                                             | DeliverableDescription   |
    | AEBP-066       | AEBA-066           | 1               | 44569.00  | 578.00   | 122.00   | 3604.00  | 6948.00  | 2754.00  | 3656.00  | 3062.00  | 4845.00  | 5334.00  | 7595.00  | 2924.00  | 3147.00  | Adult Skills Total Funding                                  |                          |  
    | AEBP-066       | AEBR-066           | 1               | 33050.00  | 3435.00  | 6852.00  | 823.00   | 3010.00  | 175.00   | 2840.00  | 685.00   | 1312.00  | 5271.00  | 3455.00  | 3063.00  | 2129.00  | 19-24 Traineeships Total Funding                            |                          |
    | AEBP-066       | [AllocRef_AERS]    | 3               | 6025.00   | 2500.00  | 0.00     | 3525.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | AEB Provider Relief Scheme 2 (August to October 2020)       |                          |
    | AEBP-066       | AETL-066           | 1               | 32254.00  | 1222.00  | 563.00   | 6762.00  | 1954.00  | 478.00   | 7017.00  | 1189.00  | 2771.00  | 138.00   | 85.00    | 6083.00  | 3992.00  | Adult Education Budget - 19-24 Traineeships Learner Support |                          |

    # Contract status is now at 'Awaiting Documentation'
 
    # Tidy Up
    And   the override date is reset
       
@AcceptanceTest @Withdrawn20210512
Scenario: A069 Import and release a 1619ED CFS Funding Allocation with one Funding Allocation Line and CFS code mapping. Check CRM contract details
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017069'
    And   there is no Funding Allocation data in CRM for UKPRN '10017069'
    And   there is no Contract, Task or Workflow data for UKPRN '10017069'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017069' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017069 Co Ltd' with UKPRN '10017069' and OrgId 'ORG0017069' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017069' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017069 | 117069 | 10017069 Co Ltd | 0              | Active                | Yes           | AA017069      | ?             | 14 Elmfield West       | Millbrook Rd West      | ?                      | ?                      | Southampton            | Hampshire              | SO15 1JA  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017069 |




    # Change the date 
    Given the override date is '14/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017069 | PSG-AY-2021-Contract-Provider-10017069-3_6        | 3_6            | PSG                         | AY-2021            | 7925.00           |

    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | PSG-AY-2021-10017069-3_6   | 3_6                    | PSG-AY-2021-Contract-Provider-10017069-3_6  | 10017069      | Furth        | 01GFE           | 7925.00                   |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PSG-AY-2021-10017069-3_6   | PSG-001         | 7925.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PSG-AY-2021-10017069-3_6   | PSG-001         | FY-2021              | July                   | 2021              | 5095.00                   |
    | PSG-AY-2021-10017069-3_6   | PSG-001         | FY-2021              | November               | 2020              | 2830.00                   |

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017069 | 10017069 Co Ltd  | PSG-AY-2021-Contract-Provider-10017069-3_6        | 3_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | PSG                         | 16-19ED2021     | Scheduling        | Awaiting Release  | 7925.00     | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action           | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | PSG-AY-2021-Contract-Provider-10017069-3_6        | Record Imported  | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017069 | PSG-AY-2021-Contract-Provider-10017069-3_6        | 3_6            | AY-2021 | PSG                         | 7925.00     | [CofG_College] |


    # Check other PaaS tables - when we know what they are 
    # Where are status, substatus, contract and contractno now that they have gone from PaaS FA table ?




    # Release a Funding Allocation (32333)

    # Change the date
    Given the override date is '22/06/2021'

    # Release from Contract Control\Scheduling
    When  a request is triggered to release the following Funding Allocations from Contract Control
    | FundingId                                         |
    | PSG-AY-2021-Contract-Provider-10017069-3_6        |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017069' for FundingType 'EDSK' and period '2021'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017069 | 10017069 Co Ltd  | PSG-AY-2021-Contract-Provider-10017069-3_6        | 3_6            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (College)  | PSG                         | 16-19ED2021     | Released          | Released          | 7925.00     | [ContractNo]  | 1                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | PSG-AY-2021-Contract-Provider-10017069-3_6        | Release Successful   | CRM Integration   | Released       | Released              | Scheduling     | Release in Progress   |
  # | PSG-AY-2021-Contract-Provider-10017069-3_6        | Initiate Release     | FCS8 Test         | Released       | Released              | In Release     | Release in Progress   |
  # | PSG-AY-2021-Contract-Provider-10017069-3_6        | Initiate Release     | FCS8 Test         | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | PSG-AY-2021-Contract-Provider-10017069-3_6        | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |

    # Check PaaS FundingAllocation.FundingAllocation
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017069 | PSG-AY-2021-Contract-Provider-10017069-3_6        | 3_6            | AY-2021 | PSG                         | 7925.00     | [CofG_College] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                         | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PSG-AY-2021-Contract-Provider-10017069-3_6        | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017069 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017069 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check contract has been created correctly
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                              | Period |
    | 10017069 | [MasterContractNo]   | [ContractNo]   | 1                     | 01/08/2020        | 31/07/2021      | 7925.00       | Conditions of Funding (Grant) (College)   | 2021   |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | LEPName     | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference   | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType   | LearningRatePremium |
    | 10017069 | [ContractNo]   | [AllocRef_16ED] | 1619ED            | AY                      | 01/08/2020          | 31/07/2021        | 7925.00         |         |         |                         |             |         |                              |              |                        |                      |                 |                     |                    |              |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableName                 | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 7925.00   | 0.00     | 0.00     | 0.00     | 2830.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5095.00  | Primary PE and Sport Premium    |                          |

    # Contract status is now at 'Awaiting Documentation'


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Manual
@CFS
Scenario: A019 Create CFS Funding Allocations (To help with manual testing)
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018086'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018277'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018297'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018328'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018344'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018361'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019026'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019041'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019048'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019065'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019087'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019096'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019314'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019380'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019383'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019431'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10025086'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10025277'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10025297'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10025328'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10025344'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10025361'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10027026'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10027041'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10027048'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10027065'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10027087'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10027096'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10027314'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10027380'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10027383'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10027431'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10031086'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10031337'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10031297'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10031328'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10031344'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10031361'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10033026'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10033041'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10033048'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10033065'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10033087'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10033096'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10033314'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10033380'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10033383'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10033431'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10044531'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10044621'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10044708'

    And   there is no Funding Allocation data in CRM for UKPRN '10018086'
    And   there is no Funding Allocation data in CRM for UKPRN '10018277'
    And   there is no Funding Allocation data in CRM for UKPRN '10018297'
    And   there is no Funding Allocation data in CRM for UKPRN '10018328'
    And   there is no Funding Allocation data in CRM for UKPRN '10018344'
    And   there is no Funding Allocation data in CRM for UKPRN '10018361'
    And   there is no Funding Allocation data in CRM for UKPRN '10019026'
    And   there is no Funding Allocation data in CRM for UKPRN '10019041'
    And   there is no Funding Allocation data in CRM for UKPRN '10019048'
    And   there is no Funding Allocation data in CRM for UKPRN '10019065'
    And   there is no Funding Allocation data in CRM for UKPRN '10019087'
    And   there is no Funding Allocation data in CRM for UKPRN '10019096'
    And   there is no Funding Allocation data in CRM for UKPRN '10019314'
    And   there is no Funding Allocation data in CRM for UKPRN '10019380'
    And   there is no Funding Allocation data in CRM for UKPRN '10019383'
    And   there is no Funding Allocation data in CRM for UKPRN '10019431'
    And   there is no Funding Allocation data in CRM for UKPRN '10025086'
    And   there is no Funding Allocation data in CRM for UKPRN '10025277'
    And   there is no Funding Allocation data in CRM for UKPRN '10025297'
    And   there is no Funding Allocation data in CRM for UKPRN '10025328'
    And   there is no Funding Allocation data in CRM for UKPRN '10025344'
    And   there is no Funding Allocation data in CRM for UKPRN '10025361'
    And   there is no Funding Allocation data in CRM for UKPRN '10027026'
    And   there is no Funding Allocation data in CRM for UKPRN '10027041'
    And   there is no Funding Allocation data in CRM for UKPRN '10027048'
    And   there is no Funding Allocation data in CRM for UKPRN '10027065'
    And   there is no Funding Allocation data in CRM for UKPRN '10027087'
    And   there is no Funding Allocation data in CRM for UKPRN '10027096'
    And   there is no Funding Allocation data in CRM for UKPRN '10027314'
    And   there is no Funding Allocation data in CRM for UKPRN '10027380'
    And   there is no Funding Allocation data in CRM for UKPRN '10027383'
    And   there is no Funding Allocation data in CRM for UKPRN '10027431'
    And   there is no Funding Allocation data in CRM for UKPRN '10031086'
    And   there is no Funding Allocation data in CRM for UKPRN '10031337'
    And   there is no Funding Allocation data in CRM for UKPRN '10031297'
    And   there is no Funding Allocation data in CRM for UKPRN '10031328'
    And   there is no Funding Allocation data in CRM for UKPRN '10031344'
    And   there is no Funding Allocation data in CRM for UKPRN '10031361'
    And   there is no Funding Allocation data in CRM for UKPRN '10033026'
    And   there is no Funding Allocation data in CRM for UKPRN '10033041'
    And   there is no Funding Allocation data in CRM for UKPRN '10033048'
    And   there is no Funding Allocation data in CRM for UKPRN '10033065'
    And   there is no Funding Allocation data in CRM for UKPRN '10033087'
    And   there is no Funding Allocation data in CRM for UKPRN '10033096'
    And   there is no Funding Allocation data in CRM for UKPRN '10033314'
    And   there is no Funding Allocation data in CRM for UKPRN '10033380'
    And   there is no Funding Allocation data in CRM for UKPRN '10033383'
    And   there is no Funding Allocation data in CRM for UKPRN '10033431'
    And   there is no Funding Allocation data in CRM for UKPRN '10044531'
    And   there is no Funding Allocation data in CRM for UKPRN '10044621'
    And   there is no Funding Allocation data in CRM for UKPRN '10044708'

    And   there is no Contract, Task or Workflow data for UKPRN '10018086' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018277' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018297' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018328' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018344' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018361'
    And   there is no Contract, Task or Workflow data for UKPRN '10019026' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019041' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019048' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019065' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019087' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019096'
    And   there is no Contract, Task or Workflow data for UKPRN '10019314' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019380' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019383' 
    And   there is no Contract, Task or Workflow data for UKPRN '10019431'
    And   there is no Contract, Task or Workflow data for UKPRN '10025086' 
    And   there is no Contract, Task or Workflow data for UKPRN '10025277' 
    And   there is no Contract, Task or Workflow data for UKPRN '10025297' 
    And   there is no Contract, Task or Workflow data for UKPRN '10025328' 
    And   there is no Contract, Task or Workflow data for UKPRN '10025344' 
    And   there is no Contract, Task or Workflow data for UKPRN '10025361'
    And   there is no Contract, Task or Workflow data for UKPRN '10027026' 
    And   there is no Contract, Task or Workflow data for UKPRN '10027041' 
    And   there is no Contract, Task or Workflow data for UKPRN '10027048' 
    And   there is no Contract, Task or Workflow data for UKPRN '10027065' 
    And   there is no Contract, Task or Workflow data for UKPRN '10027087' 
    And   there is no Contract, Task or Workflow data for UKPRN '10027096'
    And   there is no Contract, Task or Workflow data for UKPRN '10027314' 
    And   there is no Contract, Task or Workflow data for UKPRN '10027380' 
    And   there is no Contract, Task or Workflow data for UKPRN '10027383' 
    And   there is no Contract, Task or Workflow data for UKPRN '10027431'
    And   there is no Contract, Task or Workflow data for UKPRN '10031086' 
    And   there is no Contract, Task or Workflow data for UKPRN '10031337' 
    And   there is no Contract, Task or Workflow data for UKPRN '10031297' 
    And   there is no Contract, Task or Workflow data for UKPRN '10031328' 
    And   there is no Contract, Task or Workflow data for UKPRN '10031344' 
    And   there is no Contract, Task or Workflow data for UKPRN '10031361'
    And   there is no Contract, Task or Workflow data for UKPRN '10033026' 
    And   there is no Contract, Task or Workflow data for UKPRN '10033041' 
    And   there is no Contract, Task or Workflow data for UKPRN '10033048' 
    And   there is no Contract, Task or Workflow data for UKPRN '10033065' 
    And   there is no Contract, Task or Workflow data for UKPRN '10033087' 
    And   there is no Contract, Task or Workflow data for UKPRN '10033096'
    And   there is no Contract, Task or Workflow data for UKPRN '10033314' 
    And   there is no Contract, Task or Workflow data for UKPRN '10033380' 
    And   there is no Contract, Task or Workflow data for UKPRN '10033383' 
    And   there is no Contract, Task or Workflow data for UKPRN '10033431'
    And   there is no Contract, Task or Workflow data for UKPRN '10044531'
    And   there is no Contract, Task or Workflow data for UKPRN '10044621'
    And   there is no Contract, Task or Workflow data for UKPRN '10044708'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down the Funding Allocations and Release Groups
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (HEI)     |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (NMSS)    |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)     |
    | EDSK            | AY2021        | 16-19ED2021  | Contract for Services (ITP)             |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |

    # Set organisation and advisors 
#
#
#    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
#    And   the following Organisations exist in the FCT Organisation Service 
#    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
#    | 10018086 | 118086 | 10018086 Co Ltd | 0              | Active                | Yes           | AA018086      | ?             | 7 Watermill House      | Restmor Way            | Wallington             | ?                      | ?                      | Surrey                 | SM6 7AH   |
#    | 10018277 | 118277 | 10018277 Co Ltd | 0              | Active                | Yes           | AA018277      | ?             | 54 Maple Road          | 18 Osprey Court        | Surbiton               | ?                      | ?                      | Surrey                 | KT6 4BQ   |
#    | 10018297 | 118297 | 10018297 Co Ltd | 0              | Active                | Yes           | AA018297      | ?             | 33 London Road         | Blackwater             | Camberley              | Surrey                 | ?                      | ?                      | GU17 0AB  |
#    | 10018328 | 118328 | 10018328 Co Ltd | 0              | Active                | Yes           | AA018328      | ?             | 5 Jupiter House        | Calleva Park           | ?                      | ?                      | Aldermaston            | Berkshire              | RG7 8NN   |
#    | 10018344 | 118344 | 10018344 Co Ltd | 0              | Active                | Yes           | AA018344      | ?             | 230 Wharfdale Road     | Winnersh Triangle      | ?                      | ?                      | Wokingham              | Berkshire              | RG41 5TP  |
#    | 10018361 | 118361 | 10018361 Co Ltd | 0              | Active                | Yes           | AA018361      | ?             | 8 Percival Terrace     | Marine Parade          | ?                      | ?                      | Brighton               | East Sussex            | BN2 1FP   |
#    | 10019026 | 119026 | 10019026 Co Ltd | 0              | Active                | Yes           | AA019026      | ?             | 52 Park Street         | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 3PT  |
#    | 10019041 | 119041 | 10019041 Co Ltd | 0              | Active                | Yes           | AA019041      | ?             | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |
#    | 10019048 | 119048 | 10019048 Co Ltd | 0              | Active                | Yes           | AA019048      | ?             | 7 Lovers Walk          | Preston Park           | ?                      | ?                      | Brighton               | East Sussex            | BN1 6AH   |
#    | 10019065 | 119065 | 10019065 Co Ltd | 0              | Active                | Yes           | AA019065      | ?             | 23 Keytes Lane         | Barford                | ?                      | ?                      | Warwick                | Warwickshire           | CV35 8EP  |
#    | 10019087 | 119087 | 10019087 Co Ltd | 0              | Active                | Yes           | AA019087      | ?             | 12 Aintree Road        | Perivale               | ?                      | ?                      | Greenford              | Middlesex              | UB6 7LA   |
#    | 10019096 | 119096 | 10019096 Co Ltd | 0              | Active                | Yes           | AA019096      | ?             | 1 Straw Close          | Caterham               | ?                      | ?                      | ?                      | Surrey                 | CR3 5FZ   |
#    | 10019314 | 119314 | 10019314 Co Ltd | 0              | Active                | Yes           | AA019314      | ?             | 10 St. Mary at Hill    | London                 | ?                      | ?                      | ?                      | ?                      | EC3R 8EE  |
#    | 10019380 | 119380 | 10019380 Co Ltd | 0              | Active                | Yes           | AA019380      | ?             | 5 Charterhouse Bldgs   | 2nd Floor              | Gosswell Rd            | ?                      | London                 | ?                      | EC1M 7AN  |
#    | 10019383 | 119383 | 10019383 Co Ltd | 0              | Active                | Yes           | AA019383      | ?             | 5 Alton House          | Gatehouse Way          | ?                      | ?                      | Alyesbury              | Buckinghamshire        | HP19 8HN  |
#    | 10019431 | 119431 | 10019431 Co Ltd | 0              | Active                | Yes           | AA019431      | ?             | 372a Palatine Road     | Northenden             | ?                      | ?                      | Manchester             | Greater Manchester     | M22 4FZ   |
#    | 10025086 | 125086 | 10025086 Co Ltd | 0              | Active                | Yes           | AA025086      | ?             | 7 Watermill House      | Restmor Way            | Wallington             | ?                      | ?                      | Surrey                 | SM6 7AH   |
#    | 10025277 | 125277 | 10025277 Co Ltd | 0              | Active                | Yes           | AA025277      | ?             | 54 Maple Road          | 25 Osprey Court        | Surbiton               | ?                      | ?                      | Surrey                 | KT6 4BQ   |
#    | 10025297 | 125297 | 10025297 Co Ltd | 0              | Active                | Yes           | AA025297      | ?             | 33 London Road         | Blackwater             | Camberley              | Surrey                 | ?                      | ?                      | GU17 0AB  |
#    | 10025328 | 125328 | 10025328 Co Ltd | 0              | Active                | Yes           | AA025328      | ?             | 5 Jupiter House        | Calleva Park           | ?                      | ?                      | Aldermaston            | Berkshire              | RG7 8NN   |
#    | 10025344 | 125344 | 10025344 Co Ltd | 0              | Active                | Yes           | AA025344      | ?             | 230 Wharfdale Road     | Winnersh Triangle      | ?                      | ?                      | Wokingham              | Berkshire              | RG41 5TP  |
#    | 10025361 | 125361 | 10025361 Co Ltd | 0              | Active                | Yes           | AA025361      | ?             | 8 Percival Terrace     | Marine Parade          | ?                      | ?                      | Brighton               | East Sussex            | BN2 1FP   |
#    | 10027026 | 127026 | 10027026 Co Ltd | 0              | Active                | Yes           | AA027026      | ?             | 52 Park Street         | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 3PT  |
#    | 10027041 | 127041 | 10027041 Co Ltd | 0              | Active                | Yes           | AA027041      | ?             | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |
#    | 10027048 | 127048 | 10027048 Co Ltd | 0              | Active                | Yes           | AA027048      | ?             | 7 Lovers Walk          | Preston Park           | ?                      | ?                      | Brighton               | East Sussex            | BN1 6AH   |
#    | 10027065 | 127065 | 10027065 Co Ltd | 0              | Active                | Yes           | AA027065      | ?             | 23 Keytes Lane         | Barford                | ?                      | ?                      | Warwick                | Warwickshire           | CV35 8EP  |
#    | 10027087 | 127087 | 10027087 Co Ltd | 0              | Active                | Yes           | AA027087      | ?             | 12 Aintree Road        | Perivale               | ?                      | ?                      | Greenford              | Middlesex              | UB6 7LA   |
#    | 10027096 | 127096 | 10027096 Co Ltd | 0              | Active                | Yes           | AA027096      | ?             | 1 Straw Close          | Caterham               | ?                      | ?                      | ?                      | Surrey                 | CR3 5FZ   |
#    | 10027314 | 127314 | 10027314 Co Ltd | 0              | Active                | Yes           | AA027314      | ?             | 10 St. Mary at Hill    | London                 | ?                      | ?                      | ?                      | ?                      | EC3R 8EE  |
#    | 10027380 | 127380 | 10027380 Co Ltd | 0              | Active                | Yes           | AA027380      | ?             | 5 Charterhouse Bldgs   | 2nd Floor              | Gosswell Rd            | ?                      | London                 | ?                      | EC1M 7AN  |
#    | 10027383 | 127383 | 10027383 Co Ltd | 0              | Active                | Yes           | AA027383      | ?             | 5 Alton House          | Gatehouse Way          | ?                      | ?                      | Alyesbury              | Buckinghamshire        | HP27 8HN  |
#    | 10027431 | 127431 | 10027431 Co Ltd | 0              | Active                | Yes           | AA027431      | ?             | 372a Palatine Road     | Northenden             | ?                      | ?                      | Manchester             | Greater Manchester     | M22 4FZ   |
#    | 10031086 | 131086 | 10031086 Co Ltd | 0              | Active                | Yes           | AA031086      | ?             | 7 Watermill House      | Restmor Way            | Wallington             | ?                      | ?                      | Surrey                 | SM6 7AH   |
#    | 10031337 | 131337 | 10031337 Co Ltd | 0              | Active                | Yes           | AA031337      | ?             | 54 Maple Road          | 31 Osprey Court        | Surbiton               | ?                      | ?                      | Surrey                 | KT6 4BQ   |
#    | 10031297 | 131297 | 10031297 Co Ltd | 0              | Active                | Yes           | AA031297      | ?             | 33 London Road         | Blackwater             | Camberley              | Surrey                 | ?                      | ?                      | GU17 0AB  |
#    | 10031328 | 131328 | 10031328 Co Ltd | 0              | Active                | Yes           | AA031328      | ?             | 5 Jupiter House        | Calleva Park           | ?                      | ?                      | Aldermaston            | Berkshire              | RG7 8NN   |
#    | 10031344 | 131344 | 10031344 Co Ltd | 0              | Active                | Yes           | AA031344      | ?             | 230 Wharfdale Road     | Winnersh Triangle      | ?                      | ?                      | Wokingham              | Berkshire              | RG41 5TP  |
#    | 10031361 | 131361 | 10031361 Co Ltd | 0              | Active                | Yes           | AA031361      | ?             | 8 Percival Terrace     | Marine Parade          | ?                      | ?                      | Brighton               | East Sussex            | BN2 1FP   |
#    | 10033026 | 133026 | 10033026 Co Ltd | 0              | Active                | Yes           | AA033026      | ?             | 52 Park Street         | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 3PT  |
#    | 10033041 | 133041 | 10033041 Co Ltd | 0              | Active                | Yes           | AA033041      | ?             | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |
#    | 10033048 | 133048 | 10033048 Co Ltd | 0              | Active                | Yes           | AA033048      | ?             | 7 Lovers Walk          | Preston Park           | ?                      | ?                      | Brighton               | East Sussex            | BN1 6AH   |
#    | 10033065 | 133065 | 10033065 Co Ltd | 0              | Active                | Yes           | AA033065      | ?             | 23 Keytes Lane         | Barford                | ?                      | ?                      | Warwick                | Warwickshire           | CV35 8EP  |
#    | 10033087 | 133087 | 10033087 Co Ltd | 0              | Active                | Yes           | AA033087      | ?             | 12 Aintree Road        | Perivale               | ?                      | ?                      | Greenford              | Middlesex              | UB6 7LA   |
#    | 10033096 | 133096 | 10033096 Co Ltd | 0              | Active                | Yes           | AA033096      | ?             | 1 Straw Close          | Caterham               | ?                      | ?                      | ?                      | Surrey                 | CR3 5FZ   |
#    | 10033314 | 133314 | 10033314 Co Ltd | 0              | Active                | Yes           | AA033314      | ?             | 10 St. Mary at Hill    | London                 | ?                      | ?                      | ?                      | ?                      | EC3R 8EE  |
#    | 10033380 | 133380 | 10033380 Co Ltd | 0              | Active                | Yes           | AA033380      | ?             | 5 Charterhouse Bldgs   | 2nd Floor              | Gosswell Rd            | ?                      | London                 | ?                      | EC1M 7AN  |
#    | 10033383 | 133383 | 10033383 Co Ltd | 0              | Active                | Yes           | AA033383      | ?             | 5 Alton House          | Gatehouse Way          | ?                      | ?                      | Alyesbury              | Buckinghamshire        | HP33 8HN  |
#    | 10033431 | 133431 | 10033431 Co Ltd | 0              | Active                | Yes           | AA033431      | ?             | 372a Palatine Road     | Northenden             | ?                      | ?                      | Manchester             | Greater Manchester     | M22 4FZ   |
#    | 10044531 | 144531 | 10044531 Co Ltd | 0              | Active                | Yes           | AA044531      | ?             | 44 Wood Street         | ?                      | ?                      | ?                      | Barnet                 | Hertfordshire          | EN5 4AT   |
#    | 10044621 | 144621 | 10044621 Co Ltd | 0              | Active                | Yes           | AA044621      | ?             | 18 Armstrong Gardens   | Peterloo               | ?                      | ?                      | Thurnby                | Hertfordshire          | EN5 3PI   |
#    | 10044708 | 144708 | 10044708 Co Ltd | 0              | Active                | Yes           | AA044708      | ?             | 16 Grand Street        | Alberton               | ?                      | ?                      | Shapely                | Hertfordshire          | EN5 8WR   |
#
#    # Put the same Provider data in the CRM Organisation table 
#    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
#    | UKPRN    |
#    | 10018086 |
#    | 10018277 |
#    | 10018297 |
#    | 10018328 |
#    | 10018344 |
#    | 10018361 |
#    | 10019026 |
#    | 10019041 |
#    | 10019048 |
#    | 10019065 |
#    | 10019087 |
#    | 10019096 |
#    | 10019314 |
#    | 10019380 |
#    | 10019383 |
#    | 10019431 |
#    | 10025086 |
#    | 10025277 |
#    | 10025297 |
#    | 10025328 |
#    | 10025344 |
#    | 10025361 |
#    | 10027026 |
#    | 10027041 |
#    | 10027048 |
#    | 10027065 |
#    | 10027087 |
#    | 10027096 |
#    | 10027314 |
#    | 10027380 |
#    | 10027383 |
#    | 10027431 |
#    | 10031086 |
#    | 10031337 |
#    | 10031297 |
#    | 10031328 |
#    | 10031344 |
#    | 10031361 |
#    | 10033026 |
#    | 10033041 |
#    | 10033048 |
#    | 10033065 |
#    | 10033087 |
#    | 10033096 |
#    | 10033314 |
#    | 10033380 |
#    | 10033383 |
#    | 10033431 |
#    | 10044531 |
#    | 10044621 |
#    | 10044708 |



    # Change the date 
    Given the override date is '18/06/2021'

    # Populate the stub

    # Funding Allocation
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                   | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018086 | 1619-AS-2021-Contract-Provider-10018086-1_2 | 1_2            | 1619                        | AS-2021            | 2700.00           |
    | Contracting    | 10018277 | 1619-AS-2021-Contract-Provider-10018277-3_6 | 3_6            | 1619                        | AS-2021            | 7541.00           |
    | Contracting    | 10018297 | 1619-AS-2021-Contract-Provider-10018297-5_1 | 5_1            | 1619                        | AS-2021            | 2781.00           |
    | Contracting    | 10018328 | 1619-AS-2021-Contract-Provider-10018328-1_2 | 1_2            | 1619                        | AS-2021            | 2270.00           |
    | Contracting    | 10018344 | 1619-AS-2021-Contract-Provider-10018344-3_6 | 3_6            | 1619                        | AS-2021            | 2702.00           |
    | Contracting    | 10018361 | 1619-AS-2021-Contract-Provider-10018361-5_1 | 5_1            | 1619                        | AS-2021            | 6767.00           |
    | Contracting    | 10019026 | 1619-AS-2021-Contract-Provider-10019026-1_2 | 1_2            | 1619                        | AS-2021            | 5511.00           |
    | Contracting    | 10019041 | 1619-AS-2021-Contract-Provider-10019041-3_6 | 3_6            | 1619                        | AS-2021            | 6990.00           |
    | Contracting    | 10019048 | 1619-AS-2021-Contract-Provider-10019048-5_1 | 5_1            | 1619                        | AS-2021            | 4949.00           |
    | Contracting    | 10019065 | 1619-AS-2021-Contract-Provider-10019065-1_2 | 1_2            | 1619                        | AS-2021            | 5117.00           |
    | Contracting    | 10019087 | 1619-AS-2021-Contract-Provider-10019087-3_6 | 3_6            | 1619                        | AS-2021            | 7578.00           |
    | Contracting    | 10019096 | 1619-AS-2021-Contract-Provider-10019096-5_1 | 5_1            | 1619                        | AS-2021            | 4360.00           |
    | Contracting    | 10019314 | NLG-AS-2021-Contract-Provider-10019314-5_1  | 5_1            | NLG                         | AY-2021            | 5012.00           |
    | Contracting    | 10019380 | NLG-AS-2021-Contract-Provider-10019380-1_2  | 1_2            | NLG                         | AY-2021            | 6388.00           |
    | Contracting    | 10019383 | NLG-AS-2021-Contract-Provider-10019383-3_6  | 3_6            | NLG                         | AY-2021            | 1009.00           |
    | Contracting    | 10019431 | NLG-AS-2021-Contract-Provider-10019431-5_1  | 5_1            | NLG                         | AY-2021            | 9822.00           |
    | Contracting    | 10025086 | 1619-AS-2021-Contract-Provider-10025086-1_2 | 1_2            | 1619                        | AS-2021            | 6459.00           |
    | Contracting    | 10025277 | 1619-AS-2021-Contract-Provider-10025277-3_6 | 3_6            | 1619                        | AS-2021            | 8202.00           |
    | Contracting    | 10025297 | 1619-AS-2021-Contract-Provider-10025297-5_1 | 5_1            | 1619                        | AS-2021            | 2940.00           |
    | Contracting    | 10025328 | 1619-AS-2021-Contract-Provider-10025328-1_2 | 1_2            | 1619                        | AS-2021            | 6587.00           |
    | Contracting    | 10025344 | 1619-AS-2021-Contract-Provider-10025344-3_6 | 3_6            | 1619                        | AS-2021            | 3502.00           |
    | Contracting    | 10025361 | 1619-AS-2021-Contract-Provider-10025361-5_1 | 5_1            | 1619                        | AS-2021            | 7073.00           |
    | Contracting    | 10027026 | 1619-AS-2021-Contract-Provider-10027026-1_2 | 1_2            | 1619                        | AS-2021            | 9298.00           |
    | Contracting    | 10027041 | 1619-AS-2021-Contract-Provider-10027041-3_6 | 3_6            | 1619                        | AS-2021            | 7826.00           |
    | Contracting    | 10027048 | 1619-AS-2021-Contract-Provider-10027048-5_1 | 5_1            | 1619                        | AS-2021            | 1171.00           |
    | Contracting    | 10027065 | 1619-AS-2021-Contract-Provider-10027065-1_2 | 1_2            | 1619                        | AS-2021            | 1600.00           |
    | Contracting    | 10027087 | 1619-AS-2021-Contract-Provider-10027087-3_6 | 3_6            | 1619                        | AS-2021            | 8805.00           |
    | Contracting    | 10027096 | 1619-AS-2021-Contract-Provider-10027096-5_1 | 5_1            | 1619                        | AS-2021            | 8362.00           |
    | Contracting    | 10027314 | NLG-AS-2021-Contract-Provider-10027314-5_1  | 5_1            | NLG                         | AY-2021            | 4788.00           |
    | Contracting    | 10027380 | NLG-AS-2021-Contract-Provider-10027380-1_2  | 1_2            | NLG                         | AY-2021            | 8158.00           |
    | Contracting    | 10027383 | NLG-AS-2021-Contract-Provider-10027383-3_6  | 3_6            | NLG                         | AY-2021            | 5575.00           |
    | Contracting    | 10027431 | NLG-AS-2021-Contract-Provider-10027431-5_1  | 5_1            | NLG                         | AY-2021            | 5461.00           |
    | Contracting    | 10031086 | 1619-AS-2021-Contract-Provider-10031086-1_2 | 1_2            | 1619                        | AS-2021            | 9097.00           |
    | Contracting    | 10031337 | 1619-AS-2021-Contract-Provider-10031337-3_6 | 3_6            | 1619                        | AS-2021            | 9206.00           |
    | Contracting    | 10031297 | 1619-AS-2021-Contract-Provider-10031297-5_1 | 5_1            | 1619                        | AS-2021            | 4274.00           |
    | Contracting    | 10031328 | 1619-AS-2021-Contract-Provider-10031328-1_2 | 1_2            | 1619                        | AS-2021            | 4703.00           |
    | Contracting    | 10031344 | 1619-AS-2021-Contract-Provider-10031344-3_6 | 3_6            | 1619                        | AS-2021            | 9465.00           |
    | Contracting    | 10031361 | 1619-AS-2021-Contract-Provider-10031361-5_1 | 5_1            | 1619                        | AS-2021            | 4213.00           |
    | Contracting    | 10033026 | 1619-AS-2021-Contract-Provider-10033026-1_2 | 1_2            | 1619                        | AS-2021            | 3521.00           |
    | Contracting    | 10033041 | 1619-AS-2021-Contract-Provider-10033041-3_6 | 3_6            | 1619                        | AS-2021            | 4088.00           |
    | Contracting    | 10033048 | 1619-AS-2021-Contract-Provider-10033048-5_1 | 5_1            | 1619                        | AS-2021            | 8002.00           |
    | Contracting    | 10033065 | 1619-AS-2021-Contract-Provider-10033065-1_2 | 1_2            | 1619                        | AS-2021            | 7838.00           |
    | Contracting    | 10033087 | 1619-AS-2021-Contract-Provider-10033087-3_6 | 3_6            | 1619                        | AS-2021            | 7556.00           |
    | Contracting    | 10033096 | 1619-AS-2021-Contract-Provider-10033096-5_1 | 5_1            | 1619                        | AS-2021            | 8067.00           |
    | Contracting    | 10033314 | NLG-AS-2021-Contract-Provider-10033314-5_1  | 5_1            | NLG                         | AY-2021            | 9560.00           |
    | Contracting    | 10033380 | NLG-AS-2021-Contract-Provider-10033380-1_2  | 1_2            | NLG                         | AY-2021            | 5901.00           |
    | Contracting    | 10033383 | NLG-AS-2021-Contract-Provider-10033383-3_6  | 3_6            | NLG                         | AY-2021            | 4272.00           |
    | Contracting    | 10033431 | NLG-AS-2021-Contract-Provider-10033431-5_1  | 5_1            | NLG                         | AY-2021            | 8726.00           |
    | Contracting    | 10044531 | DADA-AY-2021-Contract-Provider-10044531-4_0 | 4_0            | DADA                        | AY-2021            | 5449.00           |
    | Contracting    | 10044621 | DADA-AY-2021-Contract-Provider-10044621-4_0 | 4_0            | DADA                        | AY-2021            | 5644.00           |
    | Contracting    | 10044708 | DADA-AY-2021-Contract-Provider-10044708-4_0 | 4_0            | DADA                        | AY-2021            | 4137.00           |


    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId         | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue | 
    | 1619-AS-2021-10018086-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10018086-1_2 | 10018086      | Furth        | 01GFE           | 2700.00                   | 
    | 1619-AS-2021-10018277-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10018277-3_6 | 10018277      | Furth        | 02IPP           | 7541.00                   | 
    | 1619-AS-2021-10018297-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10018297-5_1 | 10018297      | Schoo        | 21NMS           | 2781.00                   | 
    | 1619-AS-2021-10018328-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10018328-1_2 | 10018328      | Local        | 10LAU           | 2270.00                   | 
    | 1619-AS-2021-10018344-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10018344-3_6 | 10018344      | Furth        | 18ISP           | 2702.00                   | 
    | 1619-AS-2021-10018361-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10018361-5_1 | 10018361      | Schoo        | 21NMS           | 6767.00                   | 
    | 1619-AS-2021-10019026-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10019026-1_2 | 10019026      | Furth        | 03SFC           | 5511.00                   | 
    | 1619-AS-2021-10019041-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10019041-3_6 | 10019041      | Furth        | 04AHC           | 6990.00                   | 
    | 1619-AS-2021-10019048-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10019048-5_1 | 10019048      | Furth        | 05ADC           | 4949.00                   | 
    | 1619-AS-2021-10019065-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10019065-1_2 | 10019065      | Furth        | 06SDC           | 5117.00                   | 
    | 1619-AS-2021-10019087-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10019087-3_6 | 10019087      | Schoo        | 21NMS           | 7578.00                   | 
    | 1619-AS-2021-10019096-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10019096-5_1 | 10019096      | Furth        | 18ISP           | 4360.00                   | 
    | NLG-AS-2021-10019314-5_1  | 5_1                    | NLG-AS-2021-Contract-Provider-10019314-5_1  | 10019314      | Furth        | 01GFE           | 5012.00                   | 
    | NLG-AS-2021-10019380-1_2  | 1_2                    | NLG-AS-2021-Contract-Provider-10019380-1_2  | 10019380      | Furth        | 03SFC           | 6388.00                   | 
    | NLG-AS-2021-10019383-3_6  | 3_6                    | NLG-AS-2021-Contract-Provider-10019383-3_6  | 10019383      | Furth        | 05ADC           | 1009.00                   | 
    | NLG-AS-2021-10019431-5_1  | 5_1                    | NLG-AS-2021-Contract-Provider-10019431-5_1  | 10019431      | Furth        | 06SDC           | 9822.00                   | 
    | 1619-AS-2021-10025086-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10025086-1_2 | 10025086      | Furth        | 01GFE           | 6459.00                   | 
    | 1619-AS-2021-10025277-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10025277-3_6 | 10025277      | Furth        | 02IPP           | 8202.00                   | 
    | 1619-AS-2021-10025297-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10025297-5_1 | 10025297      | Schoo        | 21NMS           | 2940.00                   | 
    | 1619-AS-2021-10025328-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10025328-1_2 | 10025328      | Local        | 10LAU           | 6587.00                   | 
    | 1619-AS-2021-10025344-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10025344-3_6 | 10025344      | Furth        | 07HEP           | 3502.00                   | 
    | 1619-AS-2021-10025361-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10025361-5_1 | 10025361      | Schoo        | 21NMS           | 7073.00                   | 
    | 1619-AS-2021-10027026-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10027026-1_2 | 10027026      | Furth        | 03SFC           | 9298.00                   | 
    | 1619-AS-2021-10027041-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10027041-3_6 | 10027041      | Furth        | 04AHC           | 7826.00                   | 
    | 1619-AS-2021-10027048-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10027048-5_1 | 10027048      | Furth        | 05ADC           | 1171.00                   | 
    | 1619-AS-2021-10027065-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10027065-1_2 | 10027065      | Furth        | 06SDC           | 1600.00                   | 
    | 1619-AS-2021-10027087-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10027087-3_6 | 10027087      | Schoo        | 21NMS           | 8805.00                   | 
    | 1619-AS-2021-10027096-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10027096-5_1 | 10027096      | Furth        | 07HEP           | 8362.00                   | 
    | NLG-AS-2021-10027314-5_1  | 5_1                    | NLG-AS-2021-Contract-Provider-10027314-5_1  | 10027314      | Furth        | 01GFE           | 4788.00                   | 
    | NLG-AS-2021-10027380-1_2  | 1_2                    | NLG-AS-2021-Contract-Provider-10027380-1_2  | 10027380      | Furth        | 03SFC           | 8158.00                   | 
    | NLG-AS-2021-10027383-3_6  | 3_6                    | NLG-AS-2021-Contract-Provider-10027383-3_6  | 10027383      | Furth        | 05ADC           | 5575.00                   | 
    | NLG-AS-2021-10027431-5_1  | 5_1                    | NLG-AS-2021-Contract-Provider-10027431-5_1  | 10027431      | Furth        | 06SDC           | 5461.00                   | 
    | 1619-AS-2021-10031086-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10031086-1_2 | 10031086      | Furth        | 01GFE           | 9097.00                   | 
    | 1619-AS-2021-10031337-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10031337-3_6 | 10031337      | Furth        | 02IPP           | 9206.00                   | 
    | 1619-AS-2021-10031297-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10031297-5_1 | 10031297      | Schoo        | 21NMS           | 4274.00                   | 
    | 1619-AS-2021-10031328-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10031328-1_2 | 10031328      | Local        | 10LAU           | 4703.00                   | 
    | 1619-AS-2021-10031344-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10031344-3_6 | 10031344      | Furth        | 02IPP           | 9465.00                   | 
    | 1619-AS-2021-10031361-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10031361-5_1 | 10031361      | Schoo        | 21NMS           | 4213.00                   | 
    | 1619-AS-2021-10033026-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10033026-1_2 | 10033026      | Furth        | 03SFC           | 3521.00                   | 
    | 1619-AS-2021-10033041-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10033041-3_6 | 10033041      | Furth        | 04AHC           | 4088.00                   | 
    | 1619-AS-2021-10033048-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10033048-5_1 | 10033048      | Furth        | 05ADC           | 8002.00                   | 
    | 1619-AS-2021-10033065-1_2 | 1_2                    | 1619-AS-2021-Contract-Provider-10033065-1_2 | 10033065      | Furth        | 06SDC           | 7838.00                   | 
    | 1619-AS-2021-10033087-3_6 | 3_6                    | 1619-AS-2021-Contract-Provider-10033087-3_6 | 10033087      | Schoo        | 21NMS           | 7556.00                   | 
    | 1619-AS-2021-10033096-5_1 | 5_1                    | 1619-AS-2021-Contract-Provider-10033096-5_1 | 10033096      | Furth        | 02IPP           | 8067.00                   | 
    | NLG-AS-2021-10033314-5_1  | 5_1                    | NLG-AS-2021-Contract-Provider-10033314-5_1  | 10033314      | Furth        | 01GFE           | 9560.00                   | 
    | NLG-AS-2021-10033380-1_2  | 1_2                    | NLG-AS-2021-Contract-Provider-10033380-1_2  | 10033380      | Furth        | 03SFC           | 5901.00                   | 
    | NLG-AS-2021-10033383-3_6  | 3_6                    | NLG-AS-2021-Contract-Provider-10033383-3_6  | 10033383      | Furth        | 05ADC           | 4272.00                   | 
    | NLG-AS-2021-10033431-5_1  | 5_1                    | NLG-AS-2021-Contract-Provider-10033431-5_1  | 10033431      | Furth        | 06SDC           | 8726.00                   | 
    | DADA-AY-2021-10044531-4_0 | 4_0                    | DADA-AY-2021-Contract-Provider-10044531-4_0 | 10044531      | Furth        | 07HEP           | 5449.00                   |
    | DADA-AY-2021-10044621-4_0 | 4_0                    | DADA-AY-2021-Contract-Provider-10044621-4_0 | 10044621      | Furth        | 03SFC           | 5644.00                   |
    | DADA-AY-2021-10044708-4_0 | 4_0                    | DADA-AY-2021-Contract-Provider-10044708-4_0 | 10044708      | Furth        | 02IPP           | 4137.00                   |

    # Funding Allocation Line  (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10018086-1_2  | 1619-001        | 2700.00          | Payment         |
    | 1619-AS-2021-10018277-3_6  | 1619-001        | 7541.00          | Payment         |
    | 1619-AS-2021-10018297-5_1  | 1619-001        | 2781.00          | Payment         |
    | 1619-AS-2021-10018328-1_2  | 1619-001        | 2270.00          | Payment         |
    | 1619-AS-2021-10018344-3_6  | 1619-001        | 2702.00          | Payment         |
    | 1619-AS-2021-10018361-5_1  | 1619-001        | 6767.00          | Payment         |
    | 1619-AS-2021-10019026-1_2  | 1619-001        | 5511.00          | Payment         |
    | 1619-AS-2021-10019041-3_6  | 1619-001        | 6990.00          | Payment         |
    | 1619-AS-2021-10019048-5_1  | 1619-001        | 4949.00          | Payment         |
    | 1619-AS-2021-10019065-1_2  | 1619-001        | 5117.00          | Payment         |
    | 1619-AS-2021-10019087-3_6  | 1619-001        | 7578.00          | Payment         |
    | 1619-AS-2021-10019096-5_1  | 1619-001        | 4360.00          | Payment         |
    | NLG-AS-2021-10019314-5_1   | NLG-001         | 5012.00          | Payment         |
    | NLG-AS-2021-10019380-1_2   | NLG-001         | 6388.00          | Payment         |
    | NLG-AS-2021-10019383-3_6   | NLG-001         | 1009.00          | Payment         |
    | NLG-AS-2021-10019431-5_1   | NLG-001         | 9822.00          | Payment         |
    | 1619-AS-2021-10025086-1_2  | 1619-001        | 6459.00          | Payment         |
    | 1619-AS-2021-10025277-3_6  | 1619-001        | 8202.00          | Payment         |
    | 1619-AS-2021-10025297-5_1  | 1619-001        | 2940.00          | Payment         |
    | 1619-AS-2021-10025328-1_2  | 1619-001        | 6587.00          | Payment         |
    | 1619-AS-2021-10025344-3_6  | 1619-001        | 3502.00          | Payment         |
    | 1619-AS-2021-10025361-5_1  | 1619-001        | 7073.00          | Payment         |
    | 1619-AS-2021-10027026-1_2  | 1619-001        | 9298.00          | Payment         |
    | 1619-AS-2021-10027041-3_6  | 1619-001        | 7826.00          | Payment         |
    | 1619-AS-2021-10027048-5_1  | 1619-001        | 1171.00          | Payment         |
    | 1619-AS-2021-10027065-1_2  | 1619-001        | 1600.00          | Payment         |
    | 1619-AS-2021-10027087-3_6  | 1619-001        | 8805.00          | Payment         |
    | 1619-AS-2021-10027096-5_1  | 1619-001        | 8362.00          | Payment         |
    | NLG-AS-2021-10027314-5_1   | NLG-001         | 4788.00          | Payment         |
    | NLG-AS-2021-10027380-1_2   | NLG-001         | 8158.00          | Payment         |
    | NLG-AS-2021-10027383-3_6   | NLG-001         | 5575.00          | Payment         |
    | NLG-AS-2021-10027431-5_1   | NLG-001         | 5461.00          | Payment         |
    | 1619-AS-2021-10031086-1_2  | 1619-001        | 9097.00          | Payment         |
    | 1619-AS-2021-10031337-3_6  | 1619-001        | 9206.00          | Payment         |
    | 1619-AS-2021-10031297-5_1  | 1619-001        | 4274.00          | Payment         |
    | 1619-AS-2021-10031328-1_2  | 1619-001        | 4703.00          | Payment         |
    | 1619-AS-2021-10031344-3_6  | 1619-001        | 9465.00          | Payment         |
    | 1619-AS-2021-10031361-5_1  | 1619-001        | 4213.00          | Payment         |
    | 1619-AS-2021-10033026-1_2  | 1619-001        | 3521.00          | Payment         |
    | 1619-AS-2021-10033041-3_6  | 1619-001        | 4088.00          | Payment         |
    | 1619-AS-2021-10033048-5_1  | 1619-001        | 8002.00          | Payment         |
    | 1619-AS-2021-10033065-1_2  | 1619-001        | 7838.00          | Payment         |
    | 1619-AS-2021-10033087-3_6  | 1619-001        | 7556.00          | Payment         |
    | 1619-AS-2021-10033096-5_1  | 1619-001        | 8067.00          | Payment         |
    | NLG-AS-2021-10033314-5_1   | NLG-001         | 9560.00          | Payment         |
    | NLG-AS-2021-10033380-1_2   | NLG-001         | 5901.00          | Payment         |
    | NLG-AS-2021-10033383-3_6   | NLG-001         | 4272.00          | Payment         |
    | NLG-AS-2021-10033431-5_1   | NLG-001         | 8726.00          | Payment         |
    | DADA-AY-2021-10044531-4_0  | DADA-001        | 5449.00          | Payment         |
    | DADA-AY-2021-10044621-4_0  | DADA-001        | 5644.00          | Payment         |
    | DADA-AY-2021-10044708-4_0  | DADA-001        | 4137.00          | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10018086-1_2  | 1619-001        | FY-2021              | October                | 2020              | 2700.00                   |
    | 1619-AS-2021-10018277-3_6  | 1619-001        | FY-2021              | January                | 2021              | 7541.00                   |
    | 1619-AS-2021-10018297-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 2781.00                   |
    | 1619-AS-2021-10018328-1_2  | 1619-001        | FY-2021              | October                | 2020              | 2270.00                   |
    | 1619-AS-2021-10018344-3_6  | 1619-001        | FY-2021              | January                | 2021              | 2702.00                   |
    | 1619-AS-2021-10018361-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 6767.00                   |
    | 1619-AS-2021-10019026-1_2  | 1619-001        | FY-2021              | October                | 2020              | 5511.00                   |
    | 1619-AS-2021-10019041-3_6  | 1619-001        | FY-2021              | January                | 2021              | 6990.00                   |
    | 1619-AS-2021-10019048-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 4949.00                   |
    | 1619-AS-2021-10019065-1_2  | 1619-001        | FY-2021              | October                | 2020              | 5117.00                   |
    | 1619-AS-2021-10019087-3_6  | 1619-001        | FY-2021              | January                | 2021              | 7578.00                   |
    | 1619-AS-2021-10019096-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 4360.00                   |
    | NLG-AS-2021-10019314-5_1   | NLG-001         | FY-2021              | March                  | 2021              | 5012.00                   |
    | NLG-AS-2021-10019380-1_2   | NLG-001         | FY-2021              | October                | 2020              | 6388.00                   |
    | NLG-AS-2021-10019383-3_6   | NLG-001         | FY-2021              | January                | 2021              | 1009.00                   |
    | NLG-AS-2021-10019431-5_1   | NLG-001         | FY-2021              | May                    | 2021              | 9822.00                   |
    | 1619-AS-2021-10025086-1_2  | 1619-001        | FY-2021              | October                | 2020              | 6459.00                   |
    | 1619-AS-2021-10025277-3_6  | 1619-001        | FY-2021              | January                | 2021              | 8202.00                   |
    | 1619-AS-2021-10025297-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 2940.00                   |
    | 1619-AS-2021-10025328-1_2  | 1619-001        | FY-2021              | October                | 2020              | 6587.00                   |
    | 1619-AS-2021-10025344-3_6  | 1619-001        | FY-2021              | January                | 2021              | 3502.00                   |
    | 1619-AS-2021-10025361-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 7073.00                   |
    | 1619-AS-2021-10027026-1_2  | 1619-001        | FY-2021              | October                | 2020              | 9298.00                   |
    | 1619-AS-2021-10027041-3_6  | 1619-001        | FY-2021              | January                | 2021              | 7826.00                   |
    | 1619-AS-2021-10027048-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 1171.00                   |
    | 1619-AS-2021-10027065-1_2  | 1619-001        | FY-2021              | October                | 2020              | 1600.00                   |
    | 1619-AS-2021-10027087-3_6  | 1619-001        | FY-2021              | January                | 2021              | 8805.00                   |
    | 1619-AS-2021-10027096-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 8362.00                   |
    | NLG-AS-2021-10027314-5_1   | NLG-001         | FY-2021              | March                  | 2021              | 4788.00                   |
    | NLG-AS-2021-10027380-1_2   | NLG-001         | FY-2021              | October                | 2020              | 8158.00                   |
    | NLG-AS-2021-10027383-3_6   | NLG-001         | FY-2021              | January                | 2021              | 5575.00                   |
    | NLG-AS-2021-10027431-5_1   | NLG-001         | FY-2021              | May                    | 2021              | 5461.00                   |
    | 1619-AS-2021-10031086-1_2  | 1619-001        | FY-2021              | October                | 2020              | 9097.00                   |
    | 1619-AS-2021-10031337-3_6  | 1619-001        | FY-2021              | January                | 2021              | 9206.00                   |
    | 1619-AS-2021-10031297-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 4274.00                   |
    | 1619-AS-2021-10031328-1_2  | 1619-001        | FY-2021              | October                | 2020              | 4703.00                   |
    | 1619-AS-2021-10031344-3_6  | 1619-001        | FY-2021              | January                | 2021              | 9465.00                   |
    | 1619-AS-2021-10031361-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 4213.00                   |
    | 1619-AS-2021-10033026-1_2  | 1619-001        | FY-2021              | October                | 2020              | 3521.00                   |
    | 1619-AS-2021-10033041-3_6  | 1619-001        | FY-2021              | January                | 2021              | 4088.00                   |
    | 1619-AS-2021-10033048-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 8002.00                   |
    | 1619-AS-2021-10033065-1_2  | 1619-001        | FY-2021              | October                | 2020              | 7838.00                   |
    | 1619-AS-2021-10033087-3_6  | 1619-001        | FY-2021              | January                | 2021              | 7556.00                   |
    | 1619-AS-2021-10033096-5_1  | 1619-001        | FY-2021              | July                   | 2021              | 8067.00                   |
    | NLG-AS-2021-10033314-5_1   | NLG-001         | FY-2021              | March                  | 2021              | 9560.00                   |
    | NLG-AS-2021-10033380-1_2   | NLG-001         | FY-2021              | October                | 2020              | 5901.00                   |
    | NLG-AS-2021-10033383-3_6   | NLG-001         | FY-2021              | January                | 2021              | 4272.00                   |
    | NLG-AS-2021-10033431-5_1   | NLG-001         | FY-2021              | May                    | 2021              | 8726.00                   |
    | DADA-AY-2021-10044531-4_0  | DADA-001        | FY-2021              | July                   | 2021              | 5449.00                   |
    | DADA-AY-2021-10044621-4_0  | DADA-001        | FY-2021              | May                    | 2021              | 5644.00                   |
    | DADA-AY-2021-10044708-4_0  | DADA-001        | FY-2021              | March                  | 2021              | 4137.00                   |
 

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM


    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | DADA            | AY2021        | DADA2021     | Contract for Services                   | DADA_CfS                  |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) | CofG_College              |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (HEI)     | CofG_HEI                  |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (NMSS)    | CofG_NMSS                 |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)     | CofG_SPI                  |
    | EDSK            | AY2021        | 16-19ED2021  | Contract for Services (ITP)             | CoS_ITP                   |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG                       |


    # Check the state of the Release Groups (J129)
    Then  Release Group '[DADA_CfS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 15230.00        |

    And  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 15              | 84167.00        |

    And   Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 11864.00        |

    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 13560.00        |

    And   Release Group '[CofG_NMSS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 9               | 51987.00        |

    And   Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 7062.00         |

    And   Release Group '[CoS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 5               | 42481.00        |

    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 12              | 74672.00        |


#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Groups together
#   #When  a request is triggered to release the following Release Group
#    | ReleaseGroup        |
#    | [DADA_CfS]          |
#    | [CofG_College]      |
#    | [CofG_HEI]          |
#    | [CofG_LA]           |
#    | [CofG_NMSS]         |
#    | [CofG_SPI]          |
#    | [CoS_ITP]           |
#    | [NLG]               |


    # Tidy Up
    Then  the override date is reset
  
   