Feature: Bug 36134

@AcceptanceTest @InProgress
@CFS
Scenario: A227a Bulk create a draft NLG2122 contract with deliverables 101 and 102
    Given there are no allocations marked as Under Termination for UKPRN '10017227' 
    And   there are no terminated or closed allocations for UKPRN '10017227' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017227' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017227' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017227' 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017227'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017227' 
    And   there is no caseload advisor for UKPRN '10017227' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017227 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017227' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017227 Co Ltd' with UKPRN '10017227' and OrgId 'ORG0017227' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status        | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017227 | 117227 | 10017227 Co Ltd | 0              | Active        | Yes           | AA017227      | ?             | 29 Church Street       | Basingstoke            | ?                      | ?                      | ?                      | ?                      | RG21 7QQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017227 |




   
    # Change the date
    Given the override date is '01/03/2021'

    # Bulk file
    And   there are no files prefixed '10017227' in the Sharepoint 'NLG-2122-Input-Appendices' folder
    And   there are no files prefixed 'NLG AY 2122 10022022150041 v3_A227' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLG AY 2122 10022022150041 v3_A227' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLG AY 2122 10022022150041 v3_A227' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLG AY 2122 10022022150041 v3_A227' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLG AY 2122 10022022150041 v3_A227.xlsx' exists in the Datafiles folder and UKPRN '10017227' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

@AcceptanceTest @InProgress
@CFS
Scenario: A227b Update BulkUploadStatus to InProgress (Manual step)
    
    # Manual tasks
    #  1. Set status on [FundingAllocation].[BulkUploadStatus] to 'InProgress'

@AcceptanceTest @InProgress
@CFS
Scenario: A227c Import NLG2122 FA with deliverable 116. Fail: Bulk file is in progress
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017227'
    And   there is no Funding Allocation data in CRM for UKPRN '10017227'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
 #  And   there is no data in the FundingAllocation.BulkUploadStatus table

    
    
    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017227 | NLG-AS-2122-Contract-Provider-10017227-3_0            | 3_0            | NLG                         | AS-2122            | 21437.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017227-3_0   | 3_0                    | NLG-AS-2122-Contract-Provider-10017227-3_0            | 10017227      | Furth        | 02IPP           | 21437.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017227-3_0   | NLG-001         | 21437.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017227-3_0   | NLG-001         | FY-2122              | September              | 2021              | 3681.00                   |
    | NLG-AS-2122-10017227-3_0   | NLG-001         | FY-2122              | December               | 2021              | 4375.00                   |
    | NLG-AS-2122-10017227-3_0   | NLG-001         | FY-2122              | February               | 2022              | 4418.00                   |
    | NLG-AS-2122-10017227-3_0   | NLG-001         | FY-2122              | April                  | 2022              | 4289.00                   |
    | NLG-AS-2122-10017227-3_0   | NLG-001         | FY-2122              | July                   | 2022              | 4674.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      | NLG                       |

    # Write the following values to the output window
    And   message 'ReleaseGroup NLG = [NLG]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017227 | 10017227 Co Ltd  | NLG-AS-2122-Contract-Provider-10017227-3_0              | 3_0            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 21437.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017227-3_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 21437.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017227 | NLG-AS-2122-Contract-Provider-10017227-3_0              | 3_0            | AS-2122 | NLG                         | 21437.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [NLG]             |

    # Write the following values to the output window
    And   message 'ReleaseGroup NLG = [NLG]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 21437.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017227' for FundingType 'NLG' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017227' for FundingType 'NLG' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017227 | 10017227 Co Ltd  | NLG-AS-2122-Contract-Provider-10017227-3_0              | 3_0            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Released          | Released          | 21437.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NLG-AS-2122-Contract-Provider-10017227-3_0              | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NLG-AS-2122-Contract-Provider-10017227-3_0              | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017227 | NLG-AS-2122-Contract-Provider-10017227-3_0              | 3_0            | AS-2122 | NLG                         | 21437.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017227-3_0              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017227 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017227 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017227 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 21437.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017227 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017227 | [MasterContractNo] | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017227 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017227 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 21437.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | NLG           | NLG2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 21437.00  | 0.00     | 3681.00  | 0.00     | 0.00     | 4375.00  | 0.00     | 4418.00  | 0.00     | 4289.00  | 0.00     | 0.00     | 4674.00  | Isles of Scilly: Boarding and Accommodation Grant           |                          |

    # Contract status is now at 'Awaiting Documentation'

