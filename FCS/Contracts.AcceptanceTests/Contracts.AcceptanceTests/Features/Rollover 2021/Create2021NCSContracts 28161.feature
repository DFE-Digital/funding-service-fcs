Feature: Create2021NCSContracts 28161

@AcceptanceTest @Withdrawn20230123
Scenario: A315 Create and approve an 1819 and a 1920 NCS contract with a linked Master. Bulk load a new 2021 NCS contract also with a linked Mster. Check 2021 docs then publish and approve 2021 contract
    Given there are no allocations marked as Under Termination for UKPRN '10017315' 
    And   there are no terminated or closed allocations for UKPRN '10017315' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017315' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017315' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-3151     |
    | NCSV-3151     |
    | NCSC-3152     |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-3151     |
    | NCSV-3151     |
    | NCSC-3152     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C1819         |
    | NCS-DEV1819       |
    | NCS-C1920         |
    | NCS-C2021         |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017315' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017315 Co Ltd' with UKPRN '10017315' and OrgId 'ORG0017315' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017315' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017315 | 117315 | 10017315 Co Ltd | 0              | Active                | Yes           | AA017315      | ?             | 1 Wellington Square    | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 1EN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017315 |




    # Create and approve 1819 NCS contract 
	
	# Change the date
    Given the override date is '01/09/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017315 | 10017315 Co Ltd      | ESFA-315             | NCS-3151       | 1                     | 01/10/2018        | 31/03/2019      | 47479.00      | West Midlands and Staffordshire       | Contract for Services                      | 1819   | New          | ORG0017315 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017315 | NCS-3151       | NCSC-3151     | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        | 35479.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |
    | 10017315 | NCS-3151       | NCSV-3151     | NCS-DEV           | NCS-DEV1819             | NCS                     | 01/10/2018          | 31/03/2019        | 12000.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017315 | NCS-3151       | NCSC-3151     | 1               | 0                     | 35479.00  | 7045.00  | 8429.00  | 3295.00  | 2910.00  | 6033.00  | 7767.00  | Total In The Community Funding                                  | New          |             | 
    | 10017315 | NCS-3151       | NCSC-3151     | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             | 
    | 10017315 | NCS-3151       | NCSC-3151     | 2               | 1                     | 10454.00  | 2656.00  | 3012.00  | 962.00   | 1446.00  | 1960.00  | 418.00   | Customer Satisfaction                                           | New          |             | 
    | 10017315 | NCS-3151       | NCSC-3151     | 3               | 1                     | 25025.00  | 4389.00  | 5417.00  | 2333.00  | 1464.00  | 4073.00  | 7349.00  | Career Management and Jobs and Learning                         | New          |             | 
    | 10017315 | NCS-3151       | NCSC-3151     | 4               | 3                     | 10516.00  | 2786.00  | 2732.00  | 177.00   | 439.00   | 637.00   | 3745.00  | Career Management                                               | New          |             | 
    | 10017315 | NCS-3151       | NCSC-3151     | 5               | 3                     | 14509.00  | 1603.00  | 2685.00  | 2156.00  | 1025.00  | 3436.00  | 3604.00  | Jobs and Learning                                               | New          |             | 
    | 10017315 | NCS-3151       | NCSV-3151     | 1               | 0                     | 12000.00  | 0.00     | 0.00     | 0.00     | 3900.00  | 3900.00  | 4200.00  | 50 Plus Futures                                                 | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | 
    | 10017315 | NCS-3151       | NCSC-3151     | 6               | 0        | 320     | 54       | 64       | 78       | 60       | 24       | 40       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NCS-315' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-3151'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-315' and actual ContractNumber 'NCS-3151'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-3151' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017315 | NCS-3151           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017315 | ESFA-315           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '42' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '42' deliverable period rows in CRM linked to the latest version of contract 'NCS-3151'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations 
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | NCSC-3151     | 2305310         | Mar-19 | Reconciliation |
    | NCSC-3151     | 2305310         | Mar-19 | Capping        |
    | NCSV-3151     | 2305330         | Mar-19 | Profile        |




    # Create and approve 1920 NCS contract

    # Change the date
    Given the override date is '01/03/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017315 | 10017315 Co Ltd      | ESFA-315             | NCS-3152       | 1                     | 01/04/2019        | 31/03/2020      | 71316.00      | West Midlands and Staffordshire       | Contract for Services                      | 1920   | New          | ORG0017315 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017315 | NCS-3152       | NCSC-3152     | NCS-C             | NCS-C1920               | FY                      | 01/04/2019          | 31/03/2020        | 71316.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017315 | NCS-3152       | NCSC-3152     | 1               | 0                     | 71316.00  | 7869.00  | 4791.00  | 4657.00  | 6042.00  | 5591.00  | 4223.00  | 4628.00  | 5378.00  | 5844.00  | 6185.00  | 9845.00  | 6263.00  | Total In The Community Funding                                  | New          |             | 
    | 10017315 | NCS-3152       | NCSC-3152     | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             | 
    | 10017315 | NCS-3152       | NCSC-3152     | 2               | 1                     | 24370.00  | 2198.00  | 118.00   | 2657.00  | 3424.00  | 142.00   | 3567.00  | 696.00   | 1906.00  | 1976.00  | 3503.00  | 3606.00  | 577.00   | Customer Satisfaction                                           | New          |             | 
    | 10017315 | NCS-3152       | NCSC-3152     | 3               | 1                     | 46946.00  | 5671.00  | 4673.00  | 2000.00  | 2618.00  | 5449.00  | 656.00   | 3932.00  | 3472.00  | 3868.00  | 2682.00  | 6239.00  | 5686.00  | Career Management and Jobs and Learning                         | New          |             | 
    | 10017315 | NCS-3152       | NCSC-3152     | 4               | 3                     | 23146.00  | 3146.00  | 1792.00  | 186.00   | 1303.00  | 3620.00  | 369.00   | 1738.00  | 2316.00  | 1565.00  | 117.00   | 3477.00  | 3517.00  | Career Management                                               | New          |             | 
    | 10017315 | NCS-3152       | NCSC-3152     | 5               | 3                     | 23800.00  | 2525.00  | 2881.00  | 1814.00  | 1315.00  | 1829.00  | 287.00   | 2194.00  | 1156.00  | 2303.00  | 2565.00  | 2762.00  | 2169.00  | Jobs and Learning                                               | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | 
    | 10017315 | NCS-3152       | NCSC-3152     | 6               | 0        | 659     | 79       | 94       | 25       | 74       | 17       | 72       | 23       | 54       | 76       | 55       | 50       | 40       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/03/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NCS-3152' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-3152'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-315' and actual ContractNumber 'NCS-3152'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-3152' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017315 | NCS-3152           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2019        | 31/03/2020      | ?             |
    | 10017315 | ESFA-315           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-3152'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations 
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | NCSC-3152     | 2305310         | Mar-20 | Reconciliation |
    | NCSC-3152     | 2305310         | Mar-20 | Capping        |




	# Bulk import using intent 'New Amendment' to create a new 2021 NCS contract linked by Master to the 1819 and 1920 NCS contracts

    # Change the date
    Given the override date is '22/03/2020'

    # Bulk file
    And   there are no files prefixed '10017315' in the Sharepoint 'NCS-2021-Input-Appendices' folder
    And   there are no files prefixed 'NCS FY 2021 10022020151538 v3_A315' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS FY 2021 10022020151538 v3_A315' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS FY 2021 10022020151538 v3_A315.xlsx' exists in the Datafiles folder and UKPRN '10017315' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017315' for FundingType 'NCS' and period '2021' and Delivery Organisation '10017315'
    And   I retrieve the latest contract details from CRM for provider '10017315' for FundingType 'NCS' and period '2021'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location 'NCS-2021-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 6
    Maximum Contract Value and Target
    Customer Volumes
    Maximum Contract Value
    1. In this Schedule, where the context admits, defined terms shall have the
    meaning given to them in Clause 1 of the Terms and Conditions.
    2. This Schedule sets out the Maximum Contract Value for the supply of the
    Services under the Contract from 1 April 2020 – 31 March 2021.  Delivery
    against this Contract shall start on 1 October 2018. For the avoidance of doubt,
    the Prime Contractor may not seek to invoice the ESFA in respect of any
    services supplied prior to the Services Start Date of 1 October 2018.
    3. The Maximum Contract Value in the Area for the period 1 April 2020 – 31 March
    2021 is £73,511. The Maximum Contract Value must be allocated in
    accordance with the principles set out in the Funding Rules.
    4. The Maximum Contract Value has been calculated to include inflation during the
    Contract Period and will not be increased to reflect inflationary rate rises during
    the Contract Period.
    5. The Maximum Contract Value in the Area for the Contract Year starting on 1
    April 2021, and for each subsequent anniversary thereof, shall be as notified by
    the ESFA to the Prime Contractor as soon as is practicable at the beginning of
    each calendar year, with final allocations confirmed at the beginning of May
    each year.
    6. This Schedule supplements the obligations on the Prime Contractor in the
    Terms and Conditions and the Funding Rules.
    Target Customer Volumes
    7. The Target Customer Volumes are as follows:
    Contract Year Target Customer Volumes
    01/04/20 – 31/03/21 1,996
    """

    #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'
   
    # Inject an SFS contract approval message.
   #When  an AEB contract approval message is received from SFS for MasterContractNumber 'ESFA-315' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-315' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved in CRM
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017315 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017315 | ESFA-315           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable counts in CRM (6 deliverables x 12mths)
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 




    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | [ContractNo]   | [AllocRef_NCSC]    | 1               | 73511.00  | 7581.00  | 8335.00  | 1124.00  | 9915.00  | 6981.00  | 6888.00  | 1209.00  | 1071.00  | 10074.00 | 6505.00  | 3365.00  | 10463.00 | 
    | [ContractNo]   | [AllocRef_NCSC]    | 2               | 25735.00  | 4576.00  | 1582.00  | 663.00   | 4735.00  | 1106.00  | 2090.00  | 451.00   | 418.00   | 4153.00  | 2851.00  | 491.00   | 2619.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 3               | 47776.00  | 3005.00  | 6753.00  | 461.00   | 5180.00  | 5875.00  | 4798.00  | 758.00   | 653.00   | 5921.00  | 3654.00  | 2874.00  | 7844.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 4               | 24508.00  | 227.00   | 3413.00  | 121.00   | 3730.00  | 4120.00  | 1635.00  | 504.00   | 260.00   | 4629.00  | 1423.00  | 1139.00  | 3307.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 5               | 23268.00  | 2778.00  | 3340.00  | 340.00   | 1450.00  | 1755.00  | 3163.00  | 254.00   | 393.00   | 1292.00  | 2231.00  | 1735.00  | 4537.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VOLUMES in CRM on the latest approved contract
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | [ContractNo]   | [AllocRef_NCSC]    | 1               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 2               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 3               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 4               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 5               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 6               | 1996      | 164      | 242      | 115      | 93       | 52       | 175      | 209      | 212      | 205      | 224      | 166      | 139      | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber    | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_NCSC]     | 1             | 1               | 202004 | 2              | 0             | 7581.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202004 | 2              | 0             | 4576.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202004 | 2              | 0             | 3005.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202004 | 2              | 0             | 227.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202004 | 2              | 0             | 2778.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202004 | 2              | 164           | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202005 | 2              | 0             | 8335.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202005 | 2              | 0             | 1582.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202005 | 2              | 0             | 6753.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202005 | 2              | 0             | 3413.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202005 | 2              | 0             | 3340.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202005 | 2              | 242           | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202006 | 2              | 0             | 1124.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202006 | 2              | 0             | 663.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202006 | 2              | 0             | 461.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202006 | 2              | 0             | 121.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202006 | 2              | 0             | 340.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202006 | 2              | 115           | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202007 | 2              | 0             | 9915.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202007 | 2              | 0             | 4735.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202007 | 2              | 0             | 5180.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202007 | 2              | 0             | 3730.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202007 | 2              | 0             | 1450.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202007 | 2              | 93            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202008 | 2              | 0             | 6981.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202008 | 2              | 0             | 1106.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202008 | 2              | 0             | 5875.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202008 | 2              | 0             | 4120.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202008 | 2              | 0             | 1755.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202008 | 2              | 52            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202009 | 2              | 0             | 6888.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202009 | 2              | 0             | 2090.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202009 | 2              | 0             | 4798.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202009 | 2              | 0             | 1635.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202009 | 2              | 0             | 3163.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202009 | 2              | 175           | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202010 | 2              | 0             | 1209.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202010 | 2              | 0             | 451.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202010 | 2              | 0             | 758.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202010 | 2              | 0             | 504.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202010 | 2              | 0             | 254.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202010 | 2              | 209           | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202011 | 2              | 0             | 1071.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202011 | 2              | 0             | 418.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202011 | 2              | 0             | 653.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202011 | 2              | 0             | 260.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202011 | 2              | 0             | 393.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202011 | 2              | 212           | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202012 | 2              | 0             | 10074.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202012 | 2              | 0             | 4153.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202012 | 2              | 0             | 5921.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202012 | 2              | 0             | 4629.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202012 | 2              | 0             | 1292.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202012 | 2              | 205           | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202101 | 2              | 0             | 6505.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202101 | 2              | 0             | 2851.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202101 | 2              | 0             | 3654.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202101 | 2              | 0             | 1423.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202101 | 2              | 0             | 2231.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202101 | 2              | 224           | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202102 | 2              | 0             | 3365.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202102 | 2              | 0             | 491.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202102 | 2              | 0             | 2874.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202102 | 2              | 0             | 1139.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202102 | 2              | 0             | 1735.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202102 | 2              | 166           | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_NCSC]     | 1             | 1               | 202103 | 2              | 0             | 10463.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 2               | 202103 | 2              | 0             | 2619.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 3               | 202103 | 2              | 0             | 7844.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 4               | 202103 | 2              | 0             | 3307.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 5               | 202103 | 2              | 0             | 4537.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_NCSC]     | 1             | 6               | 202103 | 2              | 139           | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |



    # Tidy up
    And   the override date is reset
	 
@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run123
Scenario: A316SLD Create and approve 1819, 1920 and 2021 NCS contracts all linked by one Master. Bulk amend and approve 2021. Consume actuals and create payment. Check CRM, CDA, Financials and feeds
    Given there are no allocations marked as Under Termination for UKPRN '10017316' 
    And   there are no terminated or closed allocations for UKPRN '10017316' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017316' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017316' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-3161     |
    | NCSV-3161     |
    | NCSC-3162     |
    | NCSC-3163     |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-3161     |
    | NCSV-3161     |
    | NCSC-3162     |
    | NCSC-3163     |


    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C1819         |
    | NCS-DEV1819       |
    | NCS-C1920         |
    | NCS-C2021         |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017316' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017316 Co Ltd' with UKPRN '10017316' and OrgId 'ORG0017316' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017316' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017316 | 117316 | 10017316 Co Ltd | 0              | Active                | Yes           | AA017316      | ?             | 9 High Street          | Delph                  | ?                      | ?                      | Saddleworth            | Greater Manchester     | OL4 7DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017316 |




    # Create and approve 1819 NCS contract 
	
    # Change the date
    Given the override date is '04/09/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017316 | 10017316 Co Ltd      | ESFA-316             | NCS-3161       | 1                     | 01/10/2018        | 31/03/2019      | 47479.00      | West Midlands and Staffordshire       | Contract for Services                      | 1819   | New          | ORG0017316 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017316 | NCS-3161       | NCSC-3161     | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        | 35479.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |
    | 10017316 | NCS-3161       | NCSV-3161     | NCS-DEV           | NCS-DEV1819             | NCS                     | 01/10/2018          | 31/03/2019        | 12000.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017316 | NCS-3161       | NCSC-3161     | 1               | 0                     | 35479.00  | 7045.00  | 8429.00  | 3295.00  | 2910.00  | 6033.00  | 7767.00  | Total In The Community Funding                                  | New          |             | 
    | 10017316 | NCS-3161       | NCSC-3161     | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             | 
    | 10017316 | NCS-3161       | NCSC-3161     | 2               | 1                     | 10454.00  | 2656.00  | 3012.00  | 962.00   | 1446.00  | 1960.00  | 418.00   | Customer Satisfaction                                           | New          |             | 
    | 10017316 | NCS-3161       | NCSC-3161     | 3               | 1                     | 25025.00  | 4389.00  | 5417.00  | 2333.00  | 1464.00  | 4073.00  | 7349.00  | Career Management and Jobs and Learning                         | New          |             | 
    | 10017316 | NCS-3161       | NCSC-3161     | 4               | 3                     | 10516.00  | 2786.00  | 2732.00  | 177.00   | 439.00   | 637.00   | 3745.00  | Career Management                                               | New          |             | 
    | 10017316 | NCS-3161       | NCSC-3161     | 5               | 3                     | 14509.00  | 1603.00  | 2685.00  | 2156.00  | 1025.00  | 3436.00  | 3604.00  | Jobs and Learning                                               | New          |             | 
    | 10017316 | NCS-3161       | NCSV-3161     | 1               | 0                     | 12000.00  | 0.00     | 0.00     | 0.00     | 3900.00  | 3900.00  | 4200.00  | 50 Plus Futures                                                 | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | 
    | 10017316 | NCS-3161       | NCSC-3161     | 6               | 0        | 320     | 54       | 64       | 78       | 60       | 24       | 40       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NCS-316' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-3161'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-316' and actual ContractNumber 'NCS-3161'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-3161' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017316 | NCS-3161           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017316 | ESFA-316           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '42' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '42' deliverable period rows in CRM linked to the latest version of contract 'NCS-3161'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations 
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | NCSC-3161     | 2305310         | Mar-19 | Reconciliation |
    | NCSC-3161     | 2305310         | Mar-19 | Capping        |
    | NCSV-3161     | 2305330         | Mar-19 | Profile        |




    # Create and approve 1920 NCS contract

    # Change the date
    Given the override date is '06/03/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017316 | 10017316 Co Ltd      | ESFA-316             | NCS-3162       | 1                     | 01/04/2019        | 31/03/2020      | 71316.00      | West Midlands and Staffordshire       | Contract for Services                      | 1920   | New          | ORG0017316 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017316 | NCS-3162       | NCSC-3162     | NCS-C             | NCS-C1920               | FY                      | 01/04/2019          | 31/03/2020        | 71316.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017316 | NCS-3162       | NCSC-3162     | 1               | 0                     | 71316.00  | 7869.00  | 4791.00  | 4657.00  | 6042.00  | 5591.00  | 4223.00  | 4628.00  | 5378.00  | 5844.00  | 6185.00  | 9845.00  | 6263.00  | Total In The Community Funding                                  | New          |             | 
    | 10017316 | NCS-3162       | NCSC-3162     | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             | 
    | 10017316 | NCS-3162       | NCSC-3162     | 2               | 1                     | 24370.00  | 2198.00  | 118.00   | 2657.00  | 3424.00  | 142.00   | 3567.00  | 696.00   | 1906.00  | 1976.00  | 3503.00  | 3606.00  | 577.00   | Customer Satisfaction                                           | New          |             | 
    | 10017316 | NCS-3162       | NCSC-3162     | 3               | 1                     | 46946.00  | 5671.00  | 4673.00  | 2000.00  | 2618.00  | 5449.00  | 656.00   | 3932.00  | 3472.00  | 3868.00  | 2682.00  | 6239.00  | 5686.00  | Career Management and Jobs and Learning                         | New          |             | 
    | 10017316 | NCS-3162       | NCSC-3162     | 4               | 3                     | 23146.00  | 3146.00  | 1792.00  | 186.00   | 1303.00  | 3620.00  | 369.00   | 1738.00  | 2316.00  | 1565.00  | 117.00   | 3477.00  | 3517.00  | Career Management                                               | New          |             | 
    | 10017316 | NCS-3162       | NCSC-3162     | 5               | 3                     | 23800.00  | 2525.00  | 2881.00  | 1814.00  | 1316.00  | 1829.00  | 287.00   | 2194.00  | 1156.00  | 2303.00  | 2565.00  | 2762.00  | 2169.00  | Jobs and Learning                                               | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | 
    | 10017316 | NCS-3162       | NCSC-3162     | 6               | 0        | 659     | 79       | 94       | 25       | 74       | 17       | 72       | 23       | 54       | 76       | 55       | 50       | 40       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/03/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NCS-3162' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-3162'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-316' and actual ContractNumber 'NCS-3162'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-3162' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017316 | NCS-3162           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2019        | 31/03/2020      | ?             |
    | 10017316 | ESFA-316           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-3162'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations 
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | NCSC-3162     | 2305310         | Mar-20 | Reconciliation |
    | NCSC-3162     | 2305310         | Mar-20 | Capping        |




    # Create and approve 2021 NCS contract

    # Change the date
    Given the override date is '12/03/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017316 | 10017316 Co Ltd      | ESFA-316             | NCS-3163       | 1                     | 01/04/2020        | 31/03/2021      | 68721.00      | West Midlands and Staffordshire       | Contract for Services                      | 2021   | New          | ORG0017316 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017316 | NCS-3163       | NCSC-3163     | NCS-C             | NCS-C2021               | FY                      | 01/04/2020          | 31/03/2021        | 68721.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017316 | NCS-3163       | NCSC-3163     | 1               | 0                     | 68721.00  | 5471.00  | 5624.00  | 8114.00  | 6079.00  | 9236.00  | 5432.00  | 5743.00  | 4058.00  | 4429.00  | 6034.00  | 4918.00  | 3583.00  | Total In The Community Funding                                  | New          |             | 
    | 10017316 | NCS-3163       | NCSC-3163     | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             | 
    | 10017316 | NCS-3163       | NCSC-3163     | 2               | 1                     | 25144.00  | 3153.00  | 2150.00  | 2441.00  | 583.00   | 3439.00  | 3257.00  | 2822.00  | 425.00   | 213.00   | 1833.00  | 3390.00  | 1438.00  | Customer Satisfaction                                           | New          |             | 
    | 10017316 | NCS-3163       | NCSC-3163     | 3               | 1                     | 43577.00  | 2318.00  | 3474.00  | 5673.00  | 5496.00  | 5797.00  | 2175.00  | 2921.00  | 3633.00  | 4216.00  | 4201.00  | 1528.00  | 2145.00  | Career Management and Jobs and Learning                         | New          |             | 
    | 10017316 | NCS-3163       | NCSC-3163     | 4               | 3                     | 20850.00  | 1397.00  | 1120.00  | 1950.00  | 2178.00  | 3230.00  | 1056.00  | 1160.00  | 1832.00  | 2534.00  | 2163.00  | 557.00   | 1673.00  | Career Management                                               | New          |             | 
    | 10017316 | NCS-3163       | NCSC-3163     | 5               | 3                     | 22727.00  | 921.00   | 2354.00  | 3723.00  | 3318.00  | 2567.00  | 1119.00  | 1761.00  | 1801.00  | 1682.00  | 2038.00  | 971.00   | 472.00   | Jobs and Learning                                               | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | 
    | 10017316 | NCS-3163       | NCSC-3163     | 6               | 0        | 533     | 20       | 95       | 29       | 47       | 17       | 16       | 85       | 61       | 17       | 56       | 78       | 12       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NCS-3163' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-3163'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-316' and actual ContractNumber 'NCS-3163'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-3163' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017316 | NCS-3163           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017316 | ESFA-316           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-3163'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations 
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | NCSC-3163     | 2305310         | Mar-21 | Reconciliation |
    | NCSC-3163     | 2305310         | Mar-21 | Capping        |




    # Bulk amend the 2021 contract

    # Change the date
    Given the override date is '23/04/2020'

    # Bulk file
    And   there are no files prefixed '10017316' in the Sharepoint 'NCS-2021-Input-Appendices' folder
    And   there are no files prefixed 'NCS FY 2021 11022020161234 v3_A316' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NCS FY 2021 11022020161234 v3_A316' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NCS FY 2021 11022020161234 v3_A316' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS FY 2021 11022020161234 v3_A316' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS FY 2021 11022020161234 v3_A316.xlsx' exists in the Datafiles folder and UKPRN '10017316' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #Then  a syntax report should exist in the Sharepoint Reports folder
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Change the date
    Given the override date is '25/04/2020'
	
	# Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NCS-3163' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-3163'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-316' and actual ContractNumber 'NCS-3163'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-3163' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017316 | NCS-3163           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | Variation     |
    | 10017316 | NCS-3163           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2020        | 31/03/2021      | ?             |
    | 10017316 | ESFA-316           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (6 deliverables x 12mths)
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-3163'




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/08/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017316'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202004 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 1547.99     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202004 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 1905.92     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202004 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 675.33      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202005 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 668.74      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202005 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 1289.76     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202005 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 1504.21     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202006 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 1384.61     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202006 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 603.38      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202006 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 473.41      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202007 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 665.51      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202007 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 538.86      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202007 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 2301.15     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202008 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 773.57      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202008 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 2559.76     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202008 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 847.02      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202009 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 2378.99     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202009 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 2708.09     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202009 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 2327.11     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202010 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 1507.37     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202010 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 1085.81     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202010 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 499.01      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202011 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 2495.11     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202011 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 2555.99     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202011 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 757.13      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202012 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 508.56      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202012 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 1370.90     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202012 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 590.17      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202101 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 2544.77     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202101 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 1150.02     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202101 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 2708.44     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202102 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 1166.92     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202102 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 1421.55     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202102 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 973.66      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202103 | NCS-C2021               | NCSC-3163                | 0000000104 | 2               | 0            | 650.58      |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202103 | NCS-C2021               | NCSC-3163                | 0000000104 | 4               | 0            | 1876.30     |
    | NCS2021        | N12                  | ORG0017316     | CM             | 202103 | NCS-C2021               | NCSC-3163                | 0000000104 | 5               | 0            | 2460.98     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service




    # Check CRM and PaaS

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-3163       | NCSC-3163          | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3163       | NCSC-3163          | 2               | 4266.85   | 1547.99  | 668.74   | 1384.61  | 665.51   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3163       | NCSC-3163          | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3163       | NCSC-3163          | 4               | 4337.92   | 1905.92  | 1289.76  | 603.38   | 538.86   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3163       | NCSC-3163          | 5               | 4954.10   | 675.33   | 1504.21  | 473.41   | 2301.15  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3163       | NCSC-3163          | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-3163       | NCSC-3163          | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-3163       | NCSC-3163          | 2               | 4266.85   | 0.00     | 0.00     | 0.00     | 4266.85  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-3163       | NCSC-3163          | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-3163       | NCSC-3163          | 4               | 4337.92   | 0.00     | 0.00     | 0.00     | 4337.92  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-3163       | NCSC-3163          | 5               | 4954.10   | 0.00     | 0.00     | 0.00     | 4954.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-3163       | NCSC-3163          | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-3163       | NCSC-3163          | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-3163       | NCSC-3163          | 2               | 4266.85   | 0.00     | 0.00     | 0.00     | 4266.85  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-3163       | NCSC-3163          | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-3163       | NCSC-3163          | 4               | 4337.92   | 0.00     | 0.00     | 0.00     | 4337.92  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-3163       | NCSC-3163          | 5               | 4954.10   | 0.00     | 0.00     | 0.00     | 4954.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-3163       | NCSC-3163          | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Payment Batch starts here for NCS-C2021

    # Change the date
    Given the override date is '11/08/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'NCS-C2021' AccountingPaymentPeriod '202004' CensusEndDate '10/08/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | NCSC-3163                | 202007 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | NCS-C2021                  | 202007               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | NCS-C2021                  | 202007               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'NCS-C2021' PaymentPeriod '202004' CensusEndDate '10/08/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A316.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'NCS-C2021' PaymentPeriod '202004' CensusEndDate '10/08/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | NCSC                   | 2020          | 04             | 10          | ?       | NCSC-3163     | 13558.87        | RECONCILIATION   | NCS Adult Core                     | 2020-08-20 | 2020-04-01   | 2021-03-31 | ?              | 10017316 | 2305310    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    And   there is an item on the Payment feed for FundingStreamPeriod 'NCS-C2021' AccountingPaymentPeriod '202004' and CensusEndDate '10/08/2020'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                               |
    | Payment Requests for Funding Stream Period NCS-C2021 for Payment Period 202004 have been generated as of Census End Date/Time 2020-08-10T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | NCS-C2021           | 202004        | 2020-08-10T22:00:00Z  | 1                | 13558.87   |


    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | NCSC      | 01/04/2020   | 31/03/2021 | 10/08/2020    | 20/08/2020 | 2020          | 04             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017316  | 10017316       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NCSC-3163  | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2305310    | RECONCILIATION | NCS Adult Core                | 13558.87        |




#    # CDA
#	
#	# Check the contents of the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version A316.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | NCS-3163       | 2                     |
#
#   #When  the following CDA reports are run
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version               | Suffix |
#    | NCS-C2021            | Last Approved Version | A316   |
#
#    Then  a report named 'CDA Last Approved Version A316.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 4                 | 2020            | 2020/21       |              | 601          | 1905.92      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Apr              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 5                 | 2020            | 2020/21       |              | 3787         | 1289.76      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | May              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 6                 | 2020            | 2020/21       |              | 495          | 603.38       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Jun              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 7                 | 2020            | 2020/21       |              | 4104         | 538.86       | 0             |              | Yes                | 0.00           | 0.00             | 4337.92               | 0.00           | 4337.92         |             | Yes           | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Jul              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 8                 | 2020            | 2020/21       |              | 4494         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Aug              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 9                 | 2020            | 2020/21       |              | 2009         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Sep              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 10                | 2020            | 2020/21       |              | 878          |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Oct              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 11                | 2020            | 2020/21       |              | 942          |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Nov              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 12                | 2020            | 2020/21       |              | 361          |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Dec              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 1                 | 2021            | 2020/21       |              | 2106         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Jan              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 2                 | 2021            | 2020/21       |              | 1821         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Feb              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 3                 | 2021            | 2020/21       |              | 3990         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Mar              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 4                 | 2020            | 2020/21       |              | 4950         | 1547.99      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Apr              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 5                 | 2020            | 2020/21       |              | 1956         | 668.74       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | May              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 6                 | 2020            | 2020/21       |              | 1037         | 1384.61      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Jun              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 7                 | 2020            | 2020/21       |              | 158          | 665.51       | 0             |              | Yes                | 0.00           | 0.00             | 4266.85               | 0.00           | 4266.85         |             | Yes           | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Jul              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 8                 | 2020            | 2020/21       |              | 1480         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Aug              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 9                 | 2020            | 2020/21       |              | 2465         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Sep              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 10                | 2020            | 2020/21       |              | 825          |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Oct              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 11                | 2020            | 2020/21       |              | 793          |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Nov              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 12                | 2020            | 2020/21       |              | 4527         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Dec              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 1                 | 2021            | 2020/21       |              | 3225         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Jan              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 2                 | 2021            | 2020/21       |              | 865          |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Feb              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 3                 | 2021            | 2020/21       |              | 2994         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Mar              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 4                 | 2020            | 2020/21       |              | 0            | 0            | 97            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Apr              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 5                 | 2020            | 2020/21       |              | 0            | 0            | 175           |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | May              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 6                 | 2020            | 2020/21       |              | 0            | 0            | 249           |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Jun              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 7                 | 2020            | 2020/21       |              | 0            | 0            | 227           |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Jul              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 8                 | 2020            | 2020/21       |              | 0            |              | 187           |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Aug              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 9                 | 2020            | 2020/21       |              | 0            |              | 108           |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Sep              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 10                | 2020            | 2020/21       |              | 0            |              | 143           |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Oct              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 11                | 2020            | 2020/21       |              | 0            |              | 145           |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Nov              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 12                | 2020            | 2020/21       |              | 0            |              | 139           |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Dec              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 1                 | 2021            | 2020/21       |              | 0            |              | 158           |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Jan              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 2                 | 2021            | 2020/21       |              | 0            |              | 100           |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Feb              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 3                 | 2021            | 2020/21       |              | 0            |              | 73            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   |                          |                   | Mar              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 4                 | 2020            | 2020/21       |              | 3461         | 675.33       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Apr              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 5                 | 2020            | 2020/21       |              | 4022         | 1504.21      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | May              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 6                 | 2020            | 2020/21       |              | 3652         | 473.41       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Jun              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 7                 | 2020            | 2020/21       |              | 4763         | 2301.15      | 0             |              | Yes                | 0.00           | 0.00             | 4954.10               | 0.00           | 4954.10         |             | Yes           | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Jul              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 8                 | 2020            | 2020/21       |              | 116          |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Aug              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 9                 | 2020            | 2020/21       |              | 1524         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Sep              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 10                | 2020            | 2020/21       |              | 3567         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Oct              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 11                | 2020            | 2020/21       |              | 3705         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Nov              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 12                | 2020            | 2020/21       |              | 4604         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Dec              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 1                 | 2021            | 2020/21       |              | 592          |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Jan              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 2                 | 2021            | 2020/21       |              | 96           |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Feb              |
#    | NCS-C2021               | 10017316 | 10017316 Co Ltd             |               |                             | NCSC-3163                | NCS-3163       | ESFA-316                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 3                 | 2021            | 2020/21       |              | 2899         |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | West Midlands and Staffordshire |        |                   | 2305310                  | 2305310           | Mar              |


    # Tidy up
    And   the override date is reset

	  