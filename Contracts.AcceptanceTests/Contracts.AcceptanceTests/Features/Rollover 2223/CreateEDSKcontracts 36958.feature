Feature: CreateEDSKcontracts 36958

@AcceptanceTest @Withdrawn25072024
@Long2Run @Long2Run123
Scenario: A386 Bulk load a new draft EDSK2223 contract with several FSPs. Import 1619ED2223 FA from CFS. CofG_College. Publish and approve. Check docs, CRM PaaS and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017386' 
    And   there are no terminated or closed allocations for UKPRN '10017386' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017386' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017386' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables
 
    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                             |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (College)  |
    
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
    
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017386' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2223      |
    | 16-18TRN-ME2223   |
    | AEBC-19TRN2223    |
    | AEBC-ASCL2223     |
    | AEBC-NSF2223      |
    | STFIC2223         |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017386'

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
    Given there is no Organisation data in CRM for UKPRN '10017386' 
    And   there is no caseload advisor for UKPRN '10017386' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017386 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017386' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017386 Co Ltd' with UKPRN '10017386' and OrgId 'ORG0017386' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017386 | 117386 | 10017386 Co Ltd | 0              | In Administration     | Yes           | AA017386      | ?             | 9 Ronaldshaw Park      | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 2TJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017386 |





    # Change the date
    Given the override date is '16/07/2022'

    # Bulk file for new [Conditions of Funding (Grant) (College)] contract
    And   there are no files prefixed '10017386' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 13062022105948 v3_A386' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 13062022105948 v3_A386' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 13062022105948 v3_A386' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 13062022105948 v3_A386' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 13062022105948 v3_A386.xlsx' exists in the Datafiles folder and UKPRN '10017386' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017386' for FundingType 'EDSK' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017386' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017386_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £25,775 £12,005 £37,780
    Advanced Learner Loans Bursary [AllocRef_ALLB] £40,174 £21,996 £62,170
    Advanced Learner Loans Bursary [AllocRef_ALLC] £39,233 £6,808 £46,041
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £34,508 £16,372 £50,880
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £71,601 £22,112 £93,713
    of which Community Learning £38,013 £9,119 £47,132
    ESFA AEB - National Skills Fund [AllocRef_NSFC] £35,396 £12,593 £47,989
    of which Level 3 Free Courses for Jobs £35,396 £12,593 £47,989
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £145,975 £62,071 £208,046
    of which Short Term Funding Initiative 1 £24,544 £10,335 £34,879
    of which Short Term Funding Initiative 2 £44,872 £16,523 £61,395
    of which Short Term Funding Initiative 3 £39,236 £20,599 £59,835
    of which Short Term Funding Initiative 4 £37,323 £14,614 £51,937
    16 to 18 Traineeships [AllocRef_16TR] £55,249 £22,694 £77,943
    16 to 18 Traineeships [AllocRef_16TM] £48,366 £33,291 £81,657
    Total Funding for this contract: £706,219
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017386 Co Ltd
    Advanced Learner Loans
    Funding for ESFA-Funded Adult Education Budget
    16 to 18 Traineeships
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE COLLEGE
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 3 (November 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017386 Co Ltd THE SECRETARY OF STATE FOR
    9 Ronaldshaw Park EDUCATION
    Ayr DEPARTMENT FOR EDUCATION
    AND
    KA7 2TJ 20 GREAT SMITH STREET
    LONDON
    SW1P 3BT
    Company No: AA017386
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
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY) SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (July 2022) – Page 1
    Outputs
    11.The College will deliver the eligible Provision from Find a learning aim as
    set out in the ESFA AEB Funding Rules and, where appropriate, to the
    requirements set by the Awarding Organisations between 1 December
    2022 and 31 July 2023.
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (July 2022) – Page 2
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (July 2022) – Page 6
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2022) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2022) – Page 2
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Facility £37,780 £6,510 £2,041 £5,385 £1,192 £2,094 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
    Total Funding £37,780 £6,510 £2,041 £5,385 £1,192 £2,094 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Bursary Funding £62,170 £6,951 £5,200 £391 £6,866 £5,454 £7,578 £1,208 £6,526 £6,969 £5,016 £2,925 £7,086
    Total Funding £62,170 £6,951 £5,200 £391 £6,866 £5,454 £7,578 £1,208 £6,526 £6,969 £5,016 £2,925 £7,086
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Bursary Funding £46,041 £5,160 £7,081 £1,318 £6,434 £1,148 £6,943 £7,570 £3,579 £1,763 £1,370 £436 £3,239
    Total Funding £46,041 £5,160 £7,081 £1,318 £6,434 £1,148 £6,943 £7,570 £3,579 £1,763 £1,370 £436 £3,239
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - 19 to 24 Traineeships £50,880 £279 £1,044 £6,702 £5,630 £6,734 £3,422 £5,407 £5,290 £7,753 £364 £789 £7,466
    Total Funding £50,880 £279 £1,044 £6,702 £5,630 £6,734 £3,422 £5,407 £5,290 £7,753 £364 £789 £7,466
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Adult Skills and Community Learning £93,713 £8,518 £8,891 £13,614 £7,394 £8,041 £8,211 £7,702 £9,230 £4,644 £4,612 £6,820 £6,036
    of which Community Learning £47,132 £3,070 £1,117 £6,977 £3,187 £6,605 £6,415 £2,763 £7,879 £2,593 £438 £1,064 £5,024
    Total Funding £93,713 £8,518 £8,891 £13,614 £7,394 £8,041 £8,211 £7,702 £9,230 £4,644 £4,612 £6,820 £6,036
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - National Skills Fund
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_NSFC]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Level 3 Free Courses for Jobs £47,989 £5,449 £7,169 £6,234 £1,086 £629 £4,111 £7,456 £3,262 £2,052 £1,458 £3,241 £5,842
    Total Funding £47,989 £5,449 £7,169 £6,234 £1,086 £629 £4,111 £7,456 £3,262 £2,052 £1,458 £3,241 £5,842
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_NSFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_STFC]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Short Term Funding Initiative 1 £34,879 £5,991 £1,320 £7,382 £875 £4,495 £3,698 £248 £535 £5,514 £641 £1,469 £2,711
    ESFA AEB - Short Term Funding Initiative 2 £61,395 £1,098 £5,938 £7,318 £7,403 £7,148 £7,912 £3,508 £4,547 £5,651 £2,339 £4,325 £4,208
    ESFA AEB - Short Term Funding Initiative 3 £59,835 £6,671 £7,233 £7,658 £6,384 £2,254 £4,580 £3,443 £1,013 £6,193 £6,553 £1,745 £6,108
    ESFA AEB - Short Term Funding Initiative 4 £51,937 £6,808 £980 £450 £5,769 £7,827 £3,762 £3,783 £7,944 £1,300 £3,221 £7,520 £2,573
    Total Funding £208,046 £20,568 £15,471 £22,808 £20,431 £21,724 £19,952 £10,982 £14,039 £18,658 £12,754 £15,059 £15,600
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_STFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    5. The Department will pay the College on the 16 Working Day of each month.
    EDSK Schedule 2 – 16 to 18 Traineeships Version 2 (February 2023) – Page 1

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16 to 18 Traineeships Programme Funding £32,857 £2,023 £272 £3,414 £1,938 £527 £2,650 £4,231 £1,598 £1,546 £7,543 £5,452 £1,663
    16 to 18 Traineeships Bursary Funding £45,086 £5,080 £7,002 £1,238 £6,354 £1,068 £6,864 £7,491 £3,499 £1,683 £1,291 £357 £3,159
    Total Funding £77,943 £7,103 £7,274 £4,652 £8,292 £1,595 £9,514 £11,722 £5,097 £3,229 £8,834 £5,809 £4,822
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY)
    5. The Department will pay the College on the 16 Working Day of each month.
    EDSK Schedule 2 – 16 to 18 Traineeships Version 2 (Market Entry) (February 2023) – Page 1

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16TM]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16 to 18 Traineeships Programme Funding £36,826 £6,430 £1,961 £5,306 £1,112 £2,014 £1,420 £3,203 £3,692 £5,953 £1,282 £1,505 £2,948
    16 to 18 Traineeships Bursary Funding £44,831 £4,456 £3,660 £210 £2,609 £5,475 £602 £3,543 £2,673 £1,059 £5,900 £7,280 £7,364
    Total Funding £81,657 £10,886 £5,621 £5,516 £3,721 £7,489 £2,022 £6,746 £6,365 £7,012 £7,182 £8,785 £10,312
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TM] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
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
    | [ContractNo]   | 1                     | 0                        | 2022-07-16 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017386_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A386.pdf'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017386 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017386 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Part 2: Import a Funding Allocation for 1619ED

    # Populate the stub with 1619 (Further education) data

    # Change the date 
    Given the override date is '21/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017386 | 1619-AS-2223-Contract-Provider-10017386-1_7           | 1_7            | 1619                        | AS-2223            | 85295.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | 1619-AS-2223-10017386-1_7  | 1_7                    | 1619-AS-2223-Contract-Provider-10017386-1_7           | 10017386      | Colleges                           | Further education                | 85295.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2223-10017386-1_7  | 1619-005        | 7545.00          | Payment         |
    | 1619-AS-2223-10017386-1_7  | 1619-006        | 25383.00         | Payment         |
    | 1619-AS-2223-10017386-1_7  | 1619-010        | 22750.00         | Payment         |
    | 1619-AS-2223-10017386-1_7  | 1619-011        | 21319.00         | Payment         |
    | 1619-AS-2223-10017386-1_7  | 1619-025        | 8298.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2223-10017386-1_7  | 1619-005        | FY-2223              | August                 | 2022              | 3153.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-005        | FY-2223              | May                    | 2023              | 4392.00                   |
    #
    | 1619-AS-2223-10017386-1_7  | 1619-006        | FY-2223              | September              | 2022              | 2236.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-006        | FY-2223              | November               | 2022              | 3716.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-006        | FY-2223              | December               | 2022              | 4341.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-006        | FY-2223              | March                  | 2023              | 3529.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-006        | FY-2223              | April                  | 2023              | 5965.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-006        | FY-2223              | July                   | 2023              | 5596.00                   |
    #
    | 1619-AS-2223-10017386-1_7  | 1619-010        | FY-2223              | October                | 2022              | 4424.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-010        | FY-2223              | November               | 2022              | 3713.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-010        | FY-2223              | February               | 2023              | 4782.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-010        | FY-2223              | April                  | 2023              | 5578.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-010        | FY-2223              | June                   | 2023              | 4253.00                   |
    #
    | 1619-AS-2223-10017386-1_7  | 1619-011        | FY-2223              | September              | 2022              | 4589.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-011        | FY-2223              | November               | 2022              | 5486.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-011        | FY-2223              | March                  | 2023              | 2794.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-011        | FY-2223              | April                  | 2023              | 3931.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-011        | FY-2223              | June                   | 2023              | 4519.00                   |
    #
    | 1619-AS-2223-10017386-1_7  | 1619-025        | FY-2223              | August                 | 2022              | 4966.00                   |
    | 1619-AS-2223-10017386-1_7  | 1619-025        | FY-2223              | April                  | 2023              | 3332.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '23/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017386 | 10017386 Co Ltd  | 1619-AS-2223-Contract-Provider-10017386-1_7             | 1_7            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2223     | Scheduling        | Awaiting Release  | 85295.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2223-Contract-Provider-10017386-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 85295.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017386 | 1619-AS-2223-Contract-Provider-10017386-1_7             | 1_7            | AS-2223 | 1619                        | 85295.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '25/07/2022'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 85295.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017386' for FundingType 'EDSK' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017386' for FundingType 'EDSK' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017386 | 10017386 Co Ltd  | 1619-AS-2223-Contract-Provider-10017386-1_7             | 1_7            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2223     | Released          | Released          | 85295.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2223-Contract-Provider-10017386-1_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2223-Contract-Provider-10017386-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017386 | 1619-AS-2223-Contract-Provider-10017386-1_7             | 1_7            | AS-2223 | 1619                        | 85295.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2223-Contract-Provider-10017386-1_7             | [ContractNo] | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017386 | [ContractNo]       | 1                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017386 | [ContractNo]       | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017386 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017386 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 791514.00     | 1                     | 1                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2223 | ?               | 10017386 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017386 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017386 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017386 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 85295.00        | ?             | ?                | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 7545.00   | 3153.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4392.00  | 0.00     | 0.00     | 16-19 Free Meals                                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 25383.00  | 0.00     | 2236.00  | 0.00     | 3716.00  | 4341.00  | 0.00     | 0.00     | 3529.00  | 5965.00  | 0.00     | 0.00     | 5596.00  | 16-19 High Needs Element 2                                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 22750.00  | 0.00     | 0.00     | 4424.00  | 3713.00  | 0.00     | 0.00     | 4782.00  | 0.00     | 5578.00  | 0.00     | 4253.00  | 0.00     | Teacher's Pension Scheme 1619                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 21319.00  | 0.00     | 4589.00  | 0.00     | 5486.00  | 0.00     | 0.00     | 0.00     | 2794.00  | 3931.00  | 0.00     | 4519.00  | 0.00     | Alternative Completions - Sporting Excellence               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 143             | 8298.00   | 4966.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3332.00  | 0.00     | 0.00     | 0.00     | 16-19 Tuition Fund                                          |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '288' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017386_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £25,775 £12,005 £37,780
    Advanced Learner Loans Bursary [AllocRef_ALLB] £40,174 £21,996 £62,170
    Advanced Learner Loans Bursary [AllocRef_ALLC] £39,233 £6,808 £46,041
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £34,508 £16,372 £50,880
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £71,601 £22,112 £93,713
    of which Community Learning £38,013 £9,119 £47,132
    ESFA AEB - National Skills Fund [AllocRef_NSFC] £35,396 £12,593 £47,989
    of which Level 3 Free Courses for Jobs £35,396 £12,593 £47,989
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £145,975 £62,071 £208,046
    of which Short Term Funding Initiative 1 £24,544 £10,335 £34,879
    of which Short Term Funding Initiative 2 £44,872 £16,523 £61,395
    of which Short Term Funding Initiative 3 £39,236 £20,599 £59,835
    of which Short Term Funding Initiative 4 £37,323 £14,614 £51,937
    16 to 18 Traineeships [AllocRef_16TR] £55,249 £22,694 £77,943
    16 to 18 Traineeships [AllocRef_16TM] £48,366 £33,291 £81,657
    16 to 19 Education [AllocRef_16ED] £47,729 £37,566 £85,295
    Total Funding for this contract: £791,514
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017386 Co Ltd
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
    10017386 Co Ltd THE SECRETARY OF STATE FOR
    9 Ronaldshaw Park EDUCATION
    Ayr DEPARTMENT FOR EDUCATION
    AND
    KA7 2TJ 20 GREAT SMITH STREET
    LONDON
    SW1P 3BT
    Company No: AA017386
    Hereinafter called Hereinafter called
    the College the Department
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
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY) SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (July 2022) – Page 6
    
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
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Facility £37,780 £6,510 £2,041 £5,385 £1,192 £2,094 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
    Total Funding £37,780 £6,510 £2,041 £5,385 £1,192 £2,094 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Bursary Funding £62,170 £6,951 £5,200 £391 £6,866 £5,454 £7,578 £1,208 £6,526 £6,969 £5,016 £2,925 £7,086
    Total Funding £62,170 £6,951 £5,200 £391 £6,866 £5,454 £7,578 £1,208 £6,526 £6,969 £5,016 £2,925 £7,086
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Bursary Funding £46,041 £5,160 £7,081 £1,318 £6,434 £1,148 £6,943 £7,570 £3,579 £1,763 £1,370 £436 £3,239
    Total Funding £46,041 £5,160 £7,081 £1,318 £6,434 £1,148 £6,943 £7,570 £3,579 £1,763 £1,370 £436 £3,239
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - 19 to 24 Traineeships £50,880 £279 £1,044 £6,702 £5,630 £6,734 £3,422 £5,407 £5,290 £7,753 £364 £789 £7,466
    Total Funding £50,880 £279 £1,044 £6,702 £5,630 £6,734 £3,422 £5,407 £5,290 £7,753 £364 £789 £7,466
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Adult Skills and Community Learning £93,713 £8,518 £8,891 £13,614 £7,394 £8,041 £8,211 £7,702 £9,230 £4,644 £4,612 £6,820 £6,036
    of which Community Learning £47,132 £3,070 £1,117 £6,977 £3,187 £6,605 £6,415 £2,763 £7,879 £2,593 £438 £1,064 £5,024
    Total Funding £93,713 £8,518 £8,891 £13,614 £7,394 £8,041 £8,211 £7,702 £9,230 £4,644 £4,612 £6,820 £6,036
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - National Skills Fund
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_NSFC]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Level 3 Free Courses for Jobs £47,989 £5,449 £7,169 £6,234 £1,086 £629 £4,111 £7,456 £3,262 £2,052 £1,458 £3,241 £5,842
    Total Funding £47,989 £5,449 £7,169 £6,234 £1,086 £629 £4,111 £7,456 £3,262 £2,052 £1,458 £3,241 £5,842
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_NSFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_STFC]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Short Term Funding Initiative 1 £34,879 £5,991 £1,320 £7,382 £875 £4,495 £3,698 £248 £535 £5,514 £641 £1,469 £2,711
    ESFA AEB - Short Term Funding Initiative 2 £61,395 £1,098 £5,938 £7,318 £7,403 £7,148 £7,912 £3,508 £4,547 £5,651 £2,339 £4,325 £4,208
    ESFA AEB - Short Term Funding Initiative 3 £59,835 £6,671 £7,233 £7,658 £6,384 £2,254 £4,580 £3,443 £1,013 £6,193 £6,553 £1,745 £6,108
    ESFA AEB - Short Term Funding Initiative 4 £51,937 £6,808 £980 £450 £5,769 £7,827 £3,762 £3,783 £7,944 £1,300 £3,221 £7,520 £2,573
    Total Funding £208,046 £20,568 £15,471 £22,808 £20,431 £21,724 £19,952 £10,982 £14,039 £18,658 £12,754 £15,059 £15,600
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_STFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    EDSK Schedule 2 – 16 to 18 Traineeships Version 2 (February 2023) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16 to 18 Traineeships Programme Funding £32,857 £2,023 £272 £3,414 £1,938 £527 £2,650 £4,231 £1,598 £1,546 £7,543 £5,452 £1,663
    16 to 18 Traineeships Bursary Funding £45,086 £5,080 £7,002 £1,238 £6,354 £1,068 £6,864 £7,491 £3,499 £1,683 £1,291 £357 £3,159
    Total Funding £77,943 £7,103 £7,274 £4,652 £8,292 £1,595 £9,514 £11,722 £5,097 £3,229 £8,834 £5,809 £4,822
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY)
    EDSK Schedule 2 – 16 to 18 Traineeships Version 2 (Market Entry) (February 2023) – Page 1


    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16TM]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16 to 18 Traineeships Programme Funding £36,826 £6,430 £1,961 £5,306 £1,112 £2,014 £1,420 £3,203 £3,692 £5,953 £1,282 £1,505 £2,948
    16 to 18 Traineeships Bursary Funding £44,831 £4,456 £3,660 £210 £2,609 £5,475 £602 £3,543 £2,673 £1,059 £5,900 £7,280 £7,364
    Total Funding £81,657 £10,886 £5,621 £5,516 £3,721 £7,489 £2,022 £6,746 £6,365 £7,012 £7,182 £8,785 £10,312
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TM] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017386 Co Ltd UKPRN: 10017386
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16-19 High Needs Element 2 £25,383 £0.00 £2,236.00 £0.00 £3,716.00 £4,341.00 £0.00 £0.00 £3,529.00 £5,965.00 £0.00 £0.00 £5,596.00
    16-19 Free Meals £7,545 £3,153.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £4,392.00 £0.00 £0.00
    Alternative Completions - Sporting Excellence £21,319 £0.00 £4,589.00 £0.00 £5,486.00 £0.00 £0.00 £0.00 £2,794.00 £3,931.00 £0.00 £4,519.00 £0.00
    Teacher's Pension Scheme 1619 £22,750 £0.00 £0.00 £4,424.00 £3,713.00 £0.00 £0.00 £4,782.00 £0.00 £5,578.00 £0.00 £4,253.00 £0.00
    16-19 Tuition Fund £8,298 £4,966.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,332.00 £0.00 £0.00 £0.00
    Total Funding £85,295 £8,119.00 £6,825.00 £4,424.00 £12,915.00 £4,341.00 £0.00 £4,782.00 £6,323.00 £18,806.00 £4,392.00 £8,772.00 £5,596.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
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

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017386_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A386a.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 1                        | 2022-07-25 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017386'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017386 - 10017386 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017386 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017386 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017386 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '27/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017386_[ContractNo]_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017386 | [ContractNo]       | 1                     | 1                        | Draft            | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017386 | [ContractNo]       | 1                     | 0                        | Superseded Draft | ?                       | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017386 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |




    # Approve the contract

    # Change the date 
    Given the override date is '29/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017386 | [ContractNo]       | 1                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017386 | [ContractNo]       | 1                     | 0                        | Superseded Draft | ?                       | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017386 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017386 | 10017386 Co Ltd  | 1619-AS-2223-Contract-Provider-10017386-1_7             | 1_7            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2223     | Contract Approved | Contract Approved | 85295.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017386 | 1619-AS-2223-Contract-Provider-10017386-1_7             | 1_7            | AS-2223 | 1619                        | 85295.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2223-Contract-Provider-10017386-1_7             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017386 | [ContractNo]   | 1               | [AllocRef_16ED]  | 31              | 0                     | 7545.00      | 0             | 0        | 16-19 Free Meals                               | ?                           |
    | 10017386 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 25383.00     | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
    | 10017386 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 22750.00     | 0             | 0        | Teacher's Pension Scheme 1619                  | ?                           |
    | 10017386 | [ContractNo]   | 1               | [AllocRef_16ED]  | 51              | 0                     | 21319.00     | 0             | 0        | Alternative Completions - Sporting Excellence  | ?                           |
    | 10017386 | [ContractNo]   | 1               | [AllocRef_16ED]  | 143             | 0                     | 8298.00      | 0             | 0        | 16-19 Tuition Fund                             | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Complete
@CFS
Scenario: A387 Import, release and approve a UIFSM funding allocation for 22/23 with deliverables 934 and 935. CofG_HEI. Provider Subtype = 'Higher education institutions'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017387'
    And   there is no Funding Allocation data in CRM for UKPRN '10017387'
    And   there is no Contract, Task or Workflow data for UKPRN '10017387'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017387'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017387'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017387' in the Sharepoint 'EDSK-2223-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (HEI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017387' 
    And   there is no caseload advisor for UKPRN '10017387' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017387 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017387' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017387 Co Ltd' with UKPRN '10017387' and OrgId 'ORG0017387' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017387 | 117387 | 10017387 Co Ltd | 0              | Active                | Yes           | AA017387      | ?             | 102 Handside Lane      | ?                      | ?                      | ?                      | Welwyn Garden City     | Hertfordshire          | AL8 6SY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017387 |







    # Populate the stub with UIFSM (Higher education institutions) data

    # Change the date 
    Given the override date is '01/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017387 | UIFSM-AY-2223-Contract-Provider-10017387-3_7          | 3_7            | UIFSM                       | AY-2223            | 40507.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | UIFSM-AY-2223-10017387-3_7 | 3_7                    | UIFSM-AY-2223-Contract-Provider-10017387-3_7          | 10017387      | Universities                       | Higher education institutions    | 40507.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-001       | 28311.00         | Payment         |
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-002       | 12196.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-001       | FY-2223              | August                 | 2022              | 4572.00                   |
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-001       | FY-2223              | November               | 2022              | 4888.00                   |
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-001       | FY-2223              | January                | 2023              | 2879.00                   |
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-001       | FY-2223              | February               | 2023              | 4904.00                   |
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-001       | FY-2223              | April                  | 2023              | 5769.00                   |
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-001       | FY-2223              | July                   | 2023              | 5299.00                   |
    #
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-002       | FY-2223              | August                 | 2022              | 2735.00                   |
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-002       | FY-2223              | February               | 2023              | 5684.00                   |
    | UIFSM-AY-2223-10017387-3_7 | UIFSM-002       | FY-2223              | May                    | 2023              | 3777.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (HEI)     | CofG_HEI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_HEI = [CofG_HEI]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017387 | 10017387 Co Ltd  | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | 3_7            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2223     | Scheduling        | Awaiting Release  | 40507.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_HEI]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 40507.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017387 | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | 3_7            | AY-2223 | UIFSM                       | 40507.00    | [CofG_HEI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2022'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_HEI]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_HEI = [CofG_HEI]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 40507.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017387' for FundingType 'EDSK' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017387' for FundingType 'EDSK' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017387 | 10017387 Co Ltd  | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | 3_7            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2223     | Released          | Released          | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_HEI]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017387 | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | 3_7            | AY-2223 | UIFSM                       | 40507.00    | [CofG_HEI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017387 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017387 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017387 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 40507.00      | 1                     | 0                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2223 | ?               | 10017387 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017387 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Conditions of Funding (Grant) (HEI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017387 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017387 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 40507.00        | ?             | ?                | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 934             | 28311.00  | 4572.00  | 0.00     | 0.00     | 4888.00  | 0.00     | 2879.00  | 4904.00  | 0.00     | 5769.00  | 0.00     | 0.00     | 5299.00  | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    |                          |
    | [ContractNo]   | [AllocRef_16ED] | 935             | 12196.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5684.00  | 0.00     | 0.00     | 3777.00  | 0.00     | 0.00     | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017387_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017387 Co Ltd UKPRN: 10017387
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education [AllocRef_16ED] £25,662 £14,845 £40,507
    Total Funding for this contract: £40,507
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (HEI)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017387 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE PROVIDER
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 2 (July 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017387 Co Ltd THE SECRETARY OF STATE FOR
    102 Handside Lane EDUCATION
    Welwyn Garden City DEPARTMENT FOR EDUCATION
    Hertfordshire AND 20 GREAT SMITH STREET
    AL8 6SY LONDON
    SW1P 3BT
    Company No: AA017387
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 2 (July 2022) Page 2

    1.4 Precedence of Documentation
    In the event of any inconsistency between the provisions of the Terms and
    Conditions and the Schedules, or between any of the Schedules, the
    conflict shall be resolved according to the following descending order of
    priority:
    1.4.1 the Terms and Conditions,
    1.4.2 Schedule 1 (the Specification);
    1.4.3 the remaining Schedules,
    for the avoidance of doubt, in the event of any inconsistency between this
    Agreement and the Funding Rules, this Agreement will take precedence.
    1.5 In relation to any provision in the Agreement, the Secretary of State may
    act through the Department for Education and / or its executive agency,
    ESFA. As such where the Agreement refers to the Department, both the
    Department for Education and the ESFA are entitled to act in accordance
    with; and / or benefit from; and / or enforce the relevant provision.
    1.6 Without prejudice to the position set out in Clause 1.5, the Department for
    Education will principally manage provider registers, the relationship with
    the Provider and any intervention. The ESFA will principally be
    responsible for allocations, payments, Agreement administration and
    assurance.
    EDSK Version 2 (July 2022) Page 19

    10.6 Failure to meet the requirements set out in Clauses 10.5(a) to 10.5(e) may
    result in the Department assessing the Provider to be in breach of the
    Agreement.
    EDSK Version 2 (July 2022) Page 26

    10.10 The Department may assess the quality and delivery of the Services and
    the Provider’s compliance with the requirements in Clause 10.5(a) to
    10.5(e) during the Agreement Period. The Provider will be informed of the
    outcome of that process. Where the Department assesses the Provider to
    EDSK Version 2 (July 2022) Page 27

    Inadequate overall
    12.5 Where the Department is made aware that Ofsted has provisionally
    assessed the Services to be inadequate overall, the Department may, in
    its absolute discretion commence discussions with the Provider and
    other relevant co-funding regulatory bodies where appropriate as part of
    considering what actions as specified in Clauses 12.6(a) to 12.6(f)
    inclusive may be taken.

    12.7 The failure of the Provider, as assessed by the Department, to comply
    with any requirements of Clauses 12.6(a) to 12.6(c) inclusive within such
    time as the Department may deem reasonable may lead to the
    Department taking such actions as it deems appropriate which may
    include, but is not limited to, terminating the Agreement in accordance
    with Clause 35.3.3  (Termination).
    EDSK Version 2 (July 2022) Page 29

    35.3.2 the Provider fails to comply with requirements imposed under
    Clauses 10.10(a) and/or 10.10(b); and/or
    EDSK Version 2 (July 2022) Page 67

    EDSK Version 2 (July 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 HEI (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 HEI (July 2022) – Page 10
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017387 Co Ltd UKPRN: 10017387
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Pre-16 Universal Infant Free School Meals (Initial £28,311 £4,572.00 £0.00 £0.00 £4,888.00 £0.00 £2,879.00 £4,904.00 £0.00 £5,769.00 £0.00 £0.00 £5,299.00
    Payment)
    Pre-16 Universal Infant Free School Meals (Final £12,196 £2,735.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,684.00 £0.00 £0.00 £3,777.00 £0.00 £0.00
    Payment)
    Total Funding £40,507 £7,307.00 £0.00 £0.00 £4,888.00 £0.00 £2,879.00 £10,588.00 £0.00 £5,769.00 £3,777.00 £0.00 £5,299.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2022) – Page 1
    EDSK Schedule 9 Version 2 (July 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017387_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A387.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017387'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017387 - 10017387 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017387 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017387 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017387 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017387_[ContractNo]_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017387 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017387 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017387 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017387 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017387 | 10017387 Co Ltd  | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | 3_7            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (HEI)      | UIFSM                       | 16-19ED2223     | Contract Approved | Contract Approved | 40507.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_HEI]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017387 | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | 3_7            | AY-2223 | UIFSM                       | 40507.00    | [CofG_HEI]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2223-Contract-Provider-10017387-3_7            | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10017387 | [ContractNo]   | 1               | [AllocRef_16ED]  | 934             | 0                     | 28311.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    | ?                           |
    | 10017387 | [ContractNo]   | 1               | [AllocRef_16ED]  | 935             | 0                     | 12196.00     | 0             | 0        | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Complete
@CFS
Scenario: A388 Import, release and approve an NMSS funding allocation for 22/23 with all seven deliverables. CofG_NMSS. Provider Subtype = 'Non-maintained special school'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017388'
    And   there is no Funding Allocation data in CRM for UKPRN '10017388'
    And   there is no Contract, Task or Workflow data for UKPRN '10017388'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017388'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017388'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017388' in the Sharepoint 'EDSK-2223-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (NMSS)    |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017388' 
    And   there is no caseload advisor for UKPRN '10017388' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017388 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017388' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017388 Co Ltd' with UKPRN '10017388' and OrgId 'ORG0017388' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017388 | 117388 | 10017388 Co Ltd | 0              | Active                | Yes           | AA017388      | ?             | 7a Deans Court         | Bicester               | ?                      | ?                      | Oxon                   | Oxfordshire            | OX6 7XZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017388 |







    # Populate the stub with NMSS (Non-maintained special school) data

    # Change the date 
    Given the override date is '01/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017388 | NMSS-AY-2223-Contract-Provider-10017388-4_1           | 4_1            | NMSS                        | AY-2223            | 91135.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | NMSS-AY-2223-10017388-4_1  | 4_1                    | NMSS-AY-2223-Contract-Provider-10017388-4_1           | 10017388      | Special schools                    | Non-maintained special school    | 91135.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2223-10017388-4_1  | NMSS-001        | 15198.00         | Payment         |
    | NMSS-AY-2223-10017388-4_1  | NMSS-002        | 19843.00         | Payment         |
    | NMSS-AY-2223-10017388-4_1  | NMSS-003        | 2920.00          | Payment         |
    | NMSS-AY-2223-10017388-4_1  | NMSS-006        | 14248.00         | Payment         |
    | NMSS-AY-2223-10017388-4_1  | NMSS-007        | 8488.00          | Payment         |
    | NMSS-AY-2223-10017388-4_1  | NMSS-009        | 13407.00         | Payment         |
    | NMSS-AY-2223-10017388-4_1  | NMSS-010        | 17031.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2223-10017388-4_1  | NMSS-001        | FY-2223              | September              | 2022              | 4581.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-001        | FY-2223              | January                | 2023              | 2060.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-001        | FY-2223              | February               | 2023              | 2684.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-001        | FY-2223              | May                    | 2023              | 5873.00                   |
    #
    | NMSS-AY-2223-10017388-4_1  | NMSS-002        | FY-2223              | August                 | 2022              | 2112.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-002        | FY-2223              | November               | 2022              | 2668.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-002        | FY-2223              | January                | 2023              | 3940.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-002        | FY-2223              | March                  | 2023              | 2000.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-002        | FY-2223              | April                  | 2023              | 5942.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-002        | FY-2223              | June                   | 2023              | 3181.00                   |
    #
    | NMSS-AY-2223-10017388-4_1  | NMSS-003        | FY-2223              | February               | 2023              | 2920.00                   |
    #
    | NMSS-AY-2223-10017388-4_1  | NMSS-006        | FY-2223              | September              | 2022              | 5388.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-006        | FY-2223              | December               | 2022              | 2524.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-006        | FY-2223              | March                  | 2023              | 3112.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-006        | FY-2223              | July                   | 2023              | 3224.00                   |
    #
    | NMSS-AY-2223-10017388-4_1  | NMSS-007        | FY-2223              | November               | 2022              | 2069.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-007        | FY-2223              | December               | 2022              | 2726.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-007        | FY-2223              | July                   | 2023              | 3693.00                   |
    #
    | NMSS-AY-2223-10017388-4_1  | NMSS-009        | FY-2223              | September              | 2022              | 5498.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-009        | FY-2223              | February               | 2023              | 3522.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-009        | FY-2223              | June                   | 2023              | 4387.00                   |
    #
    | NMSS-AY-2223-10017388-4_1  | NMSS-010        | FY-2223              | October                | 2022              | 3621.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-010        | FY-2223              | November               | 2022              | 5202.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-010        | FY-2223              | February               | 2023              | 4459.00                   |
    | NMSS-AY-2223-10017388-4_1  | NMSS-010        | FY-2223              | May                    | 2023              | 3749.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (NMSS)    | CofG_NMSS                 |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_NMSS = [CofG_NMSS]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017388 | 10017388 Co Ltd  | NMSS-AY-2223-Contract-Provider-10017388-4_1             | 4_1            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2223     | Scheduling        | Awaiting Release  | 91135.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_NMSS]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2223-Contract-Provider-10017388-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_NMSS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 91135.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017388 | NMSS-AY-2223-Contract-Provider-10017388-4_1             | 4_1            | AY-2223 | NMSS                        | 91135.00    | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2022'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_NMSS]       |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_NMSS = [CofG_NMSS]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_NMSS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 91135.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017388' for FundingType 'EDSK' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017388' for FundingType 'EDSK' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017388 | 10017388 Co Ltd  | NMSS-AY-2223-Contract-Provider-10017388-4_1             | 4_1            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2223     | Released          | Released          | 91135.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_NMSS]     | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2223-Contract-Provider-10017388-4_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2223-Contract-Provider-10017388-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017388 | NMSS-AY-2223-Contract-Provider-10017388-4_1             | 4_1            | AY-2223 | NMSS                        | 91135.00    | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2223-Contract-Provider-10017388-4_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017388 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017388 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017388 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 91135.00      | 1                     | 0                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2223 | ?               | 10017388 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017388 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017388 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017388 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 91135.00        | ?             | ?                | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 39              | 15198.00  | 0.00     | 4581.00  | 0.00     | 0.00     | 0.00     | 2060.00  | 2684.00  | 0.00     | 0.00     | 5873.00  | 0.00     | 0.00     | NMF Pre-16 Funding (NMSS)                                             |                          |
    | [ContractNo]   | [AllocRef_16ED] | 15              | 19843.00  | 2112.00  | 0.00     | 0.00     | 2668.00  | 0.00     | 3940.00  | 0.00     | 2000.00  | 5942.00  | 0.00     | 3181.00  | 0.00     | SSF High Needs Element 2 (NMSS)                                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 2920.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2920.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Bursary Funds                                                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 14248.00  | 0.00     | 5388.00  | 0.00     | 0.00     | 2524.00  | 0.00     | 0.00     | 3112.00  | 0.00     | 0.00     | 0.00     | 3224.00  | Teachers Pay Grant (NMSS)                                             |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 8488.00   | 0.00     | 0.00     | 0.00     | 2069.00  | 2726.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3693.00  | Teachers Pension Scheme (NMSS)                                        |                          |
    | [ContractNo]   | [AllocRef_16ED] | 200             | 13407.00  | 0.00     | 5498.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3522.00  | 0.00     | 0.00     | 0.00     | 4387.00  | 0.00     | Recovery Premium (NMSS)                                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 201             | 17031.00  | 0.00     | 0.00     | 3621.00  | 5202.00  | 0.00     | 0.00     | 4459.00  | 0.00     | 0.00     | 3749.00  | 0.00     | 0.00     | Tutoring Grant (NMSS)                                                 |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '84' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017388_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017388 Co Ltd UKPRN: 10017388
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education [AllocRef_16ED] £61,086 £30,049 £91,135
    Total Funding for this contract: £91,135
    Summary of Funding – Page 1
    
    Agreement Type Non-Maintained Special Schools (NMSS)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017388 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE NMSS
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK NMSS Version 1 (July 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    NMSS on the Manage Your Education & Skills Funding Service between:
    10017388 Co Ltd THE SECRETARY OF STATE FOR
    7a Deans Court EDUCATION
    Bicester DEPARTMENT FOR EDUCATION
    Oxon 20 GREAT SMITH STREET
    AND
    Oxfordshire LONDON
    OX6 7XZ SW1P 3BT
    Company No: AA017388
    Hereinafter called Hereinafter called
    the NMSS the Department
    EDSK NMSS Version 1 (July 2022) Page 2
    EDSK NMSS Version 1 (July 2022) Page 59
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    NON-MAINTAINED SPECIAL SCHOOL SPECIFICATION
    EDSK Schedule 1 – NMSS Version 1 (July 2022) – Page 1
    EDSK Schedule 1 – NMSS Version 1 (July 2022) – Page 11
    
    SCHEDULE 2: PAYMENT
    NON-MAINTAINED SPECIAL SCHOOL EDUCATION PAYMENTS
    EDSK Schedule 2 – NMSS Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017388 Co Ltd UKPRN: 10017388
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    SSF Bursary Funds £2,920 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,920.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF High Needs Element 2 £19,843 £2,112.00 £0.00 £0.00 £2,668.00 £0.00 £3,940.00 £0.00 £2,000.00 £5,942.00 £0.00 £3,181.00 £0.00
    NMF Pre-16 Funding £15,198 £0.00 £4,581.00 £0.00 £0.00 £0.00 £2,060.00 £2,684.00 £0.00 £0.00 £5,873.00 £0.00 £0.00
    Teachers Pay Grant £14,248 £0.00 £5,388.00 £0.00 £0.00 £2,524.00 £0.00 £0.00 £3,112.00 £0.00 £0.00 £0.00 £3,224.00
    Teachers Pension Scheme £8,488 £0.00 £0.00 £0.00 £2,069.00 £2,726.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,693.00
    Recovery Premium £13,407 £0.00 £5,498.00 £0.00 £0.00 £0.00 £0.00 £3,522.00 £0.00 £0.00 £0.00 £4,387.00 £0.00
    Tutoring Grant £17,031 £0.00 £0.00 £3,621.00 £5,202.00 £0.00 £0.00 £4,459.00 £0.00 £0.00 £3,749.00 £0.00 £0.00
    Total Funding £91,135 £2,112.00 £15,467.00 £3,621.00 £9,939.00 £5,250.00 £6,000.00 £13,585.00 £5,112.00 £5,942.00 £9,622.00 £7,568.00 £6,917.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 - NMSS Version 1 (July 2022) – Page 1
    EDSK Schedule 9 – NMSS Version 1 (July 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017388_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A388.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017388'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017388 - 10017388 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017388 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017388 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017388 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017388_[ContractNo]_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017388 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017388 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017388 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017388 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017388 | 10017388 Co Ltd  | NMSS-AY-2223-Contract-Provider-10017388-4_1             | 4_1            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2223     | Contract Approved | Contract Approved | 91135.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_NMSS]     | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017388 | NMSS-AY-2223-Contract-Provider-10017388-4_1             | 4_1            | AY-2223 | NMSS                        | 91135.00    | [CofG_NMSS]     | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2223-Contract-Provider-10017388-4_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10017388 | [ContractNo]   | 1               | [AllocRef_16ED]  | 39              | 0                     | 15198.00     | 0             | 0        | NMF Pre-16 Funding (NMSS)                                             | ?                           |
    | 10017388 | [ContractNo]   | 1               | [AllocRef_16ED]  | 15              | 0                     | 19843.00     | 0             | 0        | SSF High Needs Element 2 (NMSS)                                       | ?                           |
    | 10017388 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 2920.00      | 0             | 0        | SSF Bursary Funds                                                     | ?                           |
    | 10017388 | [ContractNo]   | 1               | [AllocRef_16ED]  | 118             | 0                     | 14248.00     | 0             | 0        | Teachers Pay Grant (NMSS)                                             | ?                           |
    | 10017388 | [ContractNo]   | 1               | [AllocRef_16ED]  | 135             | 0                     | 8488.00      | 0             | 0        | Teachers Pension Scheme (NMSS)                                        | ?                           |
    | 10017388 | [ContractNo]   | 1               | [AllocRef_16ED]  | 200             | 0                     | 13407.00     | 0             | 0        | Recovery Premium (NMSS)                                               | ?                           |
    | 10017388 | [ContractNo]   | 1               | [AllocRef_16ED]  | 201             | 0                     | 17031.00     | 0             | 0        | Tutoring Grant (NMSS)                                                 | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

 