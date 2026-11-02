Feature: DeleteDraftBulkIntent

@AcceptanceTest @InProgress
Scenario: A037 Bulk create a draft ESF1420 contract with several deliverables. Bulk update the financials on some deliverables, add new deliverables and delete others. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017037' 
    And   there are no terminated or closed allocations for UKPRN '10017037' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017037' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017037' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ESF1420           |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017037' 
    And   there is no caseload advisor for UKPRN '10017037' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017037 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017037' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017037 Co Ltd' with UKPRN '10017037' and OrgId 'ORG0017037' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017037 | 117037 | 10017037 Co Ltd | 0              | Provider Under Change | Yes           | AA017037      | ?             | 25 High Street         | Cobham                 | Surrey                 | ?                      | ?                      | ?                      | KT11 3DH  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017037 |





    # Bulk New ESF1420 contract

    # Change the date
    Given the override date is '01/07/2020'

    # Bulk file
    And   there are no files prefixed '10017037' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 06012022144404 v3_A037_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 06012022144404 v3_A037_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 06012022144404 v3_A037_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 06012022144404 v3_A037_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 06012022144404 v3_A037_1.xlsx' exists in the Datafiles folder and UKPRN '10017037' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017037' for FundingType 'ESF' and period '1420' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017037' for FundingType 'ESF' and period '1420'

    # Display Sharepoint filename
    And   message '10017037_[ContractNo]_v1.pdf' is written to the Output window

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017037 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/03/2022      | ?             |
    | 10017037 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '80' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'





    # Bulk update to add, delete and amend deliverables

    # Change the date
    Given the override date is '01/08/2020'

    # Bulk file
    And   there are no files prefixed '10017037' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 06012022144405 v3_A037_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 06012022144405 v3_A037_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 06012022144405 v3_A037_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 06012022144405 v3_A037_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 06012022144405 v3_A037_2.xlsx' exists in the Datafiles folder and UKPRN '10017037' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017037 | [ContractNo]       | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/03/2022      | ?             |
    | 10017037 | [ContractNo]       | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2020        | 31/03/2022      | ?             |
    | 10017037 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '80' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'


    # Tidy Up
    Given the override date is reset

  