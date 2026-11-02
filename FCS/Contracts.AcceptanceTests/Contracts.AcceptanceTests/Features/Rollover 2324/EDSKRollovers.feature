Feature: 23/24: Rollover EDSK funding exc AEBC (39317)

@AcceptanceTest @Withdrawn20251024
@Long2Run @Long2Run67
Scenario: AK003 Bulk load a EDSK 2324 contract with CofG(Trust) contract type for 16-18TRN, APPS and ATLP alloc. Check docs. NFA amendment. Generate payments. CDA and Payment summary reports validation.
    Given there are no allocations marked as Under Termination for UKPRN '10000003' 
    And   there are no terminated or closed allocations for UKPRN '10000003' 
    And   there is no Contract, Task or Workflow data for UKPRN '10000003' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10000003' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10000003' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2324      |
    | APPS2324          |
    | ATLP2324          |



    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_EDSK_2023-08-01.docx                        | 2023-05-01 17:55:54.950 | 
    # 
    | EDSK2324_S1_1618TRN_CFS_2023-08-01.docx         | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S1_1618TRN_COFG_2023-08-01.docx        | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S1_APPS_COLLEGE_2023-08-01.docx        | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S1_APPS_OTHER_2023-08-01.docx          | 2023-05-01 17:55:54.950 |
    #                                                   2023-05-01 17:55:54.950
    | EDSK2324_S2_1618TRN_CFS_2023-08-01.docx         | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_1618TRN_COFG_2023-08-01.docx        | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_APPS_AA_COLLEGE_2023-08-01.docx     | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_APPS_AA_LA_2023-08-01.docx          | 2023-05-01 17:55:54.950 |
    | EDSK2324_S2_APPS_OTHER_2023-08-01.docx          | 2023-05-01 17:55:54.950 |   
    | EDSK2324_S2_ATLP_AA_COLLEGE_2023-08-01.docx     | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_ATLP_COFG_2023-08-01.docx           | 2023-05-01 17:55:54.950 | 
    #                                                   2023-05-01 17:55:54.950
    | EDSK2324_S3_APPS_AA_COLLEGE_2023-08-01.docx     | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3_APPS_AA_LA_2023-08-01.docx          | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3_ATLP_AA_COLLEGE_2023-08-01.docx     | 2023-05-01 17:55:54.950 | 
    

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10000003'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10000003' 
    And   there is no caseload advisor for UKPRN '10000003' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000003 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10000003' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10000003 Co Ltd' with UKPRN '10000003' and OrgId 'ORG0000003' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000003 | 000003 | 10000003 Co Ltd | 0              | In Administration     | Yes           | AA000003      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000003 |





    # Change the date
    Given the override date is '01/06/2023'

    # Bulk file
    And   there are no files prefixed '10000003' in the Sharepoint 'EDSK-2324-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2324 11062021110140 v3_AK003' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2324 11062021110140 v3_AK003' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2324 11062021110140 v3_AK003' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2324 11062021110140 v3_AK003' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2324 11062021110140 v3_AK003.xlsx' exists in the Datafiles folder and UKPRN '10000003' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10000003' for FundingType 'EDSK' and period '2324'

 #place code here
    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10000003_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10000003 Co Ltd UKPRN: 10000003
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Apprenticeships Carry-In [AllocRef_APPS] £25,584 £13,572 £39,156
    16 to 18 Traineeships [AllocRef_16TR] £59,653 £31,387 £91,040
    T-Levels for Adults Pilot [AllocRef_ATLP] £25,584 £13,572 £39,156
    Total Funding for this contract: £169,352
    Summary of Funding – Page 1

    Agreement Type Accountability Agreement (Colleges)
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10000003 Co Ltd
    Apprenticeships Carry-In
    Funding for 16 to 18 Traineeships
    T-Levels for Adults Pilot
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    Accountability Agreement (College) Version 3 (September 2023) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10000003 Co Ltd THE SECRETARY OF STATE FOR
    46 The Avenue EDUCATION
    Bournemouth DEPARTMENT FOR EDUCATION
    Dorset AND 20 GREAT SMITH STREET    
    BH9 2UW LONDON
    SW1P 3BT
    Company No: AA000003
    Hereinafter called Hereinafter called
    the College the Department
    Accountability Agreement (College) Version 3 (September 2023) Page 2
    Accountability Agreement (College) Version 3 (September 2023) Page 72

    SCHEDULE 2: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
    Schedule 2 – Apprenticeships Carry-In Version 1 (July 2023) – Page 1
    Schedule 2 – Apprenticeships Carry-In Version 1 (July 2023) – Page 11


    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2023) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2023) – Page 5
    SCHEDULE 1B: MONITORING
    16-18-YEAR-OLD TRAINEESHIPS
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2023) – Page 6
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2023) – Page 7



    SCHEDULE 2: SPECIFICATION & MONITORING
    Adult T Level Pilot
    Schedule 2 – Adult T Level Pilot Version 1 Trust (July 2023) – Page 1
    Schedule 2 – Adult T Level Pilot Version 1 Trust (July 2023) – Page 6

    SCHEDULE 3: PAYMENT
    APPRENTICESHIPS CARRY-IN
    Schedule 3 – Apprenticeships Carry-In Version 1 (July 2023) – Page 1
    APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10000003 Co Ltd UKPRN: 10000003
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Apprenticeships Carry-In £39,156 £2,958 £4,338 £4,423 £4,168 £4,932 £527 £1,567 £2,671 £7,310 £1,345 £1,227 £3,690
    Total Funding £39,156 £2,958 £4,338 £4,423 £4,168 £4,932 £527 £1,567 £2,671 £7,310 £1,345 £1,227 £3,690   
    Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS 
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2023) – Page 1
 

    16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10000003 Co Ltd UKPRN: 10000003
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    16 to 18 Traineeships Programme Funding £34,171 £6,752 £1,944 £468 £7,007 £1,179 £2,761 £128 £75 £6,073 £3,982 £192 £3,610
    16 to 18 Traineeships Bursary Funding £56,869 £5,531 £7,719 £4,884 £7,549 £5,394 £6,020 £2,029 £213 £7,772 £6,837 £1,689 £1,232
    Total Funding £91,040 £12,283 £9,663 £5,352 £14,556 £6,573 £8,781 £2,157 £288 £13,845 £10,819 £1,881 £4,842    
    16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: PAYMENT
    Adult T Level Pilot
    Schedule 3 – Adult T Level Pilot Version 1 (July 2023) – Page 1

    T-LEVELS FOR ADULTS PILOT
    Funding Agreement – T-Levels for Adults Pilot
    Provider: 10000003 Co Ltd UKPRN: 10000003
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ATLP]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    T-Levels for Adults Pilot £39,156 £2,958 £4,338 £4,423 £4,168 £4,932 £527 £1,567 £2,671 £7,310 £1,345 £1,227 £3,690
    Total Funding £39,156 £2,958 £4,338 £4,423 £4,168 £4,932 £527 £1,567 £2,671 £7,310 £1,345 £1,227 £3,690    
    T-Levels for Adults Pilot – Funding Agreement [AllocRef_ATLP] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 4: UK GDPR/DATA PROTECTION
    Schedule 4 Version 2 (July 2023) – Page 1
    Schedule 4 Version 2 (July 2023) – Page 2

    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
    Schedule 5 Version 2 (July 2023) – Page 1
    Schedule 5 Version 2 (July 2023) – Page 8

    SCHEDULE 6: EXIT ARRANGEMENTS
    Schedule 6 Version 2 (July 2023) – Page 1
    Schedule 6 Version 2 (July 2023) – Page 5

    SCHEDULE 7: COLLEGE GOVERNANCE
    Schedule 7 Version 2 (July 2023) – Page 1
    Schedule 7 Version 2 (July 2023) – Page 6


    SCHEDULE 8: SUB-CONTRACTING
    Schedule 8 Version 2 (July 2023) – Page 1
    Schedule 8 Version 2 (July 2023) – Page 5


    SCHEDULE 9: NATIONAL SKILLS PRIORITIES
    Schedule 9 Version 2 (July 2023) – Page 1
   
    """

    

    
   

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10000003_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK003_v1.pdf'

    
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
    | 10000003 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10000003 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-06-01 09:12:35.000 |


    
    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated


    | DocumentTemplateName	                          | UploadTimestamp         |
    | SOF_EDSK_2023-08-01.docx                        | 2023-05-01 17:55:54.950 | 
    # 
    | EDSK2324_S1_1618TRN_CFS_2023-08-01.docx         | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S1_1618TRN_COFG_2023-08-01.docx        | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S1_APPS_COLLEGE_2023-08-01.docx        | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S1_APPS_OTHER_2023-08-01.docx          | 2023-05-01 17:55:54.950 |
    #                                                   2023-05-01 17:55:54.950
    | EDSK2324_S2_1618TRN_CFS_2023-08-01.docx         | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_1618TRN_COFG_2023-08-01.docx        | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_APPS_AA_COLLEGE_2023-08-01.docx     | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_APPS_AA_LA_2023-08-01.docx          | 2023-05-01 17:55:54.950 |
    | EDSK2324_S2_APPS_OTHER_2023-08-01.docx          | 2023-05-01 17:55:54.950 |   
    | EDSK2324_S2_ATLP_AA_COLLEGE_2023-08-01.docx     | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_ATLP_COFG_2023-08-01.docx           | 2023-05-01 17:55:54.950 | 
    #                                                   2023-05-01 17:55:54.950
    | EDSK2324_S3_APPS_AA_COLLEGE_2023-08-01.docx     | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3_APPS_AA_LA_2023-08-01.docx          | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3_ATLP_AA_COLLEGE_2023-08-01.docx     | 2023-05-01 17:55:54.950 | 




    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '22/07/2023'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000003 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10000003 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10000003 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10018011' for FundingType 'HTE-SIF' and period '2223' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10000003' for FundingType 'EDSK' and period '2324'


    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10000003_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10000003 Co Ltd UKPRN: 10000003
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Apprenticeships Carry-In [AllocRef_APPS] £25,584 £13,572 £39,156
    16 to 18 Traineeships [AllocRef_16TR] £59,653 £31,387 £91,040
    T-Levels for Adults Pilot [AllocRef_ATLP] £25,584 £13,572 £39,156
    Total Funding for this contract: £169,352    
    Summary of Funding – Page 1
    """

    # Save a copy of the output
    Then  Sharepoint file '10000003_[ContractNo]_v2.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK003_v2.pdf'

    #Then stop





    # Publish and Approve the contract
    
    # Change the date
    Given the override date is '01/08/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'


    
#    # Part 8: CDA
#    
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version AK003.csv'
##
##    Then  the contracts are in the replicated CRM database as follows
##    | ContractNumber | ContractVersionNumber |
##    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod     | Version               | Suffix |
#    | 16-18TR2324             | Latest Version        | AK003   |
#    | APPS2324                | Latest Version        | AK003   |
#    | ALLF2324                | Latest Version        | AK003   |
#
#
#    Then  a report named 'CDA Latest Version AK003.csv' is created
#	# Check the above report manually


    # Part 9: Payment Batch for EDSK2324

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ATLP2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ATLP]          | 202308 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ATLP2324      		     | 202308               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ATLP2324                	 | 202308               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLBC2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK003a.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'ATLP2324' AccountingPaymentPeriod '202305' and CensusEndDate '02/08/2023'
 

   #  Part 10: Create Consolidated Payment Summary rpt
   
   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
   Given there are no files prefixed '2023-08 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder

   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '03/08/2023'
    # Check the above report manually

    
   

    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20251024
@Long2Run @Long2Run67
Scenario: AK004 Bulk load a EDSK 2324 contract with CofG(Trust) contract type for AEBC-19TRN2324, AEBC-ASCL2324, AEBC-NSF2324,  ALLBC2324 and STFIC2324 allocs. Check docs. NFA amendment. Generate payments. CDA and Payment summary reports validation.
    Given there are no allocations marked as Under Termination for UKPRN '10000014' 
    And   there are no terminated or closed allocations for UKPRN '10000014' 
    And   there is no Contract, Task or Workflow data for UKPRN '10000014' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10000014' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10000014' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN2324    |
    | AEBC-ASCL2324     |
    | AEBC-NSF2324      |
    | ALLBC2324         |
    | STFIC2324         |



    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         | 
    | FA_EDSK2324_2023-08-01.docx                  | 2023-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_LA_2023-08-01.docx        | 2023-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_LA_2023-08-01.docx        | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_COFG_2023-08-01.docx         | 2023-02-20 10:00:00.000 |
    | EDSK2324_S1_AEB_COFG_2023-08-01.docx         | 2023-02-20 10:00:00.000 |
 
    

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10000014'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10000014' 
    And   there is no caseload advisor for UKPRN '10000014' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000014 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10000014' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10000014 Co Ltd' with UKPRN '10000014' and OrgId 'ORG0000014' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000014 | 000014 | 10000014 Co Ltd | 0              | In Administration     | Yes           | AA000014      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000014 |





    # Change the date
    Given the override date is '01/06/2023'

    # Bulk file
    And   there are no files prefixed '10000014' in the Sharepoint 'EDSK-2324-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2324 09062022105948 v3_AK004' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2324 09062022105948 v3_AK004' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2324 09062022105948 v3_AK004' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2324 09062022105948 v3_AK004' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2324 09062022105948 v3_AK004.xlsx' exists in the Datafiles folder and UKPRN '10000014' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10000014' for FundingType 'EDSK' and period '2324'

 #place code here
    
   Then  the file named '10000014_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10000014 Co Ltd UKPRN: 10000014
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Bursary [AllocRef_ALLC] £39,233 £6,808 £46,041
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £34,508 £16,372 £50,880
    ESFA Adult Education Budget (Grant) [AllocRef_AECA] £71,601 £22,112 £93,713
    of which Community Learning £38,013 £9,119 £47,132
    of which Funding for Innovative Provision £0 £0 £0
    ESFA AEB - National Skills Fund [AllocRef_NSFC] £35,396 £12,593 £47,989
    of which Free Courses for Jobs £35,396 £12,593 £47,989
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £145,975 £62,071 £208,046
    of which Short Term Funding Initiative 1 £24,544 £10,335 £34,879
    of which Short Term Funding Initiative 2 £44,872 £16,523 £61,395
    of which Short Term Funding Initiative 3 £39,236 £20,599 £59,835
    of which Short Term Funding Initiative 4 £37,323 £14,614 £51,937
    Total Funding for this contract: £446,669
    Summary of Funding – Page 1
   
    Agreement Type Conditions of Funding (Grant) (Trusts)
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10000014 Co Ltd
    Advanced Learner Loans
    ESFA-Funded Adult Education Budget
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE PROVIDER
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 3 (September 2023) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10000014 Co Ltd THE SECRETARY OF STATE FOR
    46 The Avenue EDUCATION
    Bournemouth DEPARTMENT FOR EDUCATION
    Dorset 20 GREAT SMITH STREET
    BH9 2UW LONDON    
    SW1P 3BT
    Company No: AA000014
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (September 2023) Page 2
    EDSK Version 3 (September 2023) Page 74
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2023) – Page 9
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2023) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2023) – Page 8



    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 2
  
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10000014 Co Ltd UKPRN: 10000014
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Bursary Funding £46,041 £5,160 £7,081 £1,318 £6,434 £1,148 £6,943 £7,570 £3,579 £1,763 £1,370 £436 £3,239
    Total Funding £46,041 £5,160 £7,081 £1,318 £6,434 £1,148 £6,943 £7,570 £3,579 £1,763 £1,370 £436 £3,239
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2023) – Page 1




    ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10000014 Co Ltd UKPRN: 10000014
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    ESFA AEB - 19 to 24 Traineeships £50,880 £279 £1,044 £6,702 £5,630 £6,734 £3,422 £5,407 £5,290 £7,753 £364 £789 £7,466
    Total Funding £50,880 £279 £1,044 £6,702 £5,630 £6,734 £3,422 £5,407 £5,290 £7,753 £364 £789 £7,466
    ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA Adult Education Budget (Grant)
    Provider: 10000014 Co Ltd UKPRN: 10000014
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    ESFA Adult Education Budget (Grant) £93,713 £8,518 £8,891 £13,614 £7,394 £8,041 £8,211 £7,702 £9,230 £4,644 £4,612 £6,820 £6,036
    of which Community Learning £47,132 £3,070 £1,117 £6,977 £3,187 £6,605 £6,415 £2,763 £7,879 £2,593 £438 £1,064 £5,024
    Total Funding £93,713 £8,518 £8,891 £13,614 £7,394 £8,041 £8,211 £7,702 £9,230 £4,644 £4,612 £6,820 £6,036
    ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - National Skills Fund
    Provider: 10000014 Co Ltd UKPRN: 10000014
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_NSFC]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    ESFA AEB - National Skills Fund Free Courses for £47,989 £5,449 £7,169 £6,234 £1,086 £629 £4,111 £7,456 £3,262 £2,052 £1,458 £3,241 £5,842
    Total Funding £47,989 £5,449 £7,169 £6,234 £1,086 £629 £4,111 £7,456 £3,262 £2,052 £1,458 £3,241 £5,842
    ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_NSFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Provider: 10000014 Co Ltd UKPRN: 10000014
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_STFC]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    ESFA AEB - Short Term Funding Initiative 1 £34,879 £5,991 £1,320 £7,382 £875 £4,495 £3,698 £248 £535 £5,514 £641 £1,469 £2,711
    ESFA AEB - Short Term Funding Initiative 2 £61,395 £1,098 £5,938 £7,318 £7,403 £7,148 £7,912 £3,508 £4,547 £5,651 £2,339 £4,325 £4,208
    ESFA AEB - Short Term Funding Initiative 3 £59,835 £6,671 £7,233 £7,658 £6,384 £2,254 £4,580 £3,443 £1,013 £6,193 £6,553 £1,745 £6,108
    ESFA AEB - Short Term Funding Initiative 4 £51,937 £6,808 £980 £450 £5,769 £7,827 £3,762 £3,783 £7,944 £1,300 £3,221 £7,520 £2,573
    Total Funding £208,046 £20,568 £15,471 £22,808 £20,431 £21,724 £19,952 £10,982 £14,039 £18,658 £12,754 £15,059 £15,600
    ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_STFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
     
   SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2023) – Page 1

    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (July 2023) – Page 1

    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (July 2023) – Page 1

    SCHEDULE 6: UK GDPR AND DATA PROTECTION
    EDSK Schedule 6 Version 2 (July 2023) – Page 1
    EDSK Schedule 6 Version 2 (July 2023) – Page 2


    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 2 (July 2023) – Page 1
    EDSK Schedule 7 Version 2 (July 2023) – Page 8


    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 2 (July 2023) – Page 1
    EDSK Schedule 8 Version 2 (July 2023) – Page 5
    
    SCHEDULE 9: SUB-CONTRACTING
    EDSK Schedule 9 Version 2 (July 2023) – Page 1
    EDSK Schedule 9 Version 2 (July 2023) – Page 5
     """
     

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10000014_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK004_v1.pdf'

    
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
    | 10000014 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10000014 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-06-01 09:12:35.000 |


    
    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated


    | DocumentTemplateName	                          | UploadTimestamp         |
    | FA_EDSK2324_2023-08-01.docx                  | 2023-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_LA_2023-08-01.docx        | 2023-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_LA_2023-08-01.docx        | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_COFG_2023-08-01.docx         | 2023-02-20 10:00:00.000 |
    | EDSK2324_S1_AEB_COFG_2023-08-01.docx         | 2023-02-20 10:00:00.000 | 




    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '22/07/2023'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000014 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10000014 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10000014 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10018011' for FundingType 'HTE-SIF' and period '2223' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10000014' for FundingType 'EDSK' and period '2324'

    #place code here
     Then  the file named '10000014_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10000014 Co Ltd UKPRN: 10000014
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Bursary [AllocRef_ALLC] £39,233 £6,808 £46,041
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £34,508 £16,372 £50,880
    ESFA Adult Education Budget (Grant) [AllocRef_AECA] £71,601 £22,112 £93,713
    of which Community Learning £38,013 £9,119 £47,132
    of which Funding for Innovative Provision £0 £0 £0
    ESFA AEB - National Skills Fund [AllocRef_NSFC] £35,396 £12,593 £47,989
    of which Free Courses for Jobs £35,396 £12,593 £47,989
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £145,975 £62,071 £208,046
    of which Short Term Funding Initiative 1 £24,544 £10,335 £34,879
    of which Short Term Funding Initiative 2 £44,872 £16,523 £61,395
    of which Short Term Funding Initiative 3 £39,236 £20,599 £59,835
    of which Short Term Funding Initiative 4 £37,323 £14,614 £51,937
    Total Funding for this contract: £446,669
    Summary of Funding – Page 1
    """
    # Save a copy of the output
    Then  Sharepoint file '10000014_[ContractNo]_v2.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK003_v2.pdf'

    #Then stop





    # Publish and Approve the contract
    
    # Change the date
    Given the override date is '01/08/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'


        # Part 8: CDA
    
    # Run the CDA report
    Given there is no CDA report named 'CDA Latest Version AK004.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |

    When  the following CDA report is run
    | FundingStreamPeriod     | Version               | Suffix |
    | AEBC-19TRN2324          | Latest Version        | AK004   |
    | AEBC-ASCL2324           | Latest Version        | AK004   |
    | AEBC-NSF2324            | Latest Version        | AK004   |
    | ALLBC2324               | Latest Version        | AK004   |
    | STFIC2324               | Latest Version        | AK004   |

    Then  a report named 'CDA Latest Version AK004.csv' is created

          
	# Check the above report manually



    # Part 9: Payment Batch for AEBC-19TRN2324

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-19TRN2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_AECT]          | 202308 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEBC-19TRN2324      		 | 202308               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEBC-19TRN2324           	 | 202308               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-19TRN2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004a.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEBC-19TRN2324' AccountingPaymentPeriod '202305' and CensusEndDate '02/08/2023'


   # Part 9: Payment Batch for AEBC-ASCL2324

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-ASCL2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_AECA]          | 202308 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEBC-ASCL2324      		 | 202308               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEBC-ASCL2324           	 | 202308               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-ASCL2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEBC-ASCL2324' AccountingPaymentPeriod '202305' and CensusEndDate '02/08/2023'

   
      # Part 9: Payment Batch for AEBC-NSF2324

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-NSF2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_NSFC]          | 202308 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEBC-NSF2324      		 | 202308               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEBC-NSF2324           	 | 202308               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-NSF2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEBC-NSF2324' AccountingPaymentPeriod '202305' and CensusEndDate '02/08/2023'


     # Part 9: Payment Batch for AEBC-STF2324

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'STFIC2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_STFC]          | 202308 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | STFIC2324         		 | 202308               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | STFIC2324             	 | 202308               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'STFIC2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'STFIC2324' AccountingPaymentPeriod '202305' and CensusEndDate '02/08/2023'


      # Part 9: Payment Batch for AEBC-ASCL2324

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLBC2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_ALLC]          | 202308 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLBC2324         		 | 202308               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLBC2324             	 | 202308               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLBC2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'ALLBC2324' AccountingPaymentPeriod '202305' and CensusEndDate '02/08/2023'

     @AcceptanceTest @Withdrawn20251024
@Long2Run @Long2Run67
Scenario: AK009 Bulk load a EDSK 2324 contract with CofG(Trust) contract type for  1619ED2324 allocs. Check docs.Generate payments. CDA and Payment summary reports validation.
    Given there are no allocations marked as Under Termination for UKPRN '10000009' 
    And   there are no terminated or closed allocations for UKPRN '10000009' 
    And   there is no Contract, Task or Workflow data for UKPRN '10000009' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10000009' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10000009' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 1619ED2324     |
   
   
    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         | 
    | FA_EDSK2324_2023-08-01.docx                  | 2023-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_LA_2023-08-01.docx        | 2023-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_LA_2023-08-01.docx        | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_COFG_2023-08-01.docx         | 2023-02-20 10:00:00.000 |
    | EDSK2324_S1_AEB_COFG_2023-08-01.docx         | 2023-02-20 10:00:00.000 |
 
    

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10000009'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10000009' 
    And   there is no caseload advisor for UKPRN '10000009' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000009 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10000009' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10000009 Co Ltd' with UKPRN '10000009' and OrgId 'ORG0000009' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000009 | 000009 | 10000009 Co Ltd | 0              | In Administration     | Yes           | AA000009      | ?             | 96 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Drewsbury                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000009 |





    # Change the date
    Given the override date is '01/06/2023'

    # Bulk file
    And   there are no files prefixed '10000009' in the Sharepoint 'EDSK-2324-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2324 19062022105948 v3_AK009' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2324 19062022105948 v3_AK009' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2324 19062022105948 v3_AK009' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2324 19062022105948 v3_AK009' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2324 19062022105948 v3_AK009.xlsx' exists in the Datafiles folder and UKPRN '10000009' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10000009' for FundingType 'EDSK' and period '2324'

 #place code here
    
   
  

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10000009_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK009_v1.pdf'

    
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
    | 10000009 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10000009 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-06-01 09:12:35.000 |


    
    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated


    | DocumentTemplateName	                          | UploadTimestamp         |
    | FA_EDSK2324_2023-08-01.docx                  | 2023-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_LA_2023-08-01.docx        | 2023-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_LA_2023-08-01.docx        | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_COFG_2023-08-01.docx         | 2023-02-20 10:00:00.000 |
    | EDSK2324_S1_AEB_COFG_2023-08-01.docx         | 2023-02-20 10:00:00.000 | 




    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '22/07/2023'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000009 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10000009 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10000009 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10018011' for FundingType 'HTE-SIF' and period '2223' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10000009' for FundingType 'EDSK' and period '2324'

    #place code here
   
  
    # Save a copy of the output
    Then  Sharepoint file '10000009_[ContractNo]_v2.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK009_v2.pdf'

    #Then stop





    # Publish and Approve the contract
    
    # Change the date
    Given the override date is '01/08/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'


#        # Part 8: CDA
#    
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version AK009.csv'
##
##    Then  the contracts are in the replicated CRM database as follows
##    | ContractNumber | ContractVersionNumber |
##    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod     | Version               | Suffix |
#    | 1619ED2324           | Latest Version        | AK009   |
#    
#    Then  a report named 'CDA Latest Version AK009.csv' is created
#
#          
#	# Check the above report manually
#



   # Part 9: Payment Batch for 1619ED2324

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '1619ED2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_AECA]          | 202308 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 1619ED2324      		 | 202308               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 1619ED2324           	 | 202308               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '1619ED2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod '1619ED2324' AccountingPaymentPeriod '202305' and CensusEndDate '02/08/2023'

   
     
@AcceptanceTest @Inprogress
@CFS
Scenario: AK006 Import, release and approve an NMSS funding allocation for 23/24 with all seven deliverables. CofG_NMSS. Provider Subtype = 'Non-maintained special school'. Check docs, CRM, PaaS and feed 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10000016'
    And   there is no Funding Allocation data in CRM for UKPRN '10000016'
    And   there is no Contract, Task or Workflow data for UKPRN '10000016'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10000016'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10000016'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10000016' in the Sharepoint 'EDSK-2324-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (NMSS)    |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10000016' 
    And   there is no caseload advisor for UKPRN '10000016' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000016 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10000016' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10000016 Co Ltd' with UKPRN '10000016' and OrgId 'ORG0000016' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000016 | 100016 | 10000016 Co Ltd | 0              | Active                | Yes           | AA000016      | ?             | 10 palace Road         | Leeds                  | ?                      | ?                      | Leeds                  | Yorkshire              | LS27 7EF  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000016 |







    # Populate the stub with NMSS (Non-maintained special school) data

    # Change the date 
    Given the override date is '20/09/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10000016 | NMSS-AY-2324-Contract-Provider-10000016-4_1           | 4_1            | NMSS                        | AY-2324            | 121573.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | NMSS-AY-2324-10000016-4_1  | 4_1                    | NMSS-AY-2324-Contract-Provider-10000016-4_1           | 10000016      | Special schools                    | Non-maintained special school    | 121573.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2324-10000016-4_1  | NMSS-001        | 15198.00         | Payment         |
    | NMSS-AY-2324-10000016-4_1  | NMSS-002        | 19843.00         | Payment         |
    | NMSS-AY-2324-10000016-4_1  | NMSS-003        | 2920.00          | Payment         |
    | NMSS-AY-2324-10000016-4_1  | NMSS-006        | 14248.00         | Payment         |
    | NMSS-AY-2324-10000016-4_1  | NMSS-007        | 8488.00          | Payment         |
    | NMSS-AY-2324-10000016-4_1  | NMSS-009        | 13407.00         | Payment         |
    | NMSS-AY-2324-10000016-4_1  | NMSS-010        | 17031.00         | Payment         |
    | NMSS-AY-2324-10000016-4_1  | NMSS-011        | 13407.00         | Payment         |
    | NMSS-AY-2324-10000016-4_1  | NMSS-012        | 17031.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2324-10000016-4_1  | NMSS-001        | FY-2324              | September              | 2023              | 4581.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-001        | FY-2324              | January                | 2024              | 2060.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-001        | FY-2324              | February               | 2024              | 2684.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-001        | FY-2324              | May                    | 2024              | 5873.00                   |
    #
    | NMSS-AY-2324-10000016-4_1  | NMSS-002        | FY-2324              | August                 | 2023              | 2112.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-002        | FY-2324              | November               | 2023              | 2668.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-002        | FY-2324              | January                | 2024              | 3940.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-002        | FY-2324              | March                  | 2024              | 2000.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-002        | FY-2324              | April                  | 2024              | 5942.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-002        | FY-2324              | June                   | 2024              | 3181.00                   |
    #
    | NMSS-AY-2324-10000016-4_1  | NMSS-003        | FY-2324              | February               | 2024              | 2920.00                   |
    #
    | NMSS-AY-2324-10000016-4_1  | NMSS-006        | FY-2324              | September              | 2023              | 5388.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-006        | FY-2324              | December               | 2023              | 2524.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-006        | FY-2324              | March                  | 2024              | 3112.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-006        | FY-2324              | July                   | 2024              | 3224.00                   |
    #
    | NMSS-AY-2324-10000016-4_1  | NMSS-007        | FY-2324              | November               | 2023              | 2069.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-007        | FY-2324              | December               | 2023              | 2726.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-007        | FY-2324              | July                   | 2024              | 3693.00                   |
    #
    | NMSS-AY-2324-10000016-4_1  | NMSS-009        | FY-2324              | September              | 2023              | 5498.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-009        | FY-2324              | February               | 2024              | 3522.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-009        | FY-2324              | June                   | 2024              | 4387.00                   |
    #
    | NMSS-AY-2324-10000016-4_1  | NMSS-010        | FY-2324              | October                | 2023              | 3621.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-010        | FY-2324              | November               | 2023              | 5202.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-010        | FY-2324              | February               | 2024              | 4459.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-010        | FY-2324              | May                    | 2024              | 3749.00                   |
  #
    | NMSS-AY-2324-10000016-4_1  | NMSS-011        | FY-2324              | September              | 2023              | 5498.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-011        | FY-2324              | February               | 2024              | 3522.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-011        | FY-2324              | June                   | 2024              | 4387.00                   |
    #
    | NMSS-AY-2324-10000016-4_1  | NMSS-012        | FY-2324              | October                | 2023              | 3621.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-012        | FY-2324              | November               | 2023              | 5202.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-012        | FY-2324              | February               | 2024              | 4459.00                   |
    | NMSS-AY-2324-10000016-4_1  | NMSS-012        | FY-2324              | May                    | 2024              | 3749.00                   |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (NMSS)    | CofG_NMSS                 |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_NMSS = [CofG_NMSS]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10000016 | 10000016 Co Ltd  | NMSS-AY-2324-Contract-Provider-10000016-4_1             | 4_1            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2324     | Scheduling        | Awaiting Release  | 121573.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_NMSS]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2324-Contract-Provider-10000016-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_NMSS]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 121573.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10000016 | NMSS-AY-2324-Contract-Provider-10000016-4_1             | 4_1            | AY-2324 | NMSS                        | 121573.00    | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2023'

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
    | Released          | 1               | 121573.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10000016' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10000016' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10000016 | 10000016 Co Ltd  | NMSS-AY-2324-Contract-Provider-10000016-4_1             | 4_1            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2324     | Released          | Released          | 121573.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_NMSS]     | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2324-Contract-Provider-10000016-4_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2324-Contract-Provider-10000016-4_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10000016 | NMSS-AY-2324-Contract-Provider-10000016-4_1             | 4_1            | AY-2324 | NMSS                        | 121573.00    | [CofG_NMSS]     | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2324-Contract-Provider-10000016-4_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_NMSS]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000016 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10000016 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10000016 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 121573.00      | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2324 | ?               | 10000016 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10000016 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Conditions of Funding (Grant) (NMSS)      | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10000016 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10000016 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 121573.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | 1619ED        | 1619ED2324          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 39              | 15198.00  | 0.00     | 4581.00  | 0.00     | 0.00     | 0.00     | 2060.00  | 2684.00  | 0.00     | 0.00     | 5873.00  | 0.00     | 0.00     | NMF Pre-16 Funding (NMSS)                                             |                          |
    | [ContractNo]   | [AllocRef_16ED] | 15              | 19843.00  | 2112.00  | 0.00     | 0.00     | 2668.00  | 0.00     | 3940.00  | 0.00     | 2000.00  | 5942.00  | 0.00     | 3181.00  | 0.00     | SSF High Needs Element 2 (NMSS)                                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 13              | 2920.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2920.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Bursary Funds                                                     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 14248.00  | 0.00     | 5388.00  | 0.00     | 0.00     | 2524.00  | 0.00     | 0.00     | 3112.00  | 0.00     | 0.00     | 0.00     | 3224.00  | Teachers Pay Grant (NMSS)                                             |                          |
    | [ContractNo]   | [AllocRef_16ED] | 135             | 8488.00   | 0.00     | 0.00     | 0.00     | 2069.00  | 2726.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3693.00  | Teachers Pension Scheme (NMSS)                                        |                          |
    | [ContractNo]   | [AllocRef_16ED] | 200             | 13407.00  | 0.00     | 5498.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3522.00  | 0.00     | 0.00     | 0.00     | 4387.00  | 0.00     | Recovery Premium (NMSS)                                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 201             | 17031.00  | 0.00     | 0.00     | 3621.00  | 5202.00  | 0.00     | 0.00     | 4459.00  | 0.00     | 0.00     | 3749.00  | 0.00     | 0.00     | Tutoring Grant (NMSS)                                                 |                          |
    | [ContractNo]   | [AllocRef_16ED] | 936             | 13407.00  | 0.00     | 5498.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3522.00  | 0.00     | 0.00     | 0.00     | 4387.00  | 0.00     | Teachers' Pay Additional Grant (NMSS)                                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 937             | 17031.00  | 0.00     | 0.00     | 3621.00  | 5202.00  | 0.00     | 0.00     | 4459.00  | 0.00     | 0.00     | 3749.00  | 0.00     | 0.00     | HTPP High Needs Funding (NMSS)                                                |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '108' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
#
#    # check the contents of the appendices
    #Then the file named '10000016_[contractno]_v1.pdf' in sharepoint location 'edsk-2324-input-appendices' contains the following lines in order
      And   the file named '10000016_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10000016 Co Ltd UKPRN: 10000016
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    16 to 19 Education [AllocRef_16ED] £83,388 £38,185 £121,573
    Total Funding for this contract: £121,573
    Summary of Funding – Page 1

    Agreement Type Non-Maintained Special Schools (NMSS)
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10000016 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE NMSS
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency    
    EDSK NMSS Version 2 (September 2023) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    NMSS on the Manage Your Education & Skills Funding Service between:
    10000016 Co Ltd THE SECRETARY OF STATE FOR
    10 palace Road EDUCATION
    Leeds DEPARTMENT FOR EDUCATION
    Leeds 20 GREAT SMITH STREET
    AND
    Yorkshire LONDON
    LS27 7EF SW1P 3BT
    Company No: AA000016
    Hereinafter called Hereinafter called
    the NMSS the Department
    EDSK NMSS Version 2 (September 2023) Page 2
    EDSK NMSS Version 2 (September 2023) Page 59
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    NON-MAINTAINED SPECIAL SCHOOL SPECIFICATION
    EDSK Schedule 1 – NMSS Version 2 (November 2023) – Page 1
    EDSK Schedule 1 – NMSS Version 2 (November 2023) – Page 11
    
    SCHEDULE 2: PAYMENT
    NON-MAINTAINED SPECIAL SCHOOL EDUCATION PAYMENTS
    EDSK Schedule 2 – NMSS Version 1 (July 2023) – Page 1
    
    16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10000016 Co Ltd UKPRN: 10000016
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    SSF Bursary Funds £2,920 £0 £0 £0 £0 £0 £0 £2,920 £0 £0 £0 £0 £0
    SSF High Needs Element 2 £19,843 £2,112 £0 £0 £2,668 £0 £3,940 £0 £2,000 £5,942 £0 £3,181 £0
    NMF Pre-16 Funding £15,198 £0 £4,581 £0 £0 £0 £2,060 £2,684 £0 £0 £5,873 £0 £0
    Teachers Pay Grant £14,248 £0 £5,388 £0 £0 £2,524 £0 £0 £3,112 £0 £0 £0 £3,224
    Teachers Pension Scheme £8,488 £0 £0 £0 £2,069 £2,726 £0 £0 £0 £0 £0 £0 £3,693
    Recovery Premium £13,407 £0 £5,498 £0 £0 £0 £0 £3,522 £0 £0 £0 £4,387 £0
    Tutoring Grant £17,031 £0 £0 £3,621 £5,202 £0 £0 £4,459 £0 £0 £3,749 £0 £0
    16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 - NMSS Version 1 (July 2023) – Page 1
    
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10000016_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10000016_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10000016'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10000016 - 10000016 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10000016 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10000016 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10000016 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10000016_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000016 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10000016 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000016 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10000016 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10000016 | 10000016 Co Ltd  | NMSS-AY-2324-Contract-Provider-10000016-4_1             | 4_1            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (NMSS)     | NMSS                        | 16-19ED2324     | Contract Approved | Contract Approved | 121573.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_NMSS]     | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10000016 | NMSS-AY-2324-Contract-Provider-10000016-4_1             | 4_1            | AY-2324 | NMSS                        | 121573.00    | [CofG_NMSS]     | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2324-Contract-Provider-10000016-4_1             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '9' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                       | DeliverableDescription      |
    | 10000016 | [ContractNo]   | 1               | [AllocRef_16ED]  | 39              | 0                     | 15198.00     | 0             | 0        | NMF Pre-16 Funding (NMSS)                                             | ?                           |
    | 10000016 | [ContractNo]   | 1               | [AllocRef_16ED]  | 15              | 0                     | 19843.00     | 0             | 0        | SSF High Needs Element 2 (NMSS)                                       | ?                           |
    | 10000016 | [ContractNo]   | 1               | [AllocRef_16ED]  | 13              | 0                     | 2920.00      | 0             | 0        | SSF Bursary Funds                                                     | ?                           |
    | 10000016 | [ContractNo]   | 1               | [AllocRef_16ED]  | 118             | 0                     | 14248.00     | 0             | 0        | Teachers Pay Grant (NMSS)                                             | ?                           |
    | 10000016 | [ContractNo]   | 1               | [AllocRef_16ED]  | 135             | 0                     | 8488.00      | 0             | 0        | Teachers Pension Scheme (NMSS)                                        | ?                           |
    | 10000016 | [ContractNo]   | 1               | [AllocRef_16ED]  | 200             | 0                     | 13407.00     | 0             | 0        | Recovery Premium (NMSS)                                               | ?                           |
    | 10000016 | [ContractNo]   | 1               | [AllocRef_16ED]  | 201             | 0                     | 17031.00     | 0             | 0        | Tutoring Grant (NMSS)                                                 | ?                           |
    | 10000016 | [ContractNo]   | 1               | [AllocRef_16ED]  | 936             | 0                     | 13407.00     | 0             | 0        | Teachers' Pay Additional Grant (NMSS)                                               | ?                           |
    | 10000016 | [ContractNo]   | 1               | [AllocRef_16ED]  | 937             | 0                     | 17031.00     | 0             | 0        | HTPP High Needs Funding (NMSS)                                                | ?                           |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    # Part 8: CDA
    
    # Run the CDA report
    Given there is no CDA report named 'CDA Latest Version AK006.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |

    When  the following CDA report is run
    | FundingStreamPeriod     | Version               | Suffix |
    | 1619ED2324           | Latest Version           | AK006   |
    
    Then  a report named 'CDA Latest Version AK006.csv' is created

          
	# Check the above report manually




   # Part 9: Payment Batch for 1619ED2324

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '1619ED2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_16ED]          | 202308 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 1619ED2324      		 | 202308               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 1619ED2324           	 | 202308               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '1619ED2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod '1619ED2324' AccountingPaymentPeriod '202305' and CensusEndDate '02/08/2023'

   
   @AcceptanceTest @Complete
@CFS
Scenario: AK007 Import, release and approve a PSG funding allocation for 23/24 with deliverable 43. CofG_SPI. Provider Subtype = 'Special post 16 institution'. Check docs, CRM, PaaS and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10000017'
    And   there is no Funding Allocation data in CRM for UKPRN '10000017'
    And   there is no Contract, Task or Workflow data for UKPRN '10000017'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10000017'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10000017'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10000017' in the Sharepoint 'EDSK-2324-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (SPI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10000017' 
    And   there is no caseload advisor for UKPRN '10000017' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000017 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10000017' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10000017 Co Ltd' with UKPRN '10000017' and OrgId 'ORG0000017' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000017 | 100017 | 10000017 Co Ltd | 0              | Locked Restructure    | Yes           | AA000017      | ?             | 5 Palace Road          | City Center            | ?                      | ?                      | Leeds                  | Yorkshire              | LS17 1PF  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000017 |







    # Populate the stub with PSG (Special post 16 institution) data

    # Change the date 
    Given the override date is '01/07/2023'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10000017 | PSG-AY-2324-Contract-Provider-10000017-3_2            | 3_2            | PSG                         | AY-2324            | 26410.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | PSG-AY-2324-10000017-3_2   | 3_2                    | PSG-AY-2324-Contract-Provider-10000017-3_2            | 10000017      | Other types                        | Special post 16 institution      | 26410.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | PSG-AY-2324-10000017-3_2   | PSG-001         | 13205.00         | Payment         |
    | PSG-AY-2324-10000017-3_2   | PSG-002         | 13205.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | PSG-AY-2324-10000017-3_2   | PSG-001         | FY-2324              | November               | 2023              | 3367.00                   |
    | PSG-AY-2324-10000017-3_2   | PSG-001         | FY-2324              | March                  | 2024              | 4265.00                   |
    | PSG-AY-2324-10000017-3_2   | PSG-001         | FY-2324              | May                    | 2024              | 5573.00                   |

    | PSG-AY-2324-10000017-3_2   | PSG-002         | FY-2324              | November               | 2023              | 3367.00                   |
    | PSG-AY-2324-10000017-3_2   | PSG-002         | FY-2324              | March                  | 2024              | 4265.00                   |
    | PSG-AY-2324-10000017-3_2   | PSG-002         | FY-2324              | May                    | 2024              | 5573.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2023'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2324        | 16-19ED2324  | Conditions of Funding (Grant) (SPI)     | CofG_SPI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_SPI = [CofG_SPI]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10000017 | 10000017 Co Ltd  | PSG-AY-2324-Contract-Provider-10000017-3_2              | 3_2            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2324     | Scheduling        | Awaiting Release  | 26410.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_SPI]        | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2324-Contract-Provider-10000017-3_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 26410.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10000017 | PSG-AY-2324-Contract-Provider-10000017-3_2              | 3_2            | AY-2324 | PSG                         | 26410.00    | [CofG_SPI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2023'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_SPI]        |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_SPI = [CofG_SPI]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_SPI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 26410.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10000017' for FundingType 'EDSK' and period '2324'
   #When  I retrieve the latest EFA contract details from CRM for provider '10000017' for FundingType 'EDSK' and period '2324' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10000017 | 10000017 Co Ltd  | PSG-AY-2324-Contract-Provider-10000017-3_2              | 3_2            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2324     | Released          | Released          | 26410.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_SPI]      | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2324-Contract-Provider-10000017-3_2              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | PSG-AY-2324-Contract-Provider-10000017-3_2              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10000017 | PSG-AY-2324-Contract-Provider-10000017-3_2              | 3_2            | AY-2324 | PSG                         | 26410.00    | [CofG_SPI]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | PSG-AY-2324-Contract-Provider-10000017-3_2              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_SPI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000017 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10000017 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10000017 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 26410.00      | 1                     | 0                        | 01/08/2023        | 31/07/2024      | True          | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2324 | ?               | 10000017 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10000017 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2023        | 31/07/2024      | False         | False               | ?             | Conditions of Funding (Grant) (SPI)       | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10000017 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10000017 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 26410.00        | ?             | ?                | 01/08/2023 | 31/07/2024 | 1619ED        | 1619ED2324          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableName                                                       | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 13205.00  | 0.00     | 0.00     | 0.00     | 3367.00  | 0.00     | 0.00     | 0.00     | 4265.00  | 0.00     | 5573.00  | 0.00     | 0.00     | Primary PE and Sport Premium (Initial Payment) (NMSS)                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 938             | 13205.00  | 0.00     | 0.00     | 0.00     | 3367.00  | 0.00     | 0.00     | 0.00     | 4265.00  | 0.00     | 5573.00  | 0.00     | 0.00     | Primary PE and Sport Premium (Final Payment) (NMSS)                            |                          |


    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
#
#    # Check the contents of the Appendices
#    And   the file named '10000017_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2023/24
#    Organisation Name: 10000017 Co Ltd UKPRN: 10000017
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
#    16 to 19 Education [AllocRef_16ED] £7,632 £5,573 £13,205
#    Total Funding for this contract: £13,205
#    Summary of Funding – Page 1Primary PE and Sport Premium (Oct Payment)
#    
#    Agreement Type Specialist Post-16 Institution
#    Funding Period 1 August 2023 to 31 July 2024
#    Between the Secretary of State for Education
#    And 10000017 Co Ltd
#    Funding for 16 to 19 Education
#    Master Agreement
#    [MasterContractNo]
#    Number
#    ACCEPTANCE BY THE PROVIDER
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Version 1  (July 2023) Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    Provider on the Manage Your Education & Skills Funding Service between:
#    10000017 Co Ltd THE SECRETARY OF STATE FOR
#    5 Spurway Parade EDUCATION
#    Woodford Avenue DEPARTMENT FOR EDUCATION
#    Ilford 20 GREAT SMITH STREET
#    AND
#    Essex LONDON
#    IG2 6UU SW1P 3BT
#    Company No: AA018030
#    Hereinafter called Hereinafter called
#    the Provider the Department
#    EDSK Version 1 (July 2023) Page 2
#    EDSK Version 1 (July 2023) Page 71
#    
#    SCHEDULE 1: SPECIFICATION & MONITORING
#    16-19 EDUCATION SPECIFICATION
#    EDSK Schedule 1 – 16 to 19 Education Version 1 SPI (July 2023) – Page 1
#    EDSK Schedule 1 – 16 to 19 Education Version 1 SPI (July 2023) – Page 12
#
#    SCHEDULE 2: PAYMENT
#    16-19 EDUCATION PAYMENT
#    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2023) – Page 1
#    
#    SCHEDULE 2 – 16 TO 19 EDUCATION
#    Funding Agreement – 16 to 19 Education
#    Provider: 10000017 Co Ltd UKPRN: 10000017
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
#    Contract Ref: [AllocRef_16ED]
#    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
#    Primary PE and Sport Premium £13,205 £0.00 £0.00 £0.00 £3,367.00 £0.00 £0.00 £0.00 £4,265.00 £0.00 £5,573.00 £0.00 £0.00
#    Total Funding £13,205 £0.00 £0.00 £0.00 £3,367.00 £0.00 £0.00 £0.00 £4,265.00 £0.00 £5,573.00 £0.00 £0.00
#    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    SCHEDULE 3: NOT USED
#    EDSK Schedule 3 Version 1 (July 2023) – Page 1
#    EDSK Schedule 9 Version 1 (July 2023) – Page 5
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10000017_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10000017_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10000017'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10000017 - 10000017 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10000017 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10000017 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10000017 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10000017_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000017 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10000017 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000017 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10000017 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10000017 | 10000017 Co Ltd  | PSG-AY-2324-Contract-Provider-10000017-3_2              | 3_2            | Education & Skills Funding | AY2324  | Conditions of Funding (Grant) (SPI)      | PSG                         | 16-19ED2324     | Contract Approved | Contract Approved | 26410.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_SPI]      | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10000017 | PSG-AY-2324-Contract-Provider-10000017-3_2              | 3_2            | AY-2324 | PSG                         | 26410.00    | [CofG_SPI]      | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | PSG-AY-2324-Contract-Provider-10000017-3_2              | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                           | DeliverableDescription      |
    | 10000017 | [ContractNo]   | 1               | [AllocRef_16ED]  | 43              | 0                     | 13205.00     | 0             | 0        | Primary PE and Sport Premium (Initial Payment) (NMSS)| ?                           |
    | 10000017 | [ContractNo]   | 1               | [AllocRef_16ED]  | 938             | 0                     | 13205.00     | 0             | 0        | Primary PE and Sport Premium (Final Payment) (NMSS)| ?                           |


        # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
#
#    # Part 8: CDA
#    
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version AK007.csv'
##
##    Then  the contracts are in the replicated CRM database as follows
##    | ContractNumber | ContractVersionNumber |
##    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version               | Suffix |
#    | 1619ED2324           | Latest Version           | AK007   |
#    
#    Then  a report named 'CDA Latest Version AK007.csv' is created

          
	# Check the above report manually




   # Part 9: Payment Batch for 1619ED2324

    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '1619ED2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_16ED]          | 202308 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 1619ED2324      		 | 202308               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 1619ED2324           	 | 202308               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '1619ED2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod '1619ED2324' AccountingPaymentPeriod '202305' and CensusEndDate '02/08/2023'


    