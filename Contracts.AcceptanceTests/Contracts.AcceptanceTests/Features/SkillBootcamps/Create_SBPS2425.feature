Feature: Create_SBPS2425

     @AcceptanceTest @Complete
@Long2Run @Long2Run67
Scenario: AK023 Bulk load a SBPS2425 new contract and do NFA notification amendment, NFA vary amendment. Check docs. 
    Given there are no allocations marked as Under Termination for UKPRN '10000023' 
    And   there are no terminated or closed allocations for UKPRN '10000023' 
    And   there is no Contract, Task or Workflow data for UKPRN '10000023' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10000023' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10000023' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | SBPS2425  |



    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    #And the following document templates have Upload timestamps as indicated
    #| DocumentTemplateName       | UploadTimestamp         |
    #| FA_TTF2425_2024-04-01.docx | 2024-04-01 22:22:22.000 | 



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10000023'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10000023' 
    And   there is no caseload advisor for UKPRN '10000023' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000023 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10000023' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10000023 Co Ltd' with UKPRN '10000023' and OrgId 'ORG0010023' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000023 | 100023 | 10000023 Co Ltd | 0              | In Administration     | Yes           | AA010023      | ?             | 6 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Bardford                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000023 |





    # Change the date
    Given the override date is '01/06/2024'

    # Bulk file  
    And   there are no files prefixed '10000023' in the Sharepoint 'EDSK-2425-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2425 20062024105948 v3_AK023' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2425 20062024105948 v3_AK023' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2425 20062024105948 v3_AK023' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2425 20062024105948 v3_AK023' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2425 20062024105948 v3_AK023.xlsx' exists in the Datafiles folder and UKPRN '10000023' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    #And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10000023' for FundingType 'EDSK' and period '2425'

     
    Then  the file named '10000023_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10000023 Co Ltd UKPRN: 10000023
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    Skills Bootcamps - Delivered through Project S [AllocRef_SBPS] £71,601 £22,112 £93,713    
    of which Initial Set Up Cost £33,588 £12,993 £46,581
   	of which Initial Course Costs £38,013 £9,119 £47,132
    Total Funding for this contract: £93,713
    Summary of Funding – Page 1
   
       
    SKILLS BOOTCAMPS - DELIVERED THROUGH PROJECT S
    Funding Agreement – Skills Bootcamps - Delivered through Project S
    Provider: 10000023 Co Ltd UKPRN: 10000023
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_SBPS]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    of which Initial Set Up Cost £46,581 £5,448 £7,774 £6,637 £4,207 £1,436 £1,796 £4,939 £1,351 £2,051 £4,174 £5,756 £1,012
    of which Initial Course Costs £47,132 £3,070 £1,117 £6,977 £3,187 £6,605 £6,415 £2,763 £7,879 £2,593 £438 £1,064 £5,024
    Total Funding £93,713 £8,518 £8,891 £13,614 £7,394 £8,041 £8,211 £7,702 £9,230 £4,644 £4,612 £6,820 £6,036
   	Skills Bootcamps - Delivered through Project S – Funding Agreement [AllocRef_SBPS] – Page 1 Ref (for internal use only):  [ContractNo] v1
 
 
  """
   
 


    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10000023_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK023.pdf'

    
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
    | 10000023 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10000023 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |


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
    | DocumentTemplateName          | UploadTimestamp         |
    | FA_TTF2425_2024-04-01.docx | 2024-04-01 22:22:22.000 | 
	



    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '01/06/2024'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000023 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2024        | 31/07/2025      | Notification  |
    | 10000023 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10000023 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |




    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10000023' for FundingType 'HTE-SIF' and period '2324' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10000023' for FundingType 'EDSK' and period '2425'


    # Save a copy of the output
    Then  Sharepoint file '10000023_[ContractNo]_v2.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK023_v2.pdf'

       # Publish then withdraw the contract
    
    # Change the date
    Given the override date is '01/06/2024'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'SBPS Test withdrawal' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10000023 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2024        | 31/07/2025      | Notification  |
    | 10000023 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10000023 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

 # Execute a NON-FINANCIAL amendment variation on v2 to create v3

 # Change the date
 Given the override date is '01/06/2024'

 # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
 And   there are no Sector-based Work Academies profile values in config for UKPRN '10000023'

 # Issue a non-financial VARIATION amendment on v1 to create v2
 When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

 # Check the CONTRACT version, status and dates in CRM
 Then  the following contract values are present in CRM
 | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
 | 10000023 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2024        | 31/07/2025      | Variation     |
 | 10000023 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2024        | 31/07/2025      | Notification  |
 | 10000023 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2024        | 31/07/2025      | ?             |
 | 10000023 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |


 # Retrieve parameters
#When  I retrieve the latest EFA contract details from CRM for provider '10000018' for FundingType 'SB' and period '2023' and Delivery Organisation '00000000'
 When  I retrieve the latest contract details from CRM for provider '10000023' for FundingType 'EDSK' and period '2425'

 # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10000023_[ContractNo]_v3.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10000023 Co Ltd UKPRN: 10000023
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    Skills Bootcamps - Delivered through Project S [AllocRef_SBPS] £71,601 £22,112 £93,713    
    of which Initial Set Up Cost £33,588 £12,993 £46,581
   	of which Initial Course Costs £38,013 £9,119 £47,132
    Total Funding for this contract: £93,713
    Summary of Funding – Page 1 
 
  """



 # Save a copy of the output
 Then  Sharepoint file '10000023_[ContractNo]_v3.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK023_v3.pdf'


 # Tidy Up
 And   the override date is reset
   