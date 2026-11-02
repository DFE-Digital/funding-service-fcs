Feature: EDSK2223TemplateChanges 38436

@AcceptanceTest @Withdrawn25072024
Scenario: A781 Bulk load and approve an EDSK2223 contract with 16-18TRN, 16-18TRN-ME and Loans (CfS) allocs. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017781' 
    And   there are no terminated or closed allocations for UKPRN '10017781' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017781' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017781' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017781' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2223      |
    | 16-18TRN-ME2223   |
    | ALLB2223          |



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017781'

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
    Given there is no Organisation data in CRM for UKPRN '10017781' 
    And   there is no caseload advisor for UKPRN '10017781' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017781 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017781' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017781 Co Ltd' with UKPRN '10017781' and OrgId 'ORG0017781' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017781 | 117781 | 10017781 Co Ltd | 0              | Active                | Yes           | AA017781      | ?             | 15 Wildgoose Drive     | ?                      | ?                      | ?                      | Horsham                | West Sussex            | RH12 1TU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017781 |





    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file
    And   there are no files prefixed '10017781' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 24012023084755 v3_A781' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 24012023084755 v3_A781' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 24012023084755 v3_A781' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 24012023084755 v3_A781' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 24012023084755 v3_A781.xlsx' exists in the Datafiles folder and UKPRN '10017781' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017781' for FundingType 'EDSK' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017781' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017781_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017781 Co Ltd UKPRN: 10017781
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Bursary [AllocRef_ALLB] £33,894 £8,114 £42,008
    16 to 18 Traineeships [AllocRef_16TR] £75,987 £44,989 £120,976
    16 to 18 Traineeships [AllocRef_16TM] £73,067 £33,715 £106,782
    Total Funding for this contract: £269,766
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017781 Co Ltd
    Advanced Learner Loans
    Funding for
    16 to 18 Traineeships
    Master Contract Number [MasterContractNo]
    ACCEPTANCE BY THE CONTRACTOR
    BY ACCEPTING THIS CONTRACT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE CONTRACTOR REPRESENTS AND WARRANTS THAT THE CONTRACTOR
    HAS READ AND UNDERSTOOD THIS CONTRACT, THE CONTRACTOR AGREES
    TO BE BOUND BY THIS CONTRACT AND THAT HE/SHE IS DULY AUTHORISED
    TO ACCEPT THIS CONTRACT AND LEGALLY BIND THE CONTRACTOR.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 2 (July 2022) Page 1
    
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017781 Co Ltd THE SECRETARY OF STATE FOR
    15 Wildgoose Drive EDUCATION
    Horsham DEPARTMENT FOR EDUCATION
    West Sussex AND 20 GREAT SMITH STREET
    RH12 1TU LONDON
    SW1P 3BT
    Company No: AA017781
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 2 (July 2022) Page 2
    EDSK Version 2 (July 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 8
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2022) – Page 7
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY) SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (July 2022) – Page 6
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON ACTUALS)
    Advanced Learner Loans Facility
    6. The Department will pay the Contractor on the 16 Working Day of each
    month.
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (February 2023) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (February 2023) – Page 2
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017781 Co Ltd UKPRN: 10017781
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Bursary Funding £42,008 £2,190 £2,955 £662 £7,541 £694 £5,333 £7,318 £7,201 £1,713 £2,275 £2,700 £1,426
    Total Funding £42,008 £2,190 £2,955 £662 £7,541 £694 £5,333 £7,318 £7,201 £1,713 £2,275 £2,700 £1,426
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    5. The Department will pay the Contractor on the 16 Working Day of each
    month.
    EDSK Schedule 2 – 16 to 18 Traineeships Version 2 (February 2023) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017781 Co Ltd UKPRN: 10017781
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16 to 18 Traineeships Programme Funding £62,325 £7,792 £6,040 £1,232 £7,707 £6,295 £467 £2,049 £7,367 £7,314 £5,361 £3,270 £7,431
    16 to 18 Traineeships Bursary Funding £58,651 £2,898 £4,819 £7,007 £4,172 £6,837 £4,681 £5,308 £1,316 £7,452 £7,059 £6,125 £977
    Total Funding £120,976 £10,690 £10,859 £8,239 £11,879 £13,132 £5,148 £7,357 £8,683 £14,766 £12,420 £9,395 £8,408
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY)
    5. The Department will pay the Contractor on the 16 Working Day of each
    month.
    EDSK Schedule 2 – 16 to 18 Traineeships (Market Entry) Version 2 (February 2023) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017781 Co Ltd UKPRN: 10017781
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16TM]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16 to 18 Traineeships Programme Funding £53,364 £520 £4,002 £7,346 £3,153 £4,055 £3,460 £5,244 £5,733 £7,994 £3,323 £3,545 £4,989
    16 to 18 Traineeships Bursary Funding £53,418 £6,497 £5,701 £2,251 £4,649 £7,516 £2,643 £5,583 £4,714 £3,100 £7,941 £1,369 £1,454
    Total Funding £106,782 £7,017 £9,703 £9,597 £7,802 £11,571 £6,103 £10,827 £10,447 £11,094 £11,264 £4,914 £6,443
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TM] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 2 (July 2022) – Page 1
    EDSK Schedule 9 Version 2 (July 2022) – Page 5
    """

    # Tidy Up
    Given the override date is reset

     