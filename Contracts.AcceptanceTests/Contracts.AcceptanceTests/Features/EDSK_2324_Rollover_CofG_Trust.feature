Feature: EDSK_2324_Rollover_CofG_Trust

@AcceptanceTest @Withdrawn20260521
Scenario: S017 Bulk load a EDSK 2324 contract with CofG(Trust) contract type for ALLBC, ALLF alloc. Check docs. NFA amendment. Generate payments. CDA and Payment summary reports validation.
    Given there are no allocations marked as Under Termination for UKPRN '10018016' 
    And   there are no terminated or closed allocations for UKPRN '10018016' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018016' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018016' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018016' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | ALLBC2324     |
    | ALLF2324      |



    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName	                                | UploadTimestamp         |
    | EDSK2324_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx       | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3ON_COFG_EMPLOYER_2022-08-01.docx		    | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3ON_CFS_ITP_2022-08-01.docx		            | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_LOANS_COFG_2022-08-01.docx		        | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_LOANS_CFS_2022-08-01.docx		            | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S1_LOANS_COFG_2022-08-01.docx		        | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S1_LOANS_CFS_2022-08-01.docx		            | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S1_LOANS_COFG_2023-08-01.docx		        | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S1_LOANS_CFS_2023-08-01.docx		            | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3ON_COFG_LA_TRUST_HEI_2023-08-01.docx	    | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3ON_COFG_EMPLOYER_2023-08-01.docx		    | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3ON_CFS_ITP_2023-08-01.docx		            | 2023-05-01 17:55:54.950 | 
    | EDSK2324_TAC_AA_LA_2023-08-01.docx                    | 2023-05-01 17:55:54.950 | 
    | EDSK2324_TAC_AA_College_2023-08-01.docx           	| 2023-05-01 17:55:54.950 |
    | EDSK2324_TAC_COFG_TRUST_2023-08-01.docx           	| 2023-05-01 17:55:54.950 |
    | EDSK2324_TAC_COFG_LA_2023-08-01.docx           	    | 2023-05-01 17:55:54.950 |
    | EDSK2324_TAC_COFG_HEI_2023-08-01.docx           	    | 2023-05-01 17:55:54.950 |
    | EDSK2324_TAC_COFG_EMPLOYER_2023-08-01.docx           	| 2023-05-01 17:55:54.950 |
    | EDSK2324_TAC_CFS_ITP_2023-08-01.docx           	    | 2023-05-01 17:55:54.950 |
    | EDSK2324_S4ON_AA_LA_2023-08-01.docx               	| 2023-05-01 17:55:54.950 | 
    | EDSK2324_S4ON_AA_COLLEGE_2023-08-01.docx      		| 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3_LOANS_AA_LA_2023-08-01.docx    		    | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S3_LOANS_AA_COLLEGE_2023-08-01.docx          | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_LOANS_AA_LA_2023-08-01.docx		        | 2023-05-01 17:55:54.950 | 
    | EDSK2324_S2_LOANS_AA_COLLEGE_2023-08-01.docx		    | 2023-05-01 17:55:54.950 | 
    | SOF_EDSK_2023-08-01.docx		                        | 2023-05-01 17:55:54.950 | 
    | FA_EDSK2324_2023-08-01.docx		                    | 2023-05-01 17:55:54.950 | 
    

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018016'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018016' 
    And   there is no caseload advisor for UKPRN '10018016' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018016 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018016' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018016 Co Ltd' with UKPRN '10018016' and OrgId 'ORG0018016' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018016 | 118016 | 10018016 Co Ltd | 0              | In Administration     | Yes           | AA018016      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018016 |





    # Change the date
    Given the override date is '01/06/2023'

    # Bulk file
    And   there are no files prefixed '10018016' in the Sharepoint 'EDSK-2324-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2324 01032023164257 v1_S016' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2324 01032023164257 v1_S016' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2324 01032023164257 v1_S016' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2324 01032023164257 v1_S016' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2324 01032023164257 v1_S016.xlsx' exists in the Datafiles folder and UKPRN '10018016' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018016' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018016_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10018016 Co Ltd UKPRN: 10018016
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £148,392 £96,996 £245,388
    Advanced Learner Loans Bursary [AllocRef_ALLC] £177,540 £90,090 £267,630
    Total Funding for this contract: £513,018
    Summary of Funding – Page 1

    Agreement Type Conditions of Funding (Grant) (Trusts)
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10018016 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 3 (September 2023) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10018016 Co Ltd THE SECRETARY OF STATE FOR
    46 The Avenue EDUCATION
    Bournemouth DEPARTMENT FOR EDUCATION
    Dorset 20 GREAT SMITH STREET
    AND
    BH9 2UW LONDON
    SW1P 3BT
    Company No: AA018016
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (September 2023) Page 2
    EDSK Version 3 (September 2023) Page 74

    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    SCHEDULE 1B: MONITORING
    ADVANCED LEARNER LOANS MONITORING (PAY ON PROFILE)
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    Advanced Learner Loans Bursary

    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10018016 Co Ltd UKPRN: 10018016
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Facility £245,388 £15,224 £16,174 £17,124 £18,074 £19,024 £19,974 £20,924 £21,874 £22,824 £23,774 £24,724 £25,674
    Total Funding £245,388 £15,224 £16,174 £17,124 £18,074 £19,024 £19,974 £20,924 £21,874 £22,824 £23,774 £24,724 £25,674
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10018016 Co Ltd UKPRN: 10018016
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Bursary Funding £267,630 £22,000 £22,055 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
    Total Funding £267,630 £22,000 £22,055 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2023) – Page 1
    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (July 2023) – Page 1
    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (July 2023) – Page 1
    SCHEDULE 6: UK GDPR AND DATA PROTECTION
    PROCESSING, PERSONAL DATA AND DATA SUBJECTS
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    SCHEDULE 8: EXIT ARRANGEMENTS
    SCHEDULE 9: SUB-CONTRACTING
    EDSK Schedule 9 Version 2 (July 2023) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018016_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018016_[ContractNo]_v1.pdf'

    
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
    | 10018016 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018016 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |



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


    | DocumentTemplateName	                                | UploadTimestamp         |
    | EDSK2324_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx       | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S3ON_COFG_EMPLOYER_2022-08-01.docx		    | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S3ON_CFS_ITP_2022-08-01.docx		            | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S2_LOANS_COFG_2022-08-01.docx		        | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S2_LOANS_CFS_2022-08-01.docx		            | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S1_LOANS_COFG_2022-08-01.docx		        | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S1_LOANS_CFS_2022-08-01.docx		            | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S1_LOANS_COFG_2023-08-01.docx		        | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S1_LOANS_CFS_2023-08-01.docx		            | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S3ON_COFG_LA_TRUST_HEI_2023-08-01.docx	    | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S3ON_COFG_EMPLOYER_2023-08-01.docx		    | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S3ON_CFS_ITP_2023-08-01.docx		            | 2023-07-11 17:55:54.950 | 
    | EDSK2324_TAC_AA_LA_2023-08-01.docx                    | 2023-07-11 17:55:54.950 | 
    | EDSK2324_TAC_AA_College_2023-08-01.docx           	| 2023-07-11 17:55:54.950 | 
    | EDSK2324_S4ON_AA_LA_2023-08-01.docx               	| 2023-07-11 17:55:54.950 | 
    | EDSK2324_S4ON_AA_COLLEGE_2023-08-01.docx      		| 2023-07-11 17:55:54.950 | 
    | EDSK2324_S3_LOANS_AA_LA_2023-08-01.docx    		    | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S3_LOANS_AA_COLLEGE_2023-08-01.docx          | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S2_LOANS_AA_LA_2023-08-01.docx		        | 2023-07-11 17:55:54.950 | 
    | EDSK2324_S2_LOANS_AA_COLLEGE_2023-08-01.docx		    | 2023-07-11 17:55:54.950 |
    | EDSK2324_TAC_COFG_TRUST_2023-08-01.docx           	| 2023-07-11 17:55:54.950 |
    | EDSK2324_TAC_COFG_LA_2023-08-01.docx           	    | 2023-07-11 17:55:54.950 |
    | EDSK2324_TAC_COFG_HEI_2023-08-01.docx           	    | 2023-07-11 17:55:54.950 |
    | EDSK2324_TAC_COFG_EMPLOYER_2023-08-01.docx           	| 2023-07-11 17:55:54.950 |
    | EDSK2324_TAC_CFS_ITP_2023-08-01.docx           	    | 2023-07-11 17:55:54.950 |




    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '22/07/2023'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018016 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10018016 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018016 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10018011' for FundingType 'HTE-SIF' and period '2223' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10018016' for FundingType 'EDSK' and period '2324'


    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018016_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10018016 Co Ltd UKPRN: 10018016
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £148,392 £96,996 £245,388
    Advanced Learner Loans Bursary [AllocRef_ALLC] £177,540 £90,090 £267,630
    Total Funding for this contract: £513,018
    Summary of Funding – Page 1
    """

    # Save a copy of the output
    Then  Sharepoint file '10018016_[ContractNo]_v2.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018016_[ContractNo]_v2.pdf'

   # Then stop





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
    Given there is no CDA report named 'CDA Latest Version S016.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |

    When  the following CDA report is run
    | FundingStreamPeriod   | Version               | Suffix |
    | ALLBC2324             | Latest Version        | S016   |
    | ALLF2324              | Latest Version        | S016   |


    Then  a report named 'CDA Latest Version S016.csv' is created
	# Check the above report manually


    # Part 9: Payment Batch for EDSK2324

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
    | ALLBC2324      		     | 202308               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLBC2324                	 | 202308               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLBC2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S017a.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'ALLBC2324' AccountingPaymentPeriod '202305' and CensusEndDate '02/08/2023'
 

   #  Part 10: Create Consolidated Payment Summary rpt
   
   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
   Given there are no files prefixed '2023-08 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder

   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '03/08/2023'
    # Check the above report manually

    
   


    # Tidy Up
    Given the override date is reset


