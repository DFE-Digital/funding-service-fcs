Feature: PreventTerminationCompletion 35130

@AcceptanceTest @Manual
@CFS
Scenario: A725 Import and release 1416 and NMSS FAs for Contracting Org and 2x Delivery Orgs. Publish and approve. Data setup for manual test
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017725'
    And   there is no Funding Allocation data in CRM for UKPRN '10017725'
    And   there is no Contract, Task or Workflow data for UKPRN '10017725'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017725'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017725'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017725' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017725' 
    And   there is no Organisation data in CRM for UKPRN '10000404' 
    And   there is no Organisation data in CRM for UKPRN '10000851' 
    And   there is no caseload advisor for UKPRN '10017725' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017725 | 
    | 10000404 |
    | 10000851 |
    
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017725' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Merseyside CC' with UKPRN '10017725' and OrgId 'ORG0017725' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017725 | 117725 | Humberside CC   | 0              | Active                | Yes           | AA017725      | ?             | 2 Town Road            | Delph                  | ?                      | ?                      | Saddleworth            | Merseyside             | OL4 7DJ   |
    | 10000404 | 100404 | Littleton Coll  | 0              | Active                | Yes           | AA000404      | ?             | 19 Waterside Avenue    | Upper Bridge Street    | West Horton            | ?                      | ?                      | Merseyside             | BL6 7AH   |
    | 10000851 | 100851 | Hamble College  | 0              | Active                | Yes           | AA000851      | ?             | Goldsmith Bldgs        | Jacob Green Road       | Kelsall                | ?                      | ?                      | Merseyside             | BO2 8AJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017725 |
    | 10000404 |
    | 10000851 |



    # Populate the stub with 1416 data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation for Local Authority and two Delivery Orgs (D\Orgs have zero-value lines)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017725 | 1416-AY-2122-Contract-LocalAuthority-10017725-1_2     | 1_2            | 1416                        | AY-2122            | 24241.00          |
    | Contracting    | 10017725 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017725-1_2  | 1_2            | 1416                        | AY-2122            | 46443.00          |
    | Contracting    | 10017725 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017725-2_5  | 2_5            | NMSS                        | AY-2122            | 59222.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1416-AY-2122-10017725-1_2  | 1_2                    | 1416-AY-2122-Contract-LocalAuthority-10017725-1_2     | 10017725      | Local        | 10LAU           | 24241.00                  |
    | 1416-AY-2122-10000404-1_2  | 1_2                    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017725-1_2  | 10000404      | Schoo        | 08SSF           | 15409.00                  |
    | 1416-AY-2122-10000851-1_2  | 1_2                    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017725-1_2  | 10000851      | Schoo        | 08SSF           | 31034.00                  |
    | NMSS-AY-2122-10000851-2_5  | 2_5                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017725-2_5  | 10000851      | Schoo        | 08SSF           | 59222.00                  |

    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1416-AY-2122-10017725-1_2  | 1416-001        | 9479.00          | Payment         |
    | 1416-AY-2122-10017725-1_2  | 1416-002        | 6169.00          | Payment         |
    | 1416-AY-2122-10017725-1_2  | 1416-003        | 8593.00          | Payment         |
    #
    | 1416-AY-2122-10000404-1_2  | 1416-001        | 0.00             | Payment         |
    | 1416-AY-2122-10000404-1_2  | 1416-002        | 13033.00         | Payment         |
    | 1416-AY-2122-10000404-1_2  | 1416-003        | 2376.00          | Payment         |
    #
    | 1416-AY-2122-10000851-1_2  | 1416-001        | 13264.00         | Payment         |
    | 1416-AY-2122-10000851-1_2  | 1416-002        | 0.00             | Payment         |
    | 1416-AY-2122-10000851-1_2  | 1416-003        | 17770.00         | Payment         |
    #
    | NMSS-AY-2122-10000851-2_5  | NMSS-005        | 19331.00         | Payment         |
    | NMSS-AY-2122-10000851-2_5  | NMSS-007        | 20027.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1416-AY-2122-10017725-1_2  | 1416-001        | FY-2122              | September              | 2021              | 2524.00                   |
    | 1416-AY-2122-10017725-1_2  | 1416-001        | FY-2122              | February               | 2022              | 4618.00                   |
    | 1416-AY-2122-10017725-1_2  | 1416-001        | FY-2122              | April                  | 2022              | 2337.00                   |
    | 1416-AY-2122-10017725-1_2  | 1416-002        | FY-2122              | November               | 2021              | 2550.00                   |
    | 1416-AY-2122-10017725-1_2  | 1416-002        | FY-2122              | March                  | 2022              | 3619.00                   |
    | 1416-AY-2122-10017725-1_2  | 1416-003        | FY-2122              | November               | 2021              | 3300.00                   |
    | 1416-AY-2122-10017725-1_2  | 1416-003        | FY-2122              | May                    | 2022              | 5293.00                   |
    #
    | 1416-AY-2122-10000404-1_2  | 1416-001        | FY-2122              | January                | 2022              | 0.00                      |
    | 1416-AY-2122-10000404-1_2  | 1416-002        | FY-2122              | November               | 2021              | 5726.00                   |
    | 1416-AY-2122-10000404-1_2  | 1416-002        | FY-2122              | January                | 2022              | 2932.00                   |
    | 1416-AY-2122-10000404-1_2  | 1416-002        | FY-2122              | April                  | 2022              | 4375.00                   |
    | 1416-AY-2122-10000404-1_2  | 1416-003        | FY-2122              | November               | 2021              | 2376.00                   |
    #
    | 1416-AY-2122-10000851-1_2  | 1416-001        | FY-2122              | October                | 2021              | 3034.00                   |
    | 1416-AY-2122-10000851-1_2  | 1416-001        | FY-2122              | December               | 2021              | 5812.00                   |
    | 1416-AY-2122-10000851-1_2  | 1416-001        | FY-2122              | June                   | 2022              | 4418.00                   |
    | 1416-AY-2122-10000851-1_2  | 1416-002        | FY-2122              | March                  | 2022              | 0.00                      |
    | 1416-AY-2122-10000851-1_2  | 1416-003        | FY-2122              | October                | 2021              | 5208.00                   |
    | 1416-AY-2122-10000851-1_2  | 1416-003        | FY-2122              | January                | 2022              | 3541.00                   |
    | 1416-AY-2122-10000851-1_2  | 1416-003        | FY-2122              | April                  | 2022              | 4540.00                   |
    | 1416-AY-2122-10000851-1_2  | 1416-003        | FY-2122              | June                   | 2022              | 4481.00                   |
    #
    | NMSS-AY-2122-10000851-2_5  | NMSS-005        | FY-2122              | August                 | 2021              | 2216.00                   |
    | NMSS-AY-2122-10000851-2_5  | NMSS-005        | FY-2122              | November               | 2021              | 3765.00                   |
    | NMSS-AY-2122-10000851-2_5  | NMSS-005        | FY-2122              | March                  | 2022              | 5244.00                   |
    | NMSS-AY-2122-10000851-2_5  | NMSS-005        | FY-2122              | May                    | 2022              | 4807.00                   |
    | NMSS-AY-2122-10000851-2_5  | NMSS-005        | FY-2122              | June                   | 2022              | 3995.00                   |
    #
    | NMSS-AY-2122-10000851-2_5  | NMSS-007        | FY-2122              | October                | 2021              | 5040.00                   |
    | NMSS-AY-2122-10000851-2_5  | NMSS-007        | FY-2122              | December               | 2021              | 3373.00                   |
    | NMSS-AY-2122-10000851-2_5  | NMSS-007        | FY-2122              | March                  | 2022              | 4372.00                   |
    | NMSS-AY-2122-10000851-2_5  | NMSS-007        | FY-2122              | May                    | 2022              | 4313.00                   |

 


    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)



    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 129906.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 3               | 129906.00       |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017725' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017725' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017725 | Humberside CC    | 1416-AY-2122-Contract-LocalAuthority-10017725-1_2       | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2122     | Released          | Released          | 24241.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017725 | Humberside CC    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017725-1_2    | 1_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2122     | Released          | Released          | 46443.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017725 | Humberside CC    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017725-2_5    | 2_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Released          | Released          | 59222.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017725 | 1416-AY-2122-Contract-LocalAuthority-10017725-1_2       | 1_2            | AY-2122 | 1416                        | 24241.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017725 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017725-1_2    | 1_2            | AY-2122 | 1416                        | 46443.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017725 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017725-2_5    | 2_5            | AY-2122 | NMSS                        | 59222.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1416-AY-2122-Contract-LocalAuthority-10017725-1_2       | [ContractNo] | 1               | 0                  | Yes            |
    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017725-1_2    | [ContractNo] | 1               | 0                  | Yes            |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017725-2_5    | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017725 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017725 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM
    Then  there are '108' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017725_[ContractNo]_v1.pdf' is created in 'EDSK-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017725 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017725 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017725 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017725 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Manual
@CFS
Scenario: A726_1 Import and release a 1619 FA. Publish and approve. Data setup for manual test
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017726'
    And   there is no Funding Allocation data in CRM for UKPRN '10017726'
    And   there is no Contract, Task or Workflow data for UKPRN '10017726'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017726'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017726'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017726' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017726' 
    And   there is no caseload advisor for UKPRN '10017726' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017726 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017726' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017726 Co Ltd' with UKPRN '10017726' and OrgId 'ORG0017726' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017726 | 117726 | 10017726 Co Ltd | 0              | In Administration     | Yes           | AA017726      | ?             | 2 Ambassador House     | Wolseley Road          | ?                      | ?                      | Harrow                 | Middlesex              | HA3 5RT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017726 |





    # Populate the stub with 1619 (04AHC) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017726 | 1619-AS-2122-Contract-Provider-10017726-1_6           | 1_6            | 1619                        | AS-2122            | 47991.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017726-1_6  | 1_6                    | 1619-AS-2122-Contract-Provider-10017726-1_6           | 10017726      | Furth        | 04AHC           | 47991.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017726-1_6  | 1619-002        | 10966.00         | Payment         |
    | 1619-AS-2122-10017726-1_6  | 1619-003        | 11437.00         | Payment         |
    | 1619-AS-2122-10017726-1_6  | 1619-009        | 0.00             | Payment         |
    | 1619-AS-2122-10017726-1_6  | 1619-020        | 18967.00         | Payment         |
    | 1619-AS-2122-10017726-1_6  | 1619-021        | 6621.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017726-1_6  | 1619-002        | FY-2122              | September              | 2021              | 2678.00                   |
    | 1619-AS-2122-10017726-1_6  | 1619-002        | FY-2122              | February               | 2022              | 3746.00                   |
    | 1619-AS-2122-10017726-1_6  | 1619-002        | FY-2122              | May                    | 2022              | 4542.00                   |
    #
    | 1619-AS-2122-10017726-1_6  | 1619-003        | FY-2122              | October                | 2021              | 5468.00                   |
    | 1619-AS-2122-10017726-1_6  | 1619-003        | FY-2122              | February               | 2022              | 2434.00                   |
    | 1619-AS-2122-10017726-1_6  | 1619-003        | FY-2122              | May                    | 2022              | 3535.00                   |
    #
    | 1619-AS-2122-10017726-1_6  | 1619-009        | FY-2122              | June                   | 2022              | 0.00                      |
    #
    | 1619-AS-2122-10017726-1_6  | 1619-020        | FY-2122              | October                | 2021              | 4114.00                   |
    | 1619-AS-2122-10017726-1_6  | 1619-020        | FY-2122              | January                | 2022              | 5866.00                   |
    | 1619-AS-2122-10017726-1_6  | 1619-020        | FY-2122              | February               | 2022              | 3548.00                   |
    | 1619-AS-2122-10017726-1_6  | 1619-020        | FY-2122              | July                   | 2022              | 5439.00                   |
    #
    | 1619-AS-2122-10017726-1_6  | 1619-021        | FY-2122              | November               | 2021              | 2947.00                   |
    | 1619-AS-2122-10017726-1_6  | 1619-021        | FY-2122              | February               | 2022              | 3674.00                   |
 
 
 
 
 
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
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017726 | 10017726 Co Ltd  | 1619-AS-2122-Contract-Provider-10017726-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 47991.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 47991.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017726 | 1619-AS-2122-Contract-Provider-10017726-1_6             | 1_6            | AS-2122 | 1619                        | 47991.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 47991.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017726' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017726' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017726 | 10017726 Co Ltd  | 1619-AS-2122-Contract-Provider-10017726-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 47991.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017726 | 1619-AS-2122-Contract-Provider-10017726-1_6             | 1_6            | AS-2122 | 1619                        | 47991.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017726-1_6             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017726 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017726 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017726 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 47991.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017726 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017726 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017726 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017726 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 47991.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 10966.00  | 0.00     | 2678.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3746.00  | 0.00     | 0.00     | 4542.00  | 0.00     | 0.00     | 16-19 Bursary Funds                                         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 11437.00  | 0.00     | 0.00     | 5468.00  | 0.00     | 0.00     | 0.00     | 2434.00  | 0.00     | 0.00     | 3535.00  | 0.00     | 0.00     | Residential Bursary Fund                                    |                          |
 #  | [ContractNo]   | [AllocRef_16ED] | 136             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses Premium                            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 52              | 18967.00  | 0.00     | 0.00     | 4114.00  | 0.00     | 0.00     | 5866.00  | 3548.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5439.00  | Alternative Completions - Sea Fishing                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 6621.00   | 0.00     | 0.00     | 0.00     | 2947.00  | 0.00     | 0.00     | 3674.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Creative Sector                   |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '48' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017726_[ContractNo]_v1.pdf' is created in 'EDSK-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017726 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017726 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017726 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017726 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017726 | 10017726 Co Ltd  | 1619-AS-2122-Contract-Provider-10017726-1_6             | 1_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 47991.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017726 | 1619-AS-2122-Contract-Provider-10017726-1_6             | 1_6            | AS-2122 | 1619                        | 47991.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check that the CRM Funding Allocation Workflow History includes an approval
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017726-1_6             | Contract Approved               | CRM Integration   | Contract Approved  | Contract Approved               | Released       | Released                        | ?                             |


    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Manual
@CFS
Scenario: A726_2 Import and release an updated 1619 FA to replace that imported by A726x.
 
    # Before running A726_2 ensure contract is in a state of 'Approved\Under Termination'. (Manual activity in CRM)

    # Clear down the CFS stub
    Given there is no data in the CFS stub

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table





    # Populate the stub with 1619 (04AHC) data

    # Change the date 
    Given the override date is '01/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017726 | 1619-AS-2122-Contract-Provider-10017726-2_1           | 2_1            | 1619                        | AS-2122            | 48000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017726-2_1  | 2_1                    | 1619-AS-2122-Contract-Provider-10017726-2_1           | 10017726      | Furth        | 04AHC           | 48000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017726-2_1  | 1619-002        | 10967.00         | Payment         |
    | 1619-AS-2122-10017726-2_1  | 1619-003        | 11439.00         | Payment         |
    | 1619-AS-2122-10017726-2_1  | 1619-009        | 0.00             | Payment         |
    | 1619-AS-2122-10017726-2_1  | 1619-020        | 18969.00         | Payment         |
    | 1619-AS-2122-10017726-2_1  | 1619-021        | 6625.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017726-2_1  | 1619-002        | FY-2122              | September              | 2021              | 2678.00                   |
    | 1619-AS-2122-10017726-2_1  | 1619-002        | FY-2122              | February               | 2022              | 3746.00                   |
    | 1619-AS-2122-10017726-2_1  | 1619-002        | FY-2122              | May                    | 2022              | 4543.00                   |
    #
    | 1619-AS-2122-10017726-2_1  | 1619-003        | FY-2122              | October                | 2021              | 5468.00                   |
    | 1619-AS-2122-10017726-2_1  | 1619-003        | FY-2122              | February               | 2022              | 2436.00                   |
    | 1619-AS-2122-10017726-2_1  | 1619-003        | FY-2122              | May                    | 2022              | 3535.00                   |
    #
    | 1619-AS-2122-10017726-2_1  | 1619-009        | FY-2122              | June                   | 2022              | 0.00                      |
    #
    | 1619-AS-2122-10017726-2_1  | 1619-020        | FY-2122              | October                | 2021              | 4116.00                   |
    | 1619-AS-2122-10017726-2_1  | 1619-020        | FY-2122              | January                | 2022              | 5866.00                   |
    | 1619-AS-2122-10017726-2_1  | 1619-020        | FY-2122              | February               | 2022              | 3548.00                   |
    | 1619-AS-2122-10017726-2_1  | 1619-020        | FY-2122              | July                   | 2022              | 5439.00                   |
    #
    | 1619-AS-2122-10017726-2_1  | 1619-021        | FY-2122              | November               | 2021              | 2947.00                   |
    | 1619-AS-2122-10017726-2_1  | 1619-021        | FY-2122              | February               | 2022              | 3678.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '02/08/2021'

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
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017726 | 10017726 Co Ltd  | 1619-AS-2122-Contract-Provider-10017726-2_1             | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 48000.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 48000.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017726 | 1619-AS-2122-Contract-Provider-10017726-2_1             | 2_1            | AS-2122 | 1619                        | 48000.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'


    # Tidy Up
    Given the override date is reset
     

    # Now try and complete the contract termination in CRM. This should fail with message:
    # 'Unable to complete contract termination - one or more outstanding funding allocations exist'
      
@AcceptanceTest @Manual
@CFS
Scenario: A727 Import and release a CCF2122 FA3_4. Publish and approve contract v1. Import and release FA4_1. Publish contract v2 then withdraw. Return FA4_1 > Scheduling\Returned to Scheduling. Data setup for manual test

    # 1. Import and release a CCF FA then publish and approve the contract
    # 2. Import and release an updated CCF FA. Publish then withdraw contract
    # 3. Second FA > Scheduling\Returned to Scheduling

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017727'
    And   there is no Funding Allocation data in CRM for UKPRN '10017727'
    And   there is no Contract, Task or Workflow data for UKPRN '10017727'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017727'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017727'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017727' in the Sharepoint 'CCF-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | CCF             | FY2122        | CCF2122      | Conditions of Funding (Grant) (College) |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017727' 
    And   there is no caseload advisor for UKPRN '10017727' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017727 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017727' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017727 Co Ltd' with UKPRN '10017727' and OrgId 'ORG0017727' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017727 | 117727 | 10017727 Co Ltd | 0              | Provider Under Change | Yes           | AA017727      | ?             | 3 Kings Court          | 153 - 155 High Street  | Watford                | ?                      | ?                      | ?                      | WD17 2ER  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017727 |







    # Populate the stub with CCF (07HEP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017727 | CCF-FY-2122-Contract-Provider-10017727-3_4            | 3_4            | CCF                         | FY-2122            | 27283.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | CCF-FY-2122-10017727-3_4   | 3_4                    | CCF-FY-2122-Contract-Provider-10017727-3_4            | 10017727      | Furth        | 07HEP           | 27283.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | CCF-FY-2122-10017727-3_4   | CCF-001         | 27283.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | CCF-FY-2122-10017727-3_4   | CCF-001         | FY-2122              | April                  | 2021              | 4628.00                   |
    | CCF-FY-2122-10017727-3_4   | CCF-001         | FY-2122              | July                   | 2021              | 5697.00                   |
    | CCF-FY-2122-10017727-3_4   | CCF-001         | FY-2122              | August                 | 2021              | 2491.00                   |
    | CCF-FY-2122-10017727-3_4   | CCF-001         | FY-2122              | November               | 2021              | 5168.00                   |
    | CCF-FY-2122-10017727-3_4   | CCF-001         | FY-2122              | January                | 2022              | 5141.00                   |
    | CCF-FY-2122-10017727-3_4   | CCF-001         | FY-2122              | February               | 2022              | 4158.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | CCF             | FY2122        | CCF2122      | Conditions of Funding (Grant) (College) | CofG_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017727 | 10017727 Co Ltd  | CCF-FY-2122-Contract-Provider-10017727-3_4              | 3_4            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Scheduling        | Awaiting Release  | 27283.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 27283.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017727 | CCF-FY-2122-Contract-Provider-10017727-3_4              | 3_4            | FY-2122 | CCF                         | 27283.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 27283.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017727' for FundingType 'CCF' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017727' for FundingType 'CCF' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017727 | 10017727 Co Ltd  | CCF-FY-2122-Contract-Provider-10017727-3_4              | 3_4            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Released          | Released          | 27283.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017727 | CCF-FY-2122-Contract-Provider-10017727-3_4              | 3_4            | FY-2122 | CCF                         | 27283.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017727-3_4              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017727 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017727 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017727 | [ContractNo]       | College Collaboration Fund             | Contract      | Draft          | Awaiting Documentation  | 27283.00      | 1                     | 0                        | 01/04/2021        | 31/03/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | FY2122 | ?               | 10017727 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017727 | [MasterContractNo] | College Collaboration Fund             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/04/2021        | 31/03/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017727 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017727 | [ContractNo]       | [AllocRef_CCF]        | ?                             | 27283.00        | ?             | ?                | 01/04/2021 | 31/03/2022 | CCF           | CCF2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_CCF]  | 1               | 27283.00  | 4628.00  | 0.00     | 0.00     | 5697.00  | 2491.00  | 0.00     | 0.00     | 5168.00  | 0.00     | 5141.00  | 4158.00  | 0.00     | College Collaboration Fund (CCF)                            |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'




    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017727_[ContractNo]_v1.pdf' is created in 'CCF-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017727 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017727 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/04/2021        | 31/03/2022      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017727 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017727 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/04/2021        | 31/03/2022      | ?             |





    # Part 2: Input and release an updated FA then and publish and withdraw contract v2 

    # Populate the stub with CCF (07HEP) data

    # Change the date 
    Given the override date is '01/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017727 | CCF-FY-2122-Contract-Provider-10017727-4_1            | 4_1            | CCF                         | FY-2122            | 27394.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | CCF-FY-2122-10017727-4_1   | 4_1                    | CCF-FY-2122-Contract-Provider-10017727-4_1            | 10017727      | Furth        | 07HEP           | 27394.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | CCF-FY-2122-10017727-4_1   | CCF-001         | 27394.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | CCF-FY-2122-10017727-4_1   | CCF-001         | FY-2122              | April                  | 2021              | 4628.00                   |
    | CCF-FY-2122-10017727-4_1   | CCF-001         | FY-2122              | July                   | 2021              | 5697.00                   |
    | CCF-FY-2122-10017727-4_1   | CCF-001         | FY-2122              | August                 | 2021              | 2491.00                   |
    | CCF-FY-2122-10017727-4_1   | CCF-001         | FY-2122              | November               | 2021              | 5168.00                   |
    | CCF-FY-2122-10017727-4_1   | CCF-001         | FY-2122              | January                | 2022              | 5141.00                   |
    | CCF-FY-2122-10017727-4_1   | CCF-001         | FY-2122              | February               | 2022              | 4269.00                   |





    # Change the date 
    Given the override date is '03/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | CCF             | FY2122        | CCF2122      | Conditions of Funding (Grant) (College) | CofG_College2             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College2 = [CofG_Colleg2e]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017727 | 10017727 Co Ltd  | CCF-FY-2122-Contract-Provider-10017727-4_1              | 4_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Scheduling        | Awaiting Release  | 27394.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College2]   | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 27394.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017727 | CCF-FY-2122-Contract-Provider-10017727-4_1              | 4_1            | FY-2122 | CCF                         | 27394.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup       |
    | [CofG_College2]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College2 = [CofG_College2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 27394.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017727' for FundingType 'CCF' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017727' for FundingType 'CCF' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017727 | 10017727 Co Ltd  | CCF-FY-2122-Contract-Provider-10017727-4_1              | 4_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Released          | Released          | 27394.00    | [ContractNo]  | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College2] | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017727 | CCF-FY-2122-Contract-Provider-10017727-4_1              | 4_1            | FY-2122 | CCF                         | 27394.00    | [CofG_College2] | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017727-4_1              | [ContractNo] | 2               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017727 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017727 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                 | False         | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017727 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |





    # Publish the contract

    # Change the date 
    Given the override date is '07/08/2021'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017727_[ContractNo]_v2.pdf' is created in 'CCF-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017727 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017727 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | False         | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017727 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/04/2021        | 31/03/2022      | ?             |





    # Withdraw the Published Contract version and return the FA to Scheduling\Returned to Scheduling

    # Change the date 
    Given the override date is '09/08/2021'

    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'Test 10017727' by 'FCS2 Test'

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017727 | CCF-FY-2122-Contract-Provider-10017727-4_1              | 4_1            | FY-2122 | CCF                         | 27394.00    | ?               | ?                 | ?                                 |
    | 10017727 | CCF-FY-2122-Contract-Provider-10017727-3_4              | 3_4            | FY-2122 | CCF                         | 27283.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | CCF-FY-2122-Contract-Provider-10017727-3_4              | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo      | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017727 | 10017727 Co Ltd  | CCF-FY-2122-Contract-Provider-10017727-4_1              | 4_1            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Scheduling        | Returned to Scheduling  | 27394.00    | ?               | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017727 | 10017727 Co Ltd  | CCF-FY-2122-Contract-Provider-10017727-3_4              | 3_4            | College Collaboration Fund | FY2122  | Conditions of Funding (Grant) (College)  | CCF                         | CCF2122         | Contract Approved | Contract Approved       | 27283.00    | [ContractNo]    | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College]  | ?          | ?                   |


    # Manual activity ...

    # Initiate Termination. 
    # Approve initiation
    # Complete Termination > Fail


    # Tidy up
    Given the override date is reset

@AcceptanceTest @Manual
@CFS
Scenario: A728 Import and release an NLG2122 FA. Publish and approve. Import and hold an updated FA. Initiate termination. Authorise initiation. Data setup for manual test
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017728'
    And   there is no Funding Allocation data in CRM for UKPRN '10017728'
    And   there is no Contract, Task or Workflow data for UKPRN '10017728'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017728'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017728'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017728' in the Sharepoint 'NLG-2122-Input-Appendices' folder

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
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017728' 
    And   there is no caseload advisor for UKPRN '10017728' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017728 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017728' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017728 Co Ltd' with UKPRN '10017728' and OrgId 'ORG0017728' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017728 | 117728 | 10017728 Co Ltd | 0              | In Administration     | Yes           | AA017728      | ?             | 36 Glencoe Road        | Weybridge              | Surrey                 | ?                      | ?                      | ?                      | KT13 8JY  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017728 |





    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017728 | NLG-AS-2122-Contract-Provider-10017728-1_2            | 1_2            | NLG                         | AS-2122            | 25984.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017728-1_2   | 1_2                    | NLG-AS-2122-Contract-Provider-10017728-1_2            | 10017728      | Furth        | 02IPP           | 25984.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017728-1_2   | NLG-001         | 25984.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017728-1_2   | NLG-001         | FY-2122              | August                 | 2021              | 5079.00                   |
    | NLG-AS-2122-10017728-1_2   | NLG-001         | FY-2122              | October                | 2021              | 2146.00                   |
    | NLG-AS-2122-10017728-1_2   | NLG-001         | FY-2122              | January                | 2022              | 2942.00                   |
    | NLG-AS-2122-10017728-1_2   | NLG-001         | FY-2122              | March                  | 2022              | 5618.00                   |
    | NLG-AS-2122-10017728-1_2   | NLG-001         | FY-2122              | April                  | 2022              | 5591.00                   |
    | NLG-AS-2122-10017728-1_2   | NLG-001         | FY-2122              | June                   | 2022              | 4608.00                   |
 
 
 
 
 
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
    | 10017728 | 10017728 Co Ltd  | NLG-AS-2122-Contract-Provider-10017728-1_2              | 1_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 25984.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG]             | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 25984.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017728 | NLG-AS-2122-Contract-Provider-10017728-1_2              | 1_2            | AS-2122 | NLG                         | 25984.00    | [NLG]           | ?                 | ?                                 |

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
    | Released          | 1               | 25984.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017728' for FundingType 'NLG' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017728' for FundingType 'NLG' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017728 | 10017728 Co Ltd  | NLG-AS-2122-Contract-Provider-10017728-1_2              | 1_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Released          | Released          | 25984.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [NLG]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017728 | NLG-AS-2122-Contract-Provider-10017728-1_2              | 1_2            | AS-2122 | NLG                         | 25984.00    | [NLG]           | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017728-1_2              | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[NLG]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017728 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017728 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017728 | [ContractNo]       | Non-learning Grants                    | Contract      | Draft          | Awaiting Documentation  | 25984.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Non-learning Grant                        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017728 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017728 | [MasterContractNo] | Non-learning Grants                    | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Non-learning Grant                        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017728 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017728 | [ContractNo]       | [AllocRef_NLG]        | ?                             | 25984.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | NLG           | NLG2122             | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_NLG]  | 116             | 25984.00  | 5079.00  | 0.00     | 2146.00  | 0.00     | 0.00     | 2942.00  | 0.00     | 5618.00  | 5591.00  | 0.00     | 4608.00  | 0.00     | Isles of Scilly: Boarding and Accommodation Grant           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '12' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017728_[ContractNo]_v1.pdf' in Sharepoint location 'NLG-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#   And   Sharepoint file '10017728_[ContractNo]_v1.pdf' in 'NLG-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A728.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-04 09:12:35.000 |





    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017728_[ContractNo]_v1.pdf' is created in 'NLG-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017728 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017728 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017728 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017728 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017728 | 10017728 Co Ltd  | NLG-AS-2122-Contract-Provider-10017728-1_2              | 1_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Contract Approved | Contract Approved | 25984.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [NLG]           | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017728 | NLG-AS-2122-Contract-Provider-10017728-1_2              | 1_2            | AS-2122 | NLG                         | 25984.00    | [NLG]           | ContractApproved  | ContractApproved                  |





    # Populate the stub with NLG (02IPP) data

    # Change the date 
    Given the override date is '01/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017728 | NLG-AS-2122-Contract-Provider-10017728-2_2            | 2_2            | NLG                         | AS-2122            | 19280.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NLG-AS-2122-10017728-2_2   | 2_2                    | NLG-AS-2122-Contract-Provider-10017728-2_2            | 10017728      | Furth        | 02IPP           | 19280.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NLG-AS-2122-10017728-2_2   | NLG-001         | 19280.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NLG-AS-2122-10017728-2_2   | NLG-001         | FY-2122              | October                | 2021              | 4192.00                   |
    | NLG-AS-2122-10017728-2_2   | NLG-001         | FY-2122              | December               | 2021              | 5945.00                   |
    | NLG-AS-2122-10017728-2_2   | NLG-001         | FY-2122              | March                  | 2022              | 3626.00                   |
    | NLG-AS-2122-10017728-2_2   | NLG-001         | FY-2122              | July                   | 2022              | 5517.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '02/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | NLG             | AY2122        | NLG2122      | Non-learning Grant                      | NLG2                      |

    # Write the following values to the output window
    And   message 'ReleaseGroup NLG2 = [NLG2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017728 | 10017728 Co Ltd  | NLG-AS-2122-Contract-Provider-10017728-2_2              | 2_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Awaiting Release  | 19280.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [NLG2]            | ?          | ?                   |


    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[NLG2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 19280.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017728 | NLG-AS-2122-Contract-Provider-10017728-2_2              | 2_2            | AS-2122 | NLG                         | 19280.00    | [NLG2]          | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[NLG2]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'

    



    # Put Funding Allocation on hold

    # Change the date
    Given the override date is '06/08/2021'

    When  User 'FCS8 TEST' opts to put the following Funding Allocations on hold
    | FundingId                                               | HoldReason                     | Comments                    |
    | NLG-AS-2122-Contract-Provider-10017728-2_2              | Under Investigation            | Suspected fraud             |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017728 | NLG-AS-2122-Contract-Provider-10017728-2_2              | 2_2            | AS-2122 | NLG                         | 19280.00    | ?               | ?                 | ?                                 |
    | 10017728 | NLG-AS-2122-Contract-Provider-10017728-1_2              | 1_2            | AS-2122 | NLG                         | 25984.00    | [NLG]           | ContractApproved  | ContractApproved                  |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NLG-AS-2122-Contract-Provider-10017728-1_2              | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017728 | 10017728 Co Ltd  | NLG-AS-2122-Contract-Provider-10017728-2_2              | 2_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Scheduling        | Held                    | 19280.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | Under Investigation       | ?               | ?          | ?                   |
    | 10017728 | 10017728 Co Ltd  | NLG-AS-2122-Contract-Provider-10017728-1_2              | 1_2            | Non-learning Grants        | AY2122  | Non-learning Grant                       | NLG                         | NLG2122         | Contract Approved | Contract Approved       | 25984.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [NLG]           | ?          | ?                   |





    # Manual activity ...

    # Initiate Termination. 
    # Approve initiation
    # Complete Termination > Fail


    # Tidy up
    Given the override date is reset

@AcceptanceTest @Manual
@CFS
Scenario: A729 Import and release. Withdraw FA. Release. Publish and Approve contract v1. Import but don't release updated FAs. Data setup for manual test

    # 1. Import 3x FA. Contracting Org (1619) and 2x Delivery Orgs (NMSS and 1416)
    # 2. Withdraw 1x Delivery Org FA (1416)
    # 3. Release Release Group. 
    # 4. Publish and Approve contract v1
    # 5. Import but don't release updated FAs

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017729'
    And   there is no Funding Allocation data in CRM for UKPRN '10017729'
    And   there is no Contract, Task or Workflow data for UKPRN '10017729'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017729'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017729'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017729' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017729' 
    And   there is no caseload advisor for UKPRN '10017729' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017729 | 
    | 10055406 | 
    | 10055628 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017729' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Flint LDC' with UKPRN '10017729' and OrgId 'ORG0017729' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017729 | 117729 | Flint LDC       | 0              | Active                | Yes           | AA017729      | ?             | 1 Friary               | Temple Quay            | Bristol                | ?                      | ?                      | ?                      | BS1 6EA   |
    | 10055406 | 155406 | Wrexham College | 0              | Active                | Yes           | AA055406      | ?             | 80 Lapins Lane         | Kingshill              | ?                      | ?                      | West Malling           | Kent                   | ME19 4LE  |
    | 10055628 | 155628 | Rhyl College    | 0              | Active                | Yes           | AA055628      | ?             | 39 Brimfield Road      | Watts Wood             | ?                      | ?                      | Purfleet               | Essex                  | RM19 1RQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017729 | 
    | 10055406 | 
    | 10055628 | 





    # Part 1: Import 3x FA. Contracting Org (1619) and 2x Delivery Orgs (NMSS and 1416)
    
    # Populate the stub with 1619 (10LAU) data

    # Change the date 
    Given the override date is '01/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017729 | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1     | 1_1            | 1619                        | AS-2122            | 25000.00          |
    | Contracting    | 10017729 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5  | 3_5            | NMSS                        | AY-2122            | 12000.00          |
    | Contracting    | 10017729 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-4_1  | 4_1            | 1416                        | AY-2122            | 13000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017729-1_1  | 1_1                    | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1     | 10017729      | Local        | 10LAU           | 25000.00                  |
    | NMSS-AY-2122-10055406-3_5  | 3_5                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5  | 10055406      | Schoo        | 08SSF           | 12000.00                  |
    | 1416-AY-2122-10055628-4_1  | 4_1                    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-4_1  | 10055628      | Schoo        | 08SSF           | 13000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017729-1_1  | 1619-004        | 25000.00         | Payment         |
    | NMSS-AY-2122-10055406-3_5  | NMSS-002        | 12000.00         | Payment         |
    | 1416-AY-2122-10055628-4_1  | 1416-003        | 13000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017729-1_1  | 1619-004        | FY-2122              | August                 | 2021              | 25000.00                  |
    | NMSS-AY-2122-10055406-3_5  | NMSS-002        | FY-2122              | August                 | 2021              | 12000.00                  |
    | 1416-AY-2122-10055628-4_1  | 1416-003        | FY-2122              | August                 | 2021              | 13000.00                  |
      

    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window
    
    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 50000.00        |
    
    
    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017729 | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1       | 1_1            | AS-2122 | 1619                        | 25000.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017729 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5    | 3_5            | AY-2122 | NMSS                        | 12000.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017729 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-4_1    | 4_1            | AY-2122 | 1416                        | 13000.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017729 | Flint LDC        | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1       | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 25000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017729 | Flint LDC        | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5    | 3_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 12000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017729 | Flint LDC        | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-4_1    | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 13000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |





    # Part 2: Withdraw 1x Delivery Org FA (1416)

    # Change the date
    Given the override date is '24/07/2021'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                             | 
    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-4_1  | 


    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017729 | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1       | 1_1            | AS-2122 | 1619                        | 25000.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017729 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5    | 3_5            | AY-2122 | NMSS                        | 12000.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017729 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-4_1    | 4_1            | AY-2122 | 1416                        | 13000.00    | ?               | Withdrawn         | Withdrawn                         |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017729 | Flint LDC        | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1       | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 25000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017729 | Flint LDC        | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5    | 3_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 12000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017729 | Flint LDC        | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-4_1    | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 13000.00    | ?             | ?                 | CRM Integration  | CRM Deploy CRMDeploy | ?                         | ?               | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 37000.00        |





    # Part 3: Release Release Group

    # Change the date 
    Given the override date is '05/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 37000.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017729' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017729' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

   # Check CRM and PaaS

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017729 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-4_1    | 4_1            | AY-2122 | 1416                        | 13000.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017729 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5    | 3_5            | AY-2122 | NMSS                        | 12000.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017729 | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1       | 1_1            | AS-2122 | 1619                        | 25000.00    | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5    | [ContractNo] | 1               | 0                  | Yes            |
    | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1       | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017729 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017729 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'





    # Part 4: Publish and Approve contract v1
    
    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2021'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017729_[ContractNo]_v1.pdf' is created in 'EDSK-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017729 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017729 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017729 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017729 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 5: Import but don't release updated FAs
    
    # Populate the stub with 1619 (10LAU) data 

    # Change the date 
    Given the override date is '01/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017729 | 1619-AS-2122-Contract-LocalAuthority-10017729-2_1     | 2_1            | 1619                        | AS-2122            | 26000.00          |
    | Contracting    | 10017729 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-4_5  | 4_5            | NMSS                        | AY-2122            | 10000.00          |
    | Contracting    | 10017729 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-5_2  | 5_2            | 1416                        | AY-2122            | 14000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017729-2_1  | 2_1                    | 1619-AS-2122-Contract-LocalAuthority-10017729-2_1     | 10017729      | Local        | 10LAU           | 26000.00                  |
    | NMSS-AY-2122-10055406-4_5  | 4_5                    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-4_5  | 10055406      | Schoo        | 08SSF           | 10000.00                  |
    | 1416-AY-2122-10055628-5_2  | 5_2                    | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-5_2  | 10055628      | Schoo        | 08SSF           | 14000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017729-2_1  | 1619-004        | 26000.00         | Payment         |
    | NMSS-AY-2122-10055406-4_5  | NMSS-002        | 10000.00         | Payment         |
    | 1416-AY-2122-10055628-5_2  | 1416-003        | 14000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017729-2_1  | 1619-004        | FY-2122              | August                 | 2021              | 26000.00                  |
    | NMSS-AY-2122-10055406-4_5  | NMSS-002        | FY-2122              | August                 | 2021              | 10000.00                  |
    | 1416-AY-2122-10055628-5_2  | 1416-003        | FY-2122              | August                 | 2021              | 14000.00                  |





    # Consume stub data
 
    # Change the date 
    Given the override date is '03/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (LA)      | CofG_LA2                  |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA2 = [CofG_LA2]' is written to the Output window
    
    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_LA2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 3               | 50000.00        |


    # Check CRM and PaaS
    
    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017729 | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1       | 1_1            | AS-2122 | 1619                        | 25000.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |
    | 10017729 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5    | 3_5            | AY-2122 | NMSS                        | 12000.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |
    | 10017729 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-4_1    | 4_1            | AY-2122 | 1416                        | 13000.00    | ?               | Withdrawn         | Withdrawn                         |
    #
    | 10017729 | 1619-AS-2122-Contract-LocalAuthority-10017729-2_1       | 2_1            | AS-2122 | 1619                        | 26000.00    | [CofG_LA2]      | ?                 | ?                                 |
    | 10017729 | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-4_5    | 4_5            | AY-2122 | NMSS                        | 10000.00    | [CofG_LA2]      | ?                 | ?                                 |
    | 10017729 | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-5_2    | 5_2            | AY-2122 | 1416                        | 14000.00    | [CofG_LA2]      | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1       | [ContractNo] | 1               | 0                  | Yes            |
    | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5    | [ContractNo] | 1               | 0                  | Yes            |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017729 | Flint LDC        | 1619-AS-2122-Contract-LocalAuthority-10017729-1_1       | 1_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 25000.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017729 | Flint LDC        | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-3_5    | 3_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Contract Approved | Contract Approved       | 12000.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017729 | Flint LDC        | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-4_1    | 4_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 13000.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    #
    | 10017729 | Flint LDC        | 1619-AS-2122-Contract-LocalAuthority-10017729-2_1       | 2_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 26000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA2]      | ?          | ?                   |
    | 10017729 | Flint LDC        | NMSS-AY-2122-Contract-LocalAuthoritySsf-10017729-4_5    | 4_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 10000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA2]      | ?          | ?                   |
    | 10017729 | Flint LDC        | 1416-AY-2122-Contract-LocalAuthoritySsf-10017729-5_2    | 5_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (LA)       | 1416                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 14000.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA2]      | ?          | ?                   |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017729 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017729 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    
    # Manual activity ...

    # Initiate Termination. 
    # Approve initiation
    # Complete Termination > Fail


    # Tidy up
    Given the override date is reset
         
