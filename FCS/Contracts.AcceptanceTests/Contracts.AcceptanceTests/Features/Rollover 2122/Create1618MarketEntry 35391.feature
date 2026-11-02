Feature: Create1618MarketEntry 35391

@AcceptanceTest @Withdrawn20230123
Scenario: A344 Create and approve an EDSK2122 contract. Bulk amend to add a new 8mth 16-18TRN-ME2122(CofG_HEI) alloc. Publish and approve. Check docs, financials and CM feed

    # 1. Create and approve an EDSK2122 contract v1 with 16TR, AECA and ALLC allocs. (Contract Type= CofG_HEI)
    # 2. Bulk amend contract to add an 8mth 16-18TRN-ME2122 alloc
    # 3. Publish and approve contract v2


    Given there are no allocations marked as Under Termination for UKPRN '10017344' 
    And   there are no terminated or closed allocations for UKPRN '10017344' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017344' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017344' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017344' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-344      |
    | AECA-344      |
    | ALLC-344      |
    | NSFC-344      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-344      |
    | AECA-344      |
    | ALLC-344      |
    | NSFC-344      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2122      |
    | AEBC-ASCL2122     |
    | AEBC-NSF2122      |
    | ALLBC2122         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-344       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017344'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017344' 
    And   there is no caseload advisor for UKPRN '10017344' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017344 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017344' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017344 Co Ltd' with UKPRN '10017344' and OrgId 'ORG0017344' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017344 | 117344 | 10017344 Co Ltd | 0              | Locked Restructure    | Yes           | AA017344      | ?             | 31 North House         | North Street           | Carshalton             | Surrey                 | ?                      | ?                      | SM5 2HW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017344 |





    # Part 1: Create and approve an EDSK2122 contract v1 with 16TR, AECA and ALLC allocs. (Contract Type= CofG_HEI)
    
    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-344'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-344'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                           | Period | CRMIntent    | OrgId      |
    | 10017344 | 10017344 Co Ltd      | ESFA-344             | EDSK-344       | 1                     | 01/08/2021        | 31/07/2022      | 105501.00     |                                       | Conditions of Funding (Grant) (HEI)    | 2122   | New          | ORG0017344 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017344 | EDSK-344       | 16TR-344      | 16-18TRN          | 16-18TRN2122            | AY                      | 01/08/2021          | 31/07/2022        | 42138.00        |                                         |            |                                                             | New          |             |
    | 10017344 | EDSK-344       | AECA-344      | AEBC-ASCL         | AEBC-ASCL2122           | AY                      | 01/08/2021          | 31/07/2022        | 41531.00        |                                         |            |                                                             | New          |             |
    | 10017344 | EDSK-344       | ALLC-344      | ALLBC             | ALLBC2122               | AY                      | 01/08/2021          | 31/07/2022        | 21832.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017344 | EDSK-344       | 16TR-344      | 1               | 0                     | 42138.00  | 29294.00  | 12844.00  | 6524.00  | 3440.00  | 2571.00  | 1480.00  | 3772.00  | 3312.00  | 4691.00  | 3504.00  | 2379.00  | 2808.00  | 4469.00  | 3188.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017344 | EDSK-344       | 16TR-344      | 2               | 1                     | 20246.00  | 16440.00  | 3806.00   | 2965.00  | 1739.00  | 1715.00  | 806.00   | 3533.00  | 1769.00  | 3360.00  | 553.00   | 1572.00  | 252.00   | 1493.00  | 489.00   | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017344 | EDSK-344       | 16TR-344      | 3               | 1                     | 21892.00  | 12854.00  | 9038.00   | 3559.00  | 1701.00  | 856.00   | 674.00   | 239.00   | 1543.00  | 1331.00  | 2951.00  | 807.00   | 2556.00  | 2976.00  | 2699.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 
    | 10017344 | EDSK-344       | AECA-344      | 1               | 0                     | 41531.00  | 26422.00  | 15109.00  | 6563.00  | 2684.00  | 2986.00  | 3064.00  | 3810.00  | 4522.00  | 1404.00  | 1389.00  | 2417.00  | 6736.00  | 1182.00  | 4774.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10017344 | EDSK-344       | AECA-344      | 2               | 1                     | 24495.00  | 15245.00  | 9250.00   | 3694.00  | 220.00   | 1273.00  | 2799.00  | 2903.00  | 3575.00  | 576.00   | 205.00   | 2300.00  | 3417.00  | 1050.00  | 2483.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017344 | EDSK-344       | AECA-344      | 5               | 1                     | 17036.00  | 11177.00  | 5859.00   | 2869.00  | 2464.00  | 1713.00  | 265.00   | 907.00   | 947.00   | 828.00   | 1184.00  | 117.00   | 3319.00  | 132.00   | 2291.00  | Community Learning                                              | New          |             | 
    | 10017344 | EDSK-344       | ALLC-344      | 1               | 0                     | 21832.00  | 15937.00  | 5895.00   | 3336.00  | 3281.00  | 727.00   | 988.00   | 1186.00  | 593.00   | 2372.00  | 3454.00  | 2925.00  | 1794.00  | 504.00   | 672.00   | Total Advanced Learner Loans Bursary Funding                    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-344'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-344' and ContractNumber 'EDSK-344' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-344' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017344 | EDSK-344           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017344 | ESFA-344           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract 'EDSK-344'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16TR-344        | 2201300          | Jul-22 | Reconciliation |
    | AECA-344        | 2371175          | Jul-22 | Reconciliation |
    | ALLC-344        | 2303975          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017344 | EDSK-344       | 1               | 16TR-344      | 1               | 0                     | 42138.00     | 0             | 0        | Total 16-18 Traineeships Funding                                | ?                                                           |
    | 10017344 | EDSK-344       | 1               | 16TR-344      | 2               | 1                     | 20246.00     | 0             | 0        | 16-18 Traineeships Programme Funding                            | ?                                                           |
    | 10017344 | EDSK-344       | 1               | 16TR-344      | 3               | 1                     | 21892.00     | 0             | 0        | 16-18 Traineeships Bursary Funding                              | ?                                                           |
    | 10017344 | EDSK-344       | 1               | AECA-344      | 1               | 0                     | 41531.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10017344 | EDSK-344       | 1               | AECA-344      | 2               | 1                     | 24495.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10017344 | EDSK-344       | 1               | AECA-344      | 5               | 1                     | 17036.00     | 0             | 0        | Community Learning                                              | ?                                                           |
    | 10017344 | EDSK-344       | 1               | ALLC-344      | 1               | 0                     | 21832.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-344' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 2: Bulk amend contract to add an 8 month 16-18TRN-ME2122 allocation

    Given the override date is '11/11/2021'

    # Bulk file
    And   there are no files prefixed '10017344' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 28102021174911 v3_A344' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 28102021174911 v3_A344' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 28102021174911 v3_A344' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 28102021174911 v3_A344' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 28102021174911 v3_A344.xlsx' exists in the Datafiles folder and UKPRN '10017344' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017344' for FundingType 'EDSK' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017344' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices (SoF, Sch1, Sch2, FA)
   #Then  the file named '10017344_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    Then  the file named '10017344_EDSK-344_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017344 Co Ltd UKPRN: 10017344
    Master Contract Number: ESFA-344
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Bursary ALLC-344 £15,937 £5,895 £21,832
    ESFA AEB - Adult Skills and Community Learning AECA-344 £26,422 £15,109 £41,531
    of which Community Learning £11,177 £5,859 £17,036
    16 to 18 Traineeships 16TR-344 £29,294 £12,844 £42,138
    16 to 18 Traineeships [AllocRef_16TM] £36,079 £32,958 £69,037
    Total Funding for this contract: £174,538
    Summary of Funding – Page 1
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY) SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (October 2021) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (October 2021) – Page 6
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY)
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (Market Entry) (October 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017344 Co Ltd UKPRN: 10017344
    Master Contract Number: ESFA-344 Start Date: 01/12/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16TM]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16 to 18 Traineeships Programme Funding £44,782 £5,539 £3,788 £6,930 £5,454 £4,043 £6,166 £7,747 £5,115
    16 to 18 Traineeships Bursary Funding £24,255 £5,062 £3,109 £1,018 £5,179 £646 £2,567 £4,754 £1,920
    Total Funding £69,037 £10,601 £6,897 £7,948 £10,633 £4,689 £8,733 £12,501 £7,035
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TM] – Page 1 Ref (for internal use only):  EDSK-344 v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017344_EDSK-344_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A344.pdf'


    # Contract status is now at 'Awaiting Documentation'





    # Part 3: Publish and approve contract v2

    # Change the date 
    Given the override date is '12/11/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-344'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-344' and ContractNumber 'EDSK-344' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-344' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017344 | EDSK-344           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017344 | EDSK-344           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017344 | ESFA-344           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (16TR=3x12, AECA=5x12, ALLC=4x12, 16TM=3x8)
    And   there are '168' deliverable period rows in CRM linked to the latest version of contract 'EDSK-344'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_16TM] | 2201300          | Jul-22 | Reconciliation |

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-344       | [AllocRef_16TM]    | 1               | 69037.00  | 10601.00 | 6897.00  | 7948.00  | 10633.00 | 4689.00  | 8733.00  | 12501.00 | 7035.00  | 
    | EDSK-344       | [AllocRef_16TM]    | 2               | 44782.00  | 5539.00  | 3788.00  | 6930.00  | 5454.00  | 4043.00  | 6166.00  | 7747.00  | 5115.00  | 
    | EDSK-344       | [AllocRef_16TM]    | 3               | 24255.00  | 5062.00  | 3109.00  | 1018.00  | 5179.00  | 646.00   | 2567.00  | 4754.00  | 1920.00  | 


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A345 Create and approve an EDSK2122 contract inc 16-18TRN-ME2122 alloc (CofG_HEI). Check CDA. NFA and approve. Consume actuals. Payment batch. Check financials and feed

    # 1. Create and approve EDSK2122 contract v1 with AEBC-19TRN2122, AEBC-ASCL2122 and 16-18TRN-ME2122 allocs
    # 2. NFA > contract v2
    # 3. Publish and approve contract v2
    # 4. Check CDA report for 16-18TRN-ME2122
    # 5. Consume actuals for 16-18TRN-ME2122
    # 6. Run payment batch for 16-18TRN-ME2122 and check financials and feed

    Given there are no allocations marked as Under Termination for UKPRN '10017345' 
    And   there are no terminated or closed allocations for UKPRN '10017345' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017345' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017345' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017345' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-345      |
    | AECT-345      |
    | 16TM-345      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-345      |
    | AECT-345      |
    | 16TM-345      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN2122    |
    | AEBC-ASCL2122     |
    | 16-18TRN-ME2122   |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-345       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017345'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017345' 
    And   there is no caseload advisor for UKPRN '10017345' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017345 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017345' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017345 Co Ltd' with UKPRN '10017345' and OrgId 'ORG0017345' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017345 | 117345 | 10017345 Co Ltd | 0              | Locked Restructure    | Yes           | AA017345      | ?             | 43 Hill Avenue         | ?                      | ?                      | ?                      | Amersham               | Buckinghamshire        | HP6 5BX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017345 |





    # Part 1: Create and approve EDSK2122 contract v1 with AEBC-19TRN2122, AEBC-ASCL2122 and 16-18TRN-ME2122 allocs

    # Change the date
    Given the override date is '08/11/2021'
    
    # Change the date
    Given the override date is '08/11/2021'
    
    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017345 | 10017345 Co Ltd      | ESFA-345             | EDSK-345       | 1                     | 01/12/2021        | 31/07/2022      | 73892.00      |                                       | Conditions of Funding (Grant) (HEI)        | 2122   | New          | ORG0017345 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017345 | EDSK-345       | 16TM-345      | 16-18TRN-ME       | 16-18TRN-ME2122         | AY                      | 01/12/2021          | 31/07/2022        | 24460.00        |                                         |            |                                                             | New          |             |
    | 10017345 | EDSK-345       | AECA-345      | AEBC-ASCL         | AEBC-ASCL2122           | AY                      | 01/12/2021          | 31/07/2022        | 31548.00        |                                         |            |                                                             | New          |             |
    | 10017345 | EDSK-345       | AECT-345      | AEBC-19TRN        | AEBC-19TRN2122          | AY                      | 01/12/2021          | 31/07/2022        | 17884.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017345 | EDSK-345       | 16TM-345      | 1               | 0                     | 24460.00  | 4350.00  | 4113.00  | 1124.00  | 2690.00  | 1692.00  | 3703.00  | 3337.00  | 3451.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017345 | EDSK-345       | 16TM-345      | 2               | 1                     | 14271.00  | 2761.00  | 3369.00  | 562.00   | 2563.00  | 261.00   | 2484.00  | 498.00   | 1773.00  | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017345 | EDSK-345       | 16TM-345      | 3               | 1                     | 10189.00  | 1589.00  | 744.00   | 562.00   | 127.00   | 1431.00  | 1219.00  | 2839.00  | 1678.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 
    | 10017345 | EDSK-345       | AECA-345      | 1               | 0                     | 31548.00  | 3848.00  | 2252.00  | 4323.00  | 3547.00  | 2173.00  | 4560.00  | 6537.00  | 4308.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10017345 | EDSK-345       | AECA-345      | 2               | 1                     | 18451.00  | 3377.00  | 96.00    | 3521.00  | 650.00   | 1860.00  | 1930.00  | 3457.00  | 3560.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017345 | EDSK-345       | AECA-345      | 5               | 1                     | 13097.00  | 471.00   | 2156.00  | 802.00   | 2897.00  | 313.00   | 2630.00  | 3080.00  | 748.00   | Community Learning                                              | New          |             | 
    | 10017345 | EDSK-345       | AECT-345      | 1               | 0                     | 17884.00  | 1485.00  | 734.00   | 2987.00  | 2646.00  | 2686.00  | 2567.00  | 2923.00  | 1856.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-345'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-345' and ContractNumber 'EDSK-345' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-345' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017345 | EDSK-345           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/12/2021        | 31/07/2022      | ?             |
    | 10017345 | ESFA-345           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/12/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-345' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables 8mths*(3+5+3)=88
   #And   there are '88' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '88' deliverable period rows in CRM linked to the latest version of contract 'EDSK-345'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-345        | 2355775          | Jul-22 | Reconciliation |
    | AECA-345        | 2371175          | Jul-22 | Reconciliation |
    | 16TM-345        | 2201300          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017345 | EDSK-345       | 1               | 16TM-345      | 1               | 0                     | 24460.00     | 0             | 0        | Total 16-18 Traineeships Funding                                | ?                                                           |
    | 10017345 | EDSK-345       | 1               | 16TM-345      | 2               | 1                     | 14271.00     | 0             | 0        | 16-18 Traineeships Programme Funding                            | ?                                                           |
    | 10017345 | EDSK-345       | 1               | 16TM-345      | 3               | 1                     | 10189.00     | 0             | 0        | 16-18 Traineeships Bursary Funding                              | ?                                                           |
    | 10017345 | EDSK-345       | 1               | AECA-345      | 1               | 0                     | 31548.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10017345 | EDSK-345       | 1               | AECA-345      | 2               | 1                     | 18451.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10017345 | EDSK-345       | 1               | AECA-345      | 5               | 1                     | 13097.00     | 0             | 0        | Community Learning                                              | ?                                                           |
    | 10017345 | EDSK-345       | 1               | AECT-345      | 1               | 0                     | 17884.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-345' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 2: NFA > contract v2

    # Change the date
    Given the override date is '01/12/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-345' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017345 | EDSK-345           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/12/2021        | 31/07/2022      | Variation     |
    | 10017345 | EDSK-345           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/12/2021        | 31/07/2022      | ?             |
    | 10017345 | ESFA-345           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/12/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM: 8mths*(3+1+3)=56
   #And   there are '56' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '56' deliverable period rows in CRM linked to the latest version of contract 'EDSK-345'





    # Part 3: Publish and approve contract v2

    # Change the date
    Given the override date is '02/12/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-345'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-345' and ContractNumber 'EDSK-345' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-345' has a substatus of 'Approved'
    
    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017345 | EDSK-345           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/12/2021        | 31/07/2022      | Variation     |
    | 10017345 | EDSK-345           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/12/2021        | 31/07/2022      | ?             |
    | 10017345 | ESFA-345           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/12/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables 8mths*(3+5+3)=88
   #And   there are '88' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '88' deliverable period rows in CRM linked to the latest version of contract 'EDSK-345'





#    # Part 4: Check CDA report for 16-18TRN-ME2122
#    
#    # Change the date
#    Given the override date is '23/12/2021'
#
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version A345.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | EDSK-345       | 2                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | 16-18TRN-ME2122       | Latest Version        | A345   |
#
#    Then  a report named 'CDA Latest Version A345.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | Total 16-18 Traineeships Funding                                | 12                | 2021            | 2021/22       |              | 1589         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Dec              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | Total 16-18 Traineeships Funding                                | 1                 | 2022            | 2021/22       |              | 744          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Jan              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | Total 16-18 Traineeships Funding                                | 2                 | 2022            | 2021/22       |              | 562          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Feb              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | Total 16-18 Traineeships Funding                                | 3                 | 2022            | 2021/22       |              | 127          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Mar              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | Total 16-18 Traineeships Funding                                | 4                 | 2022            | 2022/23       |              | 1431         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Apr              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | Total 16-18 Traineeships Funding                                | 5                 | 2022            | 2022/23       |              | 1219         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | May              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | Total 16-18 Traineeships Funding                                | 6                 | 2022            | 2022/23       |              | 2839         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Jun              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | Total 16-18 Traineeships Funding                                | 7                 | 2022            | 2022/23       |              | 1678         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Jul              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | Total 16-18 Traineeships Funding                                | 12                | 2021            | 2021/22       |              | 2761         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Dec              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | Total 16-18 Traineeships Funding                                | 1                 | 2022            | 2021/22       |              | 3369         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Jan              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | Total 16-18 Traineeships Funding                                | 2                 | 2022            | 2021/22       |              | 562          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Feb              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | Total 16-18 Traineeships Funding                                | 3                 | 2022            | 2021/22       |              | 2563         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Mar              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | Total 16-18 Traineeships Funding                                | 4                 | 2022            | 2022/23       |              | 261          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Apr              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | Total 16-18 Traineeships Funding                                | 5                 | 2022            | 2022/23       |              | 2484         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | May              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | Total 16-18 Traineeships Funding                                | 6                 | 2022            | 2022/23       |              | 498          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Jun              |
#    | 16-18TRN-ME2122         | 10017345 | 10017345 Co Ltd             |               |                             | 16TM-345                 | EDSK-345       | ESFA-345                | 01/12/2021                  | 31/07/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | Total 16-18 Traineeships Funding                                | 7                 | 2022            | 2022/23       |              | 1773         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Jul              |





    # Part 5: Consume actuals for 16-18TRN-ME2122

    # Add actuals to the contract 

    # Change the date
    Given the override date is '04/01/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017345'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Dec 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202112 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 2               | 0            | 2993.19     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202112 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 3               | 0            | 2727.69     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202201 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 2               | 0            | 4661.59     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202201 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 3               | 0            | 1841.47     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202202 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 2               | 0            | 1975.86     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202202 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 3               | 0            | 1594.23     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202203 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 2               | 0            | 1643.22     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202203 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 3               | 0            | 4577.74     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202204 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 2               | 0            | 3648.57     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202204 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 3               | 0            | 4056.73     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202205 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 2               | 0            | 2338.99     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202205 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 3               | 0            | 2165.75     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202206 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 2               | 0            | 2783.54     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202206 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 3               | 0            | 2079.66     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202207 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 2               | 0            | 3011.60     |
    | ILR2122        | R05                  | ORG0017345     | CM             | 202207 | 16-18TRN-ME2122         | 16TM-345                 | ?          | 3               | 0            | 3548.62     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-345       | 16TM-345           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-345       | 16TM-345           | 2               | 2993.19   | 2993.19  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-345       | 16TM-345           | 3               | 2727.69   | 2727.69  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-345       | 16TM-345           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-345       | 16TM-345           | 2               | 2993.19   | 2993.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-345       | 16TM-345           | 3               | 2727.69   | 2727.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-345       | 16TM-345           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-345       | 16TM-345           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-345       | 16TM-345           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-345       | 16TM-345           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-345       | 16TM-345           | 2               | 2993.19   | 2993.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-345       | 16TM-345           | 3               | 2727.69   | 2727.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 





    # Part 6: Run payment batch for 16-18TRN-ME2122 and check financials and feed

    # Change the date
    Given the override date is '11/01/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '16-18TRN-ME2122' AccountingPaymentPeriod '202109' CensusEndDate '11/01/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | 16TM-345                 | 202112 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18TRN-ME2122            | 202112               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18TRN-ME2122            | 202112               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18TRN-ME2122' PaymentPeriod '202109' CensusEndDate '11/01/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A345.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18TRN-ME2122' PaymentPeriod '202109' CensusEndDate '11/01/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 16TM                   | 2021          | 09             | 11          | ?       | 16TM-345      | 2993.19         | RECONCILIATION   | 16-18Traineeships                  | 2022-01-21 | 2021-08-01   | 2022-07-31 | ?              | 10017345 | 2201300    |
    | 16TM                   | 2021          | 09             | 11          | ?       | 16TM-345      | 2727.69         | RECONCILIATION   | 16-18TraineeshipBurs               | 2022-01-21 | 2021-08-01   | 2022-07-31 | ?              | 10017345 | 2201350    |


    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod '16-18TRN-ME2122' AccountingPaymentPeriod '202109' and CensusEndDate '11/01/2022'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                     |
    | Payment Requests for Funding Stream Period 16-18TRN-ME2122 for Payment Period 202109 have been generated as of Census End Date/Time 2022-01-11T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | 16-18TRN-ME2122     | 202109        | 2022-01-11T22:00:00Z  | 2                | 5720.88    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | 16TM      | 01/08/2021   | 31/07/2022 | 11/01/2022    | 21/01/2022 | 2021          | 09             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription   | AggregatedValue |
    | ORG0017345  | 10017345       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 16TM-345   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2201300    | RECONCILIATION | 16-18Traineeships       | 2993.19         |
    | ORG0017345  | 10017345       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 16TM-345   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2201350    | RECONCILIATION | 16-18TraineeshipBurs    | 2727.69         |


    # Tidy up
    Given the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A346 Bulk create a 21/22 EDSK contract with just an 8mth 16-18TRN-ME2122 allocation(CFS_ITP). Publish and approve

    Given there are no allocations marked as Under Termination for UKPRN '10017346' 
    And   there are no terminated or closed allocations for UKPRN '10017346' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017346' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017346' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017346' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN-ME2122   |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017346'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017346' 
    And   there is no caseload advisor for UKPRN '10017346' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017346 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017346' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017346 Co Ltd' with UKPRN '10017346' and OrgId 'ORG0017346' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017346 | 117346 | 10017346 Co Ltd | 0              | Active                | Yes           | AA017346      | ?             | 10 Wilshire House      | Woolmead               | Farnham                | ?                      | ?                      | Surrey                 | GU9 7TT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017346 |





    # Change the date
    Given the override date is '15/11/2021'

    # Bulk new file
    And   there are no files prefixed '10017346' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 29102021142102 v3_A346' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 29102021142102 v3_A346' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 29102021142102 v3_A346' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 29102021142102 v3_A346' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 29102021142102 v3_A346.xlsx' exists in the Datafiles folder and UKPRN '10017346' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017346' for FundingType 'EDSK' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017346' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices (Six doc parts = SoF, T&C, Sch1, Sch2, FA, Sch3On)
    Then  the file named '10017346_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017346 Co Ltd UKPRN: 10017346
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 18 Traineeships [AllocRef_16TM] £41,227 £38,105 £79,332
    Total Funding for this contract: £79,332
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017346 Co Ltd
    Funding for 16 to 18 Traineeships
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017346 Co Ltd THE SECRETARY OF STATE FOR
    10 Wilshire House EDUCATION
    Woolmead DEPARTMENT FOR EDUCATION
    Farnham 20 GREAT SMITH STREET
    AND
    Surrey LONDON
    GU9 7TT SW1P 3BT
    Company No: AA017346
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY) SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (October 2021) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (October 2021) – Page 6
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY)
    EDSK Schedule 2 – 16 to 18 Traineeships (Market Entry) Version 1 (October 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017346 Co Ltd UKPRN: 10017346
    Master Contract Number: [MasterContractNo] Start Date: 01/12/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16TM]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16 to 18 Traineeships Programme Funding £41,980 £7,177 £5,425 £617 £7,092 £5,680 £7,803 £1,434 £6,752
    16 to 18 Traineeships Bursary Funding £37,352 £6,699 £4,746 £2,655 £6,816 £2,283 £4,204 £6,392 £3,557
    Total Funding £79,332 £13,876 £10,171 £3,272 £13,908 £7,963 £12,007 £7,826 £10,309
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TM] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017346_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A346.pdf'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017346 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/12/2021        | 31/07/2022      | ?             |
    | 10017346 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/12/2021        | 31/07/2022      | ?             |
    
    
    # Tidy Up
    Given the override date is reset

