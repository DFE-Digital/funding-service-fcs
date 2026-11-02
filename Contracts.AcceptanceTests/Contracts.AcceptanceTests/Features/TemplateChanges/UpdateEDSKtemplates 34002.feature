Feature: UpdateEDSKtemplates 34002

@AcceptanceTest @Complete
Scenario: A097 Create and approve a 2021 EDSK contract for a Local Authority with Delivery Orgs. Change Sch1 template timestamp. Amend contract. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017097' 
    And   there are no allocations marked as Under Termination for UKPRN '10001005' 
    And   there are no allocations marked as Under Termination for UKPRN '10001465' 

    And   there are no terminated or closed allocations for UKPRN '10017097' 
    And   there are no terminated or closed allocations for UKPRN '10001005'
    And   there are no terminated or closed allocations for UKPRN '10001465'

    And   there is no Contract, Task or Workflow data for UKPRN '10017097' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017097' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017097' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16ED-0971     |
    | 16ED-0972     |
    | 16ED-0973     |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16ED-0971     |
    | 16ED-0972     |
    | 16ED-0973     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 1619ED2021        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-097       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017097'

    # Set the 'base' timestamp for each of the 20/21 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_EDSK_2020-08-01.docx                        | 2020-05-18 12:00:00.000 | 
    # 
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-05-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-05-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-05-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-05-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-05-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-05-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-05-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-05-18 12:00:00.000 | 
    # 
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-05-18 12:00:00.000 | 
    # 
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-05-18 12:00:00.000 | 
    # 
    | FA_EDSK2021_2020-08-01.docx                     | 2020-05-18 12:00:00.000 | 
    # 
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-05-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-05-18 12:00:00.000 | 




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017097' 
    Given there is no Organisation data for UKPRN '10001005' 
    Given there is no Organisation data for UKPRN '10001465' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10001005 County Council' with UKPRN '10017097' and OrgId 'ORG0017097' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Bury College' with UKPRN '10001005' and OrgId 'ORG0001005' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Bath College' with UKPRN '10001465' and OrgId 'ORG0001465' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                    | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017097 | 117097 | 10017097 County Council | 0              | Active                | Yes           | AA017097      | ?             | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |
    | 10001005 | 101005 | Bury College            | 0              | Active                | Yes           | AA001005      | ?             | 2 Buckingham Court     | Rectory Lane           | ?                      | ?                      | Loughton               | Essex                  | IG10 2QZ  |
    | 10001465 | 101465 | Bath College            | 0              | Active                | Yes           | AA001465      | ?             | 345 The Meadway        | Tilehurst              | ?                      | ?                      | Reading                | Berkshire              | RG30 4NU  |


    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017097 |
    | 10001005 |
    | 10001465 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-097'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-097'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017097 | 10017097 Co Ltd      | ESFA-097             | EDSK-097       | 1                     | 01/08/2020        | 31/07/2021      | 63027.42      |                                       | Conditions of Funding (Grant) (LA)         | 2021   | New          | ORG0017097 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017097 | EDSK-097       | 16ED-0971     | 1619ED            | 1619ED2021              | AY                      | 01/08/2020          | 31/07/2021        | 19200.12        |                                         |            |                                                             | New          | 10017097    |
    | 10001005 | EDSK-097       | 16ED-0972     | 1619ED            | 1619ED2021              | AY                      | 01/08/2020          | 31/07/2021        | 20583.21        |                                         |            |                                                             | New          | 10001005    |
    | 10001465 | EDSK-097       | 16ED-0973     | 1619ED            | 1619ED2021              | AY                      | 01/08/2020          | 31/07/2021        | 23244.09        |                                         |            |                                                             | New          | 10001465    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017097 | EDSK-097       | 16ED-0971     | 148             | 0                     | 7960.27   | 4740.53   | 3219.74   | 0.00     | 1487.21  | 1719.13  | 0.00     | 0.00     | 0.00     | 0.00     | 1534.19  | 0.00     | 0.00     | 3219.74  | 0.00     | 16-19 High Value Courses School and College Leavers Programme   | New          | 10017097    | 
    | 10017097 | EDSK-097       | 16ED-0971     | 149             | 0                     | 11239.85  | 6836.38   | 4403.47   | -1076.28 | 2482.91  | 0.00     | 0.00     | 0.00     | 3230.20  | 1171.77  | 1027.78  | 2857.31  | 0.00     | 1546.16  | 0.00     | 16-19 High Value Courses School and College Leavers Uplift      | New          | 10017097    | 
    #
    | 10017097 | EDSK-097       | 16ED-0972     | 150             | 0                     | 12016.20  | 5376.02   | 6640.18   | 0.00     | 0.00     | 0.00     | 3157.14  | 0.00     | 0.00     | 0.00     | 2218.88  | 0.00     | 3204.13  | 3436.05  | 0.00     | SSF High Value Courses School and College Leavers Programme     | New          | 10001005    | 
    | 10017097 | EDSK-097       | 16ED-0972     | 151             | 0                     | 8567.01   | 5196.76   | 3370.25   | 0.00     | 0.00     | 0.00     | 3605.61  | 0.00     | 0.00     | 1591.15  | 0.00     | 0.00     | 0.00     | 1310.73  | 2059.52  | SSF High Value Courses School and College Leavers Uplift        | New          | 10001005    | 
    #
    | 10001465 | EDSK-097       | 16ED-0973     | 149             | 0                     | 12029.63  | 9103.35   | 2926.28   | 2456.39  | 726.88   | 535.90   | 1942.54  | 0.00     | 0.00     | 0.00     | 3441.64  | 0.00     | 0.00     | 0.00     | 2926.28  | 16-19 High Value Courses School and College Leavers Uplift      | New          | 10001465    | 
    | 10001465 | EDSK-097       | 16ED-0973     | 150             | 0                     | 11214.46  | 5723.19   | 5491.27   | 0.00     | 0.00     | 3329.02  | 0.00     | 0.00     | 0.00     | 987.15   | 1407.02  | 2296.78  | 708.24   | 0.00     | 2486.25  | SSF High Value Courses School and College Leavers Programme     | New          | 10001465    | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-097       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-097'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-097' and actual ContractNumber 'EDSK-097'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-097' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017097 | EDSK-097           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017097 | ESFA-097           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-097' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'EDSK-097'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16ED-0971       | 2203071          | Jul-21 | Profile        |
    | 16ED-0972       | 2218071          | Jul-21 | Profile        |
    | 16ED-0973       | 2203072          | Jul-21 | Profile        |


    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-097' agree with the most recent entry for this contract in the ContractManagement feed





    # Amend the contract and check Sharepoint docs

    # Change the date
    Given the override date is '02/06/2021'

    # Update the timestamps on two of the 20/21 S1 document templates to dates after contract v1 was created (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2021-06-01 09:45:15.000 | 
    | EDSK2021_S1_1619ED_LA.docx                      | 2021-06-01 09:45:15.000 | 


    # Bulk file to amend contract by changing the financials on the three Orgs
    And   there are no files prefixed '10017097' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 01062021131102 v3_A097' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 01062021131102 v3_A097' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 01062021131102 v3_A097' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 01062021131102 v3_A097' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 01062021131102 v3_A097.xlsx' exists in the Datafiles folder and UKPRN '10017097' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contents of the Appendices. Sch1 template has changed since contract v1 was created so this is created too. 
    Then  the file named '10017097_EDSK-097_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017097 County Council UKPRN: 10017097
    Master Contract Number: ESFA-097
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    16 to 19 Education
    10017097 County Council 16ED-0971 £20,117 £15,092 £35,209
    Bath College 16ED-0973 £23,897 £8,480 £32,377
    Bury College 16ED-0972 £13,012 £7,824 £20,836
    Total Funding for this contract: £88,421
    Summary of Funding – Page 1
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 3 LA (June 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 3 LA (June 2021) – Page 12
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017097 County Council UKPRN: 10017097
    Master Contract Number: ESFA-097 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: 16ED-0971
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    16-19 High Value Courses School and College £22,060 £240.00 £4,625.55 £0.00 £3,039.51 £0.00 £858.30 £2,034.09 £0.00 £0.00 £3,608.63 £4,064.62 £3,588.85
    Leavers Programme
    16-19 High Value Courses School and College £13,149 £1,366.10 £4,400.73 £0.00 £401.15 £0.00 £0.00 £0.00 £3,151.28 £0.00 £1,313.13 £0.00 £2,516.61
    Leavers Uplift
    Total Funding £35,209 £1,606.10 £9,026.28 £0.00 £3,440.66 £0.00 £858.30 £2,034.09 £3,151.28 £0.00 £4,921.76 £4,064.62 £6,105.46
    Schedule 2 – 16 to 19 Education – Funding Agreement 16ED-0971 – Page 1 Ref (for internal use only):  EDSK-097 v2
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: Bath College UKPRN: 10001465
    Master Contract Number: ESFA-097 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: 16ED-0973
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    16-19 High Value Courses School and College £19,711 £1,366.10 £4,400.00 £675.00 £5,877.00 £0.00 £350.00 £0.00 £3,150.00 £0.00 £1,325.00 £0.00 £2,568.00
    Leavers Uplift
    SSF High Value Courses School and College £12,666 £1,578.00 £0.00 £1,218.00 £1,457.00 £0.00 £0.00 £1,055.00 £2,771.00 £0.00 £0.00 £0.00 £4,587.00
    Leavers Programme
    Total Funding £32,377 £2,944.10 £4,400.00 £1,893.00 £7,334.00 £0.00 £350.00 £1,055.00 £5,921.00 £0.00 £1,325.00 £0.00 £7,155.00
    Schedule 2 – 16 to 19 Education – Funding Agreement 16ED-0973 – Page 1 Ref (for internal use only):  EDSK-097 v2
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: Bury College UKPRN: 10001005
    Master Contract Number: ESFA-097 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: 16ED-0972
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    SSF High Value Courses School and College £10,382 £1,245.00 £0.00 £1,218.00 £1,962.00 £0.00 £0.00 £1,176.00 £1,287.00 £0.00 £1,994.00 £0.00 £1,500.00
    Leavers Programme
    SSF High Value Courses School and College £10,454 £1,418.00 £0.00 £0.00 £1,945.00 £0.00 £1,224.00 £0.00 £1,537.00 £1,882.00 £0.00 £1,306.00 £1,142.00
    Leavers Uplift
    Total Funding £20,836 £2,663.00 £0.00 £1,218.00 £3,907.00 £0.00 £1,224.00 £1,176.00 £2,824.00 £1,882.00 £1,994.00 £1,306.00 £2,642.00
    Schedule 2 – 16 to 19 Education – Funding Agreement 16ED-0972 – Page 1 Ref (for internal use only):  EDSK-097 v2
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017097_EDSK-097_v2.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A097.pdf'

    # Tidy Up
    And   the override date is reset
      
@AcceptanceTest @Complete
Scenario: A049 Bulk load an EDSK2223 contract. NFA amend 2x. Check docs and doc parts after template change

    # 1. Bulk load, publish and approve 22/23 EDSK contract. Check docs
    # 2. Non-Financial amendment to create v2. Publish and approve. Check docs
    # 3. Simulate arrival of new template.
    # 4. Non-Financial amendment to create v3. Publish and approve. Check docs


    Given there are no allocations marked as Under Termination for UKPRN '10017049' 
    And   there are no terminated or closed allocations for UKPRN '10017049' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017049' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017049' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017049' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017049'



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
    | EDSK2223_S1_1619ED_TRUST_2022-08-01.docx          | 2022-04-01 12:00:00.000 |
    | EDSK2223_S1_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 |
    | EDSK2223_S1_APPS_COLLEGE_2022-08-01.docx          | 2022-04-01 12:00:00.000 |
    | EDSK2223_S1_APPS_OTHER_2022-08-01.docx            | 2022-04-01 12:00:00.000 |
    | EDSK2223_S1_ATLP_COFG_2022-08-01.docx             | 2022-04-01 12:00:00.000 |
    | EDSK2223_S1_ATLP_COFG_COLLEGE_2022-08-01.docx     | 2022-04-01 12:00:00.000 |
    | EDSK2223_S1_ATLP_COFG_TRUST_2022-08-01.docx       | 2022-04-01 12:00:00.000 |
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
    Given there is no Organisation data in CRM for UKPRN '10017049' 
    And   there is no caseload advisor for UKPRN '10017049' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017049 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017049' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017049 Co Ltd' with UKPRN '10017049' and OrgId 'ORG0017049' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017049 | 117049 | 10017049 Co Ltd | 0              | Active                | Yes           | AA017049      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017049 |





    # Change the date
    Given the override date is '12/01/2023'

    # Bulk file
    And   there are no files prefixed '10017049' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 19012023155514 v3_A049' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 19012023155514 v3_A049' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 19012023155514 v3_A049' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 19012023155514 v3_A049' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 19012023155514 v3_A049.xlsx' exists in the Datafiles folder and UKPRN '10017049' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017049' for FundingType 'EDSK' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017049' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices (16 doc parts)
    #  SoF, TaC, 4xSch1, [Sch2 + FA, Loans], [Sch2 + 2xFA, AEB], [Sch2 + FA 16-18], [Sch2 + FA 16-19], Sch3
    Then  the file named '10017049_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017049 Co Ltd UKPRN: 10017049
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Bursary [AllocRef_ALLB] £30,377 £7,413 £37,790
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £33,487 £19,838 £53,325
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £67,674 £25,987 £93,661
    of which Short Term Funding Initiative 1 £21,360 £6,879 £28,239
    of which Short Term Funding Initiative 4 £46,314 £19,108 £65,422
    16 to 18 Traineeships [AllocRef_16TR] £60,383 £33,211 £93,594
    16 to 19 Education [AllocRef_16ED] £23,268 £24,544 £47,812
    Total Funding for this contract: £326,182
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017049 Co Ltd
    Advanced Learner Loans
    ESFA-Funded Adult Education Budget
    Funding for
    16 to 18 Traineeships
    16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE COLLEGE
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 3 (November 2022) Page 1
    
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017049 Co Ltd THE SECRETARY OF STATE FOR
    9 Kneesworth Street EDUCATION
    Royston DEPARTMENT FOR EDUCATION
    Hertfordshire AND 20 GREAT SMITH STREET
    SG8 5AA LONDON
    SW1P 3BT
    Company No: AA017049
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (November 2022) Page 2
    EDSK Version 3 (November 2022) Page 74
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 9
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 8
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2022) – Page 7
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2022) – Page 10
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2022) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2022) – Page 2
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017049 Co Ltd UKPRN: 10017049
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Bursary Funding £37,790 £1,060 £4,138 £7,078 £6,208 £4,595 £1,485 £2,864 £2,949 £2,694 £3,459 £1,166 £94
    Total Funding £37,790 £1,060 £4,138 £7,078 £6,208 £4,595 £1,485 £2,864 £2,949 £2,694 £3,459 £1,166 £94
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    Adult Education Budget
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017049 Co Ltd UKPRN: 10017049
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - 19 to 24 Traineeships £53,325 £4,492 £7,974 £3,368 £7,125 £76 £7,433 £1,265 £1,754 £4,015 £7,295 £7,518 £1,010
    Total Funding £53,325 £4,492 £7,974 £3,368 £7,125 £76 £7,433 £1,265 £1,754 £4,015 £7,295 £7,518 £1,010
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Provider: 10017049 Co Ltd UKPRN: 10017049
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_STFC]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Short Term Funding Initiative 1 £28,239 £197 £759 £1,184 £7,861 £3,732 £217 £4,920 £2,490 £1,831 £80 £3,222 £1,746
    ESFA AEB - Short Term Funding Initiative 4 £65,422 £6,045 £5,451 £7,234 £7,723 £2,033 £5,313 £5,536 £6,979 £536 £7,691 £4,241 £6,640
    Total Funding £93,661 £6,242 £6,210 £8,418 £15,584 £5,765 £5,530 £10,456 £9,469 £2,367 £7,771 £7,463 £8,386
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_STFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    5. The Department will pay the College on the 16 Working Day of each month.
    EDSK Schedule 2 – 16 to 18 Traineeships Version 2 (February 2023) – Page 1
   
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017049 Co Ltd UKPRN: 10017049
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16 to 18 Traineeships Programme Funding £52,609 £4,332 £2,580 £5,723 £4,247 £2,835 £4,958 £6,540 £3,907 £3,854 £1,901 £7,761 £3,971
    16 to 18 Traineeships Bursary Funding £40,985 £7,389 £1,359 £3,547 £712 £3,377 £1,221 £1,848 £5,808 £3,992 £3,599 £2,665 £5,468
    Total Funding £93,594 £11,721 £3,939 £9,270 £4,959 £6,212 £6,179 £8,388 £9,715 £7,846 £5,500 £10,426 £9,439
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017049 Co Ltd UKPRN: 10017049
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Pre-16 Universal Infant Free School Meals (Final £47,812 £4,686.00 £1,576.00 £844.00 £929.00 £674.00 £1,438.00 £7,096.00 £6,025.00 £7,129.00 £3,816.00 £7,914.00 £5,685.00
    Payment)
    Total Funding £47,812 £4,686.00 £1,576.00 £844.00 £929.00 £674.00 £1,438.00 £7,096.00 £6,025.00 £7,129.00 £3,816.00 £7,914.00 £5,685.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 3 (November 2022) – Page 1
    EDSK Schedule 10 Version 3 (November 2022) – Page 5
    """

    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this 
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-01-12 09:12:35.000 |
    
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017049_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A049v1.pdf'
    
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
    | 10017049 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017049 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Part 2: Non-Financial amendment to create v2. Publish and approve. Check docs

    # Change the date
    Given the override date is '16/01/2023'

    # Issue a non-financial VARIATION amendment on v1 to create v2. Only the Summary of Funding should be produced. No Funding Agreements.
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017049 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017049 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017049 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the contents of the Appendices. (SoF only)
    Then  the file named '10017049_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017049 Co Ltd UKPRN: 10017049
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Bursary [AllocRef_ALLB] £30,377 £7,413 £37,790
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £33,487 £19,838 £53,325
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £67,674 £25,987 £93,661
    of which Short Term Funding Initiative 1 £21,360 £6,879 £28,239
    of which Short Term Funding Initiative 4 £46,314 £19,108 £65,422
    16 to 18 Traineeships [AllocRef_16TR] £60,383 £33,211 £93,594
    16 to 19 Education [AllocRef_16ED] £23,268 £24,544 £47,812
    Total Funding for this contract: £326,182
    Summary of Funding – Page 1
    """

    # There shouldn't be a TAC document
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # There shouldn't be any Sch1 documents
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There shouldn't be any Sch2 documents
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """

    # There shouldn't be a Sch3 document
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this 
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2023-01-16 09:12:35.000 |
    
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017049_[ContractNo]_v2.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A049v2.pdf'
    
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
    | 10017049 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017049 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017049 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Part 3: Simulate arrival of new template.

    # Update the timestamp on the s2 template to a date after contract v2 was created on 16/01/2023 (DocumentsDomain.UploadedDocumentTemplate)
    Given the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2223_S2_1618TRN_COFG_2022-08-01.docx        | 2023-01-22 12:00:00.000 |





    # Part 4: Non-Financial amendment to create v3. Check docs

    # Change the date
    Given the override date is '24/01/2023'

    # Issue a non-financial VARIATION amendment on v1 to create v2. Only the Summary of Funding should be produced. No Funding Agreements.
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017049 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017049 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017049 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017049 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the contents of the Appendices. (SoF and Sch2 - because Sch2 template has changed)
    Then  the file named '10017049_[ContractNo]_v3.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017049 Co Ltd UKPRN: 10017049
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Bursary [AllocRef_ALLB] £30,377 £7,413 £37,790
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £33,487 £19,838 £53,325
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £67,674 £25,987 £93,661
    of which Short Term Funding Initiative 1 £21,360 £6,879 £28,239
    of which Short Term Funding Initiative 4 £46,314 £19,108 £65,422
    16 to 18 Traineeships [AllocRef_16TR] £60,383 £33,211 £93,594
    16 to 19 Education [AllocRef_16ED] £23,268 £24,544 £47,812
    Total Funding for this contract: £326,182
    Summary of Funding – Page 1

    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    5. The Department will pay the College on the 16 Working Day of each month.
    EDSK Schedule 2 – 16 to 18 Traineeships Version 2 (February 2023) – Page 1
    """

    # There shouldn't be a TAC document
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # There shouldn't be any Sch1 documents
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There shouldn't be a Sch3 document
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """


    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017049_[ContractNo]_v3.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A049v3.pdf'


    # Tidy Up
    Given the override date is reset
     
 