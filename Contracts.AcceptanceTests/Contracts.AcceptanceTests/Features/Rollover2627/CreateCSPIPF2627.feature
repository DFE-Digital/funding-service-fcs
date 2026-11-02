Feature: CreateCSPIPF2627


@AcceptanceTest @Complete
@Long2Run @Long2Run67
Scenario: AK051 Bulk load a CSPIPF2627 new contract and do NFA notification amendment, NFA vary amendment. Check docs. 
    Given there are no allocations marked as Under Termination for UKPRN '10010051' 
    And   there are no terminated or closed allocations for UKPRN '10010051' 
    And   there is no Contract, Task or Workflow data for UKPRN '10010051' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010051' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10010051' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | CSPIPF2627  |



    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
       | FA_CSPIPF2627_2026-04-01.docx | 2026-02-01 22:22:22.000 | 



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10010051'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010051' 
    And   there is no caseload advisor for UKPRN '10010051' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010051 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010051' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10010051 Co Ltd' with UKPRN '10010051' and OrgId 'ORG0010051' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010051 | 100051 | 10010051 Co Ltd | 0              | In Administration     | Yes           | AA010051      | ?             | 6 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Bardford                 | BH9 2UX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010051 |





    # Change the date
    Given the override date is '01/04/2026'

    # Bulk file  
    And   there are no files prefixed '10010051' in the Sharepoint 'CSP-IPF-2627-Input-Appendices' folder
    And   there are no files prefixed 'CSP-IPF FY 2627 14082025105948 v1_AK051' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'CSP-IPF FY 2627 14082025105948 v1_AK051' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'CSP-IPF FY 2627 14082025105948 v1_AK051' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'CSP-IPF FY 2627 14082025105948 v1_AK051' in the Sharepoint 'Reports' folder
    And   spreadsheet 'CSP-IPF FY 2627 14082025105948 v1_AK051.xlsx' exists in the Datafiles folder and UKPRN '10010051' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    #And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10010051' for FundingType 'CSP-IPF' and period '2627'

     
   # Then  the file named '10000051_[ContractNo]_v1.pdf' in Sharepoint location 'CSP-IPF-2627-Input-Appendices' contains the following lines in order
   # """
   # Annex H – Grant payment schedule
   # Provider: 10010051 Co Ltd UKPRN: 10010051
   # Master Contract Number: [MasterContractNo] Start Date: 01/04/2026 End Date: 31/03/2027
   # Contract Ref: [AllocRef_CSIPF]
   # Cash (£) Apr 2026 May 2026 Jun 2026 Jul 2026 Aug 2026 Sep 2026 Oct 2026 Nov 2026 Dec 2026 Jan 2027 Feb 2027 Mar 2027
   #Construction Skills Package: Industry Placements £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
   #Fund
   #Total Funding £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
   #Construction Skills Package: Industry Placements Fund (CSP-IPF) 2627 – [AllocRef_CSIPF] – Page 1 Ref (for internal use only):  [ContractNo] v1
   # """

    
   
 


    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010051_[ContractNo]_v1.pdf' in 'CSP-IPF-2627-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK051.pdf'

    
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
    | 10010051 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2026        | 31/03/2027      | ?             |
    | 10010051 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2026        | 31/03/2027      | ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
   And   the following document creation details exist in the ContractManagement.CreatedContract table
   | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
   | [ContractNo]   | 1                     | 0                        | 2026-02-01 09:12:35.000 |



    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | FA_CSPIPF2627_2026-04-01.docx | 2026-02-01 22:22:22.000 |



    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '01/04/2026'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010051 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2026        | 31/03/2027      | Notification  |
    | 10010051 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2026        | 31/03/2027      | ?             |
    | 10010051 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2026        | 31/03/2027      | ?             |




    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10010051' for FundingType 'HTE-SIF' and period '2324' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10010051' for FundingType 'CSP-IPF' and period '2627'


    # Save a copy of the output
    Then  Sharepoint file '10010051_[ContractNo]_v2.pdf' in 'CSP-IPF-2627-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK051_v2.pdf'

       # Publish then withdraw the contract
    
    # Change the date
    Given the override date is '01/04/2026'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'CSP-IPF Test withdrawal' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010051 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/04/2026        | 31/03/2027      | Notification  |
    | 10010051 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2026        | 31/03/2027      | ?             |
    | 10010051 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2026        | 31/03/2027      | ?             |

 # Execute a NON-FINANCIAL amendment variation on v2 to create v3

 # Change the date
 Given the override date is '01/04/2026'

 # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
 And   there are no Sector-based Work Academies profile values in config for UKPRN '10010051'

 # Issue a non-financial VARIATION amendment on v1 to create v2
 When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

 # Check the CONTRACT version, status and dates in CRM
 Then  the following contract values are present in CRM
 | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
 | 10010051 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2026        | 31/03/2027      | Variation     |
 | 10010051 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/04/2026        | 31/03/2027      | Notification  |
 | 10010051 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2026        | 31/03/2027      | ?             |
 | 10010051 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2026        | 31/03/2027      | ?             |


 # Retrieve parameters
#When  I retrieve the latest EFA contract details from CRM for provider '10000018' for FundingType 'SB' and period '2023' and Delivery Organisation '00000000'
 When  I retrieve the latest contract details from CRM for provider '10010051' for FundingType 'CSP-IPF' and period '2627'

 ### Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
 #Then  the file named '10010051_[ContractNo]_v3.pdf' in Sharepoint location 'CSP-IPF-2627-Input-Appendices' contains the following lines in order
 #  """
 #   Annex H – Grant payment schedule
 #   Provider: 10010051 Co Ltd UKPRN: 10010051
 #   Master Contract Number: [MasterContractNo] Start Date: 01/04/2026 End Date: 31/03/2027
 #   Contract Ref: [AllocRef_CSIPF]
 #   Cash (£) Apr 2026 May 2026 Jun 2026 Jul 2026 Aug 2026 Sep 2026 Oct 2026 Nov 2026 Dec 2026 Jan 2027 Feb 2027 Mar 2027
 #  Construction Skills Package: Industry Placements £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
 #  Fund
 #  Total Funding £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
 #  Construction Skills Package: Industry Placements Fund (CSP-IPF) 2627 – [AllocRef_CSIPF] – Page 1 Ref (for internal use only):  [ContractNo] v1
 #   """





 # Save a copy of the output
 Then  Sharepoint file '10010051_[ContractNo]_v3.pdf' in 'CSP-IPF-2627-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK051_v3.pdf'

#
# # Tidy Up
# And   the override date is reset
#  #
#    # CDA
#    
#    # Change the date
#    Given the override date is '02/04/2026'
##
##    # Run the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version AK051.csv'
#    And   the following ADF Pipeline run
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | CSPIPF2627            | Last Approved Version | AK051  |
#
#    Then  a report named 'CDA Last Approved Version AK051.csv' is created


    

    
    