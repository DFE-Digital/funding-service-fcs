Feature: Higher Technical Education - Skills Injection Fund HTES2223


@AcceptanceTest @Withdrawn20260521
Scenario: S011 Bulk load a HTE-SIF 2223 new contract and do NFA notification amendment, NFA vary amendment. Check docs. 
    Given there are no allocations marked as Under Termination for UKPRN '10018011' 
    And   there are no terminated or closed allocations for UKPRN '10018011' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018011' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018011' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018011' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | HTE-SIF2223   |



    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | FA_HTESIF2223_2023-01-01.docx | 2022-02-20 10:00:00.000 |



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018011'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018011' 
    And   there is no caseload advisor for UKPRN '10018011' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018011 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018011' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10018011 Co Ltd' with UKPRN '10018011' and OrgId 'ORG0018011' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018011 | 118011 | 10018011 Co Ltd | 0              | In Administration     | Yes           | AA018011      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018011 |





    # Change the date
    Given the override date is '01/03/2022'

    # Bulk file 
    And   there are no files prefixed '10018011' in the Sharepoint 'HTE-SIF-2223-Input-Appendices' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 30102022164257 v1_S011' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 30102022164257 v1_S011' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 30102022164257 v1_S011' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 30102022164257 v1_S011' in the Sharepoint 'Reports' folder
    And   spreadsheet 'HTE-SIF HTES 2223 30102022164257 v1_S011.xlsx' exists in the Datafiles folder and UKPRN '10018011' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018011' for FundingType 'HTE-SIF' and period '2223'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018011_[ContractNo]_v1.pdf' in Sharepoint location 'HTE-SIF-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10018011 Co Ltd UKPRN: 10018011
    Master Contract Number: [MasterContractNo] Start Date: 01/01/2023 End Date: 31/03/2024
    Contract Ref: [AllocRef_HTSIF]
    Cash (£) Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
    HTE Skills Injection Fund - Capital £134,280 £1,952 £2,952 £3,952 £4,952 £5,952 £6,952 £7,952 £8,952 £9,952 £10,952 £11,952 £12,952 £13,952 £14,952 £15,952
    HTE Skills Injection Fund - £54,000 £450 £900 £1,350 £1,800 £2,250 £2,700 £3,150 £3,600 £4,050 £4,500 £4,950 £5,400 £5,850 £6,300 £6,750
    Programme
    Total Funding £188,280 £2,402 £3,852 £5,302 £6,752 £8,202 £9,652 £11,102 £12,552 £14,002 £15,452 £16,902 £18,352 £19,802 £21,252 £22,702
    Higher Technical Education Skills Injection Fund– [AllocRef_HTSIF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """


    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018011_[ContractNo]_v1.pdf' in 'HTE-SIF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S011.pdf'

    
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
    | 10018011 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2023        | 31/03/2024      | ?             |
    | 10018011 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2023        | 31/03/2024      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |



    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | FA_HTESIF2223_2023-01-01.docx | 2022-07-24 22:22:22.000 | 
	



    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '28/07/2022'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018011 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2023        | 31/03/2024      | Notification  |
    | 10018011 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/01/2023        | 31/03/2024      | ?             |
    | 10018011 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2023        | 31/03/2024      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10018011' for FundingType 'HTE-SIF' and period '2223' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10018011' for FundingType 'HTE-SIF' and period '2223'


    # Save a copy of the output
    Then  Sharepoint file '10018011_[ContractNo]_v2.pdf' in 'HTE-SIF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S011_v2.pdf'



    # Publish then withdraw the contract
    
    # Change the date
    Given the override date is '02/10/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'HTESIF Test withdrawal' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018011 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/01/2023        | 31/03/2024      | Notification  |
    | 10018011 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2023        | 31/03/2024      | ?             |
    | 10018011 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2023        | 31/03/2024      | ?             |




    # Execute a NON-FINANCIAL amendment variation on v2 to create v3

    # Change the date
    Given the override date is '05/10/2022'

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018011'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018011 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2023        | 31/03/2024      | Variation     |
    | 10018011 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/01/2023        | 31/03/2024      | Notification  |
    | 10018011 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/01/2023        | 31/03/2024      | ?             |
    | 10018011 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2023        | 31/03/2024      | ?             |


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10018011' for FundingType 'SB' and period '2022' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10018011' for FundingType 'HTE-SIF' and period '2223'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018011_[ContractNo]_v3.pdf' in Sharepoint location 'HTE-SIF-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10018011 Co Ltd UKPRN: 10018011
    Master Contract Number: [MasterContractNo] Start Date: 01/01/2023 End Date: 31/03/2024
    Contract Ref: [AllocRef_HTSIF]
    Cash (£) Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
    HTE Skills Injection Fund - Capital £134,280 £1,952 £2,952 £3,952 £4,952 £5,952 £6,952 £7,952 £8,952 £9,952 £10,952 £11,952 £12,952 £13,952 £14,952 £15,952
    HTE Skills Injection Fund - £54,000 £450 £900 £1,350 £1,800 £2,250 £2,700 £3,150 £3,600 £4,050 £4,500 £4,950 £5,400 £5,850 £6,300 £6,750
    Programme
    Total Funding £188,280 £2,402 £3,852 £5,302 £6,752 £8,202 £9,652 £11,102 £12,552 £14,002 £15,452 £16,902 £18,352 £19,802 £21,252 £22,702
    Higher Technical Education Skills Injection Fund– [AllocRef_HTSIF] – Page 1 Ref (for internal use only):  [ContractNo] v3
    """



    # Save a copy of the output
    Then  Sharepoint file '10018011_[ContractNo]_v3.pdf' in 'HTE-SIF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S011_v3.pdf'


    # Tidy Up
    And   the override date is reset



    
@AcceptanceTest @Withdrawn20260521
Scenario: S013 Bulk load a HTE-SIF 2223 new contract and do Amend (vary). Publish and approve. Check docs. Run payment batch and generate reports. 
    Given there are no allocations marked as Under Termination for UKPRN '10018013' 
    And   there are no terminated or closed allocations for UKPRN '10018013' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018013' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018013' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018013' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | HTE-SIF2223   |



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018013'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018013' 
    And   there is no caseload advisor for UKPRN '10018013' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018013 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018013' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10018013 Co Ltd' with UKPRN '10018013' and OrgId 'ORG0018013' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018013 | 118013 | 10018013 Co Ltd | 0              | In Administration     | Yes           | AA018013      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018013 |





    # Change the date
    Given the override date is '01/03/2022'

    # Bulk file 
    And   there are no files prefixed '10018013' in the Sharepoint 'HTE-SIF-2223-Input-Appendices' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 30102022164257 v1_S013a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 30102022164257 v1_S013a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 30102022164257 v1_S013a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 30102022164257 v1_S013a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'HTE-SIF HTES 2223 30102022164257 v1_S013a.xlsx' exists in the Datafiles folder and UKPRN '10018013' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018013' for FundingType 'HTE-SIF' and period '2223'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018013_[ContractNo]_v1.pdf' in Sharepoint location 'HTE-SIF-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10018013 Co Ltd UKPRN: 10018013
    Master Contract Number: [MasterContractNo] Start Date: 01/01/2023 End Date: 31/03/2024
    Contract Ref: [AllocRef_HTSIF]
    Cash (£) Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
    HTE Skills Injection Fund - Capital £52,395 £987 £1,345 £1,703 £2,061 £2,419 £2,777 £3,135 £3,493 £3,851 £4,209 £4,567 £4,925 £5,283 £5,641 £5,999
    HTE Skills Injection Fund - £14,880 £3,456 £3,000 £2,544 £2,088 £1,632 £1,176 £720 £264 £0 £0 £0 £0 £0 £0 £0
    Programme
    Total Funding £67,275 £4,443 £4,345 £4,247 £4,149 £4,051 £3,953 £3,855 £3,757 £3,851 £4,209 £4,567 £4,925 £5,283 £5,641 £5,999
    Higher Technical Education Skills Injection Fund– [AllocRef_HTSIF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018013_[ContractNo]_v1.pdf' in 'HTE-SIF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S013v1.pdf'

    
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
    | 10018013 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2023        | 31/03/2024      | ?             |
    | 10018013 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2023        | 31/03/2024      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |




    # Bulk amend the HTE-SIF alloc 22/23 contract and check v2 docs

    Given the override date is '05/09/2022'

    # Bulk file 'Amend Vary' 
    And   there are no files prefixed '10018013' in the Sharepoint 'HTE-SIF-2223-Input-Appendices' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 10112022164257 v1_S013b' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 10112022164257 v1_S013b' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 10112022164257 v1_S013b' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'HTE-SIF HTES 2223 10112022164257 v1_S013b' in the Sharepoint 'Reports' folder
    And   spreadsheet 'HTE-SIF HTES 2223 10112022164257 v1_S013b.xlsx' exists in the Datafiles folder and UKPRN '10018013' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018013' for FundingType 'HTE-SIF' and period '2223'

    # Check the contents of the Appendices (All doc parts should be present)
    Then  the file named '10018013_[ContractNo]_v2.pdf' in Sharepoint location 'HTE-SIF-2223-Input-Appendices' contains the following lines in order
    """ 
    Annex H – Grant payment schedule
    Provider: 10018013 Co Ltd UKPRN: 10018013
    Master Contract Number: [MasterContractNo] Start Date: 01/01/2023 End Date: 31/03/2024
    Contract Ref: [AllocRef_HTSIF]
    Cash (£) Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
    HTE Skills Injection Fund - Capital £52,395 £987 £1,345 £1,703 £2,061 £2,419 £2,777 £3,135 £3,493 £3,851 £4,209 £4,567 £4,925 £5,283 £5,641 £5,999
    HTE Skills Injection Fund - £21,873 £3,456 £3,000 £2,544 £2,088 £1,632 £1,176 £720 £264 £999 £999 £999 £999 £999 £999 £999
    Programme
    Total Funding £74,268 £4,443 £4,345 £4,247 £4,149 £4,051 £3,953 £3,855 £3,757 £4,850 £5,208 £5,566 £5,924 £6,282 £6,640 £6,998
    Higher Technical Education Skills Injection Fund– [AllocRef_HTSIF] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                    | 0                        | 2022-09-15 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018013_[ContractNo]_v2.pdf' in 'HTE-SIF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S013_v2.pdf'

    
    # Part 8: CDA
    
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version S013.csv'
##
##    Then  the contracts are in the replicated CRM database as follows
##    | ContractNumber | ContractVersionNumber |
##    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | HTE-SIF2223           | Latest Version        | S013   |
#
#    Then  a report named 'CDA Latest Version S013.csv' is created
#	# Check the above report manually


#    # Part 9: Payment Batch for HTE-SIF2223
#
#    # Change the date
#    Given the override date is '04/01/2023 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'HTE-SIF2223' AccountingPaymentPeriod '202210' CensusEndDate '04/01/2023' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_HTSIF]         | 202301 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | HTE-SIF2223      		     | 202301               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | HTE-SIF2223           	 | 202301               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'HTE-SIF2223' PaymentPeriod '202210' CensusEndDate '04/01/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S013.xml'
#
##
##    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
##    And   the Payment feed xml for FundingStreamPeriod 'HTE-SIF2223' PaymentPeriod '202210' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' includes the following values
##    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
##    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_HTSIF]  | 929.43          | RECONCILIATION   | 19-24Trn19+Hardship                | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100932     |
##    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_HTSIF]  | 947.96          | RECONCILIATION   | 19-24Trn20+Childcare               | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100933     |
##    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_HTSIF]  | 1203.59         | RECONCILIATION   | 19-24TrnRsdntlAccess               | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100934     |
##    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_HTSIF]  | 674.97          | RECONCILIATION   | 19-24TrnAdminExp                   | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100935     |
##    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_HTSIF]  | 530.40          | RECONCILIATION   | 19-24TrnC19Response                | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100936     |
##    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_HTSIF]  | 574.70          | RECONCILIATION   | 19-24 Traineeships                 | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 2355800    |
##    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_HTSIF]  | 458.03          | RECONCILIATION   | 19-24TraineeshpsLngS               | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 2355860    |
##
#
#
#
#    # Retrieve data from the Payment Feed and check for specific items and values (23926)
#    Then  there is an item on the Payment feed for FundingStreamPeriod 'HTE-SIF2223' AccountingPaymentPeriod '202210' and CensusEndDate '04/01/2023'
#
##
##    # Title details
##    And   the Payment feed item TITLE is as follows
##    | Title                                                                                                                                                          |
##    | Payment Requests for Funding Stream Period HTE-SIF2223 for Payment Period 202210 have been generated as of Census End Date/Time 2022-09-08T22:00:00Z.       |
##
##
##    # Summary details
##    And   the Payment feed item SUMMARY is as follows
##    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
##    | HTE-SIF2223         | 202210        | 2022-09-08T22:00:00Z  | 7                | 5319.08    |
##
##    # PaymentPeriod details
##    And   the Payment feed item PaymentPeriod details are as follows
##    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
##    | ESFA   | 19TR      | 01/08/2022   | 31/07/2023 | 08/09/2022    | 20/09/2022 | 2022          | 05             |
##
##    # PaymentDetails
##    And   the Payment feed item PaymentDetails are as follows
##    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef         | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
##    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_HTSIF]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100932     | RECONCILIATION | 19-24Trn19+Hardship           | 929.43          |
##    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_HTSIF]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100933     | RECONCILIATION | 19-24Trn20+Childcare          | 947.96          |
##    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_HTSIF]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100934     | RECONCILIATION | 19-24TrnRsdntlAccess          | 1203.59         |
##    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_HTSIF]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100935     | RECONCILIATION | 19-24TrnAdminExp              | 674.97          |
##    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_HTSIF]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100936     | RECONCILIATION | 19-24TrnC19Response           | 530.40          |
##    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_HTSIF]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355800    | RECONCILIATION | 19-24 Traineeships            | 574.70          |
##    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_HTSIF]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355860    | RECONCILIATION | 19-24TraineeshpsLngS          | 458.03          |
##
##
##    # Check ADP
##
##    # Check all activity has completed
##    When  there are no messages left in the system
##
##    # Check financials on the ADP feed for Aug-22
##    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
##    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
##    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_HTSIF]  | 1               | 202301 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
##    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_HTSIF]  | 2               | 202301 | 574.70      | 0.00           | 0.00             | 574.70                | 0.00           | 574.70     |
##    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_HTSIF]  | 3               | 202301 | 458.03      | 0.00           | 0.00             | 458.03                | 0.00           | 458.03     |
##    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_HTSIF]  | 4               | 202301 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
##    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_HTSIF]  | 5               | 202301 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
##    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_HTSIF]  | 6               | 202301 | 929.43      | 0.00           | 0.00             | 929.43                | 0.00           | 929.43     |
##    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_HTSIF]  | 7               | 202301 | 947.96      | 0.00           | 0.00             | 947.96                | 0.00           | 947.96     |
##    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_HTSIF]  | 8               | 202301 | 1203.59     | 0.00           | 0.00             | 1203.59               | 0.00           | 1203.59    |
##    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_HTSIF]  | 9               | 202301 | 674.97      | 0.00           | 0.00             | 674.97                | 0.00           | 674.97     |
##    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_HTSIF]  | 10              | 202301 | 530.40      | 0.00           | 0.00             | 530.40                | 0.00           | 530.40     |
#
#
#
#
#   #  Part 10: Create Consolidated Payment Summary rpt
#   
#   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
##   Given there are no files prefixed '2023-01 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
##
##   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '05/01/2023'
##    # Check the above report manually
##
##    
##   
#
#
#
##   Given there are no files prefixed '2023-01 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
##   
##
##   When  a Consolidated Payment Summary Report is created in Sharepoint for '11/01/2023'
##    # Check the above report manually
