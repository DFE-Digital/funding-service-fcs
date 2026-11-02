Feature: CreateTLevels 37273

@AcceptanceTest @Withdrawn25072024
Scenario: A784 Create and approve a 22/23 EDSK contract with 2 FSP groups. Bulk amend to add T-Levels allocation. Approve. Check docs, CRM, financials and feed.
    Given there are no allocations marked as Under Termination for UKPRN '10017784' 
    And   there are no terminated or closed allocations for UKPRN '10017784' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017784' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017784'
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017784' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-784      |
    | AECA-784      |
    | NSFC-784      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-784      |
    | AECA-784      |
    | NSFC-784      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2223      |
    | AEBC-NSF2223      |
    | AEBC-ASCL2223     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-784       | 1                     | 0                        |
    | EDSK-784       | 2                     | 0                        |


    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                              | UploadTimestamp         | 
    | SOF_EDSK_2022-08-01.docx                          | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_TAC_CFS_ITP_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_LA_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_NMSS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_SPI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S1_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_HEI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_ITP_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_LA_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_APPS_COLLEGE_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_APPS_OTHER_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_ATLP_COFG_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S2_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_CFS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_COFG_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_APPS_COLLEGE_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_APPS_OTHER_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_ATLP_COFG_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | FA_EDSK2223_2022-08-01.docx                       | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx       | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx   | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017784' 
    And   there is no caseload advisor for UKPRN '10017784' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017784 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017784' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017784 Co Ltd' with UKPRN '10017784' and OrgId 'ORG0017784' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017784 | 117784 | 10017784 Co Ltd | 0              | Active                | Yes           | AA017784      | ?             | Cabot House            | Quadrant Gardens       | Bold Street            | Thingwall              | Watford                | Hertfordshire          | WD1 2DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017784 |





    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-784'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-784'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017784 | 10017784 Co Ltd      | ESFA-784             | EDSK-784       | 1                     | 01/08/2022        | 31/07/2023      | 115944.00     |                                       | Conditions of Funding (Grant) (College)    | 2223   | New          | ORG0017784 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017784 | EDSK-784       | 16TR-784      | 16-18TRN          | 16-18TRN2223            | AY                      | 01/08/2022          | 31/07/2023        | 46435.00        |                                         |            |                                                             | New          |             |
    | 10017784 | EDSK-784       | AECA-784      | AEBC-ASCL         | AEBC-ASCL2223           | AY                      | 01/08/2022          | 31/07/2023        | 47346.00        |                                         |            |                                                             | New          |             |
    | 10017784 | EDSK-784       | NSFC-784      | AEBC-NSF          | AEBC-NSF2223            | AY                      | 01/08/2022          | 31/07/2023        | 22163.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10017784 | EDSK-784       | 16TR-784      | 1               | 0                     | 46435.00  | 30145.00  | 16290.00  | 5354.00  | 6381.00  | 3298.00  | 2428.00  | 1336.00  | 3630.00  | 3170.00  | 4548.00  | 3362.00  | 2236.00  | 6366.00  | 4326.00  | Total 16-18 Traineeships Funding                                                | New          |             | 
    | 10017784 | EDSK-784       | 16TR-784      | 2               | 1                     | 22787.00  | 16183.00  | 6604.00   | 1987.00  | 2723.00  | 1498.00  | 1473.00  | 564.00   | 3292.00  | 1528.00  | 3118.00  | 312.00   | 1330.00  | 3711.00  | 1251.00  | 16-18 Traineeships Programme Funding                                            | New          |             | 
    | 10017784 | EDSK-784       | 16TR-784      | 3               | 1                     | 23648.00  | 13962.00  | 9686.00   | 3367.00  | 3658.00  | 1800.00  | 955.00   | 772.00   | 338.00   | 1642.00  | 1430.00  | 3050.00  | 906.00   | 2655.00  | 3075.00  | 16-18 Traineeships Bursary Funding                                              | New          |             | 
    #
    | 10017784 | EDSK-784       | AECA-784      | 1               | 0                     | 47346.00  | 36014.00  | 11332.00  | 4266.00  | 6464.00  | 6288.00  | 2887.00  | 2967.00  | 3712.00  | 4423.00  | 5007.00  | 4993.00  | 2319.00  | 2936.00  | 1084.00  | Adult Skills and Community Learning Total Funding                               | New          |             | 
    | 10017784 | EDSK-784       | AECA-784      | 2               | 1                     | 28472.00  | 20300.00  | 8172.00   | 2238.00  | 3068.00  | 3296.00  | 647.00   | 2174.00  | 2277.00  | 2949.00  | 3651.00  | 3281.00  | 1675.00  | 2791.00  | 425.00   | Adult Skills Total Funding                                                      | New          |             | 
    | 10017784 | EDSK-784       | AECA-784      | 5               | 1                     | 18874.00  | 15714.00  | 3160.00   | 2028.00  | 3396.00  | 2992.00  | 2240.00  | 793.00   | 1435.00  | 1474.00  | 1356.00  | 1712.00  | 644.00   | 145.00   | 659.00   | Community Learning                                                              | New          |             | 
    #
    | 10017784 | EDSK-784       | NSFC-784      | 1               | 0                     | 22163.00  | 13955.00  | 8208.00   | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | Total 16-18 Traineeships Funding                                                | New          |             | 
    | 10017784 | EDSK-784       | NSFC-784      | 2               | 1                     | 22163.00  | 13955.00  | 8208.00   | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | Level 3 Free Courses for Jobs                                                   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-784       | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-784'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-784' and ContractNumber 'EDSK-784' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-784' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017784 | EDSK-784           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017784 | ESFA-784           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-784' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'EDSK-784'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16TR-784        | 2201300          | Jul-23 | Reconciliation |
    | NSFC-784        | 100946           | Jul-23 | Reconciliation |
    | AECA-784        | 2371175          | Jul-23 | Reconciliation |





    # Add T-Levels allocation to contract 

    # Change the date
    Given the override date is '16/08/2022'

    # Bulk file
    And   there are no files prefixed '10017784' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 28072022140103 v3_A784' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 28072022140103 v3_A784' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 28072022140103 v3_A784' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 28072022140103 v3_A784' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 28072022140103 v3_A784.xlsx' exists in the Datafiles folder and UKPRN '10017784' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017784' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices (SoF, Sch1, Sch2, FA)
    Then  the file named '10017784_EDSK-784_v2.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017784 Co Ltd UKPRN: 10017784
    Master Contract Number: ESFA-784
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    ESFA AEB - Adult Skills and Community Learning AECA-784 £36,014 £11,332 £47,346
    of which Community Learning £15,714 £3,160 £18,874
    ESFA AEB - National Skills Fund NSFC-784 £13,955 £8,208 £22,163
    of which Level 3 Free Courses for Jobs £13,955 £8,208 £22,163
    16 to 18 Traineeships 16TR-784 £30,145 £16,290 £46,435
    T-Levels for Adults Pilot [AllocRef_ATLP] £40,836 £23,189 £64,025
    Total Funding for this contract: £179,969
    Summary of Funding – Page 1
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    Adult T Level Pilot
    EDSK Schedule 1 – Adult T Level Pilot Version 1 College (August 2022) – Page 1
    EDSK Schedule 1 – Adult T Level Pilot Version 1 College (August 2022) – Page 6
    
    SCHEDULE 2: PAYMENT
    Adult T Level Pilot
    EDSK Schedule 2 – Adult T Level Pilot Version 1 (August 2022) – Page 1

    SCHEDULE 2 – T-LEVELS FOR ADULTS PILOT
    Funding Agreement – T-Levels for Adults Pilot
    Provider: 10017784 Co Ltd UKPRN: 10017784
    Master Contract Number: ESFA-784 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ATLP]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    T-Levels for Adults Pilot £64,025 £4,997 £6,177 £6,538 £1,729 £6,092 £6,792 £5,965 £2,546 £5,753 £7,811 £5,858 £3,767
    Total Funding £64,025 £4,997 £6,177 £6,538 £1,729 £6,092 £6,792 £5,965 £2,546 £5,753 £7,811 £5,858 £3,767
    Schedule 2 – T-Levels for Adults Pilot – Funding Agreement [AllocRef_ATLP] – Page 1 Ref (for internal use only):  EDSK-784 v2
    """

    # There should not be a TaC doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # There should not be a Sch3ON doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED 
    """
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017784_[ContractNo]_v2.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A784v2.pdf'





    # Publish and Approve contract v2

    # Change the date
    Given the override date is '18/08/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-784'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-784' and ContractNumber 'EDSK-784' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-784' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017784 | EDSK-784           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017784 | EDSK-784           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017784 | ESFA-784           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'EDSK-784' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '156' deliverable period rows in CRM linked to the latest version of contract 'EDSK-784'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ATLP] | 100697           | Jul-23 | Reconciliation |





    # Check Financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-784       | [AllocRef_ATLP]    | 1               | 64025.00  | 4997.00  | 6177.00  | 6538.00  | 1729.00  | 6092.00  | 6792.00  | 5965.00  | 2546.00  | 5753.00  | 7811.00  | 5858.00  | 3767.00  | 
    #
    | EDSK-784       | 16TR-784           | 1               | 46435.00  | 5354.00  | 6381.00  | 3298.00  | 2428.00  | 1336.00  | 3630.00  | 3170.00  | 4548.00  | 3362.00  | 2236.00  | 6366.00  | 4326.00  | 
    | EDSK-784       | 16TR-784           | 2               | 22787.00  | 1987.00  | 2723.00  | 1498.00  | 1473.00  | 564.00   | 3292.00  | 1528.00  | 3118.00  | 312.00   | 1330.00  | 3711.00  | 1251.00  | 
    | EDSK-784       | 16TR-784           | 3               | 23648.00  | 3367.00  | 3658.00  | 1800.00  | 955.00   | 772.00   | 338.00   | 1642.00  | 1430.00  | 3050.00  | 906.00   | 2655.00  | 3075.00  | 
    #
    | EDSK-784       | AECA-784           | 1               | 47346.00  | 4266.00  | 6464.00  | 6288.00  | 2887.00  | 2967.00  | 3712.00  | 4423.00  | 5007.00  | 4993.00  | 2319.00  | 2936.00  | 1084.00  | 
    | EDSK-784       | AECA-784           | 2               | 28472.00  | 2238.00  | 3068.00  | 3296.00  | 647.00   | 2174.00  | 2277.00  | 2949.00  | 3651.00  | 3281.00  | 1675.00  | 2791.00  | 425.00   | 
    | EDSK-784       | AECA-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 5               | 18874.00  | 2028.00  | 3396.00  | 2992.00  | 2240.00  | 793.00   | 1435.00  | 1474.00  | 1356.00  | 1712.00  | 644.00   | 145.00   | 659.00   | 
    #
    | EDSK-784       | NSFC-784           | 1               | 22163.00  | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | 
    | EDSK-784       | NSFC-784           | 2               | 22163.00  | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | 
    | EDSK-784       | NSFC-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | NSFC-784           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-784       | [AllocRef_ATLP]    | 1               | 4997.00   | ?        | 4997.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | EDSK-784       | 16TR-784           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | 16TR-784           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | 16TR-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-784       | AECA-784           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 2               | 0.00      | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-784       | AECA-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 5               | 0.00      | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | EDSK-784       | NSFC-784           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | NSFC-784           | 2               | 0.00      | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-784       | NSFC-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | NSFC-784           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-784       | [AllocRef_ATLP]    | 1               | 59028.00  | ?        | 6177.00  | 6538.00  | 1729.00  | 6092.00  | 6792.00  | 5965.00  | 2546.00  | 5753.00  | 7811.00  | 5858.00  | 3767.00  | 
    #
    | EDSK-784       | 16TR-784           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | 16TR-784           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | 16TR-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-784       | AECA-784           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 2               | 28472.00  | 2238.00  | 3068.00  | 3296.00  | 647.00   | 2174.00  | 2277.00  | 2949.00  | 3651.00  | 3281.00  | 1675.00  | 2791.00  | 425.00   | 
    | EDSK-784       | AECA-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 5               | 18874.00  | 2028.00  | 3396.00  | 2992.00  | 2240.00  | 793.00   | 1435.00  | 1474.00  | 1356.00  | 1712.00  | 644.00   | 145.00   | 659.00   | 
    #
    | EDSK-784       | NSFC-784           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | NSFC-784           | 2               | 22163.00  | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | 
    | EDSK-784       | NSFC-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | NSFC-784           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-784       | [AllocRef_ATLP]    | 1               | 64025.00  | 0.00     | 11174.00 | 6538.00  | 1729.00  | 6092.00  | 6792.00  | 5965.00  | 2546.00  | 5753.00  | 7811.00  | 5858.00  | 3767.00  | 
    #
    | EDSK-784       | 16TR-784           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | 16TR-784           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | 16TR-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-784       | AECA-784           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 2               | 28472.00  | 2238.00  | 3068.00  | 3296.00  | 647.00   | 2174.00  | 2277.00  | 2949.00  | 3651.00  | 3281.00  | 1675.00  | 2791.00  | 425.00   | 
    | EDSK-784       | AECA-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | AECA-784           | 5               | 18874.00  | 2028.00  | 3396.00  | 2992.00  | 2240.00  | 793.00   | 1435.00  | 1474.00  | 1356.00  | 1712.00  | 644.00   | 145.00   | 659.00   | 
    #
    | EDSK-784       | NSFC-784           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | NSFC-784           | 2               | 22163.00  | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | 
    | EDSK-784       | NSFC-784           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-784       | NSFC-784           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal  | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
    | 10017784 | EDSK-784       | [AllocRef_ATLP]    | 100697             | 0.00      | 11174.00  | 6538.00   | 1729.00   | 6092.00   | 6792.00   | 5965.00   | 2546.00   | 5753.00   | 7811.00   | 5858.00   | 3767.00   | 
    | 10017784 | EDSK-784       | AECA-784           | 2371110            | 2238.00   | 3068.00   | 3296.00   | 647.00    | 2174.00   | 2277.00   | 2949.00   | 3651.00   | 3281.00   | 1675.00   | 2791.00   | 425.00    | 
    | 10017784 | EDSK-784       | AECA-784           | 2371130            | 2028.00   | 3396.00   | 2992.00   | 2240.00   | 793.00    | 1435.00   | 1474.00   | 1356.00   | 1712.00   | 644.00    | 145.00    | 659.00    | 
    | 10017784 | EDSK-784       | NSFC-784           | 100945             | 3219.00   | 443.00    | 388.00    | 1534.00   | 1796.00   | 1994.00   | 1401.00   | 3180.00   | 561.00    | 3733.00   | 2602.00   | 1312.00   | 



    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName            | DeliverableDescription  | 
    | 10017784 | EDSK-784       | 2               | [AllocRef_ATLP]  | 1               | 0                     | 64025.00     | 0             | 0        | T-Levels for Adults Pilot  | ?                       |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'EDSK-784' agree with the most recent entry for this contract in the ContractManagement feed

    # Tidy Up
    Given the override date is reset

    
    @AcceptanceTest @Complete
Scenario: S785 Create and approve a 22/23 EDSK contract with 2 FSP groups. Bulk amend to add T-Levels allocation. Approve. Check docs, CRM, financials and feed.
    Given there are no allocations marked as Under Termination for UKPRN '10017785' 
    And   there are no terminated or closed allocations for UKPRN '10017785' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017785' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017785' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017785' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-785      |
    | AECA-785      |
    | NSFC-785      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-785      |
    | AECA-785      |
    | NSFC-785      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2223      |
    | AEBC-NSF2223      |
    | AEBC-ASCL2223     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-785       | 1                     | 0                        |
    | EDSK-785       | 2                     | 0                        |


    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                              | UploadTimestamp         | 
    | SOF_EDSK_2022-08-01.docx                          | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_TAC_CFS_ITP_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_LA_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_NMSS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_SPI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S1_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_HEI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_ITP_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_LA_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_APPS_COLLEGE_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_APPS_OTHER_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_ATLP_COFG_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S2_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_CFS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_COFG_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_APPS_COLLEGE_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_APPS_OTHER_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_ATLP_COFG_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | FA_EDSK2223_2022-08-01.docx                       | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx       | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx   | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017785' 
    And   there is no caseload advisor for UKPRN '10017785' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017785 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017785' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017785 Co Ltd' with UKPRN '10017785' and OrgId 'ORG0017785' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017785 | 117785 | 10017785 Co Ltd | 0              | Active                | Yes           | AA017785      | ?             | Cabot House            | Quadrant Gardens       | Bold Street            | Thingwall              | Watford                | Hertfordshire          | WD1 2DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017785 |





    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-785'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-785'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017785 | 10017785 Co Ltd      | ESFA-785             | EDSK-785       | 1                     | 01/08/2022        | 31/07/2023      | 115944.00     |                                       | Conditions of Funding (Grant) (Trust)    | 2223   | New          | ORG0017785 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017785 | EDSK-785       | 16TR-785      | 16-18TRN          | 16-18TRN2223            | AY                      | 01/08/2022          | 31/07/2023        | 46435.00        |                                         |            |                                                             | New          |             |
    | 10017785 | EDSK-785       | AECA-785      | AEBC-ASCL         | AEBC-ASCL2223           | AY                      | 01/08/2022          | 31/07/2023        | 47346.00        |                                         |            |                                                             | New          |             |
    | 10017785 | EDSK-785       | NSFC-785      | AEBC-NSF          | AEBC-NSF2223            | AY                      | 01/08/2022          | 31/07/2023        | 22163.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10017785 | EDSK-785       | 16TR-785      | 1               | 0                     | 46435.00  | 30145.00  | 16290.00  | 5354.00  | 6381.00  | 3298.00  | 2428.00  | 1336.00  | 3630.00  | 3170.00  | 4548.00  | 3362.00  | 2236.00  | 6366.00  | 4326.00  | Total 16-18 Traineeships Funding                                                | New          |             | 
    | 10017785 | EDSK-785       | 16TR-785      | 2               | 1                     | 22787.00  | 16183.00  | 6604.00   | 1987.00  | 2723.00  | 1498.00  | 1473.00  | 564.00   | 3292.00  | 1528.00  | 3118.00  | 312.00   | 1330.00  | 3711.00  | 1251.00  | 16-18 Traineeships Programme Funding                                            | New          |             | 
    | 10017785 | EDSK-785       | 16TR-785      | 3               | 1                     | 23648.00  | 13962.00  | 9686.00   | 3367.00  | 3658.00  | 1800.00  | 955.00   | 772.00   | 338.00   | 1642.00  | 1430.00  | 3050.00  | 906.00   | 2655.00  | 3075.00  | 16-18 Traineeships Bursary Funding                                              | New          |             | 
    #
    | 10017785 | EDSK-785       | AECA-785      | 1               | 0                     | 47346.00  | 36014.00  | 11332.00  | 4266.00  | 6464.00  | 6288.00  | 2887.00  | 2967.00  | 3712.00  | 4423.00  | 5007.00  | 4993.00  | 2319.00  | 2936.00  | 1084.00  | Adult Skills and Community Learning Total Funding                               | New          |             | 
    | 10017785 | EDSK-785       | AECA-785      | 2               | 1                     | 28472.00  | 20300.00  | 8172.00   | 2238.00  | 3068.00  | 3296.00  | 647.00   | 2174.00  | 2277.00  | 2949.00  | 3651.00  | 3281.00  | 1675.00  | 2791.00  | 425.00   | Adult Skills Total Funding                                                      | New          |             | 
    | 10017785 | EDSK-785       | AECA-785      | 5               | 1                     | 18874.00  | 15714.00  | 3160.00   | 2028.00  | 3396.00  | 2992.00  | 2240.00  | 793.00   | 1435.00  | 1474.00  | 1356.00  | 1712.00  | 644.00   | 145.00   | 659.00   | Community Learning                                                              | New          |             | 
    #
    | 10017785 | EDSK-785       | NSFC-785      | 1               | 0                     | 22163.00  | 13955.00  | 8208.00   | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | Total 16-18 Traineeships Funding                                                | New          |             | 
    | 10017785 | EDSK-785       | NSFC-785      | 2               | 1                     | 22163.00  | 13955.00  | 8208.00   | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | Level 3 Free Courses for Jobs                                                   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-785       | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-785'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-785' and ContractNumber 'EDSK-785' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-785' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017785 | EDSK-785           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017785 | ESFA-785           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-785' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'EDSK-785'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16TR-785        | 2201300          | Jul-23 | Reconciliation |
    | NSFC-785        | 100946           | Jul-23 | Reconciliation |
    | AECA-785        | 2371175          | Jul-23 | Reconciliation |





    # Add T-Levels allocation to contract 

    # Change the date
    Given the override date is '16/08/2022'

    # Bulk file
    And   there are no files prefixed '10017785' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 28072022140103 v3_A785' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 28072022140103 v3_A785' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 28072022140103 v3_A785' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 28072022140103 v3_A785' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 19082022140103 v3_S785.xlsx' exists in the Datafiles folder and UKPRN '10017785' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017785' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices (SoF, Sch1, Sch2, FA)
    Then  the file named '10017785_EDSK-785_v2.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017785 Co Ltd UKPRN: 10017785
    Master Contract Number: ESFA-785
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    ESFA AEB - Adult Skills and Community Learning AECA-785 £36,014 £11,332 £47,346
    of which Community Learning £15,714 £3,160 £18,874
    ESFA AEB - National Skills Fund NSFC-785 £13,955 £8,208 £22,163
    of which Level 3 Free Courses for Jobs £13,955 £8,208 £22,163
    16 to 18 Traineeships 16TR-785 £30,145 £16,290 £46,435
    T-Levels for Adults Pilot [AllocRef_ATLP] £40,836 £23,189 £64,025
    Total Funding for this contract: £179,969
    Summary of Funding – Page 1
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    Adult T Level Pilot
    EDSK Schedule 1 – Adult T Level Pilot Version 1 Trust (August 2022) – Page 1
    EDSK Schedule 1 – Adult T Level Pilot Version 1 Trust (August 2022) – Page 6
    
    SCHEDULE 2: PAYMENT
    Adult T Level Pilot
    EDSK Schedule 2 – Adult T Level Pilot Version 1 (August 2022) – Page 1

    SCHEDULE 2 – T-LEVELS FOR ADULTS PILOT
    Funding Agreement – T-Levels for Adults Pilot
    Provider: 10017785 Co Ltd UKPRN: 10017785
    Master Contract Number: ESFA-785 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ATLP]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    T-Levels for Adults Pilot £64,025 £4,997 £6,177 £6,538 £1,729 £6,092 £6,792 £5,965 £2,546 £5,753 £7,811 £5,858 £3,767
    Total Funding £64,025 £4,997 £6,177 £6,538 £1,729 £6,092 £6,792 £5,965 £2,546 £5,753 £7,811 £5,858 £3,767
    Schedule 2 – T-Levels for Adults Pilot – Funding Agreement [AllocRef_ATLP] – Page 1 Ref (for internal use only):  EDSK-785 v2
    """

    # There should not be a TaC doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # There should not be a Sch3ON doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED 
    """
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017785_[ContractNo]_v2.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A785v2.pdf'





    # Publish and Approve contract v2

    # Change the date
    Given the override date is '18/08/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-785'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-785' and ContractNumber 'EDSK-785' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-785' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017785 | EDSK-785           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017785 | EDSK-785           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017785 | ESFA-785           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'EDSK-785' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '156' deliverable period rows in CRM linked to the latest version of contract 'EDSK-785'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ATLP] | 100697           | Jul-23 | Reconciliation |





    # Check Financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-785       | [AllocRef_ATLP]    | 1               | 64025.00  | 4997.00  | 6177.00  | 6538.00  | 1729.00  | 6092.00  | 6792.00  | 5965.00  | 2546.00  | 5753.00  | 7811.00  | 5858.00  | 3767.00  | 
    #
    | EDSK-785       | 16TR-785           | 1               | 46435.00  | 5354.00  | 6381.00  | 3298.00  | 2428.00  | 1336.00  | 3630.00  | 3170.00  | 4548.00  | 3362.00  | 2236.00  | 6366.00  | 4326.00  | 
    | EDSK-785       | 16TR-785           | 2               | 22787.00  | 1987.00  | 2723.00  | 1498.00  | 1473.00  | 564.00   | 3292.00  | 1528.00  | 3118.00  | 312.00   | 1330.00  | 3711.00  | 1251.00  | 
    | EDSK-785       | 16TR-785           | 3               | 23648.00  | 3367.00  | 3658.00  | 1800.00  | 955.00   | 772.00   | 338.00   | 1642.00  | 1430.00  | 3050.00  | 906.00   | 2655.00  | 3075.00  | 
    #
    | EDSK-785       | AECA-785           | 1               | 47346.00  | 4266.00  | 6464.00  | 6288.00  | 2887.00  | 2967.00  | 3712.00  | 4423.00  | 5007.00  | 4993.00  | 2319.00  | 2936.00  | 1084.00  | 
    | EDSK-785       | AECA-785           | 2               | 28472.00  | 2238.00  | 3068.00  | 3296.00  | 647.00   | 2174.00  | 2277.00  | 2949.00  | 3651.00  | 3281.00  | 1675.00  | 2791.00  | 425.00   | 
    | EDSK-785       | AECA-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 5               | 18874.00  | 2028.00  | 3396.00  | 2992.00  | 2240.00  | 793.00   | 1435.00  | 1474.00  | 1356.00  | 1712.00  | 644.00   | 145.00   | 659.00   | 
    #
    | EDSK-785       | NSFC-785           | 1               | 22163.00  | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | 
    | EDSK-785       | NSFC-785           | 2               | 22163.00  | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | 
    | EDSK-785       | NSFC-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | NSFC-785           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-785       | [AllocRef_ATLP]    | 1               | 4997.00   | ?        | 4997.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | EDSK-785       | 16TR-785           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | 16TR-785           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | 16TR-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-785       | AECA-785           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 2               | 0.00      | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-785       | AECA-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 5               | 0.00      | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | EDSK-785       | NSFC-785           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | NSFC-785           | 2               | 0.00      | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-785       | NSFC-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | NSFC-785           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-785       | [AllocRef_ATLP]    | 1               | 59028.00  | ?        | 6177.00  | 6538.00  | 1729.00  | 6092.00  | 6792.00  | 5965.00  | 2546.00  | 5753.00  | 7811.00  | 5858.00  | 3767.00  | 
    #
    | EDSK-785       | 16TR-785           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | 16TR-785           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | 16TR-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-785       | AECA-785           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 2               | 28472.00  | 2238.00  | 3068.00  | 3296.00  | 647.00   | 2174.00  | 2277.00  | 2949.00  | 3651.00  | 3281.00  | 1675.00  | 2791.00  | 425.00   | 
    | EDSK-785       | AECA-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 5               | 18874.00  | 2028.00  | 3396.00  | 2992.00  | 2240.00  | 793.00   | 1435.00  | 1474.00  | 1356.00  | 1712.00  | 644.00   | 145.00   | 659.00   | 
    #
    | EDSK-785       | NSFC-785           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | NSFC-785           | 2               | 22163.00  | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | 
    | EDSK-785       | NSFC-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | NSFC-785           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-785       | [AllocRef_ATLP]    | 1               | 64025.00  | 0.00     | 11174.00 | 6538.00  | 1729.00  | 6092.00  | 6792.00  | 5965.00  | 2546.00  | 5753.00  | 7811.00  | 5858.00  | 3767.00  | 
    #
    | EDSK-785       | 16TR-785           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | 16TR-785           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | 16TR-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-785       | AECA-785           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 2               | 28472.00  | 2238.00  | 3068.00  | 3296.00  | 647.00   | 2174.00  | 2277.00  | 2949.00  | 3651.00  | 3281.00  | 1675.00  | 2791.00  | 425.00   | 
    | EDSK-785       | AECA-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | AECA-785           | 5               | 18874.00  | 2028.00  | 3396.00  | 2992.00  | 2240.00  | 793.00   | 1435.00  | 1474.00  | 1356.00  | 1712.00  | 644.00   | 145.00   | 659.00   | 
    #
    | EDSK-785       | NSFC-785           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | NSFC-785           | 2               | 22163.00  | 3219.00  | 443.00   | 388.00   | 1534.00  | 1796.00  | 1994.00  | 1401.00  | 3180.00  | 561.00   | 3733.00  | 2602.00  | 1312.00  | 
    | EDSK-785       | NSFC-785           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-785       | NSFC-785           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal  | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
    | 10017785 | EDSK-785       | [AllocRef_ATLP]    | 100697             | 0.00      | 11174.00  | 6538.00   | 1729.00   | 6092.00   | 6792.00   | 5965.00   | 2546.00   | 5753.00   | 7811.00   | 5858.00   | 3767.00   | 
    | 10017785 | EDSK-785       | AECA-785           | 2371110            | 2238.00   | 3068.00   | 3296.00   | 647.00    | 2174.00   | 2277.00   | 2949.00   | 3651.00   | 3281.00   | 1675.00   | 2791.00   | 425.00    | 
    | 10017785 | EDSK-785       | AECA-785           | 2371130            | 2028.00   | 3396.00   | 2992.00   | 2240.00   | 793.00    | 1435.00   | 1474.00   | 1356.00   | 1712.00   | 644.00    | 145.00    | 659.00    | 
    | 10017785 | EDSK-785       | NSFC-785           | 100945             | 3219.00   | 443.00    | 388.00    | 1534.00   | 1796.00   | 1994.00   | 1401.00   | 3180.00   | 561.00    | 3733.00   | 2602.00   | 1312.00   | 



    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName            | DeliverableDescription  | 
    | 10017785 | EDSK-785       | 2               | [AllocRef_ATLP]  | 1               | 0                     | 64025.00     | 0             | 0        | T-Levels for Adults Pilot  | ?                       |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'EDSK-785' agree with the most recent entry for this contract in the ContractManagement feed

    # Tidy Up
    Given the override date is reset



@AcceptanceTest @Withdrwan25072024
@Long2Run @Long2Run67
Scenario: A792 Bulk load a new EDSK2223 contract with just a T-Level alloc. Check doc parts. Approve. Amend. Check doc parts. Approve. CDA. Payment batch. Check financials, CRM, CPSR and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017792' 
    And   there are no terminated or closed allocations for UKPRN '10017792' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017792' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017792' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017792' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ATLP2223          |

    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                              | UploadTimestamp         | 
    | SOF_EDSK_2022-08-01.docx                          | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_TAC_CFS_ITP_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_LA_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_NMSS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_SPI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S1_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_HEI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_ITP_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_LA_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_APPS_COLLEGE_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_APPS_OTHER_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_ATLP_COFG_COLLEGE_2022-08-01.docx     | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S2_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_CFS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_COFG_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_APPS_COLLEGE_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_APPS_OTHER_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_ATLP_COFG_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | FA_EDSK2223_2022-08-01.docx                       | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx       | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx   | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017792' 
    And   there is no caseload advisor for UKPRN '10017792' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017792 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017792' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017792 Co Ltd' with UKPRN '10017792' and OrgId 'ORG0017792' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017792 | 117792 | 10017792 Co Ltd | 0              | Active                | Yes           | AA017792      | ?             | 4 Deck Offices         | Surrey Quays Road      | London                 | ?                      | ?                      | ?                      | SE16 2XU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017792 |





    # Bulk New an EDSK contract with just a T-Level allocation
    
    # Change the date
    Given the override date is '21/07/2022'

    # Bulk file (CofG_College)
    And   there are no files prefixed '10017792' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 02082022125934 v3_A792' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 02082022125934 v3_A792' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 02082022125934 v3_A792' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 02082022125934 v3_A792' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 02082022125934 v3_A792.xlsx' exists in the Datafiles folder and UKPRN '10017792' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017792' for FundingType 'EDSK' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017792' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices (Six doc parts = SoF, TaC, Sch1, Sch2, FA, Sch3ON)
    Then  the file named '10017792_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017792 Co Ltd UKPRN: 10017792
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    T-Levels for Adults Pilot [AllocRef_ATLP] £26,744 £23,256 £50,000
    Total Funding for this contract: £50,000
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017792 Co Ltd
    Funding for T-Levels for Adults Pilot
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 3 (November 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017792 Co Ltd THE SECRETARY OF STATE FOR
    4 Deck Offices EDUCATION
    Surrey Quays Road DEPARTMENT FOR EDUCATION
    London AND 20 GREAT SMITH STREET
    SE16 2XU LONDON
    SW1P 3BT
    Company No: AA017792
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (November 2022) Page 2
    EDSK Version 3 (November 2022) Page 74
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    Adult T Level Pilot
    EDSK Schedule 1 – Adult T Level Pilot Version 1 College (August 2022) – Page 1
    EDSK Schedule 1 – Adult T Level Pilot Version 1 College (August 2022) – Page 6
    
    SCHEDULE 2: PAYMENT
    Adult T Level Pilot
    EDSK Schedule 2 – Adult T Level Pilot Version 1 (August 2022) – Page 1
    
    SCHEDULE 2 – T-LEVELS FOR ADULTS PILOT
    Funding Agreement – T-Levels for Adults Pilot
    Provider: 10017792 Co Ltd UKPRN: 10017792
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ATLP]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    T-Levels for Adults Pilot £50,000 £1,886 £5,135 £3,277 £1,801 £6,389 £2,701 £4,094 £1,461 £1,408 £7,406 £5,416 £9,026
    Total Funding £50,000 £1,886 £5,135 £3,277 £1,801 £6,389 £2,701 £4,094 £1,461 £1,408 £7,406 £5,416 £9,026
    Schedule 2 – T-Levels for Adults Pilot – Funding Agreement [AllocRef_ATLP] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 3 (November 2022) – Page 1

    SCHEDULE 9: COLLEGE GOVERNANCE
    4.4 The College must obtain the written consent of the Secretary of State
    before entering into any new arrangements for Borrowing Money and for
    any amendment to such arrangements from 29 November 2022 and
    before entering into any amendment to arrangements for Borrowing
    Money that existed before 29 November 2022. Failure to do so will amount
    to a breach of this Agreement and the provisions of Part 8 (Clauses 34 to
    37) will apply.
    EDSK Schedule 9 Version 3 (November 2022) – Page 2

    SCHEDULE 10: SUB-CONTRACTING
    EDSK Schedule 10 Version 3 (November 2022) – Page 5
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-21 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017792_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A792v1.pdf'

    # Simulate an update to the TAC template by changing the UploadTimestamp to a point after contract v1 was created (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx       | 2022-07-26 12:12:12.000 | 





    # Publish and Approve then check feed

    # Change the date
    Given the override date is '28/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017792 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017792 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ATLP] | 100697           | Jul-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverable
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                     | DeliverableDescription                                      | 
    | 10017792 | [ContractNo]   | 1               | [AllocRef_ATLP] | 1               | 0                     | 50000.00     | 0             | 0        | T-Levels for Adults Pilot                                                           | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_ATLP]    | 1               | 50000.00  | 1886.00  | 5135.00  | 3277.00  | 1801.00  | 6389.00  | 2701.00  | 4094.00  | 1461.00  | 1408.00  | 7406.00  | 5416.00  | 9026.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_ATLP]    | 1               | 50000.00  | 1886.00  | 5135.00  | 3277.00  | 1801.00  | 6389.00  | 2701.00  | 4094.00  | 1461.00  | 1408.00  | 7406.00  | 5416.00  | 9026.00  | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_ATLP]    | 1               | 0.00      | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_ATLP]    | 1               | 50000.00  | 1886.00  | 5135.00  | 3277.00  | 1801.00  | 6389.00  | 2701.00  | 4094.00  | 1461.00  | 1408.00  | 7406.00  | 5416.00  | 9026.00  | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
    | 10017792 | [ContractNo]   | [AllocRef_ATLP]    | 100697                   | 1886.00   | 5135.00   | 3277.00   | 1801.00   | 6389.00   | 2701.00   | 4094.00   | 1461.00   | 1408.00   | 7406.00   | 5416.00   | 9026.00   | 




#
#    # Check ADP
#
#    # Check all activity has completed
#    When  there are no messages left in the system
#
#    # Check Planned data on the ADP feed
#    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
#    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202208 | 1886.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202209 | 5135.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202210 | 3277.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202211 | 1801.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202212 | 6389.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202301 | 2701.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202302 | 4094.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202303 | 1461.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202304 | 1408.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202305 | 7406.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202306 | 5416.00      | 0             |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_ATLP]  | 1               | 202307 | 9026.00      | 0             |
#
#


    Then wait '10' seconds


    # Payment Batch stuff starts here for ATLP2223(PoP)

    # Change the date
    Given the override date is '04/07/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ATLP2223' AccountingPaymentPeriod '202304' CensusEndDate '04/07/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ATLP]          | 202307 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ATLP2223                   | 202307               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ATLP2223                   | 202307               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ATLP2223' PaymentPeriod '202304' CensusEndDate '04/07/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A792.xml'

#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ATLP2223' PaymentPeriod '202304' CensusEndDate '04/07/2023' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | ATL                    | 2023          | 04             | 04          | ?       | [AllocRef_ATLP]   | 9026.00         | PROFILE          | Adult T-Levels                     | 2023-07-18 | 2022-08-01   | 2023-07-31 | ?              | 10017792 | 100697     |
#







    # Bulk Amend contract to change the financials
    
    # Change the date
    Given the override date is '01/08/2023'

    # Bulk file (CofG_College)
    And   there are no files prefixed '10017792' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 02082022125955 v3_A792' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 02082022125955 v3_A792' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 02082022125955 v3_A792' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 02082022125955 v3_A792' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 02082022125955 v3_A792.xlsx' exists in the Datafiles folder and UKPRN '10017792' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

#
#    # Retrieve parameters
#   #When  I retrieve the latest EFA contract details from CRM for provider '10017792' for FundingType 'EDSK' and period '2223' and Delivery Organisation '00000000'
#    When  I retrieve the latest contract details from CRM for provider '10017792' for FundingType 'EDSK' and period '2223'
#
#    # Check the contents of the Appendices (Three doc parts = SoF, TaC and FA. No Sch1 or Sch3ON)
#    Then  the file named '10017792_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2022/23
#    Organisation Name: 10017792 Co Ltd UKPRN: 10017792
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
#    T-Levels for Adults Pilot [AllocRef_ATLP] £28,866 £26,134 £55,000
#    Total Funding for this contract: £55,000
#    Summary of Funding – Page 1
#
#    Agreement Type Conditions of Funding (Grant) (Colleges)
#    Funding Period 1 August 2022 to 31 July 2023
#    Between the Secretary of State for Education
#    And 10017792 Co Ltd
#    Funding for T-Levels for Adults Pilot
#    Master Agreement Number [MasterContractNo]
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Version 3 (November 2022) Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    College on the Manage Your Education & Skills Funding Service between:
#    10017792 Co Ltd THE SECRETARY OF STATE FOR
#    4 Deck Offices EDUCATION
#    Surrey Quays Road DEPARTMENT FOR EDUCATION
#    London AND 20 GREAT SMITH STREET
#    SE16 2XU LONDON
#    SW1P 3BT
#    Company No: AA017792
#    Hereinafter called Hereinafter called
#    the College the Department
#    EDSK Version 3 (November 2022) Page 2
#
#
#    SCHEDULE 2 – T-LEVELS FOR ADULTS PILOT
#    Funding Agreement – T-Levels for Adults Pilot
#    Provider: 10017792 Co Ltd UKPRN: 10017792
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
#    Contract Ref: [AllocRef_ATLP]
#    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
#    T-Levels for Adults Pilot £55,000 £1,907 £5,619 £3,208 £3,040 £6,504 £2,922 £4,129 £1,537 £3,839 £7,569 £5,229 £9,497
#    Total Funding £55,000 £1,907 £5,619 £3,208 £3,040 £6,504 £2,922 £4,129 £1,537 £3,839 £7,569 £5,229 £9,497
#    Schedule 2 – T-Levels for Adults Pilot – Funding Agreement [AllocRef_ATLP] – Page 1 Ref (for internal use only):  [ContractNo] v2
#    """
#
#    # There should not be a Sch1 or Sch2
#    #And the pdf file does not contain the following text
#    #"""
#    #Adult T Level Pilot
#    #"""
#
#    # There should not be a Sch3ON
#    And   the pdf file does not contain the following text
#    """
#    EDSK Schedule 3 Version 3 (November 2022) – Page 1
#    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2023-08-01 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017792_[ContractNo]_v2.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A792v2.pdf'




    # Publish and Approve then check feed


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017792 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017792 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017792 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '13' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | [AllocRef_ATLP] | 100697           | Jul-23 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverable
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName             | DeliverableDescription  | 
#    | 10017792 | [ContractNo]   | 2               | [AllocRef_ATLP] | 1               | 0                     | 55000.00     | 0             | 0        | T-Levels for Adults Pilot   | ?                       |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


#
#    # Check financials
#
#    # Check the PLANNED VALUES in CRM on the latest approved contract
#    Then  the Planned Values are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
#    | [ContractNo]   | [AllocRef_ATLP]    | 1               | 55000.00  | 1907.00  | 5619.00  | 3208.00  | 3040.00  | 6504.00  | 2922.00  | 4129.00  | 1537.00  | 3839.00  | 7569.00  | 5229.00  | 9497.00  | 
#
#    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
#    And   the Profile Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
#    | [ContractNo]   | [AllocRef_ATLP]    | 1               | 54979.00  | 1886.00  | 5619.00  | 3208.00  | 3040.00  | 6504.00  | 2922.00  | 4129.00  | 1537.00  | 3839.00  | 7569.00  | 5229.00  | 9497.00  | 
#
#    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
#    And   the Balancing Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
#    | [ContractNo]   | [AllocRef_ATLP]    | 1               | 21.00     | 0.00     | 21.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
#    | [ContractNo]   | [AllocRef_ATLP]    | 1               | 55000.00  | 1886.00  | 5640.00  | 3208.00  | 3040.00  | 6504.00  | 2922.00  | 4129.00  | 1537.00  | 3839.00  | 7569.00  | 5229.00  | 9497.00  | 
#
#
#    # Check the PROFILE subnominal aggregations in CRM
#    And   the Profile Subnominal Amounts are calculated as follows
#    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
#    | 10017792 | [ContractNo]   | [AllocRef_ATLP]    | 100697                   | 1886.00   | 5640.00   | 3208.00   | 3040.00   | 6504.00   | 2922.00   | 4129.00   | 1537.00   | 3839.00   | 7569.00   | 5229.00   | 9497.00   | 



    Then wait '10' seconds


    # Payment Batch stuff starts here for ATLP2223(PoP)

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ATLP2223' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'R'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ATLP]          | 202308 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ATLP2223                   | 202308               |                      | R              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ATLP2223                   | 202308               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ATLP2223' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'R' is decrypted and saved to 'DataFiles/Downloads' as 'A792.xml'
#
#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ATLP2223' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'R' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | ATL                    | 2023          | 05             | 02          | ?       | [AllocRef_ATLP]   | 9497.00         | PROFILE          | Adult T-Levels                     | 2023-08-18 | 2022-08-01   | 2023-07-31 | ?              | 10017792 | 100697     |
#




    # Consolidated Payment Summary Report

    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    When a Consolidated Payment Summary Report is created in Sharepoint for '12/08/2023'

    # Check the contents of the Consolidated Payment Summary Report manually





    # Create and check the contents of the CDA report

    # Change the date
       Given the override date is '14/08/2023'
#
#    # Run the CDA report
    Given there is no CDA report named 'CDA Last Approved Version A792.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 2                     |

    When  the following CDA report is run
    | FundingStreamPeriod   | Version               | Suffix |
    | ATLP2223              | Last Approved Version | A792   |

    Then  a report named 'CDA Last Approved Version A792.csv' is created

    # Check the contents of the CDA report
    #And   the following rows are present in the report
    #| FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription   | Deliverable                 | DeliverableParent  | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 8                 | 2022            | 2022/23       |              | 1907         |              | 0             |              | Yes                | 1886.00        | 0.00             | 0.00                  | 0.00           | 1886.00         |             | No            |                   |        | 100697            | 100697                   |                   | Aug              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 9                 | 2022            | 2022/23       |              | 5619         |              | 0             |              | Yes                | 5619.00        | 21.00            | 0.00                  | 0.00           | 5640.00         |             | Yes           |                   |        | 100697            | 100697                   |                   | Sep              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 10                | 2022            | 2022/23       |              | 3208         |              | 0             |              | Yes                | 3208.00        |                  | 0.00                  | 0.00           | 3208.00         |             | No            |                   |        | 100697            | 100697                   |                   | Oct              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 11                | 2022            | 2022/23       |              | 3040         |              | 0             |              | Yes                | 3040.00        |                  | 0.00                  | 0.00           | 3040.00         |             | No            |                   |        | 100697            | 100697                   |                   | Nov              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 12                | 2022            | 2022/23       |              | 6504         |              | 0             |              | Yes                | 6504.00        |                  | 0.00                  | 0.00           | 6504.00         |             | No            |                   |        | 100697            | 100697                   |                   | Dec              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 1                 | 2023            | 2022/23       |              | 2922         |              | 0             |              | Yes                | 2922.00        |                  | 0.00                  | 0.00           | 2922.00         |             | No            |                   |        | 100697            | 100697                   |                   | Jan              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 2                 | 2023            | 2022/23       |              | 4129         |              | 0             |              | Yes                | 4129.00        |                  | 0.00                  | 0.00           | 4129.00         |             | No            |                   |        | 100697            | 100697                   |                   | Feb              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 3                 | 2023            | 2022/23       |              | 1537         |              | 0             |              | Yes                | 1537.00        |                  | 0.00                  | 0.00           | 1537.00         |             | No            |                   |        | 100697            | 100697                   |                   | Mar              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 4                 | 2023            | 2023/24       |              | 3839         |              | 0             |              | Yes                | 3839.00        |                  | 0.00                  | 0.00           | 3839.00         |             | No            |                   |        | 100697            | 100697                   |                   | Apr              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 5                 | 2023            | 2023/24       |              | 7569         |              | 0             |              | Yes                | 7569.00        |                  | 0.00                  | 0.00           | 7569.00         |             | No            |                   |        | 100697            | 100697                   |                   | May              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 6                 | 2023            | 2023/24       |              | 5229         |              | 0             |              | Yes                | 5229.00        |                  | 0.00                  | 0.00           | 5229.00         |             | No            |                   |        | 100697            | 100697                   |                   | Jun              |
    #| ATLP2223                | 10017792 | 10017792 Co Ltd             |               |                             | [AllocRef_ATLP]          | [ContractNo]   | [MasterContractNo]      | 01/08/2022                  | 31/07/2023                | 2                     | Approved       | Approved                |                          | T-Levels for Adults Pilot   |                    | 7                 | 2023            | 2023/24       |              | 9497         |              | 0             |              | Yes                | 9497.00        |                  | 0.00                  | 0.00           | 9497.00         |             | No            |                   |        | 100697            | 100697                   |                   | Jul              |


    # Tidy Up
    Given the override date is reset
