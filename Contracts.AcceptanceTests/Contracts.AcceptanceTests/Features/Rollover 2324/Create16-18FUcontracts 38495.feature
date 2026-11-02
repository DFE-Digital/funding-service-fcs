Feature: Create16-18FUcontracts 38495

@AcceptanceTest @Withdrawn20251024
Scenario: A011 Bulk load a new 16-18FU2324 contract. Publish and approve. Check docs, CRM, PaaS and feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017011' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017011' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2324       |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 2430670        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017011'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017011' 
    And   there is no caseload advisor for UKPRN '10017011' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017011 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017011' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017011 Co Ltd' with UKPRN '10017011' and OrgId 'ORG0017011' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017011 | 117011 | 10017011 Co Ltd | 0              | Active                | Yes           | AA017011      | ?             | 241 High Street        | ?                      | ?                      | ?                      | Waltham Cross          | Hertfordshire          | EN8 7BE   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017011 |





    # Change the date
    Given the override date is '01/03/2023'

    # Bulk file with a New intent
    And   there are no files prefixed '10017011' in the Sharepoint '16-18FU-2324-Input-Appendices' folder
    And   there are no files prefixed '16-18FU FY 2324 31012023175208 v3_A011' in the Sharepoint 'Input' folder
    And   there are no files prefixed '16-18FU FY 2324 31012023175208 v3_A011' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '16-18FU FY 2324 31012023175208 v3_A011' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '16-18FU FY 2324 31012023175208 v3_A011' in the Sharepoint 'Reports' folder
    And   spreadsheet '16-18FU FY 2324 31012023175208 v3_A011.xlsx' exists in the Datafiles folder and UKPRN '10017011' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017011' for FundingType '16-18FU' and period '2324' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017011' for FundingType '16-18FU' and period '2324'

    # Check the contents of the Appendices
    Then  the file named '10017011_[ContractNo]_v1.pdf' in Sharepoint location '16-18FU-2324-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017011 Co Ltd UKPRN: 10017011
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2023 End Date: 31/03/2024
    Contract Ref: [AllocRef_16FU]
    Cash (£) Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
    16-18 Education at an Adolescent Forensic Unit £49,465 £5,306 £4,647 £2,896 £6,038 £4,562 £3,151 £5,274 £6,855 £4,223 £4,170 £2,217 £126
    Total Funding £49,465 £5,306 £4,647 £2,896 £6,038 £4,562 £3,151 £5,274 £6,855 £4,223 £4,170 £2,217 £126
    16-18 Education at an Adolescent Forensic Unit – [AllocRef_16FU] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Contract is now at 'Draft\Awaiting Documentation'

    # Copy a named Sharepoint file into Datafiles\Downloads with a different name
    And   Sharepoint file '10017011_[ContractNo]_v1.pdf' in '16-18FU-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A011.pdf'


   
   

    # Change the date
    Given the override date is '02/03/2023'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017011 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/04/2023        | 31/03/2024      | ?             |
    | 10017011 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2023        | 31/03/2024      | ?             |

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017011 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2023        | 31/03/2024      | ?             |
    | 10017011 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2023        | 31/03/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_16FU] | 2430670          | Mar-24 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                 | DeliverableDescription |
    | 10017011 | [ContractNo]   | 1               | [AllocRef_16FU] | 1               | 0                     | 49465.00     | 0             | 0        | 16-18 Education at an Adolescent Forensic Unit  | ?                      |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed




    # Check financials

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   |
    | [ContractNo]   | [AllocRef_16FU]    | 1               | 49465.00  | 5306.00  | 4647.00  | 2896.00  | 6038.00  | 4562.00  | 3151.00  | 5274.00  | 6855.00  | 4223.00  | 4170.00  | 2217.00  | 126.00   | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   |
    | [ContractNo]   | [AllocRef_16FU]    | 1               | 49465.00  | 5306.00  | 4647.00  | 2896.00  | 6038.00  | 4562.00  | 3151.00  | 5274.00  | 6855.00  | 4223.00  | 4170.00  | 2217.00  | 126.00   | 




    # Check ADP feed

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202304 | 5306.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202305 | 4647.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202306 | 2896.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202307 | 6038.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202308 | 4562.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202309 | 3151.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202310 | 5274.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202311 | 6855.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202312 | 4223.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202401 | 4170.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202402 | 2217.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_16FU]  | 1               | 202403 | 126.00       | 0             |


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Complete
Scenario: A012 Create a new 16-18FU2324 contract. Approve late. Payment Batch with Balancing amt. Check financials
    Given there are no allocations marked as Under Termination for UKPRN '10017012' 
    And   there are no terminated or closed allocations for UKPRN '10017012' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017012' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017012' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017012' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-012      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-012      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2324       |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 2430670        |


    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 1618FU-012     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017012'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017012' 
    And   there is no caseload advisor for UKPRN '10017012' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017012 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017012' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017012 Co Ltd' with UKPRN '10017012' and OrgId 'ORG0017012' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017012 | 117012 | 10017012 Co Ltd | 0              | In Administration     | Yes           | AA017012      | ?             | 23 The Landway         | Kemsing                | Kent                   | ?                      | ?                      | ?                      | TN15 6TG  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017012 |





    # Change the date
    Given the override date is '01/03/2023'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '1618FU-012'
    And   there are no details in ContractManagement.CreatedContract for '1618FU-012'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017012 | 10017012 Co Ltd      | ESFA-012             | 1618FU-012     | 1                     | 01/04/2023        | 31/03/2024      | 6247.00       |                                       | Contract for Services                      | 2324   | New          | ORG0017012 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017012 | 1618FU-012     | 16FU-012      | 16-18FU           | 16-18FU2324             | FY                      | 01/04/2023          | 31/03/2024        | 6247.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10017012 | 1618FU-012     | 16FU-012      | 1               | 0                     | 6247.00   | 0.00     | 0.00     | 1590.00  | 0.00     | 0.00     | 1407.00  | 0.00     | 0.00     | 973.00   | 0.00     | 0.00     | 2277.00  | 16-18 Education at an Adolescent Forensic Unit                                  | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'





    # Publish the contract
    
    # Change the date
    Given the override date is '08/03/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '1618FU-012'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017012 | 1618FU-012         | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/04/2023        | 31/03/2024      | ?             |
    | 10017012 | ESFA-012           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2023        | 31/03/2024      | ?             |

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'





    # Approve the contract late
    
    # Change the date
    Given the override date is '28/06/2023'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-012' and ContractNumber '1618FU-012' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '1618FU-012' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017012 | 1618FU-012         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2023        | 31/03/2024      | ?             |
    | 10017012 | ESFA-012           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2023        | 31/03/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '1618FU-012' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-012'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16FU-012        | 2430670          | Mar-24 | Profile        |



    # Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   |
    | 1618FU-012     | 16FU-012           | 1               | 6247.00   | 0.00     | 0.00     | 1590.00  | 0.00     | 0.00     | 1407.00  | 0.00     | 0.00     | 973.00   | 0.00     | 0.00     | 2277.00  | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   |
    | 1618FU-012     | 16FU-012           | 1               | 1590.00   | ?        | ?        | ?        | 1590.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   |
    | 1618FU-012     | 16FU-012           | 1               | 6247.00   | 0.00     | 0.00     | 0.00     | 1590.00  | 0.00     | 1407.00  | 0.00     | 0.00     | 973.00   | 0.00     | 0.00     | 2277.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef | ProfileSubnominal     | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   |
    | 10017012 | 1618FU-012     | 16FU-012      | 2430670               | 0.00     | 0.00     | 0.00     | 1590.00  | 0.00     | 1407.00  | 0.00     | 0.00     | 973.00   | 0.00     | 0.00     | 2277.00  | 


    # Check CM Feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                 | DeliverableDescription   | 
    | 10017012 | 1618FU-012     | 1               | 16FU-012      | 1               | 0                     | 6247.00      | 0             | 0        | 16-18 Education at an Adolescent Forensic Unit  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '1618FU-012' agree with the most recent entry for this contract in the ContractManagement feed


    # Check ADP Feed

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202304 | 0.00         | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202305 | 0.00         | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202306 | 1590.00      | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202307 | 0.00         | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202308 | 0.00         | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202309 | 1407.00      | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202310 | 0.00         | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202311 | 0.00         | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202312 | 973.00       | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202401 | 0.00         | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202402 | 0.00         | 0             |
    | NewContractAllocationApproved     | 1618FU-012         | 1             | 16FU-012         | 1               | 202403 | 2277.00      | 0             |



    

    # Payment Batch starts here for 16-18FU2324 (PoP)

    # Change the date
    Given the override date is '04/07/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '16-18FU2324' AccountingPaymentPeriod '202304' CensusEndDate '04/07/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | 16FU-012                 | 202307 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18FU2324                | 202307               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18FU2324                | 202307               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18FU2324' PaymentPeriod '202304' CensusEndDate '04/07/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A012.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18FU2324' PaymentPeriod '202304' CensusEndDate '04/07/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 16FU                   | 2023          | 04             | 04          | ?       | 16FU-012          | 1590.00         | PROFILE          | Forensic Unit           | 2023-07-18 | 2023-04-01   | 2024-03-31 | ?              | 10017012 | 2430670    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod '16-18FU2324' AccountingPaymentPeriod '202304' and CensusEndDate '04/07/2023'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                 |
    | Payment Requests for Funding Stream Period 16-18FU2324 for Payment Period 202304 have been generated as of Census End Date/Time 2023-07-04T22:00:00Z. |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | DFE   | 16FU      | 01/04/2023   | 31/03/2024 | 04/07/2023    | 18/07/2023 | 2023          | 04             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription  | AggregatedValue |
    | ORG0017012  | 10017012       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 16FU-012   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2430670    | PROFILE        | Forensic Unit          | 1590.00         |


    # Tidy Up
    Given the override date is reset

