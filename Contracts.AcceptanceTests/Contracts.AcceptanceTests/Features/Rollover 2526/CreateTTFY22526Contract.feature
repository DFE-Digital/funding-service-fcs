Feature: CreateTTFY22526Contract

@AcceptanceTest @Complete
@Long2Run @Long2Run67
Scenario: AK045 Bulk load a TTFY22526 new contract and do NFA notification amendment, NFA vary amendment. Check docs. 
    Given there are no allocations marked as Under Termination for UKPRN '10000045' 
    And   there are no terminated or closed allocations for UKPRN '10000045' 
    And   there is no Contract, Task or Workflow data for UKPRN '10000045' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10000045' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10000045' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | TTFY2  |



    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
       | FA_TTF2526_2025-04-01.docx | 2025-04-01 22:22:22.000 | 



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10000045'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10000045' 
    And   there is no caseload advisor for UKPRN '10000045' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000045 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10000045' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10000045 Co Ltd' with UKPRN '10000045' and OrgId 'ORG0010045' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000045 | 100045 | 10000045 Co Ltd | 0              | In Administration     | Yes           | AA010045      | ?             | 6 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Bardford                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000045 |





    # Change the date
    Given the override date is '01/06/2025'

    # Bulk file  
    And   there are no files prefixed '10000045' in the Sharepoint 'TTFY2-2526-Input-Appendices' folder
    And   there are no files prefixed 'TTFY2 FY 2526 15082025105948 v1_AK045' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'TTFY2 FY 2526 15082025105948 v1_AK045' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'TTFY2 FY 2526 15082025105948 v1_AK045' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'TTFY2 FY 2526 15082025105948 v1_AK045' in the Sharepoint 'Reports' folder
    And   spreadsheet 'TTFY2 FY 2526 15082025105948 v1_AK045.xlsx' exists in the Datafiles folder and UKPRN '10000045' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    #And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10000045' for FundingType 'TTFY2' and period '2526'
#
#    # 
#    Then  the file named '10000037_[ContractNo]_v1.pdf' in Sharepoint location 'TTF-2526-Input-Appendices' contains the following lines in order
#       """
#    Annex H – Grant payment schedule
#    Provider: 10000045 Co Ltd UKPRN: 10000045
#    Master Contract Number: [MasterContractNo] Start Date: 01/04/2025 End Date: 31/03/2026
#    Contract Ref: [AllocRef_TTFY2]
#    Cash (£) Apr 2025 May 2025 Jun 2025 Jul 2025 Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026
#    Taking Teaching Futher - College £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
#    Taking Teaching Further - LA £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
#    Taking Teaching Further - Other £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
#    Total Funding £360,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000
#    Taking Teaching Further (TTFY2) 2526 – [AllocRef_TTFUY2] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    """

    
   
 


    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10000045_[ContractNo]_v1.pdf' in 'TTFY2-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK045.pdf'

    
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
    | 10000045 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2025        | 31/03/2026      | ?             |
    | 10000045 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2025        | 31/03/2026      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
   And   the following document creation details exist in the ContractManagement.CreatedContract table
   | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
   | [ContractNo]   | 1                     | 0                        | 2025-06-01 09:12:35.000 |



    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | FA_TTF2526_2025-04-01.docx | 2025-04-01 22:22:22.000 | 
	



    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '01/06/2025'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000045 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                | True          | False               | 01/04/2025        | 31/03/2026      | Notification  |
    | 10000045 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2025        | 31/03/2026      | ?             |
    | 10000045 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2025        | 31/03/2026      | ?             |




    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10000045' for FundingType 'HTE-SIF' and period '2324' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10000045' for FundingType 'TTFY2' and period '2526'


    # Save a copy of the output
    Then  Sharepoint file '10000045_[ContractNo]_v2.pdf' in 'TTFY2-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK045_v2.pdf'

       # Publish then withdraw the contract
    
    # Change the date
    Given the override date is '01/06/2025'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'TTFY2 Test withdrawal' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000045 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/04/2025        | 31/03/2026      | Notification  |
    | 10000045 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2025        | 31/03/2026      | ?             |
    | 10000045 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2025        | 31/03/2026      | ?             |

 # Execute a NON-FINANCIAL amendment variation on v2 to create v3

 # Change the date
 Given the override date is '01/06/2025'

 # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
 And   there are no Sector-based Work Academies profile values in config for UKPRN '10000045'

 # Issue a non-financial VARIATION amendment on v1 to create v2
 When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

 # Check the CONTRACT version, status and dates in CRM
 Then  the following contract values are present in CRM
 | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
 | 10000045 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2025        | 31/03/2026      | Variation     |
 | 10000045 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/04/2025        | 31/03/2026      | Notification  |
 | 10000045 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2025        | 31/03/2026      | ?             |
 | 10000045 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2025        | 31/03/2026      | ?             |


 # Retrieve parameters
#When  I retrieve the latest EFA contract details from CRM for provider '10000018' for FundingType 'SB' and period '2023' and Delivery Organisation '00000000'
 When  I retrieve the latest contract details from CRM for provider '10000045' for FundingType 'TTFY2' and period '2526'

## Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
 #Then  the file named '10000037_[ContractNo]_v3.pdf' in Sharepoint location 'TTF-2526-Input-Appendices' contains the following lines in order
 #  """
 #   Annex H – Grant payment schedule
 #   Provider: 10000045 Co Ltd UKPRN: 10000045
 #   Master Contract Number: [MasterContractNo] Start Date: 01/04/2025 End Date: 31/03/2026
 #   Contract Ref: [AllocRef_TTFY2]
 #   Cash (£) Apr 2025 May 2025 Jun 2025 Jul 2025 Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026
 #   Taking Teaching Futher - College £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
 #   Taking Teaching Further - LA £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
 #   Taking Teaching Further - Other £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
 #   Total Funding £360,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000 £30,000
 #   Taking Teaching Further (TTF) 2526 – [AllocRef_TTFUY2] – Page 1 Ref (for internal use only):  [ContractNo] v3
 #   """




 # Save a copy of the output
 Then  Sharepoint file '10000045_[ContractNo]_v3.pdf' in 'TTFY2-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK045_v3.pdf'


# # Tidy Up
# And   the override date is reset
#
#
#
#  Given the override date is '02/06/2025 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'TTFY22425' AccountingPaymentPeriod '202503' CensusEndDate '02/06/2025' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_TTFY2]          | 202506 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | TTFY22425                   | 202506               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | TTFY22425                   | 202506               | NotStarted |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'TTFY22425' PaymentPeriod '202503' CensusEndDate '02/06/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'Ak045.xml'
#
#
#
#      # Run the CDA report for TTF2526
#    Given the override date is '02/06/2025'
#    Given there is no CDA report named 'CDA Latest Version AK045.csv'
#    And   the following ADF Pipeline run
#    And   the following CDA report is run
#    | FundingStreamPeriod   | Version         | Suffix |
#    | TTFY22425                | Latest Version  | AK045   |
# 
#    Then  a report named 'CDA Latest Version AK045.csv' is created
