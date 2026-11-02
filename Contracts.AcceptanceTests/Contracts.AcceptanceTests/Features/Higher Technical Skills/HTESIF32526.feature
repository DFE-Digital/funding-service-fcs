Feature: HTESIF32526


        @AcceptanceTest @Inprogress
    @Long2Run @Long2Run67

    Scenario: AK029 Bulk load a HTE-SIF3 2526 new contract and do NFA notification amendment, NFA vary amendment. Check docs. 
    Given there are no allocations marked as Under Termination for UKPRN '10000029' 
    And   there are no terminated or closed allocations for UKPRN '10000029' 
    And   there is no Contract, Task or Workflow data for UKPRN '10000029' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10000029' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10000029' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | HTE-SIF32526  |



     #Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | FA_HTESIF32526_2025-02-01.docx| 2024-05-11 10:00:00.000 |



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10000029'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10000029' 
    And   there is no caseload advisor for UKPRN '10000029' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000029 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10000029' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10000029 Co Ltd' with UKPRN '10000029' and OrgId 'ORG0010029' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000029 | 100029 | 10000029 Co Ltd | 0              | In Administration     | Yes           | AA010029      | ?             | 6 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Bardford                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000029 |





    # Change the date
    Given the override date is '01/01/2025'

    # Bulk file  
    And   there are no files prefixed '10000029' in the Sharepoint 'HTE-SIF3-2526-Input-Appendices' folder
    And   there are no files prefixed 'HTE-SIF3 HTES3 2526 05112024164257 v1_AK029' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'HTE-SIF3 HTES3 2526 05112024164257 v1_AK029' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'HTE-SIF3 HTES3 2526 05112024164257 v1_AK029' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'HTE-SIF3 HTES3 2526 05112024164257 v1_AK029' in the Sharepoint 'Reports' folder
    And   spreadsheet 'HTE-SIF3 HTES3 2526 05112024164257 v1_AK029.xlsx' exists in the Datafiles folder and UKPRN '10000029' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10000029' for FundingType 'HTE-SIF3' and period '2526'

      #Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    #Then  the file named '10000029_[ContractNo]_v1.pdf' in Sharepoint location 'HTE-SIF3-2526-Input-Appendices' contains the following lines in order
    #"""
    #Annex H – Grant payment schedule
    #Provider: 10000029 Co Ltd UKPRN: 10000029
    #Master Contract Number: [MasterContractNo] Start Date: 01/02/2025 End Date: 31/03/2026
    #Contract Ref: [AllocRef_HTSIF3]
    #Cash (£) Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025 Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026
    #Capital Grants to Central Government £118,328 £1,952 £1561000 £3,952 £4,952 £5,952 £6,952 £7,952 £8,952 £9,952 £10,952 £11,952 £12,952 £13,952
    #- FE Colleges
    #Capital Grants to Private Sector - £47,250 £450 £1561000 £1,350 £1,800 £2,250 £2,700 £3,150 £3,600 £4,050 £4,500 £4,950 £5,400 £5,850
    #Persons & NPISH
    #Total Funding £165,578 £2,402 £1561000 £5,302 £6,752 £8,202 £9,652 £11,102 £12,552 £14,002 £15,452 £16,902 £18,352 £19,802
    #Higher Technical Education Skills Injection Fund– [AllocRef_HTSIF3] – Page 1 Ref (for internal use only):  [ContractNo] v1
    #"""

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10000029_[ContractNo]_v1.pdf' in 'HTE-SIF3-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK029.pdf'

    
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
    | 10000029 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2025        | 31/03/2026      | ?             |
    | 10000029 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2025        | 31/03/2026      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-11-04 09:12:35.000 |



    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
 #   And the following document templates have Upload timestamps as indicated
 #   | DocumentTemplateName          | UploadTimestamp         |
 #   | FA_HTESIF22526_2023-11-01.docx | 2023-11-24 22:22:22.000 | 
	#



    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '28/11/2023'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000029 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/02/2025        | 31/03/2026      | Notification  |
    | 10000029 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/02/2025        | 31/03/2026      | ?             |
    | 10000029 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2025        | 31/03/2026      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10000029' for FundingType 'HTE-SIF' and period '2526' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10000029' for FundingType 'HTE-SIF3' and period '2526'


    # Save a copy of the output
    Then  Sharepoint file '10000029_[ContractNo]_v2.pdf' in 'HTE-SIF3-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK008_v2.pdf'



    # Publish then withdraw the contract
    
    # Change the date
    Given the override date is '02/10/2024'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'HTE-SIF3 Test withdrawal' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000029 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/02/2025        | 31/03/2026      | Notification  |
    | 10000029 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2025        | 31/03/2026      | ?             |
    | 10000029 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2025        | 31/03/2026      | ?             |




    # Execute a NON-FINANCIAL amendment variation on v2 to create v3

    # Change the date
    Given the override date is '05/01/2025'

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10000029'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000029 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/02/2025        | 31/03/2026      | Variation     |
    | 10000029 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               |01/02/2025         | 31/03/2026      | Notification  |
    | 10000029 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                |01/02/2025         | 31/03/2026      | ?             |
    | 10000029 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               |01/02/2025         | 31/03/2026      | ?             |


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10000029' for FundingType 'SB' and period '2023' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10000029' for FundingType 'HTE-SIF3' and period '2526'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    #Then  the file named '10000029_[ContractNo]_v3.pdf' in Sharepoint location 'HTE-SIF3-2526-Input-Appendices' contains the following lines in order
    #"""
    #Annex H – Grant payment schedule
    #Provider: 10000029 Co Ltd UKPRN: 10000029
    #Master Contract Number: [MasterContractNo] Start Date: 01/02/2025 End Date: 31/03/2026
    #Contract Ref: [AllocRef_HTSIF3]
    #Cash (£) Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025 Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026
    #Capital Grants to Central Government £118,328 £1,952 £1561000 £3,952 £4,952 £5,952 £6,952 £7,952 £8,952 £9,952 £10,952 £11,952 £12,952 £13,952
    #– FE Colleges
    #Capital Grants to Private Sector – £47,250 £450 £1561000 £1,350 £1,800 £2,250 £2,700 £3,150 £3,600 £4,050 £4,500 £4,950 £5,400 £5,850
    #Persons & NPISH
    #Total Funding £165,578 £2,402 £1561000 £5,302 £6,752 £8,202 £9,652 £11,102 £12,552 £14,002 £15,452 £16,902 £18,352 £19,802
    #Higher Technical Education Skills Injection Fund– [AllocRef_HTSIF3] – Page 1 Ref (for internal use only):  [ContractNo] v3
    #"""




    # Save a copy of the output
    Then  Sharepoint file '10000029_[ContractNo]_v3.pdf' in 'HTE-SIF3-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK029_v3.pdf'


    # Tidy Up
    And   the override date is reset

