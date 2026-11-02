Feature: CreateLOANS2627

@AcceptanceTest @Complete
@CFS
Scenario: AK047 Import and release a ALLBC2627, ALLF2627 allocation. Approve. Check docs, CRM and feed. 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10010047'
    And   there is no Funding Allocation data in CRM for UKPRN '10010047'
    And   there is no Contract, Task or Workflow data for UKPRN '10010047'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10010047'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010047'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10010047' in the Sharepoint 'EDSK-2627-Input-Appendices' folder

    # Clear down the CfS_ITP stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables
#
#    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
#    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
#    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
#    | EDSK            | AY2627        | LOANS2627    |Contract for Services (ITP)      	   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table




#    # Clear down all subnominal data from PaaS for an FSP
#    And   there is no Subnominal data in PaaS for the following FSPs
#    | FSP               |
#    | ALLBC2526          |
#    | ALLF2526          |
#
#	
#    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
#    And   there are no Sector-based Work Academies profile values in config for UKPRN '10010047'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010047' 
    And   there is no caseload advisor for UKPRN '10010047' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010047 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010047' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010047 Co Ltd' with UKPRN '10010047' and OrgId 'ORG0010047' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010047 | 110047 | 10010047 Co Ltd | 0              | Active                | Yes           | AA010047      | ?             | 19 Kneesworth Street    | ?                      | ?                      | ?                      | Fixby                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010047 |





    # Populate the stub with ALLB (06SDC) data

    # Change the date 
    Given the override date is '01/07/2026'

    # Clear down the CfS_ITP stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10010047 | LOANS-AY-2627-Contract-Provider-10010047-3_5          | 3_5            | LOANS                       | AY-2627            | 10000.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                   | ProviderSubType | ProviderFundingTotalValue |
    | LOANS-AY-2627-10010047-3_5 | 3_5                    | LOANS-AY-2627-Contract-Provider-10010047-3_5          | 10010047      | Furth                          | 05ADC             | 10000.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | LOANS-AY-2627-10010047-3_5   | LOANS-001         | 3680.00        | Payment         |
    | LOANS-AY-2627-10010047-3_5   | LOANS-002         | 6320.00           | Payment         |
    | LOANS-AY-2627-10010047-3_5   | LOANS-003         |  null       | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | LOANS-AY-2627-10010047-3_5   | LOANS-001         | FY-2627              | April	               | 2027              | 3680.00                    |
    | LOANS-AY-2627-10010047-3_5   | LOANS-002         | FY-2627              | December	           | 2026              | 6320.00                    |

 
 

 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2026'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2627        | LOANS2627    |Accountability Agreement (College)     	   | AA_College                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    Then wait '30' seconds
    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10010047 | 10010047 Co Ltd  | LOANS-AY-2627-Contract-Provider-10010047-3_5            | 3_5            | Education & Skills Funding | AY2627  |Accountability Agreement (College) 		       | LOANS                       | LOANS2627       | Scheduling        | Awaiting Release  | 10000.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                 | [AA_College]         | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | LOANS-AY-2627-Contract-Provider-10010047-3_5            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
        


    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 10000.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010047 | LOANS-AY-2627-Contract-Provider-10010047-3_5            | 3_5            | AY-2627 | LOANS                       | 10000.00    | [AA_College]       | ?                 | ?                                 |
        Then wait '30' seconds

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

  
    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2026'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [AA_College]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup AA_College = [AA_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[AA_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 10000.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10010047' for FundingType 'EDSK' and period '2627'
   #When  I retrieve the latest EFA contract details from CRM for provider '10010047' for FundingType 'ALLBC' and period '2627' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010047 | 10010047 Co Ltd  | LOANS-AY-2627-Contract-Provider-10010047-3_5              | 3_5            | Education & Skills Funding | AY2627  | Accountability Agreement (College)		       | LOANS                         | LOANS2627       | Released          | Released          | 10000.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [AA_College]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | LOANS-AY-2627-Contract-Provider-10010047-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | LOANS-AY-2627-Contract-Provider-10010047-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010047 | LOANS-AY-2627-Contract-Provider-10010047-3_5              | 3_5            | AY-2627 | LOANS                         | 10000.00    | [AA_College]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | LOANS-AY-2627-Contract-Provider-10010047-3_5              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[AA_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010047 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2026        | 31/07/2027      | ?             |
    | 10010047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2026        | 31/07/2027      | ?             |
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


        # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010047_[ContractNo]_v1.pdf' in 'EDSK-2627-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010047_[ContractNo]_v1.pdf'
#
    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2026-07-04 09:12:35.000 |
#
##    # Check the current state of the Tasks for this contract
##    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10010047'
##    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
##    | Initiate Document Merge   | 10010047 - 10010047 Co Ltd Awaiting documentation  | [AllocRef_ALLBC] | Document Management Team  | ?                | Open       | Not Started   |
##
##    # Check the CRM Contract Workflow History data
##    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
##    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
##   #| 10010047 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
##   #| 10010047 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
##    | 10010047 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
##
#
#
##        # 2. Delete the draft contract. FA1 -> Return to Scheduling
##
##    # Change to date
##    Given the override date is '07/07/2023'
##
##    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
##    When  a request is initiated in CRM to delete the following contracts
##   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
##    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
##    | 10010047 | [ContractNo]   | 1                     | 0                  |
##
###
###    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
###    Then  the following Funding Allocations data is present in CRM
###    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus                       | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
###    | 10010047 | 10010047 Co Ltd  | ALLBC-AY-2627-Contract-Provider-10010047-3_5             | 3_5            | Education & Skills Funding | AY2627  | Contract for Services (ITP)       | ALLBC                        | ALLBC2526        | Scheduling        | Returned to Scheduling          | 5000.00     | ?             | ?                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]           | ?          | ?                   |
###
##
##    # Check PaaS FundingAllocation.FundingAllocation (J131)
##    Then the following Funding Allocations data is present in PaaS
##    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
##    | 10010047 | ALLBC-AY-2627-Contract-Provider-10010047-3_5             | 3_5            | AY-2627 | ALLBC                        | 5000.00     | ?               | ?                 | ?                                 |
##
#

    # Publish the contract

    # Change the date 
    Given the override date is '08/07/2026'

   # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
   And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
  # or
     #Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10010047_[ContractNo]_v1.pdf' is created in 'EDSK-2627-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010047 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2026        | 31/07/2027      | ?             |
    | 10010047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2026        | 31/07/2027      | ?             |


#    Given the override date is '08/07/2023'
#        
#     # Withdraw v1 of the contract 
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'ALLBC test withdrawal' by 'FCS1 Test'
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10010047 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2024        | 31/07/2026      | ?             |
#    | 10010047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2026      | ?             |


   # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'


    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2026'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010047 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2026        | 31/07/2027      | ?             |
    | 10010047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2026        | 31/07/2027      | ?             |


    # Run the CDA report
    Given the override date is '09/07/2026'
    Given there is no CDA report named 'CDA Latest Version AK047.csv'
    And   the following ADF Pipeline run
    And   the following CDA report is run
    | FundingStreamPeriod           | Version               | Suffix |
    | ALLBC2627                      | Latest Version        | AK047   |

    Then  a report named 'CDA Latest Version AK047.csv' is created

@AcceptanceTest @Complete
@CFS
Scenario: AK049 Import and release a ALLB2627, ALLF2627 allocation. Approve. Check docs, CRM and feed. 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10010049'
    And   there is no Funding Allocation data in CRM for UKPRN '10010049'
    And   there is no Contract, Task or Workflow data for UKPRN '10010049'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10010049'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010049'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10010049' in the Sharepoint 'EDSK-2627-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables
#
#    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2627        | LOANS2627    | Contract for Services (ITP)      	   |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table




#    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2627          |
    | ALLF2627          |
#
#	
#    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10010049'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010049' 
    And   there is no caseload advisor for UKPRN '10010049' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010049 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010049' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010049 Co Ltd' with UKPRN '10010049' and OrgId 'ORG0010049' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010049 | 110049 | 10010049 Co Ltd | 0              | Active                | Yes           | AA010049      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010049 |





    # Populate the stub with ALLB (06SDC) data

    # Change the date 
    Given the override date is '01/07/2026'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10010049 | LOANS-AY-2627-Contract-Provider-10010049-3_5          | 3_5            | LOANS                       | AY-2627            | 10000.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | LOANS-AY-2627-10010049-3_5 | 3_5                    | LOANS-AY-2627-Contract-Provider-10010049-3_5          | 10010049      | Furth        | 02IPP           | 10000.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | LOANS-AY-2627-10010049-3_5   | LOANS-001         | 3680.00        | Payment         |
    | LOANS-AY-2627-10010049-3_5   | LOANS-002         | null           | Payment         |
    | LOANS-AY-2627-10010049-3_5   | LOANS-003         | 6320.00        | Payment         |

 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | LOANS-AY-2627-10010049-3_5   | LOANS-001         | FY-2627              | April	               | 2027              | 3680.00                    |
    | LOANS-AY-2627-10010049-3_5   | LOANS-003         | FY-2627              | December	           | 2026              | 6320.00                    |

 
 

 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2026'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2627        | LOANS2627    | Contract for Services (ITP)      	   | CFS_ITP                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CFS_ITP = [CFS_ITP]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10010049 | 10010049 Co Ltd  | LOANS-AY-2627-Contract-Provider-10010049-3_5            | 3_5            | Education & Skills Funding | AY2627  | Contract for Services (ITP) 		       | LOANS                       | LOANS2627       | Scheduling        | Awaiting Release  | 10000.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CFS_ITP]         | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | LOANS-AY-2627-Contract-Provider-10010049-3_5            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CFS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 10000.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010049 | LOANS-AY-2627-Contract-Provider-10010049-3_5            | 3_5            | AY-2627 | LOANS                       | 10000.00    | [CFS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CFS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'




    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2026'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CFS_ITP]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CFS_ITP = [CFS_ITP]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CFS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 10000.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10010049' for FundingType 'EDSK' and period '2627'
   #When  I retrieve the latest EFA contract details from CRM for provider '10010049' for FundingType 'ALLB' and period '2627' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010049 | 10010049 Co Ltd  | LOANS-AY-2627-Contract-Provider-10010049-3_5              | 3_5            | Education & Skills Funding | AY2627  | Contract for Services (ITP)		       | LOANS                         | LOANS2627       | Released          | Released          | 10000.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CFS_ITP]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | LOANS-AY-2627-Contract-Provider-10010049-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | LOANS-AY-2627-Contract-Provider-10010049-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010049 | LOANS-AY-2627-Contract-Provider-10010049-3_5              | 3_5            | AY-2627 | LOANS                         | 10000.00    | [CFS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | LOANS-AY-2627-Contract-Provider-10010049-3_5              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CFS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

     Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10010049 | 10010049 Co Ltd  | LOANS-AY-2627-Contract-Provider-10010049-3_5              | 3_5            | Education & Skills Funding | AY2627  | Contract for Services (ITP)		       | LOANS                         | LOANS2627       | Released          | Released          | 10000.00     | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CFS_ITP]       | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | LOANS-AY-2627-Contract-Provider-10010049-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | LOANS-AY-2627-Contract-Provider-10010049-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10010049 | LOANS-AY-2627-Contract-Provider-10010049-3_5              | 3_5            | AY-2627 | LOANS                         | 10000.00    | [CFS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | LOANS-AY-2627-Contract-Provider-10010049-3_5              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CFS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010049 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2026        | 31/07/2027      | ?             |
    | 10010049 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2026        | 31/07/2027      | ?             |
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'


        # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010049_[ContractNo]_v1.pdf' in 'EDSK-2627-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010049_[ContractNo]_v1.pdf'
#
    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2026-07-04 09:12:35.000 |
#
 # Publish the contract

    # Change the date 
    Given the override date is '08/07/2026'

   # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
   And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
  # or
     #Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10010049_[ContractNo]_v1.pdf' is created in 'EDSK-2627-Output-Merged Document'
    #And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
   # And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010049 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2026        | 31/07/2027      | ?             |
    | 10010049 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2026        | 31/07/2027      | ?             |


#    Given the override date is '08/07/2023'
#        
#     # Withdraw v1 of the contract 
#    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'ALLBC test withdrawal' by 'FCS1 Test'
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10010049 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2024        | 31/07/2026      | ?             |
#    | 10010049 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2026      | ?             |


   # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'


    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2026'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010049 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2026        | 31/07/2027      | ?             |
    | 10010049 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2026        | 31/07/2027      | ?             |
#
# # Retrieve parameters
#    And   I retrieve the latest contract details from CRM for provider '10010049' for FundingType 'EDSK' and period '2627'
#
#  #  # Check the contents of the Appendices 
#  #  Then  the file named '10010049_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2627-Input-Appendices' contains the following lines in order
#  #  """
#  #  SUMMARY OF FUNDING 2026/27
#  #  Organisation Name: 10010049 Co Ltd UKPRN: 10010049
#  #  Master Contract Number: [MasterContractNo]
#  #  Allocation
#  #  Contract Ref Aug 26 - Mar 27 Apr 27 - Jul 27 2026/27 Total
#  #  Advanced Learner Loans Facility [AllocRef_ALLF] £23,201 £6,799 £30,000
#  #  Advanced Learner Loans Bursary [AllocRef_ALLB] £21,898 £18,102 £40,000
#  #  Total Funding for this contract: £70,000
#  #  Summary of Funding – Page 1
#  #  """
#  #
#  #  # There should not be a TAC
#  #  And   the pdf file does not contain the following text
#  #  """
#  #  Agreement Type Conditions of Funding (Grant) (Employers)
#  #  """
#
#
# 
#
#
#    # Publish and approve
#
#    # Change the date
#    Given the override date is '28/03/2026'
#
#    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    # Check the CONTRACT version, status and dates in CRM.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10010049 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2026        | 31/07/2027      | Variation     |
#    | 10010049 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2026        | 31/07/2027      | ?             |
#    | 10010049 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2026        | 31/07/2027      | ?             |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#    And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#
    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ALLB] | 2303800          | Jul-27 | Reconciliation |





    # Add actuals to the contract for ALLB2627

    # Change the date
    Given the override date is '04/11/2026'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0010049'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2026
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202608 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2498.70     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202608 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1347.24     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202608 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2090.31     |
    #
    | ILR2627        | R01                  | ORG0010049     | CM             | 202609 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 679.53      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202609 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1330.31     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202609 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2364.35     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202610 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1764.18     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202610 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1048.84     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202610 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2091.38     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202611 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 194.56      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202611 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1727.00     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202611 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 748.89      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202612 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2368.13     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202612 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 2322.55     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202612 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2213.62     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202701 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1475.22     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202701 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 614.34      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202701 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 1898.97     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202702 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 936.70      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202702 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 2089.85     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202702 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 892.58      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202703 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2441.41     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202703 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 632.58      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202703 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 1493.84     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202704 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1783.60     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202704 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 609.71      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202704 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 951.32      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202705 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2100.55     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202705 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1159.46     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202705 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 200.33      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202706 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1309.97     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202706 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 278.64      |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202706 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 1200.39     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202707 | ALLB2627                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1747.56     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202707 | ALLB2627                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1910.20     |
    | ILR2627        | R01                  | ORG0010049     | CM             | 202707 | ALLB2627                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2472.73     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check actuals in CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 4942.41   | 2498.70  | 679.53   | 1764.18  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 3726.39   | 1347.24  | 1330.31  | 1048.84  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 6546.04   | 2090.31  | 2364.35  | 2091.38  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
#    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 4942.41   | 2498.70  | 679.53   | 1764.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 3726.39   | 1347.24  | 1330.31  | 1048.84  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 6546.04   | 2090.31  | 2364.35  | 2091.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-26   | Sep-26   | Oct-26   | Nov-26   | Dec-26   | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
#    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 4942.41   | 2498.70  | 679.53   | 1764.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 3726.39   | 1347.24  | 1330.31  | 1048.84  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 6546.04   | 2090.31  | 2364.35  | 2091.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#



    # Payment Batch starts here for ALLB2627 (PoA)


    # Change the date
    Given the override date is '09/11/2026 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLB2627' AccountingPaymentPeriod '202607' CensusEndDate '09/11/2026' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ALLB]          | 202610 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLB2627                   | 202610               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLB2627                   | 202610               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLB2627' PaymentPeriod '202607' CensusEndDate '09/11/2026' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'AK049.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    #And   the Payment feed xml for FundingStreamPeriod 'ALLB2627' PaymentPeriod '202305' CensusEndDate '09/11/2026' and LinkCodeSuffix 'A' includes the following values
    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription    | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    #| LBT                    | 2026          | 07             | 10          | ?       | [AllocRef_ALLB]   | 6320.00         | RECONCILIATION   | Adv LL Bursary           | 2026-11-19 | 2026-08-01   | 2027-07-31 | ?              | 10010049 | 2303800    |

    # CDA
    
    # Run the CDA report
    Given the override date is '11/08/2026'
    Given there is no CDA report named 'CDA Latest Version AK049.csv'
    And   the following ADF Pipeline run
    And   the following CDA report is run
    | FundingStreamPeriod           | Version               | Suffix |
    | ALLB2627                      | Latest Version        | AK049   |

    Then  a report named 'CDA Latest Version AK049.csv' is created
  # Given the override date is reset