Feature: FSR-012 34339

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A203 Bulk files to create new, update draft and amend EDSK2122 contract while RG in progress for same Funding Type Period. Fail: FSR-012
    
    # 1. EDSK RG at 'ReleaseInProgress'  2122   Bulk New fails FSR-012
    # 2. EDSK RG at 'ReleaseInProgress'  2021   Bulk New success
    # 3. EDSK RG at 'ReleaseInProgress'  2122   Bulk Update Draft fails FSR-012
    # 4. EDSK RG at 'Released'           2122   Bulk Update Draft success
    # 5. EDSK RG at 'ReleaseInProgress'  2122   Bulk Amendment fails FSR-012 
    # 6. EDSK RG at 'ReleaseInProgress'  2021   Bulk Amendment success 
    # 7. EDSK RG at 'ReleaseInProgress'  2122   Bulk New for 2021 success
    
    Given there are no allocations marked as Under Termination for UKPRN '10017203' 
    And   there are no terminated or closed allocations for UKPRN '10017203' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017203' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017203' 
 
    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017203' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-NSF2122      |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017203'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017203' 
    And   there is no caseload advisor for UKPRN '10017203' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017203 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017203' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017203 Co Ltd' with UKPRN '10017203' and OrgId 'ORG0017203' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017203 | 117203 | 10017203 Co Ltd | 0              | Active                | Yes           | AA017203      | ?             | 16 Emmanuel Court      | Mill Street            | ?                      | ?                      | Sutton Coldfield       | West Midlands          | B72 1TJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017203 |





    # Step 1. Bulk NEW while RG is at 'ReleaseInProgress'. Fail: FSR-012
    
    # Change the date
    Given the override date is '01/07/2021'

    # Truncate ContractRequest.FundingAllocationRelease then insert the following data. (To check if Release Groups are in-flight) (J147)
    Given the following data exists in the ContractRequest.FundingAllocationRelease table
    | FundingTypeCode | FundingPeriodName | ReleaseStatus       |
    | EDSK            | AY2122            | ReleaseInProgress   |

    # Bulk file with 'New' intent
    And   there are no files prefixed '10017203' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174526 v3_A203a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174526 v3_A203a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174526 v3_A203a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174526 v3_A203a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 25082021174526 v3_A203a.xlsx' exists in the Datafiles folder and UKPRN '10017203' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values

    Then  a syntax report showing file failure should exist in the Sharepoint Reports folder
    
    # FSR-012
    And   the syntax report includes the phrase 'Release of funding allocations from Contract Control is in progress for the same Funding Type Period'





    # Step 2. Bulk NEW while RG is at 'ReleaseInProgress' but for 2021. Success
    
    # Change the date
    Given the override date is '02/07/2021'

    # Truncate ContractRequest.FundingAllocationRelease then insert the following data. (To check if Release Groups are in-flight) (J147)
    Given the following data exists in the ContractRequest.FundingAllocationRelease table
    | FundingTypeCode | FundingPeriodName | ReleaseStatus       |
    | EDSK            | AY2021            | ReleaseInProgress   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 

    # Bulk file with 'New' Intent - again
    And   there are no files prefixed '10017203' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174526 v3_A203a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174526 v3_A203a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174526 v3_A203a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174526 v3_A203a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 25082021174526 v3_A203a.xlsx' exists in the Datafiles folder and UKPRN '10017203' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report    

    # Contract ia at Awaiting Documentation

    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017203' for FundingType 'EDSK' and period '2122'





    # Step 3. Bulk UPDATE DRAFT while RG is at 'ReleaseInProgress'. Fail: FSR-012
    
    # Change the date
    Given the override date is '03/07/2021'

    # Truncate ContractRequest.FundingAllocationRelease then insert the following data. (To check if Release Groups are in-flight) (J147)
    Given the following data exists in the ContractRequest.FundingAllocationRelease table
    | FundingTypeCode | FundingPeriodName | ReleaseStatus       |
    | EDSK            | AY2122            | ReleaseInProgress   |

    # Bulk file with 'Update Draft' intent
    And   there are no files prefixed '10017203' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174527 v3_A203b' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174527 v3_A203b' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174527 v3_A203b' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174527 v3_A203b' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 25082021174527 v3_A203b.xlsx' exists in the Datafiles folder and UKPRN '10017203' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file failure should exist in the Sharepoint Reports folder
    
    # FSR-012
    And   the syntax report includes the phrase 'Release of funding allocations from Contract Control is in progress for the same Funding Type Period'





    # Step 4. Bulk UPDATE DRAFT while RG is at 'Released'. Success
    
    # Change the date
    Given the override date is '04/07/2021'

    # Truncate ContractRequest.FundingAllocationRelease then insert the following data. (To check if Release Groups are in-flight) (J147)
    Given the following data exists in the ContractRequest.FundingAllocationRelease table
    | FundingTypeCode | FundingPeriodName | ReleaseStatus       |
    | EDSK            | AY2122            | Released            |

    # Bulk file with 'Update Draft' intent - again
    And   there are no files prefixed '10017203' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174527 v3_A203b' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174527 v3_A203b' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174527 v3_A203b' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174527 v3_A203b' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 25082021174527 v3_A203b.xlsx' exists in the Datafiles folder and UKPRN '10017203' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report    

    # Contract is at Awaiting Documentation

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
    | 10017203 | [ContractNo]       | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017203 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Step 5. Bulk AMEND while RG is at 'ReleaseInProgress'. Fail: FSR-012
    
    # Change the date
    Given the override date is '05/07/2021'

    # Truncate ContractRequest.FundingAllocationRelease then insert the following data. (To check if Release Groups are in-flight) (J147)
    Given the following data exists in the ContractRequest.FundingAllocationRelease table
    | FundingTypeCode | FundingPeriodName | ReleaseStatus       |
    | EDSK            | AY2122            | ReleaseInProgress   |

    # Bulk file with 'Amendment' intent
    And   there are no files prefixed '10017203' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174528 v3_A203c' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174528 v3_A203c' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174528 v3_A203c' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174528 v3_A203c' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 25082021174528 v3_A203c.xlsx' exists in the Datafiles folder and UKPRN '10017203' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file failure should exist in the Sharepoint Reports folder
    
    # FSR-012
    And   the syntax report includes the phrase 'Release of funding allocations from Contract Control is in progress for the same Funding Type Period'





    # Step 6. Bulk AMEND while RG is at 'ReleaseInProgress', but for 2021. Success
    
    # Change the date
    Given the override date is '06/07/2021'

    # Truncate ContractRequest.FundingAllocationRelease then insert the following data. (To check if Release Groups are in-flight) (J147)
    Given the following data exists in the ContractRequest.FundingAllocationRelease table
    | FundingTypeCode | FundingPeriodName | ReleaseStatus       |
    | EDSK            | AY2021            | ReleaseInProgress   |
    
    # Bulk file with 'Amendment' intent - again
    And   there are no files prefixed '10017203' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174528 v3_A203c' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174528 v3_A203c' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174528 v3_A203c' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 25082021174528 v3_A203c' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 25082021174528 v3_A203c.xlsx' exists in the Datafiles folder and UKPRN '10017203' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report    

    # Contract at Awaiting Documentation





    # Step 7. Bulk NEW for 2021 while 2122 RG is at 'ReleaseInProgress'. Success
    
    # Change the date
    Given the override date is '06/07/2021'

    # Truncate ContractRequest.FundingAllocationRelease then insert the following data. (To check if Release Groups are in-flight) (J147)
    Given the following data exists in the ContractRequest.FundingAllocationRelease table
    | FundingTypeCode | FundingPeriodName | ReleaseStatus       |
    | EDSK            | AY2122            | ReleaseInProgress   |
    
    # Bulk file with 'New' intent
    And   there are no files prefixed '10017203' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 09092021124139 v3_A203d' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 09092021124139 v3_A203d' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 09092021124139 v3_A203d' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 09092021124139 v3_A203d' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 09092021124139 v3_A203d.xlsx' exists in the Datafiles folder and UKPRN '10017203' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report    

    # Contract at Awaiting Documentation


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 
      
@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A204 Import a 1619 FA and add to RG. Mark EDSK bulk file as InProgress. Release RG. Fail: Slack msg

    # Step 1. Bulk file 'InProgress' for 2122. RG release should fail
    # Step 2. Bulk file 'Loaded' for 2122. RG release should succeed

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017204'
    And   there is no Funding Allocation data in CRM for UKPRN '10017204'
    And   there is no Contract, Task or Workflow data for UKPRN '10017204'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017204'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017204'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017204' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017204' 
    And   there is no caseload advisor for UKPRN '10017204' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017204 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017204' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017204 Co Ltd' with UKPRN '10017204' and OrgId 'ORG0017204' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017204 | 117204 | 10017204 Co Ltd | 0              | Active                | Yes           | AA017204      | ?             | 71 Beckenham Lane      | Shortlands             | ?                      | ?                      | Bromley                | Kent                   | BR2 0JB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017204 |





    # Populate the stub with 1619 (01GFE) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017204 | 1619-AS-2122-Contract-Provider-10017204-2_5           | 2_5            | 1619                        | AS-2122            | 36690.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017204-2_5  | 2_5                    | 1619-AS-2122-Contract-Provider-10017204-2_5           | 10017204      | Furth        | 01GFE           | 36690.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017204-2_5  | 1619-002        | 14264.00         | Payment         |
    | 1619-AS-2122-10017204-2_5  | 1619-005        | 22426.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017204-2_5  | 1619-002        | FY-2122              | October                | 2021              | 3160.00                   |
    | 1619-AS-2122-10017204-2_5  | 1619-002        | FY-2122              | November               | 2021              | 5254.00                   |
    | 1619-AS-2122-10017204-2_5  | 1619-002        | FY-2122              | March                  | 2022              | 2973.00                   |
    | 1619-AS-2122-10017204-2_5  | 1619-002        | FY-2122              | July                   | 2022              | 2877.00                   |
    #
    | 1619-AS-2122-10017204-2_5  | 1619-005        | FY-2122              | August                 | 2021              | 2759.00                   |
    | 1619-AS-2122-10017204-2_5  | 1619-005        | FY-2122              | November               | 2021              | 4410.00                   |
    | 1619-AS-2122-10017204-2_5  | 1619-005        | FY-2122              | January                | 2022              | 3459.00                   |
    | 1619-AS-2122-10017204-2_5  | 1619-005        | FY-2122              | February               | 2022              | 4186.00                   |
    | 1619-AS-2122-10017204-2_5  | 1619-005        | FY-2122              | April                  | 2022              | 2006.00                   |
    | 1619-AS-2122-10017204-2_5  | 1619-005        | FY-2122              | June                   | 2022              | 5606.00                   |
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017204 | 10017204 Co Ltd  | 1619-AS-2122-Contract-Provider-10017204-2_5             | 2_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 36690.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017204-2_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 36690.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017204 | 1619-AS-2122-Contract-Provider-10017204-2_5             | 2_5            | AS-2122 | 1619                        | 36690.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Step 1. Bulk file 'InProgress' for 2122. RG release should fail

    # Change the date 
    Given the override date is '05/07/2021'

    # Truncate FundingAllocation.BulkUploadStatus then insert the following data. (To check if Bulk Imports are in-flight) (J149)
    Given the following data exists in the FundingAllocation.BulkUploadStatus table
    | FundingTypeCode | FundingPeriodName | Status     |
    | EDSK            | AY2122            | InProgress |

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The details are unchanged because a bulk file is in-flight)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | AwaitingRelease   | 1               | 36690.00        |

    # There should be a slack message too. Check manually





    # Step 2. Bulk file 'Loaded'. RG release should succeed

    # Change the date 
    Given the override date is '07/07/2021'

    # Truncate FundingAllocation.BulkUploadStatus then insert the following data. (To check if Bulk Imports are in-flight) (J149)
    Given the following data exists in the FundingAllocation.BulkUploadStatus table
    | FundingTypeCode | FundingPeriodName | Status     |
    | EDSK            | AY2122            | Loaded     |

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The details are unchanged because a bulk file is in-flight)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 36690.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017204' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017204' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017204 | 10017204 Co Ltd  | 1619-AS-2122-Contract-Provider-10017204-2_5             | 2_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 36690.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017204-2_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017204-2_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017204 | 1619-AS-2122-Contract-Provider-10017204-2_5             | 2_5            | AS-2122 | 1619                        | 36690.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017204-2_5             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017204 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017204 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017204 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 36690.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017204 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017204 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017204 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017204 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 36690.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 14264.00  | 0.00     | 0.00     | 3160.00  | 5254.00  | 0.00     | 0.00     | 0.00     | 2973.00  | 0.00     | 0.00     | 0.00     | 2877.00  | 16-19 Bursary Funds                                         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 22426.00  | 2759.00  | 0.00     | 0.00     | 4410.00  | 0.00     | 3459.00  | 4186.00  | 0.00     | 2006.00  | 0.00     | 5606.00  | 0.00     | 16-19 Free Meals                                            |                          |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Withdrawn20260521
@CFS
Scenario: A284 Setup data for 1619ED2122 with 15 allocation lines and create RG

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10040803'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10040812'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10040815'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10040847'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10040883'
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017584'

    And   there is no Funding Allocation data in CRM for UKPRN '10040803'
    And   there is no Funding Allocation data in CRM for UKPRN '10040812'
    And   there is no Funding Allocation data in CRM for UKPRN '10040815'
    And   there is no Funding Allocation data in CRM for UKPRN '10040847'
    And   there is no Funding Allocation data in CRM for UKPRN '10040883'
    And   there is no Funding Allocation data in CRM for UKPRN '10017284'

    And   there is no Contract, Task or Workflow data for UKPRN '10040803'
    And   there is no Contract, Task or Workflow data for UKPRN '10040812'
    And   there is no Contract, Task or Workflow data for UKPRN '10040815'
    And   there is no Contract, Task or Workflow data for UKPRN '10040847'
    And   there is no Contract, Task or Workflow data for UKPRN '10040883'
    And   there is no Contract, Task or Workflow data for UKPRN '10017284'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '100408' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed '10017284' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (HEI)     |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10040803' 
    And   there is no Organisation data in CRM for UKPRN '10040812' 
    And   there is no Organisation data in CRM for UKPRN '10040815' 
    And   there is no Organisation data in CRM for UKPRN '10040847' 
    And   there is no Organisation data in CRM for UKPRN '10040883' 
    And   there is no Organisation data in CRM for UKPRN '10017284' 

    And   there is no caseload advisor for UKPRN '10040803' 
    And   there is no caseload advisor for UKPRN '10040812' 
    And   there is no caseload advisor for UKPRN '10040815' 
    And   there is no caseload advisor for UKPRN '10040847' 
    And   there is no caseload advisor for UKPRN '10040883' 
    And   there is no caseload advisor for UKPRN '10017284' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10040803 | 
    | 10040812 | 
    | 10040815 | 
    | 10040847 | 
    | 10040883 | 
    | 10172843 | 
 

    And   caseload advisor 'FCS2 Test' is assigned to provider '10040803 Co Ltd' with UKPRN '10040803' and OrgId 'ORG0040803' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10040812 Co Ltd' with UKPRN '10040812' and OrgId 'ORG0040812' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10040815 Co Ltd' with UKPRN '10040815' and OrgId 'ORG0040815' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10040847 Co Ltd' with UKPRN '10040847' and OrgId 'ORG0040847' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10040883 Co Ltd' with UKPRN '10040883' and OrgId 'ORG0040883' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017284 Co Ltd' with UKPRN '10017284' and OrgId 'ORG0017284' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10040803 | 140803 | 10040803 Co Ltd | 0              | Active                | Yes           | AA040803      | ?             | 5 Merchants Place      | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 1DP   |
    | 10040812 | 140812 | 10040812 Co Ltd | 0              | Active                | Yes           | AA040812      | ?             | 6 Merchants Place      | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 1DP   |
    | 10040815 | 140815 | 10040815 Co Ltd | 0              | Active                | Yes           | AA040815      | ?             | 7 Merchants Place      | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 1DP   |
    | 10040847 | 140847 | 10040847 Co Ltd | 0              | Active                | Yes           | AA040847      | ?             | 8 Merchants Place      | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 1DP   |
    | 10040883 | 140883 | 10040883 Co Ltd | 0              | Active                | Yes           | AA040883      | ?             | 9 Merchants Place      | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 1DP   |
    | 10017284 | 117284 | 10017284 Co Ltd | 0              | Active                | Yes           | AA017284      | ?             | 50 Lucks Hill          | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 2JW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10040803 |
    | 10040812 |
    | 10040815 |
    | 10040847 |
    | 10040883 |
    | 10017284 |


    # Populate the stub with 1619 (01GFE) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10040803 | 1619-AS-2122-Contract-Provider-10040803-2_3           | 2_3            | 1619                        | AS-2122            | 155905.00         |
    | Contracting    | 10040812 | 1619-AS-2122-Contract-Provider-10040812-1_3           | 1_3            | 1619                        | AS-2122            | 185488.00         |
    | Contracting    | 10040815 | 1619-AS-2122-Contract-Provider-10040815-1_6           | 1_6            | 1619                        | AS-2122            | 208707.00         |
    | Contracting    | 10040847 | 1619-AS-2122-Contract-Provider-10040847-3_4           | 3_4            | 1619                        | AS-2122            | 191799.00         |
    | Contracting    | 10040883 | 1619-AS-2122-Contract-Provider-10040883-4_4           | 4_4            | 1619                        | AS-2122            | 220823.00         |
    | Contracting    | 10017284 | 1619-AS-2122-Contract-Provider-10017284-4_0           | 4_0            | 1619                        | AS-2122            | 200.00            |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10040803-2_3  | 2_3                    | 1619-AS-2122-Contract-Provider-10040803-2_3           | 10040803      | Furth        | 01GFE           | 155905.00                 |
    | 1619-AS-2122-10040812-1_3  | 1_3                    | 1619-AS-2122-Contract-Provider-10040812-1_3           | 10040812      | Furth        | 01GFE           | 185488.00                 |
    | 1619-AS-2122-10040815-1_6  | 1_6                    | 1619-AS-2122-Contract-Provider-10040815-1_6           | 10040815      | Furth        | 01GFE           | 208707.00                 |
    | 1619-AS-2122-10040847-3_4  | 3_4                    | 1619-AS-2122-Contract-Provider-10040847-3_4           | 10040847      | Furth        | 01GFE           | 191799.00                 |
    | 1619-AS-2122-10040883-4_4  | 4_4                    | 1619-AS-2122-Contract-Provider-10040883-4_4           | 10040883      | Furth        | 01GFE           | 220823.00                 |
    | 1619-AS-2122-10017284-4_0  | 4_0                    | 1619-AS-2122-Contract-Provider-10017284-4_0           | 10017284      | Furth        | 07HEP           | 200.00                    |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10040803-2_3  | 1619-001        | 19802.00         | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-002        | 11479.00         | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-003        | 15752.00         | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-004        | 23501.00         | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-005        | 8829.00          | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-006        | 10026.00         | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-007        | 16369.00         | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-008        | 8115.00          | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-009        | 6475.00          | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-010        | 3202.00          | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-011        | 5785.00          | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-013        | 5945.00          | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-020        | 15751.00         | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-024        | 2835.00          | Payment         |
    | 1619-AS-2122-10040803-2_3  | 1619-025        | 2039.00          | Payment         |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-001        | 17304.00         | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-002        | 13942.00         | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-004        | 21946.00         | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-005        | 6655.00          | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-006        | 26848.00         | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-007        | 11925.00         | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-008        | 5856.00          | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-009        | 19892.00         | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-010        | 8497.00          | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-011        | 2052.00          | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-013        | 19288.00         | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-020        | 14055.00         | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-021        | 7988.00          | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-024        | 6115.00          | Payment         |
    | 1619-AS-2122-10040812-1_3  | 1619-025        | 3125.00          | Payment         |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-001        | 16377.00         | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-002        | 22070.00         | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-003        | 4608.00          | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-004        | 25544.00         | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-005        | 10759.00         | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-006        | 19073.00         | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-007        | 8452.00          | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-008        | 24470.00         | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-009        | 4736.00          | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-010        | 19658.00         | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-011        | 2729.00          | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-013        | 7530.00          | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-021        | 13520.00         | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-024        | 6834.00          | Payment         |
    | 1619-AS-2122-10040815-1_6  | 1619-025        | 22347.00         | Payment         |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-001        | 12749.00         | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-002        | 7664.00          | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-003        | 18325.00         | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-005        | 6064.00          | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-006        | 16756.00         | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-007        | 4502.00          | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-008        | 23732.00         | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-009        | 7935.00          | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-010        | 15078.00         | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-011        | 13793.00         | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-013        | 5132.00          | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-020        | 9193.00          | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-021        | 17185.00         | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-024        | 23528.00         | Payment         |
    | 1619-AS-2122-10040847-3_4  | 1619-025        | 10163.00         | Payment         |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-002        | 24696.00         | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-003        | 22678.00         | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-004        | 18258.00         | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-005        | 23955.00         | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-006        | 7031.00          | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-007        | 13584.00         | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-008        | 3846.00          | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-009        | 18179.00         | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-010        | 10421.00         | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-011        | 16374.00         | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-013        | 6219.00          | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-020        | 26884.00         | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-021        | 3444.00          | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-024        | 6908.00          | Payment         |
    | 1619-AS-2122-10040883-4_4  | 1619-025        | 18346.00         | Payment         |
    #
    | 1619-AS-2122-10017284-4_0  | 1619-001        | 200.00           | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10040803-2_3  | 1619-001        | FY-2122              | September              | 2021              | 2424.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-001        | FY-2122              | December               | 2021              | 5341.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-001        | FY-2122              | March                  | 2022              | 5656.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-001        | FY-2122              | April                  | 2022              | 3647.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-001        | FY-2122              | June                   | 2022              | 2734.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-002        | FY-2122              | September              | 2021              | 2085.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-002        | FY-2122              | December               | 2021              | 4863.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-002        | FY-2122              | April                  | 2022              | 4531.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-003        | FY-2122              | September              | 2021              | 3874.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-003        | FY-2122              | January                | 2022              | 3917.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-003        | FY-2122              | February               | 2022              | 3788.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-003        | FY-2122              | May                    | 2022              | 4173.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-004        | FY-2122              | August                 | 2021              | 2500.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-004        | FY-2122              | October                | 2021              | 5518.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-004        | FY-2122              | January                | 2022              | 4465.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-004        | FY-2122              | March                  | 2022              | 2558.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-004        | FY-2122              | April                  | 2022              | 4278.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-004        | FY-2122              | June                   | 2022              | 4182.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-005        | FY-2122              | January                | 2022              | 4273.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-005        | FY-2122              | February               | 2022              | 4556.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-006        | FY-2122              | September              | 2021              | 4188.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-006        | FY-2122              | June                   | 2022              | 5838.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-007        | FY-2122              | October                | 2021              | 3712.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-007        | FY-2122              | January                | 2022              | 5122.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-007        | FY-2122              | April                  | 2022              | 4892.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-007        | FY-2122              | May                    | 2022              | 2643.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-008        | FY-2122              | September              | 2021              | 2057.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-008        | FY-2122              | February               | 2022              | 2238.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-008        | FY-2122              | June                   | 2022              | 3820.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-009        | FY-2122              | August                 | 2021              | 2190.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-009        | FY-2122              | May                    | 2022              | 4285.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-010        | FY-2122              | July                   | 2022              | 3202.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-011        | FY-2122              | November               | 2021              | 3726.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-011        | FY-2122              | February               | 2022              | 2059.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-013        | FY-2122              | November               | 2021              | 3293.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-013        | FY-2122              | April                  | 2022              | 2652.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-020        | FY-2122              | September              | 2021              | 2924.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-020        | FY-2122              | November               | 2021              | 4131.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-020        | FY-2122              | February               | 2022              | 5574.00                   |
    | 1619-AS-2122-10040803-2_3  | 1619-020        | FY-2122              | May                    | 2022              | 3122.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-024        | FY-2122              | December               | 2021              | 2835.00                   |
    #
    | 1619-AS-2122-10040803-2_3  | 1619-025        | FY-2122              | December               | 2021              | 2039.00                   |
    #
    #
    #
    | 1619-AS-2122-10040812-1_3  | 1619-001        | FY-2122              | August                 | 2021              | 4553.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-001        | FY-2122              | December               | 2021              | 3912.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-001        | FY-2122              | March                  | 2022              | 5835.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-001        | FY-2122              | July                   | 2022              | 3004.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-002        | FY-2122              | September              | 2021              | 5506.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-002        | FY-2122              | March                  | 2022              | 3016.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-002        | FY-2122              | June                   | 2022              | 5420.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-004        | FY-2122              | August                 | 2021              | 5603.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-004        | FY-2122              | January                | 2022              | 2911.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-004        | FY-2122              | March                  | 2022              | 4048.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-004        | FY-2122              | May                    | 2022              | 4636.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-004        | FY-2122              | June                   | 2022              | 4748.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-005        | FY-2122              | December               | 2021              | 2622.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-005        | FY-2122              | May                    | 2022              | 4033.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-006        | FY-2122              | September              | 2021              | 3393.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-006        | FY-2122              | October                | 2021              | 4018.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-006        | FY-2122              | January                | 2022              | 3206.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-006        | FY-2122              | March                  | 2022              | 5642.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-006        | FY-2122              | April                  | 2022              | 5273.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-006        | FY-2122              | July                   | 2022              | 5316.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-007        | FY-2122              | September              | 2021              | 2215.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-007        | FY-2122              | November               | 2021              | 3080.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-007        | FY-2122              | February               | 2022              | 2610.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-007        | FY-2122              | July                   | 2022              | 4020.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-008        | FY-2122              | December               | 2021              | 2736.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-008        | FY-2122              | February               | 2022              | 3120.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-009        | FY-2122              | October                | 2021              | 4636.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-009        | FY-2122              | January                | 2022              | 5705.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-009        | FY-2122              | February               | 2022              | 5438.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-009        | FY-2122              | July                   | 2022              | 4113.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-010        | FY-2122              | January                | 2022              | 5493.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-010        | FY-2122              | February               | 2022              | 3004.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-011        | FY-2122              | April                  | 2022              | 2052.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-013        | FY-2122              | August                 | 2021              | 3258.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-013        | FY-2122              | November               | 2021              | 3098.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-013        | FY-2122              | March                  | 2022              | 5705.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-013        | FY-2122              | May                    | 2022              | 4823.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-013        | FY-2122              | July                   | 2022              | 2404.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-020        | FY-2122              | September              | 2021              | 2766.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-020        | FY-2122              | November               | 2021              | 2910.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-020        | FY-2122              | February               | 2022              | 5416.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-020        | FY-2122              | May                    | 2022              | 2963.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-021        | FY-2122              | October                | 2021              | 4384.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-021        | FY-2122              | February               | 2022              | 3604.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-024        | FY-2122              | December               | 2021              | 3207.00                   |
    | 1619-AS-2122-10040812-1_3  | 1619-024        | FY-2122              | April                  | 2022              | 2908.00                   |
    #
    | 1619-AS-2122-10040812-1_3  | 1619-025        | FY-2122              | November               | 2021              | 3125.00                   |
    #
    #
    #
    | 1619-AS-2122-10040815-1_6  | 1619-001        | FY-2122              | September              | 2021              | 5199.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-001        | FY-2122              | February               | 2022              | 5482.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-001        | FY-2122              | April                  | 2022              | 5696.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-002        | FY-2122              | August                 | 2021              | 4787.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-002        | FY-2122              | January                | 2022              | 2196.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-002        | FY-2122              | February               | 2022              | 5967.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-002        | FY-2122              | April                  | 2022              | 3719.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-002        | FY-2122              | June                   | 2022              | 5401.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-003        | FY-2122              | August                 | 2021              | 4608.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-004        | FY-2122              | August                 | 2021              | 5056.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-004        | FY-2122              | November               | 2021              | 3491.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-004        | FY-2122              | January                | 2022              | 4185.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-004        | FY-2122              | March                  | 2022              | 4228.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-004        | FY-2122              | May                    | 2022              | 4100.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-004        | FY-2122              | July                   | 2022              | 4484.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-005        | FY-2122              | August                 | 2021              | 3647.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-005        | FY-2122              | March                  | 2022              | 2765.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-005        | FY-2122              | July                   | 2022              | 4347.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-006        | FY-2122              | September              | 2021              | 3914.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-006        | FY-2122              | December               | 2021              | 2007.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-006        | FY-2122              | March                  | 2022              | 3727.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-006        | FY-2122              | May                    | 2022              | 3631.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-006        | FY-2122              | July                   | 2022              | 5794.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-007        | FY-2122              | November               | 2021              | 5863.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-007        | FY-2122              | March                  | 2022              | 2589.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-008        | FY-2122              | August                 | 2021              | 2798.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-008        | FY-2122              | November               | 2021              | 3044.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-008        | FY-2122              | December               | 2021              | 4182.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-008        | FY-2122              | February               | 2022              | 5832.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-008        | FY-2122              | April                  | 2022              | 5944.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-008        | FY-2122              | June                   | 2022              | 2670.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-009        | FY-2122              | May                    | 2022              | 4736.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-010        | FY-2122              | August                 | 2021              | 4968.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-010        | FY-2122              | November               | 2021              | 3985.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-010        | FY-2122              | March                  | 2022              | 2933.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-010        | FY-2122              | May                    | 2022              | 5027.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-010        | FY-2122              | June                   | 2022              | 2745.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-011        | FY-2122              | May                    | 2022              | 2729.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-013        | FY-2122              | December               | 2021              | 2034.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-013        | FY-2122              | February               | 2022              | 5496.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-021        | FY-2122              | September              | 2021              | 3411.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-021        | FY-2122              | December               | 2021              | 3213.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-021        | FY-2122              | April                  | 2022              | 2743.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-021        | FY-2122              | July                   | 2022              | 4153.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-024        | FY-2122              | November               | 2021              | 2199.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-024        | FY-2122              | February               | 2022              | 4635.00                   |
    #
    | 1619-AS-2122-10040815-1_6  | 1619-025        | FY-2122              | October                | 2021              | 4295.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-025        | FY-2122              | January                | 2022              | 3072.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-025        | FY-2122              | February               | 2022              | 5679.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-025        | FY-2122              | April                  | 2022              | 5860.00                   |
    | 1619-AS-2122-10040815-1_6  | 1619-025        | FY-2122              | July                   | 2022              | 3441.00                   |
    #
    #
    #
    | 1619-AS-2122-10040847-3_4  | 1619-001        | FY-2122              | November               | 2021              | 4218.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-001        | FY-2122              | February               | 2022              | 5184.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-001        | FY-2122              | July                   | 2022              | 3347.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-002        | FY-2122              | October                | 2021              | 2956.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-002        | FY-2122              | February               | 2022              | 4708.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-003        | FY-2122              | September              | 2021              | 3861.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-003        | FY-2122              | November               | 2021              | 2979.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-003        | FY-2122              | March                  | 2022              | 4560.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-003        | FY-2122              | May                    | 2022              | 3818.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-003        | FY-2122              | July                   | 2022              | 3107.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-005        | FY-2122              | August                 | 2021              | 4055.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-005        | FY-2122              | March                  | 2022              | 2009.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-006        | FY-2122              | August                 | 2021              | 5936.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-006        | FY-2122              | November               | 2021              | 2458.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-006        | FY-2122              | April                  | 2022              | 3014.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-006        | FY-2122              | July                   | 2022              | 5348.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-007        | FY-2122              | October                | 2021              | 4502.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-008        | FY-2122              | September              | 2021              | 3773.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-008        | FY-2122              | November               | 2021              | 4980.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-008        | FY-2122              | January                | 2022              | 3484.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-008        | FY-2122              | February               | 2022              | 3971.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-008        | FY-2122              | April                  | 2022              | 5450.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-008        | FY-2122              | June                   | 2022              | 2074.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-009        | FY-2122              | December               | 2021              | 5212.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-009        | FY-2122              | March                  | 2022              | 2723.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-010        | FY-2122              | September              | 2021              | 5073.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-010        | FY-2122              | December               | 2021              | 2381.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-010        | FY-2122              | April                  | 2022              | 3518.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-010        | FY-2122              | June                   | 2022              | 4106.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-011        | FY-2122              | August                 | 2021              | 2682.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-011        | FY-2122              | December               | 2021              | 3547.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-011        | FY-2122              | February               | 2022              | 3077.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-011        | FY-2122              | July                   | 2022              | 4487.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-013        | FY-2122              | April                  | 2022              | 5132.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-020        | FY-2122              | September              | 2021              | 4834.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-020        | FY-2122              | January                | 2022              | 2142.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-020        | FY-2122              | May                    | 2022              | 2217.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-021        | FY-2122              | October                | 2021              | 2812.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-021        | FY-2122              | November               | 2021              | 3982.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-021        | FY-2122              | February               | 2022              | 3410.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-021        | FY-2122              | April                  | 2022              | 2187.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-021        | FY-2122              | June                   | 2022              | 4794.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-024        | FY-2122              | August                 | 2021              | 4083.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-024        | FY-2122              | October                | 2021              | 4569.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-024        | FY-2122              | January                | 2022              | 2047.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-024        | FY-2122              | March                  | 2022              | 2672.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-024        | FY-2122              | April                  | 2022              | 5861.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-024        | FY-2122              | June                   | 2022              | 4296.00                   |
    #
    | 1619-AS-2122-10040847-3_4  | 1619-025        | FY-2122              | August                 | 2021              | 5111.00                   |
    | 1619-AS-2122-10040847-3_4  | 1619-025        | FY-2122              | July                   | 2022              | 5052.00                   |
    #
    #
    #
    | 1619-AS-2122-10040883-4_4  | 1619-002        | FY-2122              | August                 | 2021              | 2515.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-002        | FY-2122              | October                | 2021              | 5090.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-002        | FY-2122              | January                | 2022              | 2430.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-002        | FY-2122              | March                  | 2022              | 5346.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-002        | FY-2122              | May                    | 2022              | 5662.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-002        | FY-2122              | June                   | 2022              | 3653.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-003        | FY-2122              | September              | 2021              | 2842.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-003        | FY-2122              | November               | 2021              | 5417.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-003        | FY-2122              | February               | 2022              | 2757.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-003        | FY-2122              | April                  | 2022              | 5673.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-003        | FY-2122              | June                   | 2022              | 5989.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-004        | FY-2122              | September              | 2021              | 4526.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-004        | FY-2122              | November               | 2021              | 3885.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-004        | FY-2122              | February               | 2022              | 5808.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-004        | FY-2122              | May                    | 2022              | 4039.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-005        | FY-2122              | September              | 2021              | 4582.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-005        | FY-2122              | October                | 2021              | 4042.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-005        | FY-2122              | December               | 2021              | 4598.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-005        | FY-2122              | February               | 2022              | 2931.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-005        | FY-2122              | May                    | 2022              | 3930.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-005        | FY-2122              | July                   | 2022              | 3872.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-006        | FY-2122              | November               | 2021              | 3665.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-006        | FY-2122              | May                    | 2022              | 3366.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-007        | FY-2122              | October                | 2021              | 4382.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-007        | FY-2122              | March                  | 2022              | 5007.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-007        | FY-2122              | July                   | 2022              | 4195.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-008        | FY-2122              | March                  | 2022              | 3846.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-009        | FY-2122              | September              | 2021              | 4721.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-009        | FY-2122              | January                | 2022              | 5447.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-009        | FY-2122              | February               | 2022              | 2205.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-009        | FY-2122              | May                    | 2022              | 5806.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-010        | FY-2122              | December               | 2021              | 5993.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-010        | FY-2122              | March                  | 2022              | 4428.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-011        | FY-2122              | September              | 2021              | 5150.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-011        | FY-2122              | November               | 2021              | 2799.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-011        | FY-2122              | April                  | 2022              | 5850.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-011        | FY-2122              | July                   | 2022              | 2575.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-013        | FY-2122              | December               | 2021              | 3430.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-013        | FY-2122              | June                   | 2022              | 2789.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-020        | FY-2122              | August                 | 2021              | 4549.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-020        | FY-2122              | October                | 2021              | 4731.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-020        | FY-2122              | January                | 2022              | 2311.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-020        | FY-2122              | February               | 2022              | 4507.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-020        | FY-2122              | April                  | 2022              | 4859.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-020        | FY-2122              | July                   | 2022              | 5927.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-021        | FY-2122              | December               | 2021              | 3444.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-024        | FY-2122              | January                | 2022              | 4509.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-024        | FY-2122              | April                  | 2022              | 2399.00                   |
    #
    | 1619-AS-2122-10040883-4_4  | 1619-025        | FY-2122              | September              | 2021              | 3718.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-025        | FY-2122              | November               | 2021              | 4787.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-025        | FY-2122              | February               | 2022              | 5583.00                   |
    | 1619-AS-2122-10040883-4_4  | 1619-025        | FY-2122              | July                   | 2022              | 4258.00                   |
    #
    #
    #
    | 1619-AS-2122-10017284-4_0  | 1619-001        | FY-2122              | September              | 2021              | 200.00                    |

  
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
    Given the Release Groups for the following Contracting Profiles have been saved
   #Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (HEI)     | CofG_HEI                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window
    And   message 'ReleaseGroup CofG_HEI = [CofG_HEI]' is written to the Output window

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 5               | 962722.00       |

    And   Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 200.00          |





#    # Release a Release Group (32953)
#
#    # Change the date 
#    Given the override date is '05/07/2021'
#
#    # Release Funding Allocations from Contract Control (J128)
#    When  a request is triggered to release the following Release Groups together
#   #When  a request is triggered to release the following Release Group
#    | ReleaseGroup      |
#    | [CofG_College]    |
#    | [CofG_HEI]        |
#
#    # Check the state of a Release Group (J129)  (The counts and values are unchanged)
#    Then  Release Group '[CofG_College]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 5               | 962722.00       |
#
#    Then  Release Group '[CofG_HEI]' has the following characteristics
#    | ReleaseStatus     | AllocationCount | AllocationValue |
#    | Released          | 1               | 226235.00       |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
#   And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
#   And   there is no data in the FundingAllocation.BulkUploadStatus table

       