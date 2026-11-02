Feature: CreateEDSKcontracts 33815

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run67
Scenario: A643 Bulk load a new 2122 EDSK contract with all allocations other than 1619ED. Contract Type CofG HEI. NFA. Withdraw. Change template. NFA. Check docs and CRM

    #  1. Bulk load a new nine allocation 21/22 EDSK contract excluding 1619ED for CofG HEI (No Delivery Orgs)
    #  2. Check docs and parts
    #  3. Publish and approve
    #  4. Check feed, CRM financials and deliverable count
    #  5. Non-financial Variation amendment > v2
    #  6. Check docs and parts
    #  7. Publish then withdraw v2 
    #  8. Change template timestamp
    #  9. Non-financial amendment > v3
    # 10. Check docs and parts

    Given there are no allocations marked as Under Termination for UKPRN '10017643' 
    And   there are no terminated or closed allocations for UKPRN '10017643' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017643' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017643' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017643' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2122      |
    | AEBC-19TRN2122    |
    | AEBC-ASCL2122     |
    | AEBC-NSF2122      |
    | ALLB2122          |
    | ALLBC2122         |
    | ALLF2122          |
    | APPS2122          |
    | STFIC2122         |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017643'

    # Set the 'base' timestamp for each of the 21\22 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_EDSK_2021-08-01.docx                        | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_TAC_CFS_ITP_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_COLLEGE_2021-08-01.docx       | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_EMPLOYER_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_HEI_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_LA_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
  # | EDSK2122_TAC_COFG_NMSS_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_SPI_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_TRUST_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S1_1618TRN_CFS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1618TRN_COFG_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_HEI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_ITP_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_LA_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
  # | EDSK2122_S1_1619ED_NMSS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_SPI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_AEB_COFG_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_APPS_COLLEGE_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_APPS_OTHER_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S2_1618TRN_CFS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1618TRN_COFG_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1619ED_CFS_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1619ED_COFG_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_AEB_COFG_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_APPS_COLLEGE_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_APPS_OTHER_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | FA_EDSK2122_2021-08-01.docx                     | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S3ON_CFS_ITP_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_EMPLOYER_2021-08-01.docx     | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_LA_TRUST_HEI_2021-08-01.docx | 2021-06-07 12:00:00.000 | 
  # | EDSK2122_S3ON_COFG_NMSS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_SPI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017643' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017643 Co Ltd' with UKPRN '10017643' and OrgId 'ORG0017643' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017643' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017643 | 117643 | 10017643 Co Ltd | 0              | Active                | Yes           | AA017643      | ?             | 6 Clyde Street         | Canterbury             | Kent                   | ?                      | ?                      | ?                      | CT1 1NA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017643 |





    # Change the date
    Given the override date is '01/07/2021'

    # Bulk file (CofG HEI)
    And   there are no files prefixed '10017643' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 15062021110140 v3_A643' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 15062021110140 v3_A643' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 15062021110140 v3_A643' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 15062021110140 v3_A643' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 15062021110140 v3_A643.xlsx' exists in the Datafiles folder and UKPRN '10017643' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017643' for FundingType 'EDSK' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017643' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017643_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £28,065 £23,820 £51,885
    Advanced Learner Loans Bursary [AllocRef_ALLB] £31,579 £6,648 £38,227
    Advanced Learner Loans Bursary [AllocRef_ALLC] £38,947 £18,142 £57,089
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £34,605 £15,163 £49,768
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £70,258 £35,138 £105,396
    of which Community Learning £36,519 £24,383 £60,902
    ESFA AEB - National Skills Fund [AllocRef_NSFC] £42,119 £12,025 £54,144
    of which Level 3 Offer for 24 year olds and over £42,119 £12,025 £54,144
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £123,123 £61,516 £184,639
    of which Short Term Funding Initiative 1 £26,691 £11,206 £37,897
    of which Short Term Funding Initiative 2 £35,653 £18,607 £54,260
    of which Short Term Funding Initiative 3 £27,095 £20,167 £47,262
    of which Short Term Funding Initiative 4 £33,684 £11,536 £45,220
    Apprenticeships Carry-In [AllocRef_APPS] £25,584 £13,572 £39,156
    16 to 18 Traineeships [AllocRef_16TR] £59,653 £31,387 £91,040
    Total Funding for this contract: £671,344
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (HEI)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017643 Co Ltd
    Advanced Learner Loans
    ESFA-Funded Adult Education Budget
    Funding for
    Apprenticeships Carry-In
    16 to 18 Traineeships
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017643 Co Ltd THE SECRETARY OF STATE FOR
    6 Clyde Street EDUCATION
    Canterbury DEPARTMENT FOR EDUCATION
    Kent AND 20 GREAT SMITH STREET
    CT1 1NA LONDON
    SW1P 3BT
    Company No: AA017643
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 74
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 9
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 2
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Advanced Learner Loans Facility £51,885 £5,795 £3,906 £5,350 £1,019 £222 £4,724 £5,011 £2,038 £5,116 £5,945 £7,186 £5,573
    Total Funding £51,885 £5,795 £3,906 £5,350 £1,019 £222 £4,724 £5,011 £2,038 £5,116 £5,945 £7,186 £5,573
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Advanced Learner Loans Bursary Funding £38,227 £2,360 £269 £4,431 £7,848 £7,658 £4,006 £1,171 £3,836 £194 £821 £4,780 £853
    Total Funding £38,227 £2,360 £269 £4,431 £7,848 £7,658 £4,006 £1,171 £3,836 £194 £821 £4,780 £853
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Advanced Learner Loans Bursary Funding £57,089 £3,068 £2,134 £4,936 £4,479 £7,961 £3,355 £7,112 £5,902 £5,308 £7,091 £1,741 £4,002
    Total Funding £57,089 £3,068 £2,134 £4,936 £4,479 £7,961 £3,355 £7,112 £5,902 £5,308 £7,091 £1,741 £4,002
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - 19 to 24 Traineeships £49,768 £3,204 £6,549 £2,355 £3,257 £2,663 £4,446 £4,935 £7,196 £2,525 £2,748 £4,191 £5,699
    Total Funding £49,768 £3,204 £6,549 £2,355 £3,257 £2,663 £4,446 £4,935 £7,196 £2,525 £2,748 £4,191 £5,699
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Adult Skills and Community Learning £105,396 £7,060 £7,782 £9,108 £13,079 £4,894 £9,820 £8,833 £9,682 £15,086 £8,938 £7,749 £3,365
    of which Community Learning £60,902 £1,662 £5,833 £4,761 £5,865 £2,553 £4,539 £4,422 £6,884 £7,447 £7,871 £6,597 £2,468
    Total Funding £105,396 £7,060 £7,782 £9,108 £13,079 £4,894 £9,820 £8,833 £9,682 £15,086 £8,938 £7,749 £3,365
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - National Skills Fund
    Provider: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_NSFC]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Level 3 Offer for 24 year olds and over £54,144 £5,289 £4,153 £1,722 £6,902 £7,263 £2,454 £6,818 £7,518 £1,690 £3,271 £6,478 £586
    Total Funding £54,144 £5,289 £4,153 £1,722 £6,902 £7,263 £2,454 £6,818 £7,518 £1,690 £3,271 £6,478 £586
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_NSFC] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Provider: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_STFC]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Short Term Funding Initiative 1 £37,897 £2,743 £3,168 £1,894 £5,715 £90 £6,904 £4,474 £1,703 £2,064 £5,206 £1,618 £2,318
    ESFA AEB - Short Term Funding Initiative 2 £54,260 £4,442 £3,911 £1,279 £3,337 £7,224 £7,244 £3,455 £4,761 £6,682 £3,030 £6,035 £2,860
    ESFA AEB - Short Term Funding Initiative 3 £47,262 £6,544 £1,331 £5,291 £1,364 £3,083 £2,148 £4,951 £2,383 £5,865 £3,370 £5,015 £5,917
    ESFA AEB - Short Term Funding Initiative 4 £45,220 £5,818 £7,602 £2,251 £4,512 £3,569 £3,792 £5,236 £904 £108 £4,609 £4,896 £1,923
    Total Funding £184,639 £19,547 £16,012 £10,715 £14,928 £13,966 £20,088 £18,116 £9,751 £14,719 £16,215 £17,564 £13,018
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_STFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Apprenticeships Carry-In £39,156 £2,958 £4,338 £4,423 £4,168 £4,932 £527 £1,567 £2,671 £7,310 £1,345 £1,227 £3,690
    Total Funding £39,156 £2,958 £4,338 £4,423 £4,168 £4,932 £527 £1,567 £2,671 £7,310 £1,345 £1,227 £3,690
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16 to 18 Traineeships Programme Funding £34,171 £6,752 £1,944 £468 £7,007 £1,179 £2,761 £128 £75 £6,073 £3,982 £192 £3,610
    16 to 18 Traineeships Bursary Funding £56,869 £5,531 £7,719 £4,884 £7,549 £5,394 £6,020 £2,029 £213 £7,772 £6,837 £1,689 £1,232
    Total Funding £91,040 £12,283 £9,663 £5,352 £14,556 £6,573 £8,781 £2,157 £288 £13,845 £10,819 £1,881 £4,842
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (July 2021) – Page 1
    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (July 2021) – Page 1
    SCHEDULE 6: UK GDPR AND DATA PROTECTION
    EDSK Schedule 6 Version 2 (July 2021) – Page 1
    EDSK Schedule 6 Version 2 (July 2021) – Page 2
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 2 (July 2021) – Page 1
    EDSK Schedule 7 Version 2 (July 2021) – Page 9
    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 2 (July 2021) – Page 1
    EDSK Schedule 8 Version 2 (July 2021) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017643_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A643_1.pdf'

    # Display Sharepoint filename
    And   message '10017643_[ContractNo]_v1.pdf' is written to the Output window

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-01 09:12:35.000 |    
    
    
 
 

    # Publish and Approve the contract
    
    # Change the date
    Given the override date is '04/07/2021'

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
    | 10017643 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017643 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    #   (16-18TRN=3x12, AEBC-19TRN=3x12, AEBC-ASCL=5x12, AEBC-NSF=4x12, ALLB=4x12, ALLBC=4x12, ALLF=4x12, APPS=24x12 and STFIC=12x12)
    And   there are '756' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
       
    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_16TR]    | 1               | 91040.00  | 12283.00 | 9663.00  | 5352.00  | 14556.00 | 6573.00  | 8781.00  | 2157.00  | 288.00   | 13845.00 | 10819.00 | 1881.00  | 4842.00  | 
    | [ContractNo]   | [AllocRef_16TR]    | 2               | 34171.00  | 6752.00  | 1944.00  | 468.00   | 7007.00  | 1179.00  | 2761.00  | 128.00   | 75.00    | 6073.00  | 3982.00  | 192.00   | 3610.00  | 
    | [ContractNo]   | [AllocRef_16TR]    | 3               | 56869.00  | 5531.00  | 7719.00  | 4884.00  | 7549.00  | 5394.00  | 6020.00  | 2029.00  | 213.00   | 7772.00  | 6837.00  | 1689.00  | 1232.00  | 
    #
    | [ContractNo]   | [AllocRef_AECA]    | 1               | 105396.00 | 7060.00  | 7782.00  | 9108.00  | 13079.00 | 4894.00  | 9820.00  | 8833.00  | 9682.00  | 15086.00 | 8938.00  | 7749.00  | 3365.00  | 
    | [ContractNo]   | [AllocRef_AECA]    | 2               | 44494.00  | 5398.00  | 1949.00  | 4347.00  | 7214.00  | 2341.00  | 5281.00  | 4411.00  | 2798.00  | 7639.00  | 1067.00  | 1152.00  | 897.00   | 
    | [ContractNo]   | [AllocRef_AECA]    | 5               | 60902.00  | 1662.00  | 5833.00  | 4761.00  | 5865.00  | 2553.00  | 4539.00  | 4422.00  | 6884.00  | 7447.00  | 7871.00  | 6597.00  | 2468.00  | 
    #
    | [ContractNo]   | [AllocRef_AECT]    | 1               | 49768.00  | 3204.00  | 6549.00  | 2355.00  | 3257.00  | 2663.00  | 4446.00  | 4935.00  | 7196.00  | 2525.00  | 2748.00  | 4191.00  | 5699.00  | 
    #
    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 38227.00  | 2360.00  | 269.00   | 4431.00  | 7848.00  | 7658.00  | 4006.00  | 1171.00  | 3836.00  | 194.00   | 821.00   | 4780.00  | 853.00   | 
    #
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 39156.00  | 2958.00  | 4338.00  | 4423.00  | 4168.00  | 4932.00  | 527.00   | 1567.00  | 2671.00  | 7310.00  | 1345.00  | 1227.00  | 3690.00  | 
    #
    | [ContractNo]   | [AllocRef_ALLC]    | 1               | 57089.00  | 3068.00  | 2134.00  | 4936.00  | 4479.00  | 7961.00  | 3355.00  | 7112.00  | 5902.00  | 5308.00  | 7091.00  | 1741.00  | 4002.00  | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 51885.00  | 5795.00  | 3906.00  | 5350.00  | 1019.00  | 222.00   | 4724.00  | 5011.00  | 2038.00  | 5116.00  | 5945.00  | 7186.00  | 5573.00  | 

    | [ContractNo]   | [AllocRef_NSFC]    | 1               | 54144.00  | 5289.00  | 4153.00  | 1722.00  | 6902.00  | 7263.00  | 2454.00  | 6818.00  | 7518.00  | 1690.00  | 3271.00  | 6478.00  | 586.00   | 
    | [ContractNo]   | [AllocRef_NSFC]    | 2               | 54144.00  | 5289.00  | 4153.00  | 1722.00  | 6902.00  | 7263.00  | 2454.00  | 6818.00  | 7518.00  | 1690.00  | 3271.00  | 6478.00  | 586.00   | 
    #
    | [ContractNo]   | [AllocRef_STFC]    | 1               | 37897.00  | 2743.00  | 3168.00  | 1894.00  | 5715.00  | 90.00    | 6904.00  | 4474.00  | 1703.00  | 2064.00  | 5206.00  | 1618.00  | 2318.00  | 
    | [ContractNo]   | [AllocRef_STFC]    | 2               | 54260.00  | 4442.00  | 3911.00  | 1279.00  | 3337.00  | 7224.00  | 7244.00  | 3455.00  | 4761.00  | 6682.00  | 3030.00  | 6035.00  | 2860.00  | 
    | [ContractNo]   | [AllocRef_STFC]    | 3               | 47262.00  | 6544.00  | 1331.00  | 5291.00  | 1364.00  | 3083.00  | 2148.00  | 4951.00  | 2383.00  | 5865.00  | 3370.00  | 5015.00  | 5917.00  | 
    | [ContractNo]   | [AllocRef_STFC]    | 4               | 45220.00  | 5818.00  | 7602.00  | 2251.00  | 4512.00  | 3569.00  | 3792.00  | 5236.00  | 904.00   | 108.00   | 4609.00  | 4896.00  | 1923.00  | 





    # Execute a NON-FINANCIAL variation amendment 

    # Change the date
    Given the override date is '06/07/2020'

    # Issue a non-financial VARIATION amendment 
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check CRM state then check docs

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017643 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017643 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017643 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017643' for FundingType 'EDSK' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017643' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017643_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £28,065 £23,820 £51,885
    Advanced Learner Loans Bursary [AllocRef_ALLB] £31,579 £6,648 £38,227
    Advanced Learner Loans Bursary [AllocRef_ALLC] £38,947 £18,142 £57,089
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £34,605 £15,163 £49,768
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £70,258 £35,138 £105,396
    of which Community Learning £36,519 £24,383 £60,902
    ESFA AEB - National Skills Fund [AllocRef_NSFC] £42,119 £12,025 £54,144
    of which Level 3 Offer for 24 year olds and over £42,119 £12,025 £54,144
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £123,123 £61,516 £184,639
    of which Short Term Funding Initiative 1 £26,691 £11,206 £37,897
    of which Short Term Funding Initiative 2 £35,653 £18,607 £54,260
    of which Short Term Funding Initiative 3 £27,095 £20,167 £47,262
    of which Short Term Funding Initiative 4 £33,684 £11,536 £45,220
    Apprenticeships Carry-In [AllocRef_APPS] £25,584 £13,572 £39,156
    16 to 18 Traineeships [AllocRef_16TR] £59,653 £31,387 £91,040
    Total Funding for this contract: £671,344
    Summary of Funding – Page 1
    """

    # There shouldn't be a T&C document                
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (HEI)
    """

    # There shouldn't be a Sch1 document                
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There shouldn't be a Sch2 document                
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """

    # There shouldn't be a Funding Agreement for Loans Facility           
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

    # There shouldn't be a Funding Agreement for Loans Bursary (either of them)
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Bursary
    """

    # There shouldn't be a Funding Agreement for 19-24 Traineeships
    And   the pdf file does not contain the following text
    """
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    """

    # There shouldn't be a Funding Agreement for ASCL
    And   the pdf file does not contain the following text
    """
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    """

    # There shouldn't be a Funding Agreement for NSF
    And   the pdf file does not contain the following text
    """
    Funding Agreement – ESFA AEB - National Skills Fund
    """

    # There shouldn't be a Funding Agreement for STFI
    And   the pdf file does not contain the following text
    """
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    """

    # There shouldn't be a Funding Agreement for Apps Carry-In
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Apprenticeships Carry-In
    """

    # There shouldn't be a Funding Agreement for 16-18 Traineeships
    And   the pdf file does not contain the following text
    """
    Funding Agreement – 16 to 18 Traineeships
    """

    # There shouldn't be a Sch3ON document
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-07-06 09:12:35.000 |  





    # Publish then withdraw the contract

    Given the override date is '07/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'Provider request' by 'FCS2 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017643 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017643 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017643 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Update the template timestamp for S3ON
    
    Given the override date is '08/07/2021'

    # Simulate the arrival of a 'new' S3ON template by updating the template timestamp (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2122_S3ON_COFG_LA_TRUST_HEI_2021-08-01.docx | 2021-07-08 11:41:22.000 | 


    
 
 
    # Execute a NON-FINANCIAL variation amendment 

    # Change the date
    Given the override date is '09/07/2020'

    # Issue a non-financial VARIATION amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check CRM state then check docs

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017643 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017643 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017643 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017643 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017643' for FundingType 'EDSK' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017643' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices (SoF and Sch3ON)
    Then  the file named '10017643_[ContractNo]_v3.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017643 Co Ltd UKPRN: 10017643
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £28,065 £23,820 £51,885
    Advanced Learner Loans Bursary [AllocRef_ALLB] £31,579 £6,648 £38,227
    Advanced Learner Loans Bursary [AllocRef_ALLC] £38,947 £18,142 £57,089
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £34,605 £15,163 £49,768
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £70,258 £35,138 £105,396
    of which Community Learning £36,519 £24,383 £60,902
    ESFA AEB - National Skills Fund [AllocRef_NSFC] £42,119 £12,025 £54,144
    of which Level 3 Offer for 24 year olds and over £42,119 £12,025 £54,144
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £123,123 £61,516 £184,639
    of which Short Term Funding Initiative 1 £26,691 £11,206 £37,897
    of which Short Term Funding Initiative 2 £35,653 £18,607 £54,260
    of which Short Term Funding Initiative 3 £27,095 £20,167 £47,262
    of which Short Term Funding Initiative 4 £33,684 £11,536 £45,220
    Apprenticeships Carry-In [AllocRef_APPS] £25,584 £13,572 £39,156
    16 to 18 Traineeships [AllocRef_16TR] £59,653 £31,387 £91,040
    Total Funding for this contract: £671,344
    Summary of Funding – Page 1

    SCHEDULE 3: NOT USED
    """

    # There shouldn't be a T&C document                
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (HEI)
    """

    # There shouldn't be a Sch1 document                
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There shouldn't be a Sch2 document                
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """

    # There shouldn't be a Funding Agreement for Loans Facility           
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

    # There shouldn't be a Funding Agreement for Loans Bursary (either of them)
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Bursary
    """

    # There shouldn't be a Funding Agreement for 19-24 Traineeships
    And   the pdf file does not contain the following text
    """
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    """

    # There shouldn't be a Funding Agreement for ASCL
    And   the pdf file does not contain the following text
    """
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    """

    # There shouldn't be a Funding Agreement for NSF
    And   the pdf file does not contain the following text
    """
    Funding Agreement – ESFA AEB - National Skills Fund
    """

    # There shouldn't be a Funding Agreement for STFI
    And   the pdf file does not contain the following text
    """
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    """

    # There shouldn't be a Funding Agreement for Apps Carry-In
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Apprenticeships Carry-In
    """

    # There shouldn't be a Funding Agreement for 16-18 Traineeships
    And   the pdf file does not contain the following text
    """
    Funding Agreement – 16 to 18 Traineeships
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 3                     | 0                        | 2021-07-09 09:12:35.000 |  


    # Tidy Up
    And   the override date is reset 
        
@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run67
Scenario: A644 Bulk load a new 2122 EDSK contract with one Contracting and two Delivery Orgs. Funding shared between 16-18TRN, AEBC-19TRN, AEBC-NSF and APPS allocs. Check docs and CRM
    
    # 1. Bulk load new 2122 EDSK contract with three Orgs
    #      Contracting Org has 16-18TRN, AEBC-19TRN, AEBC-NSF and APPS allocations
    #      Delivery Org 1 has 16-18TRN, AEBC-19TRN and APPS allocations
    #      Delivery Org 2 has 16-18TRN, AEBC-19TRN and AEBC-NSF allocations
    # 2. Check doc parts and docs
    # 3. Publish and approve
    # 4. Check CRM  
    
    Given there are no allocations marked as Under Termination for UKPRN '10017644' 
    And   there are no terminated or closed allocations for UKPRN '10017644' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017644' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017644' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017644' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

     # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2122      |
    | AEBC-19TRN2122    |
    | AEBC-NSF2122      |
    | APPS2122          |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017644'

    # Set the 'base' timestamp for each of the 21\22 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_EDSK_2021-08-01.docx                        | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_TAC_CFS_ITP_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_COLLEGE_2021-08-01.docx       | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_EMPLOYER_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_HEI_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_LA_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_NMSS_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_SPI_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_TRUST_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S1_1618TRN_CFS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1618TRN_COFG_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_HEI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_ITP_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_LA_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_NMSS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_1619ED_SPI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_AEB_COFG_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_APPS_COLLEGE_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_APPS_OTHER_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S2_1618TRN_CFS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1618TRN_COFG_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1619ED_CFS_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_1619ED_COFG_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_AEB_COFG_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_APPS_COLLEGE_2021-08-01.docx        | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_APPS_OTHER_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | FA_EDSK2122_2021-08-01.docx                     | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S3ON_CFS_ITP_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_EMPLOYER_2021-08-01.docx     | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_LA_TRUST_HEI_2021-08-01.docx | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_NMSS_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_SPI_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017644' 
    And   there is no Organisation data for UKPRN '10040208' 
    And   there is no Organisation data for UKPRN '10040240' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10017644 Co Ltd' with UKPRN '10017644' and OrgId 'ORG0017644' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017644' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017644 | 117644 | 10017644 Co Ltd | 0              | In Administration     | Yes           | AA017644      | ?             | 37a Star Street        | ?                      | ?                      | ?                      | Ware                   | Hertfordshire          | SG12 7AA  |
    | 10040208 | 140208 | 10040208 Co Ltd | 0              | In Administration     | Yes           | AA040208      | ?             | 37b Star Street        | ?                      | ?                      | ?                      | Ware                   | Hertfordshire          | SG12 7AA  |
    | 10040240 | 140240 | 10040240 Co Ltd | 0              | In Administration     | Yes           | AA040240      | ?             | 37c Star Street        | ?                      | ?                      | ?                      | Ware                   | Hertfordshire          | SG12 7AA  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017644 |
    | 10040208 |
    | 10040240 |





    # Change the date
    Given the override date is '01/07/2021'

    # Bulk file to create new EDSK contract with two Delivery Orgs
    And   there are no files prefixed '10017644' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 22062021104106 v3_A644' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 22062021104106 v3_A644' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 22062021104106 v3_A644' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 22062021104106 v3_A644' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 22062021104106 v3_A644.xlsx' exists in the Datafiles folder and UKPRN '10017644' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017644' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017644'
    When  I retrieve the latest contract details from CRM for provider '10017644' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices for expected document parts
    Then  the file named '10017644_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING 2021/22
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017644 Co Ltd
    ESFA-Funded Adult Education Budget
    Funding for Apprenticeships Carry-In
    16 to 18 Traineeships
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017644 Co Ltd THE SECRETARY OF STATE FOR
    37a Star Street EDUCATION
    Ware DEPARTMENT FOR EDUCATION
    Hertfordshire AND 20 GREAT SMITH STREET
    SG12 7AA LONDON
    SW1P 3BT
    Company No: AA017644
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 79
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2021) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2021) – Page 8
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
    EDSK Schedule 1 – Apprenticeships Carry-In Version 1 (July 2021) – Page 1
    EDSK Schedule 1 – Apprenticeships Carry-In Version 1 (July 2021) – Page 8
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 2 (December 2021) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships Version 2 (December 2021) – Page 6
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10040208 Co Ltd UKPRN: 10040208
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10040240 Co Ltd UKPRN: 10040240
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - National Skills Fund
    Provider: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - National Skills Fund
    Provider: 10040240 Co Ltd UKPRN: 10040240
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    
    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN
    EDSK Schedule 2 – Apprenticeships Carry-In Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    
    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10040208 Co Ltd UKPRN: 10040208
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
   
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10040208 Co Ltd UKPRN: 10040208
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
   
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10040240 Co Ltd UKPRN: 10040240
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (July 2021) – Page 1
    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (July 2021) – Page 1
    SCHEDULE 6: UK GDPR AND DATA PROTECTION
    EDSK Schedule 6 Version 2 (July 2021) – Page 1
    EDSK Schedule 6 Version 2 (July 2021) – Page 2
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 2 (July 2021) – Page 1
    EDSK Schedule 7 Version 2 (July 2021) – Page 8
    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 2 (July 2021) – Page 1
    EDSK Schedule 8 Version 2 (July 2021) – Page 5
    SCHEDULE 9: COLLEGE GOVERNANCE
    EDSK Schedule 9 Version 2 (July 2021) – Page 1
    EDSK Schedule 9 Version 2 (July 2021) – Page 5
    SCHEDULE 10: SUB-CONTRACTING
    EDSK Schedule 10 Version 2 (July 2021) – Page 1
    EDSK Schedule 10 Version 2 (July 2021) – Page 5
    """

    # Retrieve parameters
    When  I retrieve the latest EFA contract details from CRM for provider '10017644' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10017644'
   #When  I retrieve the latest contract details from CRM for provider '10017644' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices for Contracting Org 10017644
    Then  the file named '10017644_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    ESFA AEB - 19 to 24 Traineeships
    10017644 Co Ltd [AllocRef_AECT] £37,822 £18,030 £55,852
    ESFA AEB - National Skills Fund
    10017644 Co Ltd [AllocRef_NSFC] £29,426 £9,049 £38,475
    of which Level 3 Offer for 24 year olds and over £29,426 £9,049 £38,475
    Apprenticeships Carry-In
    10017644 Co Ltd [AllocRef_APPS] £48,396 £4,135 £52,531
    16 to 18 Traineeships
    10017644 Co Ltd [AllocRef_16TR] £58,749 £20,470 £79,219
    Total Funding for this contract: £595,106
    Summary of Funding – Page 1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - 19 to 24 Traineeships £55,852 £4,040 £7,522 £2,916 £6,673 £7,575 £6,981 £813 £1,302 £3,563 £6,843 £7,066 £558
    Total Funding £55,852 £4,040 £7,522 £2,916 £6,673 £7,575 £6,981 £813 £1,302 £3,563 £6,843 £7,066 £558
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  [ContractNo] v1    
      
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - National Skills Fund
    Provider: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_NSFC]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Level 3 Offer for 24 year olds and over £38,475 £5,169 £4,373 £923 £3,321 £349 £3,427 £6,367 £5,497 £3,884 £774 £2,153 £2,238
    Total Funding £38,475 £5,169 £4,373 £923 £3,321 £349 £3,427 £6,367 £5,497 £3,884 £774 £2,153 £2,238
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_NSFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
      
    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Apprenticeships Carry-In £52,531 £5,711 £2,252 £7,910 £6,838 £7,942 £4,630 £6,615 £6,498 £1,010 £1,183 £1,608 £334
    Total Funding £52,531 £5,711 £2,252 £7,910 £6,838 £7,942 £4,630 £6,615 £6,498 £1,010 £1,183 £1,608 £334
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1
       
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16 to 18 Traineeships Programme Funding £37,471 £1,745 £7,945 £3,136 £1,660 £248 £2,372 £3,953 £1,320 £1,268 £7,265 £5,174 £1,385
    16 to 18 Traineeships Bursary Funding £41,748 £4,802 £6,723 £960 £6,076 £790 £6,586 £7,212 £3,221 £1,405 £1,013 £79 £2,881
    Total Funding £79,219 £6,547 £14,668 £4,096 £7,736 £1,038 £8,958 £11,165 £4,541 £2,673 £8,278 £5,253 £4,266
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Retrieve parameters
    When  I retrieve the latest EFA contract details from CRM for provider '10017644' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10040208'
   #When  I retrieve the latest contract details from CRM for provider '10017644' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices for Delivery Org 10040208
    Then  the file named '10017644_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    ESFA AEB - 19 to 24 Traineeships
    10040208 Co Ltd [AllocRef_AECT] £38,604 £18,205 £56,809
    Apprenticeships Carry-In
    10040208 Co Ltd [AllocRef_APPS] £48,995 £4,233 £53,228
    16 to 18 Traineeships
    10040208 Co Ltd [AllocRef_16TR] £60,371 £21,489 £81,860
    Total Funding for this contract: £595,106
    Summary of Funding – Page 1
   
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10040208 Co Ltd UKPRN: 10040208
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - 19 to 24 Traineeships £56,809 £4,039 £7,583 £3,089 £6,763 £7,754 £7,113 £870 £1,393 £3,692 £6,862 £7,066 £585
    Total Funding £56,809 £4,039 £7,583 £3,089 £6,763 £7,754 £7,113 £870 £1,393 £3,692 £6,862 £7,066 £585
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10040208 Co Ltd UKPRN: 10040208
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Apprenticeships Carry-In £53,228 £5,862 £2,239 £7,903 £6,984 £8,076 £4,690 £6,613 £6,628 £987 £1,225 £1,642 £379
    Total Funding £53,228 £5,862 £2,239 £7,903 £6,984 £8,076 £4,690 £6,613 £6,628 £987 £1,225 £1,642 £379
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10040208 Co Ltd UKPRN: 10040208
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16 to 18 Traineeships Programme Funding £39,179 £1,942 £8,141 £3,299 £1,735 £360 £2,536 £4,144 £1,340 £1,343 £7,421 £5,358 £1,560
    16 to 18 Traineeships Bursary Funding £42,681 £4,901 £6,715 £967 £6,168 £913 £6,561 £7,327 £3,322 £1,410 £1,163 £245 £2,989
    Total Funding £81,860 £6,843 £14,856 £4,266 £7,903 £1,273 £9,097 £11,471 £4,662 £2,753 £8,584 £5,603 £4,549
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Retrieve parameters
    When  I retrieve the latest EFA contract details from CRM for provider '10017644' for FundingType 'EDSK' and period '2122' and Delivery Organisation '10040240'
   #When  I retrieve the latest contract details from CRM for provider '10017644' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices for Delivery Org 10040240
    Then  the file named '10017644_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017644 Co Ltd UKPRN: 10017644
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    ESFA AEB - 19 to 24 Traineeships
    10040240 Co Ltd [AllocRef_AECT] £38,291 £18,266 £56,557
    ESFA AEB - National Skills Fund
    10040240 Co Ltd [AllocRef_NSFC] £30,201 £9,575 £39,776
    of which Level 3 Offer for 24 year olds and over £30,201 £9,575 £39,776
    16 to 18 Traineeships
    10040240 Co Ltd [AllocRef_16TR] £59,778 £21,021 £80,799
    Total Funding for this contract: £595,106
    Summary of Funding – Page 1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10040240 Co Ltd UKPRN: 10040240
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - 19 to 24 Traineeships £56,557 £4,098 £7,607 £2,953 £6,745 £7,673 £7,014 £889 £1,312 £3,583 £7,018 £7,048 £617
    Total Funding £56,557 £4,098 £7,607 £2,953 £6,745 £7,673 £7,014 £889 £1,312 £3,583 £7,018 £7,048 £617
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - National Skills Fund
    Provider: 10040240 Co Ltd UKPRN: 10040240
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_NSFC]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Level 3 Offer for 24 year olds and over £39,776 £5,332 £4,458 £999 £3,417 £353 £3,471 £6,540 £5,631 £4,052 £842 £2,270 £2,411
    Total Funding £39,776 £5,332 £4,458 £999 £3,417 £353 £3,471 £6,540 £5,631 £4,052 £842 £2,270 £2,411
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_NSFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10040240 Co Ltd UKPRN: 10040240
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16 to 18 Traineeships Programme Funding £38,256 £1,746 £7,979 £3,253 £1,636 £338 £2,395 £4,108 £1,357 £1,377 £7,438 £5,235 £1,394
    16 to 18 Traineeships Bursary Funding £42,543 £4,994 £6,718 £936 £6,231 £909 £6,573 £7,198 £3,407 £1,403 £991 £108 £3,075
    Total Funding £80,799 £6,740 £14,697 £4,189 £7,867 £1,247 £8,968 £11,306 £4,764 £2,780 £8,429 £5,343 £4,469
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017644_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A644.pdf'
   #And   Sharepoint file '<filename1.pdf>' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A644.pdf'

    # Display Sharepoint filename
    And   message '10017644_[ContractNo]_v1.pdf' is written to the Output window





    # Publish and approve the contract
    
    # Change the date
    Given the override date is '03/07/2021'
    
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
    | 10017644 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017644 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    And   the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '888' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


    # Tidy Up
    Given the override date is reset    

