Feature: EDSK_ASFCRollover2425


@AcceptanceTest @Complete
@Long2Run @Long2Run67
Scenario: AK024 Bulk load a EDSK 2425 contract with CofG(Trust) contract type for  ASFC-ASCL2425, ASFC-FCFJ2425 and STFIG2425 allocs. Check docs. NFA amendment. Generate payments. CDA and Payment summary reports validation.
    Given there are no allocations marked as Under Termination for UKPRN '10000024' 
    And   there are no terminated or closed allocations for UKPRN '10000024' 
    And   there is no Contract, Task or Workflow data for UKPRN '10000024' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10000024' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10000024' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASFC-ASCL2425     |
    | ASFC-FCFJ2425     |
    | STFIG2425         |



    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         | 
    | FA_EDSK2324_2023-08-01.docx                  | 2024-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_LA_2023-08-01.docx        | 2024-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_COLLEGE_2023-08-01.docx   | 2024-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_LA_2023-08-01.docx        | 2024-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_COLLEGE_2023-08-01.docx   | 2024-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_COFG_2023-08-01.docx         | 2024-02-20 10:00:00.000 |
    | EDSK2324_S1_AEB_COFG_2023-08-01.docx         | 2024-02-20 10:00:00.000 |
 
    

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10000024'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10000024' 
    And   there is no caseload advisor for UKPRN '10000024' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000024 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10000024' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10000024 Co Ltd' with UKPRN '10000024' and OrgId 'ORG0010024' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000024 | 010024 | 10000024 Co Ltd | 0              | In Administration     | Yes           | AA010024      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000024 |





    # Change the date
    Given the override date is '01/06/2024'

    # Bulk file
    And   there are no files prefixed '10000024' in the Sharepoint 'EDSK-2425-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2425 09062024105948 v3_AK024' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2425 09062024105948 v3_AK024' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2425 09062024105948 v3_AK024' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2425 09062024105948 v3_AK024' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2425 09062024105948 v3_AK024.xlsx' exists in the Datafiles folder and UKPRN '10000024' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
   # And   'Success' is displayed in field 'X2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10000024' for FundingType 'EDSK' and period '2425'

 #place code here
    
   Then  the file named '10000024_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10000024 Co Ltd UKPRN: 10000024
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    ESFA Adult Skills Fund (Grant) [AllocRef_ASCA] £443,905 £277,176 £721,081    
    of which Funding for Innovative Provision £156,935 £90,090 £247,025
	of which Tailored Learning £156,935 £90,090 £247,025
    ESFA ASF - Free Courses for Jobs [AllocRef_ASFC] £156,935 £90,090 £247,025
    ESFA ASF - Short Term Funding Initiatives [AllocRef_STFG] £600,840 £367,266 £968,106
    of which Short Term Funding Initiative 1 £130,035 £96,996 £227,031
    of which Short Term Funding Initiative 2 £156,935 £90,090 £247,025
    of which Short Term Funding Initiative 3 £156,935 £90,090 £247,025
    of which Short Term Funding Initiative 4 £156,935 £90,090 £247,025
    Total Funding for this contract: £1,936,212
    Summary of Funding – Page 1
   
    Agreement Type Conditions of Funding (Grant) (Trusts)
    Funding Period 1 August 2024 to 31 July 2025
    Between the Secretary of State for Education
    And 10000024 Co Ltd
    Funding for ESFA-Adult Skills Fund    
    ACCEPTANCE BY THE PROVIDER
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Conditions of Funding (Grant) (Trusts)
    Version 2 – July 2024 – Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10000024 Co Ltd THE SECRETARY OF STATE FOR
    46 The Avenue EDUCATION
    Bournemouth DEPARTMENT FOR EDUCATION
    Dorset 20 GREAT SMITH STREET
    BH9 2UW LONDON    
    SW1P 3BT
    Company No: AA010024
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Conditions of Funding (Grant) (Trusts)
    Version 2 – July 2024 – Page 2
    EDSK Conditions of Funding (Grant) (Trusts)
    Version 2 – July 2024 – Page 58

    
    SCHEDULE 1: DEFINITIONS
    Schedule 1
    Version 2 – July 2024 – Page 1
    Schedule 1
    Version 2 – July 2024 – Page 14
	
    SCHEDULE 2: SPECIFICATION & MONITORING
    Schedule 2: ESFA Adult Skills Fund 
    Version 1 – July 2024 – Page 1
    Schedule 2: ESFA Adult Skills Fund 
    Version 1 – July 2024 – Page 8

    SCHEDULE 3: PAYMENT
    Schedule 3: ESFA Adult Skills Fund
    Version 1 – July 2024 – Page 1

   
         
    ESFA-ADULT SKILLS FUND
    Funding Agreement – ESFA Adult Skills Fund (Grant)
    Provider: 10000024 Co Ltd UKPRN: 10000024
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_ASCA]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
	ESFA Adult Skills Fund (Grant) £721,081 £59,224 £19,074 £61,344 £62,404 £45,107 £64,524 £65,584 £66,644 £67,704 £68,764 £69,824 £70,884
	of which Tailored Learning £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
    of which Funding for Innovative Provision £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
	Total Funding £721,081 £59,224 £19,074 £61,344 £62,404 £45,107 £64,524 £65,584 £66,644 £67,704 £68,764 £69,824 £70,884    
	ESFA-Adult Skills Fund – Funding Agreement [AllocRef_ASCA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ESFA-ADULT SKILLS FUND
	Funding Agreement – ESFA ASF - Free Courses for Jobs
    Provider: 10000024 Co Ltd UKPRN: 10000024
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_ASFC]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
	Total Funding £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605    
	ESFA-Adult Skills Fund – Funding Agreement [AllocRef_ASFC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ESFA-ADULT SKILLS FUND
    Funding Agreement – ESFA ASF - Short Term Funding Initiatives
    Provider: 10000024 Co Ltd UKPRN: 10000024
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_STFG]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    ESFA ASF - Short Term Funding Initiative 1 £227,031 £15,224 £16,174 £17,124 £18,074 £667 £19,974 £20,924 £21,874 £22,824 £23,774 £24,724 £25,674
    ESFA ASF - Short Term Funding Initiative 2 £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
    ESFA ASF - Short Term Funding Initiative 3 £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
    ESFA ASF - Short Term Funding Initiative 4 £247,025 £22,000 £1,450 £22,110 £22,165 £22,220 £22,275 £22,330 £22,385 £22,440 £22,495 £22,550 £22,605
    Total Funding £968,106 £81,224 £20,524 £83,454 £84,569 £67,327 £86,799 £87,914 £89,029 £90,144 £91,259 £92,374 £93,489    
	ESFA-Adult Skills Fund – Funding Agreement [AllocRef_STFG] – Page 1 Ref (for internal use only):  [ContractNo] v1


    SCHEDULE 4: UK GDPR/DATA PROTECTION
    Schedule 4
    Version 2 – July 2024 – Page 1
    Schedule 4
    Version 2 – July 2024 – Page 2

    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
    Schedule 5
    Version 2 – July 2024 – Page 1
    Schedule 5
    Version 2 – July 2024 – Page 9


    SCHEDULE 6: EXIT ARRANGEMENTS
    Schedule 6
    Version 2 – July 2024 – Page 1
    Schedule 6
    Version 2 – July 2024 – Page 5
    
        
    SCHEDULE 7: SUBCONTRACTING
    Schedule 7
    Version 2 – July 2024 – Page 1
    Schedule 7
    Version 2 – July 2024 – Page 5
     """
     

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10000024_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK024_v1.pdf'

    
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
    | 10000024 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10000024 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-06-01 09:12:35.000 |


    
    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated


    | DocumentTemplateName	                          | UploadTimestamp         |
    | FA_EDSK2324_2023-08-01.docx                  | 2024-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_LA_2023-08-01.docx        | 2024-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_COLLEGE_2023-08-01.docx   | 2024-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_LA_2023-08-01.docx        | 2024-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_COLLEGE_2023-08-01.docx   | 2024-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_COFG_2023-08-01.docx         | 2024-02-20 10:00:00.000 |
    | EDSK2324_S1_AEB_COFG_2023-08-01.docx         | 2024-02-20 10:00:00.000 | 




    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '22/07/2024'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000024 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2024        | 31/07/2025      | Variation     |
    | 10000024 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10000024 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10018011' for FundingType 'HTE-SIF' and period '2223' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10000024' for FundingType 'EDSK' and period '2425'

    #place code here
     Then  the file named '10000024_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10000024 Co Ltd UKPRN: 10000024
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    ESFA Adult Skills Fund (Grant) [AllocRef_ASCA] £443,905 £277,176 £721,081
    of which Tailored Learning £156,935 £90,090 £247,025
    of which Funding for Innovative Provision £156,935 £90,090 £247,025
    ESFA ASF - Free Courses for Jobs [AllocRef_ASFC] £156,935 £90,090 £247,025
    ESFA ASF - Short Term Funding Initiatives [AllocRef_STFG] £600,840 £367,266 £968,106
    of which Short Term Funding Initiative 1 £130,035 £96,996 £227,031
    of which Short Term Funding Initiative 2 £156,935 £90,090 £247,025
    of which Short Term Funding Initiative 3 £156,935 £90,090 £247,025
    of which Short Term Funding Initiative 4 £156,935 £90,090 £247,025
    Total Funding for this contract: £1,936,212
    Summary of Funding – Page 1
    """
    # Save a copy of the output
    Then  Sharepoint file '10000024_[ContractNo]_v2.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK024_v2.pdf'

    #Then stop





    # Publish and Approve the contract
    
    # Change the date
    Given the override date is '01/08/2024'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'


       
   
   # Part 9: Payment Batch for AEBC-ASCL2324

    # Change the date
    Given the override date is '02/08/2024 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASFC-ASCL2425' AccountingPaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_ASCA]          | 202408 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASFC-ASCL2425      		 | 202408               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ASFC-ASCL2425           	 | 202408               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ASFC-ASCL2425' PaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK024b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'ASFC-ASCL2425' AccountingPaymentPeriod '202405' and CensusEndDate '02/08/2024'

   
      # Part 9: Payment Batch for AEBC-NSF2324

    # Change the date
    Given the override date is '02/08/2024 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASFC-FCFJ2425' AccountingPaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_ASCA]          | 202408 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASFC-FCFJ2425      		 | 202408               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ASFC-FCFJ2425           	 | 202408               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ASFC-FCFJ2425' PaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'ASFC-FCFJ2425' AccountingPaymentPeriod '202405' and CensusEndDate '02/08/2024'


     # Part 9: Payment Batch for AEBC-STF2324

    # Change the date
    Given the override date is '02/08/2024 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'STFIG2425' AccountingPaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
     | ContractAllocationNumber | Period |
     | [AllocRef_STFG]          | 202408 |
    
    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | STFIG2425         		 | 202408               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | STFIG2425             	 | 202408               | Completed |
   
    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'STFIG2425' PaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK004b.xml'



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'STFIG2425' AccountingPaymentPeriod '202405' and CensusEndDate '02/08/2024'

