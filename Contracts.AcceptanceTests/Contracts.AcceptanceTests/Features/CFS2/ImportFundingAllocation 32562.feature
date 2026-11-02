Feature: ImportFundingAllocation 32562

@AcceptanceTest @Withdrawn20210702
@CFS
Scenario: A534 Import a 1619 FA and create a Release Group. Import another 1619 FA and add it to the Release Group. Import NLG FA. Create 2nd Release Group. Release both Release Groups together
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017534'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10018534'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10019534'
    And   there is no Funding Allocation data in CRM for UKPRN '10017534'
    And   there is no Funding Allocation data in CRM for UKPRN '10018534'
    And   there is no Funding Allocation data in CRM for UKPRN '10019534'
    And   there is no Contract, Task or Workflow data for UKPRN '10017534'
    And   there is no Contract, Task or Workflow data for UKPRN '10018534'
    And   there is no Contract, Task or Workflow data for UKPRN '10019534'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017534' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10018534' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed '10019534' in the Sharepoint 'NLG-2021-Input-Appendices' folder


    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)     |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017534' 
    And   there is no Organisation data for UKPRN '10018534' 
    And   there is no Organisation data for UKPRN '10019534' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017534 Co Ltd' with UKPRN '10017534' and OrgId 'ORG0017534' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018534 Co Ltd' with UKPRN '10018534' and OrgId 'ORG0018534' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10019534 Co Ltd' with UKPRN '10019534' and OrgId 'ORG0019534' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017534 | 117534 | 10017534 Co Ltd | 0              | Active                | Yes           | AA017534      | ?             | 76 Moorfield Road      | Denham Green           | ?                      | ?                      | Uxbridge               | Middlesex              | UB9 5NF   |
    | 10018534 | 118534 | 10018534 Co Ltd | 0              | Active                | Yes           | AA018534      | ?             | 301 Histon Road        | Cambridge              | ?                      | ?                      | ?                      | ?                      | CB4 3NF   |
    | 10019534 | 119534 | 10019534 Co Ltd | 0              | Active                | Yes           | AA019534      | ?             | 8 Tudor Way            | Petts Wood             | Kent                   | ?                      | ?                      | ?                      | BR1 1DZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017534 |
    | 10018534 |
    | 10019534 |





    # Populate the stub with the FIRST Funding Allocation

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation (1)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                       | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017534 | 1619-AS-2021-Contract-Provider-10017534-1_4     | 1_4            | 1619                        | AS-2021            | 76358.00          |

    # Provider Funding Allocation (1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                       | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10017534-1_4  | 1_4                    | 1619-AS-2021-Contract-Provider-10017534-1_4     | 10017534      | Furth        | 18ISP           | 76358.00                  |

    # Funding Allocation Line (aka Deliverable) (1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10017534-1_4  | 1619-001        | 20775.00         | Payment         |
    | 1619-AS-2021-10017534-1_4  | 1619-008        | 18507.00         | Payment         |
    | 1619-AS-2021-10017534-1_4  | 1619-010        | 21736.00         | Payment         |
  # | 1619-AS-2021-10017534-1_4  | 1619-012        | 8692.00          | Payment         |
    | 1619-AS-2021-10017534-1_4  | 1619-013        | 15340.00         | Payment         |

    # Funding Allocation Profile Period (1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10017534-1_4  | 1619-001        | FY-2021              | May                    | 2021              | 5274.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-001        | FY-2021              | February               | 2021              | 5060.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-001        | FY-2021              | January                | 2021              | 5840.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-001        | FY-2021              | September              | 2020              | 4601.00                   |
    #
    | 1619-AS-2021-10017534-1_4  | 1619-008        | FY-2021              | April                  | 2021              | 4210.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-008        | FY-2021              | March                  | 2021              | 5807.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-008        | FY-2021              | August                 | 2020              | 2132.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-008        | FY-2021              | December               | 2020              | 4295.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-008        | FY-2021              | June                   | 2021              | 2063.00                   |
    #
    | 1619-AS-2021-10017534-1_4  | 1619-010        | FY-2021              | December               | 2020              | 4400.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-010        | FY-2021              | September              | 2020              | 2295.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-010        | FY-2021              | March                  | 2021              | 3588.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-010        | FY-2021              | May                    | 2021              | 2023.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-010        | FY-2021              | July                   | 2021              | 5655.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-010        | FY-2021              | November               | 2020              | 3775.00                   |
    #
 #  | 1619-AS-2021-10017534-1_4  | 1619-012        | FY-2021              | April                  | 2021              | 3718.00                   |
 #  | 1619-AS-2021-10017534-1_4  | 1619-012        | FY-2021              | October                | 2020              | 4974.00                   |
    #
    | 1619-AS-2021-10017534-1_4  | 1619-013        | FY-2021              | September              | 2020              | 5661.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-013        | FY-2021              | January                | 2021              | 2797.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-013        | FY-2021              | June                   | 2021              | 3497.00                   |
    | 1619-AS-2021-10017534-1_4  | 1619-013        | FY-2021              | April                  | 2021              | 3385.00                   |





    # Consume stub data
    
    # Change the date 
    Given the override date is '15/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10017534 | 10017534 Co Ltd  | 1619-AS-2021-Contract-Provider-10017534-1_4       | 1_4            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 76358.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2021-Contract-Provider-10017534-1_4       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

    # Check PaaS FundingAllocation.FundingAllocation 
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | 
    | 10017534 | 1619-AS-2021-Contract-Provider-10017534-1_4       | 1_4            | AS-2021 | 1619                        | 76358.00    |

    # Capture the [ReleaseGroup] parameter values (J127)
   #Given the Release Group for the following Contracting Profile has been saved   
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (SPI)     | CofG_SPI                  |

    # Check PaaS FundingAllocation.FundingAllocation 
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017534 | 1619-AS-2021-Contract-Provider-10017534-1_4       | 1_4            | AS-2021 | 1619                        | 76358.00    | [CofG_SPI]     |

    # Check the state of a Release Group (J129)
    And   Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 76358.00        |





    # Populate the stub with the SECOND Funding Allocation

    # Change the date 
    Given the override date is '16/06/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation (2)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                       | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10018534 | 1619-AS-2021-Contract-Provider-10018534-4_2     | 4_2            | 1619                        | AS-2021            | 23832.00          |

    # Provider Funding Allocation (2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                       | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2021-10018534-4_2  | 4_2                    | 1619-AS-2021-Contract-Provider-10018534-4_2     | 10018534      | Furth        | 18ISP           | 23832.00                  |

    # Funding Allocation Line (aka Deliverable) (2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2021-10018534-4_2  | 1619-005        | 11158.00         | Payment         |
    | 1619-AS-2021-10018534-4_2  | 1619-006        | 12674.00         | Payment         |

    # Funding Allocation Profile Period (2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2021-10018534-4_2  | 1619-005        | FY-2021              | June                   | 2021              | 3260.00                   |
    | 1619-AS-2021-10018534-4_2  | 1619-005        | FY-2021              | December               | 2020              | 3287.00                   |
    | 1619-AS-2021-10018534-4_2  | 1619-005        | FY-2021              | August                 | 2020              | 4611.00                   |
    #
    | 1619-AS-2021-10018534-4_2  | 1619-006        | FY-2021              | May                    | 2021              | 4723.00                   |
    | 1619-AS-2021-10018534-4_2  | 1619-006        | FY-2021              | December               | 2020              | 3826.00                   |
    | 1619-AS-2021-10018534-4_2  | 1619-006        | FY-2021              | August                 | 2020              | 4125.00                   |





    # Populate the stub with the THIRD Funding Allocation
   
    # Funding Allocation (3)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                         | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10019534 | NLG-AS-2021-Contract-Provider-10019534-3_6        | 3_6            | NLG                         | AS-2021            | 18318.00          |

    # Provider Funding Allocation (3)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                   | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2021-10019534-3_6   | 3_6                    | NLG-AS-2021-Contract-Provider-10019534-3_6  | 10019534      | Furth        | 05ADC           | 18318.00                  |

    # Funding Allocation Line (aka Deliverable) (3)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2021-10019534-3_6   | NLG-001         | 5216.00          | Payment         |
    | NLG-AS-2021-10019534-3_6   | NLG-002         | 13102.00         | Payment         |

    # Funding Allocation Profile Period (3)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2021-10019534-3_6   | NLG-001         | FY-2021              | November               | 2020              | 5216.00                   |
    #
    | NLG-AS-2021-10019534-3_6   | NLG-002         | FY-2021              | October                | 2020              | 2477.00                   |
    | NLG-AS-2021-10019534-3_6   | NLG-002         | FY-2021              | November               | 2020              | 3989.00                   |
    | NLG-AS-2021-10019534-3_6   | NLG-002         | FY-2021              | April                  | 2021              | 2391.00                   |
    | NLG-AS-2021-10019534-3_6   | NLG-002         | FY-2021              | May                    | 2021              | 4245.00                   |





    # Consume stub data for the SECOND and THIRD Funding Allocations into CRM
    
    # Change the date 
    Given the override date is '18/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the SECOND CRM Funding Allocation
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                         | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10018534 | 10018534 Co Ltd  | 1619-AS-2021-Contract-Provider-10018534-4_2       | 4_2            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (SPI)      | 1619                        | 16-19ED2021     | Scheduling        | Awaiting Release  | 23832.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus         | PreviousStatus | PreviousSubStatus    |
    | 1619-AS-2021-Contract-Provider-10018534-4_2       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release     | ?              | ?                    |

     # Capture the [ReleaseGroup] parameter values (J127)
   #Given the Release Group for the following Contracting Profile has been saved   
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG                       |     

    # Check PaaS FundingAllocation.FundingAllocation 
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10018534 | 1619-AS-2021-Contract-Provider-10018534-4_2             | 4_2            | AS-2021 | 1619                        | 23832.00    | [CofG_SPI]     |

    # Has the Funding Allocation been added to the first Release Group ?
    Then  Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 100190.00       |
    




     # Capture the [ReleaseGroup] parameter values (J127)
   #Given the Release Group for the following Contracting Profile has been saved   
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      | NLG                       |     
    
    # Check that the Funding Allocation has been put in a second Release Group
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 18318.00        |

    # Check the THIRD CRM Funding Allocation
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy       |
    | 10019534 | 10019534 Co Ltd  | NLG-AS-2021-Contract-Provider-10019534-3_6              | 3_6            | Non-learning Grants        | AY2021  | Non-learning Grant                       | NLG                         | NLG2021         | Scheduling        | Awaiting Release  | 18318.00    | ?             | ?                 | CRM Integration  | CRM Integration  |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus     |
    | 10017534 | 1619-AS-2021-Contract-Provider-10017534-1_4             | 1_4            | AS-2021 | 1619                        | 76358.00    | [CofG_SPI]      | ?                 | ?             |
    | 10018534 | 1619-AS-2021-Contract-Provider-10018534-4_2             | 4_2            | AS-2021 | 1619                        | 23832.00    | [CofG_SPI]      | ?                 | ?             |
    | 10019534 | NLG-AS-2021-Contract-Provider-10019534-3_6              | 3_6            | AS-2021 | NLG                         | 18318.00    | [NLG]           | ?                 | ?             |








    # Release both Release Groups (with 3 Funding Allocations) from Contract Control

   #When  a request is triggered to release the Funding Allocations in Release Group '[ReleaseGroup]'
    When  a request is triggered to release the following Release Groups together
    | ReleaseGroup     |
    | [CofG_SPI]       |
    | [NLG]            |

    # Write the value of the ReleaseGroupParameters to the output window
    And   message 'ReleaseGroup CofG_SPI = [CofG_SPI] and NLG = [NLG]' is written to the Output window

    # Has the Release Status changed on both Release Groups ?
    Then  Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus        | AllocationCount | AllocationValue |
    | Released             | 2               | 100190.00       |

    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus        | AllocationCount | AllocationValue |
    | Released             | 1               | 18318.00        |


    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                         | Action               | CompletedBy       | NewStatus      | NewSubStatus          | PreviousStatus | PreviousSubStatus     |
    | 1619-AS-2021-Contract-Provider-10017534-1_4       | Release Successful   | CRM Integration   | Released       | Released              | In Release     | Release in Progress   |
    | 1619-AS-2021-Contract-Provider-10017534-1_4       | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | 1619-AS-2021-Contract-Provider-10017534-1_4       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |
    #
    | 1619-AS-2021-Contract-Provider-10018534-4_2       | Release Successful   | CRM Integration   | Released       | Released              | In Release     | Release in Progress   |
    | 1619-AS-2021-Contract-Provider-10018534-4_2       | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | 1619-AS-2021-Contract-Provider-10018534-4_2       | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |
    #
    | NLG-AS-2021-Contract-Provider-10019534-3_6        | Release Successful   | CRM Integration   | Released       | Released              | In Release     | Release in Progress   |
    | NLG-AS-2021-Contract-Provider-10019534-3_6        | Initiate Release     | CRM Integration   | In Release     | Release in Progress   | Scheduling     | Awaiting Release      |
    | NLG-AS-2021-Contract-Provider-10019534-3_6        | Record Imported      | CRM Integration   | Scheduling     | Awaiting Release      | ?              | ?                     |


    # Tidy Up
    And   the override date is reset

