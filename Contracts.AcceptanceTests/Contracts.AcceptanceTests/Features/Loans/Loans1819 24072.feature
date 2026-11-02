Feature: Loans1819 24072

@AcceptanceTest @Withdrawn20230123
Scenario: A810SLD Create and approve an 1819 Loans contract with ALLBC, ALLF and CLP allocations. Consume actuals for all and check CRM, PaaS and ADP feed. Bulk attempt to create a new 1920 ALLF contract with intent of New Amendment. Fail <MessageNo>
    Given there is no Contract, Task or Workflow data for UKPRN '10017810' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLC-810      |
    | ALLF-810      |
    | CLP-810       |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017810' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017810 Co Ltd' with UKPRN '10017810' and OrgId 'ORG0017810' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017810' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017810 | 117810 | 10017810 Co Ltd | 0              | Active                | Yes           | AA017810      | ?             | 4 Mount Ephraim Rd     | Tunbridge Wells        | Kent                   | ?                      | ?                      | ?                      | TN1 1EE   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017810 |




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription  | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017810 | 10017810 Co Ltd      | ESFA-810             | LOANS-810      | 1                     | 01/08/2018        | 31/07/2019      | 64518.00      |                      | Contract for Services | 1819   | New          | ORG0017810 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName      | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017810 | LOANS-810      | ALLC-810      | ALLBC             | ALLBC1819               | AY                      | 01/08/2018          | 31/07/2019        | 18883.00        |              |            |                          | New          |             |
    | 10017810 | LOANS-810      | ALLF-810      | ALLF              | ALLF1819                | AY                      | 01/08/2018          | 31/07/2019        | 23127.00        |              |            |                          | New          |             |
    | 10017810 | LOANS-810      | CLP-810       | CLP               | CLP1819                 | AY                      | 01/08/2018          | 31/07/2019        | 22508.00        |              |            |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                        | CRMIntent    | DeliveryOrg |
    | 10017810 | LOANS-810      | ALLC-810      | 1               | 0                     | 18883.00  | 2361.00  | 755.00   | 1871.00  | 3206.00  | 937.00   | 2306.00  | 1901.00  | 1150.00  | 3403.00  | 344.00   | 384.00   | 265.00   | Total Advanced Learner Loans Bursary Funding  | New          |             |
    | 10017810 | LOANS-810      | ALLF-810      | 5               | 0                     | 23127.00  | 1555.00  | 487.00   | 3689.00  | 502.00   | 2661.00  | 3586.00  | 3531.00  | 977.00   | 1238.00  | 1436.00  | 843.00   | 2622.00  | Advanced Learner Loans Facility               | New          |             |
    | 10017810 | LOANS-810      | CLP-810       | 1               | 0                     | 22508.00  | 695.00   | 166.00   | 2736.00  | 1446.00  | 1614.00  | 3077.00  | 1407.00  | 1733.00  | 2721.00  | 3457.00  | 1249.00  | 2207.00  | Career Learning Pilots                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'LOANS-810' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-810' and actual ContractNumber 'LOANS-810'

    # Check that the contract is now approved
    Then  the latest version of contract 'LOANS-810' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017810 | LOANS-810          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017810 | ESFA-810           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract 'LOANS-810'




    # Change the date
    Given the override date is '04/11/2018'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    And there are no entries in the summarised actuals PaaS table

    # Pull actuals from DC for Nov 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201808 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 1793.32     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201808 | ALLBC1819               | ALLC-810                 |            | 3               | 10           | 1380.22     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201808 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 1490.85     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201809 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 794.95      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201809 | ALLBC1819               | ALLC-810                 |            | 3               | 20           | 824.67      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201809 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 1959.38     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201810 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 133.64      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201810 | ALLBC1819               | ALLC-810                 |            | 3               | 30           | 1925.74     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201810 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 2054.78     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201811 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 1801.69     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201811 | ALLBC1819               | ALLC-810                 |            | 3               | 40           | 208.84      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201811 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 1093.68     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201812 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 2170.29     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201812 | ALLBC1819               | ALLC-810                 |            | 3               | 50           | 1997.15     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201812 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 996.49      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201901 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 2408.69     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201901 | ALLBC1819               | ALLC-810                 |            | 3               | 60           | 2191.47     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201901 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 234.96      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201902 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 2378.94     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201902 | ALLBC1819               | ALLC-810                 |            | 3               | 70           | 973.64      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201902 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 1359.68     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201903 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 1941.07     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201903 | ALLBC1819               | ALLC-810                 |            | 3               | 80           | 228.41      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201903 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 1521.90     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201904 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 1224.88     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201904 | ALLBC1819               | ALLC-810                 |            | 3               | 90           | 815.60      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201904 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 1594.47     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201905 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 1654.77     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201905 | ALLBC1819               | ALLC-810                 |            | 3               | 100          | 733.10      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201905 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 770.42      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201906 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 2091.53     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201906 | ALLBC1819               | ALLC-810                 |            | 3               | 110          | 2079.05     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201906 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 1513.99     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201907 | ALLBC1819               | ALLC-810                 |            | 2               | 10           | 2466.63     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201907 | ALLBC1819               | ALLC-810                 |            | 3               | 120          | 2286.32     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201907 | ALLBC1819               | ALLC-810                 |            | 4               | 0            | 644.48      |
    #
    | ILR1819        | R04                  | ORG0017810     | CM             | 201808 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 1768.28     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201808 | ALLF1819                | ALLF-810                 |            | 6               | 10            | 2452.01     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201808 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 685.43      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201809 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 1381.30     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201809 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 355.28      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201809 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 2498.60     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201810 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 1722.82     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201810 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 137.68      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201810 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 1480.44     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201811 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 340.12      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201811 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 347.25      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201811 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 2017.33     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201812 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 782.75      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201812 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 209.55      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201812 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 809.85      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201901 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 1016.82     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201901 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 822.33      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201901 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 2376.58     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201902 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 2451.60     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201902 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 1063.30     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201902 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 767.87      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201903 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 485.06      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201903 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 490.77      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201903 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 1651.81     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201904 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 1084.17     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201904 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 1090.64     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201904 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 1810.56     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201905 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 882.89      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201905 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 1619.63     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201905 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 598.14      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201906 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 546.43      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201906 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 1500.06     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201906 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 293.71      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201907 | ALLF1819                | ALLF-810                 |            | 2               | 1            | 1199.13     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201907 | ALLF1819                | ALLF-810                 |            | 6               | 10           | 2273.76     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201907 | ALLF1819                | ALLF-810                 |            | 7               | 0            | 727.28      |
    #
    | ILR1819        | R04                  | ORG0017810     | CM             | 201808 | CLP1819                 | CLP-810                  |            | 1               | 1            | 1984.51     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201809 | CLP1819                 | CLP-810                  |            | 1               | 1            | 1009.36     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201810 | CLP1819                 | CLP-810                  |            | 1               | 1            | 795.19      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201811 | CLP1819                 | CLP-810                  |            | 1               | 1            | 2306.51     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201812 | CLP1819                 | CLP-810                  |            | 1               | 1            | 1616.18     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201901 | CLP1819                 | CLP-810                  |            | 1               | 1            | 1606.34     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201902 | CLP1819                 | CLP-810                  |            | 1               | 1            | 1128.29     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201903 | CLP1819                 | CLP-810                  |            | 1               | 1            | 335.13      |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201904 | CLP1819                 | CLP-810                  |            | 1               | 1            | 1446.50     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201905 | CLP1819                 | CLP-810                  |            | 1               | 1            | 1766.77     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201906 | CLP1819                 | CLP-810                  |            | 1               | 1            | 2292.93     |
    | ILR1819        | R04                  | ORG0017810     | CM             | 201907 | CLP1819                 | CLP-810                  |            | 1               | 1            | 2103.56     |

    # Pull actuals from the new Submit Learner Data (SLD) interface (24329)
    When  the FCT system polls the SLD service

    # Check actual values in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18  | Sep-18  | Oct-18  | Nov-18  | Dec-18 | Jan-19  | Feb-19  | Mar-19  | Apr-19  | May-19  | Jun-19  | Jul-19  |
    | LOANS-810      | ALLC-810      | 2               | 1793.32 | 794.95  | 133.64  | ?       | ?      | ?       | ?       | ?       | ?       | ?       | ?       | ?       |
    | LOANS-810      | ALLC-810      | 3               | 1380.22 | 824.67  | 1925.74 | ?       | ?      | ?       | ?       | ?       | ?       | ?       | ?       | ?       |
    | LOANS-810      | ALLC-810      | 4               | 1490.85 | 1959.38 | 2054.78 | ?       | ?      | ?       | ?       | ?       | ?       | ?       | ?       | ?       |
    #
    | LOANS-810      | ALLF-810      | 2               | 1768.28 | 1381.30 | 1722.82 | 340.12  | 782.75 | 1016.82 | 2451.60 | 485.06  | 1084.17 | 882.89  | 546.43  | 1199.13 |
    | LOANS-810      | ALLF-810      | 6               | 2452.01 | 355.28  | 137.68  | 347.25  | 209.55 | 822.33  | 1063.30 | 490.77  | 1090.64 | 1619.63 | 1500.06 | 2273.76 |
    | LOANS-810      | ALLF-810      | 7               | 685.43  | 2498.60 | 1480.44 | 2017.33 | 809.85 | 2376.58 | 767.87  | 1651.81 | 1810.56 | 598.14  | 293.71  | 727.28  |
    #
    | LOANS-810      | CLP-810       | 1               | 1984.51 | 1009.36 | 795.19  | ?       | ?      | ?       | ?       | ?       | ?       | ?       | ?       | ?       |

    # Check actual volumes in CRM
    And   the Actuals Volume Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18 | Sep-18 | Oct-18 | Nov-18 | Dec-18 | Jan-19 | Feb-19 | Mar-19 | Apr-19 | May-19 | Jun-19 | Jul-19 |
    | LOANS-810      | ALLC-810      | 2               | 10     | 10     | 10     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | LOANS-810      | ALLC-810      | 3               | 10     | 20     | 30     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | LOANS-810      | ALLC-810      | 4               | 0      | 0      | 0      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    #
    | LOANS-810      | ALLF-810      | 2               | 1      | 1      | 1      | 1      | 1      | 1      | 1      | 1      | 1      | 1      | 1      | 1      |
    | LOANS-810      | ALLF-810      | 6               | 10     | 10     | 10     | 10     | 10     | 10     | 10     | 10     | 10     | 10     | 10     | 10     |
    | LOANS-810      | ALLF-810      | 7               | 0      | 0      | 0      | 0      | 0      | 0      | 0      | 0      | 0      | 0      | 0      | 0      |
    #
    | LOANS-810      | CLP-810       | 1               | 1      | 1      | 1      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    # Check aggregated actual values against deliverables in CRM
    And   the Actuals Data is stored in CRM at deliverable level against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | ActualValue | ActualVolume |
    | LOANS-810      | ALLC-810      | 1               | 12,357.55   | ?            |
    | LOANS-810      | ALLC-810      | 2               | 2,721.91    | 30           |
    | LOANS-810      | ALLC-810      | 3               | 4,130.63    | 60           |
    | LOANS-810      | ALLC-810      | 4               | 5,505.01    | 0            |
    #
    | LOANS-810      | ALLF-810      | 2               | 13,661.37   | 12           |
    | LOANS-810      | ALLF-810      | 5               | 41,741.23   | ?            |
    | LOANS-810      | ALLF-810      | 6               | 12,362.26   | 120          |
    | LOANS-810      | ALLF-810      | 7               | 15,717.60   | 0            |
    #
    | LOANS-810      | CLP-810       | 1               | 3,789.06    | 3            |

    # Check actual values of ContractAllocationActualsReceived events on the ADP feed
    And the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLC-810         | 2               | 201808 | 1793.32     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLC-810         | 3               | 201808 | 1380.22     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLC-810         | 4               | 201808 | 1490.85     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLC-810         | 2               | 201809 | 794.95      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLC-810         | 3               | 201809 | 824.67      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLC-810         | 4               | 201809 | 1959.38     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLC-810         | 2               | 201810 | 133.64      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLC-810         | 3               | 201810 | 1925.74     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLC-810         | 4               | 201810 | 2054.78     |
    #
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201808 | 1768.28     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201808 | 2452.01     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201808 | 685.43      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201809 | 1381.30     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201809 | 355.28      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201809 | 2498.60     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201810 | 1722.82     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201810 | 137.68      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201810 | 1480.44     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201811 | 340.12      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201811 | 347.25      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201811 | 2017.33     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201812 | 782.75      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201812 | 209.55      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201812 | 809.85      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201901 | 1016.82     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201901 | 822.33      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201901 | 2376.58     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201902 | 2451.60     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201902 | 1063.30     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201902 | 767.87      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201903 | 485.06      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201903 | 490.77      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201903 | 1651.81     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201904 | 1084.17     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201904 | 1090.64     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201904 | 1810.56     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201905 | 882.89      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201905 | 1619.63     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201905 | 598.14      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201906 | 546.43      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201906 | 1500.06     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201906 | 293.71      |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 2               | 201907 | 1199.13     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 6               | 201907 | 2273.76     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | ALLF-810         | 7               | 201907 | 727.28      |
    #
    | ContractAllocationActualsReceived | LOANS-810      | 1             | CLP-810          | 1               | 201808 | 1984.51     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | CLP-810          | 1               | 201809 | 1009.36     |
    | ContractAllocationActualsReceived | LOANS-810      | 1             | CLP-810          | 1               | 201810 | 795.19      |




    # Attempt a 'New Amendment' to create a new 1920 ALLF contract linked by Master Contract Number to the above 1819 Loans contract (25955). This should fail MBR-001a
    
    # Change the date
    Given the override date is '11/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills contract with intent of 'New Amendment' where a Master Contract Ref is specified in the bulk file
    And   there are no files prefixed '10017810' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 28022019104503 v3_A810' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 28022019104503 v3_A810' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 28022019104503 v3_A810.xlsx' exists in the Datafiles folder and UKPRN '10017810' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR-001a
    And   '[Contract] Use of intent 'New Amendment' is not allowed for this Funding Type and Period, as new Master Contracts are required.' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Attempt a 'New Amendment' to create a new 1920 ALLF contract without specifying a linked Master Contract Number (25955). This should also fail MBR-001a
    
    # Change the date
    Given the override date is '12/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills contract with intent of 'New Amendment' where the Master Contract Ref in the bulk file is blank
    And   there are no files prefixed '10017810' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 28022019104505 v3_A810_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 28022019104505 v3_A810_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 28022019104505 v3_A810_1.xlsx' exists in the Datafiles folder and UKPRN '10017810' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR-001a
    And   '[Contract] Use of intent 'New Amendment' is not allowed for this Funding Type and Period, as new Master Contracts are required.' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Tidy up
    And   the override date is reset

	 