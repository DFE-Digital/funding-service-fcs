Feature: EDSK2021TemplateChanges 31053

@AcceptanceTest @Withdrawn20231002
Scenario: A502 Create and approve a 2021 EDSK contract with AEBC-19TRN2021 and 1619ED2021 allocs and CoFG(NMSS). Update specific template timestamps. Bulk amend. Check docs and financials
    Given there are no allocations marked as Under Termination for UKPRN '10017502' 
    And   there are no terminated or closed allocations for UKPRN '10017502' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017502' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16ED-502      |
    | AECT-502      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP             |
    | AEBC-19TRN2021  |
    | 1619ED2021      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-502       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017502'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017502' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017502 Co Ltd' with UKPRN '10017502' and OrgId 'ORG0017502' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017502' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017502 | 117502 | 10017502 Co Ltd | 0              | Active                | Yes           | AA017502      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017502 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                         | Period | CRMIntent    | OrgId      |
    | 10017502 | 10017502 Co Ltd      | ESFA-502             | EDSK-502       | 1                     | 01/08/2020        | 31/07/2021      | 77360.85      |                       | Conditions of Funding (Grant) (NMSS) | 2021   | New          | ORG0017502 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName         | UoPCode    | AllocationDescription      | CRMIntent    | DeliveryOrg |
    | 10017502 | EDSK-502       | 16ED-502      | 1619ED            | 1619ED2021              | AY                      | 01/08/2020          | 31/07/2021        | 57625.85        |                 |            |                            | New          |             |
    | 10017502 | EDSK-502       | AECT-502      | AEBC-19TRN        | AEBC-19TRN2021          | AY                      | 01/08/2020          | 31/07/2021        | 19735.00        |                 |            |                            | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017502 | EDSK-502       | 16ED-502      | 128             | 0                     | 4397.23   | 0.00      | 4397.23   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2792.05  | 75.78    | 1529.40  | Early Adopter Development Fund - Marketing 1619                 | New          |             | 
    | 10017502 | EDSK-502       | 16ED-502      | 130             | 0                     | 3212.76   | 2094.85   | 1117.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 649.53   | 1445.32  | 0.00     | 0.00     | 0.00     | 1117.91  | Early Adopter Development Fund - Transition Programme SSF       | New          |             | 
    # Tuition Fund (30898)
    | 10017502 | EDSK-502       | 16ED-502      | 143             | 0                     | 3450.98   | 2217.36   | 1233.62   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2217.36  | 0.00     | 0.00     | 0.00     | 0.00     | 1233.62  | 0.00     | 16-19 Tuition Fund                                              | New          |             | 
    | 10017502 | EDSK-502       | 16ED-502      | 146             | 0                     | 4453.67   | 3406.67   | 1047.00   | 0.00     | 0.00     | 1563.88  | 1842.79  | 0.00     | 0.00     | 0.00     | 0.00     | 1047.00  | 0.00     | 0.00     | 0.00     | SSF Tuition Fund                                                | New          |             | 
    # Coronavirus (COVID-19) (31250)
    | 10017502 | EDSK-502       | 16ED-502      | 147             | 0                     | 5000.03   | 1087.00   | 3913.03   | 0.00     | 0.00     | 1087.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1535.13  | 2377.90  | 0.00     | 0.00     | Coronavirus (COVID-19) Catch-up Premium                         | New          |             | 
    # High Value Courses (32022)
    | 10017502 | EDSK-502       | 16ED-502      | 148             | 0                     | 2675.78   | 2675.78   | 0.00      | 0.00     | 0.00     | 0.00     | 2675.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses School and College Leavers Programme   | New          |             | 
    | 10017502 | EDSK-502       | 16ED-502      | 149             | 0                     | 8238.70   | 6886.81   | 1351.89   | 1629.29  | 0.00     | 0.00     | 460.62   | 739.52   | 0.00     | 1254.89  | 2802.49  | 0.00     | 0.00     | 1351.89  | 0.00     | 16-19 High Value Courses School and College Leavers Uplift      | New          |             | 
    | 10017502 | EDSK-502       | 16ED-502      | 150             | 0                     | 9524.34   | 6253.57   | 3270.77   | -1444.26 | 2381.01  | 0.00     | 1721.66  | 0.00     | 0.00     | 3595.16  | 0.00     | 3270.77  | 0.00     | 0.00     | 0.00     | SSF High Value Courses School and College Leavers Programme     | New          |             | 
    | 10017502 | EDSK-502       | 16ED-502      | 151             | 0                     | 9571.37   | 7223.73   | 2347.64   | 2158.31  | 0.00     | 0.00     | 0.00     | 1642.95  | 0.00     | 0.00     | 3422.47  | 0.00     | 378.79   | 0.00     | 1968.85  | SSF High Value Courses School and College Leavers Uplift        | New          |             | 
    # Catch-up Premium for Covid-19 (32867)
    | 10017502 | EDSK-502       | 16ED-502      | 154             | 0                     | 11259.86  | 8537.86   | 2722.00   | 0.00     | 3187.51  | 0.00     | 0.00     | 2582.71  | 2767.64  | 0.00     | 0.00     | 471.24   | 0.00     | 0.00     | 2250.76  | 14-16 Catch-up Premium (COVID-19)                               | New          |             | 
    # Employer Incentive Fund for T-level (34070)
    | 10017502 | EDSK-502       | 16ED-502      | 155             | 0                     | 7100.99   | 2006.25   | 5094.74   | -325.23  | 0.00     | 0.00     | 1634.87  | 0.00     | 0.00     | 0.00     | 696.61   | 0.00     | 1681.86  | 0.00     | 3412.88  | Employer Incentive Fund for T-level                             | New          |             | 
    #
    | 10017502 | EDSK-502       | AECT-502      | 1               | 0                     | 19735.00  | 14273.00  | 5462.00   | 3148.00  | 3662.00  | 2120.00  | 326.00   | 2990.00  | 435.00   | 697.00   | 895.00   | 302.00   | 2081.00  | 445.00   | 2634.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-502       | 1                     | 0                        | 2020-07-21 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-502' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-502'





    # Change the date
    Given the override date is '02/07/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-502' and actual ContractNumber 'EDSK-502'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-502' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017502 | EDSK-502           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017502 | ESFA-502           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '168' deliverable period rows in CRM linked to the latest version of contract 'EDSK-502'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-502        | 2355775          | Jul-21 | Reconciliation |
    | 16ED-502        | 100582           | Jul-21 | Profile        |





    # Bulk amendment of financials then doc check

    # Change the date
    Given the override date is '03/07/2020'
   
    # Update template timestamps on 6 TAC docs and S1_AEB_COFG
    # Set the 'base' timestamp for all other templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 09:15:30.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 09:15:30.000 |
    #
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-09-15 11:22:44.000 |
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 09:15:30.000 |
    #
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-06-18 09:15:30.000 |
    #
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 09:15:30.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 09:15:30.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 09:15:30.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 09:15:30.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 09:15:30.000 |
    #
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 09:15:30.000 |


    # Bulk file (Change financials on AEBC-19TRN and on deliverables 143 and 146-155 of 1619ED)
    And   there are no files prefixed '10017502' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 08092020090441 v3_A502' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 08092020090441 v3_A502' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 08092020090441 v3_A502' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 08092020090441 v3_A502' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 08092020090441 v3_A502.xlsx' exists in the Datafiles folder and UKPRN '10017502' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017502' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017502' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices (Should include an SoF, TAC, Sch1 and an AEBC-19TRN FA)
    Then  the file named '10017502_EDSK-502_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017502 Co Ltd UKPRN: 10017502
    Master Contract Number: ESFA-502
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - 19 to 24 Traineeships AECT-502 £29,839 £18,326 £48,165
    16 to 19 Education 16ED-502 £138,272 £89,970 £228,241
    Total Funding for this contract: £276,406
    Summary of Funding – Page 1

    Agreement Type Non-Maintained Special Schools
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017502 Co Ltd
    ESFA-Funded Adult Education Budget
    Funding for
    16 to 19 Education
    Master Agreement Number ESFA-502
    EDSK Version 2 (September 2020) Page 1
    EDSK Version 2 (September 2020) Page 69

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 7

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017502 Co Ltd UKPRN: 10017502
    Master Contract Number: ESFA-502 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: AECT-502
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - 19 to 24 Traineeships £48,165 £2,801 £6,889 £2,081 £605 £7,144 £1,316 £2,898 £6,105 £6,052 £4,098 £2,007 £6,169
    Total Funding £48,165 £2,801 £6,889 £2,081 £605 £7,144 £1,316 £2,898 £6,105 £6,052 £4,098 £2,007 £6,169
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement AECT-502 – Page 1 Ref (for internal use only):  EDSK-502 v2
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017502 Co Ltd UKPRN: 10017502
    Master Contract Number: ESFA-502 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: 16ED-502
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Early Adopter Development Fund - Marketing 1619 £4,397 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,792.05 £75.78 £1,529.40
    Early Adopter Development Fund - Transition £3,213 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £649.53 £1,445.32 £0.00 £0.00 £0.00 £1,117.91
    Programme SSF
    16-19 Tuition Fund £50,885 £3,292.00 £6,795.00 £2,347.00 £648.00 £7,983.00 £1,706.00 £3,232.00 £5,847.00 £6,002.00 £4,195.00 £2,409.00 £6,429.00
    SSF Tuition Fund £50,752 £3,560.00 £6,465.00 £2,162.00 £626.00 £7,877.00 £1,881.00 £3,474.00 £5,921.00 £5,820.00 £4,117.00 £2,619.00 £6,230.00
    Coronavirus (COVID-19) Catch-up Premium £20,000 £1,331.00 £1,213.00 £1,033.00 £1,713.00 £1,394.00 £1,360.00 £1,028.00 £1,687.00 £1,440.00 £2,739.00 £2,306.00 £2,756.00
    16-19 High Value Courses School and College £9,966 £807.73 £0.00 £0.00 £139.87 £1,144.26 £1,091.29 £3,834.16 £945.91 £0.00 £0.00 £0.00 £2,003.27
    Leavers Programme
    16-19 High Value Courses School and College £9,804 £0.00 £0.00 £0.00 £1,334.60 £3,059.55 £0.00 £0.00 £573.33 £0.00 £0.00 £4,771.25 £65.37
    Leavers Uplift
    SSF High Value Courses School and College £19,606 £998.88 £2,935.97 £0.00 £0.00 £1,210.75 £0.00 £3,431.14 £4,944.49 £2,988.94 £351.74 £0.00 £2,743.82
    Leavers Programme
    SSF High Value Courses School and College £12,396 £345.15 £0.00 £0.00 £1,948.49 £3,250.70 £2,054.43 £0.00 £0.00 £0.00 £0.00 £732.23 £4,064.94
    Leavers Uplift
    14-16 Catch-up Premium (COVID-19) £22,222 £0.00 £0.00 £0.00 £0.00 £0.00 £2,015.00 £4,450.00 £3,585.00 £608.00 £5,412.00 £2,088.00 £4,064.22
    Employer Incentive Fund for T-level £25,000 £2,057.00 £3,254.00 £2,014.00 £1,985.00 £1,447.00 £1,354.00 £3,245.00 £2,145.00 £2,252.00 £1,014.00 £3,021.00 £1,212.00
    Total Funding £228,241 £12,391.76 £20,662.97 £7,556.00 £8,394.96 £27,366.26 £11,461.72 £23,343.83 £27,094.05 £19,110.94 £20,620.79 £18,022.26 £32,215.93
    Schedule 2 – 16 to 19 Education – Funding Agreement 16ED-502 – Page 1 Ref (for internal use only):  EDSK-502 v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017502_EDSK-502_v2.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A502v2.pdf'


    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-502' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-502' and actual ContractNumber 'EDSK-502'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-502' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017502 | EDSK-502           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017502 | EDSK-502           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017502 | ESFA-502           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |



    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-502       | AECT-502           | 1               | 48165.00  | 2801.00  | 6889.00  | 2081.00  | 605.00   | 7144.00  | 1316.00  | 2898.00  | 6105.00  | 6052.00  | 4098.00  | 2007.00  | 6169.00  | 
    | EDSK-502       | AECT-502           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-502       | AECT-502           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-502       | 16ED-502           | 128             | 4397.23   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2792.05  | 75.78    | 1529.40  | 
    | EDSK-502       | 16ED-502           | 130             | 3212.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 649.53   | 1445.32  | 0.00     | 0.00     | 0.00     | 1117.91  | 
    # Tuition Fund (30898)
    | EDSK-502       | 16ED-502           | 143             | 50885.00  | 3292.00  | 6795.00  | 2347.00  | 648.00   | 7983.00  | 1706.00  | 3232.00  | 5847.00  | 6002.00  | 4195.00  | 2409.00  | 6429.00  | 
    | EDSK-502       | 16ED-502           | 146             | 50752.00  | 3560.00  | 6465.00  | 2162.00  | 626.00   | 7877.00  | 1881.00  | 3474.00  | 5921.00  | 5820.00  | 4117.00  | 2619.00  | 6230.00  | 
    # Coronavirus (COVID-19) (31250)
    | EDSK-502       | 16ED-502           | 147             | 20000.00  | 1331.00  | 1213.00  | 1033.00  | 1713.00  | 1394.00  | 1360.00  | 1028.00  | 1687.00  | 1440.00  | 2739.00  | 2306.00  | 2756.00  | 
    # High Value Courses (32022)
    | EDSK-502       | 16ED-502           | 148             | 9966.49   | 807.73   | 0.00     | 0.00     | 139.87   | 1144.26  | 1091.29  | 3834.16  | 945.91   | 0.00     | 0.00     | 0.00     | 2003.27  | 
    | EDSK-502       | 16ED-502           | 149             | 9804.10   | 0.00     | 0.00     | 0.00     | 1334.60  | 3059.55  | 0.00     | 0.00     | 573.33   | 0.00     | 0.00     | 4771.25  | 65.37    | 
    | EDSK-502       | 16ED-502           | 150             | 19605.73  | 998.88   | 2935.97  | 0.00     | 0.00     | 1210.75  | 0.00     | 3431.14  | 4944.49  | 2988.94  | 351.74   | 0.00     | 2743.82  | 
    | EDSK-502       | 16ED-502           | 151             | 12395.94  | 345.15   | 0.00     | 0.00     | 1948.49  | 3250.70  | 2054.43  | 0.00     | 0.00     | 0.00     | 0.00     | 732.23   | 4064.94  | 
    # Catch-up Premium for Covid-19 (32867)
    | EDSK-502       | 16ED-502           | 154             | 22222.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2015.00  | 4450.00  | 3585.00  | 608.00   | 5412.00  | 2088.00  | 4064.22  | 
    # Employer Incentive Fund for T-level (34070)
    | EDSK-502       | 16ED-502           | 155             | 25000.00  | 2057.00  | 3254.00  | 2014.00  | 1985.00  | 1447.00  | 1354.00  | 3245.00  | 2145.00  | 2252.00  | 1014.00  | 3021.00  | 1212.00  | 


    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    # Deliverable 128
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 2792.05         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 75.78           |
    | 10017502 | ORG0017502 | 16ED-502          | 2203062         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 1529.40         |
    # Deliverable 130
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 649.53          |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 1445.32         |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218061         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 1117.91         |
    # Deliverable 143
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 3292.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 6795.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 2347.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 648.00          |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 7983.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 1706.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 3232.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 5847.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 6002.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 4195.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 2409.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203200         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 6429.00         |
    #Deliverable 146
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 3560.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 6465.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 2162.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 626.00          |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 7877.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 1881.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 3474.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 5921.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 5820.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 4117.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 2619.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2219200         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 6230.00         |
    # Deliverable 147
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 1331.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 1213.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 1033.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 1713.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 1394.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 1360.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 1028.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 1687.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 1440.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 2739.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 2306.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2232300         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 2756.00         |
    # Deliverable 148
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 807.73          |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 139.87          |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 1144.26         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 1091.29         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 3834.16         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 945.91          |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203071         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 2003.27         |
    # Deliverable 149
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 1334.60         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 3059.55         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 573.33          |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 4771.25         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203072         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 65.37           |
    # Deliverable 150
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 998.88          |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 2935.97         |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 1210.75         |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 3431.14         |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 4944.49         |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 2988.94         |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 351.74          |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218071         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 2743.82         |
    # Deliverable 151
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 345.15          |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 1948.49         |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 3250.70         |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 2054.43         |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 732.23          |
    | 10017502 | ORG0017502 | 16ED-502          | 2218072         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 4064.94         |
    # Deliverable 154
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 0.00            |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 2015.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 4450.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 3585.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 608.00          |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 5412.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 2088.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 2203100         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 4064.22         |
    # Deliverable 155
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 2057.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 3254.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 2014.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 1985.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 1447.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 1354.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 3245.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 2145.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 2252.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 1014.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 3021.00         |
    | 10017502 | ORG0017502 | 16ED-502          | 100582          | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 1212.00         |

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef  | ProfileSubnominal  | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    |
    | 10017502 | EDSK-502       | 16ED-502       | 2203062            | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 2792.05   | 75.78     | 1529.40   | 
    | 10017502 | EDSK-502       | 16ED-502       | 2218061            | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 649.53    | 1445.32   | 0.00      | 0.00      | 0.00      | 1117.91   | 
    | 10017502 | EDSK-502       | 16ED-502       | 2203200            | 3292.00   | 6795.00   | 2347.00   | 648.00    | 7983.00   | 1706.00   | 3232.00   | 5847.00   | 6002.00   | 4195.00   | 2409.00   | 6429.00   | 
    | 10017502 | EDSK-502       | 16ED-502       | 2219200            | 3560.00   | 6465.00   | 2162.00   | 626.00    | 7877.00   | 1881.00   | 3474.00   | 5921.00   | 5820.00   | 4117.00   | 2619.00   | 6230.00   | 
    | 10017502 | EDSK-502       | 16ED-502       | 2232300            | 1331.00   | 1213.00   | 1033.00   | 1713.00   | 1394.00   | 1360.00   | 1028.00   | 1687.00   | 1440.00   | 2739.00   | 2306.00   | 2756.00   | 
    | 10017502 | EDSK-502       | 16ED-502       | 2203071            | 807.73    | 0.00      | 0.00      | 139.87    | 1144.26   | 1091.29   | 3834.16   | 945.91    | 0.00      | 0.00      | 0.00      | 2003.27   | 
    | 10017502 | EDSK-502       | 16ED-502       | 2203072            | 0.00      | 0.00      | 0.00      | 1334.60   | 3059.55   | 0.00      | 0.00      | 573.33    | 0.00      | 0.00      | 4771.25   | 65.37     | 
    | 10017502 | EDSK-502       | 16ED-502       | 2218071            | 998.88    | 2935.97   | 0.00      | 0.00      | 1210.75   | 0.00      | 3431.14   | 4944.49   | 2988.94   | 351.74    | 0.00      | 2743.82   | 
    | 10017502 | EDSK-502       | 16ED-502       | 2218072            | 345.15    | 0.00      | 0.00      | 1948.49   | 3250.70   | 2054.43   | 0.00      | 0.00      | 0.00      | 0.00      | 732.23    | 4064.94   | 
    | 10017502 | EDSK-502       | 16ED-502       | 2203100            | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 2015.00   | 4450.00   | 3585.00   | 608.00    | 5412.00   | 2088.00   | 4064.22   | 
    | 10017502 | EDSK-502       | 16ED-502       | 100582             | 2057.00   | 3254.00   | 2014.00   | 1985.00   | 1447.00   | 1354.00   | 3245.00   | 2145.00   | 2252.00   | 1014.00   | 3021.00   | 1212.00   | 


    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017502'
 
@AcceptanceTest @Withdrawn20230123
Scenario: A503 Bulk create a new 2021 EDSK contract with AEBC-ASCL2021 and 1619ED2021 allocs and CoFG(SPI). Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017503' 
    And   there are no terminated or closed allocations for UKPRN '10017503' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017503' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017503'

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEBC-ASCL2021  |
    | 1619ED2021     |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017503' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017503 Co Ltd' with UKPRN '10017503' and OrgId 'ORG0017503' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017503' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017503 | 117503 | 10017503 Co Ltd | 0              | Active                | Yes           | AA017503      | ?             | 6 Avenue Road          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017503 |




    # Bulk create a new EDSK 2021 contract with AEBC-ASCL2021 and 1619ED2021 allocs and CoFG(SPI)

    # Change the date
    Given the override date is '16/09/2020'
   
    # Update template timestamps on 6 TAC docs and S1_AEB_COFG
    # Set the 'base' timestamp for all other templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-09-15 11:22:44.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 09:15:30.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 09:15:30.000 |
    #
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-09-15 11:22:44.000 |
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-18 09:15:30.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 09:15:30.000 |
    #
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-06-18 09:15:30.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-06-18 09:15:30.000 |
    #
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 09:15:30.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 09:15:30.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 09:15:30.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 09:15:30.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 09:15:30.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 09:15:30.000 |
    #
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 09:15:30.000 |
 

    # Bulk file to create new contract with AEBC-ASCL2021 and 1619ED2021 allocs and CoFG(SPI)
    And   there are no files prefixed '10017503' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 08092020114552 v3_A503' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 08092020114552 v3_A503' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 08092020114552 v3_A503' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 08092020114552 v3_A503' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 08092020114552 v3_A503.xlsx' exists in the Datafiles folder and UKPRN '10017503' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017503' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017503' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices (Should include an SoF, TAC, 2xSch1, (Sch2 & FA for ASCL), (Sch2 & FA for 1619) and Sch3ON
    Then  the file named '10017503_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017503 Co Ltd UKPRN: 10017503
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £63,510 £26,825 £90,335
    of which Community Learning £34,776 £12,531 £47,307
    of which Sector-based Work Academies £0 £0 £0
    16 to 19 Education [AllocRef_16ED] £121,126 £27,414 £148,540
    Total Funding for this contract: £238,874
    Summary of Funding – Page 1
    
    Agreement Type Specialist Post-16 Institution
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through the
    Between
    Education and Skills Funding Agency)
    And 10017503 Co Ltd
    ESFA-Funded Adult Education Budget
    Funding for
    16 to 19 Education
    Master Agreement
    [MasterContractNo]
    Number
    EDSK Version 2 (September 2020) Page 1
    EDSK Version 2 (September 2020) Page 70
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 7
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 2 SPI (September 2020) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 2 SPI (September 2020) – Page 12
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: 10017503 Co Ltd UKPRN: 10017503
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - Adult Skills and Community Learning £90,335 £6,148 £14,269 £3,697 £7,338 £8,591 £8,558 £10,767 £4,142 £2,274 £7,879 £12,805 £3,867
    of which Community Learning £47,307 £4,603 £6,524 £761 £5,877 £591 £6,386 £7,013 £3,021 £1,206 £813 £7,830 £2,682
    Total Funding £90,335 £6,148 £14,269 £3,697 £7,338 £8,591 £8,558 £10,767 £4,142 £2,274 £7,879 £12,805 £3,867
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017503 Co Ltd UKPRN: 10017503
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    16-19 High Value Courses Premium £10,376 £1,098.47 £0.00 £0.00 £179.56 £2,750.00 £3,955.56 £1,999.74 £0.00 £0.00 £0.00 £392.25 £0.00
    Pupil Premium (NMSS) £12,428 £2,210.52 £571.87 £0.00 £0.00 £2,276.37 £0.00 £1,958.56 £4,615.48 £795.53 £0.00 £0.00 £0.00
    16-19 Tuition Fund £15,753 £5,342.05 £0.00 £0.00 £1,329.56 £2,741.09 £2,415.56 £2,241.74 £0.00 £241.00 £0.00 £1,442.00 £0.00
    SSF Tuition Fund £14,853 £910.52 £571.87 £0.00 £516.00 £1,774.37 £0.00 £2,106.56 £7,465.48 £1,008.53 £0.00 £500.00 £0.00
    Coronavirus (COVID-19) Catch-up Premium £13,000 £548.52 £162.87 £123.00 £187.67 £1,357.37 £291.00 £1,717.56 £7,029.48 £587.53 £467.00 £78.00 £450.00
    16-19 High Value Courses School and College £13,163 £595.93 £205.77 £138.59 £209.16 £1,347.65 £319.42 £1,737.93 £6,987.47 £576.17 £458.27 £87.77 £498.76
    Leavers Programme
    16-19 High Value Courses School and College £13,024 £597.21 £123.17 £152.91 £222.09 £1,391.11 £265.44 £1,707.53 £7,005.79 £579.59 £440.58 £118.12 £420.00
    Leavers Uplift
    SSF High Value Courses School and College £12,980 £537.77 £141.50 £145.16 £207.64 £1,360.62 £338.03 £1,742.49 £7,012.04 £570.09 £476.74 £40.10 £407.36
    Leavers Programme
    SSF High Value Courses School and College £12,964 £557.36 £119.51 £106.11 £163.85 £1,392.87 £252.27 £1,721.34 £7,044.43 £603.12 £495.15 £78.91 £428.75
    Leavers Uplift
    Employer Incentive Fund for T-level £30,000 £1,024.00 £2,305.00 £1,478.00 £2,659.00 £1,254.00 £1,025.00 £2,557.00 £2,525.00 £6,215.00 £2,154.00 £4,625.00 £2,179.00
    Total Funding £148,540 £13,422.35 £4,201.56 £2,143.77 £5,674.53 £17,645.45 £8,862.28 £19,490.45 £49,685.17 £11,176.56 £4,491.74 £7,362.15 £4,383.87
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 1 (July 2020) – Page 1
    EDSK Schedule 8 Version 1 (July 2020) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017503_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A503v1.pdf'

 
    # Tidy Up
    Given the override date is reset
    
    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017503'

