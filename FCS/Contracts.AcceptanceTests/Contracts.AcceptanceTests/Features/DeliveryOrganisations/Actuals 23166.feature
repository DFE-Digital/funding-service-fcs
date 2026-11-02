Feature: Actuals 23166

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run45
Scenario: A566SLD Create and approve an 1819 AEB contract with three delivery orgs none of which is the contracting org. Consume actuals. Run batch and create payment file. Check CRM, PaaS, Payment file and Payment feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017566' 
	And   there is no Subnominal data for the following FSPs
	| FSP           |
    | AEB-TOL1819   |
    | AEB-LS1819    |
    | AEB-CL1819    |

	# Clear down subnominal data from CRM and PaaS
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBC-5661     |
    | AEBL-5661     |
    | AEBT-5661     |
    | AEBC-5662     |
    | AEBL-5662     |
    | AEBT-5662     |
    | AEBC-5663     |
    | AEBL-5663     |
    | AEBT-5663     |
	| AEBT-5664     |




    # Set organisation and advisor for the Provider
    Given there is no Organisation data for UKPRN '10017566' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017566 Co Ltd' with UKPRN '10017566' and OrgId 'ORG0017566' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017566' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017566 | 117566 | 10017566 Co Ltd | 0              | Active                | Yes           | AA017566      | ?             | 201 London Road East   | Batheaston             | Bath                   | ?                      | ?                      | ?                      | BA1 7NB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017566 |


    # Set organisation and advisor for first Delivery Org 
    Given there is no Organisation data for UKPRN '10217566' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10217566 Co Ltd' with UKPRN '10217566' and OrgId 'ORG0217566' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017566' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10217566 | 217566 | 10217566 Co Ltd | 0              | Active                | Yes           | AA217566      | ?             | 202 London Road East   | Batheaston             | Bath                   | ?                      | ?                      | ?                      | BA1 7NB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10217566 |


    # Set organisation and advisor for second Delivery Org 
    Given there is no Organisation data for UKPRN '10317566' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10317566 Co Ltd' with UKPRN '10317566' and OrgId 'ORG0317566' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017566' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10317566 | 317566 | 10317566 Co Ltd | 0              | Active                | Yes           | AA317566      | ?             | 203 London Road East   | Batheaston             | Bath                   | ?                      | ?                      | ?                      | BA1 7NB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10317566 |


    # Set organisation and advisor for third Delivery Org 
    Given there is no Organisation data for UKPRN '10417566' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10417566 Co Ltd' with UKPRN '10417566' and OrgId 'ORG0417566' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017566' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10417566 | 417566 | 10417566 Co Ltd | 0              | Active                | Yes           | AA417566      | ?             | 204 London Road East   | Batheaston             | Bath                   | ?                      | ?                      | ?                      | BA1 7NB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10417566 |




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription  | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017566 | 10017566 Co Ltd      | ESFA-566             | AEBP-566       | 1                     | 01/08/2018        | 31/07/2019      | 208204.00     |                      | Contract for Services | 1819   | New          | ORG0017566 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017566 | AEBP-566       | AEBC-5662     | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 24843.00        |                         |            |                         | New          | 10217566    |
    | 10017566 | AEBP-566       | AEBL-5662     | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 22485.00        |                         |            |                         | New          | 10217566    |
    | 10017566 | AEBP-566       | AEBT-5662     | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 20243.00        |                         |            |                         | New          | 10217566    |
    #
    | 10017566 | AEBP-566       | AEBC-5663     | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 33780.00        |                         |            |                         | New          | 10317566    |
    | 10017566 | AEBP-566       | AEBL-5663     | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 28027.00        |                         |            |                         | New          | 10317566    |
    | 10017566 | AEBP-566       | AEBT-5663     | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 21933.00        |                         |            |                         | New          | 10317566    |
    #
    | 10017566 | AEBP-566       | AEBC-5664     | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 18606.00        |                         |            |                         | New          | 10417566    |
    | 10017566 | AEBP-566       | AEBL-5664     | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 20100.00        |                         |            |                         | New          | 10417566    |
    | 10017566 | AEBP-566       | AEBT-5664     | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 18187.00        |                         |            |                         | New          | 10417566    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                           | CRMIntent    | DeliveryOrg |
    | 10017566 | AEBP-566       | AEBC-5662     | 1               | 0                     | 24843.00  | 265.00   | 275.00   | 2212.00  | 2820.00  | 3714.00  | 2014.00  | 3413.00  | 1935.00  | 3650.00  | 1223.00  | 2084.00  | 1238.00  | Adult Education Budget - Community Learning                      | New          | 10217566    |
    | 10017566 | AEBP-566       | AEBL-5662     | 1               | 0                     | 22485.00  | 2220.00  | 1785.00  | 3089.00  | 2877.00  | 797.00   | 3336.00  | 401.00   | 821.00   | 544.00   | 1375.00  | 2585.00  | 2655.00  | Adult Education Budget - Learner Support                         | New          | 10217566    |
    | 10017566 | AEBP-566       | AEBT-5662     | 1               | 0                     | 20243.00  | 3259.00  | 3362.00  | 333.00   | 2018.00  | 665.00   | 2760.00  | 175.00   | 2493.00  | 2943.00  | 610.00   | 1188.00  | 437.00   | Adult Education - Traineeships and Other Learning Total Funding  | New          | 10217566    |
    #
    | 10017566 | AEBP-566       | AEBC-5663     | 1               | 0                     | 33780.00  | 3410.00  | 3449.00  | 3331.00  | 3686.00  | 2619.00  | 2120.00  | 2634.00  | 1092.00  | 2999.00  | 1962.00  | 3108.00  | 3370.00  | Adult Education Budget - Community Learning                      | New          | 10317566    |
    | 10017566 | AEBP-566       | AEBL-5663     | 1               | 0                     | 28027.00  | 2645.00  | 2052.00  | 130.00   | 2196.00  | 684.00   | 3253.00  | 2947.00  | 2131.00  | 3594.00  | 2907.00  | 2250.00  | 3238.00  | Adult Education Budget - Learner Support                         | New          | 10317566    |
    | 10017566 | AEBP-566       | AEBT-5663     | 1               | 0                     | 21933.00  | 3722.00  | 2497.00  | 2472.00  | 1563.00  | 590.00   | 2527.00  | 416.00   | 1311.00  | 2329.00  | 1009.00  | 2250.00  | 1247.00  | Adult Education - Traineeships and Other Learning Total Funding  | New          | 10317566    |
    #
    | 10017566 | AEBP-566       | AEBC-5664     | 1               | 0                     | 18606.00  | 2972.00  | 2127.00  | 1944.00  | 1509.00  | 2814.00  | 2601.00  | 521.00   | 2078.00  | 126.00   | 546.00   | 269.00   | 1099.00  | Adult Education Budget - Community Learning                      | New          | 10417566    |
    | 10017566 | AEBP-566       | AEBL-5664     | 1               | 0                     | 20100.00  | 1074.00  | 2127.00  | 3654.00  | 56.00    | 728.00   | 1430.00  | 1059.00  | 3155.00  | 570.00   | 1905.00  | 3337.00  | 1005.00  | Adult Education Budget - Learner Support                         | New          | 10417566    |
    | 10017566 | AEBP-566       | AEBT-5664     | 1               | 0                     | 18187.00  | 3148.00  | 2397.00  | 949.00   | 1591.00  | 1631.00  | 1512.00  | 1868.00  | 801.00   | 302.00   | 815.00   | 2975.00  | 198.00   | Adult Education - Traineeships and Other Learning Total Funding  | New          | 10417566    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-566' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-566' and actual ContractNumber 'AEBP-566'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-566' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017566 | AEBP-566           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017566 | ESFA-566           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'AEBP-566'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
	| AllocationRef | Subnominal Code | Period | Payment Type   |
	| AEBC-5662     | 2372030         | Jul-19 | Profile        |
	| AEBL-5664     | 2372065         | Jul-19 | Profile        |
	| AEBT-5664     | 2355800         | Jul-19 | Reconciliation |




    # Change the date
    Given the override date is '04/12/2018'

    # Clear down the stub
    And there are no entries in the DCFS stub table

	# Clear down PaaS summarised actuals before the first pull of actuals
    And   there are no entries in the summarised actuals PaaS table
    
    # Pull actuals from DC for Nov 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201808 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 431.42      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201808 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 1807.28     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201808 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 1585.44     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201808 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 1183.84     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201808 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 2440.05     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201808 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 622.76      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201808 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 2303.78     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201808 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 1084.43     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201808 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 1521.43     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201808 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 1923.57     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201808 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 1709.72     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201808 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 1172.80     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201808 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 2287.71     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201808 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 1480.55     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201808 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 339.36      |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201809 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 767.16      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201809 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 2348.56     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201809 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 1766.15     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201809 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 2278.07     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201809 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 1898.22     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201809 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 227.75      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201809 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 2433.41     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201809 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 711.80      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201809 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 2440.54     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201809 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 212.58      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201809 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 2300.86     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201809 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 1252.56     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201809 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 538.89      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201809 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 1505.54     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201809 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 1978.69     |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201810 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 2420.07     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201810 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 1357.69     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201810 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 2285.30     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201810 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 1331.04     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201810 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 1558.11     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201810 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 871.67      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201810 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 1218.67     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201810 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 2054.88     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201810 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 964.68      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201810 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 430.04      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201810 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 489.97      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201810 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 1413.98     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201810 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 1318.36     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201810 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 625.97      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201810 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 1290.88     |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201811 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 233.98      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201811 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 585.10      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201811 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 645.48      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201811 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 2373.19     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201811 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 2113.56     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201811 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 2499.62     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201811 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 1343.88     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201811 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 1502.14     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201811 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 1804.17     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201811 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 2017.67     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201811 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 2182.92     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201811 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 2096.53     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201811 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 1636.61     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201811 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 823.62      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201811 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 1290.76     |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201812 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 1771.98     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201812 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 1208.08     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201812 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 915.64      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201812 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 1595.37     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201812 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 1799.01     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201812 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 2068.45     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201812 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 2092.32     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201812 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 1942.06     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201812 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 1278.82     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201812 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 1060.55     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201812 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 254.81      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201812 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 2116.22     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201812 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 721.33      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201812 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 588.06      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201812 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 1191.64     |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201901 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 1509.63     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201901 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 1863.16     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201901 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 996.37      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201901 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 2265.35     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201901 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 2302.60     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201901 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 989.25      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201901 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 1431.53     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201901 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 469.57      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201901 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 1510.77     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201901 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 1371.21     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201901 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 1019.62     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201901 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 1869.52     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201901 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 1768.31     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201901 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 1176.47     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201901 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 688.37      |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201902 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 708.27      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201902 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 1388.96     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201902 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 1303.77     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201902 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 338.70      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201902 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 145.84      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201902 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 487.79      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201902 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 894.35      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201902 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 855.77      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201902 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 2078.20     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201902 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 340.86      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201902 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 2193.52     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201902 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 1005.49     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201902 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 1037.38     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201902 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 1788.26     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201902 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 2246.02     |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201903 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 1438.54     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201903 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 1868.12     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201903 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 1906.38     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201903 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 660.60      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201903 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 1640.95     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201903 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 813.07      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201903 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 865.82      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201903 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 949.41      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201903 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 423.11      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201903 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 1478.61     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201903 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 991.55      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201903 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 1248.54     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201903 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 1246.76     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201903 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 1794.54     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201903 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 1973.90     |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201904 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 1420.87     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201904 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 968.26      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201904 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 1314.60     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201904 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 1960.00     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201904 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 1420.55     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201904 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 1532.28     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201904 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 1160.78     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201904 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 956.77      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201904 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 1774.33     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201904 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 355.09      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201904 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 2417.73     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201904 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 390.58      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201904 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 1808.98     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201904 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 592.90      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201904 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 1573.78     |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201905 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 1098.72     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201905 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 1134.75     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201905 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 2464.99     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201905 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 609.29      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201905 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 2021.34     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201905 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 1362.46     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201905 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 1341.38     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201905 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 651.53      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201905 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 1830.31     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201905 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 816.31      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201905 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 1683.16     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201905 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 2249.03     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201905 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 1319.43     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201905 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 1054.16     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201905 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 1262.13     |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201906 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 1100.29     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201906 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 2168.17     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201906 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 900.35      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201906 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 1146.42     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201906 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 1930.33     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201906 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 1541.37     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201906 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 167.02      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201906 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 1137.56     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201906 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 333.40      |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201906 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 1673.46     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201906 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 451.75      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201906 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 2092.30     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201906 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 1192.41     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201906 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 1276.86     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201906 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 2119.08     |
    #
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201907 | AEB-TOL1819             | AEBT-5662                |            | 2               | 0            | 862.25      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201907 | AEB-TOL1819             | AEBT-5662                |            | 3               | 0            | 1865.53     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201907 | AEB-TOL1819             | AEBT-5662                |            | 4               | 0            | 508.48      |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201907 | AEB-TOL1819             | AEBT-5662                |            | 5               | 0            | 2471.28     |
    | AEB1819        | AEB04                | ORG0217566     | CM             | 201907 | AEB-TOL1819             | AEBT-5662                |            | 6               | 0            | 1557.96     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201907 | AEB-TOL1819             | AEBT-5663                |            | 2               | 0            | 1920.54     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201907 | AEB-TOL1819             | AEBT-5663                |            | 3               | 0            | 2027.59     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201907 | AEB-TOL1819             | AEBT-5663                |            | 4               | 0            | 1411.57     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201907 | AEB-TOL1819             | AEBT-5663                |            | 5               | 0            | 2194.26     |
    | AEB1819        | AEB04                | ORG0317566     | CM             | 201907 | AEB-TOL1819             | AEBT-5663                |            | 6               | 0            | 1692.32     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201907 | AEB-TOL1819             | AEBT-5664                |            | 2               | 0            | 2155.78     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201907 | AEB-TOL1819             | AEBT-5664                |            | 3               | 0            | 805.67      |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201907 | AEB-TOL1819             | AEBT-5664                |            | 4               | 0            | 1225.95     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201907 | AEB-TOL1819             | AEBT-5664                |            | 5               | 0            | 1705.22     |
    | AEB1819        | AEB04                | ORG0417566     | CM             | 201907 | AEB-TOL1819             | AEBT-5664                |            | 6               | 0            | 897.13      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

   # Check the ACTUAL VALUES in CRM
   #Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-566       | AEBC-5662       | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBL-5662       | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 2               | 3852.63  | 431.42   | 767.16   | 2420.07  | 233.98   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 3               | 6098.63  | 1807.28  | 2348.56  | 1357.69  | 585.10   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 4               | 6282.37  | 1585.44  | 1766.15  | 2285.30  | 645.48   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 5               | 7166.14  | 1183.84  | 2278.07  | 1331.04  | 2373.19  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 6               | 8009.94  | 2440.05  | 1898.22  | 1558.11  | 2113.56  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-566       | AEBC-5663       | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBL-5663       | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 2               | 4221.80  | 622.76   | 227.75   | 871.67   | 2499.62  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 3               | 7299.74  | 2303.78  | 2433.41  | 1218.67  | 1343.88  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 4               | 5353.25  | 1084.43  | 711.80   | 2054.88  | 1502.14  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 5               | 6730.82  | 1521.43  | 2440.54  | 964.68   | 1804.17  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 6               | 4583.86  | 1923.57  | 212.58   | 430.04   | 2017.67  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-566       | AEBC-5664       | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBL-5664       | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 2               | 6683.47  | 1709.72  | 2300.86  | 489.97   | 2182.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 3               | 5935.87  | 1172.80  | 1252.56  | 1413.98  | 2096.53  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 4               | 5781.57  | 2287.71  | 538.89   | 1318.36  | 1636.61  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 5               | 4435.68  | 1480.55  | 1505.54  | 625.97   | 823.62   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 6               | 4899.69  | 339.36   | 1978.69  | 1290.88  | 1290.76  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-566       | AEBC-5662       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBL-5662       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBT-5662       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 2               | 3852.63  | 0.00     | 0.00     | 0.00     | 3852.63  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 3               | 6098.63  | 0.00     | 0.00     | 0.00     | 6098.63  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 4               | 6282.37  | 0.00     | 0.00     | 0.00     | 6282.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 5               | 7166.14  | 0.00     | 0.00     | 0.00     | 7166.14  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 6               | 8009.94  | 0.00     | 0.00     | 0.00     | 8009.94  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-566       | AEBC-5663       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBL-5663       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBT-5663       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 2               | 4221.80  | 0.00     | 0.00     | 0.00     | 4221.80  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 3               | 7299.74  | 0.00     | 0.00     | 0.00     | 7299.74  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 4               | 5353.25  | 0.00     | 0.00     | 0.00     | 5353.25  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 5               | 6730.82  | 0.00     | 0.00     | 0.00     | 6730.82  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 6               | 4583.86  | 0.00     | 0.00     | 0.00     | 4583.86  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-566       | AEBC-5664       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBL-5664       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBT-5664       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 2               | 6683.47  | 0.00     | 0.00     | 0.00     | 6683.47  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 3               | 5935.87  | 0.00     | 0.00     | 0.00     | 5935.87  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 4               | 5781.57  | 0.00     | 0.00     | 0.00     | 5781.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 5               | 4435.68  | 0.00     | 0.00     | 0.00     | 4435.68  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 6               | 4899.69  | 0.00     | 0.00     | 0.00     | 4899.69  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

   # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-566       | AEBC-5662       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBL-5662       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBT-5662       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 2               | -2004.80 | 0.00     | 0.00     | 0.00     | -2004.80 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 3               | -3173.55 | 0.00     | 0.00     | 0.00     | -3173.55 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 4               | -3269.16 | 0.00     | 0.00     | 0.00     | -3269.16 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 5               | -3729.05 | 0.00     | 0.00     | 0.00     | -3729.05 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 6               | -4168.14 | 0.00     | 0.00     | 0.00     | -4168.14 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-566       | AEBC-5663       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBL-5663       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBT-5663       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 2               | -1960.65 | 0.00     | 0.00     | 0.00     | -1960.65 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 3               | -3390.07 | 0.00     | 0.00     | 0.00     | -3390.07 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 4               | -2486.10 | 0.00     | 0.00     | 0.00     | -2486.10 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 5               | -3125.86 | 0.00     | 0.00     | 0.00     | -3125.86 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 6               | -2128.79 | 0.00     | 0.00     | 0.00     | -2128.79 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-566       | AEBC-5664       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBL-5664       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-566       | AEBT-5664       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 2               | -3334.78 | 0.00     | 0.00     | 0.00     | -3334.78 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 3               | -2961.76 | 0.00     | 0.00     | 0.00     | -2961.76 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 4               | -2884.77 | 0.00     | 0.00     | 0.00     | -2884.77 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 5               | -2213.22 | 0.00     | 0.00     | 0.00     | -2213.22 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 6               | -2444.75 | 0.00     | 0.00     | 0.00     | -2444.75 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-566       | AEBC-5662       | 1               | 24843.00 | 265.00   | 275.00   | 2212.00  | 2820.00  | 3714.00  | 2014.00  | 3413.00  | 1935.00  | 3650.00  | 1223.00  | 2084.00  | 1238.00  | 
    | AEBP-566       | AEBL-5662       | 1               | 22485.00 | 2220.00  | 1785.00  | 3089.00  | 2877.00  | 797.00   | 3336.00  | 401.00   | 821.00   | 544.00   | 1375.00  | 2585.00  | 2655.00  | 
    | AEBP-566       | AEBT-5662       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 2               | 1847.83  | 0.00     | 0.00     | 0.00     | 1847.83  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 3               | 2925.08  | 0.00     | 0.00     | 0.00     | 2925.08  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 4               | 3013.21  | 0.00     | 0.00     | 0.00     | 3013.21  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 5               | 3437.09  | 0.00     | 0.00     | 0.00     | 3437.09  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5662       | 6               | 3841.80  | 0.00     | 0.00     | 0.00     | 3841.80  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-566       | AEBC-5663       | 1               | 33780.00 | 3410.00  | 3449.00  | 3331.00  | 3686.00  | 2619.00  | 2120.00  | 2634.00  | 1092.00  | 2999.00  | 1962.00  | 3108.00  | 3370.00  | 
    | AEBP-566       | AEBL-5663       | 1               | 28027.00 | 2645.00  | 2052.00  | 130.00   | 2196.00  | 684.00   | 3253.00  | 2947.00  | 2131.00  | 3594.00  | 2907.00  | 2250.00  | 3238.00  | 
    | AEBP-566       | AEBT-5663       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 2               | 2261.15  | 0.00     | 0.00     | 0.00     | 2261.15  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 3               | 3909.67  | 0.00     | 0.00     | 0.00     | 3909.67  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 4               | 2867.15  | 0.00     | 0.00     | 0.00     | 2867.15  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 5               | 3604.96  | 0.00     | 0.00     | 0.00     | 3604.96  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5663       | 6               | 2455.07  | 0.00     | 0.00     | 0.00     | 2455.07  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-566       | AEBC-5664       | 1               | 18606.00 | 2972.00  | 2127.00  | 1944.00  | 1509.00  | 2814.00  | 2601.00  | 521.00   | 2078.00  | 126.00   | 546.00   | 269.00   | 1099.00  | 
    | AEBP-566       | AEBL-5664       | 1               | 20100.00 | 1074.00  | 2127.00  | 3654.00  | 56.00    | 728.00   | 1430.00  | 1059.00  | 3155.00  | 570.00   | 1905.00  | 3337.00  | 1005.00  | 
    | AEBP-566       | AEBT-5664       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 2               | 3348.69  | 0.00     | 0.00     | 0.00     | 3348.69  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 3               | 2974.11  | 0.00     | 0.00     | 0.00     | 2974.11  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 4               | 2896.80  | 0.00     | 0.00     | 0.00     | 2896.80  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 5               | 2222.46  | 0.00     | 0.00     | 0.00     | 2222.46  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-566       | AEBT-5664       | 6               | 2454.94  | 0.00     | 0.00     | 0.00     | 2454.94  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION subnominal aggregations in PaaS for Nov 2018
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10217566 | ORG0217566 | AEBT-5662         | 2355800         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 3852.63         |
    | 10217566 | ORG0217566 | AEBT-5662         | 2355860         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 6098.63         |
    | 10217566 | ORG0217566 | AEBT-5662         | 2355865         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 6282.37         |
    | 10217566 | ORG0217566 | AEBT-5662         | 2372010         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 7166.14         |
    | 10217566 | ORG0217566 | AEBT-5662         | 2372060         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 8009.94         |
    #
    | 10317566 | ORG0317566 | AEBT-5663         | 2355800         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 4221.80         |
    | 10317566 | ORG0317566 | AEBT-5663         | 2355860         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 7299.74         |
    | 10317566 | ORG0317566 | AEBT-5663         | 2355865         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 5353.25         |
    | 10317566 | ORG0317566 | AEBT-5663         | 2372010         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 6730.82         |
    | 10317566 | ORG0317566 | AEBT-5663         | 2372060         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 4583.86         |
    #
    | 10417566 | ORG0417566 | AEBT-5664         | 2355800         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 6683.47         |
    | 10417566 | ORG0417566 | AEBT-5664         | 2355860         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 5935.87         |
    | 10417566 | ORG0417566 | AEBT-5664         | 2355865         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 5781.57         |
    | 10417566 | ORG0417566 | AEBT-5664         | 2372010         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 4435.68         |
    | 10417566 | ORG0417566 | AEBT-5664         | 2372060         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 4899.69         |

    # Check the CAPPING subnominal aggregations in PaaS for Nov 2018
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10217566 | ORG0217566 | AEBT-5662         | 2355816         | AEB-TOL1819                | 201811               | CAPPING         | CM             | False       | -8447.51        |
    | 10217566 | ORG0217566 | AEBT-5662         | 2372016         | AEB-TOL1819                | 201811               | CAPPING         | CM             | False       | -7897.19        |
    #
    | 10317566 | ORG0317566 | AEBT-5663         | 2355816         | AEB-TOL1819                | 201811               | CAPPING         | CM             | False       | -7836.82        |
    | 10317566 | ORG0317566 | AEBT-5663         | 2372016         | AEB-TOL1819                | 201811               | CAPPING         | CM             | False       | -5254.65        |
    #
    | 10417566 | ORG0417566 | AEBT-5664         | 2355816         | AEB-TOL1819                | 201811               | CAPPING         | CM             | False       | -9181.31        |
    | 10417566 | ORG0417566 | AEBT-5664         | 2372016         | AEB-TOL1819                | 201811               | CAPPING         | CM             | False       | -4657.97        |

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Aug-18    | Sep-18    | Oct-18    | Nov-18    |
    | AEBP-566       | AEBT-5662       | 2355800                  | 0.00      | 0.00      | 0.00      | 3852.63   | 
    | AEBP-566       | AEBT-5662       | 2355860                  | 0.00      | 0.00      | 0.00      | 6098.63   | 
    | AEBP-566       | AEBT-5662       | 2355865                  | 0.00      | 0.00      | 0.00      | 6282.37   | 
    | AEBP-566       | AEBT-5662       | 2372010                  | 0.00      | 0.00      | 0.00      | 7166.14   | 
    | AEBP-566       | AEBT-5662       | 2372060                  | 0.00      | 0.00      | 0.00      | 8009.94   | 
    #
    | AEBP-566       | AEBT-5663       | 2355800                  | 0.00      | 0.00      | 0.00      | 4221.80   | 
    | AEBP-566       | AEBT-5663       | 2355860                  | 0.00      | 0.00      | 0.00      | 7299.74   | 
    | AEBP-566       | AEBT-5663       | 2355865                  | 0.00      | 0.00      | 0.00      | 5353.25   | 
    | AEBP-566       | AEBT-5663       | 2372010                  | 0.00      | 0.00      | 0.00      | 6730.82   | 
    | AEBP-566       | AEBT-5663       | 2372060                  | 0.00      | 0.00      | 0.00      | 4583.86   | 
    #
    | AEBP-566       | AEBT-5664       | 2355800                  | 0.00      | 0.00      | 0.00      | 6683.47   | 
    | AEBP-566       | AEBT-5664       | 2355860                  | 0.00      | 0.00      | 0.00      | 5935.87   | 
    | AEBP-566       | AEBT-5664       | 2355865                  | 0.00      | 0.00      | 0.00      | 5781.57   | 
    | AEBP-566       | AEBT-5664       | 2372010                  | 0.00      | 0.00      | 0.00      | 4435.68   | 
    | AEBP-566       | AEBT-5664       | 2372060                  | 0.00      | 0.00      | 0.00      | 4899.69   | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | CappingSubnominal        | Aug-18    | Sep-18    | Oct-18    | Nov-18    |
    | AEBP-566       | AEBT-5662       | 2355816                  | 0.00      | 0.00      | 0.00      | -8447.51  | 
    | AEBP-566       | AEBT-5662       | 2372016                  | 0.00      | 0.00      | 0.00      | -7897.19  | 
    #
    | AEBP-566       | AEBT-5663       | 2355816                  | 0.00      | 0.00      | 0.00      | -7836.82  | 
    | AEBP-566       | AEBT-5663       | 2372016                  | 0.00      | 0.00      | 0.00      | -5254.65  | 
    #
    | AEBP-566       | AEBT-5664       | 2355816                  | 0.00      | 0.00      | 0.00      | -9181.31  | 
    | AEBP-566       | AEBT-5664       | 2372016                  | 0.00      | 0.00      | 0.00      | -4657.97  | 




    # Change the date
    Given the override date is '07/12/2018 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-TOL1819' AccountingPaymentPeriod '201808' CensusEndDate '07/12/2018' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AEBT-5662                | 201811 |
    | AEBT-5663                | 201811 |
    | AEBT-5664                | 201811 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-TOL1819                | 201811               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017566 | AEB-TOL1819                | CODA566   | 8115000      | 01/08/1990           | 31/08/2020         |
#    | 10217566 | AEB-TOL1819                | CODB566   | 8115000      | 01/08/1990           | 31/08/2020         |
#    | 10317566 | AEB-TOL1819                | CODC566   | 8115000      | 01/08/1990           | 31/08/2020         |
#    | 10417566 | AEB-TOL1819                | CODD566   | 8115000      | 01/08/1990           | 31/08/2020         |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-TOL1819                | 201811               | Completed |

#    # File created in Maytech FTP folder for 'Adult Education Budget (Procured) - Traineeships and Other Learning 18/19'
#    And   Payment file 'AEBT20180807A.pay' is created in the FTP Folder
#
#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#    Given there is an encrypted file called 'AEBT20180807A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    # Check the contents of the payment file
#    Then  the following details are present in payment file 'AEBT20180807A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6   | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3      | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODB566  | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 3852.63  | 160  | 157      | AEBTR   | 19-24 Traineeships Rec Dec18    | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10217566 | 2355800 | 1     | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355800  | 5000     | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 3852.63  | 161  | 158      | AEBTR   | 19-24 Traineeships Rec Dec18    | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10217566 | CODB566 | 1     | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODB566  | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 8447.51  | 161  | 157      | AEBTC   | AEB 19-24 Traineeshp Cap Dec18  | 17/12/2018 | ?   | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10217566 | 2355816 | 2     | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355816  | 5000     | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 8447.51  | 160  | 158      | AEBTC   | AEB 19-24 Traineeshp Cap Dec18  | 17/12/2018 | VIO | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10217566 | CODB566 | 2     | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODB566  | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 6098.63  | 160  | 157      | AEBTR   | 19-24TraineeshpsLngS Rec Dec18  | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10217566 | 2355860 | 3     | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355860  | 5000     | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 6098.63  | 161  | 158      | AEBTR   | 19-24TraineeshpsLngS Rec Dec18  | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10217566 | CODB566 | 3     | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODB566  | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 6282.37  | 160  | 157      | AEBTR   | 19-24TraineeshpsLnrS Rec Dec18  | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10217566 | 2355865 | 4     | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355865  | 5000     | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 6282.37  | 161  | 158      | AEBTR   | 19-24TraineeshpsLnrS Rec Dec18  | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10217566 | CODB566 | 4     | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODB566  | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 7166.14  | 160  | 157      | AEBTR   | AEB Other Learning Rec Dec18    | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10217566 | 2372010 | 5     | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2372010  | 5000     | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 7166.14  | 161  | 158      | AEBTR   | AEB Other Learning Rec Dec18    | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10217566 | CODB566 | 5     | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODB566  | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 7897.19  | 161  | 157      | AEBTC   | AEB Other Learning Cap Dec18    | 17/12/2018 | ?   | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10217566 | 2372016 | 6     | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2372016  | 5000     | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 7897.19  | 160  | 158      | AEBTC   | AEB Other Learning Cap Dec18    | 17/12/2018 | VIO | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10217566 | CODB566 | 6     | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODB566  | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 8009.94  | 160  | 157      | AEBTR   | AEB OthLearning LngS Rec Dec18  | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10217566 | 2372060 | 7     | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2372060  | 5000     | 02       | AEBT-5662  | ?        | ?        | 2018 | 08     | 07/12/2018 | 8009.94  | 161  | 158      | AEBTR   | AEB OthLearning LngS Rec Dec18  | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10217566 | CODB566 | 7     | 2         |
#    #
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODC566  | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 4221.80  | 160  | 157      | AEBTR   | 19-24 Traineeships Rec Dec18    | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10317566 | 2355800 | 8     | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355800  | 5000     | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 4221.80  | 161  | 158      | AEBTR   | 19-24 Traineeships Rec Dec18    | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10317566 | CODC566 | 8     | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODC566  | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 7836.82  | 161  | 157      | AEBTC   | AEB 19-24 Traineeshp Cap Dec18  | 17/12/2018 | ?   | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10317566 | 2355816 | 9     | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355816  | 5000     | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 7836.82  | 160  | 158      | AEBTC   | AEB 19-24 Traineeshp Cap Dec18  | 17/12/2018 | VIO | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10317566 | CODC566 | 9     | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODC566  | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 7299.74  | 160  | 157      | AEBTR   | 19-24TraineeshpsLngS Rec Dec18  | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10317566 | 2355860 | 10    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355860  | 5000     | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 7299.74  | 161  | 158      | AEBTR   | 19-24TraineeshpsLngS Rec Dec18  | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10317566 | CODC566 | 10    | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODC566  | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 5353.25  | 160  | 157      | AEBTR   | 19-24TraineeshpsLnrS Rec Dec18  | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10317566 | 2355865 | 11    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355865  | 5000     | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 5353.25  | 161  | 158      | AEBTR   | 19-24TraineeshpsLnrS Rec Dec18  | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10317566 | CODC566 | 11    | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODC566  | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 6730.82  | 160  | 157      | AEBTR   | AEB Other Learning Rec Dec18    | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10317566 | 2372010 | 12    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2372010  | 5000     | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 6730.82  | 161  | 158      | AEBTR   | AEB Other Learning Rec Dec18    | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10317566 | CODC566 | 12    | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODC566  | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 5254.65  | 161  | 157      | AEBTC   | AEB Other Learning Cap Dec18    | 17/12/2018 | ?   | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10317566 | 2372016 | 13    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2372016  | 5000     | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 5254.65  | 160  | 158      | AEBTC   | AEB Other Learning Cap Dec18    | 17/12/2018 | VIO | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10317566 | CODC566 | 13    | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODC566  | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 4583.86  | 160  | 157      | AEBTR   | AEB OthLearning LngS Rec Dec18  | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10317566 | 2372060 | 14    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2372060  | 5000     | 02       | AEBT-5663  | ?        | ?        | 2018 | 08     | 07/12/2018 | 4583.86  | 161  | 158      | AEBTR   | AEB OthLearning LngS Rec Dec18  | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10317566 | CODC566 | 14    | 2         |
#    #
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODD566  | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 6683.47  | 160  | 157      | AEBTR   | 19-24 Traineeships Rec Dec18    | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10417566 | 2355800 | 15    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355800  | 5000     | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 6683.47  | 161  | 158      | AEBTR   | 19-24 Traineeships Rec Dec18    | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10417566 | CODD566 | 15    | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODD566  | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 9181.31  | 161  | 157      | AEBTC   | AEB 19-24 Traineeshp Cap Dec18  | 17/12/2018 | ?   | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10417566 | 2355816 | 16    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355816  | 5000     | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 9181.31  | 160  | 158      | AEBTC   | AEB 19-24 Traineeshp Cap Dec18  | 17/12/2018 | VIO | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10417566 | CODD566 | 16    | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODD566  | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 5935.87  | 160  | 157      | AEBTR   | 19-24TraineeshpsLngS Rec Dec18  | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10417566 | 2355860 | 17    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355860  | 5000     | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 5935.87  | 161  | 158      | AEBTR   | 19-24TraineeshpsLngS Rec Dec18  | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10417566 | CODD566 | 17    | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODD566  | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 5781.57  | 160  | 157      | AEBTR   | 19-24TraineeshpsLnrS Rec Dec18  | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10417566 | 2355865 | 18    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2355865  | 5000     | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 5781.57  | 161  | 158      | AEBTR   | 19-24TraineeshpsLnrS Rec Dec18  | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10417566 | CODD566 | 18    | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODD566  | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 4435.68  | 160  | 157      | AEBTR   | AEB Other Learning Rec Dec18    | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10417566 | 2372010 | 19    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2372010  | 5000     | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 4435.68  | 161  | 158      | AEBTR   | AEB Other Learning Rec Dec18    | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10417566 | CODD566 | 19    | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODD566  | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 4657.97  | 161  | 157      | AEBTC   | AEB Other Learning Cap Dec18    | 17/12/2018 | ?   | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10417566 | 2372016 | 20    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2372016  | 5000     | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 4657.97  | 160  | 158      | AEBTC   | AEB Other Learning Cap Dec18    | 17/12/2018 | VIO | AEBT PAYMENT CAP 2018/19      | AEBT180807A | ?            | ?       | 10417566 | CODD566 | 20    | 2         |
#    | AEBT180807A | SFA         | AAA40    | +        | 8115000  | CODD566  | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 4899.69  | 160  | 157      | AEBTR   | AEB OthLearning LngS Rec Dec18  | 17/12/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10417566 | 2372060 | 21    | 1         |
#    | AEBT180807A | SFA         | AAA40    | +        | 2372060  | 5000     | 02       | AEBT-5664  | ?        | ?        | 2018 | 08     | 07/12/2018 | 4899.69  | 161  | 158      | AEBTR   | AEB OthLearning LngS Rec Dec18  | 17/12/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180807A | ?            | ?       | 10417566 | CODD566 | 21    | 2         |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-TOL1819' PaymentPeriod '201808' CensusEndDate '07/12/2018' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A662.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-TOL1819' PaymentPeriod '201808' CensusEndDate '07/12/2018' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5662     | 3852.63         | RECONCILIATION   | 19-24 Traineeships                 | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10217566 | 2355800    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5662     | -8447.51        | CAPPING          | AEB 19-24 Traineeshp               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10217566 | 2355816    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5662     | 6098.63         | RECONCILIATION   | 19-24TraineeshpsLngS               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10217566 | 2355860    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5662     | 6282.37         | RECONCILIATION   | 19-24TraineeshpsLnrS               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10217566 | 2355865    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5662     | 7166.14         | RECONCILIATION   | AEB Other Learning                 | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10217566 | 2372010    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5662     | -7897.19        | CAPPING          | AEB Other Learning                 | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10217566 | 2372016    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5662     | 8009.94         | RECONCILIATION   | AEB OthLearning LngS               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10217566 | 2372060    |
    #
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5663     | 4221.80         | RECONCILIATION   | 19-24 Traineeships                 | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10317566 | 2355800    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5663     | -7836.82        | CAPPING          | AEB 19-24 Traineeshp               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10317566 | 2355816    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5663     | 7299.74         | RECONCILIATION   | 19-24TraineeshpsLngS               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10317566 | 2355860    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5663     | 5353.25         | RECONCILIATION   | 19-24TraineeshpsLnrS               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10317566 | 2355865    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5663     | 6730.82         | RECONCILIATION   | AEB Other Learning                 | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10317566 | 2372010    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5663     | -5254.65        | CAPPING          | AEB Other Learning                 | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10317566 | 2372016    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5663     | 4583.86         | RECONCILIATION   | AEB OthLearning LngS               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10317566 | 2372060    |
    #
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5664     | 6683.47         | RECONCILIATION   | 19-24 Traineeships                 | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10417566 | 2355800    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5664     | -9181.31        | CAPPING          | AEB 19-24 Traineeshp               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10417566 | 2355816    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5664     | 5935.87         | RECONCILIATION   | 19-24TraineeshpsLngS               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10417566 | 2355860    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5664     | 5781.57         | RECONCILIATION   | 19-24TraineeshpsLnrS               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10417566 | 2355865    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5664     | 4435.68         | RECONCILIATION   | AEB Other Learning                 | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10417566 | 2372010    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5664     | -4657.97        | CAPPING          | AEB Other Learning                 | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10417566 | 2372016    |
    | AEBT                   | 2018          | 08             | 07          | ?       | AEBT-5664     | 4899.69         | RECONCILIATION   | AEB OthLearning LngS               | 2018-12-17 | 2018-08-01   | 2019-07-31 | ?              | 10417566 | 2372060    |

    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEB-TOL1819' AccountingPaymentPeriod '201808' and CensusEndDate '07/12/2018'

    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period AEB-TOL1819 for Payment Period 201808 have been generated as of Census End Date/Time 2018-12-07T22:00:00Z. |

    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate        | PaymentLineCount | TotalValue |
    | AEB-TOL1819         | 201808        | 2018-12-07T22:00:00Z | 21               | 44060.01   |

    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | AEBT      | 01/08/2018   | 31/07/2019 | 07/12/2018    | 17/12/2018 | 2018          | 08             |

    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0217566  | 10217566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5662  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355800    | RECONCILIATION | 19-24 Traineeships            | 3852.63         |
    | ORG0217566  | 10217566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5662  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355816    | CAPPING        | AEB 19-24 Traineeshp          | -8447.51        |
    | ORG0217566  | 10217566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5662  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355860    | RECONCILIATION | 19-24TraineeshpsLngS          | 6098.63         |
    | ORG0217566  | 10217566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5662  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355865    | RECONCILIATION | 19-24TraineeshpsLnrS          | 6282.37         |
    | ORG0217566  | 10217566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5662  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372010    | RECONCILIATION | AEB Other Learning            | 7166.14         |
    | ORG0217566  | 10217566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5662  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372016    | CAPPING        | AEB Other Learning            | -7897.19        |
    | ORG0217566  | 10217566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5662  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372060    | RECONCILIATION | AEB OthLearning LngS          | 8009.94         |
    #
    | ORG0317566  | 10317566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5663  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355800    | RECONCILIATION | 19-24 Traineeships            | 4221.80         |
    | ORG0317566  | 10317566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5663  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355816    | CAPPING        | AEB 19-24 Traineeshp          | -7836.82        |
    | ORG0317566  | 10317566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5663  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355860    | RECONCILIATION | 19-24TraineeshpsLngS          | 7299.74         |
    | ORG0317566  | 10317566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5663  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355865    | RECONCILIATION | 19-24TraineeshpsLnrS          | 5353.25         |
    | ORG0317566  | 10317566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5663  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372010    | RECONCILIATION | AEB Other Learning            | 6730.82         |
    | ORG0317566  | 10317566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5663  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372016    | CAPPING        | AEB Other Learning            | -5254.65        |
    | ORG0317566  | 10317566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5663  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372060    | RECONCILIATION | AEB OthLearning LngS          | 4583.86         |
    #
    | ORG0417566  | 10417566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5664  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355800    | RECONCILIATION | 19-24 Traineeships            | 6683.47         |
    | ORG0417566  | 10417566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5664  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355816    | CAPPING        | AEB 19-24 Traineeshp          | -9181.31        |
    | ORG0417566  | 10417566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5664  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355860    | RECONCILIATION | 19-24TraineeshpsLngS          | 5935.87         |
    | ORG0417566  | 10417566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5664  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355865    | RECONCILIATION | 19-24TraineeshpsLnrS          | 5781.57         |
    | ORG0417566  | 10417566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5664  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372010    | RECONCILIATION | AEB Other Learning            | 4435.68         |
    | ORG0417566  | 10417566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5664  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372016    | CAPPING        | AEB Other Learning            | -4657.97        |
    | ORG0417566  | 10417566       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBT-5664  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372060    | RECONCILIATION | AEB OthLearning LngS          | 4899.69         |

#   # Check that payment files have not been created in the Maytech FTP folder (22121)
#   And   Payment file 'AEBT20180807A.nat' is not present on the Maytech FTP server
#   And   Payment file 'AEBT20180807A.pay' is not present on the Maytech FTP server
#   And   Payment file 'AEBT20180807A.err' is not present on the Maytech FTP server
#   # It is possible that the payment files could be created AFTER this check is done. Check manually

	# Tidy up
    And   the override date is reset
    
