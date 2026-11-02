Feature: Year-End1819FundingClaimsA 25712

@AcceptanceTest @Withdrawn20211005
@FundingClaim
@Long2Run @Long2Run45
Scenario: A555SLD Create and approve two each of 1819 Mainstream, Loans and AEB contracts with Delivery Orgs which are not the Contracting Org. Inject a Year End Delivery Org Funding Claim. Two allocations are below profile by more than the 3% tolerance and one is above. ClaimAdjustment non-zero. Reconciliation value changes. Publish. Check CRM and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017555' 
    And   there are no terminated or closed allocations for UKPRN '10017555' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017555' 
	And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Reconciliation Publication Failed'
	And   there are no notifications of type 'FCR Hold Failed'
	And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEC-5551      |
    | AEC-5552      |
    | AEBL-5551     |
    | AEBL-5552     |
    | ALLC-5551     |
    | ALLC-5552     |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Final         | 1718   |
    | Final         | 1819   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017555 |
    | 10027518 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEC-5551      |
    | AEC-5552      |
    | AEBL-5551     |
    | AEBL-5552     |
    | ALLC-5551     |
    | ALLC-5552     |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017555' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017555 Co Ltd' with UKPRN '10017555' and OrgId 'ORG0017555' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                   | SequenceNumber | Status   | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017555 | 117555 | 10017555 Co Ltd        | 0              | Active   | Yes           | AA017555      | ?             | 74 Lenelby Road        | Surbiton               | Surrey                 | ?                      | ?                      | ?                      | RT7 6BH   |
    | 10021585 | 126476 | Shears Academy Ltd     | 0              | Active   | Yes           | ?             | 125476        | 5 Riversdale Road      | Thames Ditton          | Surrey                 | ?                      | ?                      | ?                      | KT7 0QL   |
    | 10027518 | 121526 | Millennium Academy Ltd | 0              | Active   | Yes           | AA121526      | 121526        | 7a Deans Court         | Bicester               | ?                      | ?                      | Oxon                   | Oxfordshire            | OX6 7XZ   |

    # Put the same Provider data in the CRM Organisation table
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017555 |
    | 10021585 |
    | 10027518 |





    # Change the date
    Given the override date is '01/07/2018'

    # Create contract ONE with 2 allocations (Mainstream)
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017555 | 10017555 Co Ltd      | ESFA-5551            | MAIN-555       | 1                     | 01/08/2018        | 31/07/2019      | 198145.00     |                                    | Contract for Services                      | 1819   | New          | ORG0017555 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017555 | MAIN-555       | AEC-5551      | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 47748.00        |                                         |            |                                                             | New          | 10021585    |
    | 10017555 | MAIN-555       | 16TR-5551     | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2017          | 31/07/2018        | 50591.00        |                                         |            |                                                             | New          | 10021585    |
	#
	| 10017555 | MAIN-555       | AEC-5552      | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 49215.00        |                                         |            |                                                             | New          | 10027518    |
    | 10017555 | MAIN-555       | 16TR-5552     | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2017          | 31/07/2018        | 50591.00        |                                         |            |                                                             | New          | 10027518    |



    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017555 | MAIN-555       | AEC-5551      | 1               | 0                     | 47748.00  | 5396.00  | 4715.00  | 4793.00  | 4556.00  | 5268.00  | 3133.00  | 5836.00  | 4146.00  | 3781.00  | 2911.00  | 1819.00  | 1394.00  | Adult Education Budget Total Funding                         | New          | 10021585    |
    | 10017555 | MAIN-555       | AEC-5551      | 13              | 1                     | 23626.00  | 3339.00  | 2050.00  | 1234.00  | 2697.00  | 2010.00  | 1353.00  | 2341.00  | 3077.00  | 1852.00  | 1827.00  | 918.00   | 928.00   | Community Learning                                           | New          | 10021585    |
    | 10017555 | MAIN-555       | AEC-5551      | 14              | 1                     | 24122.00  | 2057.00  | 2665.00  | 3559.00  | 1859.00  | 3258.00  | 1780.00  | 3495.00  | 1069.00  | 1929.00  | 1084.00  | 901.00   | 466.00   | Other AEB Funding                                            | New          | 10021585    |
    #
    | 10017555 | MAIN-555       | 16TR-5551     | 1               | 0                     | 40447.00  | 1675.00  | 5803.00  | 1688.00  | 3568.00  | 4804.00  | 2209.00  | 4346.00  | 3308.00  | 2799.00  | 3637.00  | 876.00   | 5734.00  | Total 16-18 Traineeships Funding                             | New          | 10021585    |
    | 10017555 | MAIN-555       | 16TR-5551     | 2               | 1                     | 24699.00  | 876.00   | 2213.00  | 1395.00  | 3291.00  | 1819.00  | 755.00   | 2581.00  | 2816.00  | 2322.00  | 2944.00  | 648.00   | 3039.00  | 16-18 Traineeships Programme Funding                         | New          | 10021585    |
    | 10017555 | MAIN-555       | 16TR-5551     | 3               | 1                     | 15748.00  | 799.00   | 3590.00  | 293.00   | 277.00   | 2985.00  | 1454.00  | 1765.00  | 492.00   | 477.00   | 693.00   | 228.00   | 2695.00  | 16-18 Traineeships Bursary Funding                           | New          | 10021585    |
	#
    | 10017555 | MAIN-555       | AEC-5552      | 1               | 0                     | 49215.00  | 2247.00  | 5898.00  | 4080.00  | 2133.00  | 3290.00  | 4506.00  | 6294.00  | 6596.00  | 2973.00  | 2736.00  | 3448.00  | 5014.00  | Adult Education Budget Total Funding                         | New          | 10027518    |
    | 10017555 | MAIN-555       | AEC-5552      | 13              | 1                     | 21972.00  | 1802.00  | 3358.00  | 1406.00  | 843.00   | 567.00   | 1397.00  | 2607.00  | 3660.00  | 1485.00  | 606.00   | 1278.00  | 2963.00  | Community Learning                                           | New          | 10027518    |
    | 10017555 | MAIN-555       | AEC-5552      | 14              | 1                     | 27243.00  | 445.00   | 2540.00  | 2674.00  | 1290.00  | 2723.00  | 3109.00  | 3687.00  | 2936.00  | 1488.00  | 2130.00  | 2170.00  | 2051.00  | Other AEB Funding                                            | New          | 10027518    |
	#
	| 10017555 | MAIN-555       | 16TR-5552     | 1               | 0                     | 50591.00  | 3685.00  | 4067.00  | 5296.00  | 5842.00  | 4849.00  | 1448.00  | 4605.00  | 3925.00  | 4779.00  | 5280.00  | 3979.00  | 2836.00  | Total 16-18 Traineeships Funding                             | New          | 10027518    |
    | 10017555 | MAIN-555       | 16TR-5552     | 2               | 1                     | 31749.00  | 3149.00  | 248.00   | 2096.00  | 3041.00  | 3213.00  | 1334.00  | 3893.00  | 3227.00  | 2716.00  | 3626.00  | 3510.00  | 1696.00  | 16-18 Traineeships Programme Funding                         | New          | 10027518    |
    | 10017555 | MAIN-555       | 16TR-5552     | 3               | 1                     | 18842.00  | 536.00   | 3819.00  | 3200.00  | 2801.00  | 1636.00  | 114.00   | 712.00   | 698.00   | 2063.00  | 1654.00  | 469.00   | 1140.00  | 16-18 Traineeships Bursary Funding                           | New          | 10027518    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '02/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-555' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '03/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-5551' and actual ContractNumber 'MAIN-555'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-555' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017555 | MAIN-555           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017555 | ESFA-5551          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '264' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '264' deliverable period rows in CRM linked to the latest version of contract 'MAIN-555'




    # Change the date
    Given the override date is '04/07/2018'

    # Create contract TWO with 2 allocations (Adult Education Budget)
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017555 | 10017555 Co Ltd      | ESFA-5552            | AEBP-555       | 1                     | 01/08/2018        | 31/07/2019      | 36763.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017555 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017555 | AEBP-555       | AEBL-5551     | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 20484.00        |                                         |            |                                                             | New          | 10021585    |
    | 10017555 | AEBP-555       | AEBL-5552     | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 16279.00        |                                         |            |                                                             | New          | 10027518    |


    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017555 | AEBP-555       | AEBL-5551     | 1               | 0                     | 20484.00  | 3317.00  | 1079.00  | 3110.00  | 3436.00  | 723.00   | 476.00   | 2952.00  | 209.00   | 2018.00  | 2028.00  | 264.00   | 872.00   | Adult Education Budget - Learner Support                     | New          | 10021585    |
    | 10017555 | AEBP-555       | AEBL-5552     | 1               | 0                     | 16279.00  | 1477.00  | 662.00   | 2124.00  | 1437.00  | 780.00   | 1768.00  | 2505.00  | 1279.00  | 1255.00  | 345.00   | 355.00   | 2292.00  | Adult Education Budget - Learner Support                     | New          | 10027518    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '05/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-555' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '06/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-5552' and actual ContractNumber 'AEBP-555'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-555' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017555 | AEBP-555           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017555 | ESFA-5552          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'AEBP-555'




    # Change the date
    Given the override date is '07/07/2018'

    # Create contract THREE with 2 allocations (Advanced Learner Loans)
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017555 | 10017555 Co Ltd      | ESFA-5553            | LOANS-555      | 1                     | 01/08/2018        | 31/07/2019      | 44714.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017555 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017555 | LOANS-555      | ALLC-5551     | ALLBC             | ALLBC1819               | AY                      | 01/08/2018          | 31/07/2019        | 25366.00        |                                         |            |                                                             | New          | 10021585    |
    | 10017555 | LOANS-555      | ALLC-5552     | ALLBC             | ALLBC1819               | AY                      | 01/08/2018          | 31/07/2019        | 19348.00        |                                         |            |                                                             | New          | 10027518    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017555 | LOANS-555      | ALLC-5551     | 1               | 0                     | 25366.00  | 1224.00  | 2276.00  | 102.00   | 2924.00  | 3596.00  | 1580.00  | 1209.00  | 3304.00  | 3438.00  | 2054.00  | 3487.00  | 172.00   | Total Advanced Learner Loans Bursary Funding                 | New          | 10021585    |
    | 10017555 | LOANS-555      | ALLC-5552     | 1               | 0                     | 19348.00  | 1855.00  | 1548.00  | 733.00   | 2196.00  | 1509.00  | 852.00   | 1840.00  | 2576.00  | 1351.00  | 1326.00  | 417.00   | 3145.00  | Total Advanced Learner Loans Bursary Funding                 | New          | 10027518    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '08/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'LOANS-555' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '09/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-5553' and actual ContractNumber 'LOANS-555'

    # Check that the contract is now approved
    Then  the latest version of contract 'LOANS-555' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017555 | LOANS-555          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017555 | ESFA-5553          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'LOANS-555'




    # Populate stub with Claim data  
	#  Claims are possible for Delivery Orgs 10021585 and 10027518. This test is a claim for the latter. Other data should be ignored

    # Change the date
    Given the override date is '19/06/2019'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEBL-5552     | AEB-LS1819              |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | AEBC1819                |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | ALLC-5552     | ALLBC1819               |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEBL-5552     | 2               | 3992.00     | 37.26         | 12.00           | 4041.26    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEBL-5552     | 3               | 3745.00     | 26.90         | 9.85            | 3781.75    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEBL-5552     | 4               | 3510.00     | 25.62         | 8.05            | 3543.67    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEBL-5552     | 5               | 3611.00     | 47.52         | 13.69           | 3672.21    |
    #                                                                                                                                                                            £15038.89
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | 2               | 3301.00     | 56.76         | 8.62            | 3366.38    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | 3               | 3211.00     | 39.70         | 8.10            | 3258.80    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | 4               | 3630.00     | 58.48         | 11.43           | 3699.91    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | 5               | 3137.00     | 68.68         | 13.12           | 3218.80    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | 6               | 3117.00     | 30.76         | 14.62           | 3162.38    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | 7               | 3110.00     | 57.65         | 9.09            | 3176.74    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | 8               | 3586.00     | 73.45         | 7.55            | 3667.00    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | 9               | 3368.00     | 66.22         | 9.26            | 3443.48    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | 10              | 3424.00     | 39.67         | 5.80            | 3469.47    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | AEC-5552      | 13              | 24483.00    | 61.49         | 12.96           | 24557.45   |
    #                                                                                                                                                                            £55020.41
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | ALLC-5552     | 2               | 2432.00     | 61.57         | 8.97            | 2502.54    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | ALLC-5552     | 3               | 2682.00     | 65.83         | 13.74           | 2761.57    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | ALLC-5552     | 4               | 2231.00     | 73.78         | 10.64           | 2315.42    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | ALLC-5552     | 5               | 2504.00     | 56.34         | 12.88           | 2573.22    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | ALLC-5552     | 6               | 2565.00     | 25.67         | 7.84            | 2598.51    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | ALLC-5552     | 7               | 2621.00     | 37.13         | 5.50            | 2663.63    |
    | ORG0027518     | 10027518 | 3                  | Year End      | AY             | 1819   | ALLC-5552     | 8               | 2705.00     | 74.92         | 9.65            | 2789.57    |
    #                                                                                                                                                                            £18204.46
    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10027518 | 1819          | Year End         | AEB-LS1819          | 3                  | 16279.00     | 15038.89     | -1240.11                    | -1240.11            | 15038.89         | 0.00            | 15038.89                 | Draft      |
    | 10027518 | 1819          | Year End         | AEBC1819            | 3                  | 49215.00     | 55020.41     | 1476.45                     | 1476.45             | 52434.96         | 0.00            | 52434.96                 | Draft      |
    | 10027518 | 1819          | Year End         | ALLBC1819           | 3                  | 19348.00     | 18204.46     | -1143.54                    | -1143.54            | 18204.46         | 0.00            | 18204.46                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10027518 | 1819          | Year End         | AEB-LS1819          | AEBL-5552     | 16279.00     | 15038.89     | -1240.11                    | -1240.11            | 15038.89         | 0.00            | ?                     | 15038.89                 | 488.37           |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | 49215.00     | 55020.41     | 1476.45                     | 1476.45             | 52434.96         | 0.00            | ?                     | 52434.96                 | 1476.45          |
    | 10027518 | 1819          | Year End         | ALLBC1819           | ALLC-5552     | 19348.00     | 18204.46     | -1143.54                    | -1143.54            | 18204.46         | 0.00            | ?                     | 18204.46                 | 580.44           |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10027518 | 1819          | Year End         | AEB-LS1819          | AEBL-5552     | AEB-LS1819           | 2               | 19+ Hardship                                           | 0.00         | 4041.26      |
    | 10027518 | 1819          | Year End         | AEB-LS1819          | AEBL-5552     | AEB-LS1819           | 3               | 20+ Childcare                                          | 0.00         | 3781.75      |
    | 10027518 | 1819          | Year End         | AEB-LS1819          | AEBL-5552     | AEB-LS1819           | 4               | Residential Access Fund                                | 0.00         | 3543.67      |
    | 10027518 | 1819          | Year End         | AEB-LS1819          | AEBL-5552     | AEB-LS1819           | 5               | Administration Expenditure                             | 0.00         | 3672.21      |
    #                                                                                                                                                                                                    £15038.89
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | AEBC1819_AS_LS       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 3366.38      |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | AEBC1819_AS_LS       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 3258.80      |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | AEBC1819_AS_LS       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 3699.91      |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | AEBC1819_AS_LS       | 5               | Other Learning Programme Funding                       | 0.00         | 3218.80      |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | AEBC1819_AS_LS       | 6               | Other Learning - Learning Support                      | 0.00         | 3162.38      |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | AEBC1819_AS_LS       | 7               | Learner Support - 19+ Hardship                         | 0.00         | 3176.74      |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | AEBC1819_AS_LS       | 8               | Learner Support - 20+ Childcare                        | 0.00         | 3667.00      |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | AEBC1819_AS_LS       | 9               | Learner Support - Residential Access Fund              | 0.00         | 3443.48      |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | AEBC1819_AS_LS       | 10              | Learner Support - Administration Expenditure           | 0.00         | 3469.47      |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | AEBC1819_CL          | 13              | Community Learning                                     | 21972.00     | 24557.45     |
    #                                                                                                                                                                                                    £55020.41
    | 10027518 | 1819          | Year End         | ALLBC1819           | ALLC-5552     | ALLBC1819            | 2               | Loans - Bursary Funding                                | 0.00         | 2502.54      |
    | 10027518 | 1819          | Year End         | ALLBC1819           | ALLC-5552     | ALLBC1819            | 3               | Loans - Area Costs                                     | 0.00         | 2761.57      |
    | 10027518 | 1819          | Year End         | ALLBC1819           | ALLC-5552     | ALLBC1819            | 4               | Loans - Excess Claims                                  | 0.00         | 2315.42      |
    | 10027518 | 1819          | Year End         | ALLBC1819           | ALLC-5552     | ALLBC1819            | 5               | Loans - Hardship                                       | 0.00         | 2573.22      |
    | 10027518 | 1819          | Year End         | ALLBC1819           | ALLC-5552     | ALLBC1819            | 6               | Loans - Childcare                                      | 0.00         | 2598.51      |
    | 10027518 | 1819          | Year End         | ALLBC1819           | ALLC-5552     | ALLBC1819            | 7               | Loans - Residential Access Fund                        | 0.00         | 2663.63      |
    | 10027518 | 1819          | Year End         | ALLBC1819           | ALLC-5552     | ALLBC1819            | 8               | Loans - Administration Expenditure                     | 0.00         | 2789.57      |
	#                                                                                                                                                                                                    £18204.46



    # Change the date 
    Given the override date is '21/06/2019'

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, both
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10027518 | 1819          | Year End         | AEB-LS1819          | 3                  | AEBL-5552     | 16279.00     | 15038.89     | -1240.11                    | -1368.80            | 15038.89         | 200.00          | Other                 | 
    | 10027518 | 1819          | Year End         | AEBC1819            | 3                  | AEC-5552      | 49215.00     | 55020.41     | 1476.45                     | 65.16               | 52434.96         | -500.00         | Claim Error           | 
    | 10027518 | 1819          | Year End         | ALLBC1819           | 3                  | ALLC-5552     | 19348.00     | 18204.46     | -1143.54                    | -1076.44            | 18204.46         | 0.00            | ?                     | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10027518 | 1819          | Year End         | AEB-LS1819          | 3                  | 16279.00     | 15038.89     | -1040.11                    | -1368.80            | 15038.89         | 200.00          | 15238.89                 | Draft      |
    | 10027518 | 1819          | Year End         | AEBC1819            | 3                  | 49215.00     | 55020.41     | 1476.45                     | 65.16               | 52434.96         | -500.00         | 51934.96                 | Draft      |
    | 10027518 | 1819          | Year End         | ALLBC1819           | 3                  | 19348.00     | 18204.46     | -1143.54                    | -1076.44            | 18204.46         | 0.00            | 18204.46                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10027518 | 1819          | Year End         | AEB-LS1819          | AEBL-5552     | 16279.00     | 15038.89     | -1040.11                    | -1368.80            | 15038.89         | 200.00          | Other                 | 15238.89                 | 488.37           |
    | 10027518 | 1819          | Year End         | AEBC1819            | AEC-5552      | 49215.00     | 55020.41     | 1476.45                     | 65.16               | 52434.96         | -500.00         | Claim Error           | 51934.96                 | 1476.45          |
    | 10027518 | 1819          | Year End         | ALLBC1819           | ALLC-5552     | 19348.00     | 18204.46     | -1143.54                    | -1076.44            | 18204.46         | 0.00            | ?                     | 18204.46                 | 580.44           |



    # Change the date
    Given the override date is '23/06/2019'

    # Check the current date against the Publication Close Date for the AGC
   #And   the override date is after the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code '???'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code 'AEB-LS1819'
    And   the override date is before the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code 'AEBC1819'
    And   the override date is before the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code 'ALLBC1819'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10027518 | 1819          | Year End         | AEB-LS1819          | 3                  |
    | 10027518 | 1819          | Year End         | AEBC1819            | 3                  |
    | 10027518 | 1819          | Year End         | ALLBC1819           | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10027518 | 1819          | Year End         | AEB-LS1819          | 3                  |
    | 10027518 | 1819          | Year End         | AEBC1819            | 3                  |
    | 10027518 | 1819          | Year End         | ALLBC1819           | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10027518 | 1819          | Year End         | AEB-LS1819          | 3                  |
    | 10027518 | 1819          | Year End         | AEBC1819            | 3                  |
    | 10027518 | 1819          | Year End         | ALLBC1819           | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10027518 | AEBL-5552        | 1819   | Year End      | Adult Education Budget - Learner Support 18/19              | 16279.00     | 15038.89     | -1040.11                    | -1368.80                 | 15038.89           | 200.00          | Other                 | 15238.89                 | 
    | 10027518 | AEC-5552         | 1819   | Year End      | Adult Education Budget (College) 18/19                      | 49215.00     | 55020.41     | 1476.45                     | 65.16                    | 52434.96           | -500.00         | Claim Error           | 51934.96                 | 
    | 10027518 | ALLC-5552        | 1819   | Year End      | Advanced Learner Loans Bursary (College) 18/19              | 19348.00     | 18204.46     | -1143.54                    | -1076.44                 | 18204.46           | ?               | ?                     | 18204.46                 | 


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20211005
@FundingClaim
Scenario: A556SLD Create and approve an 1819 Mainstream contract sans Delivery Orgs. For a Year End claim, attempt publication, hold, release and second recalculation while initial recalculation is in progress. All to fail. Check CRM and notifications
    Given there are no allocations marked as Under Termination for UKPRN '10017556' 
    And   there are no terminated or closed allocations for UKPRN '10017556' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017556' 
	And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Reconciliation Publication Failed'
	And   there are no notifications of type 'FCR Hold Failed'
	And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEC-556       |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Final         | 1718   |
    | Final         | 1819   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017556 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEC-556       |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017556' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017556 Co Ltd' with UKPRN '10017556' and OrgId 'ORG0017556' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                  | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017556 | 117556 | 10017556 Co Ltd       | 0              | Active                | Yes           | AA017556      | ?             | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |
    | 10024415 | 139048 | Keystone Training Ltd | 0              | Active                | Yes           | ?             | 139048        | 7a Deans Court         | Bicester               | ?                      | ?                      | Oxon                   | Oxfordshire            | OX6 7XZ   |
    | 10028542 | 140687 | JHC Skills Ltd        | 0              | Active                | Yes           | AA140687      | ?             | 74 Lenelby Road        | Surbiton               | Surrey                 | ?                      | ?                      | ?                      | RT7 6BH   |

    # Put DeliveryOrg data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs  
    | UKPRN    |
    | 10017556 |
    | 10024415 |
    | 10028542 |




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017556 | 10017556 Co Ltd      | ESFA-556             | MAIN-556       | 1                     | 01/08/2018        | 31/07/2019      | 36971.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017556 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017556 | MAIN-556       | AEC-556       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 36971.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017556 | MAIN-556       | AEC-556       | 1               | 0                     | 36971.00  | 4041.00  | 923.00   | 4610.00  | 1937.00  | 2554.00  | 1685.00  | 4294.00  | 2885.00  | 2426.00  | 3804.00  | 6319.00  | 1493.00  | Adult Education Budget Total Funding                         | New          |             |
    | 10017556 | MAIN-556       | AEC-556       | 13              | 1                     | 17520.00  | 792.00   | 135.00   | 1124.00  | 1860.00  | 634.00   | 610.00   | 3402.00  | 2428.00  | 664.00   | 2255.00  | 3149.00  | 467.00   | Community Learning                                           | New          |             |
    | 10017556 | MAIN-556       | AEC-556       | 14              | 1                     | 19451.00  | 3249.00  | 788.00   | 3486.00  | 77.00    | 1920.00  | 1075.00  | 892.00   | 457.00   | 1762.00  | 1549.00  | 3170.00  | 1026.00  | Other AEB Funding                                            | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-556' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-556' and actual ContractNumber 'MAIN-556'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-556' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017556 | MAIN-556           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017556 | ESFA-556           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'MAIN-556'




    # Populate stub with Claim data

    # Change the date
    Given the override date is '17/06/2019'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | AEBC1819                |
    
   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | 2               | 2998.00     | 66.35         | 6.36            | 3070.71    |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | 3               | 3069.00     | 52.77         | 5.86            | 3127.63    |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | 4               | 3097.00     | 62.27         | 7.81            | 3167.08    |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | 5               | 2935.00     | 34.38         | 10.08           | 2979.46    |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | 6               | 2661.00     | 69.07         | 9.19            | 2739.26    |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | 7               | 2843.00     | 44.08         | 13.15           | 2900.23    |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | 8               | 3068.00     | 38.55         | 8.71            | 3115.26    |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | 9               | 2666.00     | 37.44         | 10.72           | 2714.16    |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | 10              | 3083.00     | 33.30         | 6.24            | 3122.54    |
    | ORG0017556     | 10017556 | 5                  | Year End      | AY             | 1819   | AEC-556       | 13              | 28610.00    | 27.12         | 14.81           | 28651.93   |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 0.00            | 44456.33                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 0.00            | ?                     | 44456.33                 | 1109.13          |    
	
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | AEBC1819_AS_LS       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 3070.71      |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | AEBC1819_AS_LS       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 3127.63      |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | AEBC1819_AS_LS       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 3167.08      |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | AEBC1819_AS_LS       | 5               | Other Learning Programme Funding                       | 0.00         | 2979.46      |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | AEBC1819_AS_LS       | 6               | Other Learning - Learning Support                      | 0.00         | 2739.26      |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | AEBC1819_AS_LS       | 7               | Learner Support - 19+ Hardship                         | 0.00         | 2900.23      |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | AEBC1819_AS_LS       | 8               | Learner Support - 20+ Childcare                        | 0.00         | 3115.26      |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | AEBC1819_AS_LS       | 9               | Learner Support - Residential Access Fund              | 0.00         | 2714.16      |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | AEBC1819_AS_LS       | 10              | Learner Support - Administration Expenditure           | 0.00         | 3122.54      |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | AEBC1819_CL          | 13              | Community Learning                                     | 17520.00     | 28651.93     |




    # Inhibit publication while recalculation is in progress (26424)

	# Change the date
    Given the override date is '21/06/2019'

    # Simulate a calculation in progress state by setting the FCR to Draft\Recalculating
    Given the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Recalculating'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # Attempt to publish the draft FCR
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # Publication should fail. Status and substatus should not change. 
    Then  the following funding claim reconciliations will have a status 'Draft' and a sub status 'Recalculating'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # A notification should be written
	And   there is '1' notification of type 'Reconciliation Publication Failed' owned by user 'CRM Integration' which matches the following
    | Status | NotificationName                                                                                  | NotificationText                                                                                                                                |
    | New    | Reconciliation Publication Failed - 1819_Year End_Adult Education Budget (College) 18/19_10017556 | The Adult Education Budget (College) 18/19 FCR for provider 10017556 (10017556 Co Ltd) could not be published because it is being recalculated  |
  



    # Prevent holding of an FCR while it is being recalculated (26423)

	# Change the date
    Given the override date is '22/06/2019'

    # Simulate a calculation in progress state by setting the FCR to Draft\Recalculating
    Given the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Recalculating'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # Trigger WF26 in CRM to attempt to put FCR on hold 
    When  a hold request is triggered in CRM for the following unpublished Funding Claim Reconciliations
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # Hold should fail. Status and substatus should not change. 
    Then  the following funding claim reconciliations will have a status 'Draft' and a sub status 'Recalculating'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # A notification should be written
	And   there is '1' notification of type 'FCR Hold Failed' owned by user 'CRM Integration' which matches the following
    | Status | NotificationName                                                                 | NotificationText                                                                                                                           |
    | New    | FCR Hold Failed - 1819_Year End_Adult Education Budget (College) 18/19_10017556  | The Adult Education Budget (College) 18/19 FCR for provider 10017556 (10017556 Co Ltd) could not be held because it is being recalculated. |




    # Prevent the release of a hold while the FCR is being recalculated (26480)

	# Change the date
    Given the override date is '23/06/2019'

    # Put the contract into its unpublished base state of Draft\Draft
    Given the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Draft'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # Trigger WF26 in CRM to put FCR on hold 
    When  a hold request is triggered in CRM for the following unpublished Funding Claim Reconciliations
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # Hold should succeed
    Then  the following funding claim reconciliations will have a status 'Draft' and a sub status 'Held'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |
	
	# Simulate a calculation in progress by setting the FCR to Draft\Recalculating (Held)
    Given the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Recalculating (Held)'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # Trigger WF27 in CRM to release held FCR
    When  a release request is triggered in CRM for the following held Funding Claim Reconciliations
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # Release should fail. Status and substatus should not change. 
    Then  the following funding claim reconciliations will have a status 'Draft' and a sub status 'Recalculating (Held)'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # A notification should be written
	And   there is '1' notification of type 'Held FCR Release Failed' owned by user 'CRM Integration' which matches the following
    | Status | NotificationName                                                                         | NotificationText                                                                                                                                    |
    | New    | Held FCR Release Failed - 1819_Year End_Adult Education Budget (College) 18/19_10017556  | The held Adult Education Budget (College) 18/19 FCR for provider 10017556 (10017556 Co Ltd) could not be released because it is being recalculated  |




	# Check that an FCR with a sus-status of 'Held' is returned to this sub-status after performaing a recalculation (25755)

	# Change the date
    Given the override date is '24/06/2019'

    # Put the contract into its unpublished base state of Draft\Draft
    And   the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Draft'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # Trigger WF26 in CRM to put FCR on hold 
    When  a hold request is triggered in CRM for the following unpublished Funding Claim Reconciliations
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # Hold should succeed
    Then  the following funding claim reconciliations will have a status 'Draft' and a sub status 'Held'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, just the Claim Adjustment
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  | AEC-556       | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 172.60          | Ineligible Data       |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 172.60          | 44628.93                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 172.60          | Ineligible Data       | 44628.93                 | 1109.13          |

    # Sub-status should now be 'Held' after briefly being 'Recalculating (Held)' during the recalculation step above
    Then  the following funding claim reconciliations will have a status 'Draft' and a sub status 'Held'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |




    # Inhibit further recalculation while recalculation is in progress (25755 and 26410 notification test 2)

	# Change the date
    Given the override date is '25/06/2019'

    # Simulate a calculation in progress state by setting the FCR to Draft\Recalculating
    Given the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Recalculating'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, both
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  | AEC-556       | 36971.00     | 55588.26     | 1109.13                     | 999.99              | 44456.33         | -5000.00        | Claim Error           |

	# Claim Adjustment should fail. Numbers should not have changed on the FCR
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 172.60          | 44628.93                 | Draft      |

	# ... or on the FCR Allocation. (ClaimAdjustmentReason should be as it was previously)
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 172.60          | Ineligible Data       | 44628.93                 | 1109.13          |

    # A notification should be written
	And   there is '1' notification of type 'FCR Allocation Update Failed' owned by user 'CRM Integration' which matches the following
    | Status | NotificationName                                                                                       | NotificationText                                                                                                                                  |
    | New    | FCR Allocation Update Failed - AEC-556 - 1819_Year End_Adult Education Budget (College) 18/19_10017556 | The FCR Allocation for contract allocation AEC-556 for provider 10017556 (10017556 Co Ltd) could not be updated because it is being recalculated  |
  



	# Non-zero Claim Adjustments must have the Claim Adjustment Reason set (26410 notification test 3) 

	# Change the date
    Given the override date is '26/06/2019'

    # Put the contract into its unpublished base state of Draft\Draft
    And   the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Draft'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, just the Claim Adjustment
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  | AEC-556       | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | -5000.00        | ?                     |

	# Claim Adjustment should fail. Numbers should not have changed on the FCR
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 172.60          | 44628.93                 | Draft      |

	# ... or on the FCR Allocation. (ClaimAdjustmentReason should be as it was previously)
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 172.60          | Ineligible Data       | 44628.93                 | 1109.13          |

    # A notification should be written
	And   there is '1' notification of type 'FCR Allocation Update Failed' owned by user 'CRM Integration' which matches the following
    | Status | NotificationName                                                                                       | NotificationText                                                                                                                                                                                                  |
    | New    | FCR Allocation Update Failed - AEC-556 - 1819_Year End_Adult Education Budget (College) 18/19_10017556 | The FCR Allocation for contract allocation AEC-556 for provider 10017556 (10017556 Co Ltd) could not be updated because a Claim Adjustment Reason is required when a non-zero Claim Adjustment Value is specified |




	# Zero value Claim Adjustments must not have a Claim Adjustment Reason set (26410, notification test 4)

	# Change the date
    Given the override date is '27/06/2019'

    # Put the contract into its unpublished base state of Draft\Draft
    And   the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Draft'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, just the Claim Adjustment
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  | AEC-556       | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 0.00            | Claim Error           |

	# Claim Adjustment should fail. Numbers should not have changed on the FCR
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 172.60          | 44628.93                 | Draft      |

	# ... or on the FCR Allocation. (ClaimAdjustmentReason should be as it was previously)
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017556 | 1819          | Year End         | AEBC1819            | AEC-556       | 36971.00     | 55588.26     | 1109.13                     | 1109.13             | 44456.33         | 172.60          | Ineligible Data       | 44628.93                 | 1109.13          |

    # A notification should be written
	And   there is '1' notification of type 'FCR Allocation Update Failed' owned by user 'CRM Integration' which matches the following
    | Status | NotificationName                                                                                       | NotificationText                                                                                                                                                                                                          |
    | New    | FCR Allocation Update Failed - AEC-556 - 1819_Year End_Adult Education Budget (College) 18/19_10017556 | The FCR Allocation for contract allocation AEC-556 for provider 10017556 (10017556 Co Ltd) could not be updated because a Claim Adjustment Reason is only allowed if a non-zero Claim Adjustment Value has been specified |



    # Tidy up
	And   the override date is reset

	  