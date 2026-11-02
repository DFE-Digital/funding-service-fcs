Feature: Create1920AEBPcontractsA 26143

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run67
Scenario: A735SLD Create and approve a 1920 EDSK contract with PoA allocations. Consume actuals and generate PoA payments. Check CRM, PaaS, CDA and payment feed
    Given there are no allocations marked as Under Termination for UKPRN '10017735' 
    And   there are no terminated or closed allocations for UKPRN '10017735' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017735' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-735      |
    | ALLB-735      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017735' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017735 Co Ltd' with UKPRN '10017735' and OrgId 'ORG0017735' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017735' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status     | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017735 | 117735 | 10017735 Co Ltd | 0              | Active     | Yes           | AA017735      | ?             | 34 Comet Road          | ?                      | ?                      | ?                      | Hatfield               | Hertfordshire          | AL10 0SX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017735 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017735 | 10017735 Co Ltd      | ESFA-735             | EDSK-735       | 1                     | 01/08/2019        | 31/07/2020      | 74399.00      |                                    | Conditions of Funding (Grant) (Employer)   | 1920   | New          | ORG0017735 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017735 | EDSK-735       | 16TR-735      | 16-18TRN          | 16-18TRN1920            | AY                      | 01/08/2019          | 31/07/2020        | 46169.00        |                                         |            |                                                             | New          |             |
    | 10017735 | EDSK-735       | ALLB-735      | ALLB              | ALLB1920                | AY                      | 01/08/2019          | 31/07/2020        | 28230.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017735 | EDSK-735       | 16TR-735      | 1               | 0                     | 46169.00  | 3467.00  | 4085.00  | 3215.00  | 5824.00  | 4416.00  | 3957.00  | 1634.00  | 4149.00  | 3023.00  | 3453.00  | 5113.00  | 3833.00  | 16-18 Traineeships Funding                                      | New          |             |
    | 10017735 | EDSK-735       | 16TR-735      | 2               | 1                     | 25890.00  | 659.00   | 3135.00  | 3110.00  | 2201.00  | 1228.00  | 3165.00  | 1055.00  | 1949.00  | 2967.00  | 1648.00  | 2888.00  | 1885.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017735 | EDSK-735       | 16TR-735      | 3               | 1                     | 20279.00  | 2808.00  | 950.00   | 105.00   | 3623.00  | 3188.00  | 792.00   | 579.00   | 2200.00  | 56.00    | 1805.00  | 2225.00  | 1948.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017735 | EDSK-735       | ALLB-735      | 1               | 0                     | 28230.00  | 3388.00  | 3616.00  | 967.00   | 2494.00  | 2597.00  | 3269.00  | 270.00   | 3601.00  | 1995.00  | 3111.00  | 745.00   | 2177.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-735' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-735' and actual ContractNumber 'EDSK-735'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-735' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017735 | EDSK-735           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017735 | ESFA-735           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '84' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract 'EDSK-735'




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/03/2020'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    And there are no entries in the summarised actuals PaaS table

    # Pull actuals from DC for Feb 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201908 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 1676.25     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201908 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 1926.40     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201909 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 2117.41     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201909 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 369.99      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201910 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 1785.33     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201910 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 2270.05     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201911 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 2073.75     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201911 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 539.06      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201912 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 1763.87     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201912 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 1477.21     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202001 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 423.93      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202001 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 1373.48     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202002 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 205.75      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202002 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 1516.20     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202003 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 413.02      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202003 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 1688.02     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202004 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 1416.61     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202004 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 1620.16     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202005 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 1491.57     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202005 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 2081.09     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202006 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 1951.26     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202006 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 274.59      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202007 | 16-18TRN1920            | 16TR-735                 | ?          | 2               | 0            | 553.07      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202007 | 16-18TRN1920            | 16TR-735                 | ?          | 3               | 0            | 1222.17     |
    #
    | ILR1920        | R07                  | ORG0017735     | CM             | 201908 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 1751.27     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201908 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 204.84      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201908 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 971.51      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201909 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 2339.34     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201909 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 1482.40     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201909 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 1963.59     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201910 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 638.81      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201910 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 1106.74     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201910 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 472.15      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201911 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 518.37      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201911 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 2202.41     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201911 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 532.17      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201912 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 2447.23     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201912 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 1639.05     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 201912 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 2302.67     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202001 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 2444.49     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202001 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 271.04      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202001 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 485.35      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202002 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 610.44      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202002 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 1981.12     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202002 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 2081.27     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202003 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 1594.34     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202003 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 2264.56     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202003 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 1875.62     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202004 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 427.25      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202004 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 1067.90     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202004 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 1709.29     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202005 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 945.13      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202005 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 2007.59     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202005 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 560.30      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202006 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 731.90      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202006 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 2377.89     |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202006 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 407.57      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202007 | ALLB1920                | ALLB-735                 | ?          | 2               | 0            | 265.62      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202007 | ALLB1920                | ALLB-735                 | ?          | 3               | 0            | 700.11      |
    | ILR1920        | R07                  | ORG0017735     | CM             | 202007 | ALLB1920                | ALLB-735                 | ?          | 4               | 0            | 1020.70     |

    # Pull actuals from new Submit Learner Data (SLD) interface (24329)
    When  the FCT system polls the SLD service



    # Check the PoA allocation data in CRM and PaaS for the two PoA allocations

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-735       | 16TR-735        | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-735       | 16TR-735        | 2               | 10046.29  | 1676.25  | 2117.41  | 1785.33  | 2073.75  | 1763.87  | 423.93   | 205.75   | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-735       | 16TR-735        | 3               | 9472.39   | 1926.40  | 369.99   | 2270.05  | 539.06   | 1477.21  | 1373.48  | 1516.20  | ?        | ?        | ?        | ?        | ?        | 
    #
    | EDSK-735       | ALLB-735        | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-735       | ALLB-735        | 2               | 10749.95  | 1751.27  | 2339.34  | 638.81   | 518.37   | 2447.23  | 2444.49  | 610.44   | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-735       | ALLB-735        | 3               | 8887.60   | 204.84   | 1482.40  | 1106.74  | 2202.41  | 1639.05  | 271.04   | 1981.12  | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-735       | ALLB-735        | 4               | 8808.71   | 971.51   | 1963.59  | 472.15   | 532.17   | 2302.67  | 485.35   | 2081.27  | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-735       | 16TR-735        | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-735       | 16TR-735        | 2               | 10046.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10046.29 | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-735       | 16TR-735        | 3               | 9472.39   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9472.39  | ?        | ?        | ?        | ?        | ?        | 
    #
    | EDSK-735       | ALLB-735        | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-735       | ALLB-735        | 2               | 10749.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10749.95 | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-735       | ALLB-735        | 3               | 8887.60   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8887.60  | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-735       | ALLB-735        | 4               | 8808.71   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8808.71  | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-735       | 16TR-735           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-735       | 16TR-735           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-735       | 16TR-735           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-735       | ALLB-735           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-735       | ALLB-735           | 2               | -81.73    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -81.73   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-735       | ALLB-735           | 3               | -67.57    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -67.57   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-735       | ALLB-735           | 4               | -66.97    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -66.97   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-735       | 16TR-735           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-735       | 16TR-735           | 2               | 10046.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10046.29 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-735       | 16TR-735           | 3               | 9472.39   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9472.39  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-735       | ALLB-735           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-735       | ALLB-735           | 2               | 10668.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10668.22 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-735       | ALLB-735           | 3               | 8820.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8820.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-735       | ALLB-735           | 4               | 8741.74   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8741.74  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 201908               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 201908               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 201909               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 201909               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 201910               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 201910               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 201911               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 201911               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 201912               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 201912               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 202001               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 202001               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 202002               | RECONCILIATION  | CM             | False       | 10046.29        |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 202002               | RECONCILIATION  | CM             | False       | 9472.39         |
    #
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 201908               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 201909               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 201910               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 201911               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 201912               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 202001               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 202002               | RECONCILIATION  | CM             | False       | 28446.26        |

    # Check the CAPPING subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    #
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 201908               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 201908               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 201909               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 201909               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 201910               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 201910               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 201911               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 201911               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 201912               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 201912               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 202001               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 202001               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201300         | 16-18TRN1920               | 202002               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | 16TR-735          | 2201350         | 16-18TRN1920               | 202002               | CAPPING         | CM             | False       | 0.00            |
    #
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 201908               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 201909               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 201910               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 201911               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 201912               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 202001               | CAPPING         | CM             | False       | 0.00            |
    | 10017735 | ORG0017735 | ALLB-735          | 2303800         | ALLB1920                   | 202002               | CAPPING         | CM             | False       | -216.27         |




    # Payment Run
               
    # Change the date
    Given the override date is '09/03/2020 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And  there is no data in the Payment feed for FundingStreamPeriod '16-18TRN1920' AccountingPaymentPeriod '201911' CensusEndDate '09/03/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | 16TR-735                 | 202002 |

    # PaymentGeneration.PaymentTimetable
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18TRN1920               | 202002               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18TRN1920               | 202002               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18TRN1920' PaymentPeriod '201911' CensusEndDate '09/03/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A735_16TR.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    Then  the Payment feed xml for FundingStreamPeriod '16-18TRN1920' PaymentPeriod '201911' CensusEndDate '09/03/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 16TR                   | 2019          | 11             | 06          | ?       | 16TR-735      | 10046.29        | RECONCILIATION   | 16-18Traineeships       | 2020-03-19 | 2019-08-01   | 2020-07-31 | ?              | 10017735 | 2201300    |
    | 16TR                   | 2019          | 11             | 06          | ?       | 16TR-735      | 9472.39         | RECONCILIATION   | 16-18TraineeshipBurs    | 2020-03-19 | 2019-08-01   | 2020-07-31 | ?              | 10017735 | 2201350    |

    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod '16-18TRN1920' AccountingPaymentPeriod '201911' and CensusEndDate '09/03/2020'

    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                  |
    | Payment Requests for Funding Stream Period 16-18TRN1920 for Payment Period 201911 have been generated as of Census End Date/Time 2020-03-09T22:00:00Z. |

    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate        | PaymentLineCount | TotalValue |
    | 16-18TRN1920        | 201911        | 2020-03-09T22:00:00Z | 2                | 19518.68   |

    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | 16TR      | 01/08/2019   | 31/07/2020 | 09/03/2020    | 19/03/2020 | 2019          | 11             |

    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription   | AggregatedValue |
    | ORG0017735  | 10017735       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 16TR-735   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2201300    | RECONCILIATION | 16-18Traineeships       | 10046.29        |
    | ORG0017735  | 10017735       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 16TR-735   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2201350    | RECONCILIATION | 16-18TraineeshipBurs    | 9472.39         |




#	# CDA Reports
#
#    # Run the CDA report for 16-18TRN1920 
#    Given there is no CDA report named 'CDA Last Approved Version A735_16TR.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | EDSK-735       | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod | Version               | Suffix    |
#    | 16-18TRN1920        | Last Approved Version | A735_16TR |
#
#    Then  a report named 'CDA Last Approved Version A735_16TR.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 8                 | 2019            | 2019/20       |              | 2808         | 1926.4       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Aug              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 8                 | 2019            | 2019/20       |              | 659          | 1676.25      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Aug              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 9                 | 2019            | 2019/20       |              | 950          | 369.99       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Sep              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 9                 | 2019            | 2019/20       |              | 3135         | 2117.41      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Sep              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 10                | 2019            | 2019/20       |              | 105          | 2270.05      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Oct              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 10                | 2019            | 2019/20       |              | 3110         | 1785.33      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Oct              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 11                | 2019            | 2019/20       |              | 3623         | 539.06       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Nov              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 11                | 2019            | 2019/20       |              | 2201         | 2073.75      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Nov              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 12                | 2019            | 2019/20       |              | 1228         | 1763.87      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Dec              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 12                | 2019            | 2019/20       |              | 3188         | 1477.21      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Dec              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 1                 | 2020            | 2019/20       |              | 792          | 1373.48      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Jan              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 1                 | 2020            | 2019/20       |              | 3165         | 423.93       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Jan              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 2                 | 2020            | 2019/20       |              | 579          | 1516.2       |               |              | Yes                | 0.00           | 0.00             | 9472.39               | 0.00           | 9472.39         |             | Yes           |                   |        |                   | 2201350                  | 2201350           | Feb              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 2                 | 2020            | 2019/20       |              | 1055         | 205.75       |               |              | Yes                | 0.00           | 0.00             | 10046.29              | 0.00           | 10046.29        |             | Yes           |                   |        |                   | 2201300                  | 2201300           | Feb              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 3                 | 2020            | 2019/20       |              | 2200         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Mar              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 3                 | 2020            | 2019/20       |              | 1949         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Mar              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 4                 | 2020            | 2020/21       |              | 56           |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Apr              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 4                 | 2020            | 2020/21       |              | 2967         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Apr              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 5                 | 2020            | 2020/21       |              | 1805         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | May              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 5                 | 2020            | 2020/21       |              | 1648         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | May              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 6                 | 2020            | 2020/21       |              | 2888         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Jun              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 6                 | 2020            | 2020/21       |              | 2225         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Jun              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | 16-18 Traineeships Funding                                      | 7                 | 2020            | 2020/21       |              | 1948         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Jul              |
#    | 16-18TRN1920            | 10017735 | 10017735 Co Ltd             |               |                             | 16TR-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | 16-18 Traineeships Funding                                      | 7                 | 2020            | 2020/21       |              | 1885         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Jul              |




#    # Run the CDA report for ALLB1920
#    Given there is no CDA report named 'CDA Last Approved Version A735_ALLB.csv'
#    
#    When  the following CDA report is run
#    | FundingStreamPeriod | Version               | Suffix    |
#    | ALLB1920            | Last Approved Version | A735_ALLB |
#
#    Then  a report named 'CDA Last Approved Version A735_ALLB.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 8                 | 2019            | 2019/20       |              | 3388         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 9                 | 2019            | 2019/20       |              | 3616         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 10                | 2019            | 2019/20       |              | 967          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 11                | 2019            | 2019/20       |              | 2494         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 12                | 2019            | 2019/20       |              | 2597         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 1                 | 2020            | 2019/20       |              | 3269         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 2                 | 2020            | 2019/20       |              | 270          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 3                 | 2020            | 2019/20       |              | 3601         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 4                 | 2020            | 2020/21       |              | 1995         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 5                 | 2020            | 2020/21       |              | 3111         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 6                 | 2020            | 2020/21       |              | 745          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 7                 | 2020            | 2020/21       |              | 2177         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 8                 | 2019            | 2019/20       |              | 0            | 204.84       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Aug              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 9                 | 2019            | 2019/20       |              | 0            | 1482.40      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Sep              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 10                | 2019            | 2019/20       |              | 0            | 1106.74      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Oct              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 11                | 2019            | 2019/20       |              | 0            | 2202.41      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Nov              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 12                | 2019            | 2019/20       |              | 0            | 1639.05      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Dec              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 1                 | 2020            | 2019/20       |              | 0            | 271.04       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Jan              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 2                 | 2020            | 2019/20       |              | 0            | 1981.12      |               |              | Yes                | 0.00           | 0.00             | 8887.60               | -67.57         | 8820.03         |             | No            |                   |        |                   | 2303800                  | 2303800           | Feb              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 3                 | 2020            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Mar              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 4                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Apr              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 5                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | May              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 6                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Jun              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Area Costs                                   | Loans - Area Costs                                              | Total Advanced Learner Loans Bursary Funding                    | 7                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Jul              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 8                 | 2019            | 2019/20       |              | 0            | 1751.27      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Aug              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 9                 | 2019            | 2019/20       |              | 0            | 2339.34      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Sep              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 10                | 2019            | 2019/20       |              | 0            | 638.81       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Oct              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 11                | 2019            | 2019/20       |              | 0            | 518.37       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Nov              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 12                | 2019            | 2019/20       |              | 0            | 2447.23      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Dec              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 1                 | 2020            | 2019/20       |              | 0            | 2444.49      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Jan              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 2                 | 2020            | 2019/20       |              | 0            | 610.44       |               |              | Yes                | 0.00           | 0.00             | 10749.95              | -81.73         | 10668.22         |             | No            |                   |        |                   | 2303800                  | 2303800           | Feb              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 3                 | 2020            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Mar              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 4                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Apr              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 5                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | May              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 6                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Jun              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Bursary Funding                              | Loans - Bursary Funding                                         | Total Advanced Learner Loans Bursary Funding                    | 7                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Jul              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 8                 | 2019            | 2019/20       |              | 0            | 971.51       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Aug              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 9                 | 2019            | 2019/20       |              | 0            | 1963.59      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Sep              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 10                | 2019            | 2019/20       |              | 0            | 472.15       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Oct              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 11                | 2019            | 2019/20       |              | 0            | 532.17       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Nov              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 12                | 2019            | 2019/20       |              | 0            | 2302.67      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Dec              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 1                 | 2020            | 2019/20       |              | 0            | 485.35       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Jan              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 2                 | 2020            | 2019/20       |              | 0            | 2081.27      |               |              | Yes                | 0.00           | 0.00             | 8808.71               | -66.97         | 8741.74         |             | No            |                   |        |                   | 2303800                  | 2303800           | Feb              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 3                 | 2020            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Mar              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 4                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Apr              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 5                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | May              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 6                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Jun              |
#    | ALLB1920                | 10017735 | 10017735 Co Ltd             |               |                             | ALLB-735                 | EDSK-735       | ESFA-735                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | Loans - Excess Claims                                | Loans - Excess Claims                                           | Total Advanced Learner Loans Bursary Funding                    | 7                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2303800                  | 2303800           | Jul              |


    # Tidy up
    And   the override date is reset
       
@AcceptanceTest @Withdrawn20231002
Scenario: A741 Create and approve 1718 and 1819 AEBP contracts. Bulk load a 5-allocation 1920 AEBP contract. All 3 contracts share a Master Contract No. Check docs and CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017741' 
    And   there are no terminated or closed allocations for UKPRN '10017741' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017741' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017741'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017741' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017741 Co Ltd' with UKPRN '10017741' and OrgId 'ORG0017741' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017741' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status    | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017741 | 117741 | 10017741 Co Ltd | 0              | Active    | Yes           | AA017741      | ?             | 9 Merchants Place      | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 1DP   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017741 |




    # Change the date
    Given the override date is '01/11/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017741 | 10017741 Co Ltd      | ESFA-741             | AEBP-7411      | 1                     | 01/11/2017        | 31/07/2018      | 55235.00      |                                    | Contract for Services                      | 1718   | New          | ORG0017741 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017741 | AEBP-7411      | AEBC-7411     | AEB-CL            | AEB-CL1718              | AY                      | 01/11/2017          | 31/07/2018        | 22240.00        |                                         |            |                                                             | New          |             |
    | 10017741 | AEBP-7411      | AEBL-7411     | AEB-LS            | AEB-LS1718              | AY                      | 01/11/2017          | 31/07/2018        | 18182.00        |                                         |            |                                                             | New          |             |
    | 10017741 | AEBP-7411      | AEBT-7411     | AEB-TOL           | AEB-TOL1718             | AY                      | 01/11/2017          | 31/07/2018        | 14813.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017741 | AEBP-7411      | AEBC-7411     | 1               | 0                     | 22240.00  | 3333.00  | 3308.00  | 2399.00  | 1426.00  | 3363.00  | 1253.00  | 2147.00  | 3165.00  | 1846.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017741 | AEBP-7411      | AEBL-7411     | 1               | 0                     | 18182.00  | 2175.00  | 2911.00  | 1685.00  | 1661.00  | 751.00   | 3479.00  | 1715.00  | 3306.00  | 499.00   | Adult Education Budget - Learner Support                        | New          |             |
    | 10017741 | AEBP-7411      | AEBT-7411     | 1               | 0                     | 14813.00  | 1912.00  | 593.00   | 1833.00  | 830.00   | 1122.00  | 2965.00  | 2119.00  | 1937.00  | 1502.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '02/11/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-7411' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-741' and actual ContractNumber 'AEBP-7411'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-7411' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017741 | AEBP-7411          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017741 | ESFA-741           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-7411'




    # Create and approve an 1819 AEBP contract with the same Master as the 1718 AEBP contract

    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent      | OrgId      |
    | 10017741 | 10017741 Co Ltd      | ESFA-741             | AEBP-7412      | 1                     | 01/08/2018        | 31/07/2019      | 72379.00      |                                    | Contract for Services                      | 1819   | New Amendment  | ORG0017741 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017741 | AEBP-7412      | AEBC-7412     | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 23941.00        |                                         |            |                                                             | New          |             |
    | 10017741 | AEBP-7412      | AEBL-7412     | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 27479.00        |                                         |            |                                                             | New          |             |
    | 10017741 | AEBP-7412      | AEBT-7412     | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 20959.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017741 | AEBP-7412      | AEBC-7412     | 1               | 0                     | 23941.00  | 257.00   | 1339.00  | 810.00   | 3380.00  | 2090.00  | 2258.00  | 3721.00  | 2051.00  | 2377.00  | 3365.00  | 400.00   | 1893.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017741 | AEBP-7412      | AEBL-7412     | 1               | 0                     | 27479.00  | 3433.00  | 2524.00  | 1550.00  | 3487.00  | 1377.00  | 1289.00  | 3290.00  | 1970.00  | 3211.00  | 2208.00  | 2499.00  | 641.00   | Adult Education Budget - Learner Support                        | New          |             |
    | 10017741 | AEBP-7412      | AEBT-7412     | 1               | 0                     | 20959.00  | 2113.00  | 2914.00  | 2479.00  | 82.00    | 3571.00  | 1490.00  | 3047.00  | 1095.00  | 532.00   | 255.00   | 1085.00  | 2296.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-7412' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-741' and actual ContractNumber 'AEBP-7412'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-7412' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017741 | AEBP-7411          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017741 | AEBP-7412          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017741 | ESFA-741           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-7412'




    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    #   The record should not appear in the SoF as it only relates to AEB-AS2021
    Given the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017741 | AEB-AS2021    | 2121.00     | 250.00      |




    # Change the date
    Given the override date is '17/07/2019'

    # Bulk load a new amendment to add a 1920 AEB contract to the same master as above
    And   there are no files prefixed '10017741' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 24062019174844 v3_A741' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 24062019174844 v3_A741' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 24062019174844 v3_A741' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 24062019174844 v3_A741.xlsx' exists in the Datafiles folder and UKPRN '10017741' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   


    # Retrieve parameters for 1920
   #Given I retrieve the latest EFA contract details from CRM for provider '10017741' for FundingType 'AEB' and period '1920' and Delivery Organisation '10017741'
    Given I retrieve the latest contract details from CRM for provider '10017741' for FundingType 'AEB' and period '1920'  

    # Check the document parts are present and in the right order
    Then  a file for this contract exists in sharepoint location 'AEB-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017741 Co Ltd UKPRN: 10017741
    Master Contract Number: ESFA-741

    1 November 2017 to 31 July 2018 Contract Ref Nov 17 - Mar 18 Apr 18 - Jul 18 Total
	1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
	1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total

	Total Funding for this contract: £364,918

	Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships
	Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills
	Funding Agreement ESFA-Funded Adult Education Budget - Community Learning
	Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships Learner Support
	Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills Learner Support
	"""
	



    # Retrieve parameters for 1718
   #Given I retrieve the latest EFA contract details from CRM for provider '10017741' for FundingType 'AEB' and period '1718' and Delivery Organisation '10017741'
    Given I retrieve the latest contract details from CRM for provider '10017741' for FundingType 'AEB' and period '1718'  

	# Check the Summary of Funding data for 1718
    Then  the pdf file contains the following page lines in order
    """
    Allocation
    1 November 2017 to 31 July 2018 Contract Ref Nov 17 - Mar 18 Apr 18 - Jul 18 Total
	Adult Education Budget - Traineeships and Other Learning [AllocRef_AEBT] £6,290 £8,523 £14,813
	Adult Education Budget - Community Learning [AllocRef_AEBC] £13,829 £8,411 £22,240
    Adult Education Budget - Learner Support [AllocRef_AEBL] £9,183 £8,999 £18,182
    Total: £55,235
	"""




    # Retrieve parameters for 1819
   #Given I retrieve the latest EFA contract details from CRM for provider '10017741' for FundingType 'AEB' and period '1819' and Delivery Organisation '10017741'
    Given I retrieve the latest contract details from CRM for provider '10017741' for FundingType 'AEB' and period '1819'  

    # Check the Summary of Funding data for 1819
    Then  the pdf file contains the following page lines in order
	"""
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
	Adult Education Budget - Traineeships and Other Learning [AllocRef_AEBT] £16,791 £4,168 £20,959
    Adult Education Budget - Community Learning [AllocRef_AEBC] £15,906 £8,035 £23,941
    Adult Education Budget - Learner Support [AllocRef_AEBL] £18,920 £8,559 £27,479
    Total: £72,379
	"""




    # Retrieve parameters for 1920
   #Given I retrieve the latest EFA contract details from CRM for provider '10017741' for FundingType 'AEB' and period '1920' and Delivery Organisation '10017741'
    Given I retrieve the latest contract details from CRM for provider '10017741' for FundingType 'AEB' and period '1920'  

    # Check the Summary of Funding data for 1920
    Then  the pdf file contains the following page lines in order
	"""
    Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AEBR] £21,668 £11,210 £32,878
    ESFA AEB - Adult Skills [AllocRef_AEBA] £40,263 £17,341 £57,604
    ESFA AEB - Community Learning [AllocRef_AEBC] £41,741 £16,216 £57,957
    ESFA AEB - 19 to 24 Traineeships Learner Support [AllocRef_AETL] £32,854 £10,092 £42,946
    ESFA AEB - Adult Skills Learner Support [AllocRef_AEAL] £35,411 £10,508 £45,919
    Total: £237,304
    """




	# Check the 1920 Funding Agreements
	And   the pdf file contains the following page lines in order
	"""
	Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships
    Provider: 10017741 Co Ltd UKPRN: 10017741
    Master Contract Number: ESFA-741 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEBR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £32,878 £2,808 £4,867 £2,914 £823 £4,984 £451 £261 £4,560 £1,725 £4,390 £2,234 £2,861
    Total Funding £32,878 £2,808 £4,867 £2,914 £823 £4,984 £451 £261 £4,560 £1,725 £4,390 £2,234 £2,861
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills
    Provider: 10017741 Co Ltd UKPRN: 10017741
    Master Contract Number: ESFA-741 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills £57,604 £7,233 £3,306 £5,025 £4,091 £6,893 £6,436 £1,967 £5,312 £1,118 £7,860 £7,265 £1,098
    Total Funding £57,604 £7,233 £3,306 £5,025 £4,091 £6,893 £6,436 £1,967 £5,312 £1,118 £7,860 £7,265 £1,098
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Community Learning
    Provider: 10017741 Co Ltd UKPRN: 10017741
    Master Contract Number: ESFA-741 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEBC]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Community Learning £57,957 £2,549 £936 £5,777 £7,156 £7,241 £6,986 £7,750 £3,346 £4,386 £5,490 £2,177 £4,163
    Total Funding £57,957 £2,549 £936 £5,777 £7,156 £7,241 £6,986 £7,750 £3,346 £4,386 £5,490 £2,177 £4,163
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships Learner Support
    Provider: 10017741 Co Ltd UKPRN: 10017741
    Master Contract Number: ESFA-741 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AETL]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships Learner Support £42,946 £3,553 £7,375 £6,963 £5,827 £3,396 £626 £986 £4,128 £541 £1,241 £3,364 £4,946
    Total Funding £42,946 £3,553 £7,375 £6,963 £5,827 £3,396 £626 £986 £4,128 £541 £1,241 £3,364 £4,946
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills Learner Support
    Provider: 10017741 Co Ltd UKPRN: 10017741
    Master Contract Number: ESFA-741 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEAL]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills Learner Support £45,919 £3,073 £5,334 £663 £6,725 £3,450 £7,070 £6,273 £2,823 £3,110 £138 £3,216 £4,044
    Total Funding £45,919 £3,073 £5,334 £663 £6,725 £3,450 £7,070 £6,273 £2,823 £3,110 £138 £3,216 £4,044
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # There should not be a zero value entry in the doc for Sector-based Work Academies. These are 2021+ (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £0 £0 £0
    """

    # There should not be a value entry in the doc for Sector-based Work Academies. These are 2021+ (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £2,121 £250 £2,371
    """

    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017741'
     
 