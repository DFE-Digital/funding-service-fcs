Feature: InhibitPaymentCalcAfterCloseDate 22166

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run123
Scenario: A300 Create and approve an 8-allocation 1718 NCS contract. Consume actuals. Bulk amend before PoP FSP close date. Approve after PoP FSP close date but before PoA FSP close date. Check CRM and PaaS financials
    Given there is no Contract, Task or Workflow data for UKPRN '10017300'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSA-300      |
    | NCSC-300      |
    | NCSD-300      |
    | NCSE-300      |
    | NCSF-300      |
    | NCSI-300      |
    | NCSP-300      |
    | NCSS-300      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017300' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017300 Co Ltd' with UKPRN '10017300' and OrgId 'ORG0017300' and has 'FCS1 Test' as a manager 
    And   UPIN '117300' is associated with UKPRN '10017300' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017300 | 117300 | 10017300 Co Ltd | 0              | Active | Yes           | AA017300      | ?             | 

    # Change the date 
    And   the override date is '17/03/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017300 | 10017300 Co Ltd      | ESFA-300             | NCS-300        | 1                     | 01/04/2017        | 31/03/2018      | 349083.00     | Gyrwe                          | Contract for Services | 1718   | New          | ORG0017300 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription   | CRMIntent    |
    | 10017300 | NCS-300        | NCSA-300      | NCS-EA            | NCS-EA1718              | FY                      | 01/04/2017          | 31/03/2018        | 9586.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017300 | NCS-300        | NCSC-300      | NCS-C             | NCS-C1718               | FY                      | 01/04/2017          | 31/03/2018        | 142270.00       | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017300 | NCS-300        | NCSD-300      | NCS-SEEDIC        | NCS-SEEDIC1718          | FY                      | 01/04/2017          | 31/03/2018        | 6515.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017300 | NCS-300        | NCSE-300      | NCS-IC            | NCS-IC1718              | FY                      | 01/04/2017          | 31/03/2018        | 12251.00        | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017300 | NCS-300        | NCSF-300      | NCS-FWL           | NCS-FWL1718             | FY                      | 01/04/2017          | 31/03/2018        | 4157.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017300 | NCS-300        | NCSI-300      | NCS-I             | NCS-I1718               | FY                      | 01/04/2017          | 31/03/2018        | 9759.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017300 | NCS-300        | NCSP-300      | NCS-P             | NCS-P1718               | FY                      | 01/04/2017          | 31/03/2018        | 157038.00       | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017300 | NCS-300        | NCSS-300      | NCS-ASIST         | NCS-ASIST1718           | FY                      | 01/04/2017          | 31/03/2018        | 7507.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | DeliverableDescription                                      | CRMIntent    |
    | 10017300 | NCS-300        | NCSA-300      | 1               | 0                     | 9586.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.00  | 3114.00  | 0.00     | 0.00     | 2688.00  | Enabling Apprenticeships                                    | New          |
    | 10017300 | NCS-300        | NCSC-300      | 1               | 0                     | 142270.00 | 7775.00  | 13120.00 | 12961.00 | 12941.00 | 13522.00 | 13139.00 | 17026.00 | 7877.00  | 16408.00 | 8887.00  | 10076.00 | 8538.00  | Total In The Community Funding                              | New          |
    | 10017300 | NCS-300        | NCSC-300      | 2               | 1                     | 53348.00  | 4910.00  | 5325.00  | 5916.00  | 2209.00  | 3207.00  | 5548.00  | 5600.00  | 3400.00  | 5400.00  | 3777.00  | 2995.00  | 5061.00  | Customer Satisfaction                                       | New          |
    | 10017300 | NCS-300        | NCSC-300      | 3               | 1                     | 88922.00  | 2865.00  | 7795.00  | 7045.00  | 10732.00 | 10315.00 | 7591.00  | 11426.00 | 4477.00  | 11008.00 | 5110.00  | 7081.00  | 3477.00  | Career Management and Jobs and Learning                     | New          |
    | 10017300 | NCS-300        | NCSC-300      | 4               | 3                     | 46397.00  | 1655.00  | 2420.00  | 3233.00  | 5451.00  | 5305.00  | 2798.00  | 5821.00  | 3416.00  | 5918.00  | 3124.00  | 4852.00  | 2404.00  | Career Management                                           | New          |
    | 10017300 | NCS-300        | NCSC-300      | 5               | 3                     | 42525.00  | 1210.00  | 5375.00  | 3812.00  | 5281.00  | 5010.00  | 4793.00  | 5605.00  | 1061.00  | 5090.00  | 1986.00  | 2229.00  | 1073.00  | Jobs and Learning                                           | New          |
    | 10017300 | NCS-300        | NCSC-300      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                 | New          |
    | 10017300 | NCS-300        | NCSD-300      | 1               | 0                     | 6515.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5257.00  | 1258.00  | Support and Enhance Existing Delivery In-Community Funding  | New          |
    | 10017300 | NCS-300        | NCSE-300      | 1               | 0                     | 12251.00  | 0.00     | 0.00     | 0.00     | 2286.00  | 0.00     | 2396.00  | 0.00     | 0.00     | 4917.00  | 0.00     | 0.00     | 2652.00  | Inspiration and Employer Engagement in Custody Activity     | New          |
    | 10017300 | NCS-300        | NCSF-300      | 1               | 0                     | 4157.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3065.00  | 0.00     | 0.00     | 1092.00  | Fuller Working Lives 50+                                    | New          |
    | 10017300 | NCS-300        | NCSI-300      | 1               | 0                     | 9759.00   | 0.00     | 2047.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4280.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3432.00  | Inspiration Activity                                        | New          |
    | 10017300 | NCS-300        | NCSP-300      | 1               | 0                     | 157038.00 | 12955.00 | 9313.00  | 19224.00 | 17248.00 | 11421.00 | 10852.00 | 8192.00  | 12373.00 | 15117.00 | 16936.00 | 11235.00 | 12172.00 | Total In Custody Funding                                    | New          |
    | 10017300 | NCS-300        | NCSP-300      | 2               | 1                     | 34883.00  | 3681.00  | 1031.00  | 5034.00  | 3244.00  | 3637.00  | 2758.00  | 1564.00  | 4612.00  | 1945.00  | 1893.00  | 2480.00  | 3004.00  | Customer Satisfaction                                       | New          |
    | 10017300 | NCS-300        | NCSP-300      | 3               | 1                     | 122155.00 | 9274.00  | 8282.00  | 14190.00 | 14004.00 | 7784.00  | 8094.00  | 6628.00  | 7761.00  | 13172.00 | 15043.00 | 8755.00  | 9168.00  | Career Management and Jobs and Learning                     | New          |
    | 10017300 | NCS-300        | NCSP-300      | 4               | 3                     | 40208.00  | 4092.00  | 1635.00  | 5515.00  | 2722.00  | 5038.00  | 1653.00  | 3396.00  | 975.00   | 4688.00  | 5172.00  | 2332.00  | 2990.00  | Career Management                                           | New          |
    | 10017300 | NCS-300        | NCSP-300      | 5               | 3                     | 43920.00  | 3474.00  | 820.00   | 4261.00  | 5879.00  | 1285.00  | 4859.00  | 1029.00  | 5823.00  | 5999.00  | 4381.00  | 4377.00  | 1733.00  | Jobs and Learning                                           | New          |
    | 10017300 | NCS-300        | NCSP-300      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                 | New          |
    | 10017300 | NCS-300        | NCSP-300      | 7               | 3                     | 38027.00  | 1708.00  | 5827.00  | 4414.00  | 5403.00  | 1461.00  | 1582.00  | 2203.00  | 963.00   | 2485.00  | 5490.00  | 2046.00  | 4445.00  | Career Management 2                                         | New          |
    | 10017300 | NCS-300        | NCSS-300      | 1               | 0                     | 7507.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5704.00  | 1803.00  | Apprenticeship Specialist Intervention and Support Team     | New          |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | 10017300 | NCS-300        | NCSC-300      | 6               | 2412      | 179      | 193      | 205      | 129      | 114      | 307      | 178      | 178      | 129      | 130      | 336      | 334      |
    | 10017300 | NCS-300        | NCSP-300      | 6               | 1977      | 89       | 151      | 70       | 120      | 185      | 173      | 276      | 170      | 71       | 190      | 139      | 343      |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 
 
    # Change the date 
    And   the override date is '19/03/2017' 
 
    # Publish the contract 
    And   the latest version of contract 'NCS-300' is in a state of 'Published to Provider' 

	# Check that deliverable creation has finished by counting the rows (essentially just a wait)
    Then  there are '228' deliverable period rows in CRM linked to the latest version of contract 'NCS-300'

    # Change the date 
    And   the override date is '21/03/2017' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-300' and actual ContractNumber 'NCS-300' 
 
    # Check CONTRACT version, status and dates in CRM
    Then   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017300 | NCS-300            | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017300 | ESFA-300           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 9586.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.00  | 3114.00  | 0.00     | 0.00     | 2688.00  | 
    | NCS-300        | NCSC-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSD-300        | 1               | 6515.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5257.00  | 1258.00  | 
    | NCS-300        | NCSE-300        | 1               | 12251.00 | 0.00     | 0.00     | 0.00     | 2286.00  | 0.00     | 2396.00  | 0.00     | 0.00     | 4917.00  | 0.00     | 0.00     | 2652.00  | 
    | NCS-300        | NCSF-300        | 1               | 4157.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3065.00  | 0.00     | 0.00     | 1092.00  | 
    | NCS-300        | NCSI-300        | 1               | 9759.00  | 0.00     | 2047.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4280.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3432.00  | 
    | NCS-300        | NCSP-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSS-300        | 1               | 7507.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5704.00  | 1803.00  | 

    # Check the BALANCING PAYMENTS in CRM
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSD-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSE-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSF-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSI-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSS-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSD-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSE-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSF-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSI-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSS-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSD-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSE-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSF-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSI-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSS-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 9586.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.00  | 3114.00  | 0.00     | 0.00     | 2688.00  | 
    | NCS-300        | NCSC-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSD-300        | 1               | 6515.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5257.00  | 1258.00  | 
    | NCS-300        | NCSE-300        | 1               | 12251.00 | 0.00     | 0.00     | 0.00     | 2286.00  | 0.00     | 2396.00  | 0.00     | 0.00     | 4917.00  | 0.00     | 0.00     | 2652.00  | 
    | NCS-300        | NCSF-300        | 1               | 4157.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3065.00  | 0.00     | 0.00     | 1092.00  | 
    | NCS-300        | NCSI-300        | 1               | 9759.00  | 0.00     | 2047.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4280.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3432.00  | 
    | NCS-300        | NCSP-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSS-300        | 1               | 7507.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5704.00  | 1803.00  | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 9586.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.00  | 3114.00  | 0.00     | 0.00     | 2688.00  | 
    | NCS-300        | NCSC-300        | 1               | 142270.00| 7775.00  | 13120.00 | 12961.00 | 12941.00 | 13522.00 | 13139.00 | 17026.00 | 7877.00  | 16408.00 | 8887.00  | 10076.00 | 8538.00  | 
    | NCS-300        | NCSC-300        | 2               | 53348.00 | 4910.00  | 5325.00  | 5916.00  | 2209.00  | 3207.00  | 5548.00  | 5600.00  | 3400.00  | 5400.00  | 3777.00  | 2995.00  | 5061.00  | 
    | NCS-300        | NCSC-300        | 3               | 88922.00 | 2865.00  | 7795.00  | 7045.00  | 10732.00 | 10315.00 | 7591.00  | 11426.00 | 4477.00  | 11008.00 | 5110.00  | 7081.00  | 3477.00  | 
    | NCS-300        | NCSC-300        | 4               | 46397.00 | 1655.00  | 2420.00  | 3233.00  | 5451.00  | 5305.00  | 2798.00  | 5821.00  | 3416.00  | 5918.00  | 3124.00  | 4852.00  | 2404.00  | 
    | NCS-300        | NCSC-300        | 5               | 42525.00 | 1210.00  | 5375.00  | 3812.00  | 5281.00  | 5010.00  | 4793.00  | 5605.00  | 1061.00  | 5090.00  | 1986.00  | 2229.00  | 1073.00  | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSD-300        | 1               | 6515.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5257.00  | 1258.00  | 
    | NCS-300        | NCSE-300        | 1               | 12251.00 | 0.00     | 0.00     | 0.00     | 2286.00  | 0.00     | 2396.00  | 0.00     | 0.00     | 4917.00  | 0.00     | 0.00     | 2652.00  | 
    | NCS-300        | NCSF-300        | 1               | 4157.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3065.00  | 0.00     | 0.00     | 1092.00  | 
    | NCS-300        | NCSI-300        | 1               | 9759.00  | 0.00     | 2047.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4280.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3432.00  | 
    | NCS-300        | NCSP-300        | 1               | 157038.00| 12955.00 | 9313.00  | 19224.00 | 17248.00 | 11421.00 | 10852.00 | 8192.00  | 12373.00 | 15117.00 | 16936.00 | 11235.00 | 12172.00 | 
    | NCS-300        | NCSP-300        | 2               | 34883.00 | 3681.00  | 1031.00  | 5034.00  | 3244.00  | 3637.00  | 2758.00  | 1564.00  | 4612.00  | 1945.00  | 1893.00  | 2480.00  | 3004.00  | 
    | NCS-300        | NCSP-300        | 3               | 122155.00| 9274.00  | 8282.00  | 14190.00 | 14004.00 | 7784.00  | 8094.00  | 6628.00  | 7761.00  | 13172.00 | 15043.00 | 8755.00  | 9168.00  | 
    | NCS-300        | NCSP-300        | 4               | 40208.00 | 4092.00  | 1635.00  | 5515.00  | 2722.00  | 5038.00  | 1653.00  | 3396.00  | 975.00   | 4688.00  | 5172.00  | 2332.00  | 2990.00  | 
    | NCS-300        | NCSP-300        | 5               | 43920.00 | 3474.00  | 820.00   | 4261.00  | 5879.00  | 1285.00  | 4859.00  | 1029.00  | 5823.00  | 5999.00  | 4381.00  | 4377.00  | 1733.00  | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 7               | 38027.00 | 1708.00  | 5827.00  | 4414.00  | 5403.00  | 1461.00  | 1582.00  | 2203.00  | 963.00   | 2485.00  | 5490.00  | 2046.00  | 4445.00  | 
    | NCS-300        | NCSS-300        | 1               | 7507.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5704.00  | 1803.00  | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 4               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 5               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 6               | 2412     | 179      | 193      | 205      | 129      | 114      | 307      | 178      | 178      | 129      | 130      | 336      | 334      | 
    | NCS-300        | NCSD-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSE-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSF-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSI-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 4               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 5               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 6               | 1977     | 89       | 151      | 70       | 120      | 185      | 173      | 276      | 170      | 71       | 190      | 139      | 343      | 
    | NCS-300        | NCSP-300        | 7               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSS-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | ProfileSubnominal        | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 2305330                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.00  | 3114.00  | 0.00     | 0.00     | 2688.00  | 
    | NCS-300        | NCSD-300        | 2305330                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5257.00  | 1258.00  | 
    | NCS-300        | NCSE-300        | 2322060                  | 0.00     | 0.00     | 0.00     | 2286.00  | 0.00     | 2396.00  | 0.00     | 0.00     | 4917.00  | 0.00     | 0.00     | 2652.00  | 
    | NCS-300        | NCSF-300        | 2305330                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3065.00  | 0.00     | 0.00     | 1092.00  | 
    | NCS-300        | NCSI-300        | 2305310                  | 0.00     | 2047.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4280.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3432.00  | 
    | NCS-300        | NCSS-300        | 2305330                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5704.00  | 1803.00  | 

    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201705               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201707               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201709               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201710               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201711               | PROFILE         | CM             | False       | 3784.00         |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201712               | PROFILE         | CM             | False       | 3114.00         |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201802               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201803               | PROFILE         | CM             | False       | 2688.00         |
    # 
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201705               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201707               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201709               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201710               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201711               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201712               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201802               | PROFILE         | CM             | False       | 5257.00         |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201803               | PROFILE         | CM             | False       | 1258.00         |
    #
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201705               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201707               | PROFILE         | CM             | False       | 2286.00         |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201709               | PROFILE         | CM             | False       | 2396.00         |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201710               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201711               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201712               | PROFILE         | CM             | False       | 4917.00         |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201802               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201803               | PROFILE         | CM             | False       | 2652.00         |
    #
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201705               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201707               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201709               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201710               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201711               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201712               | PROFILE         | CM             | False       | 3065.00         |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201802               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201803               | PROFILE         | CM             | False       | 1092.00         |
    #
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201705               | PROFILE         | CM             | False       | 2047.00         |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201707               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201709               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201710               | PROFILE         | CM             | False       | 4280.00         |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201711               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201712               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201802               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201803               | PROFILE         | CM             | False       | 3432.00         |
    #
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201705               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201707               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201709               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201710               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201711               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201712               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201802               | PROFILE         | CM             | False       | 5704.00         |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201803               | PROFILE         | CM             | False       | 1803.00         |

    # Change the date
    And   the override date is '04/03/2018'

    # Consume DCFS Summarised Actuals for February 2018
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS            | N12                  | ORG0017300     | CM             | 201704 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 8400.78     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201704 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 2314.45     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201704 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 3157.88     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201705 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 9462.13     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201705 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 7188.22     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201705 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 2752.30     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201706 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 3432.41     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201706 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 7218.22     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201706 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 3373.06     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201707 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 8428.35     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201707 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 3584.24     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201707 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 7123.03     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201708 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 3746.32     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201708 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 2118.21     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201708 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 9275.06     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201709 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 8346.34     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201709 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 9418.27     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201709 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 2175.08     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201710 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 3246.31     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201710 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 3318.24     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201710 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 4745.02     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201711 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 5196.35     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201711 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 4288.22     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201711 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 8375.00     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201712 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 9466.34     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201712 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 3258.22     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201712 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 4345.00     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201801 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 3436.42     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201801 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 2428.29     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201801 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 3215.01     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201802 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 4346.45     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201802 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 3186.24     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201802 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 2455.05     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201803 | NCS-C1718               | NCSC-300                 | 0000000006 | 2               | 0            | 8564.46     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201803 | NCS-C1718               | NCSC-300                 | 0000000006 | 4               | 0            | 3383.27     | 
    | NCS            | N12                  | ORG0017300     | CM             | 201803 | NCS-C1718               | NCSC-300                 | 0000000006 | 5               | 0            | 5252.80     | 
 
     # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUALS in CRM for NCSC
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSC-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-300        | NCSC-300        | 2               | 67508.20 | 8400.78  | 9462.13  | 3432.41  | 8428.35  | 3746.32  | 8346.34  | 3246.31  | 5196.35  | 9466.34  | 3436.42  | 4346.45  | ?        | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-300        | NCSC-300        | 4               | 48320.81 | 2314.45  | 7188.22  | 7218.22  | 3584.24  | 2118.21  | 9418.27  | 3318.24  | 4288.22  | 3258.22  | 2428.29  | 3186.24  | ?        | 
    | NCS-300        | NCSC-300        | 5               | 50991.49 | 3157.88  | 2752.30  | 3373.06  | 7123.03  | 9275.06  | 2175.08  | 4745.02  | 8375.00  | 4345.00  | 3215.01  | 2455.05  | ?        | 

    # Check the CAPPING AMOUNTS in CRM for NCSC
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSC-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-300        | NCSC-300        | 2               | -14160.20| 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -14160.20| ?        | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-300        | NCSC-300        | 4               | -5055.45 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5055.45 | ?        | 
    | NCS-300        | NCSC-300        | 5               | -5334.86 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5334.86 | ?        | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM for NCSC
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSC-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-300        | NCSC-300        | 2               | 67508.20 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 67508.20 | ?        | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-300        | NCSC-300        | 4               | 48320.82 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 48320.82 | ?        | 
    | NCS-300        | NCSC-300        | 5               | 50991.49 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 50991.49 | ?        | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    # Check the NET AMOUNTS in CRM for NCSC
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSC-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-300        | NCSC-300        | 2               | 53348.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 53348.00 | ?        | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-300        | NCSC-300        | 4               | 43265.37 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 43265.37 | ?        | 
    | NCS-300        | NCSC-300        | 5               | 45656.63 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 45656.63 | ?        | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts in CRM are as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18    |
    | NCS-300        | NCSC-300        | 2305310                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 166820.51 | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | CappingSubnominal        | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18    |
    | NCS-300        | NCSC-300        | 2305310                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -24550.51 | 

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201704               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201705               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201706               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201707               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201708               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201709               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201710               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201711               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201712               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201801               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201802               | RECONCILIATION  | CM             | False       | 166820.51       |

    # Check the CAPPING subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201704               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201705               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201706               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201707               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201708               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201709               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201710               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201711               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201712               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201801               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201802               | CAPPING         | CM             | False       | -24550.51       |

    # Change the date 
    Given the override date is '22/03/2018' 

    # Bulk file to amend the contract 
    And   there are no files prefixed '10017300_NCS-300' in the Sharepoint 'NCS-1718-Input-Appendices' folder
    And   there are no files prefixed 'NCS FY 1718 02032018104818 v2_A300' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NCS FY 1718 02032018104818 v2_A300' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS FY 1718 02032018104818 v2_A300' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS FY 1718 02032018104818 v2_A300.xlsx' exists in the Datafiles folder and UKPRN '10017300' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   #And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 
 
    # Change the date 
    And   the override date is '26/03/2018' 
 
    # Publish the contract 
    And   the latest version of contract 'NCS-300' is in a state of 'Published to Provider' 

    # Check that deliverable creation has finished by counting the rows (essentially just a wait)
    And   there are '228' deliverable period rows in CRM linked to the latest version of contract 'NCS-300'

    # Set indicator to show month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
	
    # Change the date 
    # Activity Close Date for NCS(PoP) is 12/04/2018. For NCS(PoA) it is 14/05/2018 
    And   the override date is '22/04/2018' 

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-300' and actual ContractNumber 'NCS-300' 

    # Check CONTRACT version, status and dates in CRM
    Then   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017300 | NCS-300            | 2                     | 0                        | Approved         | Approved               | True          | True                | 01/04/2017        | 31/03/2018      | Variation     |
    | 10017300 | NCS-300            | 1                     | 0                        | Replaced         | Approved               | False         | False               | 01/04/2017        | 31/03/2018      | ?             |
    | 10017300 | ESFA-300           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check that the deliverable count has not changed 
    And   there are '234' deliverable period rows in CRM linked to the latest version of contract 'NCS-300'

    # Check the ACTUALS in CRM. These should not have changed although a new period is added
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   |
    | NCS-300        | NCSC-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 2               | 67508.20 | 8400.78  | 9462.13  | 3432.41  | 8428.35  | 3746.32  | 8346.34  | 3246.31  | 5196.35  | 9466.34  | 3436.42  | 4346.45  | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 4               | 48320.81 | 2314.45  | 7188.22  | 7218.22  | 3584.24  | 2118.21  | 9418.27  | 3318.24  | 4288.22  | 3258.22  | 2428.29  | 3186.24  | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 5               | 50991.49 | 3157.88  | 2752.30  | 3373.06  | 7123.03  | 9275.06  | 2175.08  | 4745.02  | 8375.00  | 4345.00  | 3215.01  | 2455.05  | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PoP-allocation PROFILE PAYMENTS in CRM. 
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 9586.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.00  | 3114.00  | 0.00     | 0.00     | 2688.00  | 
    | NCS-300        | NCSD-300        | 1               | 6515.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5257.00  | 1258.00  | 
    | NCS-300        | NCSE-300        | 1               | 12251.00 | 0.00     | 0.00     | 0.00     | 2286.00  | 0.00     | 2396.00  | 0.00     | 0.00     | 4917.00  | 0.00     | 0.00     | 2652.00  | 
    | NCS-300        | NCSF-300        | 1               | 4157.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3065.00  | 0.00     | 0.00     | 1092.00  | 
    | NCS-300        | NCSI-300        | 1               | 9759.00  | 0.00     | 2047.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4280.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3432.00  | 
    | NCS-300        | NCSP-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSS-300        | 1               | 7507.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5704.00  | 1803.00  | 

    # Check the PoP-allocation BALANCING PAYMENTS in CRM. These should all be zero (or null)
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSD-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSE-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSF-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSI-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSS-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PoP-allocation CAPPING AMOUNTS in CRM. These should all be zero (or null)
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSD-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSE-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSF-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSI-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSS-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PoA-allocation CAPPING AMOUNTS in CRM. These should have changed as the caps have been partly released by the contract amendment.
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18    | Mar-18   | Apr-18   |
    | NCS-300        | NCSC-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 2               | -18150.40| 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -14160.20 | 0.00     | -3990.20 | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 4               | -6992.57 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5055.45  | 0.00     | -1937.12 | 
    | NCS-300        | NCSC-300        | 5               | -7379.05 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5334.86  | 0.00     | -2044.19 | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 
 
     # Check the PoP-allocation RECONCILIATION AMOUNTS in CRM. These should be unchanged
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSD-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSE-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSF-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSI-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSP-300        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-300        | NCSS-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

	# Check the PoA-allocation RECONCILIATION AMOUNTS in CRM. These should have changed as the caps have been partly released by the contract amendment.
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   |
    | NCS-300        | NCSC-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 2               | 81668.41 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 67508.20 | 0.00     | 14160.20 | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 4               | 53376.27 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 48320.82 | 0.00     | 5055.45  | 
    | NCS-300        | NCSC-300        | 5               | 56326.35 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 50991.49 | 0.00     | 5334.86  | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PoP-allocation NET AMOUNTS in CRM. These should be unchanged (although some nulls have changed to zeros - ok?
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 9586.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.00  | 3114.00  | 0.00     | 0.00     | 2688.00  | 
    | NCS-300        | NCSD-300        | 1               | 6515.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5257.00  | 1258.00  | 
    | NCS-300        | NCSE-300        | 1               | 12251.00 | 0.00     | 0.00     | 0.00     | 2286.00  | 0.00     | 2396.00  | 0.00     | 0.00     | 4917.00  | 0.00     | 0.00     | 2652.00  | 
    | NCS-300        | NCSF-300        | 1               | 4157.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3065.00  | 0.00     | 0.00     | 1092.00  | 
    | NCS-300        | NCSI-300        | 1               | 9759.00  | 0.00     | 2047.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4280.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3432.00  | 
    | NCS-300        | NCSP-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSS-300        | 1               | 7507.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5704.00  | 1803.00  | 

    # Check the PoA-allocation NET AMOUNTS in CRM. These should have changed as the caps have been partly released by the contract amendment.
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   |
    | NCS-300        | NCSC-300        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 2               | 63518.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 53348.00 | 0.00     | 10170.00 | 
    | NCS-300        | NCSC-300        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSC-300        | 4               | 46383.70 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 43265.37 | 0.00     | 3118.33  | 
    | NCS-300        | NCSC-300        | 5               | 48947.30 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 45656.63 | 0.00     | 3290.67  | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VALUES in CRM. These should have changed across the board to reflect the values from the bulk import amendment file
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 26750.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10050.00 | 8125.00  | 0.00     | 0.00     | 8575.00  | 
    | NCS-300        | NCSC-300        | 1               | 158849.00| 12573.00 | 12527.00 | 12662.00 | 6325.00  | 14538.00 | 9645.00  | 10371.00 | 20388.00 | 11052.00 | 27892.00 | 8926.00  | 11950.00 | 
    | NCS-300        | NCSC-300        | 2               | 63518.00 | 4303.00  | 8760.00  | 2802.00  | 2941.00  | 3840.00  | 4779.00  | 4283.00  | 9135.00  | 3629.00  | 10457.00 | 4379.00  | 4210.00  | 
    | NCS-300        | NCSC-300        | 3               | 95331.00 | 8270.00  | 3767.00  | 9860.00  | 3384.00  | 10698.00 | 4866.00  | 6088.00  | 11253.00 | 7423.00  | 17435.00 | 4547.00  | 7740.00  | 
    | NCS-300        | NCSC-300        | 4               | 49222.00 | 3669.00  | 2664.00  | 8327.00  | 1586.00  | 1639.00  | 1482.00  | 1256.00  | 7128.00  | 4812.00  | 8549.00  | 3437.00  | 4673.00  | 
    | NCS-300        | NCSC-300        | 5               | 46109.00 | 4601.00  | 1103.00  | 1533.00  | 1798.00  | 9059.00  | 3384.00  | 4832.00  | 4125.00  | 2611.00  | 8886.00  | 1110.00  | 3067.00  | 
    | NCS-300        | NCSC-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSD-300        | 1               | 20075.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12050.00 | 8025.00  | 
    | NCS-300        | NCSE-300        | 1               | 20860.00 | 0.00     | 0.00     | 0.00     | 2685.00  | 0.00     | 6275.00  | 0.00     | 0.00     | 10150.00 | 0.00     | 0.00     | 1750.00  | 
    | NCS-300        | NCSF-300        | 1               | 25250.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 15250.00 | 0.00     | 0.00     | 10000.00 | 
    | NCS-300        | NCSI-300        | 1               | 8950.00  | 0.00     | 5225.00  | 0.00     | 0.00     | 0.00     | 0.00     | 1475.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2250.00  | 
    | NCS-300        | NCSP-300        | 1               | 129864.00| 15959.00 | 8455.00  | 13775.00 | 13350.00 | 10870.00 | 8850.00  | 10380.00 | 10085.00 | 11370.00 | 9285.00  | 9885.00  | 7600.00  | 
    | NCS-300        | NCSP-300        | 2               | 28334.00 | 4534.00  | 1355.00  | 4925.00  | 1025.00  | 2825.00  | 350.00   | 1450.00  | 810.00   | 2625.00  | 2310.00  | 4450.00  | 1675.00  | 
    | NCS-300        | NCSP-300        | 3               | 101530.00| 11425.00 | 7100.00  | 8850.00  | 12325.00 | 8045.00  | 8500.00  | 8930.00  | 9275.00  | 8745.00  | 6975.00  | 5435.00  | 5925.00  | 
    | NCS-300        | NCSP-300        | 4               | 32970.00 | 4025.00  | 3225.00  | 2800.00  | 3950.00  | 1050.00  | 2025.00  | 4075.00  | 2875.00  | 3925.00  | 1050.00  | 575.00   | 3395.00  | 
    | NCS-300        | NCSP-300        | 5               | 37230.00 | 3575.00  | 1750.00  | 3675.00  | 4150.00  | 4900.00  | 3950.00  | 2005.00  | 2850.00  | 2925.00  | 2750.00  | 3225.00  | 1475.00  | 
    | NCS-300        | NCSP-300        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-300        | NCSP-300        | 7               | 31330.00 | 3825.00  | 2125.00  | 2375.00  | 4225.00  | 2095.00  | 2525.00  | 2850.00  | 3550.00  | 1895.00  | 3175.00  | 1635.00  | 1055.00  | 
    | NCS-300        | NCSS-300        | 1               | 16100.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7850.00  | 8250.00  | 

    # Check the PLANNED VOLUMES in CRM. These should have changed for NCSC and NCSP to reflect the values from the bulk import amendment file
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 4               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 5               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSC-300        | 6               | 1691     | 81       | 99       | 153      | 193      | 73       | 125      | 75       | 224      | 128      | 214      | 209      | 117      | 
    | NCS-300        | NCSD-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSE-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSF-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSI-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 4               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 5               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSP-300        | 6               | 1644     | 93       | 125      | 238      | 87       | 84       | 147      | 161      | 175      | 139      | 236      | 94       | 65       | 
    | NCS-300        | NCSP-300        | 7               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-300        | NCSS-300        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 

    # Check the PoP-allocation PROFILE subnominal aggregations in CRM. These should not have changed
    And   the Profile Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | ProfileSubnominal        | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-300        | NCSA-300        | 2305330                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.00  | 3114.00  | 0.00     | 0.00     | 2688.00  | 
    | NCS-300        | NCSD-300        | 2305330                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5257.00  | 1258.00  | 
    | NCS-300        | NCSE-300        | 2322060                  | 0.00     | 0.00     | 0.00     | 2286.00  | 0.00     | 2396.00  | 0.00     | 0.00     | 4917.00  | 0.00     | 0.00     | 2652.00  | 
    | NCS-300        | NCSF-300        | 2305330                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3065.00  | 0.00     | 0.00     | 1092.00  | 
    | NCS-300        | NCSI-300        | 2305310                  | 0.00     | 2047.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4280.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3432.00  | 
    | NCS-300        | NCSS-300        | 2305330                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5704.00  | 1803.00  | 

    # Check the PoA-ALLOCATION RECONCILIATION subnominal aggregations in CRM. These should have changed
    And   the Reconciliation Subnominal Amounts in CRM are as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18    | Mar-18   | Apr-18   |
    | NCS-300        | NCSC-300        | 2305310                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 166820.51 | 0.00     | 24550.51 | 

    # Check the PoA-ALLOCATION CAPPING subnominal aggregations in CRM. These should have changed
    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | CappingSubnominal        | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18    | Mar-18   | Apr-18   |
    | NCS-300        | NCSC-300        | 2305310                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -24550.51 | 0.00     | -7971.51 | 

    # Check the PoP-allocation PROFILE subnominal aggregations in PaaS. These should not have changed
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201705               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201707               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201709               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201710               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201711               | PROFILE         | CM             | False       | 3784.00         |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201712               | PROFILE         | CM             | False       | 3114.00         |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201802               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSA-300          | 2305330         | NCS-EA1718                 | 201803               | PROFILE         | CM             | False       | 2688.00         |
    #
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201705               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201707               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201709               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201710               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201711               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201712               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201802               | PROFILE         | CM             | False       | 5257.00         |
    | 10017300 | ORG0017300 | NCSD-300          | 2305330         | NCS-SEEDIC1718             | 201803               | PROFILE         | CM             | False       | 1258.00         |
    #
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201705               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201707               | PROFILE         | CM             | False       | 2286.00         |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201709               | PROFILE         | CM             | False       | 2396.00         |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201710               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201711               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201712               | PROFILE         | CM             | False       | 4917.00         |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201802               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSE-300          | 2322060         | NCS-IC1718                 | 201803               | PROFILE         | CM             | False       | 2652.00         |
    #
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201705               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201707               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201709               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201710               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201711               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201712               | PROFILE         | CM             | False       | 3065.00         |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201802               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSF-300          | 2305330         | NCS-FWL1718                | 201803               | PROFILE         | CM             | False       | 1092.00         |
    #
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201705               | PROFILE         | CM             | False       | 2047.00         |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201707               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201709               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201710               | PROFILE         | CM             | False       | 4280.00         |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201711               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201712               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201802               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSI-300          | 2305310         | NCS-I1718                  | 201803               | PROFILE         | CM             | False       | 3432.00         |
    #
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201704               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201705               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201706               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201707               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201708               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201709               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201710               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201711               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201712               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201801               | PROFILE         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201802               | PROFILE         | CM             | False       | 5704.00         |
    | 10017300 | ORG0017300 | NCSS-300          | 2305330         | NCS-ASIST1718              | 201803               | PROFILE         | CM             | False       | 1803.00         |

    # Check the PoA-allocation RECONCILIATION subnominal aggregations in PaaS. These should have changed 
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201704               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201705               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201706               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201707               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201708               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201709               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201710               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201711               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201712               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201801               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201802               | RECONCILIATION  | CM             | False       | 166820.51       |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201803               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201804               | RECONCILIATION  | CM             | False       | 24550.51        |

    # Check the PoA-ALLOCATION CAPPING subnominal aggregations in PaaS. These should have changed
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201704               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201705               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201706               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201707               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201708               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201709               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201710               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201711               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201712               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201801               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201802               | CAPPING         | CM             | False       | -24550.51       |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201803               | CAPPING         | CM             | False       | 0.00            |
    | 10017300 | ORG0017300 | NCSC-300          | 2305310         | NCS-C1718                  | 201804               | CAPPING         | CM             | False       | -7971.51        |

    # Tidy up
    And   the override date is reset

