Feature: ZeroValueFundingLinesA 34859

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A651 Multi-part test of Funding Lines of no interest. EDSK2122 contract built from several 1619 FAs

    # Full details of the following journey are in the Acceptance Criteria of story 34859
    
    # 1.1 Consume 1619 FA v2_2 with null funding lines, and FA v2_2 with null and zero funding lines to supersede FA v2_2
    # 1.2 Withdraw FA v2_2
    # 1.3 Consume 1619 FA v3_1. (A £value line is reduced to £0 and a null line is given a non-zero value)
    # 2.1 Delete draft contract v1 and withdraw FA v3_1
    # 2.2 Consume 1619 FA v4_3. (Adjust lines thus: £value to £0 and £0 to £value). Release RG > Draft contract v1
    # 3.1 Consume 1619 FA v5_2. (Adjust lines thus: £value to £0) > Parked\Awaiting Outcome 
    # 3.2 Publish then withdraw contract v1 to return FA v4_3 to Scheduling
    # 3.3 Withdraw FA v4_3 and auto-unpark FA v5_2 into new Release Group
    # 3.4 Release Release Group and create draft contract v2
    # 3.5 Publish and approve contract v2
    # 4.1 Consume 1619 FA v6_2. (Adjust lines thus: £0 to £value, £value to £0, null to £value). Release RG > Draft contract v3  
    # 4.2 Delete draft contract v3 and withdraw FA v6_2
    # 5.1 Consume 1619 FA v5_1. (Adjust lines thus: £0 to £value, £value to £0, £value up and £value down). Release RG > Draft contract v3


    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017651'
    And   there is no Funding Allocation data in CRM for UKPRN '10017651'
    And   there is no Contract, Task or Workflow data for UKPRN '10017651'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017651'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017651'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017651' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

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
    Given there is no Organisation data in CRM for UKPRN '10017651' 
    And   there is no caseload advisor for UKPRN '10017651' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017651 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017651' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017651 Co Ltd' with UKPRN '10017651' and OrgId 'ORG0017651' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017651 | 117651 | 10017651 Co Ltd | 0              | Active                | Yes           | AA017651      | ?             | 14 Daisy Way           | High Lane              | ?                      | ?                      | Stockport              | Cheshire               | SK6 8EF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017651 |





    # Part 1.1: Consume 1619 FA v1_1 with null funding lines, and FA v2_2 with null and zero funding lines to supersede FA v1_1

    # Populate the stub with 1619 (01GFE) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1           | 1_1            | 1619                        | AS-2122            | 91934.00          |
    | Contracting    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2           | 2_2            | 1619                        | AS-2122            | 88015.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017651-1_1  | 1_1                    | 1619-AS-2122-Contract-Provider-10017651-1_1           | 10017651      | Furth        | 01GFE           | 91934.00                  |
    | 1619-AS-2122-10017651-2_2  | 2_2                    | 1619-AS-2122-Contract-Provider-10017651-2_2           | 10017651      | Furth        | 01GFE           | 88015.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017651-1_1  | 1619-001        | 25810.00         | Payment         |
    | 1619-AS-2122-10017651-1_1  | 1619-002        | 6794.00          | Payment         |
    | 1619-AS-2122-10017651-1_1  | 1619-009        | 22976.00         | Payment         |
    | 1619-AS-2122-10017651-1_1  | 1619-010        | 7675.00          | Payment         |
    | 1619-AS-2122-10017651-1_1  | 1619-008        | 24760.00         | Payment         |
    | 1619-AS-2122-10017651-1_1  | 1619-005        | ?                | Payment         |
    | 1619-AS-2122-10017651-1_1  | 1619-007        | 3919.00          | Payment         |
    | 1619-AS-2122-10017651-1_1  | 1619-011        | ?                | Payment         |
    #
    | 1619-AS-2122-10017651-2_2  | 1619-001        | 25810.00         | Payment         |
    | 1619-AS-2122-10017651-2_2  | 1619-002        | 6794.00          | Payment         |
    | 1619-AS-2122-10017651-2_2  | 1619-009        | 22976.00         | Payment         |
    | 1619-AS-2122-10017651-2_2  | 1619-010        | 7675.00          | Payment         |
    | 1619-AS-2122-10017651-2_2  | 1619-008        | 24760.00         | Payment         |
    | 1619-AS-2122-10017651-2_2  | 1619-005        | ?                | Payment         |
    # Reduce line 007 from £3919 to £0
    | 1619-AS-2122-10017651-2_2  | 1619-007        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-2_2  | 1619-011        | ?                | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017651-1_1  | 1619-001        | FY-2122              | August                 | 2021              | 4413.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-001        | FY-2122              | December               | 2021              | 5994.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-001        | FY-2122              | February               | 2022              | 5252.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-001        | FY-2122              | May                    | 2022              | 4541.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-001        | FY-2122              | July                   | 2022              | 5610.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-002        | FY-2122              | November               | 2021              | 3341.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-002        | FY-2122              | February               | 2022              | 3453.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-009        | FY-2122              | August                 | 2021              | 5892.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-009        | FY-2122              | January                | 2022              | 5422.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-009        | FY-2122              | March                  | 2022              | 2831.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-009        | FY-2122              | April                  | 2022              | 5540.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-009        | FY-2122              | July                   | 2022              | 3291.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-010        | FY-2122              | October                | 2021              | 2630.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-010        | FY-2122              | December               | 2021              | 2843.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-010        | FY-2122              | May                    | 2022              | 2202.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-008        | FY-2122              | September              | 2021              | 5570.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-008        | FY-2122              | October                | 2021              | 4074.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-008        | FY-2122              | January                | 2022              | 4560.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-008        | FY-2122              | March                  | 2022              | 2039.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-008        | FY-2122              | April                  | 2022              | 2664.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-008        | FY-2122              | July                   | 2022              | 5853.00                   |
    | 1619-AS-2122-10017651-1_1  | 1619-007        | FY-2122              | July                   | 2022              | 3919.00                   |
    #
    | 1619-AS-2122-10017651-2_2  | 1619-001        | FY-2122              | August                 | 2021              | 4413.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-001        | FY-2122              | December               | 2021              | 5994.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-001        | FY-2122              | February               | 2022              | 5252.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-001        | FY-2122              | May                    | 2022              | 4541.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-001        | FY-2122              | July                   | 2022              | 5610.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-002        | FY-2122              | November               | 2021              | 3341.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-002        | FY-2122              | February               | 2022              | 3453.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-009        | FY-2122              | August                 | 2021              | 5892.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-009        | FY-2122              | January                | 2022              | 5422.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-009        | FY-2122              | March                  | 2022              | 2831.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-009        | FY-2122              | April                  | 2022              | 5540.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-009        | FY-2122              | July                   | 2022              | 3291.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-010        | FY-2122              | October                | 2021              | 2630.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-010        | FY-2122              | December               | 2021              | 2843.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-010        | FY-2122              | May                    | 2022              | 2202.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-008        | FY-2122              | September              | 2021              | 5570.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-008        | FY-2122              | October                | 2021              | 4074.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-008        | FY-2122              | January                | 2022              | 4560.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-008        | FY-2122              | March                  | 2022              | 2039.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-008        | FY-2122              | April                  | 2022              | 2664.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-008        | FY-2122              | July                   | 2022              | 5853.00                   |
    | 1619-AS-2122-10017651-2_2  | 1619-007        | FY-2122              | July                   | 2022              | 0.00                      |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '04/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |

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
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 88015.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 88015.00        |



    

    # Part 1.2: Withdraw FA v2_2

    # Change the date 
    Given the override date is '06/07/2021'

    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                    | 
    | 1619-AS-2122-Contract-Provider-10017651-2_2  | 

    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |





    # Part 1.3: Consume 1619 FA v3_1. (A £value line is reduced to £0 and a null line is given a non-zero value)

    # Change the date 
    Given the override date is '08/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (01GFE) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1           | 3_1            | 1619                        | AS-2122            | 93255.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017651-3_1  | 3_1                    | 1619-AS-2122-Contract-Provider-10017651-3_1           | 10017651      | Furth        | 01GFE           | 93255.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017651-3_1  | 1619-001        | 25810.00         | Payment         |
    | 1619-AS-2122-10017651-3_1  | 1619-002        | 6794.00          | Payment         |
    | 1619-AS-2122-10017651-3_1  | 1619-009        | 22976.00         | Payment         |
    | 1619-AS-2122-10017651-3_1  | 1619-010        | 7675.00          | Payment         |
    # Reduce line 008 from £24760 to £0
    | 1619-AS-2122-10017651-3_1  | 1619-008        | 0.00             | Payment         |
    # Change line 005 from null to £30000
    | 1619-AS-2122-10017651-3_1  | 1619-005        | 30000.00         | Payment         |
    | 1619-AS-2122-10017651-3_1  | 1619-007        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-3_1  | 1619-011        | ?                | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017651-3_1  | 1619-001        | FY-2122              | August                 | 2021              | 4413.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-001        | FY-2122              | December               | 2021              | 5994.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-001        | FY-2122              | February               | 2022              | 5252.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-001        | FY-2122              | May                    | 2022              | 4541.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-001        | FY-2122              | July                   | 2022              | 5610.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-002        | FY-2122              | November               | 2021              | 3341.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-002        | FY-2122              | February               | 2022              | 3453.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-009        | FY-2122              | August                 | 2021              | 5892.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-009        | FY-2122              | January                | 2022              | 5422.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-009        | FY-2122              | March                  | 2022              | 2831.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-009        | FY-2122              | April                  | 2022              | 5540.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-009        | FY-2122              | July                   | 2022              | 3291.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-010        | FY-2122              | October                | 2021              | 2630.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-010        | FY-2122              | December               | 2021              | 2843.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-010        | FY-2122              | May                    | 2022              | 2202.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-008        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-3_1  | 1619-005        | FY-2122              | November               | 2021              | 5621.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-005        | FY-2122              | January                | 2022              | 8124.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-005        | FY-2122              | March                  | 2022              | 7878.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-005        | FY-2122              | April                  | 2022              | 8377.00                   |
    | 1619-AS-2122-10017651-3_1  | 1619-007        | FY-2122              | July                   | 2022              | 0.00                      |

 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '10/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College2             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College2 = [CofG_College2]' is written to the Output window

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 93255.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 93255.00        |





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '12/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College2]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College2 = [CofG_College2]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College2]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 93255.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017651' for FundingType 'EDSK' and period '2122'

    # Check the CRM Funding Allocations data (J125) {F7} Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released                | 93255.00    | [ContractNo]  | 1                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College2] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | [CofG_College2] | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College2]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017651 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017651 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 93255.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017651 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017651 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017651 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017651 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 93255.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

   # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | [ContractNo]   | [AllocRef_16ED]    | 20              | 25810.00  | 4413.00  | 0.00     | 0.00     | 0.00     | 5994.00  | 0.00     | 5252.00  | 0.00     | 0.00     | 4541.00  | 0.00     | 5610.00  | 16-19 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 19              | 6794.00   | 0.00     | 0.00     | 0.00     | 3341.00  | 0.00     | 0.00     | 3453.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Bursary Funds                                         |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 136             | 22976.00  | 5892.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5422.00  | 0.00     | 2831.00  | 5540.00  | 0.00     | 0.00     | 3291.00  | 16-19 High Value Courses Premium                            |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 125             | 7675.00   | 0.00     | 0.00     | 2630.00  | 0.00     | 2843.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2202.00  | 0.00     | 0.00     | Teacher's Pension Scheme 1619                               |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 914             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 31              | 30000.00  | 0.00     | 0.00     | 0.00     | 5621.00  | 0.00     | 8124.00  | 0.00     | 7878.00  | 8377.00  | 0.00     | 0.00     | 0.00     | 16-19 Free Meals                                            |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 112             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Capacity and Delivery                                 |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 51              | null      |          |          |          |          |          |          |          |          |          |          |          |          | Alternative Completions - Sporting Excellence               |                          |


    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Funding Agreement
    And   the file named '10017651_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017651 Co Ltd UKPRN: 10017651
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £25,810 £4,413.00 £0.00 £0.00 £0.00 £5,994.00 £0.00 £5,252.00 £0.00 £0.00 £4,541.00 £0.00 £5,610.00
    16-19 Bursary Funds £6,794 £0.00 £0.00 £0.00 £3,341.00 £0.00 £0.00 £3,453.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16-19 Free Meals £30,000 £0.00 £0.00 £0.00 £5,621.00 £0.00 £8,124.00 £0.00 £7,878.00 £8,377.00 £0.00 £0.00 £0.00
    Teacher's Pension Scheme 1619 £7,675 £0.00 £0.00 £2,630.00 £0.00 £2,843.00 £0.00 £0.00 £0.00 £0.00 £2,202.00 £0.00 £0.00
    16-19 High Value Courses Premium £22,976 £5,892.00 £0.00 £0.00 £0.00 £0.00 £5,422.00 £0.00 £2,831.00 £5,540.00 £0.00 £0.00 £3,291.00
    Total Funding £93,255 £10,305.00 £0.00 £2,630.00 £8,962.00 £8,837.00 £13,546.00 £8,705.00 £10,709.00 £13,917.00 £6,743.00 £0.00 £8,901.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017651_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A651_v1a.pdf'





    # Part 2.1: Delete draft contract v1 and withdraw FA v3_1

    # Delete draft contract v1

    # Change the date 
    Given the override date is '14/07/2021'
    
    # Trigger WF28 in CRM to issue a delete request against v1 of the contract (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017651 | [ContractNo]   | 1                     | 0                  |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 93255.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |



    # Withdraw FA v3_1

    # Change the date 
    Given the override date is '16/07/2021'
    
    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                    | 
    | 1619-AS-2122-Contract-Provider-10017651-3_1  | 

    # Check that the FA is showing as withdrawn

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 93255.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |





    # Part 2.2: Consume 1619 FA v4_3. (Adjust lines thus £value to £0 and £0 to £value) and release RG > Draft contract v1

    # Change the date 
    Given the override date is '18/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (01GFE) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3           | 4_3            | 1619                        | AS-2122            | 65580.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017651-4_3  | 4_3                    | 1619-AS-2122-Contract-Provider-10017651-4_3           | 10017651      | Furth        | 01GFE           | 65580.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017651-4_3  | 1619-001        | 25810.00         | Payment         |
    | 1619-AS-2122-10017651-4_3  | 1619-002        | 6794.00          | Payment         |
    | 1619-AS-2122-10017651-4_3  | 1619-009        | 22976.00         | Payment         |
    # Adjust line 010 from £7675 to £0
    | 1619-AS-2122-10017651-4_3  | 1619-010        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-4_3  | 1619-008        | 0.00             | Payment         |
    # Adjust line 005 from £30000 to £0
    | 1619-AS-2122-10017651-4_3  | 1619-005        | 0.00             | Payment         |
    # Adjust line 007 from £0 to £10000
    | 1619-AS-2122-10017651-4_3  | 1619-007        | 10000.00         | Payment         |
    | 1619-AS-2122-10017651-4_3  | 1619-011        | ?                | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017651-4_3  | 1619-001        | FY-2122              | August                 | 2021              | 4413.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-001        | FY-2122              | December               | 2021              | 5994.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-001        | FY-2122              | February               | 2022              | 5252.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-001        | FY-2122              | May                    | 2022              | 4541.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-001        | FY-2122              | July                   | 2022              | 5610.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-002        | FY-2122              | November               | 2021              | 3341.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-002        | FY-2122              | February               | 2022              | 3453.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-009        | FY-2122              | August                 | 2021              | 5892.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-009        | FY-2122              | January                | 2022              | 5422.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-009        | FY-2122              | March                  | 2022              | 2831.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-009        | FY-2122              | April                  | 2022              | 5540.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-009        | FY-2122              | July                   | 2022              | 3291.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-010        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-4_3  | 1619-008        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-4_3  | 1619-005        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-4_3  | 1619-007        | FY-2122              | March                  | 2022              | 3478.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-007        | FY-2122              | May                    | 2022              | 4581.00                   |
    | 1619-AS-2122-10017651-4_3  | 1619-007        | FY-2122              | July                   | 2022              | 1941.00                   | 
 
 
 


    # Consume stub data
 
    # Change the date 
    Given the override date is '20/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College3             |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College3 = [CofG_College3]' is written to the Output window

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | AS-2122 | 1619                        | 65580.00    | [CofG_College3] | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release        | 65580.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_College3] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 93255.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 65580.00        |





    # Release the Release Group
 
    # Change the date 
    Given the override date is '22/07/2021'

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College3]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College3 = [CofG_College3]' is written to the Output window
    
    # Check the state of a Release Group (J129)  )
    Then  Release Group '[CofG_College3]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 65580.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017651' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017651' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017651 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017651 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 65580.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017651 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017651 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017651 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017651 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 65580.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | [ContractNo]   | [AllocRef_16ED]    | 20              | 25810.00  | 4413.00  | 0.00     | 0.00     | 0.00     | 5994.00  | 0.00     | 5252.00  | 0.00     | 0.00     | 4541.00  | 0.00     | 5610.00  | 16-19 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 19              | 6794.00   | 0.00     | 0.00     | 0.00     | 3341.00  | 0.00     | 0.00     | 3453.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Bursary Funds                                         |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 136             | 22976.00  | 5892.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5422.00  | 0.00     | 2831.00  | 5540.00  | 0.00     | 0.00     | 3291.00  | 16-19 High Value Courses Premium                            |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 125             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                               |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 914             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 31              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Free Meals                                            |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 112             | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3478.00  | 0.00     | 4581.00  | 0.00     | 1941.00  | 16-19 Capacity and Delivery                                 |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 51              | null      |          |          |          |          |          |          |          |          |          |          |          |          | Alternative Completions - Sporting Excellence               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '48' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Funding Agreement
    And   the file named '10017651_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017651 Co Ltd UKPRN: 10017651
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £25,810 £4,413.00 £0.00 £0.00 £0.00 £5,994.00 £0.00 £5,252.00 £0.00 £0.00 £4,541.00 £0.00 £5,610.00
    16-19 Bursary Funds £6,794 £0.00 £0.00 £0.00 £3,341.00 £0.00 £0.00 £3,453.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16-19 Capacity and Delivery £10,000 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,478.00 £0.00 £4,581.00 £0.00 £1,941.00
    16-19 High Value Courses Premium £22,976 £5,892.00 £0.00 £0.00 £0.00 £0.00 £5,422.00 £0.00 £2,831.00 £5,540.00 £0.00 £0.00 £3,291.00
    Total Funding £65,580 £10,305.00 £0.00 £0.00 £3,341.00 £5,994.00 £5,422.00 £8,705.00 £6,309.00 £5,540.00 £9,122.00 £0.00 £10,842.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017651_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A651_v1b.pdf'





    # Part 3.1: Consume 1619 FA v5_2. (Adjust lines thus: £value to £0, inc £+ and £- to net £0) > Parked\Awaiting Outcome 

    # Change the date 
    Given the override date is '24/07/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (01GFE) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_2           | 5_2            | 1619                        | AS-2122            | 32604.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017651-5_2  | 5_2                    | 1619-AS-2122-Contract-Provider-10017651-5_2           | 10017651      | Furth        | 01GFE           | 32604.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017651-5_2  | 1619-001        | 25810.00         | Payment         |
    | 1619-AS-2122-10017651-5_2  | 1619-002        | 6794.00          | Payment         |
    # Adjust line 009 from £22976 to £0
    | 1619-AS-2122-10017651-5_2  | 1619-009        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-5_2  | 1619-010        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-5_2  | 1619-008        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-5_2  | 1619-005        | 0.00             | Payment         |
    # Adjust line 007 from £10000 to £0
    | 1619-AS-2122-10017651-5_2  | 1619-007        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-5_2  | 1619-011        | ?                | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017651-5_2  | 1619-001        | FY-2122              | August                 | 2021              | 4413.00                   |
    | 1619-AS-2122-10017651-5_2  | 1619-001        | FY-2122              | December               | 2021              | 5994.00                   |
    | 1619-AS-2122-10017651-5_2  | 1619-001        | FY-2122              | February               | 2022              | 5252.00                   |
    | 1619-AS-2122-10017651-5_2  | 1619-001        | FY-2122              | May                    | 2022              | 4541.00                   |
    | 1619-AS-2122-10017651-5_2  | 1619-001        | FY-2122              | July                   | 2022              | 5610.00                   |
    | 1619-AS-2122-10017651-5_2  | 1619-002        | FY-2122              | November               | 2021              | 3341.00                   |
    | 1619-AS-2122-10017651-5_2  | 1619-002        | FY-2122              | February               | 2022              | 3453.00                   |
    | 1619-AS-2122-10017651-5_2  | 1619-009        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-5_2  | 1619-010        | FY-2122              | December               | 2021              | 500.00                    |
    | 1619-AS-2122-10017651-5_2  | 1619-010        | FY-2122              | April                  | 2022              | -500.00                   |
    | 1619-AS-2122-10017651-5_2  | 1619-008        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-5_2  | 1619-005        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-5_2  | 1619-007        | FY-2122              | July                   | 2022              | 0.00                      | 





    # Consume stub data
 
    # Change the date 
    Given the override date is '26/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | AS-2122 | 1619                        | 32604.00    | ?               | Parked            | AwaitingOutcome                   |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | AS-2122 | 1619                        | 65580.00    | [CofG_College3] | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |





    # Part 3.2: Publish then withdraw contract v1 to return FA v4_3 to Scheduling

    # Change the date 
    Given the override date is '28/07/2021'

    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017651_[ContractNo]_v1.pdf' is created in 'EDSK-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017651 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider                     | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |



    # Contract Withdrawal
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'Test A651' by 'FCS2 Test'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017651 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 65580.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 93255.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |





    # Part 3.3: Withdraw FA v4_3 and auto-unpark FA v5_2 into new Release Group

    # Change the date 
    Given the override date is '30/07/2021'
   
    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                    | 
    | 1619-AS-2122-Contract-Provider-10017651-4_3  | 
  
    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | AS-2122 | 1619                        | 65580.00    | ?               | Withdrawn         | Withdrawn                         |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College4             |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | AS-2122 | 1619                        | 32604.00    | [CofG_College4] | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | AS-2122 | 1619                        | 65580.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |





    # Part 3.4 Release the Release Group and create contract v2
 
    # Change the date 
    Given the override date is '02/08/2021'

    # Release Funding Allocations from Contract Control (J128)
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College4]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College4 = [CofG_College4]' is written to the Output window
    
    # Check the state of a Release Group (J129)  
    Then  Release Group '[CofG_College4]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 32604.00        |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released                | 32604.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College4] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 65580.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 93255.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | AS-2122 | 1619                        | 32604.00    | [CofG_College4] | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | AS-2122 | 1619                        | 65580.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017651 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017651' for FundingType 'EDSK' and period '2122'

    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017651 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 32604.00      | 2                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017651 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017651 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017651 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017651 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 32604.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | [ContractNo]   | [AllocRef_16ED]    | 20              | 25810.00  | 4413.00  | 0.00     | 0.00     | 0.00     | 5994.00  | 0.00     | 5252.00  | 0.00     | 0.00     | 4541.00  | 0.00     | 5610.00  | 16-19 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 19              | 6794.00   | 0.00     | 0.00     | 0.00     | 3341.00  | 0.00     | 0.00     | 3453.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Bursary Funds                                         |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 136             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses Premium                            |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 125             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 500.00   | 0.00     | 0.00     | 0.00     | -500.00  | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                               |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 914             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 31              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Free Meals                                            |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 112             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Capacity and Delivery                                 |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 51              | null      |          |          |          |          |          |          |          |          |          |          |          |          | Alternative Completions - Sporting Excellence               |                          |


    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '48' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Funding Agreement
    And   the file named '10017651_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017651 Co Ltd UKPRN: 10017651
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £25,810 £4,413.00 £0.00 £0.00 £0.00 £5,994.00 £0.00 £5,252.00 £0.00 £0.00 £4,541.00 £0.00 £5,610.00
    16-19 Bursary Funds £6,794 £0.00 £0.00 £0.00 £3,341.00 £0.00 £0.00 £3,453.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16-19 Capacity and Delivery £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16-19 High Value Courses Premium £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £32,604 £4,413.00 £0.00 £0.00 £3,341.00 £5,994.00 £0.00 £8,705.00 £0.00 £0.00 £4,541.00 £0.00 £5,610.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017651_[ContractNo]_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A651_v2a.pdf'





    # Part 3.5 Publish and approve contract v2
 
    # Change the date 
    Given the override date is '04/08/2021'

    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017651_[ContractNo]_v2.pdf' is created in 'EDSK-2122-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017651 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider                     | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017651 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 32604.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College4] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 65580.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 93255.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | AS-2122 | 1619                        | 32604.00    | [CofG_College4] | ContractApproved  | ContractApproved                  |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | AS-2122 | 1619                        | 65580.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |





    # Part 4.1: Consume 1619 FA v6_2. (Adjust lines thus: £0 to £value, £value to £0, null to £value). Release RG > Draft contract v3 

    # Change the date 
    Given the override date is '06/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (01GFE) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-6_2           | 6_2            | 1619                        | AS-2122            | 66584.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017651-6_2  | 6_2                    | 1619-AS-2122-Contract-Provider-10017651-6_2           | 10017651      | Furth        | 01GFE           | 66584.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017651-6_2  | 1619-001        | 25810.00         | Payment         |
    # Adjust line 002 from £6794 to £0
    | 1619-AS-2122-10017651-6_2  | 1619-002        | 0.00             | Payment         |
    # Adjust line 009 from £0 to £16528
    | 1619-AS-2122-10017651-6_2  | 1619-009        | 16528.00         | Payment         |
    # Adjust line 010 from £0 to £8612
    | 1619-AS-2122-10017651-6_2  | 1619-010        | 8612.00          | Payment         |
    | 1619-AS-2122-10017651-6_2  | 1619-008        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-6_2  | 1619-005        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-6_2  | 1619-007        | 0.00             | Payment         |
    # Adjust line 011 from null to £15634
    | 1619-AS-2122-10017651-6_2  | 1619-011        | 15634.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017651-6_2  | 1619-001        | FY-2122              | August                 | 2021              | 4413.00                   |
    | 1619-AS-2122-10017651-6_2  | 1619-001        | FY-2122              | December               | 2021              | 5994.00                   |
    | 1619-AS-2122-10017651-6_2  | 1619-001        | FY-2122              | February               | 2022              | 5252.00                   |
    | 1619-AS-2122-10017651-6_2  | 1619-001        | FY-2122              | May                    | 2022              | 4541.00                   |
    | 1619-AS-2122-10017651-6_2  | 1619-001        | FY-2122              | July                   | 2022              | 5610.00                   |
    | 1619-AS-2122-10017651-6_2  | 1619-002        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-6_2  | 1619-009        | FY-2122              | March                  | 2022              | 16528.00                  |
    | 1619-AS-2122-10017651-6_2  | 1619-010        | FY-2122              | December               | 2021              | 8612.00                   |
    | 1619-AS-2122-10017651-6_2  | 1619-008        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-6_2  | 1619-005        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-6_2  | 1619-007        | FY-2122              | July                   | 2022              | 0.00                      | 
    | 1619-AS-2122-10017651-6_2  | 1619-011        | FY-2122              | January                | 2022              | 10000.00                  | 
    | 1619-AS-2122-10017651-6_2  | 1619-011        | FY-2122              | April                  | 2022              | 5634.00                   | 





    # Consume stub data
 
    # Change the date 
    Given the override date is '08/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College5             |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College5]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 66584.00        |
    



    # Release the Release Group

    # Change the date
    Given the override date is '10/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College5]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College5 = [CofG_College5]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College5]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 66584.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017651' for FundingType 'EDSK' and period '2122' 

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017651 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017651 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-6_2             | 6_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released                | 66584.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College5] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 32604.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College4] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 65580.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 93255.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-6_2             | 6_2            | AS-2122 | 1619                        | 66584.00    | [CofG_College5] | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | AS-2122 | 1619                        | 32604.00    | [CofG_College4] | ContractApproved  | ContractApproved                  |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | AS-2122 | 1619                        | 65580.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |


    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017651 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 66584.00      | 3                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017651 Co Ltd  | Active | Document Management Team  | 33980.00               |
    | 10017651 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017651 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017651 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 66584.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 33980.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | [ContractNo]   | [AllocRef_16ED]    | 20              | 25810.00  | 4413.00  | 0.00     | 0.00     | 0.00     | 5994.00  | 0.00     | 5252.00  | 0.00     | 0.00     | 4541.00  | 0.00     | 5610.00  | 16-19 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Bursary Funds                                         |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 136             | 16528.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16528.00 | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses Premium                            |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 125             | 8612.00   | 0.00     | 0.00     | 0.00     | 0.00     | 8612.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                               |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 914             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 31              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Free Meals                                            |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 112             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Capacity and Delivery                                 |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 51              | 15634.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10000.00 | 0.00     | 0.00     | 5634.00  | 0.00     | 0.00     | 0.00     | Alternative Completions - Sporting Excellence               |                          |


    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
     Then  there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Funding Agreement
    And   the file named '10017651_[ContractNo]_v3.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017651 Co Ltd UKPRN: 10017651
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £25,810 £4,413.00 £0.00 £0.00 £0.00 £5,994.00 £0.00 £5,252.00 £0.00 £0.00 £4,541.00 £0.00 £5,610.00
    16-19 Bursary Funds £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16-19 Capacity and Delivery £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Alternative Completions - Sporting Excellence £15,634 £0.00 £0.00 £0.00 £0.00 £0.00 £10,000.00 £0.00 £0.00 £5,634.00 £0.00 £0.00 £0.00
    Teacher's Pension Scheme 1619 £8,612 £0.00 £0.00 £0.00 £0.00 £8,612.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16-19 High Value Courses Premium £16,528 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £16,528.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £66,584 £4,413.00 £0.00 £0.00 £0.00 £14,606.00 £10,000.00 £5,252.00 £16,528.00 £5,634.00 £4,541.00 £0.00 £5,610.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v3
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017651_[ContractNo]_v3.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A651_v3a.pdf'




    # Part 4.2: Delete draft contract v3 and withdraw FA v6_2
    
    # Delete draft contract v1

    # Change the date 
    Given the override date is '12/08/2021'
    
    # Trigger WF28 in CRM to issue a delete request against v1 of the contract (J090)
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017651 | [ContractNo]   | 3                     | 0                  |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-6_2             | 6_2            | AS-2122 | 1619                        | 66584.00    | ?               | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | AS-2122 | 1619                        | 32604.00    | [CofG_College4] | ContractApproved  | ContractApproved                  |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | AS-2122 | 1619                        | 65580.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-6_2             | 6_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Returned to Scheduling  | 66584.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 32604.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College4] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 65580.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 93255.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |

    # Check the CONTRACT version, status and dates in CRM {F6}  (Draft v3 has gone)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017651 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |




    # Withdraw FA v6_2

    # Change the date 
    Given the override date is '14/08/2021'
    
    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                    | 
    | 1619-AS-2122-Contract-Provider-10017651-6_2  | 

    # Check that the FA is showing as withdrawn

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-6_2             | 6_2            | AS-2122 | 1619                        | 66584.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | AS-2122 | 1619                        | 32604.00    | [CofG_College4] | ContractApproved  | ContractApproved                  |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | AS-2122 | 1619                        | 65580.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-6_2             | 6_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 66584.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 32604.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College4] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 65580.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 93255.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |





    # Part 5.1: Consume 1619 FA v5_1. (Adjust lines thus: £0 to £value, £value to £0, £value up and £value down). Release RG > Draft contract v3

    # Change the date 
    Given the override date is '16/08/2021'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Populate the stub with 1619 (01GFE) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_1           | 5_1            | 1619                        | AS-2122            | 50000.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017651-5_1  | 5_1                    | 1619-AS-2122-Contract-Provider-10017651-5_1           | 10017651      | Furth        | 01GFE           | 50000.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    # Adjust line 001 from £25810 to £45000
    | 1619-AS-2122-10017651-5_1  | 1619-001        | 45000.00         | Payment         |
    # Adjust line 002 from £0 to £5000
    | 1619-AS-2122-10017651-5_1  | 1619-002        | 5000.00          | Payment         |
    # Adjust line 009 from £16528 to £0
    | 1619-AS-2122-10017651-5_1  | 1619-009        | 0.00             | Payment         |
    # Adjust line 010 from £8612 to £0
    | 1619-AS-2122-10017651-5_1  | 1619-010        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-5_1  | 1619-008        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-5_1  | 1619-005        | 0.00             | Payment         |
    | 1619-AS-2122-10017651-5_1  | 1619-007        | 0.00             | Payment         |
    # Adjust line 011 from £15634 to £0
    | 1619-AS-2122-10017651-5_1  | 1619-011        | 0.00             | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017651-5_1  | 1619-001        | FY-2122              | August                 | 2021              | 45000.00                  |
    | 1619-AS-2122-10017651-5_1  | 1619-002        | FY-2122              | July                   | 2022              | 5000.00                   |
    | 1619-AS-2122-10017651-5_1  | 1619-009        | FY-2122              | March                  | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-5_1  | 1619-010        | FY-2122              | December               | 2021              | 0.00                      |
    | 1619-AS-2122-10017651-5_1  | 1619-008        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-5_1  | 1619-005        | FY-2122              | July                   | 2022              | 0.00                      |
    | 1619-AS-2122-10017651-5_1  | 1619-007        | FY-2122              | July                   | 2022              | 0.00                      | 
    | 1619-AS-2122-10017651-5_1  | 1619-011        | FY-2122              | January                | 2022              | 0.00                      | 





    # Consume stub data
 
    # Change the date 
    Given the override date is '18/08/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College6             |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College6]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 50000.00        |
    



    # Release the Release Group

    # Change the date
    Given the override date is '20/08/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College6]   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College6 = [CofG_College6]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College6]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 50000.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017651' for FundingType 'EDSK' and period '2122' 

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_1             | 5_1            | AS-2122 | 1619                        | 50000.00    | [CofG_College6] | ?                 | ?                                 |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-6_2             | 6_2            | AS-2122 | 1619                        | 66584.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | AS-2122 | 1619                        | 32604.00    | [CofG_College4] | ContractApproved  | ContractApproved                  |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | AS-2122 | 1619                        | 65580.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | AS-2122 | 1619                        | 93255.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | AS-2122 | 1619                        | 88015.00    | ?               | Withdrawn         | Withdrawn                         |
    | 10017651 | 1619-AS-2122-Contract-Provider-10017651-1_1             | 1_1            | AS-2122 | 1619                        | 91934.00    | ?               | Discarded         | Superseded                        |

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-5_1             | 5_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released                | 50000.00    | [ContractNo]  | 3                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College6] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-6_2             | 6_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 66584.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-5_2             | 5_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved       | 32604.00    | [ContractNo]  | 2                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | [CofG_College4] | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-4_3             | 4_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 65580.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-3_1             | 3_1            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 93255.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |
    | 10017651 | 10017651 Co Ltd  | 1619-AS-2122-Contract-Provider-10017651-2_2             | 2_2            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Withdrawn         | Withdrawn               | 88015.00    | ?             | ?                 | CRM Integration  | CRMDeploy CRMDeploy  | ?                         | ?               | ?          | ?                   |

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017651 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017651 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017651 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017651 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 50000.00      | 3                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017651 Co Ltd  | Active | Document Management Team  | 17396.00               |
    | 10017651 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017651 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017651 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 50000.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 17396.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                             | DeliverableDescription   | 
    | [ContractNo]   | [AllocRef_16ED]    | 20              | 45000.00  | 45000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Programme Funding                                     |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 19              | 5000.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5000.00  | 16-19 Bursary Funds                                         |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 136             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses Premium                            |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 125             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                               |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 914             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Advanced Maths Premium                                |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 31              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Free Meals                                            |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 112             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 Capacity and Delivery                                 |                          |
 #  | [ContractNo]   | [AllocRef_16ED]    | 51              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sporting Excellence               |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '48' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Funding Agreement
    And   the file named '10017651_[ContractNo]_v3.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017651 Co Ltd UKPRN: 10017651
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £45,000 £45,000.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16-19 Bursary Funds £5,000 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,000.00
    16-19 Capacity and Delivery £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16-19 High Value Courses Premium £0 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £50,000 £45,000.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,000.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v3
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10017651_[ContractNo]_v3.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A651_v3b.pdf'


    # Tidy Up
    Given the override date is reset


