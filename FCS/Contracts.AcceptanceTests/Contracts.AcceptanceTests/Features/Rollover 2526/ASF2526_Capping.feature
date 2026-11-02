Feature: ASF2526_Capping


@AcceptanceTest @Complete
@Long2Run @Long2Run67
Scenario: S061 Import and release a ASF2023-AS2526 and ASF2023-FCFJ2526 FA. Approve. Check docs, CRM and feed. Amend and repeat
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10018061'
    #And   there is no Funding Allocation data in CRM for UKPRN '10018061'
    And   there is no Contract, Task or Workflow data for UKPRN '10018061'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10018061'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018061'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10018061' in the Sharepoint 'AEB2023-2526-Input-Appendices' folder

    # Clear down the Cfs stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | AEB2023         | AY2526        | ASF2023_2526 | Contract for Services             |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table
	
	And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASF2023-AS2526    |
    | ASF2023-FCFJ2526  |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018061' 
    And   there is no caseload advisor for UKPRN '10018061' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018061 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018061' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018061 Co Ltd' with UKPRN '10018061' and OrgId 'ORG0018061' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018061 | 118061 | 10018061 Co Ltd | 0              | Active                | Yes           | AA018061      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018061 |







    # Populate the stub with ASF data

   # Change the date 
   Given the override date is '01/07/2025'

   # Clear down the Cfs stub
   And   there is no data in the CFS stub

   # Funding Allocation 
   And   the following Funding Allocation data is in the CFS stub
   | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
   | Contracting    | 10018061 | AEB2023-AY-2526-Contract-Provider-10018061-3_5        | 3_5            | ASFC                        | AY-2526            | 8180.00          |

   # Provider Funding Allocation
   And   the following Provider Funding Agreement data is present in the CFS stub

   | ProviderFundingId             | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                                 | ProviderSubType                                   | ProviderFundingTotalValue |
   | AEB2023-AY-2526-10018061-3_5  | 3_5                 	| AEB2023-AY-2526-Contract-Provider-10018061-3_5        | 10018061      | Limited Liability Partnership                | Direct Funded Organisation              	       | 8180.00                  |


   # Funding Allocation Line (aka Deliverable)
   And   the following Funding Allocation Line data is present in the CFS stub
   | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-001         | 1000.00		| Payment         |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-002         | 3680.00        | Payment         |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-003         | 6320.00        | Payment         |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-004         | 2500.00        | Payment         |


   # Funding Allocation Profile Period
   And   the following Funding Allocation Profile Period data is present in the CFS stub
   | ProviderFundingId          	| FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-001         | FY-2526              | September            | 2025              | 1000.00                    |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-002         | FY-2526              | December	         | 2025              | 680.00                     |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-002         | FY-2526              | January	             | 2026              | 1000.00                    |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-002         | FY-2526              | March	             | 2026              | 2000.00                    |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-003         | FY-2526              | November             | 2025              | 3320.00                    |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-003         | FY-2526              | December             | 2025              | 1000.00                    |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-003         | FY-2526              | January              | 2026              | 1000.00                    |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-003         | FY-2526              | February             | 2026              | 1000.00                    |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-004         | FY-2526              | December	         | 2025              | 1500.00                    |
   | AEB2023-AY-2526-10018061-3_5   | ASFC-004         | FY-2526              | March	         	 | 2026              | 1000.00                    |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2025'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode 	 | ContractType                            | ReleaseGroupParameterName |
    | AEB2023         | AY2526        | ASF2023_2526     | Contract for Services    			   | Cfs    	               |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                                  | FundingVersion | FundingType                				| Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10018061 | 10018061 Co Ltd  | AEB2023-AY-2526-Contract-Provider-10018061-3_5             | 3_5         	| Adult Education Budget - 2023 Procurement | AY2526  | Contract for Services       		 | ASFC                        | ASF2023_2526    | Scheduling        | Awaiting Release  | 8180.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [Cfs]             | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2526-Contract-Provider-10018061-3_5          | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 8180.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018061 | AEB2023-AY-2526-Contract-Provider-10018061-3_5          | 3_5            | AY-2526 | ASFC                        | 8180.00     | [Cfs]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[Cfs]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2025'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [Cfs]      |

    # Write the following values to the output window
    And   message 'ReleaseGroup Cfs = [Cfs]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[Cfs]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 8180.00         |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10018061' for FundingType 'AEB2023' and period '2526'
   #When  I retrieve the latest EFA contract details from CRM for provider '10018061' for FundingType 'AEB2023' and period '2526' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                					 | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018061 | 10018061 Co Ltd  | AEB2023-AY-2526-Contract-Provider-10018061-3_5          | 3_5            | Adult Education Budget - 2023 Procurement     | AY2526  | Contract for Services              | ASFC                        | ASF2023_2526        | Released          | Released          | 8180.00     | [ContractNo]  | 1            | CRM Integration   | CRMDeploy CRMDeploy   | ?                         | [Cfs]           | ?          | ?                   |




    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018061_[ContractNo]_v1.pdf' in 'AEB2023-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018061_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2025-07-04 09:12:35.000 |

    # Check the current state of the Tasks for this contract
#    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018061'
#    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
#    | Initiate Document Merge   | 10018061 - 10018061 Co Ltd Awaiting documentation  | [AllocRef_ASFC] | Document Management Team  | ?                | Open       | Not Started   |
#
#    # Check the CRM Contract Workflow History data
#    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
#    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
#   #| 10018061 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#   #| 10018061 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#    | 10018061 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
#


    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2025'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018061_[ContractNo]_v1.pdf' is created in 'AEB2023-2526-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018061 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2025        | 31/07/2026      | ?             |
    | 10018061 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018061 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10018061 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                					 | Period  | ContractType                              | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10018061 | 10018061 Co Ltd  | AEB2023-AY-2526-Contract-Provider-10018061-3_5          | 3_5            | Adult Education Budget - 2023 Procurement     | AY2526  | Contract for Services               | ASFC                        | ASF2023_2526    | Contract Approved | Contract Approved | 8180.00     | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [Cfs]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               	| FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10018061 | AEB2023-AY-2526-Contract-Provider-10018061-3_5             | 3_5            | AY-2526 | ASFC                        | 8180.00     | [Cfs]           | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | AEB2023-AY-2526-Contract-Provider-10018061-3_5          | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    #Then  the Legal Contract CM feed contains the following '4' deliverables
    #| UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    #| 10018061 | [ContractNo]   | 1               | [AllocRef_ASCA]  | 5               | 1                     | 3680.00       | 0             | 0        | Tailored Learning                                  | ?                           |
    #| 10018061 | [ContractNo]   | 1               |  [AllocRef_ASCA] | 2               | 1                     |  1000.00      | 0             | 0        |  Adult Skills Total Funding                        | ?                           |
    #| 10018061 | [ContractNo]   | 1               |  [AllocRef_ASCA] | 12              | 1                     |  6320.00      | 0             | 0        |  Funding for Innovative Provision                  | ?                           |
    #| 10018061 | [ContractNo]   | 1               |  [AllocRef_ASFC] | 2               | 1                     |  2500.00      | 0             | 0        |  Funding for Innovative Provision                  | ?                           |




    And wait '20' seconds

    # Part 5: Add Actuals for 25/26 then check CRM

    # Add actuals to the contract for ASF2023-AS2526, ASF2023-FCFJ2526 

    # Change the date
    Given the override date is '04/04/2026'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018061'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber   | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 656.38      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 514.81      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 564.11      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1411.24     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 478.56      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1469.21     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1163.17     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 2352.37     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 465.26      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 2003.87     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 699.93      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 844.84      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1604.57     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 860.77      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 656.38      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 514.81      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 564.11      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1411.24     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 478.56      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1469.21     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1163.17     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 2352.37     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 465.26      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 2003.87     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 699.93      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 844.84      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1604.57     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 860.77      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 656.38      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 514.81      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 564.11      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1411.24     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 478.56      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1469.21     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1163.17     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 2352.37     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 465.26      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 2003.87     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 699.93      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 844.84      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1604.57     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 860.77      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 656.38      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 514.81      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 564.11      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1411.24     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 478.56      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1469.21     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1163.17     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 2               | 0            | 656.38      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 3               | 0            | 514.81      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 6               | 0            | 564.11      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 7               | 0            | 1411.24     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 8               | 0            | 478.56      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 9               | 0            | 1469.21     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-AS2526          | [AllocRef_ASFA23]          | ?          | 10              | 0            | 1163.17     |
 #   #                                                                                                            
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1951.00     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 627.27      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1274.11     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1790.98     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 615.15      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1977.70     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202508 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1956.70     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 804.17      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 855.21      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 631.06      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 938.44      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 995.84      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1931.92     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202509 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 2158.27     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1951.00     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 627.27      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1274.11     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1790.98     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 615.15      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1977.70     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202510 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1956.70     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 804.17      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 855.21      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 631.06      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 938.44      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 995.84      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1931.92     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202511 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 2158.27     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1951.00     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 627.27      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1274.11     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1790.98     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 615.15      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1977.70     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202512 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1956.70     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 804.17      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 855.21      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 631.06      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 938.44      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 995.84      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1931.92     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202601 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 2158.27     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 1951.00     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 627.27      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 1274.11     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 1790.98     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 615.15      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1977.70     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202602 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 1956.70     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 3               | 0            | 804.17      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 4               | 0            | 855.21      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 6               | 0            | 631.06      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 7               | 0            | 938.44      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 8               | 0            | 995.84      |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 9               | 0            | 1931.92     |
    | ILR2526        | R09                  | ORG0018061     | CM             | 202603 | ASF2023-FCFJ2526         | [AllocRef_ASFJ23]           | ?          | 10              | 0            | 2158.27     |

    Then wait '30' seconds


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then wait '60' seconds


 #
 #   # Check the ACTUAL VALUES in CRM on the latest approved contract
 #   Then  the Actuals Value Data is as follows
 #   | ContractNumber | AllocationRef | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 1             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 2             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 3             | 2755.17   | 1951.00  | 804.17   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 4             | 1482.48   | 627.27   | 855.21   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 5             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 6             | 1905.17   | 1274.11  | 631.06   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 7             | 2729.42   | 1790.98  | 938.44   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 8             | 1610.99   | 615.15   | 995.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 9             | 3909.62   | 1977.70  | 1931.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFJ23]| 10            | 4114.97   | 1956.70  | 2158.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   #
 #   | [ContractNo]   | [AllocRef_ASFA23]| 1             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 2             | 3008.75   | 656.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 3             | 980.07    | 514.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 4             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 5             | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 6             | 2567.98   | 564.11   | 2003.87  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 7             | 2111.17   | 1411.24  | 699.93   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 8             | 1323.40   | 478.56   | 844.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 9             | 3073.78   | 1469.21  | 1604.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ASFA23]| 10            | 2023.94   | 1163.17  | 860.77   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	#

#
#
#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 3               | 2755.17   | 0.00     | 2755.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 4               | 1482.48   | 0.00     | 1482.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 6               | 1905.17   | 0.00     | 1905.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 7               | 2729.42   | 0.00     | 2729.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 8               | 1610.99   | 0.00     | 1610.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 9               | 3909.62   | 0.00     | 3909.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFJ23]  | 10              | 4114.97   | 0.00     | 4114.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_ASFA23]  | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 2               | 3008.75   | 0.00     | 3008.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 3               | 980.07    | 0.00     | 980.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 6               | 2567.98   | 0.00     | 2567.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 7               | 2111.17   | 0.00     | 2111.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 8               | 1323.40   | 0.00     | 1323.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 9               | 3073.78   | 0.00     | 3073.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ASFA23]  | 10              | 2023.94   | 0.00     | 2023.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#






    
    # Payment Batch for ASFC-ASCL2526(PoA)

    # Change the date
    Given the override date is '10/04/2026 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASF2023-AS2526' AccountingPaymentPeriod '202512' CensusEndDate '10/04/2026' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber 	 | Period |
    | [AllocRef_ASFA23]          | 202603 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASF2023-AS2526             | 202603               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ASF2023-AS2526             | 202603               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ASF2023-AS2526' PaymentPeriod '202512' CensusEndDate '10/04/2026' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S061_ASFA.xml'
#
#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ALLB2526' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | ALLB                   | 2023          | 05             | 02          | ?       | [AllocRef_ALLB]   | 562.00          | PROFILE          | Principals Ref Group               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208100    |
#    | ALLB                   | 2023          | 05             | 02          | ?       | [AllocRef_ALLB]   | 448.00          | PROFILE          | NationalLeadrs of FE               | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2208200    |
#    | ALLB                   | 2023          | 05             | 02          | ?       | [AllocRef_ALLB]   | 25.00           | PROFILE          | Isles of Scilly                    | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10018034 | 2202070    |
#
#

#
#    # Consolidated Payment Summary Report
#
#    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#    When a Consolidated Payment Summary Report is created in Sharepoint for '02/08/2023'
#
#    # Check the contents of the Consolidated Payment Summary Report manually


    
    # Payment Batch for ASFC-ASFJ(PoA)

    # Change the date
    Given the override date is '10/04/2026 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ASF2023-FCFJ2526' AccountingPaymentPeriod '202512' CensusEndDate '10/04/2026' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ASFJ23]          | 202603 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ASF2023-FCFJ2526           | 202603               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ASF2023-FCFJ2526           | 202603               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ASF2023-FCFJ2526' PaymentPeriod '202512' CensusEndDate '10/04/2026' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S061_ASFJ.xml'
#


    # Change the date
    Given the override date is '12/04/2026 09:05'
    
   #  Part 10: Create Consolidated Payment Summary rpt
   
   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
   Given there are no files prefixed '2026-04 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder

   When  a Consolidated Payment Summary Report is created in Sharepoint for '12/04/2026'

    # Check the above report manually




    # Tidy Up
    Given the override date is reset
