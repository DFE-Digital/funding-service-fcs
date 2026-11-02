Feature: ManualDataSetupForPoP 26458

@AcceptanceTest @Withdrawn20211216
Scenario: A098 Bulk create a new EDSK AEBC-ASCL1920 PoP contract and approve it before the contract start date. Check CRM financials
    Given there are no allocations marked as Under Termination for UKPRN '10017098' 
    And   there are no terminated or closed allocations for UKPRN '10017098' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017098' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017098' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL1920     |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017098' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017098 Co Ltd' with UKPRN '10017098' and OrgId 'ORG0017098' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017098' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017098 | 117098 | 10017098 Co Ltd | 0              | Active                | Yes           | AA017098      | ?             | 9 Westbourne Close     | Wheatlands Estate      | ?                      | ?                      | Heston                 | Middlesex              | TW5 0SA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017098 |




    # Change the date
    Given the override date is '22/03/2019'

    # Bulk file
    And   there are no files prefixed '10017098' in the Sharepoint 'NCS-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 23042020083340 v3_A098' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 1920 23042020083340 v3_A098' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 23042020083340 v3_A098' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 23042020083340 v3_A098' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 23042020083340 v3_A098.xlsx' exists in the Datafiles folder and UKPRN '10017098' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017098' for FundingType 'EDSK' and period '1920' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017098' for FundingType 'EDSK' and period '1920'
	And   message 'Master is [MasterContractNo], Contract is [ContractNo] and AllocRef is [AllocRef_AECA]' is written to the Output window

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017098 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017098 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
#   And   there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
    And   there are '60' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_AECA] | 2371130          | Jul-20 | Profile        |




	# Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | [ContractNo]   | [AllocRef_AECA]    | 1               | 94886.00  | 5202.00  | 5373.00  | 10702.00 | 6391.00  | 7645.00  | 7613.00  | 9821.00  | 11147.00 | 9279.00  | 6933.00  | 3908.00  | 10872.00 | 
    | [ContractNo]   | [AllocRef_AECA]    | 2               | 53255.00  | 5048.00  | 3297.00  | 6439.00  | 4963.00  | 3552.00  | 5675.00  | 7256.00  | 4623.00  | 4571.00  | 2617.00  | 526.00   | 4688.00  | 
    | [ContractNo]   | [AllocRef_AECA]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 5               | 41631.00  | 154.00   | 2076.00  | 4263.00  | 1428.00  | 4093.00  | 1938.00  | 2565.00  | 6524.00  | 4708.00  | 4316.00  | 3382.00  | 6184.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | [ContractNo]   | [AllocRef_AECA]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 2               | 53255.00  | 5048.00  | 3297.00  | 6439.00  | 4963.00  | 3552.00  | 5675.00  | 7256.00  | 4623.00  | 4571.00  | 2617.00  | 526.00   | 4688.00  | 
    | [ContractNo]   | [AllocRef_AECA]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 5               | 41631.00  | 154.00   | 2076.00  | 4263.00  | 1428.00  | 4093.00  | 1938.00  | 2565.00  | 6524.00  | 4708.00  | 4316.00  | 3382.00  | 6184.00  | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | [ContractNo]   | [AllocRef_AECA]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 2               | 0.00      | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AECA]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 5               | 0.00      | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | [ContractNo]   | [AllocRef_AECA]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 2               | 53255.00  | 5048.00  | 3297.00  | 6439.00  | 4963.00  | 3552.00  | 5675.00  | 7256.00  | 4623.00  | 4571.00  | 2617.00  | 526.00   | 4688.00  | 
    | [ContractNo]   | [AllocRef_AECA]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AECA]    | 5               | 41631.00  | 154.00   | 2076.00  | 4263.00  | 1428.00  | 4093.00  | 1938.00  | 2565.00  | 6524.00  | 4708.00  | 4316.00  | 3382.00  | 6184.00  | 


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20211216
Scenario: A099 Manual Test - Create and approve a new NCS-C1920 PoP contract before the contract start date
    Given there are no allocations marked as Under Termination for UKPRN '10017099' 
    And   there are no terminated or closed allocations for UKPRN '10017099' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017099' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017099' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C1920         |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017099' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017099 Co Ltd' with UKPRN '10017099' and OrgId 'ORG0017099' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017099' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017099 | 117099 | 10017099 Co Ltd | 0              | Active                | Yes           | AA017099      | ?             | 2 Westbourne House     | Wheatlands Estate      | ?                      | ?                      | Heston                 | Middlesex              | TW5 0SA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017099 |




    # Change the date
    Given the override date is '22/03/2019'

    # Bulk file
    And   there are no files prefixed '10017099' in the Sharepoint 'NCS-1920-Input-Appendices' folder
    And   there are no files prefixed 'NCS FY 1920 22042020153526 v3_A099' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NCS FY 1920 22042020153526 v3_A099' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NCS FY 1920 22042020153526 v3_A099' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS FY 1920 22042020153526 v3_A099' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS FY 1920 22042020153526 v3_A099.xlsx' exists in the Datafiles folder and UKPRN '10017099' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017099' for FundingType 'NCS' and period '1920' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017099' for FundingType 'NCS' and period '1920'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017099 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2019        | 31/03/2020      | ?             |
    | 10017099 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2019        | 31/03/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
	And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_NCSC] | 2305310          | Mar-20 | Reconciliation |




	# Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | [ContractNo]   | [AllocRef_NCSC]    | 1               | 93515.00  | 7908.00  | 13613.00 | 9030.00  | 2969.00  | 4986.00  | 9844.00  | 9117.00  | 8978.00  | 1813.00  | 8146.00  | 5006.00  | 12105.00 | 
    | [ContractNo]   | [AllocRef_NCSC]    | 2               | 37252.00  | 2261.00  | 4218.00  | 3298.00  | 2419.00  | 3742.00  | 4726.00  | 3087.00  | 3054.00  | 523.00   | 4172.00  | 1812.00  | 3940.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 3               | 56263.00  | 5647.00  | 9395.00  | 5732.00  | 550.00   | 1244.00  | 5118.00  | 6030.00  | 5924.00  | 1290.00  | 3974.00  | 3194.00  | 8165.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 4               | 25507.00  | 1548.00  | 4734.00  | 1442.00  | 100.00   | 490.00   | 2956.00  | 1825.00  | 1581.00  | 999.00   | 2744.00  | 2460.00  | 4628.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 5               | 30756.00  | 4099.00  | 4661.00  | 4290.00  | 450.00   | 754.00   | 2162.00  | 4205.00  | 4343.00  | 291.00   | 1230.00  | 734.00   | 3537.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VOLUMES in CRM on the latest approved contract
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | [ContractNo]   | [AllocRef_NCSC]    | 1               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 2               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 3               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 4               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 5               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 6               | 1725      | 123      | 148      | 222      | 200      | 159      | 81       | 115      | 118      | 111      | 130      | 72       | 246      | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | [ContractNo]   | [AllocRef_NCSC]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | [ContractNo]   | [AllocRef_NCSC]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20211216
Scenario: A100 Create a new EDSK 1619ED1920 PoP contract and approve it before the contract start date. Bulk amend and approve mid contract. Non-financial amendment. Check CRM financials
    Given there are no allocations marked as Under Termination for UKPRN '10017100' 
    And   there are no terminated or closed allocations for UKPRN '10017100' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017100' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017100' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16ED-100      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16ED-100      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 1619ED1920        |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017100' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017100 Co Ltd' with UKPRN '10017100' and OrgId 'ORG0017100' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017100' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017100 | 117100 | 10017100 Co Ltd | 0              | Active                | Yes           | AA017100      | ?             | 74 Warwick Road        | Kenilworth             | Warwickshire           | ?                      | ?                      | ?                      | CV8 1HL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017100 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription    | ContractType                         | Period | CRMIntent    | OrgId      |
    | 10017100 | 10017100 Co Ltd      | ESFA-100             | EDSK-100       | 1                     | 01/08/2019        | 31/07/2020      | 19660.92      |                        | Conditions of Funding (Grant) (HEI)  | 1920   | New          | ORG0017100 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017100 | EDSK-100       | 16ED-100      | 1619ED            | 1619ED1920              | AY                      | 01/08/2019          | 31/07/2020        | 8324.32         |             |            |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                   | CRMIntent    | DeliveryOrg |
    | 10017100 | EDSK-100       | 16ED-100      | 18              | 0                     | 4735.51   | 3118.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1616.69  | 0.00     | 0.00     | 0.00     | Maintained Special SSF Bursary Support   | New          |             | 
    | 10017100 | EDSK-100       | 16ED-100      | 47              | 0                     | 2548.73   | 0.00     | 0.00     | 851.09   | 848.06   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 849.58   | SSF Free Meals                           | New          |             | 
    | 10017100 | EDSK-100       | 16ED-100      | 103             | 0                     | 1040.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1040.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Forensic Unit                            | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-100' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-100'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-100' and actual ContractNumber 'EDSK-100'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-100' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017100 | EDSK-100           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017100 | ESFA-100           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'EDSK-100'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16ED-100      | 2430670          | Jul-20 | Profile        |




    # Change the date
    Given the override date is '23/12/2019'

    # Bulk file to amend the contract, adding deliverable 932. No other change
    And   there are no files prefixed '10017100' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 23042020135802 v3_A100' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 1920 23042020135802 v3_A100' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 23042020135802 v3_A100' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 23042020135802 v3_A100' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 23042020135802 v3_A100.xlsx' exists in the Datafiles folder and UKPRN '10017100' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-100' is in a state of 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-100'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-100' and actual ContractNumber 'EDSK-100'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-100' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017100 | EDSK-100           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017100 | EDSK-100           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017100 | ESFA-100           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-100'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16ED-100      | 2430670          | Jul-20 | Profile        |


    # Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-100       | 16ED-100           | 18              | 4735.51   | 3118.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1616.69  | 0.00     | 0.00     | 0.00     | 
    | EDSK-100       | 16ED-100           | 47              | 2548.73   | 0.00     | 0.00     | 851.09   | 848.06   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 849.58   | 
    | EDSK-100       | 16ED-100           | 103             | 1040.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1040.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-100       | 16ED-100           | 932             | 17349.19  | 2923.11  | 3040.80  | 0.00     | 290.10   | 0.00     | 4536.50  | 2955.83  | 0.00     | 3602.85  | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-100       | 16ED-100           | 18              | 4735.51   | 3118.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1616.69  | 0.00     | 0.00     | 0.00     | 
    | EDSK-100       | 16ED-100           | 47              | 2548.73   | 0.00     | 0.00     | 851.09   | 848.06   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 849.58   | 
    | EDSK-100       | 16ED-100           | 103             | 1040.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1040.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-100       | 16ED-100           | 932             | 11095.18  | ?        | ?        | ?        | ?        | ?        | 4536.50  | 2955.83  | 0.00     | 3602.85  | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-100       | 16ED-100           | 18              | 0.00      | 0.00     | ?        | ?        | ?        | ?        | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-100       | 16ED-100           | 47              | 0.00      | 0.00     | ?        | ?        | ?        | ?        | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-100       | 16ED-100           | 103             | 0.00      | 0.00     | ?        | ?        | ?        | ?        | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-100       | 16ED-100           | 932             | 6254.01   | ?        | ?        | ?        | ?        | ?        | 6254.01  | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-100       | 16ED-100           | 18              | 4735.51   | 3118.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1616.69  | 0.00     | 0.00     | 0.00     | 
    | EDSK-100       | 16ED-100           | 47              | 2548.73   | 0.00     | 0.00     | 851.09   | 848.06   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 849.58   | 
    | EDSK-100       | 16ED-100           | 103             | 1040.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1040.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-100       | 16ED-100           | 932             | 17349.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10790.51 | 2955.83  | 0.00     | 3602.85  | 0.00     | 0.00     | 0.00     | 




    # Change the date
    Given the override date is '23/02/2020'

    # Issue a non-financial NOTIFICATION amendment on v2 to create v3
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-100' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017100 | EDSK-100           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Notification  |
    | 10017100 | EDSK-100           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017100 | EDSK-100           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017100 | ESFA-100           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Update the contract from 'Awaiting Documentation' to 'Internally Approved'
    Given the contract sub-status is updated to 'Internally Approved' on the latest version of contract 'EDSK-100'

	# Put a dummy file in the output folder in Sharepoint
    And  a file with filename '10017100_EDSK-100_v3.pdf' is created in 'EDSK-1920-Output-Documents for Publication'

    # Then manually update contract to 'Published to Provider' and it should auto-approve


	# Tidy Up
	And   the override date is reset
	    
@AcceptanceTest @Withdrawn20211216
Scenario: A101 Process a Final 1819 Funding Claim against an AEB contract with AEB-LS1819 (PoP) and AEB-TOL1819 (PoA) allocations. Amend and approve contract manually then check PoP has not been recalculated
    Given there is no Contract, Task or Workflow data for UKPRN '10017101' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBL-101      |
    | AEBT-101      |

    # Cleardown DEDs and PaaS
    And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Final         | 1819   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017101 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEBL-101      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017101' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017101 Co Ltd' with UKPRN '10017101' and OrgId 'ORG0017101' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017101' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017101 | 117101 | 10017101 Co Ltd | 0              | Provider Under Change | Yes           | AA017101      | ?             | 9 St John's Gardens    | Moulsham Street        | ?                      | ?                      | Chelmsford             | Essex                  | CM2 0JD   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017101 |




    # Change the date
    Given the override date is '01/10/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017101 | 10017101 Co Ltd      | ESFA-101             | AEBP-101       | 1                     | 01/11/2018        | 31/07/2019      | 28311.00      |                                | Contract for Services | 1819   | New          | ORG0017101 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName   | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017101 | AEBP-101       | AEBL-101      | AEB-LS            | AEB-LS1819              | AY                      | 01/11/2018          | 31/07/2019        | 13312.00        |           |            |                         | New          |             |
    | 10017101 | AEBP-101       | AEBT-101      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/11/2018          | 31/07/2019        | 14999.00        |           |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017101 | AEBP-101       | AEBL-101      | 1               | 0                     | 13312.00  | 977.00   | 320.00   | 1308.00  | 2045.00  | 819.00   | 795.00   | 3586.00  | 2613.00  | 849.00   | Adult Education Budget - Learner Support                        | New          |             |
    | 10017101 | AEBP-101       | AEBT-101      | 1               | 0                     | 14999.00  | 3593.00  | 786.00   | 1805.00  | 485.00   | 1725.00  | 722.00   | 1014.00  | 2857.00  | 2012.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-101' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-101' and actual ContractNumber 'AEBP-101'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-101' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017101 | AEBP-101           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2018        | 31/07/2019      | ?             |
    | 10017101 | ESFA-101           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '63' deliverable period rows in CRM linked to the latest version of contract 'AEBP-101'



    # Change the date
    Given the override date is '22/09/2019'

    #Set up claim data from DC for a 'Final'
    And   funding claim data is present in the DEDS stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017101     | 10017101 | 1                  | Final         | AY             | 1819   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017101     | 10017101 | 1                  | Final         | AY             | 1819   | AEBL-101      | AEB-LS1819              |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017101     | 10017101 | 1                  | Final         | AY             | 1819   | AEBL-101      | 2               | 3706.47     | 72.76         | 20.08           | 3799.31    |
    | ORG0017101     | 10017101 | 1                  | Final         | AY             | 1819   | AEBL-101      | 3               | 5120.14     | 73.30         | 11.94           | 5205.38    |
    | ORG0017101     | 10017101 | 1                  | Final         | AY             | 1819   | AEBL-101      | 4               | 843.79      | 11.19         | 11.26           | 866.24     |
    | ORG0017101     | 10017101 | 1                  | Final         | AY             | 1819   | AEBL-101      | 5               | 2155.55     | 54.47         | 23.36           | 2233.38    |

    When  data is retrieved from the DEDS stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017101 | 1819          | Final            | AEB-LS1819          | 1                  | 13312.00     | 12104.31     | -1207.69                    | -1207.69            | 12104.31         | 0.00            | 12104.31                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017101 | 1819          | Final            | AEB-LS1819          | AEBL-101      | 13312.00     | 12104.31     | -1207.69                    | -1207.69            | 12104.31         | 0.00            | ?                     | 12104.31                 | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017101 | 1819          | Final            | AEB-LS1819          | AEBL-101      | AEB-LS1819           | 2               | 19+ Hardship                                           | 0.00         | 3799.31      |
    | 10017101 | 1819          | Final            | AEB-LS1819          | AEBL-101      | AEB-LS1819           | 3               | 20+ Childcare                                          | 0.00         | 5205.38      |
    | 10017101 | 1819          | Final            | AEB-LS1819          | AEBL-101      | AEB-LS1819           | 4               | Residential Access Fund                                | 0.00         | 866.24       |
    | 10017101 | 1819          | Final            | AEB-LS1819          | AEBL-101      | AEB-LS1819           | 5               | Administration Expenditure                             | 0.00         | 2233.38      |




    # Change the date
    Given the override date is '26/09/2019'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017101 | 1819          | Final            | AEB-LS1819          | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017101 | 1819          | Final            | AEB-LS1819          | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017101 | 1819          | Final            | AEB-LS1819          | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |  
    | 10017101 | AEBL-101         | 1819   | Final         | Adult Education Budget - Learner Support 18/19              | 13312.00     | 12104.31     | -1207.69                    | -1207.69                 | 12104.31           | ?               | ?                     | 12104.31                 |

	# Check that the deliverable period count has increased from 63 to 64 (extra period for AEBL-101 for Oct 19)
    And   there are '64' deliverable period rows in CRM linked to the latest version of contract 'AEBP-101'

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-101       | AEBT-101        | 1               | 14999.00 | 3593.00  | 786.00   | 1805.00  | 485.00   | 1725.00  | 722.00   | 1014.00  | 2857.00  | 2012.00  | 

    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Oct-19   |
    | AEBP-101       | AEBL-101        | 1               | 13312.00 | 977.00   | 320.00   | 1308.00  | 2045.00  | 819.00   | 795.00   | 3586.00  | 2613.00  | 849.00   | ?        | 

	# Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Oct-19   |
    | AEBP-101       | AEBL-101        | 1               | 13312.00 | 977.00   | 320.00   | 1308.00  | 2045.00  | 819.00   | 795.00   | 3586.00  | 2613.00  | 849.00   | 0.00     | 

	# Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Oct-19   |
    | AEBP-101       | AEBL-101        | 1               | -1207.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1207.69 | 

	# Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Oct-19   |
    | AEBP-101       | AEBL-101        | 1               | 12104.31 | 977.00   | 320.00   | 1308.00  | 2045.00  | 819.00   | 795.00   | 3586.00  | 2613.00  | 849.00   | -1207.69 | 

  